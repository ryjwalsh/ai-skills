# Operations

Phase 2 sections G and H: service control, health checks, monitoring hooks, maintenance, logging and diagnostics.

## Contents

1. Starting and stopping services
2. Server Admin and role control
3. Health monitoring
4. Trace loggers and consoles
5. Log and dump locations
6. Log retention and disk-usage settings
7. Windows event, performance and SQL logs
8. Diagnostic utilities (ProcDump, Wireshark, Dumpcap)
9. Database information and maintenance
10. Retention and cleanup behaviour
11. Maintenance mode
12. Monitoring hooks (SNMP, syslog, API)
13. What to collect before opening a support case

## 1. Starting and stopping services [S7] [S21]

Two Windows services exist: `Genetec Server` (`GenetecServer`) and `Genetec Watchdog` (`GenetecWatchdog`), where Watchdog is a dependency of Server.

```
NET START GenetecServer
NET START GenetecWatchdog
```

These are the documented start commands (given for restarting after a hotfix following a `SKIPSERVICESTART=Y` install). Service control is otherwise done from the Windows Services console (`services.msc`). After uninstalling a patch release, both services stop on all servers and must be set back to **Automatic** startup and restarted manually. [S10]

**Multi-Directory systems:** start `GenetecServer` on **all** Directory servers concurrently, or within the shortest possible window. Each server discovers the others on startup and participates in the main-Directory election and load distribution. Staggered starts unbalance load and shrink the Directory pool. There is no required order and nothing is gained by waiting for one server to settle. [S1]

**Service logon failure recovery:** if `Genetec Server` fails to start with a logon failure, reset the service account password in the Computer Management console (**Users** folder, right-click the account), then set the matching password on the service in Windows Services and start it. Repeat for `Genetec Watchdog`. The Local System account password is managed by Windows. [S21]

## 2. Server Admin and role control [S1]

Server Admin is the web application for server and Directory administration: `http(s)://computer:port/Genetec`, or the **Genetec Server Admin** shortcut in the Windows Start menu on the main server. From it you can start and stop the Directory role, manage the Directory database, view and modify the license, change the main server password and communication ports, and convert the main server to an expansion server.

Role control from Config Tool: **System task > Roles view**. Roles are deactivated and reactivated with **Maintenance > Deactivate role** and **Maintenance > Activate role** (in the **Video** task for video roles). Deactivating an Archiver role turns it and all its video units red temporarily, so do it at a non-critical time. [S20]

Documented role-level diagnostics: right-click the **Media Router** role and choose **Maintenance > Diagnose** to find and fix issues; on the role **Resources** tab, **Create a database** if the status is Disconnected or Unavailable. [S20]

Directory role status from the console: Server Admin > select the server > **Actions > Console > Commands > Directory Commands > Status**. [S21]
Archiver config file generation: **Actions > Console > Commands > Archiver Agent commands > GenerateConfigFile** (or **Archiver Role commands > GenerateConfigFile** for the role section only). [S20]
Federated stream statistics (new in 5.14.0.0): the `ShowFederatedStreams` debug command, available through Server Admin **or the Genetec PowerShell module**, showing active streams, bit rates and playback sessions. [S9]

## 3. Health monitoring [S1]

The **Health Monitor** role monitors servers, roles, units and client applications; health events are stored for reporting and statistics and current errors appear in the notification tray. One instance per system, created at installation, not deletable. You select which health events to monitor from the role. The role database can be reset (**Resetting the Health Monitor database**).

Security Desk maintenance tasks used for health work: **System status**, **Audit trails**, **Activity trails**, **Health history**, **Health statistics**, **Hardware inventory**, plus per-solution tasks such as **Access control health history**, **Archiver events**, **Archiver statistics** and **Archive storage details**. [S7]

**System Availability Monitor Agent (SAMA)** reports to a cloud Health Service over TCP 443. Its data-collection policy is set at install time with `SAMA_COLLECTPOLICY` (`On` requires `ACTIVATIONCODE`, `Anonymous` is the default, `Off` disables it). **From 5.14.0.0 SAMA is no longer installed by default** but remains available for manual installation from the `SC Packages` folder. [S7] [S9]

Health events introduced in 5.14.0.0 worth monitoring: **Automation Manager overloaded** and **Automation Manager no longer overloaded** (raised when automation instances in memory cross the configured maximum, set in the Automation Manager advanced settings). The Report Manager now queues automated tasks with a **maximum queue size of 100**; hitting the limit raises a health event and puts the Report Manager into a warning state. Security Center also detects **time drift of more than 10 seconds** between the Directory server and connected failover or expansion servers, raising health events and warnings. [S9]

No HTTP health-check endpoint is documented for Security Center roles - logged in `../known-gaps.md`.

## 4. Trace loggers and consoles [S22]

