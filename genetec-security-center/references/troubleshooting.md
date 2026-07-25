# Troubleshooting

Phase 2 section I, organised **symptom first**. Each symptom lists probable causes ordered by likelihood as presented in the source, the exact check, the resolution, and the source ID.

## Symptom index

| Symptom | Section |
|---|---|
| Clients cannot connect / main server is offline | 1 |
| Genetec Server service is stopped | 2 |
| Directory role is offline | 3 |
| Directory database is disconnected | 4 |
| Cannot log on to Server Admin | 5 |
| Forgotten Server Admin password | 6 |
| "Invalid license" in Server Admin | 7 |
| Archiver role is offline | 8 |
| Archiver database is not connected | 9 |
| Cannot add network drives for Archiver storage | 10 |
| Archiver cannot write to disk / stopped recording | 11 |
| Archiver performance is slow | 12 |
| Archiver is triggering MSMQ warnings | 13 |
| Video unit / camera is offline (red) | 14 |
| Cannot watch live video | 15 |
| Cannot watch playback video | 16 |
| Active Directory role problems | 17 |
| Security Desk or Config Tool freezes or disconnects | 18 |
| Client applications will not launch (Streamvault) | 19 |
| Genetec Web App inaccessible after upgrade | 20 |
| ALPR Manager in warning state or misbehaving | 21 |
| Installation and upgrade failures | 22 |
| Failover not working | 23 |
| SaaS-specific symptoms | 24 |

## 1. Clients cannot connect / main server is offline [S21]

| Order | Probable cause | Check | Resolution |
|---|---|---|---|
| 1 | License is no longer valid | Server Admin - is the license green? | Activate or reset the license from the Genetec Portal; contact Technical Support for a new one. |
| 2 | `Genetec Server` service not running | Windows Services | Start it. If it will not start, go to section 2. |
| 3 | Service logon user lacks database or Windows permissions | Sign in to SQL Server with SSMS as that user; confirm Windows rights with IT | Grant full permissions and restart `Genetec Server`. |
| 4 | Directory role not started | Server Admin - is Directory online? | **Directory > Start**. For detail: **Actions > Console > Commands > Directory Commands > Status**. If it still will not start, go to section 3. |
| 5 | Required ports closed or in use | `netstat -na | find"[PortNumber]"`; confirm with IT | Open the correct ports (see `network-ports.md`). |
| 6 | A Windows event stopped the service | `eventvwr.msc` - Application, System and **Genetec** logs; check `C:\ProgramData\Genetec Security Center [5.x]` for `Dumps` and `Logs` | Provide the logs and dumps to Technical Support. |

## 2. Genetec Server service is stopped [S21]

| Probable cause | Check | Resolution |
|---|---|---|
| Service logon failure | Try starting the service in Windows Services | Reset the service account password in the Computer Management console (**Users** folder, right-click the account), set the matching password on the service, start it. Repeat for `Genetec Watchdog`, which is a dependency. The Local System account password is managed by Windows. |
| Server out of CPU or memory | Task Manager **Performance** tab | Verify the server meets Security Center specifications; investigate the top CPU/RAM consumers; close unwanted applications. |
| Server out of disk space | Free space on the C: drive | Free space and restart `Genetec Server`; monitor disk space afterwards. |
| Unexpected restart from a power outage or Windows update | Event Viewer **System** log for **Event ID 41**: "The system has rebooted without cleanly shutting down first" | The SQL server or installation may be corrupted - contact Technical Support. |

## 3. Directory role is offline [S21]

| Probable cause | Check | Resolution |
|---|---|---|
| Directory database not connected | Server Admin - **Directory database** status should be OK (green) | Go to section 4. |
| License issue | Log on to Config Tool as Admin and check the **About** page for license errors | Remove an unlicensed entity you do not need, or contact Customer Service to update the license. |
| Certificate issue | Server Admin server page, **Secure communication** section - has the certificate expired? | Replace the expired certificate and restart `Genetec Server`. If a current certificate still fails, verify it was created per the guidelines. |
| Incorrect server timestamp | Windows date and time | Correct them. |

