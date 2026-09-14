# IndigoVision Control Center - installation, licensing, upgrade and firewall reference
Source: IndigoVision Control Center Installation Guide v61 (IU-SMS-MAN001-61, 18 Jun 2024), docs.avigilon.com bundle iv-control-center-install-guide (PDF), read 2026-09-14. Plus TOCs of the Site Database Server Admin Guide v12, License Server Admin Guide v10, Control Center Web Admin Guide v16, Operator's Guide v20, Compact NVR-AS 4000 User Guide v22.

## Suite components
- **Control Center front-end application** (Windows admin + operator UI; edit mode for the site database) and **Control Center Client** (same minus site-database edit mode). **Incident Player** plays exported incidents.
- **Site Database Server** (service, TCP 8135 default; MongoDB 8134 for failover replication) + **Site Database Files** (Windows file share: maps, audio). Segmented site databases for large/multi-admin sites. One failover Site Database Server allowed (read-only when failed over; Files dir must be synced by 3rd-party tooling).
- **NVR-AS** (Network Video Recorder / Alarm Server) - Windows software (needs third-party Windows NVR-AS connection license) or appliances Compact NVR-AS 4000 / Enterprise NVR-AS 4000 (Linux or Windows, no extra license), legacy NVR-AS 3000.
- **License Server** (TCP 8133; 45-day IndigoUltra trial on first install - 5 cameras + 1 Windows NVR-AS; 30-day rolling backup license on clients/NVRs; License Manager tool: "Request a new or updated IndigoVision license" → fingerprint file → IndigoVision Sales Orders with order acknowledgment number → "Apply a new or updated IndigoVision license"). Tiers IndigoLite / IndigoPro / IndigoUltra; license = tier + device connections + Windows NVR-AS connections.
- Extensions: **Video Stream Manager** (ONVIF/RTSP/Ultra 5K JPEG2000 proxies), **Camera Gateway** (native third-party camera drivers; ports 80, 25473, 554, 47002, 29170), **FrontLine Manager** (body-worn cameras; VideoManager web UI 9080, FrontLine interface 8132), **Control Center Web** (IIS application server 443 + Hyper-V media server 8888/5349/WebRTC 49152-65535 + Control Center Mobile app), **CyberVigilant** (network anomaly appliance), Bandwidth Manager (UDP 49600), IndigoVision VPN (OpenVPN UDP 1194), IndigoReports.
- Recommended architecture: one server hosting License Server + Site Database Server + Site Database Files (an NVR-AS 4000 is ideal); one NVR as primary NTP source, all workstations/NVRs/cameras NTP-synced; Distributed Network Architecture keeps sites recording locally on WAN failure.

## Install order (new site)
1 License Server → 2 Site Database Server → 3 NVR-AS → 4 Control Center front-end. Installer: mount CD image from IndigoVision partner site → `Installer.exe` → Install per component. Do not install the License Server on a PC with integration modules.
- Site Database Server Setup tool (Start > IndigoVision > Site Database Server Setup): Create a new site database (Site Database Files share path; local DB path; License Server IP; default permissions None/All; initial Control Center administrator (Windows account or password); Site Database Server Administrator credentials (needed for failover/restore); Network Binding IP:port + replication IP; TLS certificate (self-signed for test only); Camera HTTPS Configuration) · Use an existing site database · Upgrade from a Control Center 16 site database · Configure as a failover Site Database Server (primary address - use FQDN, username/password, local data path, binding, certificate). SMB encryption for central Files share: `Set-SmbShare -Name <share> -EncryptData 1`.
- Control Center Setup tool (Start > Programs > IndigoVision > Control Center Setup) re-points a workstation to a different Site Database Server.
- NVR-AS on Windows: prepare video library (local drive or UNC network share - IP or FQDN, never mapped drive or NetBIOS name); service "IndigoVision NVR-AS" Log On account needs read/write to the share; NVR-AS Administrator (Start > Programs > IndigoVision > NVR-AS > NVR-AS Administrator) > Video Library > Set; restart the service. Anti-virus exclusions required. High-availability cluster (iSCSI + Windows failover clustering) in Appendix E.
- Front-end: Windows 10/11 or Server 2016/2019 (recommended)/2022; optional Implicit Windows Authentication, audit logging (ODBC), partner branding, unattended install via installer properties; firewall exceptions.
- OS support (License Server / Site DB): Windows Server 2022/2019 (recommended)/2016, Windows 11, Windows 10 64-bit; disable NUMA in BIOS on multi-processor Site Database Server hosts; VMware ESXi / Hyper-V supported.