A **logger** is an individual monitor or counter describing one part of the system. A **trace logger** is a named group of loggers saved together for a class of problem; running one runs several loggers at once. Documented example trace loggers: `Access Control - Access Manager`, `Archiver - No Video Found`, `Platform - Active Directory`. Trace and logger names are supplied by Technical Support.

**Running a predefined trace:** log on to Server Admin, select the server in **Servers**, click **Actions > Console**, open the **Trace logger** tab, select the trace, optionally set the retention and disk-usage settings and the **Log folder**, then click **Start**. Reproduce the issue and note the exact time, then click **Stop**.

> **IMPORTANT (repeated in every trace procedure):** unless you stop the trace it keeps running, consuming more disk space than needed and potentially making the server's hard drive unusable or causing system failures.

**Creating a custom trace:** same path, then **Add**, give it a **Name**, optionally set retention, disk usage and log folder, search and select the loggers (names provided by Technical Support), then **Save** and **Start**.

**Exporting a trace:** select it on the **Trace logger** tab and click **Export trace logger to clipboard** (drag the trace list wider if the icon is not visible), then paste into a text file.

**Importing a trace:** **Import trace logger**, paste the trace file into the **Trace logger** field, click **Import**, optionally set retention, disk usage and log folder, **Save**, then **Start**.

Console addresses: Server Admin `localhost/Genetec/Overview`, Security Desk `localhost:6020/Genetec/Overview`, Config Tool `localhost:6021/Genetec/Overview`, Genetec Mobile `localhost:9001/Genetec/console#/Diagnostic`. Security Desk and Config Tool debug consoles are **disabled by default** - enable them from **About > Debug console** and run the application as administrator.

Also useful: the **Loggers** view of the console (Server Admin > select server > **Actions > Console > Loggers**) shows current issues in the right-hand **Logs** panel - documented for both Directory database and Archiver troubleshooting. [S21]

Known issue to be aware of: in Server Admin, when the default values for predefined trace loggers are updated, the trace logger does not load the new defaults unless the trace loggers have been reset (issue 3338757). [S9]

## 5. Log and dump locations

| Path | Contents | Src |
|---|---|---|
| `C:\ProgramData\Genetec Security Center [X.Y]\Logs` | Default trace and console log output. The `ProgramData` folder may be hidden. | S22 |
| `C:\ProgramData\Genetec Security Center [5.x]\Dumps` | Crash dump files. | S21 [S20] |
| `C:\ArchiverLogs` | Archiver logs by default, including **disk full** and **disk 80%** events. | S20 |
| `%ALLUSERSPROFILE%\Genetec\Installation\Security_Center_5.14` | Installer logs by default. | S7 |
| `C:\ProgramData\Genetec\Installation` | Installation logs referenced when diagnosing error 1603. | S28 [S29] |
| `C:\Program Files\Microsoft SQL Server\MSSQL12.SQLEXPRESS\MSSQL\Log` | Default location of SQL Server `ERRORLOG` files. The instance folder name varies by version and install settings, and the path differs if SQL was installed on another drive. | S22 |
| Windows Event Viewer: **Windows Logs > Application**, **System**, and **Applications and Services Logs > Genetec** | Security Center service and role events. | S22 [S21] |
| Windows Performance Monitor: **Data Collector Sets > User Defined > Genetec - General** | Genetec performance data collector set. | S22 |

## 6. Log retention and disk-usage settings [S22]

Configurable per trace, under **Retention policy** and **Disk usage and log file size**:

| Setting | Meaning |
|---|---|
| Delete files after | Number of days log files are retained; the system deletes files when the threshold is reached. |
| Create file after | Maximum number of lines in a single log file; a new file is created at the threshold. |
| Minimum available disk space | Minimum free space required for logging, in MB or GB. Below the threshold **logging stops and the system sends a notification**; logging resumes when space is available. |
| Maximum disk space usage | Maximum usable disk space for logging, in MB or GB. At the threshold **old log files are deleted**. |
| Maximum log file size | Maximum size of a single log file, in MB or GB; a new file is created at the threshold. |
| Enable compression | Compresses the log file in ZIP format. |

Best practices: save log files somewhere other than the C: drive or anywhere recordings are stored; stop the trace once the issue is logged; align the logging strategy with available storage.

Archiver log settings are separate and live in `Archiver.gconfig` under `ArchiverAgent`: `ArchiverLogPath` (default `"C:\ArchiverLogs\"`) and `logDaysToKeep` (default `"90"`). Restart the Archiver role after changing them. [S20]

## 7. Windows event, performance and SQL logs [S22]

**Event logs for support:** open Event Viewer, expand **Windows Logs** and **Applications and Services Logs**, select **Application**, then from the **Actions** pane choose **Save All Events As** and save the file. Repeat for **System** and **Genetec**. Quick launch from an elevated prompt: `eventvwr.msc`. [S21]

