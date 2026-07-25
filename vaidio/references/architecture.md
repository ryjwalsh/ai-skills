# Vaidio - Architecture

## 1. Product lines and components

| Component | Role | Notes | Source |
|---|---|---|---|
| Vaidio Core (Core Platform Software, CPS) | Main analytics server. Runs multiple analytic engines, camera management, search, alerts, statistics, user management, metadata storage | Delivered as a single Docker container named 'vaidio' (image family 'ainvr') on Ubuntu with NVIDIA GPU | S1 S15 |
| Admin Portal | Separate appliance-level web app on port 8000 for port configuration, time/NTP, network, upgrade and factory reset | Installed from the APT package admin-portal; only usable after Core install completes | S1 S4 |
| Vaidio Edge (Edge Platform Software, EPS) | Single-analytic-engine appliance on NVIDIA Jetson | One analytic engine per device. Engines: Intrusion Detection, LPR (with MMR), Object Tracking, Face Recognition, Container ID, Tunable Edge | S15 |
| Vaidio Command Center (CC) | Top-layer federation portal for multi-site monitoring, central search, node and license management | GPU not required. Supports 100+ nodes from 6.2.0 | S12 |
| Vaidio Data | Aggregates and visualises analytics metadata from multiple Core nodes; dashboards, insights, camera overview | Installs on a Core node or (recommended) a separate server | S10 |
| Vaidio Enterprise (VE) + Vaidio Manager | Kubernetes-based large-scale deployment: many Core pods in one cluster, centrally managed | One Vaidio Manager per VE cluster, on the K8s master node | S11 |
| Vaidio Cloud Microservices (VCM) | Orchestrates containers across master, worker and microservice nodes; AI inference and supporting microservices | Part of VE | S11 |
| Vaidio / VaidioCam mobile apps | Android and iOS clients for search, face search, alerts, live view; VaidioCam turns a phone into a stream | VaidioCam streams support FR and LPR only | S14 S4 |

## 2. Core process/service names and files

Vaidio Core does not expose individual Linux systemd services for the analytics stack; the whole application runs inside one Docker container managed through **container_tool**. [S1]

| Name | Type | Detail | Source |
|---|---|---|---|
| vaidio | Docker container | NAME="vaidio" in /etc/vaidio/vaidio.conf | S1 |
| ainvr | Docker image / internal app name | Visible in docker output after offline install; Java package namespace com.ironyun.ainvr.* appears in alert JSON | S5 S8 |
| container_tool | Shipped CLI wrapper | init, run, stop, start, remove, status, upgrade, prune, check_disk_space | S1 |
| preinstall | Shipped script | Installs GPU drivers; reboots the server on completion | S1 |
| admin-portal | APT package / web app on 8000 | Requires Python 3.11 as of 9.x; offline upgrades from 9.0.0-1 or older need a manual Python upgrade | S1 S2 |
| systemd-timesyncd.service | OS service | Required; its absence breaks the Admin Portal config read | S1 |
| docker (Docker Engine) | OS service | Default bridge subnet configurable via bip in /etc/docker/daemon.json | S1 |

## 3. Databases and storage

- Two logical data stores are mounted at install time: a **system volume** holding OS and the Vaidio database (SSD recommended) and a **data volume** holding Vaidio metadata (separate HDD recommended). An optional third volume holds Internal Video Recorder data. [S1]
- Default paths: SYSTEM_VOLUME="/opt/data/sys/vaidio", DATA_VOLUME="/mnt/data/vaidio", DATA_VOLUME_FOR_RECORDER="/mnt/data-rec/recorder". [S1]
- The specific DBMS is **not documented** in the retrieved guides. Vaidio Data has its own database and can optionally use database credentials distinct from Vaidio Core (Advanced > Database Setting), which implies a shared DB technology between the two products. [INFERRED - verify] [S10]
- Vaidio stores **metadata only**; it does not change or encrypt video. Recorded video stays on the source (NVR/VMS/USB/HDD) unless the licensed Internal Video Recorder is used. Metadata ages out on a rolling basis. [S22]
- Optional multi-tier cloud storage: **Amazon S3** and **Qumulo S3** (Access Key, Secret Key, region, bucket). [S4]

## 4. Dependency stack

| Dependency | Requirement | Source |
|---|---|---|
| OS | Ubuntu 22.04 for Core install; Ubuntu Server 22.04 for the offline USB image; Vaidio Data on 20.04 or 22.04; Command Center on Ubuntu 22.04 | S1 S5 S10 S12 |
| CPU | Must support avx, avx2 and sse4 SIMD instructions (Vaidio Data: AVX and SSE4) | S1 S10 |
| GPU | NVIDIA only, Turing / Ampere / Ada Lovelace / Hopper, INT8 precision. Vaidio 10.0 adds Blackwell and Grace Hopper support | S1 S16 |
| GPU driver | Minimum 535.183.06 | S1 |
| Container runtime | Docker Engine plus libnvidia-container1, libnvidia-container-tools, nvidia-container-toolkit-base, nvidia-container-toolkit, nvidia-container-runtime | S1 S2 |
| Python | Admin Portal requires Python 3.11 (jammy/focal/bionic tarballs supplied for offline upgrades) | S2 |
| APT extras | curl, ntpdate, ssh, net-tools; PPA ppa:deadsnakes/ppa; vendor repo ironyun-release.list | S1 S6 |
| Edge GPU | NVIDIA Jetson Xavier NX, Orin Nano, Orin NX, AGX Orin; JetPack 5.1.3 | S15 |

## 5. Vaidio Core server roles

