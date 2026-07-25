---
name: vaidio
description: Comprehensive knowledge of the Vaidio (formerly IronYun) AI Vision Platform - Vaidio Core, Admin Portal, Command Center, Vaidio Data, Vaidio Enterprise/Manager and Vaidio Edge - covering installation, licensing, ports, configuration, upgrades, operations, troubleshooting and HTTP alert-trigger integration. Use whenever the user mentions Vaidio, container_tool, ainvr, preinstall, profile_x86.bin, admin-portal, VSB appliances, or asks about installing, sizing, upgrading or diagnosing it.
---

# Vaidio AI Vision Platform

Vaidio is AI video-analytics software that layers object/face/plate/behaviour analytics onto existing ONVIF IP cameras and third-party VMS/NVRs. It runs as a Docker container on Ubuntu with NVIDIA GPUs, stores only metadata (not video, unless the Internal Video Recorder is licensed), and is administered entirely from a browser. [S1][S4][S22]

## Version coverage

> Knowledge current as of docs retrieved **2026-07-25**, covering **Vaidio 9.0 - 10.0**, with the deepest coverage of **Core 9.3.0** (installation, setup, support, HTTP triggers), **Command Center 9.2.0**, **Vaidio Data 9.2.0**, **Vaidio Enterprise 9.3.0** and **Tunable Edge 9.0.0**. Vaidio 10.0 (GA 2026-07-08) is covered only from the release announcement - no 10.0 admin guide was published at the docs root, and 10.0 changes the container model (single-container to modular multi-container Unified Scalable Architecture). **Verify any 10.0-specific or version-sensitive answer against current docs.** [S16][S23]

No DEPLOYED_VERSION was supplied for this build, so no conflict flags were raised. If you are told the deployed version, re-check every fact tagged with an applies-to version in references/version-matrix.md.

## Quick facts

| Item | Value | Source |
|---|---|---|
| Product family | Vaidio Core (CPS), Vaidio Edge (EPS), Command Center, Vaidio Data, Vaidio Enterprise + Vaidio Manager | S4 S11 S12 S15 |
| Host OS | Ubuntu 22.04 (Core install guide); FAQ also references 20.04 for patching; Vaidio Data supports 20.04 or 22.04 | S1 S22 S10 |
| Container name / tool | Docker container 'vaidio' (image family 'ainvr'), managed by the CLI wrapper **container_tool** | S1 S5 |
| APT packages | admin-portal=9.3.0-1, ainvr-docker-utilities=9.3.0-1 | S1 |
| Helper commands | container_tool, preinstall | S1 |
| Core admin URL | http://<vaidioip> (HTTP 80) / https (443); login page /login | S1 S5 |
| Admin Portal URL | http://<vaidioip>:8000 | S1 S4 |
| Vaidio Data URL | http://<VaidioData-IP>:7000 (HTTPS 7001) | S10 |
| Command Center node port | 7000 (device registration to CC) | S12 |
| Key config file | /etc/vaidio/vaidio.conf | S1 |
| App profile / bin | /etc/vaidio/profile_x86.bin (also referenced as profile.bin) | S1 |
| System volume | /opt/data/sys (Vaidio dir /opt/data/sys/vaidio) - SSD recommended | S1 |
| Metadata volume | /mnt/data (Vaidio dir /mnt/data/vaidio) - separate HDD recommended | S1 |
| Recorder volume | /mnt/data-rec (Vaidio dir /mnt/data-rec/recorder) | S1 |
| Upgrade status log | /opt/data/sys/vaidio/log/app/start_service.log | S1 |
| Installer failure logs | /var/log/ (offline USB installer) | S5 |
| Minimum NVIDIA driver | 535.183.06 (Turing / Ampere / Ada Lovelace / Hopper, INT8) | S1 S2 |
| Default credentials policy | Core UI and Admin Portal ship as **admin / admin888**; offline-image Ubuntu OS account **superuser / usersuper888**. Change on first login; 3 failed UI logins lock the account for 5 minutes. Never leave defaults in production. | S1 S5 S4 |
| Supported browsers | Chrome or Edge (Chrome recommended for Data/CC); 1920x1080, 100% scaling | S1 S10 S12 |
| Licensing | Perpetual per-analytic-channel license file (.key) issued against an exported .info file; mandatory 15% software + 5% hardware annual maintenance | S1 S4 S22 |
| Support portal | Gated: vaidio.myportallogin.com (register at vaidio.ai/support); email support@vaidio.ai | S1 |

## Where to look (decision table)

| If the question is about | Read |
|---|---|
| Components, server roles, clustering vs federation, Kubernetes/Enterprise topology, Edge vs Core | references/architecture.md |
| Ports, firewall/ufw rules, camera RTSP URLs, VMS ports, TLS/certificates, proxy | references/network-ports.md |
| Fresh install (online or USB offline), prerequisites, storage mounts, upgrade paths, backup/restore, rollback | references/install-upgrade.md |
| Config file keys, UI navigation paths, storage retention, SMTP, LDAP/SAML/OIDC SSO, MFA, security policy, camera/alert setup | references/configuration.md |
| Start/stop/restart, health checks, licensing workflow, log export, monitoring, maintenance jobs, data cleanup | references/operations.md |
| A symptom ('container will not start', 'no detections', 'Whoops error') | references/troubleshooting.md |
| A literal error string or message | references/error-codes.md |
| HTTP alert triggers and parameters, Vaidio Data API, API keys, VMS/NVR integration levels, messaging-app webhooks | references/api-integration.md |
| 'Which version added X', hardware/appliance models, sizing, compatibility, deprecations | references/version-matrix.md |
| Something the docs never covered | known-gaps.md (do not invent an answer) |
| Read-only health check script | scripts/healthcheck.sh |

