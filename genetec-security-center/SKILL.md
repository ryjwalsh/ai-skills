---
name: genetec-security-center
description: Comprehensive knowledge of Genetec Security Center 5.13-5.14: architecture, install/silent install, upgrade paths, default ports, configuration, hardening, operations, logging, troubleshooting, and SDK/API. Use whenever Security Center, Config Tool, Security Desk, Server Admin, Directory, Archiver, Media Router, Access Manager, ALPR Manager, AutoVu, Synergis, Omnicast, Mission Control or Genetec SaaS is mentioned, or when terms like Genetec Server service, .gconfig, or LPM protocol appear.
---

# Genetec Security Center

Security Center is Genetec's unified security platform combining IP video surveillance (Omnicast), access control (Synergis), automatic license plate recognition (AutoVu), intrusion detection and communications behind two desktop clients - Security Desk (monitoring) and Config Tool (configuration) - plus the browser-based Server Admin and Genetec Web App. [S1]

## Version coverage

> Knowledge current as of docs retrieved **2026-07-24**, covering versions **5.13.0.0 - 5.14.0.1** (deployment target: 5.13.x.x and 5.14.x.x). Verify version-sensitive answers against current docs.

Latest builds recorded: **5.14.0.1 = 5.14.178.1082** (2026/07/02), **5.14.0.0 = 5.14.178.8** (2026/05/11), **5.13.3.7 = 5.13.3132.7023** (2026/06/15). Full table in `references/version-matrix.md`. [S13]

## Quick facts

| Item | Value | Src |
|---|---|---|
| Windows services | `Genetec Server` (GenetecServer) and `Genetec Watchdog` (GenetecWatchdog). Watchdog is a dependency of Server; both are created by the installer. | S7, S21 |
| Service start | `NET START GenetecServer` / `NET START GenetecWatchdog` | S7 |
| Key executables | `GenetecServer.exe`, `Genetec.Directory.exe`, `GenetecWatchdog.exe`, `SecurityDesk.exe`, `ConfigTool.exe`, `GenetecArchiver.exe`, `GenetecArchiverAgent32.exe`, `GenetecMediaRouter.exe`, `GenetecRedirector.exe`, `GenetecAccessManager.exe`, `GenetecLicensePlateManager.exe`, `Genetec.MediaGateway.exe`, `Genetec.WebApp.Console.exe`, `GenetecUpdateService.exe` | S3 |
| Default install path (64-bit) | `C:\Program Files (x86)\Genetec Security Center 5.14` (32-bit: `C:\Program Files\Genetec Security Center 5.x`) | S7, S23 |
| Config files | `<install>\ConfigurationFiles\*.gconfig` - for example `GenetecServer.gconfig`, `Archiver.gconfig`, `License.gconfig` | S23, S20, S31 |
| Log paths | Default `C:\ProgramData\Genetec Security Center [X.Y]\Logs`; crash dumps in `...\Dumps`; Archiver logs `C:\ArchiverLogs\`; installer logs `%ALLUSERSPROFILE%\Genetec\Installation\Security_Center_5.14` and `C:\ProgramData\Genetec\Installation` | S22, S20, S7, S28 |
| Core ports | Directory / server-to-server **TCP 5500**; Server Admin REST **TCP 80 / 443**; Map Manager **8012**; Media Router RTSP **554**; Archiver **555**; Auxiliary Archiver **558**; Redirector **560**; edge playback **605**; Cloud Playback **570**; Media Gateway RTSP **654**; GUS **4595**; SQL **TCP 1433 / UDP 1434** | S3 |
| Admin URLs | Server Admin `http(s)://<server>:<port>/Genetec`. Debug consoles: Server Admin `localhost/Genetec/Overview`, Security Desk `localhost:6020/Genetec/Overview`, Config Tool `localhost:6021/Genetec/Overview`, Genetec Mobile `localhost:9001/Genetec/console#/Diagnostic` | S22 |
| Default credentials policy | The default `Admin` password must be changed and the profile ideally deactivated. Server / Server Admin passwords require at least 8 characters with upper, lower, numeric and special characters, no spaces or double quotation marks. Password strength is **not** validated when set directly in `GenetecServer.gconfig`. | S12, S7, S23 |
| Databases | SQL Server 2017 / 2019 / 2022 / 2025 (Express, Standard, Enterprise), 64-bit only. Directory database default name `Directory`; automation event cache `DirectoryAutomationEvents`. | S5, S1 |
| SQL Express size cap | 10 GB for SQL Server 2008 Express through 2022; **50 GB** for SQL Server 2025 Express. | S21, S20 |
| Server name limit | Server names must be **15 characters or fewer**; longer names are truncated and cause access errors. | S7 |

## Where to look

