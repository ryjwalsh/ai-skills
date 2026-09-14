---
name: avigilon-unity
description: Tier 1/2/3 technician knowledge of the Avigilon Unity family - Unity Video 8.x (formerly ACC 7) Client, Server/Admin Tool, Software Manager, licensing, multi-server sites, failover, Active Directory, Unity Cloud, Web Endpoint, Unity Access (ACM) appliance, Mercury panels, Avigilon H4/H5/H6 camera web interface, Camera Configuration Tool (CCT), AI NVR / NVR6 / ENVR2X / HDVA appliances, ports, networking, hardening, OS recovery and analytics (LPR, Face, Appearance Search, Occupancy, Crowd, Visual Alerts, Halo, Z-Wave). Use this skill whenever anyone asks where a setting lives, how to configure/install/repair/upgrade/troubleshoot anything Avigilon Unity, ACC, ACM, Avigilon camera, NVR, HDVA, docs.avigilon.com, support.avigilon.com or avigilon.com/software-downloads - even if they just say "Avigilon" or "ACC" without naming Unity.
---

# Avigilon Unity (Unity Video 8.x / ACC 7, Unity Access / ACM, cameras, appliances)

Avigilon Unity is Motorola Solutions' on-premises security platform: **Unity Video** (the VMS, formerly Avigilon Control Center / ACC 7) with its Windows **Client**, **Server** + **Admin Tool**, **Software Manager**, **Web Endpoint**, **Virtual Matrix**, **Player** and **Mobile** apps; **Unity Access** (formerly Access Control Manager / ACM) appliance with HID Mercury panels; Avigilon **H4/H5/H6 cameras**; and Avigilon **recorders/appliances** (NVR6, NVR5, AI NVR 2/2X, AI Appliance, ENVR2/ENVR2X, HD Video Appliance). Unity Cloud (cloud.avigilon.com) adds remote viewing, site health and remote upgrades. [S1]

## Scope and freshness

Built from the Avigilon Documentation Center (docs.avigilon.com, Zoomin) captured **2026-09-14**, reading the full text of ~50 HTML guides for the current release train - Unity Video **8.8** (client, server, system setup, upgrade, software manager, multi-server, IPv6, privilege management, feature setup guides), Unity Access **7.22**, CCT **2.18**, the fixed/PTZ camera web interface guides, AI NVR 2 Premium Form D, ENVR2X, networking best practices, reference architecture, system hardening, Windows upgrade & recovery, Unity Cloud, Web Endpoint API and the Mercury hardware guide. Older ACC 7.14 guides exist for legacy sites (same navigation, "ACC" naming). [S1]-[S40]

Where a menu label may differ by version, say which version the breadcrumb was captured from (8.8 unless stated) and tell the technician to confirm on screen.

## Quick facts

| Item | Value | Src |
|---|---|---|
| Docs | `https://docs.avigilon.com/bundle/<bundle>/page/<topic>` - versioned bundles such as `unity-video-client-8-8`, `unity-access-admin-7-22`, `camera-configuration-tool-2-18`; unversioned names are index stubs | S1 |
| Downloads / licensing | avigilon.com/software-downloads (login), licensing.avigilon.com; offline activation via activate.avigilon.com | S6, S9 |
| Support | support.avigilon.com (Support Community: knowledge base, New Case, Trust & Status); phone +1.888.281.5182 | S2 |
| First login | Client: username `administrator`, blank password, forced change. Cameras made after Jan 2020: no default credentials, you create the admin (16-char max password rule on H5/H6) | S3, S15 |
| Base port | 38880 (HTTP/API) - shifting the base shifts 38881 (HTTPS media/API) and 38882 (UDP clustering); RTP base 51000 covers 51000-55000 | S5, S20 |
| Live video black but recorded works | UDP 51000-55000 blocked - set the site connection to **WAN (Secured)** in Client Settings > Site Networking (TCP 38881) | S3, S20 |
| Editions | Core / Standard / Enterprise (multi-server, failover, Appearance Search, Virtual Matrix). License IDs like UNITY8-ENT/STD/COR + Smart Plans | S3, S6 |
| Server config store | Admin Tool > Settings > Storage - AvigilonConfig (config volume) and AvigilonData (data volumes); both must be antivirus-excluded | S6, S19 |
| Reset lost admin password | Tech Support is required for the site password; on a single server you can delete `<ConfigVolume>\AvigilonConfig\Db\DirectoryShared\Users` with the server stopped (all users lost) | S6 |
| Docker subnets | 172.17.0.0/16 and 172.18.0.0/16 are reserved on Unity servers/appliances - never use them for cameras or clients | S17, S18 |
| Hardened appliances | Never re-image an AI NVR / ENVR (voids warranty); factory restore = hold `f` at BIOS bar (AI NVR) or Reset button 20 s (ENVR2X) | S22, S23 |

