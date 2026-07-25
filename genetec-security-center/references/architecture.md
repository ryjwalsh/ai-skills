# Architecture

Covers Phase 2 section B (architecture) plus the database and high-availability material that depends on it. Source IDs resolve in `../sources.md`.

## 1. Product scope and feature families [S1]

Security Center is a client-server platform whose features divide into four families:

| Family | Brand | Scope |
|---|---|---|
| Common / core | - | Alarms, zones, Federation, intrusion panel integration, report management, schedules and scheduled tasks, users and user groups, Windows Active Directory integration, programmable automation |
| Video surveillance | Omnicast | Camera configuration, live and playback video, PTZ, digital zoom, motion detection, bookmarks, visual tracking, export, protection against deletion, digital signatures, privacy protection |
| Access control | Synergis | Cardholders, credentials, visitors, doors, access rules, people counting |
| License plate recognition | AutoVu | Fixed and mobile (Genetec Patroller) ALPR, hotlist/scofflaw matching, parking enforcement, permits, plate inventory |

Applications: **Security Desk** (monitoring, reporting, alarm handling), **Config Tool** (configuration), **Server Admin** (web, server and Directory administration), **Genetec Web App** (web client - as of 5.14.0.0 it is the exclusive web client and replaces Security Center Web Client), **Genetec Mobile** (mobile app). [S1] [S9]

## 2. Client-server model and server types [S1]

Every system has its own pool of servers, from one machine to hundreds. Server roles are assigned to servers; a server can host many roles.

| Server type | Definition |
|---|---|
| Main server | Hosts the **Directory** role. Must be set up first. Only one Directory role is permitted per system. |
| Expansion server | Any additional server. Must connect to the main server to join the system. Installed with `SERVER_TYPE=Expansion` (no Directory). |
| Directory gateway | A Security Center server acting as a proxy for the main server so clients on a non-secured network can reach it. A server cannot be both a Directory server and a Directory gateway, because the Directory server must connect to the Directory database and the gateway must not. Load balancing does not occur between gateways and Directory servers. Gateways must be added to the license. [S12] |

Constraints: the Genetec Server service cannot be installed on a domain controller; server names must be 15 characters or fewer; systems with more than 300 cameras, 1,000 readers or 300 HID Edge readers must isolate the Directory on a dedicated server. [S5] [S7]

## 3. Windows services and processes

| Service (display name) | Service name | Notes |
|---|---|---|
| Genetec Server | `GenetecServer` | Hosts all roles on that server. Depends on `GenetecWatchdog` and `Winmgmt`. |
| Genetec Watchdog | `GenetecWatchdog` | Supervises Genetec Server; created with `start= auto` and specific Recovery options. |

Documented recreate commands (see `install-upgrade.md` for full syntax): `sc create GenetecWatchdog ...`, `sc config GenetecServer ... depend= GenetecWatchdog/Winmgmt`, `sc start GenetecServer`. [S7]

Process-to-function mapping (extracted from the port tables, so it is authoritative for firewall rules): [S3]

| Process | Function |
|---|---|
| `Genetec.Directory.exe` | Directory role, accepts server connections on TCP 5500 |
| `GenetecServer.exe` | Generic role host / server-to-server communication |
| `GenetecInterface.exe` | Server Admin REST endpoint (TCP 80 / 443) |
| `GenetecAuth.exe` | Authentication role (OIDC / SAML2) |
| `GenetecArchiver.exe`, `GenetecArchiverAgent32.exe`, `GenetecVideoUnitControl32.exe` | Archiver role, Archiver agent, video unit control |
| `GenetecAuxiliaryArchiver.exe` | Auxiliary Archiver role |
| `GenetecMediaRouter.exe`, `GenetecRedirector.exe` | Media Router role and redirectors |
| `Genetec.MediaGateway.exe`, `Genetec.MediaComponent32.exe` | Media Gateway role and media component |
| `GenetecCloudPlaybackRole.exe`, `GenetecCloudPlaybackAgent.exe` | Cloud Playback |
| `GenetecAccessManager.exe` | Access Manager role |
| `GenetecActiveDirectory.exe` | Active Directory role |
| `GenetecLicensePlateManager.exe` | ALPR Manager role |
| `GenetecMapManager.exe` | Map Manager role (image map downloads on TCP 8012) |
| `GenetecMobileRole.exe`, `GenetecMobileAgent.exe` | Mobile Server role |
| `Genetec.WebApp.Console.exe` | Web App Server role |
| `GenetecIngestion.exe` | Record Caching Service |
| `GenetecUnitAssistantRole.exe` | Unit Assistant role |
| `GenetecBwcManagerRole.exe`, `GenetecBwcAgentService.exe` | Wearable Camera Manager |
| `GenetecGlobalCardholderManagement.exe` | Global Cardholder Synchronizer |
| `GenetecMobileCredentialManager.exe` | Mobile Credential Manager |
| `GenetecSecurityCenterFederation.exe` | Security Center Federation role |
| `GenetecUpdateService.exe`, `GenetecUpdaterService.Sidecar.exe` | Genetec Update Service (GUS) and its sidecar |
| `Genetec.HealthMonitor.Agent.exe` | System Availability Monitor Agent (SAMA) |
| `GenetecPlugin.exe`, `GenetecPlugin32.exe` | Plugin roles (Sipelia, Pay-by-Plate Sync, KiwiVision, and others) |
| `Genetec.MediaProcessor.exe` | KiwiVision Privacy Protector / Camera Integrity Monitor (documented in the 5.13 port guide) [S4] |
| `Genetec.WebBrowserWorker.exe` | Embedded browser in Security Desk / Config Tool |