| If the question is about... | Open |
|---|---|
| Roles, services, databases, topologies, failover, load balancing | `references/architecture.md` |
| Ports, firewall rules, TLS and certificates, SaaS cloud endpoints, 5.13 vs 5.14 port deltas | `references/network-ports.md` |
| Hardware / OS / SQL support, sizing, camera and reader maxima, virtualization | `references/version-matrix.md` |
| Prerequisites, install packages, silent-install switches, upgrade paths, backup and restore | `references/install-upgrade.md` |
| .gconfig keys, client command-line arguments, Active Directory / OpenID / SAML2, license options, hardening settings | `references/configuration.md` |
| Starting and stopping, health monitoring, trace loggers, ProcDump and Wireshark captures, retention, maintenance mode | `references/operations.md` |
| A **symptom** such as "Archiver is offline", "no live video", "service will not start" | `references/troubleshooting.md` |
| A specific error string, MSMQ warning, installer return code, or KBA number | `references/error-codes.md` |
| SDK, Web-based SDK, Media Gateway RTSP, Mission Control Web API, Federation | `references/api-integration.md` |
| What changed between versions, known issues, limitations, build numbers | `references/version-matrix.md` |
| What the documentation does **not** answer | `known-gaps.md` |

Every reference file cites source IDs defined in `sources.md`. A read-only PowerShell collector built strictly from documented commands is in `scripts/healthcheck.ps1`.

## Five most common troubleshooting flows

### 1. Clients cannot connect / main server offline [S21]

1. **License** - in Server Admin confirm the license is still valid (green). If not, reactivate or reapply it.
2. **Service** - in Windows Services confirm `Genetec Server` is running. If it will not start, check the `Genetec Watchdog` dependency and the service logon account.
3. **Service account rights** - confirm the Genetec Server logon user can sign in to SQL Server through SSMS and has full Windows rights, then restart the service.
4. **Directory role** - in Server Admin verify Directory is online and start it with **Directory > Start**. For detail use **Actions > Console > Commands > Directory Commands > Status**.
5. **Ports** - confirm the required ports are open and not used by another process: `netstat -na | find"[PortNumber]"`.
6. **Windows events** - run `eventvwr.msc` and check the Application, System and **Genetec** logs; look for dump files under `C:\ProgramData\Genetec Security Center [5.x]\Dumps`.

### 2. Archiver role offline [S20]

Check in order: host server online (Genetec Server service running, expansion server connected to the Directory), NIC priority (the NIC used by Genetec Server must be first in both Windows and Config Tool **Network view**), Archiver ports open (`telnet <IP address> <port>` or `tnc -computer <IP or DNS> -port <port>`), antivirus and Windows Firewall exclusions, interfering Windows processes (event logs plus dump files), low disk space on C:, CPU or RAM saturation, and finally a corrupt or missing `Archiver.gconfig` - regenerate it from Server Admin with **Actions > Console > Commands > Archiver Agent commands > GenerateConfigFile**.

### 3. Archiver stopped recording or cannot write to disk [S20]

Likely causes: storage drives shown red in the role **Resources** tab, recording disks full (the Archiver re-evaluates free space every **30 seconds**), orphan video files that Security Center cannot delete, or the Genetec Server service user lacking read/write access to the storage path. Remedies: enable **Delete oldest files when disks are full**, lower the **Automatic cleanup** threshold and the retention period, reduce **Min. free space** (keep it at least 0.2% of total size), add storage, or grant NTFS rights. Verify access by signing in to the server *as the service account* and creating a text file in the archive folder.

### 4. MSMQ warnings on the Archiver (role turns yellow) [S20]

Three documented warnings exist: MSMQ not running (enable **Microsoft Message Queue (MSMQ) Server** in Windows Features), MSMQ delayed, and "unable to store messages in the Microsoft Message Queuing (MSMQ)" - at which point archiving stops. Collect before contacting GTAC: the role database size, version and free disk space; the disk response time for `mqsvc.exe` in Resource Monitor (above 50 ms is high, above 100 ms is critical); and the queue size from `C:\Windows\System32\msmq` by opening the properties of the **Storage** folder. **The queue is considered full at 520 items or 1 GB.**

### 5. No live video in Security Desk [S20]

Press **Ctrl+Shift+D** or click **Show diagnosis** in the tile and read the Media Player state to localise the delay: Initializing, Connecting to Media Router, Connecting to Archiver and redirector, Requesting live stream (the player resets after 15 seconds), Analyzing the stream, Requesting security information, Decoding stream, Streaming. Then confirm the unit is online (**Unit > Ping**, **Unit > Reboot**), confirm the model and firmware appear on the Supported Device List, change the camera **Connection type**, test playback, test from a Security Desk running on the Archiver server (this isolates redirection), confirm that ports 554, 555, 560, 605 and 9603 plus the UDP ranges are open, and review the **Network view** settings.

## Working rules for this skill

- Every fact traces to a source ID listed in `sources.md`. Anything marked **[INFERRED - verify]** was not stated verbatim in a retrieved source.
- Where the documentation is silent the files say **Not documented** and the item is recorded in `known-gaps.md`.
- 5.13 and 5.14 differ in several documented places (the ALPR Patroller service port, SAMA installation, the KiwiVision port table, Config Tool backward compatibility, SQL Server 2025 support). Confirm which version the user runs before answering port, upgrade or requirements questions.
- The scripts directory contains **read-only** checks only. Nothing in this skill changes system state.
