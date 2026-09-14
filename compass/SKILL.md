---
name: compass
description: Technician knowledge of the Motorola Solutions Compass Decision Management System (on-prem PSIM / alarm decision-management console, IndigoVision-derived) - architecture and services, ports (80/443/3306/9000-9200/9100+ drivers), installation and first login (Administrator/admin, https://<ip>, /manager), licensing via License Manager (.v2c, 60-day trial), backup/restore, upgrades, logs and anti-virus exclusions, multi-node failover, integration drivers (IndigoVision Control Center, Avigilon ACC/ACM, SNMP, PACOM), and the operator web client (alarms, operator guides, video wall, maps, reports, auditing, configuration). Use whenever Compass, "decision management system", Compass driver, Compass-Primary, agent.properties or partners.indigovision.com Compass downloads come up.
---

# Motorola Solutions Compass Decision Management System

Compass is Motorola Solutions' on-premises decision-management (PSIM) platform: it collects alarms from video, access-control, intrusion and IT systems through integration **drivers**, presents them to operators with step-by-step **operator guides**, and adds video wall, maps, reports and auditing. It runs on Windows Server (Tomcat + MariaDB + Elasticsearch/Kibana) and is licensed with the IndigoVision License Manager. Documentation and drivers are published on avigilon.com/fs/documents and, for partners, partners.indigovision.com (the Tool Hub "Compass Documentation & Software" tile). [S1]-[S4]

## Scope and freshness
Built 2026-09-14 from the On-Prem Install and Maintenance Guide v2.2.11.x (Dec 2024), the On-Prem User Guide v2.2.10.x, and the IndigoVision Control Center driver integration guide v1.7.1. The Configuration Guide (admin console detail) was not available - configuration paths below are top-level only.

## Quick facts
| Item | Value | Src |
|---|---|---|
| Login | https://<compass IP> — Administrator / admin (change on first login); System Manager https://127.0.0.1/manager | S1 |
| Ports | 80, 443 web; 3306 MariaDB; 5601 Kibana; 8443 HTTPS services; 9000 streamer; 9050 manager; 9060 license manager; 9080 services adapter; 9100/9102/… drivers; 9200 Elasticsearch; 8020 failover registration | S1 |
| Services | COMPASSDB, COMPASSLicenseServer, COMPASSManager, COMPASSServicesAdapter, Apache Tomcat (COMPASSserver), elasticsearch-service-x64, Kibana | S1 |
| Install path / logs | %COMPASS_PATH% (default C:\Program Files (x86)\COMPASS); logs under %COMPASS_PATH%\logs\<component>; drivers logs\drivers\driver_<port> | S1 |
| License | IndigoVision License Manager → fingerprint → Sales Orders → apply .v2c → restart COMPASSServer; 60-day trial Compass_trial_60days.v2c | S1 |
| Backup | %COMPASS_PATH%\tools\backupDB\backupDatabase.bat / restoreDatabase.bat | S1 |
| OS | clean Windows Server 2019, static IP, .NET 3.5, no other MySQL/MariaDB | S1 |
| Partner portal | partners.indigovision.com (software, drivers, docs); public PDFs at avigilon.com/fs/documents/MSI-Compass-* and Integration-*.pdf | S4 |

## Answer contract
Name the surface (**Compass web client**, **Configuration interface**, **System Manager**, **Windows server / files**, **driver installer**) and then the exact menu, file or command. Include port numbers and file paths for driver/connectivity problems. Where the Configuration Guide detail is missing, say "Configuration interface > <area>" and point to the Configuration Guide on the partner portal rather than inventing field names.

## Where to look
| Question | Open |
|---|---|
| Services, ports, install wizard pages, first login, licensing, backup/restore, upgrade, logs, AV exclusions, certificates, multi-node failover, migration, troubleshooting, IndigoVision driver setup | `references/compass-install-maintenance.md` |
| Operator client: alarm handling flow, alarm panel, video wall, mosaics, maps, workspace, reports, auditing, configuration areas, error messages | `references/compass-user-navigation.md` |
| Sources / gaps | `sources.md`, `known-gaps.md` |

## High-frequency answers
| Question | Answer |
|---|---|
| Driver shows Offline | agent.properties BACKEND_URL → https://<primary> (port 80 backend.url); instance.conf IPs/ports; Configuration > Private/Public Host IP ≠ 127.0.0.1; restart agents/manager/services adapter |
| Can't open the login page | services running (services.msc), correct URL, firewall 80/443 |
| Apply / renew license | Windows menu > IndigoVision License Manager > Apply a new or updated Motorola Solutions license > .v2c > restart COMPASSServer |
| Back up before upgrade | run backupDatabase.bat, copy tools + data folders off-box; installer also copies app files to bck |
| Where are the logs | %COMPASS_PATH%\logs\server\tomcat, \drivers\driver_9100…, \streamers, \servicesadapter; levels in conf\logconf |
| Add IndigoVision Control Center to Compass | generate SiteDB service token (CC 17.0.2+) → install IndigoVision driver → Global Devices > new device IndigoVision / Control Center → Connection Data → map sites (names must match) |
| Clear / postpone / escalate an alarm | select alarm → Operator Guide → Clear (classification) / Postpone dropdown (time or Forever, Escalate, Change priority) |
| Schedule a PDF alarm report | User Menu > Reports > New Automatic Report |
| Video wall layouts | Video Wall > Layouts > New |
| Check failover status | User Menu > Other > Multinode |

## Working rules
- Facts trace to `sources.md`; **[INFERRED - verify]** otherwise.
- Compass Configuration interface field names were not captured - never invent them.
- Read-only knowledge; destructive steps (Create DB in System Manager, restoreDatabase, uninstall with Remove all files) are flagged.