## 4. The Directory role [S1]

The Directory role identifies the system and manages all entity configuration and system-wide settings. Only one instance is permitted. Its main functions: authenticating client connections, enforcing the software license, central configuration management, event management and routing, audit and activity trail management, alarm management and routing, incident management, scheduled task execution, macro execution.

Because the Directory authenticates all client connections it **cannot** be configured from Config Tool - use Server Admin. From Server Admin you can start/stop the Directory, manage the Directory database, view and modify the license, change the main server password and communication ports, and convert the main server into an expansion server.

## 5. Role inventory and failover support [S1]

| Role | Failover | Notes |
|---|---|---|
| Access Manager | Yes | |
| Active Directory | Yes | |
| ALPR Manager | Yes | Extra resources must be shared: the role **Root folder** and the hotlist/permit paths must use UNC and be reachable from all assigned servers. |
| ALPR Matcher | Yes | Compares reads against hotlists to produce hits. |
| Archiver | Yes | Up to two secondary servers; each server needs its own database. Not supported for Archivers used for wearable cameras. |
| Authentication Service | Yes | Runs on the same server as the Directory. With Directory failover, every Directory endpoint URI must be registered with the identity provider. |
| Automation Manager | Yes | When unavailable, unprocessed events are cached for up to five minutes in `DirectoryAutomationEvents`, hosted with the Directory database by default. |
| Auxiliary Archiver | **No** | Its purpose is to keep archives available when the Archiver fails. |
| Cloud Playback | Yes | |
| Directory | Yes | Runs on up to five servers simultaneously; database failover also supported. |
| Directory Manager | n/a | It *is* the mechanism that manages Directory failover and load balancing. One per system, created automatically when the license permits multiple Directory servers. |
| Global Cardholder Synchronizer | Yes | |
| Health Monitor | Yes | |
| Intrusion Manager | Yes | Only for IP-connected panels; not for serial. |
| Map Manager | Yes | Best practice: put the map cache where all assigned servers can reach it. |
| Media Gateway | Yes | Do **not** co-host with an Archiver - high CPU can cause "Archiving queue full" and data loss. [S5] |
| Media Router | Yes | Primary and secondary may each use a separate database. |
| Mobile Credential Manager | Yes | |
| Mobile Server | Yes | |
| Plugin (all instances) | Yes | |
| Record Caching Service | Yes | |
| Record Fusion Service | Yes | |
| Report Manager | Yes | |
| Reverse Tunnel / Reverse Tunnel Server | Yes | The server side is handled by Genetec Cloud Operations. |
| Security Center Federation | Yes | |
| Unit Assistant | Yes | |
| Wearable Camera Manager | **No** | Client stations accumulate data until the role returns. |
| Web-based SDK | Yes | No database required. |
| Web App Server | Yes | Web App must reconnect to a different URL after failover. |
| Web Client Server | Yes | Legacy; Web App replaces it in 5.14. |
| Zone Manager | Yes | |

**Important:** Security Center does not manage failover of role databases except the Directory database. For non-Archiver roles with a database, host the database server on a separate machine that all role servers can read and write. [S1]

## 6. Directory failover and load balancing [S1]

The Directory service is available while both the **Directory role** and the **Directory database** (default name `Directory`, configured in Server Admin) are available. The **Directory Manager** role handles failover for the role and the database independently, so the two can use different (or overlapping) server lists.