## 4. Directory database is disconnected [S21]

| Probable cause | Check | Resolution |
|---|---|---|
| Local database problems | Server Admin **Database server** field should show a local SQL server | In SSMS verify the instance name is correct and the SQL service host is online; **Management > SQL Server Logs**, double-click **Current** and inspect the Log File Viewer for credential or permission issues. In Server Admin: **Actions > Console > Loggers**, read the **Logs** panel. |
| Remote database connection | | Connect using the server's **IP address** instead of the SQL instance name; ensure remote database ports are open and reserved for SQL Server. |
| Incompatible database version | Server Admin **Database** status showing `Database version is higher than the current version` | Restore the database to a previous version, or install the correct Security Center version. |
| Service user lacks database rights | SSMS **Security > Logins >** right-click the user **> Properties**; check **Server roles** and **User mapping > Directory**. If the service runs as Local System, the SSMS user is `NT AUTHORITY\SYSTEM` | Add the required permissions (see `architecture.md` section 10). |
| Directory database is full | SSMS **Databases >** right-click **Directory > Properties > General > Space Available**. SQL Server 2025 Express caps at **50 GB**; earlier versions at **10 GB** | Contact Technical Support. |
| Directory failover misconfiguration | Event Viewer for `Event Source: GenetecDirectory.exe` / `Description: Unable to take the database lock, another Master Directory may be running on this database, restarting Directory service` | Restart `Genetec Server` on the failover server. |
| SQL transaction log (LDF) too big | SSMS **Properties > Files >** Database files - LDF should not exceed the MDF | Contact Technical Support. Related fix elsewhere in the docs: switch the recovery model to Simple, shrink the log, set a maximum size. [S20] |
| Corrupted Directory database | In Server Admin create a **new** Directory database to test whether the Directory starts clean. **Do not overwrite the existing database.** | If it starts clean, the original database has a configuration conflict or is corrupted. Inspect **Actions > Console > Loggers** and Event Viewer **Applications and Services Logs > Genetec**. Send Technical Support a backup copy of the original database. |

## 5. Cannot log on to Server Admin [S21]

Cause: the server certificate has expired **and** the HTTP port is disabled.

Check: open `GenetecServer.gconfig` (default `C:\Program Files (x86)\Genetec Security Center 5.x\ConfigurationFiles`) and look for `<ServerAdminService http="false" />`. `false` means the HTTP port is disabled.

Resolution: re-enable the HTTP port of the Security Center server, log on to Server Admin over HTTP, then update the certificate - Server Admin > select the server > **Secure communication > Select certificate >** choose a certificate **> Select > Save**. If HTTP is not disabled and you still cannot log on, contact Technical Support.

## 6. Forgotten Server Admin password [S23]

Set a temporary password in `GenetecServer.gconfig`, then change it properly in Server Admin.

1. Run Notepad **as administrator**, open `GenetecServer.gconfig` (64-bit: `C:\Program Files (x86)\Genetec Security Center 5.x\ConfigurationFiles`; 32-bit: `C:\Program Files\Genetec Security Center 5.x\ConfigurationFiles`; select **All Files (*.*)** if `.gconfig` is not associated with Notepad). **Back the file up first.**
2. Inside `<genetecServer>` set, depending on version:
   - 5.13.0.0 and earlier: `<password password="my_new_password" encrypted="false" />`
   - 5.13.1.0 and later: `<resetPassword input="my_new_password" updated="false" />`
3. Save and close. Do **not** set a blank or weak password even briefly - strength is not validated here.
4. Log on to Server Admin with the temporary password, then **Overview > Connection settings > Modify > Change password**: enter the old (temporary) password, the new password twice, **Save**, **Save**.

