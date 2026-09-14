# Unity Video System Setup User Guide 8.8 (bundle unity-video-system-setup-8-8)
Base: https://docs.avigilon.com/bundle/unity-video-system-setup-8-8/page/<path>

## Phases
Phase 1 Preparation (architecture, checklist, pre-deployment, licensing) → Phase 2 Network & hardware (IP strategy, recorders, devices, ports, verify) → Phase 3 Core software & hardening (install, AV exclusions, server network, certs, FIPS) → Phase 4 Site config (storage, merge, license, site view, connect cameras) → Phase 5 devices/analytics/users/notifications/cloud.

## Pre-deployment / checklist [system-management/presite-checklist.htm] [system-management/setup-checklist.htm]
- Camera-to-server map with Primary/Secondary/Tertiary; standards for ips, quality, retention. Device admin creds (else factory reset time).
- Monitor/mouse/keyboard for server; UPS for servers + switches with safe shutdown; switch ports + PoE budget; laptop with Camera Configuration Tool + PoE splitter.
- IP: static IP for server; private subnet for cameras (192.168.x.x / 10.x.x.x); NO default gateway on camera NIC; only corporate-facing server NIC has a gateway; /24 for <250 devices.
- Software: latest Software Manager (USB/network share); Microsoft Edge WebView2 required; Windows Administrator rights.
- Licensing: 1 channel license per device, same edition site-wide; Smart Plan per channel; failover licenses for secondary/tertiary; feature licenses (Face, LPR, POS).
- NTP on servers/appliances (AI NVR & ENVR get NTP via DHCP by default). Set date/time/unique hostname; change local admin password; create backup admin.
- Merge prerequisites: Enterprise license, identical versions, failover licenses, same NTP.
- Set largest volume as Primary Data Volume; volumes similar size.

## Network & IP strategy [system-management/network-setup.htm]
- One NIC for outbound video (to viewing stations/Internet) with the only default gateway; other NICs for camera subnets, each NIC unique subnet, one subnet per VLAN; static IP or DHCP reservation per NIC.
- Static setup trick: add temporary second IP 169.254.x.x/255.255.0.0 on camera NIC to discover Zeroconf cameras, connect them, then change camera IPs into server subnet, then remove temp IP.
- DHCP cameras: lease expiry renewal can interrupt video (looks like camera restart) — set lease Forever/long + reservations.
- Recorders: connect to camera+corporate networks, IP, new admin password, CA cert, unique hostname (Windows), UPS, NTP.
- Switch ports ≥1 Gbps per server NIC (100 Mbps ok for low outbound corporate NIC).

## PORTS [system-management/configure-ports.htm]
Client↔Server: 38880 TCP HTTPS (API/services, base port), 38881 TCP (API/media), 51000-55000 UDP RTP/RTCP (LAN streaming; if blocked 38881 used — but live goes black unless WAN (Secured)), 38883 UDP multicast 239.255.255.0 (server discovery, same broadcast domain), 38984 TCP (local client update), 38985 TCP (device management), 443 (Unity Cloud, usage analytics), 4433 TCP HTTPS to Flexera (online licensing; only during activation/upgrade), 4434 (Software Manager downloads from installers.avigilon.com CloudFront).
Server↔Server: 38882 UDP (synchrony/clustering), 38883 UDP multicast 239.255.255.238 WS-Discovery (site families), 38980 TCP Postgres replication, 38981 TCP Postgres DB, 38982 TCP HTTPS gossip, 38983 TCP MQTT (all four required 8.0+, needed after ACC→Unity upgrade). Base port change shifts 38881/38882; base RTP change shifts 51000-55000. Ports closed by default on hardened NVRs.
Server↔Devices: 38884 UDP NTP (Avigilon device time sync; else external NTP), 3702 UDP multicast 239.255.255.250 WS-Discovery (ONVIF discovery, LAN), ICMP ping (LAN mode health check), 80 TCP HTTP / 443 TCP HTTPS device control, 554 RTSP, 51000-54999 UDP media device→server, 161 SNMP, 59595 TCP Pelco SOAP driver.
Cloud/other: 1935 TCP RTMP (3rd-party video integrations via cloud), 8443 TCP HTTPS Web Endpoint REST API (Windows; ACC Mobile 3/browser), 443 Web Endpoint REST/Admin UI (appliance), 1900 UDP SSDP (appliance), 49152 TCP SSDP (Windows), 5353 UDP mDNS, 443 HTTPS/AMQP Unity Cloud + WebRTC signalling (Ably/PubNub), WebRTC UDP 49152-65535 (Windows) / 32768-60999 (appliance) for symmetric NAT/direct, 25 SMTP, Unity AI: 28831 TCP API, 28832 clustering, 28833 DB (multiple GenAI appliances).

