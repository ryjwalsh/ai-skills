# Version matrix, requirements and sizing

Phase 2 sections D and K. Sources: [S13] build numbers, [S5] System Requirements Guide 5.14, [S6] System Requirements Guide 5.13, [S9] / [S10] / [S11] release notes, [S7] upgrade paths.

## Contents

1. Build numbers
2. Version types and lifecycle
3. Software support matrix (5.14)
4. Client workstation requirements
5. Camera decoding limits per client
6. Server requirements
7. Maximum cameras and readers per server type
8. Cloud Storage adjustments
9. Media Gateway, Web App and Mobile capacities
10. Unit Assistant batch limits
11. Additional sizing considerations
12. Virtualization design guidelines
13. AutoVu ALPR server requirements
14. Upgrade paths
15. What changed in 5.14.0.0
16. What changed in 5.14.0.1
17. Mission Control versions

## 1. Build numbers [S13]

Provide the build number when opening a support case. It is on the **About** page of client applications running on the Directory or an expansion server. **If a build number is not in these tables you are most likely running a hotfix.**

### 5.14

| Version | Type | Build number | Release date |
|---|---|---|---|
| 5.14.0.1 | Patch | 5.14.178.1082 | 2026/07/02 |
| 5.14.0.0 | Major | 5.14.178.8 | 2026/05/11 |

### 5.13

| Version | Type | Build number | Release date |
|---|---|---|---|
| 5.13.3.7 | Patch | 5.13.3132.7023 | 2026/06/15 |
| 5.13.3.6 | Patch | 5.13.3132.6019 | 2026/05/19 |
| 5.13.3.5 | Patch | 5.13.3132.5031 | 2026/05/04 |
| 5.13.3.4 | Patch | 5.13.3132.4010 | 2026/03/17 |
| 5.13.3.3 | Patch | 5.13.3132.3006 | 2026/02/26 |
| 5.13.3.2 | Patch | 5.13.3132.2066 | 2026/02/12 |
| 5.13.3.1 | Patch | 5.13.3132.1080 | 2025/12/11 |
| 5.13.3.0 | Minor | 5.13.3132.18 | 2025/11/03 |
| 5.13.2.3 | Patch | 5.13.2114.3005 | 2025/09/08 |
| 5.13.2.2 | Patch | 5.13.2114.2017 | 2025/08/19 |
| 5.13.2.1 | Patch | 5.13.2114.1073 | 2025/07/28 |
| 5.13.2.0 | Minor | 5.13.2114.23 | 2025/07/14 |
| 5.13.1.2 | Patch | 5.13.1120.2011 | 2025/05/26 |
| 5.13.1.1 | Patch | 5.13.1120.1073 | 2025/05/05 |
| 5.13.1.0 | Minor | 5.13.1120.34 | 2025/04/07 |
| 5.13.0.2 | Patch | 5.13.121.2010 | 2025/05/01 |
| 5.13.0.1 | Patch | 5.13.121.1077 | 2025/02/04 |
| 5.13.0.0 | Major | 5.13.121.36 | 2024/12/16 |

### 5.12 (most recent entries; the full table runs back to 5.12.0.0)

| Version | Type | Build number | Release date |
|---|---|---|---|
| 5.12.2.20 | Patch | 5.12.2181.20011 | 2026/06/22 |
| 5.12.2.19 | Patch | 5.12.2181.19016 | 2026/05/27 |
| 5.12.2.18 | Patch | 5.12.2181.18014 | 2026/05/04 |
| 5.12.2.17 | Patch | 5.12.2181.17020 | 2026/03/23 |
| 5.12.2.16 | Patch | 5.12.2181.16020 | 2026/02/25 |
| 5.12.2.15 | Patch | 5.12.2181.15028 | 2026/01/27 |
| 5.12.2.14 | Patch | 5.12.2181.14021 | 2025/12/17 |
| 5.12.2.13 | Patch | 5.12.2181.13021 | 2025/11/10 |
| 5.12.2.12 | Patch | 5.12.2181.12026 | 2025/10/09 |
| 5.12.2.0 | Minor | 5.12.2181.44 | 2024/09/24 |
| 5.12.1.0 | Minor | 5.12.1239.75 | 2024/05/01 |
| 5.12.0.0 | Major | 5.12.144.70 | 2023/12/06 |

### Reference points for older majors