## 7. "Invalid license" error in Server Admin [S31]

Cause: usually hardware changes on the licensed server, but other factors are possible.

**CAUTION: the system does not function until a valid license is activated and applied - do this at a non-critical time.**

1. Close Server Admin.
2. Back up `License.gconfig` (64-bit `C:\Program Files (x86)\Genetec Security Center 5.x\ConfigurationFiles`, 32-bit `C:\Program Files\Genetec Security Center 5.x\ConfigurationFiles`).
3. Edit it so it contains only:

```xml
<?xml version="1.0" encoding="UTF-8"?>
<configuration>
<Licensing License="" ValidationKey="" />
</configuration>
```

4. Reset the computer license and activate the Security Center license again.
5. To roll back, copy the backup `License.gconfig` into `ConfigurationFiles`.

## 8. Archiver role is offline [S20]

| Order | Probable cause | Check | Resolution |
|---|---|---|---|
| 1 | Host server offline | Config Tool **System > Roles >** role **> Resources** - is the server icon red? | Ensure `Genetec Server` is running on that server and the expansion server has connected to the Directory; otherwise troubleshoot the server (section 1). |
| 2 | Incorrect NIC priority | Config Tool **Network view >** select the server **> Properties**; also Windows network settings | The NIC used by `Genetec Server` must be at the top of the NIC list in **both** Windows Control Panel and Config Tool. |
| 3 | Archiver ports closed or in use | `telnet <IP address> <port number>` (enable the Telnet Client Windows feature) or `tnc -computer (IP or DNS name) -port (port number)` | Open the ports and make sure nothing else uses them. |
| 4 | Antivirus or firewall blocking | Review antivirus and Windows Firewall exclusions | Apply the documented antivirus and Windows Firewall best practices. |
| 5 | A Windows process or application is affecting the role | `eventvwr.msc` (Application, System, Genetec); `C:\Program Data\Genetec Security Center [5.x]` then `Dumps` or `Logs` | Send the event logs and dump files to Technical Support. |
| 6 | Host server low on disk space | Free space on C: | Free space and restart `Genetec Server`. Ensure the archive database, backups and logs are not on C:. |
| 7 | High CPU or memory on the host | `taskmgr` | Verify the server meets specifications, investigate top consumers, close unwanted applications. |
| 8 | `Archiver.gconfig` corrupted or missing | Locate `Archiver.gconfig` in the ConfigurationFiles folder and confirm it is readable. If missing, regenerate: Server Admin > server **> Actions > Console > Commands > Archiver Agent commands > GenerateConfigFile** | If corrupted: move the bad file elsewhere as a backup; create a new Archiver role on the same server and database with the same retention period; once it connects, use the **Move Unit** tool in Config Tool to move video units to the new role; deactivate the old role and delete it once its retention period elapses. |

## 9. Archiver database is not connected [S20]

| Probable cause | Check | Resolution |
|---|---|---|
| Missing permissions | SSMS **Security > Logins >** right-click the user **> Properties**; verify **Server roles** and **User mapping > Archiver** | Grant the required roles (see `architecture.md` section 10). |
| Archiver database is full | Size limit is 10 GB in SQL Server 2008 Express and later | Upgrade SQL Express to Standard or Enterprise. Workarounds: create a new database, reduce the recording retention period, and contact support to find out why it filled. Databases can fill unexpectedly when cameras send too many events - set up monitoring for an unusually high event rate. |
| Transaction log (LDF) too big | LDF should not exceed the MDF | In SSMS switch the recovery model to **Simple**, shrink the transaction log, set a maximum size limit. |
| Remote database ports closed | TCP 1433 and UDP 1434 | Open them and reserve them for SQL Server. |

## 10. Cannot add network drives for Archiver storage [S20]