- The Directory role can run on up to **five** servers simultaneously for load balancing; they share credential authentication, license enforcement and Directory database report queries.
- Only the **main** Directory server has read/write access to the Directory database; the others are read-only.
- Client connection requests are distributed round robin by the Directory Manager; load balancing can be bypassed on specific workstations.
- When a secondary server fails only its own clients reconnect. When the main server fails **all** clients reconnect and the next server in the failover list becomes main.
- **Start the `GenetecServer` service on all Directory servers concurrently.** On start, each server discovers the other Directory servers and participates in the main-Directory election and load distribution. Staggered starts give no benefit, unbalance load and temporarily shrink the Directory pool. There is no required startup order.

## 7. Directory database failover modes [S1]

Three modes require a switch in **Config Tool > Directory Manager > Database failover**:

| Mode | Owner | Behaviour |
|---|---|---|
| Backup and restore | Directory Manager (Security Center) | Regularly backs up the master Directory database and replicates it to a backup server; on loss, connects to the most recent restored backup. |
| Mirroring | Microsoft SQL Server | Principal and mirror kept perfectly in sync; transparent to Security Center; no data loss. |
| Always On Availability Groups | Microsoft SQL Server | Multiple independent copies across servers, no shared storage. Distinct from Always On Failover Cluster Instance (FCI), which needs no Security Center switch. |

| Backup and restore | Mirroring |
|---|---|
| Failover DB only as current as the last backup | Failover DB is an exact copy |
| Changes made while on the backup DB are lost when switching back | No data loss at any time |
| Master and backup must be hosted on Security Center servers | Principal and mirror can be on any computer |
| Works with free SQL Server Express | Requires SQL Server 2008 Standard or better |
| Recommended when entity configuration changes rarely | Recommended when configuration changes often (cardholder / visitor management) |
| Temporarily disconnects all clients and roles during failover | Directory restarts if the principal is unavailable for more than a few seconds |
| Handled by the Directory Manager role | Executed by a separate Witness server on SQL Express (optional, strongly recommended) or manually by the DBA |

## 8. Archiver failover and redundant archiving [S1]

Primary, secondary and tertiary servers may be assigned (useful for putting the tertiary at a remote site). **Each server must have its own database.** Turn on **redundant archiving** so every assigned server archives simultaneously and manages its own copy of the archive; otherwise video written by the failed primary is unreachable.

- Failover takes **15-30 seconds** for cameras to come back online. Live video is unavailable and Auxiliary Archivers do not record during that window, but the gap in recorded video is **no more than 5 seconds**.
- **Never let two Archiver roles share the same logical disk for archive storage.** Give each server two logical disks and assign one disk per Archiver role.
- If role A has secondary and tertiary servers and its secondary is shared with higher-priority role B, a simultaneous failure of both primaries lets B archive on the shared secondary and prevents A from archiving on either standby. If a standby must be shared, share the tertiary.

## 9. Health monitoring [S1]

The **Health Monitor** role monitors servers, roles, units and client applications. Health events are stored in a database for reporting and statistics; current errors surface in real time in the notification tray. One instance per system, created at installation and not deletable. You choose which health events to monitor from the role.

The **System Availability Monitor Agent (SAMA)** (`Genetec.HealthMonitor.Agent.exe`) reports to a cloud Health Service over TCP 443. **As of 5.14.0.0 SAMA is no longer installed by default** but can be installed manually from the `SC Packages` folder. [S9] The 5.13 port guide additionally documents a legacy SAMA path on TCP 4592, which is absent from the 5.14 guide. [S4]

## 10. Databases and SQL Server permissions

Supported engines: SQL Server 2017, 2019, 2022, 2025 in Express, Standard or Enterprise, 64-bit only. On the minimum server profile, SQL Server **Maximum server memory** must be limited to 512 MB. [S5]

Minimum SQL roles quoted in the install guide: server-level `dbcreator`, `processadmin`, `public`; database-level `db_backupoperator`, `db_datareader`, `db_datawriter`, `db_ddladmin`, `public`. Service users who are not Windows administrators and not members of `sysadmin` additionally need `VIEW SERVER STATE`: `GRANT VIEW SERVER STATE TO [login name]`. [S7]

Hardening guide detail (SQL Server 2017 and later do **not** require `sysadmin`; SQL Server 2016 and earlier do require it for backup and restore): [S12]