| Version | Type | Build number | Release date |
|---|---|---|---|
| 5.11.3.29 | Patch | 5.11.3130.29010 | 2026/05/07 |
| 5.11.3.0 | Minor | 5.11.3130.13 | 2023/06/06 |
| 5.11.0.0 | Major | 5.11.143.4 | 2022/09/12 |
| 5.10.4.31 | Patch | 5.10.4111.31009 | 2026/03/02 |
| 5.10.4.0 | Minor | 5.10.4111.0 | 2022/04/19 |
| 5.10.0.0 | Major | 5.10.357.0 | 2021/02/27 |

Note: the published 5.11 table contains an obvious typo, listing `.11.3.1` instead of `5.11.3.1` (build `5.11.3130.1052`, 2023/06/12). [S13]

## 2. Version types and lifecycle [S7] [S13]

| Type | Meaning |
|---|---|
| **Major** | Version number with zeros in the third and fourth positions (X.Y.0.0). Adds features, behavioural changes, SDK capabilities, new device support and performance improvements. **Requires a license update.** Compatible with up to three previous major versions in backward compatibility mode. |
| **Minor** | Third digit changes (X.Y.Z.0). |
| **Patch** | Fourth digit changes (X.Y.Z.W). "A patch release ... might add new features, behavioural changes, support for new devices, and performance improvements." Silent-install options are supported for major and minor releases only, **not** patch releases - use the patch procedure instead. |
| **Hotfix** | Build not listed in the published tables; obtained from GTAC. |

In `5.X.Y.Z`, `X` is the major version. Role failover does not work until all servers assigned to a role run the same major version. Full lifecycle policy lives on the Genetec Portal **Product Lifecycle** page, which was **not retrieved** - end-of-life dates per version are therefore **not documented** here. One explicit EOL statement exists: **HID VertX and Edge controllers reached end of life in 2023**, remain supported throughout the 5.14 lifecycle, and should be replaced before upgrading to 5.15. [S9]

## 3. Software support matrix (5.14) [S5]

| Category | Supported software |
|---|---|
| Operating systems | Microsoft Windows 11 Pro/Enterprise; Microsoft Windows Server 2019; Microsoft Windows Server 2022; Microsoft Windows Server 2025 |
| Database engines | SQL Server 2017 Express/Standard/Enterprise; SQL Server 2019 Express/Standard/Enterprise; SQL Server 2022 Express/Standard/Enterprise; SQL Server 2025 Express/Standard/Enterprise |
| Browsers for Server Admin | Microsoft Edge, Chrome, Firefox, Safari |
| Browsers for Synergis Appliance Portal | Microsoft Edge, Chrome |
| Browsers for Genetec Web App | Microsoft Edge, Chrome, Firefox, Safari (desktop version) |
| Browser for Genetec Cloudrunner integration | Microsoft Edge |
| Virtualization (server) | VMware ESXi 7.x; VMware ESXi 8.x; Microsoft Hyper-V with Windows Server 2016/2019/2022/2025 |

Footnotes: only Standard, Enterprise and Datacenter editions of Windows Server are supported; **only 64-bit versions are supported**; Windows 11 Pro/Enterprise requires at least 4 GB of RAM for installation; on the minimum server profile SQL Server **Maximum server memory** must be limited to **512 MB**; **Windows Server 2022 and 2025 are incompatible with the minimum server profile**; keep browsers up to date. If you run antivirus on any machine using Security Center you must configure the required exceptions.

**Genetec Web App software requirements:** [S5]

| Operating system | Supported browsers |
|---|---|
| Windows 11 Professional and Enterprise | Microsoft Edge latest, Google Chrome latest, Mozilla Firefox latest |
| Windows Server 2019 / 2022 / 2025 Standard Edition | Microsoft Edge latest, Google Chrome latest, Mozilla Firefox latest |
| macOS | Apple Safari latest |

Web App does not fully support Safari for iOS or Chrome for Android - use Genetec Mobile on mobile devices. If Firefox does not show high-quality H.264 video, make sure `H.264/avc3` on the media source extension is enabled.

**Browser latency for H.264 in a single Web App tile:** Google Chrome **300 ms**; Mozilla Firefox **300 ms to 800 ms**. If Web App detects no H.264 support it falls back to a lower-quality MJPEG stream. [S5]

## 4. Client workstation requirements (5.14) [S5]