| Probable cause | Check | Resolution |
|---|---|---|
| Service user lacks share permissions | | Right-click the folder **> Properties > Sharing > Advanced Sharing > Share this folder > Permissions**, select the user or group (for example `MACHINE_NAME_ARCHIVER\admin`), set **Full Control > Allow**, **OK**. |
| Service user lacks read/write on the storage disk | Right-click the recording drive **> Properties > Security** | Grant read/write to the `Genetec Server` service user on the storage disk **and its subfolders** (**Properties > Security > Advanced**, or **Properties > Security > Edit**). |

## 11. Archiver cannot write to disk / stopped recording [S20]

| Probable cause | Check | Resolution |
|---|---|---|
| Storage drives not accessible (red in **Resources**) | Sign in to the server with the **same credentials the `Genetec Server` service uses** (confirm via `services.msc`), browse to the archive folder in Explorer (enable **Show hidden files, folders, and drives**) and create a simple text file. For remote drives, first confirm you can reach them at all - failure means denied access or a network fault. | If you cannot create the file you lack write privileges; ask your administrator. Repair network faults for remote drives. |
| Recording disk full | Compare free space against **Min. free space** on the Archiver **Resources** tab; look for **disk full** or **disk 80%** events in the Archiver logs (`C:\ArchiverLogs` by default). Occurs when another application consumed the reserved space, or when **Delete oldest files when disks are full** is not selected in **Resources > Advanced settings**. The Archiver re-evaluates disk space every **30 seconds**. | Enable **Delete oldest files when disks are full**; lower the **Automatic cleanup** threshold on the **Camera default settings** tab; lower the retention period; reduce **Min. free space** (keep it at least **0.2%** of total size); add storage drives. |
| Recording disk full due to orphan files | Orphan files exist on the drive but are unknown to Security Center, so neither **Automatic cleanup** nor **Delete oldest files when disks are full** can remove them | Use "Finding orphan files on your system", then delete them or re-integrate them into the database. |
| Missing read/write access | Right-click the recording drive **> Properties > Security** | Grant read/write to the `Genetec Server` service user on the disk and subfolders. |
| Disk hardware or software issues | Windows Device Manager for disk errors; Event Viewer for unusual messages; the storage vendor's diagnostic tool | Repair or replace per vendor guidance. |

Related known issue: if the NAS configuration is changed while the Archiver is in a bad network state, the Archiver may stop recording without warning - the timeline appears white as if archives exist but nothing plays back (issue 5111826, fixed in 5.14.0.1). [S10]

## 12. Archiver performance is slow [S20]

| Probable cause | Check | Resolution |
|---|---|---|
| Insufficient server specifications | Compare against the System Requirements Guide | Upgrade the server (see `version-matrix.md`). |
| Server low on memory because SQL Server takes it all | By default the SQL Server service uses all available RAM | Limit SQL Server maximum memory (512 MB on the minimum server profile). |
| Slow hard disk drives | Windows **Resource Monitor > Disk** write speed | Contact the storage provider to upgrade the disks. |
| Outdated drivers | Device Manager **> Network Adapters > Properties** and **> Disk drives > Properties** | Update NIC and disk drivers. |
| Archiver is handling motion detection for many cameras | Motion detection setting per video unit | Switch motion detection to **Unit** instead of **Archiver**; if not possible, reduce the number of units detecting motion and set them to record continuously. Software motion detection can cut capacity by up to 50%. [S5] |
| BIOS not set to Performance | Server BIOS | Set BIOS to **Performance**. |

## 13. Archiver is triggering MSMQ warnings [S20]

Symptoms - the Archiver role shows **yellow** and one or more of these appear:

- `Microsoft Message Queuing (MSMQ) is not running on the server___. Start the MSMQ service and restart the Archiver.`
- `Microsoft Message Queuing (MSMQ) is delayed on the server___. Last message took ___ to arrive.`
- `Archiver ___ on server ___ is unable to store messages in the Microsoft Message Queuing (MSMQ).`