## Upgrades
- 17.0/earlier → 17.1+: 64-bit migration (reinstall 64-bit ODBC driver for audit logging: File > Audit Log Settings > Change…; recompile 32-bit plugins) and NVR-AS authentication (enable "allow unauthenticated access" on each NVR-AS - NVR-AS Administrator on Windows, Network Security web page on Linux appliances - upgrade all front-ends, then per NVR-AS disable unauthenticated access, set credentials, and set Device Access credentials in Control Center).
- 17.0+ → later: back up site database + NVR-AS config → upgrade License Server → Site Database Server → each NVR-AS → each front-end. License Server version should match all components; backup license lasts 30 days.
- 16 → 17+: copy the CC16 site database directory (never upgrade the live copy) → upgrade License Server → install Site Database Server choosing "Upgrade from a Control Center 16 site database" → NVR-AS → front-ends → delete old sites.vdc / users.vdc / tasks.vdc. 15 or earlier: upgrade one workstation + License Server to 16 first, make a small user + site change in each segment, then upgrade to 17.

## Troubleshooting (install guide)
- Trial expired / no trial after reinstall → buy full license (trial is one-time per machine).
- "Unable to contact the License Server" → License Server service running with valid license; TCP 8133 open both ends.
- SQL Server 2014 Express install fails → remove SQL Server 2014, 2008/2012 Native Client, Setup Support Files, VSS Writer, Browser, ScriptDom via Programs and Features, reinstall.
- Site database cannot be edited → share permission Full Control + NTFS Synchronize/Read/Write attributes/Delete/Change Permissions for the user.
- NVR-AS cluster: see Appendix E troubleshooting (role fails to start, inconsistent device details, no failover).

## Firewall ports (direction = who initiates)
| Component | Ports |
|---|---|
| License Server | TCP 8133 IN (clients, NVR-AS, CyberVigilant); UDP 49000 IN/OUT discovery |
| Site Database Server | TCP 8135 IN (default, configurable); TCP 8134 IN MongoDB (failover only) |
| NVR-AS | UDP 49300 IN/OUT control (mandatory); TCP 8133 OUT license; TCP 8130 IN/OUT NVR control; TCP 8131 IN Alarm Server; TCP 49299 IN playback; TCP 49400-49402/49420-49422 OUT TCP video; TCP 49410 OUT audio; TCP 49500-49509 OUT PTZ actions; TCP 80/443/554 OUT ONVIF/RTSP; UDP 12000-20001 IN best-effort unicast; UDP multicast video 49400/49402/49404/49420/49422/49424 IN, control 49401/49403/49405/49421/49423/49425 IN/OUT, audio 49410/49430, audio control 49411/49431; IGMP; UDP 49301 IN NVR events (CyberVigilant/SDK); UDP 49600 OUT bandwidth manager; TCP 25/587 OUT email |
| NVR-AS 4000 Linux appliance (Compact/Enterprise) | TCP 80/443 IN web config; TCP 22 IN SSH; UDP 123 OUT NTP; UDP/TCP 53 OUT DNS; TCP 1311 IN OMSA (Enterprise) |
| NVR-AS 3000 (legacy) | TCP 80, 23 telnet, 21 + 1024-4999 FTP archive, UDP 123, 514 syslog, 161 SNMP, 53 |
| FrontLine-capable NVR-AS | TCP 9080 IN VideoManager UI; TCP 8132 IN FrontLine interface |
| Control Center front-end | UDP 49300 OUT; TCP 8133 OUT; TCP 8130/8131 OUT; UDP 49303 IN NVR events; TCP 8132 OUT FrontLine; TCP 49299 OUT playback; TCP video/audio OUT as NVR; UDP 12000-20001 IN; multicast as above; TCP 49500-49509 OUT serial/PTZ; TCP 80/443 OUT config + ONVIF; TCP 554 OUT RTSP; TCP 21 + 1024-4999 OUT bulk upgrade FTP; UDP 3702 OUT WS-Discovery; TCP 80 OUT version check |
| IndigoVision 8000/9000/11000/Ultra 2K cameras & encoders | UDP 49300 IN; TCP 49500-49509 / 49510-49519 IN serial; TCP video 49400-49402/49420-49422 IN; TCP 49410 audio; multicast OUT; UDP 49600 OUT; TCP 80/443 IN web; 23 telnet; 22 SSH; 21 + 1024-4999 FTP upgrade; UDP 123 OUT; 53; 514; 161; UDP 50000 VBLTM; ONVIF firmware: TCP 8080 web services, TCP 554 RTSP, UDP 3702 |
| BX / GX range cameras | TCP 554 IN RTSP; multicast UDP 49400/49402/49412 + 49410 OUT; TCP 80/443 IN web; UDP 123; 161; TCP 25/587 email; 53; UDP 3702 |
| Ultra 5K cameras | TCP 8888 IN JPEG2000; TCP 554; TCP 80; UDP 3702 |
| 8000/9000 receivers | UDP 49300; TCP 49500-49509 OUT; TCP video OUT; multicast IN; TCP 49299 OUT playback; 80/23/21 admin |
| AP100/AP110 alarm panels | UDP 49300 IN; TCP 80/23/21 admin; UDP 123/514/161 |
| Bandwidth Manager | UDP 49600 IN |
| Camera Gateway | TCP 80 + 25473 IN config; TCP 554 IN/OUT; TCP 47002 IN control; TCP 29170 IN events; UDP 3702 |
| Video Stream Manager | TCP 8888 OUT JPEG2000; TCP 80/443 OUT ONVIF; TCP 12000-12999 IN web services per camera; TCP 10000-10999 IN RTSP per camera; TCP 554 OUT; UDP 3702 |
| Control Center Web app server | TCP 443 IN (configurable); TCP 8888 OUT media server; TCP 80 OUT ONVIF; TCP 8131 OUT alarm server; TCP 8135 OUT site DB |
| Control Center media server | TCP/UDP 5349 IN STUN/TURN; TCP 8888 IN; TCP 554 OUT; UDP 49152-65535 IN WebRTC |
| CyberVigilant | TCP 80/443/22 IN; UDP 123, 53, 514 OUT; TCP 445 OUT SMB; UDP 49301 OUT NVR events |
| VPN | UDP 1194 IN OpenVPN server |
Stream port map per transmitter: Encoder1 Stream1/2/3 → multicast video 49400/49402/49404 (control +1), TCP video 49400/49401/49402; Encoder2 → 49420/49422/49424 and TCP 49420/49421/49422; UDP unicast always 49300. Firewalls need TCP/UDP connection tracking, UDP timeout ≥30 s.