## Answering rules for this skill

1. Preserve exact strings (paths, commands, ports, defaults) verbatim - they are transcribed from vendor PDFs.
2. Every reference section carries source IDs; cite them (see sources.md for the ID to URL map).
3. If a fact is not in these files, say so and point at known-gaps.md rather than guessing.
4. Anything marked [INFERRED - verify] is not directly stated in the docs.
5. container_tool remove, container_tool prune, Factory Reset and 'purge data' are destructive - always surface the data-loss consequence before recommending them.

## Top five troubleshooting flows (inline)

### 1. Container will not run or start ('Failed to run docker container')
1. Check the GPU driver: run **nvidia-smi**. Expect driver 535.183.06 or higher. [S1][S2]
2. If NVIDIA-SMI has failed because it couldn't communicate with the NVIDIA driver, confirm the card is present: **lshw -C display**. If absent, this is a hardware/seating problem. [S1]
3. If the card is present, purge and reinstall drivers, rebooting between steps: apt-get remove --purge of '^nvidia-.*', '^libnvidia-.*', '^cuda-.*', then **sudo apt autoremove -y**, reboot, **sudo apt install nvidia-driver-535**, reboot, **sudo preinstall**. [S1]
4. Still failing: check Secure Boot with **mokutil --sb-state** and disable it in BIOS/UEFI, then repeat step 3. [S1]
5. Note: changing GPU hardware while the container exists can break resume and can invalidate the Face Recognition license - remove the container (keeping data) before powering off to change hardware. [S1]
Full flow: references/troubleshooting.md

### 2. Package install fails: 'E: Unable to locate package ...' / 'gpg: no valid OpenPGP data found.'
1. Re-run the repository steps and confirm sudo was used on every curl command. [S1]
2. Verify curl is installed (**sudo apt install curl**) and that a DNS server is set in the netplan file. [S1]
3. Test reachability: **curl https://ironyun.github.io/Vaidio-APT/KEY.gpg** - it must return a public key block. Anything else means a network firewall or missing proxy. [S1]
Full flow: references/troubleshooting.md

### 3. Admin Portal shows 'No such file or directory' / config /etc/vaidio/vaidio.conf does not exist
1. Expected before Vaidio itself is installed - the Admin Portal only becomes usable after Core installation completes. [S1][S4]
2. If it persists after install, the time-sync service may be missing: **sudo systemctl status systemd-timesyncd.service**; if absent, **sudo apt install systemd-timesyncd** then **sudo systemctl enable systemd-timesyncd.service**. [S1]
Full flow: references/troubleshooting.md

### 4. Web UI redirects to /system/license with 'Whoops, looks like something went wrong.'
1. Cause per vendor: a GPU problem (loose, unplugged or failed card). [S3]
2. Shut the device down from the Admin Portal, power off, reseat the GPU card and cables. [S3]
3. Clear the site cookies, then retry. [S3]
Full flow: references/troubleshooting.md

### 5. Analytics produce no detections although the camera is connected
1. Confirm object pixel size is sufficient - Vaidio needs about 10 px on target (roughly 14 ppf for a person); recommended camera resolution is 2MP / 1920x1080. [S3]
2. Check camera shutter speed - defaults as slow as 1/5 s starve FR, LPR and weapon detection; raise it. [S3]
3. Enable Wide Dynamic Range for backlit or high-contrast scenes (garages, bright entrances). [S3]
4. Check the General ROI in Camera > Edit - objects outside it are never detected, and engine-specific ROIs must sit inside it. [S4]
5. Lower the object Confidence value in the camera Profile (range 0.01 - 1.00) and re-check Min/Max pixel limits. [S4]
6. Verify the object type is selected in the Profile - unselected object types cannot even be searched. [S4]
7. Verify the camera is time-synced to within 5 seconds of the server (NTP), or connect by RTSP instead of ONVIF, which needs no time sync. [S3]
Full flow: references/troubleshooting.md

## Before opening a vendor ticket

Collect, in this order [S1][S3][S4][S9][S11][S12]:
1. System > License > Export - the .info system information file.
2. System > Log > Diagnostic log > Export (.xlsx) and System log > Export (.xlsx).
3. System > Audit Trail > Export (.xlsx) if the issue involves user actions.
4. Upgrade problems: **sudo cat /opt/data/sys/vaidio/log/app/start_service.log**.
5. Offline USB install failures: everything under /var/log/ on the installed Ubuntu system.
6. Command Center or Vaidio Enterprise: use the Export Diagnostic Log button in the UI.
7. Server specs (GPU, CPU, RAM), Vaidio version, and whether the host is a VM (name the platform).
Upload to the Support Portal (gated) or email support@vaidio.ai.