Background: Security Center writes recordings straight to disk, but sends video metadata and linked camera events through MSMQ before inserting them into the Archiver database. This lets the Archiver keep recording while the database is unreachable - messages wait in the queue. **MSMQ is not used for archiving from an Auxiliary Archiver.**

| Warning | Cause | Resolution |
|---|---|---|
| MSMQ is not running | MSMQ was not enabled (the installer should have done it) | **Start > Control Panel > Programs and Features > Turn Windows features on or off**, select **Microsoft Message Queue (MSMQ) Server**, **OK**. |
| MSMQ is delayed | Messages have accumulated - slow database, slow disk response, or other causes | Contact GTAC with the data below. |
| Unable to store messages | The queue is full, so **archiving stops**. Either the Archiver database hit its size limit (10 GB in SQL Server 2008 Express and later) or the queue fills faster than the database can drain it. The "delayed" warning usually appears too. | Contact GTAC with the data below. |

Data to collect first:

- Archiver role database size, version and available disk space (**Resources > Database info**).
- Disk response time: Windows **Resource Monitor > Disk**, expand **Disk Activity** and read the response time for `mqsvc.exe`. **Above 50 ms is high; above 100 ms is critical.**
- MSMQ queue size: go to `C:\Windows\System32\msmq`, right-click the **Storage** folder **> Properties > General** and read **Size** and **Contains**. **The queue becomes full at 520 items or when the queue exceeds 1 GB - in both cases archiving stops.**

## 14. Video unit / camera is offline (red) [S20]

A red camera in the area view means the unit is offline or has lost communication with the Archiver, usually accompanied by a **Unit lost** event in Security Desk. Causes are an unstable network connection or a problem with the unit.

1. Ping it: Config Tool **Video** task, select the red unit, **Unit > Ping**. No reply means the unit is offline (broken, unplugged) or there is a network problem.
2. Once connected, open the unit's web page from the **Unit** menu - this also confirms whether your credentials are correct.
3. Reboot it: **Unit > Reboot**.
4. Verify the unit is supported and running certified firmware (Supported Device List).
5. Restart the controlling Archiver role - **all units on that Archiver go offline temporarily, so do this at a non-crucial time**: **Video** task, select the Archiver, **Maintenance > Deactivate role > Continue**, then **Maintenance > Activate role**.
6. Media Router problems prevent live and playback streams for recently added cameras: **Video** task, right-click **Media Router > Maintenance > Diagnose**, fix what it finds, then add the unit again.
7. Media Router connected to the wrong database: **Video** task, select **Media Router > Resources**; if the status is **Disconnected** or **Unavailable**, click **Create a database**, then add the unit again.
8. Still offline: contact GTAC.

## 15. Cannot watch live video [S20]

Possible causes: a slow network, a port connection problem, or the stream being dropped while redirected to Security Desk.

1. Wait to see whether the camera connects.
2. After 10 seconds click **Show diagnosis** in the tile or press **Ctrl+Shift+D**, expand the drop-down and save the details. The **Media Player states** localise the latency; you can also get the per-state breakdown from the `MediaPlayer Initialization` logger.

| Media Player state | Meaning and what to check |
|---|---|
| Initializing | The player is preparing resources. |
| Connecting to Media Router | Getting the stream's network location. A bad network configuration or slow Media Router causes time here. A federated camera may require the Media Router to query the federated Media Router. |
| Connecting to Archiver and redirector | Requesting video. Failure here means a problem with the role or the server - see the "Impossible to establish video session with the server" error. Each additional redirector adds to call-up time. |
| Requesting live stream | Connection established; the player requests the stream. **If no stream arrives within 15 seconds the Media Player resets and retries.** Check for a firewall, slow network or third-party software blocking the stream. A camera not yet requested or recorded may add delay. |
| Analyzing the stream | Detecting video format and key frames. If the camera is unresponsive here, check whether it supports on-demand key frame requests - unsupported requests make the player wait for the next key frame. |
| Requesting security information | Fetching decryption keys if the stream is encrypted. |
| Decoding stream | First key frame received; sent to AvCodec, Intel or NVIDIA to decode and render. Codec configuration (H.264, MJPEG, HEVC) affects this; adjust the Security Desk anti-jitter buffer to reduce live latency. |
| Streaming | Frames are visible. |