## Answer contract

Every "where is it / how do I get to it" answer gives a full breadcrumb starting from the application and menu, then the dialog, tab and field:

> To change a camera's IP address from the VMS, open the Unity Video Client, then **New Task > Site Setup > [camera] > Network**, choose **Use the following IP address**, fill IP / Subnet / Gateway and click **OK**. The same page in the camera web UI is **Network > Network settings**.

Rules:

- Name the surface first: **Client** (New Task menu, Client Settings), **Admin Tool** (server), **camera web UI**, **CCT**, **Server Management / Management Interface** (appliance WebUI), **Unity Access web app**, **Unity Cloud**.
- Use `[site]`, `[server]`, `[camera]`, `[door]`, `[panel]` placeholders for the item the technician picks in System Explorer.
- Go all the way to the field or checkbox. If the setting exists in two places (client-side vs site-side, camera web UI vs Client > Site Setup), give both and say which one wins.
- Include the port, service name, file path or registry key when the task is network/IT flavoured.
- Cite the bundle topic (`[bundle/page.htm]`) from the reference file so the technician can open the source.
- If the answer is not in the references, say so and point to the right guide in `references/techdocs-index.md` - never invent a menu path.

## Product map at a glance

| Surface | How to reach it | Main areas |
|---|---|---|
| Unity Video Client | Windows app; Site Login tab; **New Task** (⊕) menu | Live View, Recorded, Search (Appearance/Event/Motion/LPR/Face/Alarm/Bookmark), Export, Site Health, Site Setup, Client Settings (top-right profile menu) |
| Site Setup > [site] | New Task > Site Setup > site name | General, Site View Editor, Users and Groups, Alarms, Rules, Site Management, Site Update, Security, Email, Central Station, Avigilon Unity Cloud, ACM (Unity Access), Backup/Restore, Licensing, Recording Schedule, Recording and Bandwidth, Corporate Hierarchy, POS, External Notifications, Sync… |
| Site Setup > [server] | select server | General, Server Management (appliances), Server Analytics, Storage/Continuous Archive, Failover, License Plate Recognition, Site Health |
| Site Setup > [camera] | select device | General, Network, Image and Display, Compression and Image Rate, Recording (schedule/templates), Motion Detection, Video Analytics, Privacy Zones, Manual Recording, Digital Inputs/Outputs, Microphone/Speaker, PTZ, Analytic Events, Self-Learning, Certificates |
| Admin Tool (server) | Start > Avigilon > Unity Video Admin Tool | General (Start/Shut down, Reinstall, Backup), Settings tab: Storage, Network (ports, IPv6, HTTPS), Storage Management, Logs, License |
| Software Manager | AvigilonUnitySetup.exe | Install/Upgrade Applications, Create Custom Bundle, Camera/Appliance Firmware, Uninstall |
| Camera web UI | https://<camera IP> | Live Preview, General, Network (+SNMP/DSCP/Firewall/MQTT/SMTP/IP Filter/WebRTC/802.1x/Certificates/SSO), Image and Display, Compression and Image Rate, Streaming, Motion, Tamper, Analytics, Camera Automation, Extended Settings, Privacy Zones, Storage, Digital I/O, PTZ, Audio, Users, System, Device Logs, About |
| CCT | Windows app | tabs General, Network, Multicast, TLS, Image Settings, Admin Users, Analytics, All Settings, Connection Credentials, Firmware Update; task menu (export/import CSV, certificates, logs) |
| Appliance Server Management | Client > Site Setup > [server] > Server Management, or https://<appliance> | Dashboard, ACC/Unity Server panel, Device (General/Hostname/Password/Time/Certificates/Upgrade Firmware/Support), Network (NIC teams, Docker pools), Storage, Logs |
| Unity Access (ACM) | https://<appliance>/ | Monitor, Identities, Reports, Physical Access (Panels, Doors, Inputs/Outputs…), Roles, gear: Appliance, System Settings, External Systems, Collaboration, Users |
| Unity Cloud | cloud.avigilon.com | Views, System Health (Sites/Servers, Site Update), Users/Privilege Management, Licenses, Organization Management |

