# Motorola Solutions Compass Decision Management System - install, maintenance, ports (v2.2.11.x)
Source: MSI Compass On-Prem Install and Maintenance Guide IU-AG-MAN002-7 (12 Dec 2024), https://www.avigilon.com/fs/documents/MSI-Compass-On-Prem-Install-Maintenance-Guide.pdf, extracted 2026-09-14.

## Components / services
COMPASS Server (Apache Tomcat, GWT RPC over HTTPS) · Compass Manager (watchdog) · Compass LicenseServer · Compass ServicesAdapter (JSON-RPC gateway/encryption) · Compass VideoAdapter (HTML5 video) · ElasticSearch + Kibana (alarm/event search & BI) · Compass Database (MariaDB) · Compass Heartbeat (multi-node failover) · integration **drivers** (one per manufacturer, e.g. IndigoVision Control Center, Avigilon ACC, Avigilon ACM, SNMP, PACOM) run as agents on ports 9100+ (two ports each), on the main server or a remote driver server. Windows services: COMPASSDB, COMPASSLicenseServer, COMPASSManager, COMPASSServicesAdapter, Apache Tomcat (COMPASSserver), elasticsearch-service-x64, Kibana.

## Requirements
Clean Windows Server 2019, static IP (static MAC on VMs), RDP on, .NET 3.5 feature, Chrome/Firefox, no pre-existing MySQL/MariaDB, external backup folder (share/USB), reserved ports free.

## Ports
80 / 443 COMPASS server (set at install) · 3306 DB (set at install) · 5601 Kibana · 8443 HTTPS services · 9000 streamer · 9050 manager · 9060 license manager · 9080 services adapter · 9100, 9102, 9104… agent drivers (set at install) · 9200 Elasticsearch · 8020 failover registerServer.

## Install (single server)
`COMPASS_v2.x.x.x_Setup.exe` as admin → Failover Setup (Server ID 1, Server Type Central/Failover) → Database and Plugin Setup (Initial Port for Plugins 9100, DB IP, DB port 3306) → Server Setup (IP, Port, Additional Server IP - real IP not 127.0.0.1) → Backup Setup (external folder, frequency) → EULA → destination → Components "COMPASS Base" → self-signed cert → Sentinel/Gemalto License Manager wizard → finish. Remote driver server: same installer, choose "Additional COMPASS Server instance", point DB/primary server IP + port 80, backup "Never", then enable drivers and set BACKEND_URL=https://<primary_ip> in agent.properties.
- First login: https://<compass IP> — Administrator / admin (forced change). System Manager: https://127.0.0.1/manager (Create DB, Shutdown server).
- Licensing: Windows menu > IndigoVision License Manager > "Request a new Motorola Solutions license" → fingerprint → Sales Orders with order number → "Apply a new or updated Motorola Solutions license" (.v2c) → restart COMPASSServer (`taskkill /fi "SERVICES eq COMPASSServer" /f`). 60-day trial: Compass_trial_60days.v2c from reseller, applied the same way (License Manager folder C:\Program Files (x86)\IndigoVision\LicenseManager).

## Maintenance
- Backup: `%COMPASS_PATH%\tools\backupDB\backupDatabase.bat` (admin) → backup-win[YYYYMMDD].sql zips; restore with `restoreDatabase.bat` + full path, restart. Also keep `%COMPASS_PATH%\tools` custom folders and `data` folder. Registry: HKLM\...\Environment COMPASS_PATH, AGORA_PATH, COMPASS_BACKUP_DIR.
- Upgrade: run new installer as admin (backs up app files to bck, up to 40 min) → Install → services stop → after upgrade update the database; primary: backend.properties failover flag true, central.conf host IP, restart; failover: failover-2.conf IPs, heartbeat.properties mode.central=false.
- Logs: `%COMPASS_PATH%\logs\` (client, drivers\driver_<port>, heartbeat, hibernate, licenseserver, manager, odfe, server\tomcat, server\gc, servicesadapter, streamers\streamer_<type>); daily/size rotation, 30-day retention; log levels in `%COMPASS_PATH%\conf\logconf` (TRACE…OFF, default INFO).
- Anti-virus exclusions: %COMPASS_PATH%, Backend\bin\tomcat7.exe, licenseserver\licenseserver.exe, runtime\x64\jre\bin\java.exe, odfe\elastic\jdk\bin\java.exe, odfe\kibana\node\node.exe, %COMPASS_PATH%\data.
- Certificates: tools\CertificateCreator → openssl pkcs12 -export -name tomcat … -out .keystore → copy to conf\ and odfe\elastic\config\; Install_ca.bat for CA.
- Multi-node failover: hostnames Compass-Primary / Compass-Second, AD forest compass.local, MariaDB primary-primary replication (CompassDBReplication setup.bat / dump.bat / registerServer.bat https://<ip>:8020), DFS replication group "Compass Replication" for the Data folder, enableHeartbeat.bat.
- Migration: stop services except CompassDB → backupDatabase.bat → copy tools + data → fresh install on target → restoreDatabase.bat → copy folders → reinstall drivers → restart.
- Uninstall: Add or remove programs > COMPASS_v2.2.x.x > Uninstall > Remove all files.

## Troubleshooting
| Symptom | Check |
|---|---|
| Driver Offline | agent.properties backend.url → primary server port 80; instance.conf SERVICES_ADAPTER_IP/PORT, STREAMER_IP/PORT, INSTANCEMANAGER_IP/PORT, SELF_IP, BACKEND_URL; hibernate.properties DB IP (bin\ and bin\classes\); Configuration menu Private/Public Host IPs not 127.0.0.1; re-register driver, restart agents/managers/services adapters |
| Services not running after install | anti-virus exclusions |
| Cannot reach login page | services running, URL, firewall 80/443, routing |
| DB update error after upgrade | restore backup DB, retry, then support |
| Video "No resources available" / "LIVE stream lost" | server overload / camera offline or network; cameras must be H.264 |

## IndigoVision Control Center driver (Integration guide v1.7.1)
Ports: TCP 445 SMB to SiteDB (CC v16), TCP 8135 SiteDB (CC v17), TCP 8131 Alarm Server, UDP 49300 relay status, TCP 49299 NVR playback. CC v17.0.2+: Start > IndigoVision > Site Database Server Setup > Generate a service authentication token; import self-signed cert into Compass Trusted Root. Install `Setup-driver-indigovision-controlcenter-<ver>_Setup.exe` (Instance Manager IP) → Compass Global Devices Menu > new device Brand IndigoVision / Model Control Center → Connection Data (v17: SiteDB IP, port, token, username/password, test period) → Site mapping (New → existing or "Create new site", name must match Control Center site exactly; Static/Mobile; auto-ack options) → logical devices auto-created (detectors, panel acknowledge, cameras, alarm detectors, multifunctional). Alarms map to ACCESSPOINT_ALARM / ALARMDETECTOR_*; system alarms COMMAND_CONNECTION_FAILED, SYSTEM_NOT_READY_TO_ACKNOWLEDGE. NTP sync everywhere; ONVIF cameras, PTZ commands, digital I/O unsupported via this driver. Other drivers: Avigilon Control Center (Integration-Avigilon-ControlCenter-v1.8.0-2024-02-08.pdf), Avigilon ACM, SNMP (Integration-SNMP-v1.1.0), PACOM EMCS.