**Performance logs:** open Performance Monitor, expand **Data Collector Sets > User Defined**. Recommended first: right-click the log, **Properties > Directory > Browse** on **Root directory** to move output off the C: drive or away from recordings, then **OK**. Select **Genetec - General**, click **Start the data collector set**, repeat for other logs specified by Technical Support, then **Stop the data collector set** for each when finished.

**SQL Server error logs:** collect the `ERRORLOG` files from `C:\Program Files\Microsoft SQL Server\MSSQL12.SQLEXPRESS\MSSQL\Log` (adjust for your instance and drive).

## 8. Diagnostic utilities [S22]

**ProcDump** captures unhandled exceptions and crashes. Save `ProcDump.exe` (best practice: `C:\Program Files (x86)\Windows Debugging Tools` if that folder exists), ensure the target process is running, note the PID from Task Manager **Details** if the process runs multiple times, then from an elevated Command Prompt:

```
ProcDump.exe -ma [Process Name] [Destination Folder]
ProcDump.exe -ma GenetecDirectory.exe C:\Dumps
ProcDump.exe -ma 9192 C:\Dumps
ProcDump.exe -ma -h GenetecDirectory.exe C:\Dumps
ProcDump.exe -ma -e GenetecDirectory.exe C:\Dumps
```

Always include `-ma` for a full memory dump. Add `-h` for a process with a hung window, `-e` to queue a dump for when the process crashes. **Do not close Command Prompt while the process is still running** - close it only once the dump is generated. Then collect the 32-bit `sos.dll`, `clr.dll`, `mscordackws.dll` and `Mscordbi.dll` from `C:\Windows\Microsoft.NET\Framework\v4.0.XXX` and the 64-bit versions from `C:\Windows\Microsoft.NET\Framework64\v4.0.XXX`, and send them with the dump files.

**Wireshark** for network traces. Install on the machine that matches the issue (for a camera issue, the Archiver managing that camera). The InstallShield installs WinPcap or Npcap. Configuration: **Edit > Preferences > Capture**, clear **Syntax check capture filter**; **Name Resolution**, disable transport name resolution (clear **Enable transport name resolution**, or clear **Resolve transport names** and **Resolve network (IP) addresses**); **Appearance > Columns**, add **Source port** = Src port (unresolved), **Destination port** = Dest port (unresolved), and **TCP stream** = Custom with field `tcp.stream` and Field Occurrence `0`. Then **Capture > Options > Output**: set a permanent file with the **.pcapng** extension, select **Create a new file automatically after** and set **200 megabytes**, select **Use a ring buffer with** and set **50 files** (about 10 GB total). On the **Input** tab set a capture filter; on the **Options** tab select **Update lists of packets in real-time**; then **Start**. Stop with **Stop capturing packets**.

**Dumpcap** for long or high-volume captures, because high traffic can freeze the Wireshark UI. From an elevated prompt in the Wireshark folder, list interfaces with `dumcap.exe -D` (spelling as printed in the guide; the utility is `dumpcap`), then:

```
dumpcap -i [ID of Network Card] -f [Capture Filter] -w [File Name] -b filesize:[Size in kB] -b files:[Number of Files]
dumpcap -i 2 -f "host 10.2.100.18 and tcp" -w Cam18_tcp_traffic_only.pcapng -b filesize:102400 -b files:50
```

Recommended values: 102400 kB per file and 50 files (about 5 GB). The file needs the `.pcapng` extension. Stop with **Ctrl+C**. Traces are usually saved to `C:\Program Files\Wireshark`.

**Database Anonymization Tool** (new in 5.14.0.0, shipped with Security Center) removes personally identifiable information from database backup files before sharing them with Genetec support - see "Anonymizing Security Center database backup files". [S9]

## 9. Database information and maintenance [S20]

**Viewing database information:** Config Tool **System > Roles >** select the role **> Resources > Database info**. For the Directory database use Server Admin's **Main server** page. Fields (role dependent): **Database server version**, **Database version** (schema version), **Approximate number of events**, **Source count** and **Video file count** (Archiver and Auxiliary Archiver only), **Size on disk**, and for the Directory only **Approximate number of entities**, **Approximate number of active alarms** and **Approximate number of archived alarms**.

**Checking whether a database is full:** SSMS **Object Explorer > Databases >** right-click the database **> Properties > General** and read **Space Available**. SQL Server 2025 Express has a **50 GB** limit; previous versions have **10 GB**. [S21]

**Transaction log too big:** SSMS **Properties > Files** shows the LDF size; the LDF should not be larger than the MDF. Fix: switch the recovery model to **Simple**, shrink the transaction log, then set a maximum size limit for it. [S20]