3. Confirm the unit is online (section 14) and pingable, and that credentials are correct.
4. Verify the unit and firmware are supported.
5. Change the camera's **Connection type**: **Video** task, select the camera, **Video** tab, **Network settings > Connection type**, pick a different type, **Apply**.
6. Try playback from the Security Desk **Archives** task on the most recent archive. If playback works, continue; if nothing plays, contact GTAC.
7. Try viewing from a Security Desk running on the expansion server that hosts the Archiver. If that works, the problem is redirection from the Media Router to your Security Desk.
8. Confirm no firewall blocks the video ports (see `network-ports.md`).
9. Verify each network in **Network view > Properties** (IP prefix, subnet mask, routes, network capabilities) and **Apply** any corrections.
10. Force a different connection type in Security Desk: **Options > General > Network options > Network > Specific**, choose another network, **Save**, restart Security Desk. Repeat for other networks.
11. Still failing: click **Show video stream status** in the tile and troubleshoot the stream, then contact GTAC.

## 16. Cannot watch playback video [S20]

1. Try live video from the same camera. If live works, continue; if not, treat it as a network issue (section 14).
2. In the **Archives** task, search different dates and times, generate the report and try to play. Repeat with other cameras on the same Archiver. If some archives play, continue; if none play, skip to step 4.
3. Verify the unit and firmware are supported.
4. Try the **Archives** task on another Security Desk **and** on the server running the Archiver role. If it works there, the problem is redirection from the Media Router to your Security Desk.
5. Confirm the video ports are open.
6. Still failing: contact GTAC.

## 17. Active Directory role problems [S36]

| Symptom | Cause | Resolution |
|---|---|---|
| Active Directory role not listed when creating a role in Config Tool | Not logged on as **Admin** | Log on with the Admin account. |
| Active Directory role offline (red) | Wrong connection information | **System > Roles >** role **> Properties**: verify the hostname or IP of the Active Directory server. The Security Center server hosting the role must be able to reach it. |
| Active Directory role offline (red) | Credential problem - status shows `Error: Connection to Active Directory denied. Check service permissions` or `Server invalid credentials` | If **Use Windows credentials** is selected, the role uses the `Genetec Server` service logon; change it in Windows Services (**Properties > Log On > This account**). Otherwise supply correct credentials on the role's **Properties** tab. The user must have read access to the Active Directory server, be a domain member, and have local administrator rights. |
| Active Directory users not listed in **User management** | Groups missing from **Synchronized groups**, or **As user group** not selected | **System > Roles >** role **> Properties**: import the groups and select **As user group** beside each group name. |

## 18. Security Desk or Config Tool freezes or disconnects [S33]

Applies to Security Center 5.10 - 5.14. Symptom: Security Desk (or Config Tool) loses its connection when another instance connects to the Directory.

Cause: each client is identified by a unique GUID. Cloning or ghosting a workstation from an image with the client pre-installed duplicates the GUID, so the Directory treats both machines as the same workstation and disconnects one.

Resolution on the affected computers: stop Security Desk and Config Tool, go to `C:\Users\<username>\AppData\Local\Genetec Security Center 5.x`, add a `.bak` extension to `SecurityDesk.Workspace.Settings` and `ConfigTool.Workspace.Settings`, then restart the applications.