## Where to look

| If the question is about... | Open |
|---|---|
| Any Client menu path: login, live/recorded/search/export, Site Setup for devices, recording, analytics, rules/alarms, users/groups/AD/2FA, licensing, backup, Site Update, ACM link, Virtual Matrix, email, registry/FIPS/C2PA, Site Health, bug reports | `references/unity-video-client-navigation.md` |
| Fast keyword → breadcrumb lookup across every surface | `references/where-is-it-index.md` |
| Admin Tool (storage volumes, ports, certificates, reset admin password), Licensing Portal | `references/server-admin-tool-and-licensing.md` |
| Deployment checklist, IP strategy, full port table, install, antivirus exclusions, ACC 5→6→7→Unity upgrade paths, rollback | `references/system-setup-ports-upgrade.md` |
| NIC teaming, VLANs, Docker pools, bandwidth/latency targets, LAN vs WAN, segmentation, failover ratios | `references/networking-and-architecture.md` |
| Hardening: BitLocker, TPM, iDRAC, recovery USB, CA certificates, FIPS modes, 802.1x, disable discovery, device certificates, firewall extras | `references/system-hardening.md` |
| AI NVR 2 / ENVR2X Server Management WebUI, LEDs, factory restore, multi-server site rules/merge/remove, IPv6 migration | `references/appliances-multiserver-ipv6.md` |
| Dell NVR hardware faults, RAID, OMSA, DSET/TSR log collection | `references/troubleshooting-nvr-hardware.md` |
| Windows OS recovery/upgrade on Avigilon hardware; Unity Cloud connect, ports, safelist, remote support, cloud site update, troubleshooting | `references/os-recovery-and-unity-cloud.md` |
| Camera web interface pages (H5/H6 fixed) and PTZ extras | `references/camera-web-interface.md`, `references/ptz-mercury-webendpoint-mobile-misc.md` |
| CCT (bulk config, static IPs, certificates, firmware, CCT-Batch), Software Manager custom bundles and Site Update | `references/camera-configuration-tool-and-software-manager.md` |
| Unity Access appliance admin (Appliance tabs, replication, panels/subpanels, doors, APB, lockdown, card formats, debug logs), Mercury DIP switches/reset/LEDs | `references/unity-access-acm.md`, `references/ptz-mercury-webendpoint-mobile-misc.md` |
| ACC↔ACM Alarm Gateway / VidProxy (legacy integration) | `references/acc-acm-integration-gateway.md` |
| Media Gateway, Federated Auth (Azure/Okta), LPR, Face Recognition, Halo, Z-Wave, Visual Alerts, Occupancy, Crowd, Audio analytics | `references/feature-setup-guides.md` |
| Web Endpoint API config/logs, Analytics Service, Virtual Matrix, Mobile app, analytics sizing tables, release-note facts, USB Wi‑Fi adapter | `references/ptz-mercury-webendpoint-mobile-misc.md` |
| Which official guide to hand the technician | `references/techdocs-index.md` |
| Sources and capture dates | `sources.md` |
| What was not captured | `known-gaps.md` |

## High-frequency answers