The recommended requirements refer to newer-generation hardware; **upgrading from 5.13 with older hardware does not impact performance when using the same feature set.**

| Profile | Characteristics |
|---|---|
| **Minimum** | Intel Core i3-8100 3.6 GHz (supports Intel Quick Sync Video); 8 GB RAM (DDR4); 64-bit OS (Windows 11); 128 GB SSD for OS and applications; Intel Ethernet Connection I219-LM (GbE 1000/1000 Mbps) NIC; 1920 x 1200 display resolution |
| **Recommended** | Intel Core Ultra 7 Processor 265K; 32 GB RAM (DDR5); 64-bit OS (Windows 11 Enterprise 25H2); 1 TB SSD; Intel Ethernet Connection I219-LM NIC; NVIDIA GeForce RTX 5060 Ti (16 GB) |
| **High-performance (video-intensive)** | Intel Xeon w5-2465X 3.10 GHz; 64 GB RAM (DDR5); 64-bit OS (Windows 11 Enterprise 25H2); 240 GB SATA SSD or better with at least 15 GB free to install a Security Center server; GbE NIC; dual NVIDIA GeForce RTX 5070 Ti (16 GB) |

## 5. Camera decoding limits per client (5.14) [S5]

Maximum camera streams per workstation profile, at 30 fps. Benchmarks were obtained with two 4K UHD monitors.

| | Full HD 1920x1080 H.264 | Full HD HEVC | Full HD AV1 | Ultra HD 3840x2160 H.264 | Ultra HD HEVC | Ultra HD AV1 |
|---|---|---|---|---|---|---|
| Average bit rate per camera (Mbps) | 4.8 | 3.2 | 3.1 | 19 | 13.4 | 12.7 |
| Minimum | 5 | 6 | 3 | 1 | 1 | 0 |
| Recommended | 64 | 64 | 56 | 19 | 18 | 16 |
| High-performance | 104 | 102 | 100 | 36 | 36 | 30 |

Recommended and high-performance figures are the maximum at full capacity (**85% CPU and GPU use**) in a **static** environment such as a video wall. Reduce the count for an active-operator scenario and when using features such as visual tracking and guard tours.

GPU notes: Intel Quick Sync Video can be used if the monitor is connected to the motherboard (laptops included); NVIDIA graphics cards are supported; two or more cards can drive different monitors, but at least one monitor must be connected to each card for decoding to occur on it; enabling hardware acceleration can add a slight decoding delay.

Overheads: video encryption can raise CPU by up to **40%** for CIF video, becoming negligible at HD and Ultra-HD. Video watermarks are rendered by the client, cutting the maximum simultaneous streams by about **10%** with hardware acceleration and up to **30%** without it; the impact grows with resolution.

## 6. Server requirements (5.14) [S5]

For Directory, Archiver, Access Manager and Media Gateway roles.

| Profile | Characteristics |
|---|---|
| **Minimum** | Intel Core i5-8500 3.0 GHz or better; 8 GB RAM or better; 64-bit OS; 80 GB hard drive for OS and applications with at least 15 GB free to install a server; 100/1000 Mbps Ethernet NIC; standard SVGA video card. **SQL Server Maximum server memory must be limited to 512 MB.** |
| **Recommended** | Intel Xeon E-2434 3.4 GHz or better; 16 GB RAM or better; 64-bit OS; 240 GB SATA SSD or better with at least 15 GB free; GbE NIC; standard SVGA video card |
| **High-performance** | 2 x Intel Xeon Silver 4416+ 2.0 GHz (40 cores total); 64 GB RAM or better; 64-bit OS; 240 GB SATA SSD or better with at least 15 GB free; 10 GbE NIC; standard SVGA video card. The intended throughput requires specific hardware and software configurations. |

**Dedicated archiving servers** (all specifications assume 5 Mbps streams; smaller bit rates reduce performance):

| Profile | Characteristics |
|---|---|
| Recommended, up to 300 Mbps | Intel Xeon Silver 4210 2.2 GHz or better; 16 GB RAM or better; 64-bit OS; 80 GB SATA II or better for OS, applications and a local Archiver database, with at least 15 GB free; GbE NIC; standard SVGA |
| Above 300 Mbps up to 500 Mbps | Same CPU/RAM, plus **dedicated video disks of at least 12 drives in RAID 5 or 6**; pre-event recording left at the default **4 seconds**; playback or archive transfer should not exceed **100 Mbps** |
| High-performance (video intensive) | Streamvault rackmount appliance. The Streamvault 2000, 4000 and 7000 Series start from **900 Mbps** total throughput up to **4,135 Mbps** |
| Media transcoding applications | Intel Core i7-9700K, Intel Xeon E-2186G or better with Intel Quick Sync Video support; 16 GB RAM or better; 64-bit OS; 80 GB SATA II or better; NVIDIA RTX A2000 |