Other documented performance symptoms: opening the **Cardholder management** task on a system with many credentials raises RAM use and causes slow response or freezing (5.13.1.0 and later; hotfix available for 5.13.2.3, fixed in 5.13.3.1 and 5.14.0.0) [S40]; Security Desk and Config Tool take a long time to load and display a large camera list (issue 5112328) [S9]; Security Center freezes or crashes on a text search in the **System status** task and Config Tool crashes when saving changes in the **Network** task (issues 5111806 and 5111804, fixed in 5.14.0.1) [S10].

## 19. Client applications will not launch (Streamvault appliances)

| Symptom | Applies to | Cause | Resolution |
|---|---|---|---|
| Security Desk and Config Tool crash after loading to 100% | Streamvault Control Panel 3.2.1 | DLL conflict with Security Center | Uninstall Streamvault Control Panel 3.2.1; delete all folders in `C:\Program Files (x86)\Genetec SV Control Panel\Control Panel` (for example `Notification_1`, `Notification_2`) - if files are in use, stop the `GenetecServer` service, delete, then start it; install Streamvault Control Panel 3.1 from the GTAP Product download page. Resolved in Streamvault Control Panel 3.2.2. GTAP and GUS downloads were reverted to 3.1. [S37] |
| Config Tool and Security Desk freeze on the loading screen; the homepage never appears (unless launched from the SV Control Panel or run as administrator, which does not help a non-administrator user) | All Security Center versions on appliances manufactured 19 September - 9 October 2025 inclusive | Code defect | Upgrade to **Streamvault service 1.4.1** through GUS or the GTAP Product download page. Resolved in Streamvault service 1.4.1. [S38] |
| Config Tool and Security Desk homepages do not load on Streamvault appliances | | | Also tracked as KBA-79266. [S38] |

## 20. Genetec Web App inaccessible after upgrade [S7]

Cause: after installing 5.13 or later on the primary server, the **Web App Server** role must be hosted on a server that also runs 5.13 or later. Hosted on an older expansion server, Web App is unavailable to users.

Resolution: move the Web App Server role to a server running 5.13+ that meets the Web App system requirements, **or** upgrade the expansion server hosting it.

Related known issue: a Web App Server role hosted on a backward expansion server connected to a 5.13.0.0+ Directory does not start and shows no error message (issue 4066835). [S9]

## 21. ALPR Manager in warning state or misbehaving

| Symptom | Applies to | Cause | Resolution |
|---|---|---|---|
| ALPR Manager in a warning state after upgrade; fails to connect to its database | Upgrades from any version earlier than 5.13.0.0 up to 5.13.0.0 | A timing mismatch in initialisation order makes the role skip steps and fire an event prematurely, causing a null reference exception that blocks the database connection and schema upgrade | **Manually deactivate and reactivate the ALPR Manager role**, which lets the database connect and perform the schema upgrade. Fixed in 5.13.0.1 and later. [S34] |
| License plate reads exceeding the retention period are not deleted | Systems upgraded from 5.13.3.2+ to 5.14.0.0. **Not** affected: upgrades from 5.13.3.0 or 5.13.3.1 to 5.14.0.0, upgrades from 5.13.x to 5.14.0.1+, and systems staying on 5.13.x | Retention settings are not applied | Upgrade to 5.14.0.1. Contact Genetec support for immediate help restoring retention behaviour. Watch for unexpected storage consumption and disk capacity issues, and for breaches of internal or regulatory ALPR retention policy. [S35] |
| ALPR Manager consumes a large amount of memory | 5.11.3.0 | Memory leak when Patroller is offline and its associated hotlists are updated | Do not modify a hotlist while an associated Patroller is offline. Resolved in 5.11.3.1. [S39] |
| Patroller offload fails after upgrading to 5.14.0.0 when Patroller encrypts offloaded data | 5.14.0.0 | Documented limitation 4858619 | Restart the ALPR Manager role. [S9] |
| Devices in the ALPR Manager role do not reconnect after connecting to a new Archiver | | Documented limitation 2483593 | Restart the ALPR Manager role. [S9] |
| Cloudrunner export does not connect or send data | | Outgoing ports blocked | Have the network administrator unblock outgoing ports **5671 and 5672** (limitation 4340455). [S9] |