| Question | Breadcrumb |
|---|---|
| Add / discover a camera | Client > New Task > Site Setup > Connect/Disconnect Devices > Find Device… (IP / range, device type, control port 443) > select > Connect… |
| Change camera IP from the VMS | Site Setup > [camera] > Network > Use the following IP address |
| Camera won't show live but records | Client Settings (top-right) > Site Networking > [site] > Connection Type = WAN (Secured); or open UDP 51000-55000 |
| Set recording schedule / retention | Site Setup > [camera] > Recording (templates) ; retention: Site Setup > [server] > Recording and Bandwidth (data aging) |
| Enable failover | Site Setup > [site] > Connect/Disconnect Devices > [device] > Edit… > Connection Type Secondary/Tertiary + License Priority 1-5 (Enterprise) |
| Activate / reactivate a license | Site Setup > [site] > License Management > Add License / Reactivate (offline: save .KEY, upload at activate.avigilon.com, load response) |
| Add Active Directory users | Site Setup > [site] > Users and Groups > External Directory > Active Directory > Edit (port 389 UDP to DC) > Add Group / Add User |
| Turn on 2FA / dual authorization | Site Setup > [site] > Users and Groups > [user] > Edit > Security ; group privileges in Groups tab |
| Change server ports | Admin Tool > Settings > Network > Base Port (HTTP 38880) / RTP base; appliance: Server panel > Service Ports / RTP Ports |
| Move storage / add volume | Admin Tool > Shut down > Settings > Storage > Add data volume… |
| Back up site settings | Site Setup > [site] > Backup > .avs (Restore > Custom Settings for device connections/views) |
| Update all servers remotely | Site Setup > [site] > Site Update > Upload SiteUpdate[ver].avrsu (built with Software Manager > Create a Custom Bundle) > Update |
| Push camera firmware | Software Manager custom bundle (Camera Firmware tab) via Site Update, or CCT > Firmware Update tab, or camera web UI > System > Firmware |
| Server analytics (Appearance Search, Face, LPR, VFD) on an appliance | Site Setup > [server] > Server Analytics > feature tab > tick cameras |
| Configure LPR lanes | Site Setup > [server] > License Plate Recognition > lane (button missing = LPR license not active) |
| Enable IPv6 on the server | Admin Tool > Settings > Network > Enable IPv6 > restart; camera: web UI Setup > Network > IPv6 Settings |
| Merge a server into a multi-server site | Site Setup > Site Management > drag server onto site > Yes > reactivate license (Enterprise, same version, one default gateway per server) |
| Connect site to Unity Cloud | cloud.avigilon.com Organization Management > Sites > Add site (code) → Client Site Setup > [site] > Avigilon Unity Cloud > enter code > Connect |
| Link Unity Access (ACM) doors to cameras | Site Setup > [site] > ACM > connect (ACM user with delegations) > Import Roles > Doors tab link cameras |
| Camera admin password / users | Camera web UI > Users > Add… (Administrator/Operator/User); bulk: CCT > Admin Users tab |
| Camera certificate / CSR | Camera web UI > Network > Certificates (Identity and Trust) > CSR; bulk: CCT > TLS tab > Download CSR / Upload Certificates |
| FIPS on camera | Client Site Setup > [camera] > Network > Encryption Mode; CCT TLS tab; camera Network > Encryption Engine |
| Appliance admin password lost | Factory restore only (AI NVR: hold `f` during BIOS bar; ENVR2X: Reset 20 s) - wipes config and video |
| Appliance NIC teaming | Server Management > Network > New Team > members + mode (Active Backup / LACP / ALB) |
| Site health / bug report | Client > New Task > Site Health (Download report); Site Setup > [server] > System Bug Report; appliance Logs panel; Cloud: System Health > Servers > Generate System Bug Report |
| Unity Access panel offline | Physical Access > Panels > [panel] > Status tab (Parameters/Tokens/Reset-Download/Firmware/Clock); check port 3001 & TLS; Mercury DIP S1 all OFF |
| Unity Access appliance backup / logs / SSL | gear > Appliance > Backups tab / Logs tab / SSL Certificate tab; software update on Appliance > Software Update |
| Add a Mercury panel to Unity Access | Physical Access > Panels > Add Panel > Vendor Mercury Security > Model > Save > Subpanels tab > Host tab (Installed + IP or IP Client Connection + MAC) |

## Working rules

- Facts trace to a source ID in `sources.md`; anything marked **[INFERRED - verify]** was not read in a captured guide.
- Breadcrumbs come from the 8.8 / 7.22 / 2.18 guides. ACC 7.14 sites use the same Client layout but say "ACC" and "ACC Server Admin Tool"; ACS is now Unity Cloud; ACM is now Unity Access.
- Never invent a path or port. If not in the references, name the guide (techdocs-index) and say the exact page was not captured.
- Prefer the least destructive fix first (restart service, reconnect device) and flag the destructive ones explicitly: Reinitialize storage, factory restore, deleting the Users DB folder, disconnecting a server from a site, hard resets.
- This skill is read-only knowledge: it explains where a human makes the change; it never tells an agent to change a production system on its own.
