# Where is it - keyword to breadcrumb index (Avigilon Unity)

Alphabetical lookup from a control, feature or symptom straight to its location. Surfaces: **Client** = Unity Video Client (New Task ⊕ menu; **CS** = top-right profile > Client Settings; **SS** = New Task > Site Setup), **Admin Tool** = Unity Video Admin Tool on the server, **Cam UI** = camera web interface, **CCT** = Camera Configuration Tool, **SM** = appliance Server Management / Management Interface WebUI, **UA** = Unity Access web app, **Cloud** = cloud.avigilon.com. `[bundle/page]` points to the source topic; see the reference file named in the last column for detail. Captured from Unity Video 8.8 / Unity Access 7.22 / CCT 2.18 guides on 2026-09-14.

| Term the user says | Go to | Ref |
|---|---|---|
| 2FA / two-factor authentication (TOTP) | SS > [site] > Users and Groups > Groups > Edit Group > Two-Factor Authentication Required; reset a user's key: Users > Edit User > Reset Two-Factor Key | client-navigation |
| 802.1x on a camera | Cam UI > Network > 802.1x > EAP Method PEAP / EAP-TLS > Save Config > Enable | camera-web-interface, system-hardening |
| Active Directory (enable, port 389 UDP) | SS > [site] > Users and Groups > External Directory tab > Active Directory > Edit > Use Avigilon Unity service account or domain creds | client-navigation |
| Active Directory groups/users import | SS > [site] > Users and Groups > Add Group / Add User > Locations… (other domain) | client-navigation |
| ACM / Unity Access - connect appliance to site | SS > [site] > Unity Access (ACM) icon > hostname/IP, port, creds > verify SHA-256 fingerprint > Trust | client-navigation |
| ACM roles import | SS > [site] > Users and Groups > External Directory > Avigilon Unity Access > Add Group | client-navigation |
| ACM doors in System Explorer | SS > [site] > [ACM appliance] > Cameras and Doors > Show Doors in Site View | client-navigation |
| ACM door-to-camera links | SS > [ACM appliance] > Door links > Create Link | client-navigation |
| ACM Alarm Gateway (legacy ACC↔ACM alarms) | Start > Avigilon > ACM to ACC Alarm Gateway > Configure Connections (ACM ports 443 + 6050) | acc-acm-integration-gateway |
| Admin password lost (Unity Video site) | Avigilon Tech Support; single server: stop server, delete `<ConfigVolume>\AvigilonConfig\Db\DirectoryShared\Users` | server-admin-tool |
| Admin password lost (appliance OS) | Factory restore only (AI NVR: hold `f` at BIOS; ENVR2X: Reset 20 s) | appliances-multiserver-ipv6 |
| Admin password lost (Unity Access) | See unity-access-acm (Support / console); appliance login = https://<ip>/ | unity-access-acm |
| Alarms - create | SS > [site] > Alarms > Add > trigger source > cameras > recipients > name/priority > Enable alarm | client-navigation |
| Alarms - review / acknowledge / purge | Client > New Task > View > Alarms (Active / Assigned to Me / Acknowledged) | client-navigation |
| Analytics scene mode / camera type / tamper | SS > [camera] > Settings (analytics) ; Cam UI > Analytics ; CCT > Analytics tab | client-navigation, camera-web-interface, cct |
| Analytic events (loitering, beam, direction…) | SS > [camera] > Analytic Events > Add > Activity, Object Types, ROI, Sensitivity, Threshold Time, Timeout | client-navigation |
| Analytics Service (server add-on) status / restart | Client > New Task > Site Health > General Information > Analytics Add-on ; services.msc > "Avigilon Unity Video Analytics Service" > Restart | ptz-mercury-webendpoint-mobile-misc |
| Antivirus exclusions | AvigilonData + AvigilonConfig folders (Admin Tool > Settings > Storage shows volumes) + process list | system-setup-ports-upgrade, system-hardening |
| Appearance Search enable | SS > [server] > Server Analytics > Appearance Search tab (Enterprise) | client-navigation |
| Appearance Search - disable face processing | SS > [site] > Identity and Privacy Settings > Appearance Search Privacy > Disable Face Processing | client-navigation |
| Appliance firmware (.fp) upgrade | SM > Device > Upgrade Firmware pane > drop .fp ; or Site Update / Cloud Site Update | appliances-multiserver-ipv6 |
| Appliance hostname / time zone / NTP | SM > Device > General > Hostname / Time (NTP DHCP / Manual / Off) | appliances-multiserver-ipv6 |
| Appliance IP address (static) | SM > Network > pane > IP tab > Automatic IP off > IP/Subnet/Gateway > Apply | appliances-multiserver-ipv6 |
| Appliance logs for Support | SM > Logs > Server Logs / System Logs tabs ; Device > Support (Device Logs, System Snapshot, SupportAssist) | appliances-multiserver-ipv6 |
| Appliance NAS archive (CIFS/NFS) | SM > Server panel > Network Storage Management > Enabled > Protocol > Network Path | appliances-multiserver-ipv6 |
| Appliance ports (service/RTP base) | SM > Server panel > Service Ports / RTP Ports > Base > Apply > restart | appliances-multiserver-ipv6 |
| Appliance storage / RAID / eject disk | SM > Storage > Virtual Disks / Physical Disks (Offline before pull; Rebuild after) | appliances-multiserver-ipv6 |
| Appliance web certificate / CSR | SM > Device > Certificates > Web Certificate tab > Certificate Signing Request / Upload | appliances-multiserver-ipv6 |
| Archive (on demand, AVK) | Client > New Task > Archive | client-navigation |
| Archive (continuous) | Admin Tool > Settings > Storage Management > Enable (NVR) or SS > [server] > Network Storage Management (appliance) → SS > [server] > Storage Management > Enable Continuous Archive | client-navigation |
| Audio - microphone / speaker | SS > [device] > Microphone / Speakers ; Client duplex: CS > Client Duplex Audio Setting | client-navigation |
| Audio analytics | Cam UI > Analytics / SS > [camera] > Audio analytics events; guide unity-video-audio-analytics-8-8 | feature-setup-guides |
| Auto login | CS > Automatically log in to sites (Windows Authentication / saved credentials) | client-navigation |
| Backup site settings (.avs) | SS > Backup Settings icon > server > encrypt > save | client-navigation |
| Backup - Unity Access appliance | UA > gear > Appliance > Backups tab | unity-access-acm |
| Bandwidth cap per client | CS > Maximum Incoming Client Bandwidth | client-navigation |
| Bandwidth / estimated record time | SS > [server] > Recording and Bandwidth | client-navigation |
| Base port (38880) change | Admin Tool > Settings > Network > Base Port ; appliance SM > Server > Service Ports | server-admin-tool, appliances |
| BitLocker on NVR | Windows: WinRM on > Server Manager > Add roles and features > BitLocker > Admin Tool Shut down > Manage BitLocker C: then D: (auto-unlock) > Admin Tool > Storage > Add data volume | system-hardening |
| Bug report (server) | SS > [server] > System Bug Report ; Cloud: System Health > Servers > Generate System Bug Report | client-navigation, os-recovery-and-unity-cloud |
| Camera add / discover / connect | SS > Connect/Disconnect Devices > Find Device… then Connect… | client-navigation |
| Camera credentials / users | Cam UI > Users > Add… (Administrator / Operator / User) ; bulk: CCT > Admin Users tab ; keep after revert: Users page > "Do not clear usernames or passwords on firmware revert" | camera-web-interface, cct, system-hardening |
| Camera default IP / first login | New H5/H6: DHCP then Zeroconf 169.254.x.x; no default credentials - create admin (Cam UI initial page; CCT "factory default no creds" icon) | camera-web-interface |
| Camera factory reset | Cam UI > System > Clear All Settings (option keep network) ; physical revert button 3 s (see model install guide) ; IPv6 sites: choose "Keep network settings" | camera-web-interface, appliances-multiserver-ipv6 |
| Camera firmware upgrade | Cam UI > System > Firmware ; CCT > Firmware Update tab ; Site Update custom bundle ; auto-offer toggle SS > [server] > General > Automatically update cameras | camera-web-interface, cct, client-navigation |
| Camera IP address (from VMS) | SS > [device] > Network > Use the following IP address | client-navigation |
| Camera IP address (web UI / CCT bulk) | Cam UI > Network > Network settings (DHCP off) ; CCT > Network tab > column header edit > Start IP Address range | camera-web-interface, cct |
| Camera mode (High Framerate / Full Feature / No Video Analytics) | SS > [camera] > General > Mode ; Cam UI > General > Camera Mode ; CCT > Image Settings > Camera Mode | client-navigation, camera-web-interface |
| Camera not discovered | Same subnet/VLAN as server NIC, WS-Discovery UDP 3702, control port 443, uninitialized creds; use Find Device by IP; ICMP blocked → WAN network type | client-navigation, system-setup-ports-upgrade |
| Camera replace (swap hardware, keep video/rules) | SS > Connect/Disconnect Devices > Discovered Devices > new camera > Replace > pick Not Present device | client-navigation |
| Camera templates (bulk settings) | SS > [site] > Camera Templates > Add camera template > Template assignment | client-navigation |
| Camera RTSP URI | Cam UI > Compression and Image Rate > RTSP Stream URI (rtsp://<ip>/defaultPrimary?streamType=u) | camera-web-interface |
| CCT - static IP range | CCT > Network tab > column header edit icon > Start IP Address + Subnet Mask + Default Gateway | cct |
| CCT - export/import settings | Task menu > Export Device Settings (CSV) / Import Device Settings | cct |
| CCT - CSR / certificates | TLS tab > Download CSR checkbox > Apply ; task menu > Upload Certificates ; TLS Certificate Subject column > Apply | cct |
| CCT - disable HTTP fallback | C:\Program Files (x86)\Motorola Solutions\Camera Configuration Tool\CCT_DisableHttp.reg | cct |
| CCT command line | CCT-Batch.exe -a <ip> -u -p -e/-i csv -d csr -c crt -l | cct |
| Central station (SIA/XML) | SS > [site] > External Notifications > Central Station Monitoring tab | client-navigation |
| Certificates - server (AccServerCert) | certlm.msc > Personal > Request New Certificate > Friendly Name AccServerCert/UnityServerCert > exportable key; restart Avigilon Unity Orchestrator Service; SS > [site] > Security > Require trusted server certificates ; CS > Security | system-hardening, appliances-multiserver-ipv6 |
| Certificates - device trust | Import CA into server Local Computer store > SS > [site] > Security > Require trusted device certificates (Device certificate report) | system-hardening |
| Certificates - Unity Access SSL | UA > gear > Appliance > SSL Certificate tab (CSR / upload) | unity-access-acm |
| Client language / theme | CS > Language ; CS > Display > theme | client-navigation |
| Client login method (local/cloud/Windows only) | Registry HKLM\SOFTWARE\Avigilon\Avigilon Control Center Client LoginControlPolicy 0-7 | client-navigation |
| Cloud (Unity Cloud) connect site | Cloud > Organization Management > Sites > Add site > code → SS > [site] > Avigilon Unity Cloud > code > Connect | os-recovery-and-unity-cloud |
| Cloud disconnect | SS > [site] > Avigilon Unity Cloud > Disconnect | os-recovery-and-unity-cloud |
| Cloud remote support access | Cloud > Support > Manage Avigilon Support Access > Accept / Terminate | os-recovery-and-unity-cloud |
| Cloud site update (remote upgrade) | Cloud > System Health > Sites > Details > Select version > Update > Download > Install (Advanced System Health) | os-recovery-and-unity-cloud |
| Cloud user invite expired | SS > Users and Groups > user > Edit > clear Connect > OK > re-tick Connect | os-recovery-and-unity-cloud |
| Compression / bitrate / image rate | SS > [camera] > Compression and Image Rate ; Cam UI > Compression and Image Rate ; CCT > Image Settings | client-navigation, camera-web-interface |
| Corporate hierarchy / ranks | SS > [site] > Users and Groups > Groups > Edit Group > rank icon | client-navigation |
| Crowd detection | Cam UI/CCT > Analytics > Crowd Detection > Configure ; rules per guide | cct, feature-setup-guides |
| Custom bundle / offline install | Software Manager > Create a Custom Bundle > Applications / Camera Firmware / Appliance Firmware > Download | cct (Software Manager section) |
| Data aging / retention | SS > [server] > Recording and Bandwidth > data aging ; min retention alert rule "Minimum retention not met on server" | client-navigation |
| Day/Night, IR LEDs, exposure, WDR | SS > [camera] > Image and Display ; Cam UI > Image and Display > Day/Night / Exposure | client-navigation, camera-web-interface |
| Dewarping (third-party fisheye) | SS > [camera] > Dewarping | client-navigation |
| Digital inputs / outputs | SS > [device] > Digital Inputs and Outputs ; Cam UI > Digital Inputs and Outputs | client-navigation, camera-web-interface |
| Discovery (server auto-discovery) disable | VmsDaemonConfig.cfg <DevClient> AvigilonDiscoveryEnable / OnvifDiscoveryEnable = 0 > reboot | system-hardening |
| Discovery (client site broadcast) disable | CS > Site Networking > Disable automatic site discovery | client-navigation |
| Docker IP pool (appliance / 8.6+) | SM > Network > Docker pane > + Base/Size > restart (avoid 172.17/16, 172.18/16) | networking-and-architecture, appliances |
| Door - Unity Access add/edit/modes | UA > Physical Access > Doors > Add Door / [door] > Parameters, Operations, Hardware tabs | unity-access-acm |
| Door held open / forced | UA > [door] > Operations tab (held-open times) ; events in Monitor | unity-access-acm |
| Dual authorization | SS > Users and Groups > Groups > Edit Group > Dual Authorization ; user: right-click site > Dual Authorization Log In | client-navigation |
| Email notifications / SMTP | SS > [site] > External Notifications > Email Server / Email Notifications tabs | client-navigation |
| Emergency privilege override | SS > Users and Groups > Groups > Add Group > Emergency Privilege Override; right-click site > Enable Emergency Override | client-navigation |
| Encryption engine (camera FIPS/TPM/CRYPTR) | SS > [device] > Network > Encryption Mode ; CCT > TLS tab > Encryption Mode ; Cam UI > Network > Encryption Engine | client-navigation, cct, camera-web-interface |
| Encrypt live video | CS > Security > Encrypt video from all sites ; or CS > Site Networking > site > WAN (Secured) | client-navigation |
| Export signing (C2PA) | Cert with Friendly Name MediaSigningCert ; CS > Security > Enable signing of MP4 and JPEG exports | client-navigation |
| Face recognition | SS > [server] > Server Analytics > Face Recognition tab ; watch lists per guide | client-navigation, feature-setup-guides |
| Failover connections | SS > Connect/Disconnect Devices > [device] > Edit… > Change on server > Connection Type Secondary/Tertiary > License Priority | client-navigation, appliances-multiserver-ipv6 |
| Federated authentication (Azure/Okta) | Unity Cloud org > Privilege Management ; guide unity-video-federated-authentication-8-8 | feature-setup-guides |
| FIPS 140-2 mode (server / client) | SS > [site] > Security > FIPS 140-2 Mode ; CS > Security > FIPS 140-2 Mode | system-hardening, client-navigation |
| Firewall / port list | see PORTS table (38880-38885, 38980-38985, 51000-55000, 3702, 443/80/554, 8443, 1935, 4433, 4434, WebRTC) | system-setup-ports-upgrade, system-hardening |
| Focus / zoom (remote) | SS > [camera] > Image and Display > Continuous/Manual Focus, Zoom ; Cam UI > Live Preview | client-navigation, camera-web-interface |
| Focus of Attention | Client > New Task > Focus of Attention | client-navigation |
| Halo 4 sensors | initialize sensor > SS > link Halo to site/cameras > events/rules (guide) | feature-setup-guides |
| Hardware rendering (GPU issues) | CS > Graphics > Enable Hardware Rendering | client-navigation |
| HDSM SmartCodec / Idle Scene | SS > [camera] > Compression and Image Rate > Enable HDSM SmartCodec / Idle Scene Mode | client-navigation |
| iDRAC password / reset | F2 > iDRAC Settings > User Configuration ; reset controller: hold front ID button 16 s | system-hardening, appliances |
| Identity Verification panel | image panel top-right icon > door | client-navigation |
| IPv6 - server | Admin Tool > Settings > Network > Enable IPv6 > restart | appliances-multiserver-ipv6 |
| IPv6 - camera | SS > [device] > Network > Enable IPv6 ; Cam UI > Network > IPv6 Settings | client-navigation, camera-web-interface |
| Joystick / keyboard | CS > Joystick ; keyboard shortcuts list | client-navigation |
| Kerberos (Windows creds fail) | VmsDaemonConfig.cfg RequireKerberos=1 + setspn -S ACC/<host> | client-navigation |
| Keyframe interval | Cam UI/CCT > Compression > Keyframe Interval | camera-web-interface, cct |
| License activate / reactivate / deactivate | SS > [site] > Licensing > Add License… / Reactivate Licenses… / Remove License… ; offline via activate.avigilon.com | client-navigation, server-admin-tool |
| License refresh / edition change / upgrade eligibility | SS > [site] > Licensing > Refresh Licenses / Select Edition / Check Upgrade Eligibility | client-navigation |
| Licensing Portal | licensing.avigilon.com (entitlements, activation IDs) | server-admin-tool |
| Live video black, recorded OK | CS > Site Networking > [site] > Connection Type WAN (Secured) (UDP 51000-55000 blocked) | client-navigation |
| Logical ID | SS > [device] > General > Logical ID ; show: CS > Display > Display Logical IDs | client-navigation |
| Logs - site logs | Client > New Task > Site Logs (90 days) | client-navigation |
| Logs - server (Windows) | Admin Tool > Settings > Logs ; System Bug Report | server-admin-tool |
| Logs - camera | Cam UI > Device Logs ; CCT > Device Logs > Write Logs to File | camera-web-interface, cct |
| Logs - Unity Access | UA > gear > Appliance > Logs tab ; debug logs per troubleshooting section | unity-access-acm |
| Log users out | Client > New Task > User Connections > Log Users Out | client-navigation |
| LPR (License Plate Recognition) | SS > [server] > License Plate Recognition > lanes ; watch lists ; LPR Performance Mode on appliance SM > Server panel | client-navigation, feature-setup-guides, appliances |
| Maps | Client > New Task > Maps (Preview) ; classic image maps via System Explorer | client-navigation |
| Media Gateway (RTSP proxy) | C:\Program Files\Avigilon\Avigilon Unity Media Gateway\config.json ; service Avigilon Unity Media Gateway Service | feature-setup-guides |
| Merge server into site / multi-server | SS > Site Management > drag server onto site > Yes > reactivate license | client-navigation, appliances-multiserver-ipv6 |
| Mobile app connect (Unity Video Mobile) | app > Connect to local site > IP + port 8443 (Windows) / 443 (appliance) ; requires Web Endpoint | ptz-mercury-webendpoint-mobile-misc |
| Motion detection (classified / pixel) | SS > [camera] > Motion Detection tabs ; Cam UI > Motion Detection | client-navigation, camera-web-interface |
| Multicast (camera) | SS > [device] > Network > Enable Multicast ; Cam UI > Compression > Multicast ; CCT > Multicast tab | client-navigation, camera-web-interface, cct |
| NIC teaming | Windows Server Manager NIC Teaming (Switch Independent, Active-Standby) ; appliance SM > Network > New Team | networking-and-architecture, appliances |
| NTP for cameras | Server built-in NTP UDP 38884 (Windows) / 123 (appliance) ; Cam UI > General > Time ; CCT > Network > NTP Server Mode | client-navigation, camera-web-interface, cct |
| Occupancy counting | Analytic Events (Objects in area with Occupancy Area) + rules ; Cloud dashboard | feature-setup-guides |
| ONVIF event subscription / health check | SS > [3rd-party device] > ONVIF Event Subscription ; Connect… > Advanced > Disable Onvif health check | client-navigation |
| OS recovery (Windows NVR) | onboard partition: Shift+Restart > Use another operating system > OS Recovery ; or bootable USB (F11/F12 one-time boot) | os-recovery-and-unity-cloud, system-hardening |
| Overlays (timestamp, name, watermark, analytics) | CS > Overlays ; Cam UI > Image and Display > Overlays | client-navigation, camera-web-interface |
| Panel (Mercury) add to Unity Access | UA > Physical Access > Panels > Add Panel > Mercury Security > Model > Save > Subpanels > Host tab | unity-access-acm, ptz-mercury-webendpoint-mobile-misc |
| Panel offline / reset / firmware | UA > Physical Access > Panels > [panel] > Status tab buttons (Parameters, Tokens, Reset/Download, Firmware, Clock, APB Reset) ; DIP S1 OFF ; port 3001 | unity-access-acm |
| Panel factory reset (Mercury LP) | S1 SW1+SW2 ON at power-up → flip one OFF within 10 s → LED2 flashes 60 s | ptz-mercury-webendpoint-mobile-misc |
| Panel static IP (Mercury) | SW2 ON > PC 192.168.0.100 > https://192.168.0.251 > SW1 ON (5 min) > admin/password > Network > Use Static IP > Apply Settings, Reboot > all OFF | ptz-mercury-webendpoint-mobile-misc |
| Password complexity (camera) | Cam UI > Users > Minimum Length / Uppercase / Number / Symbols | ptz-mercury-webendpoint-mobile-misc |
| Password strength / expiry (Unity users) | SS > Users and Groups > Groups > Edit Group > Min Password Strength ; Users > Edit > Password Expiry | client-navigation |
| POS transactions | SS > [server] > POS Transactions > Add ; overlay CS > Overlays > Text Inputs | client-navigation |
| Privacy zones / removable masks | SS > [camera] > Privacy Zones ; Cam UI > Privacy Zones ; lift privilege: Groups > View high-resolution images > Lift privacy masks | client-navigation, camera-web-interface |
| PTZ presets / tours / patterns / limits | Client PTZ Controls pane ; Cam UI > PTZ > Patterns / Scans / Tours / Positioning / Washer / Zones | client-navigation, ptz-mercury-webendpoint-mobile-misc |
| PTZ analog protocol (RS-485) | SS > [camera] > General > Enable PTZ controls > Protocol/Address/Baud | client-navigation |
| PTZ priority mode (network shaping) | Cam UI > Network > Priority mode | ptz-mercury-webendpoint-mobile-misc |
| Recording schedule / templates | SS > [server] > Recording Schedule > Templates > Default Week ; SS > [camera] > Recording | client-navigation |
| Recording profile / low bandwidth stream | SS > [camera] > Compression and Image Rate > Enable Low Bandwidth Stream > Recording Profile | client-navigation |
| Recovery from SD card (Profile G) | SS > [server] > Recovery Configuration ; Cam UI > Storage > ONVIF Profile G | client-navigation, camera-web-interface |
| Reboot camera | SS > [device] > General > Reboot Device… ; Cam UI > System > Reboot | client-navigation, camera-web-interface |
| Remove server from site | SS > Site Management > server > Disconnect from Site… (copy license keys first) | appliances-multiserver-ipv6 |
| Replication / failover (Unity Access) | UA > gear > Appliance > Replication tab (default Admin only; ports 443, LDAP, 6052) | unity-access-acm |
| Restore site settings | SS > Restore Settings icon > .avs > Restore site and server settings / server only / Use custom settings | client-navigation |
| Rules (event → action) | SS > [site] > Rules > Add > events > actions > conditions > schedule | client-navigation |
| Rules - web request (webhook) | Rules > Add > User Notification Actions > Send web request > Web Request Setup | client-navigation |
| SD card format / encryption / recording mode | Cam UI > Storage > Format / SD Card Encryption / Recording Mode | camera-web-interface |
| Self-learning / Teach by Example | SS > [camera] > Settings > Self Learning progress/Reset ; SS > [camera] > Teach By Example | client-navigation |
| Server Analytics (per appliance) | SS > [server] > Server Analytics > tabs | client-navigation, appliances |
| Server certificate (appliance web) | SM > Device > Certificates | appliances-multiserver-ipv6 |
| Server name / site name | SS > [server] > General ; Windows computer name becomes default site name | client-navigation, os-recovery |
| Server storage volumes / config volume | Admin Tool > Shut down > Settings > Storage > Add data volume… / Config Volume | server-admin-tool, os-recovery |
| Service account / run as Network Service | services.msc > Avigilon service > Log On > NT AUTHORITY\NetworkService | system-hardening |
| Site families / parent-child | SS > [site] > Manage Site > Connect to Parent Site ; restrict login: parent SS > General > Restrict login to only Global and Unranked users | client-navigation, appliances |
| Site Health | Client > New Task > Site Health ; Cloud > System Health | client-navigation |
| Site update (remote server upgrade) | SS > [site] > Site Update > Upload SiteUpdate[ver].avrsu > Update | cct (Software Manager), client-navigation |
| SNMP / DSCP / firewall / IP filter (camera) | Cam UI > Network > SNMP / DSCP / Firewall / IP Filter | camera-web-interface |
| SSO on camera | Cam UI > Network > Single Sign-On (SSO) | camera-web-interface |
| Standby / pause device | SS > Rules > action Pause device / Resume device | client-navigation |
| Streaming settings (WebRTC, secondary stream) | Cam UI > Streaming ; Network > WebRTC | camera-web-interface |
| System Explorer folders | SS > [site] > Site View Editor | client-navigation |
| Tamper detection off | SS > [camera] > Settings > clear Enable Tampering Detection ; Cam UI > Tamper Detection | client-navigation, camera-web-interface |
| Temperature thresholds (thermal ETD) | SS > [thermal camera] > Temperature Settings ; radiometric events CCT > Analytics > Thermal | client-navigation, cct |
| Trusted device certs report | SS > [site] > Security > Device certificate report | system-hardening |
| Unity Access appliance settings (ports, backups, logs, software update, SSL) | UA > gear > Appliance > tabs | unity-access-acm |
| Unity Access system settings / remote auth (LDAP/OIDC) | UA > gear > System Settings > General tab / External Domains tab (LDAP 636/389, OIDC) | unity-access-acm |
| Unity Access send events to Unity Video | UA > gear > External Systems > Avigilon tab | unity-access-acm |
| Unity Access anti-passback / priority situations / lockdown | UA > Physical Access > Doors/Areas (APB) ; Settings > Priority Situations ; panic button | unity-access-acm |
| Upgrade ACC 7 → Unity Video 8 | Software Manager ; Smart Plan license required (Core free); Unity Video System Upgrade Guide | system-setup-ports-upgrade, client-navigation |
| Upgrade ACC 5/6 → 7 | staged path ACC5 → 6 → 7 → Unity; unsupported hardware list | system-setup-ports-upgrade |
| USB ports (FIPS NVR) enable/disable | C:\Avigilon\3rdPartyInstallers\UsbPortConfigurationTool.exe ; BIOS Integrated Devices | system-hardening |
| Users - add / edit / disable | SS > [site] > Users and Groups > Users tab > Add User / Edit User (Disable user, Login Timeout, Member Of) | client-navigation |
| Usage data opt-out | SS > [site] > General > Send anonymous usage data ; CS > General | client-navigation |
| VidProxy (ACM pulls ACC video) | ACM > Settings > External Systems > Avigilon tab > Add New Avigilon Server port 8080 | acc-acm-integration-gateway |
| Video Analytics Mode (Classified/UMD/None) | SS > [device] > General > Video Analytics Mode ; CCT > Analytics > Video Analytics Mode | client-navigation, cct |
| Video intercom call | SS > Rules > Digital Input Activated > Monitoring Actions "Video intercom call" | client-navigation |
| Virtual Matrix | install on display PC > log in ; CS privilege "Manage virtual matrix monitors"; SS monitor Logical ID | client-navigation, ptz-mercury-webendpoint-mobile-misc |
| Visible Firearm Detection | SS > [server] > Server Analytics > Firearm Detection (site claimed to Unity Cloud US; license) | client-navigation |
| Visual Alerts (GenAI, AIA2X) | Site Setup > Visual Alerts (guide) | feature-setup-guides |
| WAN vs LAN device network type | SS > Connect/Disconnect Devices > [device] > Edit… > Network Type WAN (Secure) | client-navigation, system-hardening |
| Watermark (user name) | CS > Overlays > User Name Watermark ; registry EnforceUsernameOverlay=1 | client-navigation |
| Web Endpoint port / CORS / logs | %ProgramData%\Avigilon\WebEndpoint.config.yaml (publicRestInterface.port, enableCors) ; C:\ProgramData\Avigilon\WebEndpoint Logs | ptz-mercury-webendpoint-mobile-misc |
| Web pages in System Explorer | right-click site/folder > New Web Page… | client-navigation |
| Z-Wave sensors | via H6XP camera hub; guide unity-video-z-wave-iot-sensors-8-8 | feature-setup-guides |