Footnotes: all RAID specifications were derived with **one RAID rebuild** in progress - no rebuild increases maximum recording capability; exceeding the recommended playback volume reduces recording capability.

**Dedicated access control servers** (Access Manager role):

| Cardholders | Characteristics |
|---|---|
| Up to 250,000 | Intel Xeon E-2434 3.4 GHz; 16 GB RAM or better; 64-bit OS; SSD with at least 15 GB free; 1 GbE NIC |
| Up to 600,000 | Intel Xeon E-2436 2.9 GHz; 32 GB RAM or better; 64-bit OS; SSD with at least 15 GB free; 1 GbE NIC |

**To support 250,000-600,000 cardholders, both the Directory and Access Manager roles must be standalone**, each meeting at least the high-performance access control specification.

## 7. Maximum cameras and readers per server type (5.14) [S5]

| Server type | With Minimum profile | With Recommended profile |
|---|---|---|
| Directory and Archiver (video only) | 50 cameras or 50 Mbps | 100 cameras or 200 Mbps |
| Standalone Redirector (video only) | 50 cameras or 50 Mbps | 475 cameras or 475 Mbps |
| Directory and Access Manager (access control only) | Up to 100 HID Edge readers or 200 V2000 readers; up to 150 readers on HID V1000 units; up to 150 on Axis Powered by Genetec units; up to 150 on Synergis Cloud Link units; up to 400 on Cloud Link Roadrunner units; readers spread across 10 HID V1000/Synergis Cloud Link or 100 Axis Powered by Genetec/Cloud Link Roadrunner units; 10,000 cardholders | Up to 300 HID Edge readers or 600 V2000 readers; up to 1,000 readers on HID V1000 units; up to 1,024 on Axis Powered by Genetec units; up to 1,024 on Synergis Cloud Link units; up to 4,000 on Cloud Link Roadrunner units; readers spread across 100 HID V1000/Synergis Cloud Link or 1,000 Axis Powered by Genetec/Cloud Link Roadrunner units; 250,000 cardholders |
| Standalone Access Manager (access control only) | Up to 400 HID Edge readers or 800 V2000 readers; up to 400 readers on HID V1000 units; up to 400 on Axis Powered by Genetec units; up to 400 on Synergis Cloud Link units; up to 800 on Cloud Link Roadrunner units; readers spread across 20 HID V1000/Synergis Cloud Link or 200 Axis Powered by Genetec/Cloud Link Roadrunner units; 100,000 cardholders | Up to 700 HID Edge readers or 1,400 V2000 readers; up to 2,000 readers on HID V1000 units; up to 2,048 on Axis Powered by Genetec units; up to 2,048 on Synergis Cloud Link units; up to 4,000 on Cloud Link Roadrunner units; readers spread across 100 HID V1000/Synergis Cloud Link or 1,000 Axis Powered by Genetec/Cloud Link Roadrunner units; 250,000 cardholders |
| Directory, Archiver and Access Manager (unified) | 50 cameras or 50 Mbps; 64 readers across 5 HID V1000/Synergis Cloud Link units; 5,000 cardholders. **If the server uses minimum requirements, SQL Server must be on a separate machine.** | 100 cameras or 200 Mbps; 200 readers across 40 HID V1000/Synergis Cloud Link units; 40,000 cardholders |

**Fusion Stream Encryption impact on Archiver capacity** - the first certificate costs 30% and each additional certificate applied to all cameras costs a further 4%. For an Archiver that supports 300 cameras unencrypted:

| Certificates enabled | Supported cameras |
|---|---|
| 0 | 300 |
| 1 | 210 |
| 5 | 178 |
| 10 | 145 |
| 20 | 96 |

**Best practice: do not exceed 20 encryption certificates per Archiver.**

## 8. Cloud Storage adjustments [S5]

Because all archives are encrypted before upload, server capacity must be reduced:

| Specification | Directory and Archiver | Standalone Archiver |
|---|---|---|
| Minimum | 20 cameras or 40 Mbps | 50 cameras or 65 Mbps |
| Recommended | 30 cameras or 65 Mbps | 100 cameras or 200 Mbps |
| High-performance | Not applicable | See dedicated archiving servers |

**Network requirements for Cloud Storage:**

| Item | Requirement |
|---|---|
| Connection type | Internet |
| Uplink throughput to the cloud | **At least 30% higher than video recording throughput** |
| Network availability | Minimum 99.9% guaranteed (SLA) by the ISP |
| Network latency | Less than **150 milliseconds** with one Azure data centre |

Worked examples from the guide: one Archiver recording 100 Mbps needs at least 130 Mbps guaranteed uplink; two Archivers recording 100 Mbps each need at least 260 Mbps. Cloud Storage uploads over HTTPS as fast as the uplink allows; contact Genetec if you need more than 1 Gbps per system.

## 9. Media Gateway, Web App and Mobile capacities [S5]

**Media Gateway** - see `api-integration.md` section 5 for the full stream table, the ~500-connection hard limit and the "do not co-host with an Archiver" caution.

**Web App streaming** uses the same performance table as the Media Gateway (127-170 streams Full HD H.264, up to 198 HEVC, 50-129 Ultra HD depending on codec and profile). The Web App Server sends the stream that best fits the tile size.

**Web App user connections:**

| Server type | Maximum Web App client connections |
|---|---|
| Recommended | 300 |
| High-performance | 400 |

A "user connection" is any account logon - 50 users on the same account count as 50 connections. Report generation, cardholder management and alarm acknowledgement are light; monitoring video and receiving ALPR reads are heavy. **Video bandwidth is more critical than the number of users when sizing.** To increase capacity: deploy high-performance hardware, reduce camera video quality, or add web servers.

**Genetec Mobile MJPEG transcoding capacities**, with the server hosting both Mobile Server and Media Gateway and CPU held at 75-80%, source streams H.264 at 15 FPS:

Recommended server profile:

| Source | Requested | Max streams | Outbound traffic | Per stream |
|---|---|---|---|---|
| 320x240 (0.2 Mbps) | 320x240 | 75 | 63.0 Mbps | 0.84 Mbps |
| 640x480 (0.5 Mbps) | 640x480 | 60 | 60.0 Mbps | 1.00 Mbps |
| 1280x720 (1.0 Mbps) | 1280x720 | 40 | 45.8 Mbps | 1.15 Mbps |
| 640x480 (0.5 Mbps) | 320x240 | 50 | 52.6 Mbps | 1.05 Mbps |
| 1280x720 (1.0 Mbps) | 320x240 | 40 | 40.4 Mbps | 1.01 Mbps |
| 1280x720 (1.0 Mbps) | 640x480 | 40 | 40.6 Mbps | 1.02 Mbps |
| 1920x1080 (3.0 Mbps) | 320x240 | 20 | 22.0 Mbps | 1.10 Mbps |

High-performance server profile:

| Source | Requested | Max streams | Outbound traffic | Per stream |
|---|---|---|---|---|
| 320x240 (0.2 Mbps) | 320x240 | 160 | 158.0 Mbps | 0.98 Mbps |
| 640x480 (0.5 Mbps) | 640x480 | 110 | 139.0 Mbps | 1.26 Mbps |
| 1280x720 (1.0 Mbps) | 1280x720 | 70 | 145.0 Mbps | 2.07 Mbps |
| 640x480 (0.5 Mbps) | 320x240 | 90 | 161.4 Mbps | 1.79 Mbps |
| 1280x720 (1.0 Mbps) | 320x240 | 80 | 60.0 Mbps | 0.75 Mbps |
| 1280x720 (1.0 Mbps) | 640x480 | 80 | 70.0 Mbps | 0.87 Mbps |
| 1920x1080 (3.0 Mbps) | 320x240 | 40 | 18.0 Mbps | 0.45 Mbps |

Mobile Server video settings are configured in Config Tool at **System task > Roles view > Mobile Server > Properties > Video > Video settings**, with separate settings for Wi-Fi and cellular; Mobile Server always uses the wireless connection when available. The Mobile Server sends the stream closest to the one requested by the app, minimising Media Gateway transcoding.

## 10. Unit Assistant batch limits (5.14) [S5]