Every Core server must be assigned a Role at System > Setting > Select Role. [S4]

| Role | Purpose | Source |
|---|---|---|
| Standalone | Default. Runs independently, handles all analytics, management and storage locally | S4 |
| Main | Central hub of a cluster. Manages cameras, users and configuration and can also run analytics. Max 1 per cluster | S4 |
| Remote | Connects to the Main server, processes streams, applies analytics, returns results. Max 15 per cluster | S4 S12 |
| Node | Used with Command Center. Runs independently; registers to CC with CC IP/Domain plus Access Key | S4 S12 |

Role capability matrix as published (X = available, O = not supported): [S4]

| Role | Video Page | Video Filters | Edit FR List | Edit LPR List | Indoor Map | Connect to Vaidio/VaidioCam apps | Connect to Command Center |
|---|---|---|---|---|---|---|---|
| Standalone | X | X | O | O | O | O | X |
| Main | O | O | O | O | O | O | X |
| Remote | X | X | X | X | X | X | X |
| Node | X | X | O | O | X | X | O |

Note: the published table marks several capabilities for Standalone and Main as not supported, which is counter-intuitive for a standalone deployment. Treat the matrix as transcribed and confirm with the vendor before designing around it. [INFERRED - verify] [S4]

## 6. Clustering vs Federation

| Aspect | Clustering (Core Main + Remote) | Federation (Command Center + Nodes) | Source |
|---|---|---|---|
| Purpose | Expand compute capacity at one site | Central management across multiple sites | S12 |
| Data flow | Edge -> Core (Remote) -> Core (Main) | Core and Edge -> CC | S12 |
| Scale | 1 Main + up to 15 Remote | 1 CC + 100+ nodes (6.2.0+); exact count depends on network traffic | S12 |
| Redundancy | Main required; its downtime stops communication. All nodes must run the same version | Nodes operate independently, no downtime if one is offline; includes license management and daily backups | S12 |
| GPU | Required | Not required for CC itself | S12 |

Rules: a node can operate in only one architecture at a time - a CC-federated node cannot also be a cluster Main or Remote. Remote Core nodes must be added to CC individually and cannot connect through the Main node. Each device can connect to only one CC. Keep all nodes and CC on the same version; federation nodes must be 6.1.0+ to connect to CC 6.1.0+ (9.2.0+ recommended). When a Remote joins a cluster its settings and camera configuration migrate to the Main server; a camera added to the wrong server must be deleted and re-added. [S12][S4]

## 7. Vaidio Enterprise (Kubernetes) topology

Flow: Video sources -> Gateway -> Vaidio Core pods (worker nodes) and VCM inference microservices -> Storage; Vaidio Manager on the master node provides administration. [S11]

- One Vaidio Manager per VE cluster, on-premises or cloud, running on a Kubernetes cluster hosted by the enterprise or a cloud provider (AWS EKS, GKE, OKE, AKS and similar). [S11]
- Within VE, 'Core' and 'Core pod' mean the same runtime instance. Multiple Core pods can share a worker node subject to resources. [S11]
- Persistent storage is **Ceph**, installed as an infrastructure prerequisite and expandable after deployment. [S11]
- Setup order: provision hardware from the appliance calculator -> install Ceph -> install and initialise Kubernetes and pod networking -> install Vaidio Manager on the master node -> create Cores and assign the license key. [S11]
- Manager subsystems: Pod Manager, Component Manager (Image / Model / Module / OEM), Account Manager, License Manager. [S11]
- Cores launched from Manager are functionally identical to standalone Core except that License Type is Kubernetes and license import/export are unavailable in the Core UI - licensing is handled in License Manager. [S11]
- Vaidio 10.0 replaces the traditional single-container architecture with a modular multi-container 'Unified Scalable Architecture'. [S16]

## 8. Edge (EPS) vs Core (CPS)

| Capability | Edge (EPS) | Core (CPS) | Source |
|---|---|---|---|
| Analytic engines | Single engine per device | Multiple engines | S15 |
| GPU | NVIDIA Jetson NX / AGX Orin | NVIDIA GTX, RTX, A40, A100, L4 | S15 |
| Object search / smart hashtags / VMS playback | Not available | Available | S15 |
| Trigger actions | Email, HTTP | Email, app notification, VMS notification, HTTP | S15 |
| Heatmap and statistics | Not available | Available | S15 |
| Camera health (blurry/moved/disconnected) | Not available | Available | S15 |
| LDAP | Not available | Available | S15 |
| Privacy protection blurring | Edge Intrusion and Tunable Edge only | Available | S15 |
| Mobile apps / third-party integration | Not available | Available | S15 |
| Internal video recording | For event replay | Full | S15 |
| Connect to Command Center | Yes | Yes | S15 |

Edge engines cannot be installed on the Core platform or vice versa, and an Edge engine may differ in features from its Core counterpart. EPS 5.4.0 and later do not include Video Search. [S15]

## 9. Deployment topologies for cameras and VMS

Three documented patterns: [S3]
1. Cameras stream RTSP to a Vaidio appliance which applies analytics and returns processed metadata / post-motion images to the VMS that records video and displays alerts.
2. VMS performs motion detection and recording; Vaidio applies analytics on a parallel RTSP stream.
3. AI cameras with on-board GPU run Vaidio preliminary analytics and send metadata to Vaidio Cloud for advanced analytics (low, image-only or metadata-only transmission).

Vaidio can be bought as an appliance (VSB models), as software for compliant servers, or run in the cloud; it also supports on-premises, edge, cloud and hybrid deployment. [S22][S16]