## 22. Installation and upgrade failures

Full detail is in `install-upgrade.md` section 17. Quick map:

| Symptom | See |
|---|---|
| Silent install fails with error **1603** | `/ISInstallDir` trailing backslash [S28] |
| GUS upgrade fails with error **1603** | Install path trailing backslash [S29] |
| `0x800f081f` installing .NET Framework | Enable .NET 3.5 with DISM from Windows media [S7] |
| `0x800f0906` installing .NET Framework on Windows Server 2012 / 2012 R2 | Alternate source path via Group Policy; note that these OS versions are unsupported from 5.12.0.0 [S30] [S9] |
| Installation interrupted by missing cached MSI files | Microsoft `FixMissingMSI.exe` [S7] |
| "Setup detected blocked file(s) in the download package" | `streams.exe -d <filename>` [S7] |
| One or more services failed to install | `sc create` / `sc config` commands [S7] |
| Cameras stop working after install with default security | Reset the authentication scheme or turn off **Refuse basic authentication** [S7] |
| Omnicast Federation role disabled and red after upgrade | Delete the roles and uninstall the compatibility packages [S7] |

## 23. Failover not working [S7] [S1]

| Symptom | Cause | Resolution |
|---|---|---|
| Role failover does not occur after a staged upgrade | Not all servers assigned to the role run the same major version | Upgrade all servers assigned to the role. |
| Clients unbalanced across Directory servers; high load on one server | Directory servers were started with long delays between them | Start `GenetecServer` concurrently on all Directory servers. |
| `Unable to take the database lock, another Master Directory may be running on this database, restarting Directory service` | Directory failover configuration issue | Restart `Genetec Server` on the failover server. |
| Two Archiver roles both stop archiving after one primary fails | The two roles share the same logical disk for archive storage | Give each server two logical disks and assign one disk per Archiver role. |
| Archiver role A cannot archive on its standby servers | Its secondary is shared with higher-priority role B and both primaries failed together | Do not share the secondary when the role does not have the highest archiving priority; share the tertiary instead. |
| Media Router cannot connect to its failover servers when the primary is down | Defect (issue 5222921) | Fixed in 5.14.0.1. [S10] |
| Archiver role fails to start after restarting the Directory server | Defect (issue 5189782) | Fixed in 5.14.0.1. [S10] |
| Archiver agent starts without access to the Directory server, so its cameras do not record | Known issue 5051880 | Listed as a 5.14.0.0 known issue and as resolved in 5.14.0.1. [S9] [S10] |

The Administrator Guide also contains a dedicated **Troubleshooting failover** topic that was not retrieved - logged in `../known-gaps.md`.

## 24. SaaS-specific symptoms [S19] [S17]

The Security Center SaaS Troubleshooting Guide contains exactly two topics: **Axis device connectivity issues in Security Center SaaS** and **Okta user synchronization issues in Security Center SaaS**. Their bodies were not retrieved - logged in `../known-gaps.md`.

Related SaaS Classic KBAs identified by title only (contents not retrieved): Synergis Cloud Link and Cloud Link Roadrunner going offline after 10 days of enrolment (KBA-79126), Synergis Cloud Link and Cloud Link Roadrunner units remaining offline (KBA-79183), NTP server configuration lost after a Synergis Softwire upgrade (KBA-79192), and PIN synchronization issues with Axis Powered by Genetec units (KBA-79217).

First checks for any SaaS connectivity symptom, from the pre-deployment requirements: latency to the nearest Azure data centre must be **150 ms or less**; the outbound endpoint and port list in `network-ports.md` section 10 must be allowed through the firewall and proxy; and on-premises Federation into SaaS requires outbound **TCP 5500** from the Directory to `*.gsc-cloud.com`.