Operations such as password changes and certificate updates require the unit to reconnect - schedule them outside critical periods, and monitor server CPU if normal usage is already high.

| Server type | Recommended | High-performance |
|---|---|---|
| Directory and UAR - passwords | Batch of 10,000 units; CPU usage increased over 80% during the operation; no impact on the system | Batch of 10,000 units; low CPU increase; no impact |
| Directory and UAR - certificates | Not tested; expected to be similar to high-performance servers | Video: batch of 1,000 units. Access control: batch of 100 units. Low CPU increase; no impact |
| Archiver and UAR agents | Same as the maximum number of units recommended for Archivers | Same as the maximum number of units recommended for Archivers |

## 11. Additional sizing considerations (5.14) [S5]

- When video streaming is not multicast from the camera, the maximum throughput calculation must include camera streams redirected by the Archiver.
- **Software motion detection can reduce maximum capacity by as much as 50%** - use hardware (unit) motion detection for maximum capacity.
- Systems with more than **300 cameras**, **1,000 readers** or **300 HID Edge readers** must isolate the Directory on a dedicated server.
- A more powerful server than the recommended specification does not necessarily increase maximum capacity.
- **A virtual machine with the same specifications as its physical counterpart has 20% less capacity.**
- Assign a dedicated NIC per Archiver role or Access Manager role instance when using virtualization.
- VMware ESXi must be installed on a clean computer with no operating system installed.
- **The Genetec Server service cannot be installed on the same machine as the domain controller.**
- Security Center is **not a life safety platform**; comply with applicable laws, regulations and industry codes if integrating life safety components, and consult life safety compliance professionals.
- For configuration advice, Genetec directs customers to Sales Engineering at `salesengineering@genetec.com`; for Streamvault model selection, `sales@genetec.com` or 1-866-684-8006 (option 2).

## 12. Virtualization design guidelines [S5]

Performance loss from virtualization is **typically under 20%** but varies with hardware and hypervisor configuration. Contact your Systems Engineer if your system does not follow these guidelines. The guidelines also account for modular infrastructure where several server modules share a chassis, network interfaces, power supplies and cooling, so contention or a component failure can affect many servers at once.

**Provisioning - VMs**

- Do not exceed **six VMs per server module**, with a maximum of **four video-intensive VMs** per module. Video-intensive means running the Archiver, Auxiliary Archiver or Media Gateway role.
- Install Security Center on a **dedicated server module**; do not share a module running Genetec VMs with non-Genetec VMs.
- Monitor for CPU scheduling delays. **Keep CPU wait time (CPU Ready) at or below 50 ms (or 5%)** to avoid performance degradation.

**Virtual CPU**

- Assign only complete logical cores from the same physical CPU. **Never split hyperthreaded vCPUs between VMs** by giving vCPU core 0 to one VM and core 1 to another.
- Fault-tolerant VMs typically **do not support transferring more than four vCPUs** even if more are assigned - assign 8 vCPUs to a fault-tolerant VM and only 4 transfer during a failure.
- If not running fault-tolerant VMs, assign **8 or more vCPUs per VM**.

**Memory**

- Assign at least **16 GB of RAM to each VM**.
- Keep **16 GB unallocated for the hypervisor**.
- Total memory allocated to VMs plus hypervisor must not exceed the module's physical memory.

**Storage**

- Install Windows and SQL databases on a dedicated high-performance drive (SSD, or a SAN with SSD or hybrid storage).
- **Do not use the OS drive for archived video.** Make the OS partition **at least 120 GB**.
- Configure Archiver video disks as a data store (VMDK, VHD or SMB share), Raw Device Mapping for Fibre Channel, or in-guest iSCSI. Other configurations may degrade performance.

**Network**

- Do not rely on the link speed reported by Windows for virtual adapters - measure actual bandwidth.
- Send video traffic on a different VLAN or subnet than storage traffic.
- Preferred connectivity is **10 GbE or greater**. Where only 1 GbE is available, assign one dedicated 1 GbE connection per VM for video traffic.
- Some alternate network configurations send multicast traffic to all hosted VMs simultaneously, which can affect performance.

**High availability**

- Do not assign VMs on the same physical server as primary and secondary (failover) servers of the same role.
- Use dedicated chassis resources for Genetec VMs, and house failover server modules in a **second chassis** so a chassis failure cannot take the whole system out.

**VM operations**