- `processadmin` is what confers `VIEW SERVER STATE`, which the Directory role always needs and which is mandatory with Directory failover.
- `dbcreator` is only needed for the first execution (or if you let Security Center create the databases); remove it afterwards. It is also needed for Directory database failover through backup and restore, and during an upgrade when Automation is enabled (creates `DirectoryAutomationEvents`).
- `public` allows execution of default stored procedures - revoke `EXECUTE` on `xp_dirtree`.
- Replace `db_owner` with the less privileged `db_ddladmin`. Roles with dynamic schemas need `db_ddladmin`.
- All roles need `EXECUTE` on the `dbo` schema: `GRANT EXECUTE ON SCHEMA::[dbo] TO [ principal used by the Security Center role ]`.

Server-level roles required per role (X = required; `dbcreator` is first-run only unless noted): Access Manager, ALPR Manager, ALPR Matcher, Archiver, Automation Manager, Auxiliary Archiver, Directory, Health Monitor, Intrusion Manager, Media Router, Mobile Credential Manager, Mobile Server, Plugin (own database), Point of Sale, Record Caching Service, Unit Assistant and Zone Manager all require `public` + `dbcreator` + `processadmin`. A Plugin role that connects to another role's database requires only `public`. [S12]

Database-level roles: all of the above require `public`, `db_datareader`, `db_datawriter` and `db_backupoperator`. `db_ddladmin` is additionally required by Access Manager, ALPR Manager, ALPR Matcher, Automation Manager, Directory, Health Monitor, Mobile Credential Manager, Plugin (own database), Point of Sale, Record Caching Service and Zone Manager - but **not** by Archiver, Auxiliary Archiver, Intrusion Manager, Media Router, Mobile Server or Unit Assistant. A Plugin role using another role's database needs `public`, `db_datareader` and `db_datawriter` only. [S12]

## 11. Supported topologies

| Topology | Notes |
|---|---|
| Standalone / single server | Directory + Archiver + Access Manager on one machine. With the minimum profile and the unified server type, SQL Server must be on a separate machine. [S5] |
| Distributed on-premises | Main server plus expansion servers; roles distributed by load. |
| High availability | Directory role on up to five servers, Directory database failover, per-role failover, Archiver primary/secondary/tertiary with redundant archiving. [S1] |
| Virtualized | VMware ESXi 7.x / 8.x, Microsoft Hyper-V on Windows Server 2016/2019/2022/2025. See `version-matrix.md` for the full design guidelines. [S5] |
| Hybrid with Cloud Storage | Archiver uploads encrypted archives to Azure over TCP 804 / 4434; Cloud Playback serves them back. Requires uplink at least 30% above recording throughput and latency under 150 ms. [S3] [S5] |
| Security Center SaaS | Genetec-hosted. On-premises systems join by federating into SaaS over a reverse tunnel on TCP 5500 to `*.gsc-cloud.com`. Regional data centres: AU, CA, EU, UK, US. [S17] |
| Mission Control | Adds the **Incident Manager** role, the **Incident Document Service** role, a **Web API SDK** endpoint (TCP 9550) and a **RabbitMQ** message broker (TCP 5671 AMQPS, 4369 Erlang, 15671 HTTPS API, 25672 clustering). RabbitMQ can be standalone or clustered. [S15] |

## 12. Adjacent modules that touch Security Center

| Module | Interface |
|---|---|
| Sipelia (intercom / SIP) | Plugin role; SIP UDP/TCP 5060, TLS 5061, session transfer TCP 8202, RTP UDP 20000-20500, Sipelia Gateway Web API TCP 7550, WebRTC UDP 49152-65535. [S3] |
| Synergis Softwire / Cloud Link / Axis Powered by Genetec | Access control units managed by the Access Manager; secure comms on TCP 443. [S3] |
| Genetec Clearance | Evidence sharing from Web App; Wearable Camera Manager talks to Axis SCU on TCP 48830-48833. [S3] [S9] |
| Streamvault appliances | Genetec-supplied hardware; SV Control Panel and Streamvault service versions have caused documented client launch failures. [S37] [S38] |
| Genetec Update Service (GUS) | Deploys Security Center, Drivers and documentation updates; TCP 4595 (HTTPS), 4596 (sidecar), 443 outbound to Azure/Genetec; TCP 4594 deprecated and redirects to 4595. [S3] [S26] |
| Genetec Cloudrunner | ALPR export over TCP 5671 (and 5672 must be unblocked per a documented limitation). [S3] [S9] |