**Shrinking databases after an upgrade** is a documented post-upgrade task. [S7]

**Documented notification feature:** the system can monitor incoming camera events to detect an unusually high event rate and notify you before a database fills unexpectedly - "Receiving notifications when databases are almost full". [S20]

## 10. Retention and cleanup behaviour

| Mechanism | Behaviour | Src |
|---|---|---|
| Archiver retention period | Set per Archiver role; can differ per Archiver failover server ("Configuring different retention periods for each Archiver server"). | S1 |
| Automatic cleanup | On the Archiver **Camera default settings** tab; lowering the threshold deletes older archives automatically. | S20 |
| Delete oldest files when disks are full | Archiver **Resources > Advanced settings**. If not selected, the Archiver cannot free space and stops recording. The Archiver re-evaluates disk space every **30 seconds**. | S20 |
| Min. free space | Archiver **Resources** tab; keep it at least **0.2%** of total size. | S20 |
| Orphan files | Video files on disk that Security Center does not know about. They are not removed by Automatic cleanup or Delete oldest files. Use "Finding orphan files on your system" to locate them, then delete or re-integrate them. | S20 |
| Cloud Storage video files | For Archivers with Cloud Storage enabled, video files are capped at **5 minutes** and **100 MB**, overriding the Archiver advanced **Video files** values. | S9 |
| Zone Manager event retention | Up to **9,999 days** from 5.14.0.0. | S9 |
| Automation Manager event cache | Unprocessed events held for up to **five minutes** in `DirectoryAutomationEvents`. | S1 |
| Plugin cleanup | Plugins with a **Cleanup** option run a scheduled cleanup. Known issue: during daylight saving time it triggers an hour earlier than configured (issue 5204760). | S9 |
| ALPR retention | Configured on the ALPR Manager **Properties** page. **Known defect:** reads, hits and Patroller positions were not deleted after the retention period in 5.14.0.0 (issues 5249814 / KBA-79289); fixed in 5.14.0.1. | S9 [S35] |
| Log retention | See section 6. | S22 |

## 11. Maintenance mode [S1]

Documented procedures: **Configuring predefined reasons for maintenance mode**, **Setting entities to maintenance mode in Security Center**, **Enabling events for cameras in maintenance mode**, and **Setting Security Desk to maintenance mode**. Use these to suppress health noise during planned work.

## 12. Monitoring hooks (SNMP, syslog, API)

| Hook | Status |
|---|---|
| Syslog | Documented only for the **Access Manager** remote syslog server on **UDP 514**, and for Sharp units sending syslog on demand over UDP 514. **From 5.10.1.0 the Access Manager syslog port is no longer enabled by default.** [S3] |
| SNMP | **Not documented** in any retrieved source. Logged in `../known-gaps.md`. |
| API / events | The **Web-based SDK** role exposes SDK methods and objects as web services, with a separate **Streaming port** for events and configurable event selection. See `api-integration.md`. [S1] |
| Cloud health telemetry | SAMA reports to the Genetec cloud Health Service over TCP 443. [S3] |
| Email | An email server enables Watchdog notifications and the **Send an email** and **Email a report** actions (license option **Automatic email notification**). From 5.14.0.0 reports can be emailed directly from a reporting task without scheduling. [S1] [S9] |

## 13. What to collect before opening a support case

Always provide the **build number** from the **About** page of a client running on the Directory or expansion server; if it is not in the build-number tables you are most likely running a hotfix. [S13]

| Scenario | Collect |
|---|---|
| Any issue | Build number; Windows Application, System and **Genetec** event logs; dump files from `C:\ProgramData\Genetec Security Center [5.x]\Dumps`. [S22] [S21] |
| Reproducible functional issue | A console trace with the trace logger named by Technical Support, plus the exact time the issue occurred during the trace. [S22] |
| Crash or hang | A ProcDump full dump (`-ma`, plus `-h` for a hang) and the matching 32-bit and 64-bit .NET DLLs. [S22] |
| Network or streaming issue | A Wireshark or Dumpcap capture taken on the machine matching the issue. [S22] |
| Performance / hardware | Performance Monitor **Genetec - General** data collector set output. [S22] |
| Database issue | SQL `ERRORLOG` files; role **Database info** output (server version, schema version, event count, size on disk, free space). [S22] [S20] |
| MSMQ warnings | Database size, version and free disk; `mqsvc.exe` disk response time from Resource Monitor; MSMQ queue size and item count from `C:\Windows\System32\msmq` Storage folder properties. [S20] |
| Directory database corruption | A backup copy of the original database (create a **new** Directory database for testing - **do not overwrite the existing one**). [S21] |
| Before sharing a backup | Run the **Database Anonymization Tool** to strip PII. [S9] |