- Take system snapshots only during scheduled maintenance - snapshots freeze I/O and can cause disconnections and packet loss.
- **Dynamic load balancing is not recommended**; a live VM migration freezes I/O with the same effect.

**Security Center specifics under virtualization**

- Archiver VMs on one server module: do not exceed **300 Mbps** incoming and outgoing video **per VM**, and **1,200 Mbps** incoming video plus outgoing playback **per server module**.
- **Use static MAC addresses when installing a Directory on a VM - changing the MAC invalidates the system license.**

## 13. AutoVu ALPR server requirements (5.14) [S5]

For a server hosting the ALPR Manager role, on a single server (distribute across servers for higher performance):

| Profile | Characteristics |
|---|---|
| **Minimum** | Intel Core i5-3550 equivalent or better; 8 GB RAM (minimum 4 GB dedicated to SQL Server); storage disk separated from the OS primary disk; 50 AutoVu camera units (fixed or mobile); SQL Server Express containing up to **6,000,000** ALPR events (reads and hits combined); maximum 5 simultaneous user connections. **SQL Server Maximum server memory must be limited to 512 MB.** |
| **AutoVu Recommended** | Intel Core i7-3820 equivalent or better; 16 GB RAM (minimum 6 GB dedicated to SQL Server); dedicated RAID5 storage with 4 enterprise-grade disks or better; 100 AutoVu camera units; SQL Server Standard containing up to **25,000,000** ALPR events; maximum 20 simultaneous user connections |
| **AutoVu High performance** | Intel Xeon E5-2620 v4 equivalent or better; 32 GB RAM (minimum 8 GB dedicated to SQL Server); dedicated RAID5 storage with at least 8 high-performance enterprise-grade disks; up to 300 AutoVu camera units; SQL Server Standard containing up to **80,000,000** ALPR events; maximum 80 simultaneous user connections |

Footnotes: 300 units **must be distributed across three ALPR Managers with a maximum of 100 AutoVu units per ALPR Manager**, and the total number of AutoVu units on all ALPR Managers connected to the same Archiver **cannot exceed 100**. A mobile AutoVu system can include up to **4 SharpZ3 camera units and up to 2 wheel imaging cameras**.

## 14. Upgrade paths [S7]

| Target | Direct from | Two-step from |
|---|---|---|
| 5.14.0.0 | 5.13.x.y, 5.12.x.y, 5.11.x.y | 5.10.x.y, 5.9.x.y, 5.8 GA and all SRs - via the latest 5.11 release |
| 5.7 and earlier | contact your Genetec representative | |

Backward compatibility rules, the per-role compatibility table, the GCS host/guest matrix and the full procedures are in `install-upgrade.md` sections 12-15.

## 15. What changed in 5.14.0.0 [S9]

**Platform**

- **Genetec Web App replaces Security Center Web Client** and becomes the exclusive web client; upgrading migrates Web Client to Web App automatically. Web App adds maps, a real-time access control **Watch list**, Mission Control incident monitoring, secure video evidence sharing to Genetec Clearance, **Work requests** trackable with Genetec Operations Center, and a Fleet monitoring plugin.
- **Microsoft Entra OAuth support** for SMTP authentication, replacing Basic authentication as Microsoft phases it out.
- **Custom privilege templates** creatable and editable in the User management task.
- **WebView2 enabled by default.**
- Two new threat-level privileges: **Set system-wide threat level** and **Reset system-wide minimum security clearance** (resets to the lowest level, 7, across all system areas; adds a **Reset** button next to the system entity in the Threat levels dialog).
- **Zone Manager event retention extended to 9,999 days.**
- Zone entities now show status, arming state and input status on monitoring tiles, and can be armed, disarmed, bypassed and un-bypassed there.
- Custom fields now support up to **4,000 characters** with text wrapping in the field.
- **Report Manager queues automated tasks** (maximum queue size 100) instead of running them simultaneously; hitting the limit raises a health event and a warning state.
- Security Center UI available in **Finnish** (Config Tool and Security Desk via the Language Tool; Server Admin from the language list; Web App requires version 26.1.0 or later; Genetec Mobile requires 26.1.0 or later).
- Reports can be emailed directly from the reporting task without scheduling.
- **Database Anonymization Tool** now ships with Security Center to strip PII from backups before sharing with support.
- Alerts for **time synchronization offset over 10 seconds** between the Directory server and failover or expansion servers.
- The Unit replacement tool can preserve a replaced camera's activity and audit trails via **Keep audit and activity trails**.
- Automation: threat levels configurable from the Automation task; a **Wait for event** step; time zone support for scheduled automations and tasks; two new Automation Manager health events.
- **Installer redesigned** - fewer screens, clearer navigation, an **Operations Summary** window, no failure when optional packages are missing, the ability to relaunch and add only missing components, and the new `FEATURESET` silent option.
- **SAMA is no longer installed by default** but remains available in `SC Packages`.
- Mission Control: related entities (cameras, inputs) shown for intrusion incidents in the Incident monitoring details pane.
- Intrusion: cameras linked to the input that triggered an alarm are now included in the alarm's associated entities.