## NVR-AS 4000 appliance (Compact) web configuration pages
Home · Network (incl. redundancy/bonding) · Date & Time · Disk (format, protect) · NVR · Alarms · Status Monitoring · Network Security (authentication, allow unauthenticated access) · Email · Bandwidth Management · License (fingerprint / apply) · Firmware Upgrade · Diagnostics. Initial setup: DHCP, or monitor+keyboard, or serial port; configure License Server address; Edge Storage / NVR Footage Retrieval. 40 cameras record / 20 playback per Compact NVR-AS 4000; two LAN ports; reset switch on front; PS_ON remote power pins. Troubleshooting: NVR Alerts, recording-failure and network-failure alerts.

## Control Center front-end (Operator's Guide v20 map)
Explorer panels: Video explorer, Alarms explorer, Users explorer; Events panels; Maps; Alarm status bar; Monitors, Alerts, Storyboard, PTZ Control panels (dock/undock/auto-hide). Live: View Camera in Pane (double-click / drag / Live Video menu / right-click), salvos, sequences, guard tours, persistent connections, analog monitors, IndigoVision/Barco video walls, Pursuit Mode, CCTV keyboard numbering. Recordings: playback pane, change playback NVR, thumbnails, save/protect, incidents (Incident Player), motion search, audio search, bookmarks, data records. Alarms: escalation policy, acknowledge/authorize, isolate/restore detector, set/unset zone, reports. Admin (edit mode): users/groups, sites hierarchy (cameras, monitors, NVRs, Alarm Servers), detectors/zones, actions, maps, transmitter/receiver Configuration pages, CCTV numbering, IP Video Wall. Help: F1. Troubleshooting chapter covers alarms/relays, CCTV keyboards, live video (PTZ lock-out, jerky video, username overlay), motion search, passwords ("Which password should I use?"), recordings, salvos/sequences/guard tours, sites (red X device, all-segments mode), FrontLine, audit log DB error, license backup warning.