## Install [system-management/install-unity-on-computers.htm]
- Requires Windows 10 1607 / Server 2016+. NVRs ship with AvigilonUnity-CustomBundle folder on desktop → run AvigilonUnitySetup.exe. Software Manager: Install or Upgrade Applications (online) or Create a Custom Bundle (air-gapped; don't alter bundle; launch AvigilonUnitySetup.exe inside bundle). Install Unity Client on every server (serves client updates). Analytics Add-on needed for Additional Search Options/Face Recognition; LPR Add-on for LPR. License within 30 days; configure storage after install.

## Antivirus exclusions [system-management/configure-endpoint.htm]
- Folders: AvigilonData (each primary/secondary data volume), AvigilonConfig (config volume; only one). Find volumes: Admin Tool > Settings > Storage. Never on C:/OS drive.
- Prefer certificate-based whitelisting of Avigilon signing cert; else process exclusions incl. C:\Program Files\Avigilon\Avigilon Unity Server\VmsAdminPanel.exe, VmsAdminPanelLauncher.exe, VmsDaemonService.exe; Avigilon Unity Web Endpoint\WebEndpointService.exe; Avigilon Unity Server\LPR6\LprDaemonApp.exe; Avigilon Unity Analytics Service\AnalyticsDaemonService.exe; Avigilon Unity Cloud Bridge\VmsCloudBridge.exe; Avigilon Unity Orchestrator Service\VmsOrchestratorService.exe; Avigilon Unity API Gateway\VmsApiGateway.exe; Avigilon Unity Core\VmsCore.exe; Avigilon Unity Core\bin\pgbouncer\pgbouncer.exe and bin\pgsql\bin\*.exe (postgres.exe, pg_ctl.exe, psql.exe …); Avigilon Unity Client\CefSharp.BrowserSubprocess.exe; Avigilon Unity Player / Virtual Matrix CefSharp; legacy Avigilon Control Center Server\VmsUpgraderApp.exe, Control Center Client\VmsClientApp.exe, Control Center Web Endpoint\node.exe, Control Center Gateway\VmsWebGateway.exe, Control Center Virtual Matrix\VmsVirtualMatrixApp.exe, Avigilon Player\VmsPlayerApp.exe, Avigilon Platform Monitor Service\AvigilonPlatformMonitorService.exe.
- Safelisting for Unity Cloud: see Unity Cloud User Guide "Safelisting Services".

# Unity Video System Upgrade Guide 8.8 (bundle unity-video-system-upgrade-8-8, HTML-UNITY-VIDEO-UPGRADE-H Rev 5 EN20260812)
Base: https://docs.avigilon.com/bundle/unity-video-system-upgrade-8-8/page/<path>
- Path: no direct upgrade from ACC 5/6 — ACC5 → ACC6 → ACC7 → Unity. Paid major upgrade: Smart Plans needed (Core free). Check: Site Setup > [site] > Licensing > Check Upgrade Eligibility. Smart Plans expiring after 2 Oct 2023 = free. 30-day grace. [system-management/upgrade-eligibility-options.htm]
- Unsupported in Unity (remove before upgrade): ES HD Recorder (VMA-RPO), ES Analytics Appliance (VMA-RPA), H4ES cameras (x.xC-H4A-xxG-B1). ACM must be 6.36+ for unification. Windows 10 1607+/Server 2016+ 64-bit (upgrade Win7/2012 OS first). Pre-checks: licenses, Site Health per server, all servers on ACC 7 (Site Setup > server shows version), backup .avs per server (not on the machine being upgraded), AD port 389 UDP open, AV exclusions, same time zone/NTP, integration versions at avigilon.com/integrations. [system-management/before-upgrading-servers.htm]
- Hardened OS/AI appliances: Docker uses 172.17.0.0/16 and 172.18.0.0/16 — avoid conflicts; change via debug WebUI (+ icon, IP/Base/Size), restart. [system-management/upgrade-troubleshoot.htm]
- Windows upgrade: Software Manager > Install or Upgrade Applications (only previously installed apps upgraded) > tabs > Install; then reactivate licenses. Rollback: retry with stable internet, use custom bundle, or reinstall ACC 7 (Software Manager > Uninstall Applications, reinstall ACC 7, restore backup, reactivate Activation IDs). [system-management/upgrade-to-avigilon-unity.htm]
- AI NVR / ENVR2 PLUS / AIA2 (Linux): download .fp package from Software Downloads (community login); ACC7 Client site tree > server > Management Interface > Upgrade Firmware pane > drop .fp > OK; reboots several times ("Web UI Communication Lost"). [system-management/upgrade-to-avigilon-unity-linux.htm]
- Post-upgrade: verify licenses, user logins incl. mobile, recorded video, rules/alarms/analytics, cameras online, camera firmware; open new ports (38980-38983 etc.); backup. [system-management/upgrade-post-upgrade-checks.htm]
- Cloud org upgrade to "full Unity experience" (Privilege Management): all sites ≥8.0.4; cloud > Support > Get the new Unity experience > Check version > Upgrade (primary admin only). Wait if using ACM Unification or partner System Health Monitoring. After upgrade non-primary users become Viewers with no site access until added to groups/policies. [web-client/sites/upgrade-acs-cloud-sites-to-unity.htm]