**Video**

- **The media component now runs 64-bit**, improving decoding performance, Media Gateway and Web App performance, and adding full compatibility with NVIDIA RTX 50X series cards for hardware-accelerated decoding and rendering.
- Firmware upgrade privileges split into **Upgrade video units using the Genetec Update Service** (included in the Provisioning template; ensures only Genetec-certified firmware) and **Upgrade video units using user-provided hardware** (replaces the old **Upgrade video units** privilege, more restrictive, in no template). Users who held the old privilege receive both.
- **`ShowFederatedStreams` debug command** for federated stream statistics, via Server Admin or the Genetec PowerShell module.
- **Cloud Storage video file defaults:** 5 minutes and 100 MB caps that override the Archiver advanced **Video files** values.
- New visual tracking overlays: polygons, images and text objects.
- Video watermarking on live, playback and exported video individually or combined, with customizable text colour, outline colour, alignment, custom text up to 100 characters, and **Auto scale**.

**ALPR**

- **Patroller must connect through the secure service port TCP 18731** and be registered with authenticated credentials.
- **Sharp units can no longer use the legacy WCF connection - LPM protocol is mandatory.**
- The **Generated a hit** column in Reads reports now respects partition-based access rights.
- Support for Korean (Hangul) characters in plate reads.
- Predefined hotlist import schedules: **Never** (default), **Always** (every minute), **Every 30 minutes**.

**Access control**

- **End of life notice: native HID controller integration.** HID VertX and Edge reached end of life in 2023, remain supported through the 5.14 lifecycle, but HID no longer provides fixes or features - plan hardware replacement before upgrading to 5.15.
- PIN must be entered twice when creating or modifying a PIN credential.
- New **Apply cardholder group partition changes to child entities** setting (Access control task > General settings) controls whether child entities move with a cardholder group.
- MIFARE DESFire encoding and printing in one step with the **Evolis Primacy 2** printer plus a STid SSCPv2 reader module.
- Larger badge template print preview.
- New **View PINs** privilege under **View advanced credential info**, separating PIN visibility from credential codes.
- **Cardholder management**, **Visitor management** and **Credential management** tasks now each require both the task privilege **and** the corresponding **View properties** privilege.

## 16. What changed in 5.14.0.1 [S10]

A patch release. **No new known issues and no known limitations.** It resolves a long list of Access, All, ALPR and Video defects - enumerated in `error-codes.md` section 6. The most operationally significant fixes: corrupted Access Manager backups when **Compress backup file** was selected; a Media Router service memory leak that stopped live video; video being deleted per retention without being uploaded when cloud uploads failed; the Archiver failing to start after a Directory server restart; the Media Router being unable to reach its failover servers; the ALPR retention defect; and crashes for cameras with a `%` symbol in their name.

## 17. Mission Control versions [S15] [S16]

Retrieved deployment guides: **3.4.0.0** and **3.3.1.0**. Other versions exist as separate maps (3.3.3.0, 3.3.2.0, 3.3.0.0, 3.2.1.0, 3.2.0.0, 3.1.3.0). Mission Control 3.4.0.0 pairs with **Incident Document Service 25.11.0.2**; Document Service versions map to Mission Control as 1.6 to 3.2.1.x, 1.7 to 3.3.0.x and 1.8 to 3.3.1.x / 3.3.2.x / 3.3.3.x. Systems running 3.4.0.0 must meet or exceed the **recommended** Security Center server requirements. Upgrade paths are in `configuration.md` section 11.

Product compatibility between Mission Control and Security Center versions is published in a "Product compatibility for Mission Control" topic that was **not retrieved** - logged in `../known-gaps.md`.
