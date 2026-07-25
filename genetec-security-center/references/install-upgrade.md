# Install and upgrade

Phase 2 section E. All content is for **5.14.0.0** unless stated. Primary source [S7] (Installation and Upgrade Guide 5.14.0.0), with [S8] for 5.13.3.0, [S9]/[S10] for release-note impacts and [S13] for build numbers.

## Contents

1. Pre-installation checklist
2. Prerequisites
3. SQL Server permissions
4. Installation packages and modes
5. Reducing the client package
6. Silent installation - setup options
7. Silent installation - Security Center options
8. Sample commands
9. Silent uninstall, Drivers and SDK
10. Patch (cumulative update) installation
11. Licensing activation
12. Supported upgrade paths
13. Pre-upgrade checklist
14. Backward compatibility
15. Upgrade procedures
16. Backup and restore
17. Installation troubleshooting

## 1. Pre-installation checklist [S7]

**CAUTION from the guide:** do not use the image of a configured machine to install Security Center Server on similar machines. The installer creates unique IDs on first run, stored in configuration files and the Directory database; duplicated IDs conflict with entities that share the identifiers and can make the system unusable.

| # | Task |
|---|---|
| 1 | Read the release notes for known issues and limitations. |
| 2 | Review the System Requirements Guide (hardware and software). |
| 3 | Read the installation prerequisites for the release. |
| 4 | Read the best practices for configuring Windows Firewall for Security Center. |
| 5 | Note that Security Center is **not a life safety platform**; comply with applicable laws and standards if integrating life safety components. |
| 6 | List the computers in the system and the components each needs: Security Center Server (main or expansion), Security Center Client (Config Tool, Security Desk or both), SQL Server (Express, Standard or Enterprise). **Server names must be 15 characters or fewer** - longer names are truncated and cause errors when the system accesses those servers. Dedicate system computers to Security Center components only. |
| 7 | Verify network connections between servers, workstations and units; ensure required ports are open and redirected for firewall and NAT. |
| 8 | Verify unicast and multicast settings. Multicast works by default if the network supports the load, but if multicast is the **only** configured protocol Security Center cannot fall back and video cannot be recorded when multicast is blocked. |
| 9 | Have administrative privileges, or run `setup.exe` as administrator. Windows domain administrator rights may be needed for databases and storage. |
| 10 | Grant the service users the necessary SQL Server permissions. |
| 11 | Install SQL Server yourself if implementing role failover or VSS operation. |
| 12 | Download the installation package from the Genetec Portal Product Download page. |
| 13 | Unblock any blocked files in the downloaded package. |
| 14 | Have the System ID and password ready (from the **Security Center License Information** document sent by Genetec Inside Sales or Customer Service). |
| 15 | Install Security Center. |

## 2. Installation prerequisites for 5.14.0.0 [S7]

Found in the installation package under `SC Packages`, in separate subfolders.

| Prerequisite | 32-bit Client | 32-bit Server | 64-bit Client | 64-bit Server |
|---|---|---|---|---|
| ArcGIS Runtime 200 | yes | yes | yes | yes |
| ASP.NET Core Runtime 8.0.18 | | | yes | |
| Microsoft .NET Core 8.0.18 - Windows Server Hosting | | yes | | yes |
| Microsoft .NET Core 9.0.7 - Windows Server Hosting | | yes | | yes |
| Microsoft .NET Framework 4.8 Full | yes | yes | yes | yes |
| Microsoft System CLR Types for SQL Server 2019 v.15.0.2000.5 | | | yes | yes |
| Microsoft Visual C++ 14.44.35211.0 Redistributable (x64) | | | yes | yes |
| Microsoft Visual C++ 14.44.35211.0 Redistributable (x86) | yes | yes | | |
| .NET Core Desktop runtime 8.0.18 - x64 | | | yes | yes |
| .NET Core Desktop runtime 9.0.7 - x64 | | | | yes |
| MSMQ 3.0 and up (Windows Feature) | yes | yes | yes | yes |

MSMQ version depends on the Windows version. Security Center also requires the **.NET Framework 3.5** Windows feature, which the installer turns on by default. [S7]

## 3. Granting SQL Server permissions [S7]

Skippable if you use the default local SQL Server Express instance. Service users who are not Windows administrators and are not members of `sysadmin` need `VIEW SERVER STATE`.

Minimum server-level roles: `dbcreator`, `processadmin`, `public`.
Minimum database-level roles: `db_backupoperator`, `db_datareader`, `db_datawriter`, `db_ddladmin`, `public`.

Procedure: connect with SQL Server Management Studio, add the Security Center service users to SQL Server **Logins** and assign the roles above, then for each user either run

```sql
GRANT VIEW SERVER STATE TO [login name]
```

or grant it manually: right-click the database instance > **Properties > Permissions**, select the login or role, then on the **Explicit** tab select **Grant** beside **View server state**.

See `architecture.md` section 10 for the full per-role permission matrix from the Hardening Guide.

## 4. Installation packages and modes [S7]

| Package | Contents |
|---|---|
| `SecurityCenterWebSetup.exe` | Web installer. Small wizard with no software packages; connects to Genetec servers and downloads only the components for the features you select. Can create a **custom installation bundle** - but only if you choose that option *during* the install or upgrade; you cannot re-run web setup afterwards to create it. The bundle only replicates the same install on machines with the same Windows configuration. |
| Full installation package | Standalone, for machines without internet. Contains `Security Center Setup.exe` (in `SC Packages`), the `SC Packages` folder with all components and prerequisites, and a `Documentation` folder with PDF guides and release notes. |
| Security Center 5.14 Documentation | Installs the F1 help (`.exe` files) and the Hardening Guide PDF locally. Updatable through GUS. |
| Security Center Drivers 14.x.y | Required to integrate video devices. Reinstall with `Genetec Security Center Drivers 14.x.y.msi` from `SC Packages` if removed - otherwise video units stop working and turn red in Config Tool. Do not install a Drivers package older than the one bundled with your Security Center package. Updatable through GUS. |

Modes: **wizard mode** (web or standard version) and **silent mode**. The installer UI is available in English and French; the software itself installs in more than twenty languages.

**Limitation:** the Security Center Installer does not support mapped drives in path specifications.

## 5. Reducing the package size for client-only installs [S7]

The full standalone package is roughly **4.77 GB**. For client-only installs:

1. Download and unzip the full package.
2. Delete `Documentation` (saves about 21 MB).
3. In `SC Packages`, delete `SQLExpress` (saves about 544 MB).
4. If Genetec Video Player is not needed, delete `Genetec Video Player` (saves about 1.04 GB).

Then use one of these documented commands:

```
"Security Center Setup.exe" /silent FEATURESET=CLIENT AGREETOLICENSE=Yes
"Security Center Setup.exe" /silent FEATURESET=CUSTOM AGREETOLICENSE=Yes /ISFeatureInstall=ConfigTool,SecurityDesk,AccessControlMustering
"Security Center Setup.exe" /silent FEATURESET=CUSTOM /ISFeatureInstall=SecurityDesk,GVP AGREETOLICENSE=Yes
```

## 6. Silent installation - setup options [S7]

Syntax: `<setup_exe> <options> <SC_options>` where `<setup_exe>` is `"Security Center Setup.exe"` (in `SC Packages`) or `SecurityCenterWebSetup.exe`. Setup options are **case-sensitive**; Security Center options are all uppercase.

Preparation: install the prerequisites manually first (the installer may reboot the machine), apply the latest Windows updates, and pre-create any non-default service account - it must be in the Administrators group and hold the **Log on as a service** privilege.

**Limitations:** you cannot update the license in silent mode (run Server Admin afterwards); a command line is limited to **850 characters** (shorten the installation path to save space); mapped drives are not supported; silent options are supported for major and minor releases only, not patch releases (see section 10).

| Setup option | Description |
|---|---|
| `FEATURESET` | `CLIENTSERVER` (default) installs SERVER and CLIENT. `CLIENT` installs Config Tool, Security Desk, Genetec Video Player, Access Control Mustering plugin and extensions. `SERVER` installs Server, Automation Manager, Mobile Server, Web App Server, plugins and extensions. `CUSTOM` is used with `/ISFeatureInstall`. |
| `/ISFeatureInstall` | Selects features with `FEATURESET=CUSTOM`: `ConfigTool`, `SecurityDesk`, `GVP`, `AccessControlMustering`, `Server`, `CertSigning`, `Clearance`, `SynergisIntrusion`. Replaced by `FEATURESET`; for backward compatibility, used alone `Client` means `FEATURESET=CLIENT` and `Server` means `FEATURESET=SERVER`. |
| `/ISInstallDir` | Root folder for the product subfolder. Default `C:\Program Files (x86)\Genetec Security Center 5.14`. Quote paths containing spaces. **CAUTION: the path cannot end with a trailing backslash - this causes a fatal silent-install failure** (see [S28]). |
| `/silent` | Run with no user interaction. |
| `/DebugLog<FilePath\LogFileName>` | Installation log file path; the folder must already exist. By default logs go to `%ALLUSERSPROFILE%\Genetec\Installation\Security_Center_5.14`. |
| `/log<FolderPath\>` | Enables log files in the given existing folder. |
| `/language:` | Installer language, immediately followed by the four-digit code with no space. `/language:1033` English (default), `/language:3084` French. |

## 7. Silent installation - Security Center options [S7]

Syntax `<option>=<value_list>` with no spaces around `=`. Comma-separate multi-values; wrap value lists containing spaces in `\"` (a backslash-escaped double quote). **All servers on a system share the same password, so use only `MAINSERVER_PASSWORD` for both main and expansion server installs.**

| Option | Description |
|---|---|
| `ACTIVATIONCODE` | Activation code allowing SAMA to collect system data. Used with `SAMA_COLLECTPOLICY=On`. |
| `AGREETOLICENSE` | **Mandatory.** Only `Yes` is accepted; the install fails if omitted. |
| `ALLOWSQLUPGRADE` | `0` do not upgrade (default), `1` upgrade the database server to SQL Server 2022 Express Advanced if the OS supports it (64-bit Windows 11 and Windows Server 2016+). Back up databases first. If `1` and SQL is in mixed mode you must also pass `GLOBAL_SERVER`, `SQLSERVER_AUTHENTICATION=1`, `SQLSERVER_USERNAME` and `SQLSERVER_PASSWORD` or the install may fail. Ignored when `SKIPSQLVALIDATION=1`. |
| `COLLECTPOLICY` | `On`, `Anonymous`, or `Off` for the Product Improvement Program. **Mandatory when installing the main server on a clean machine**; ignored for expansion servers and clients. |
| `CONFIGURATION_SETTINGS` | Handling of existing `ConfigurationFiles\*.gconfig`: `KeepExistingSettings` (default, only if 5.14 files exist), `DeployNewSettings`, `UpgradeOldSettings` (only if older-major-version files exist; the most recent older version is used). Applies to fresh installations only - upgrades always upgrade current settings. |
| `CREATE_FIREWALL_RULES` | `1` create Windows Firewall exceptions (default), `0` do not. |
| `DATABASE_AUTOBACKUP` | `1` back up the Directory database after the software upgrade but before the database upgrade (default when the last backup is more than one day old); `0` do not. Configuration files are backed up to the same folder. Default folder `C:\SecurityCenterBackup` on the SQL Server machine. |
| `DATABASE_SERVER` | Alias of `GLOBAL_SERVER`, kept for backward compatibility. |
| `DEACTIVBASIC` | `1` basic camera authentication disabled (default), `0` enabled. |
| `GLOBAL_SERVER` | Database server for all default roles. Default `(local)\SQLEXPRESS`. Examples: `GLOBAL_SERVER=BLADE32\SQLServerEnterprise`, `GLOBAL_SERVER=MyDbName.database.windows.net`. |
| `LANGUAGECHOSEN` | Security Center UI language code. English 1033, French 3084, German 1031, Spanish 1034, Arabic 1025, Japanese 1041, Simplified Chinese 2052, Traditional Chinese 1028, Brazilian Portuguese 2070, Russian 1049, Italian 1040, Dutch 1043, Polish 1045, Korean 1042, Turkish 1055, Swedish 1053, Norwegian 1044, Finnish 1035, Danish/others per guide. Invalid codes fall back to English; if omitted, the installer language is used. |
| `MAINSERVER_ENDPOINT` | Name or IP of the main server, for expansion server installs. |
| `MAINSERVER_PASSWORD` | **Mandatory for server installs.** Must be at least 8 characters with at least one uppercase, one lowercase, one numeric and one special character, and no spaces or double quotation marks. |
| `PRODUCT_UPDATES` | `true` automatic update check on (default), `false` off. |
| `REBOOT` | `F` force reboot, `S` suppress all except ForceReboot, `R` suppress Windows Installer reboots (default). |
| `SAMA_COLLECTPOLICY` | `On` (requires `ACTIVATIONCODE`), `Anonymous` (default), `Off`. |
| `SECURE_COMMUNICATION` | `1` enforce Directory authentication, `0` not enforced (default). |
| `SERVER_TYPE` | `Main` install Genetec Server with Directory (default), `Expansion` without Directory. |
| `SERVERADMIN_PORT` | HTTP port for web-based Server Admin. Guide states the default is 5500. |
| `SERVICEUSERNAME` / `SERVICEPASSWORD` | Service account. Create the account first. Example `SERVICEUSERNAME=.\admin`. For a gMSA: `IS_GMSA_SERVICE_ACCOUNT=1 SERVICEUSERNAME=domain\myGmsaUser$` - the gMSA name must always end with `$`. Double quotation marks cannot be part of a password but can wrap one containing a space. |
| `SKIP_FORCE_CLOSE_CLIENTS` | `1` force close Security Desk and Config Tool during silent install (default), `0` leave them running. |
| `SKIPSERVICESTART` | `SKIPSERVICESTART=Y` prevents services starting after install (useful before applying hotfixes). Afterwards run `NET START GenetecServer` and `NET START GenetecWatchdog`. |
| `SKIPSQLVALIDATION` | `1` skip connecting to SQL Server to validate its version. Turns off `ALLOWSQLUPGRADE`. |
| `SQLSERVER_AUTHENTICATION` | `0` Windows authentication (default), `1` mixed mode - then also pass `SQLSERVER_USERNAME` and `SQLSERVER_PASSWORD`. |
| `SQLSERVER_GROUP` | `ExistingServer` (default), `None` (expansion server without a database), `NewServer` (optionally with `SQL_INSTANCE_NAME`, else creates `(local)\SQLEXPRESS`), `AzureServer` (must be used with `GLOBAL_SERVER`). |
| `UNINSTALL_EARLIER_CLIENTS` | `1` automatically uninstall earlier client versions (default), `0` do not. Applies only when clients are installed without server functionality. |
| `UPGRADE_DATABASE` | `Y` (default) or `N` - automatically upgrade the Directory database. Ignored if no database exists. |
| `WEBSERVER_PORT` | HTTP port for web-based Server Admin. Guide states the default is 80. |

Note: the guide lists both `SERVERADMIN_PORT` (default 5500) and `WEBSERVER_PORT` (default 80) as "the HTTP port for the web-based Server Admin". This inconsistency is recorded in `../known-gaps.md`.

## 8. Sample installation commands [S7]

Full server plus clients in English, new SQL Express instance, logs to `C:\MyLogs`, data collection on:

```
"Security Center Setup.exe" /silent /debuglog"C:\MyLogs\Install.log" /log"C:\MyLogs\" FEATURESET=CLIENTSERVER AGREETOLICENSE=Yes COLLECTPOLICY=On MAINSERVER_PASSWORD=ServerPwd-123 SQLSERVER_GROUP=NewServer
```

Main server only, no clients, anonymous data collection:

```
"Security Center Setup.exe" /silent FEATURESET=SERVER AGREETOLICENSE=Yes COLLECTPOLICY=Anonymous MAINSERVER_PASSWORD=ServerPwd-123 SQLSERVER_GROUP=NewServer
```

Security Desk and Config Tool only:

```
"Security Center Setup.exe" /silent /debuglog"C:\MyLogs\Install.log" /log"C:\MyLogs\" FEATURESET=CUSTOM /ISFeatureInstall=ConfigTool,SecurityDesk AGREETOLICENSE=Yes
```

Expansion server, no SQL Server, custom path:

```
"Security Center Setup.exe" /silent FEATURESET=SERVER /ISInstallDir="c:\GENETEC_PATH" AGREETOLICENSE=Yes SERVER_TYPE=Expansion MAINSERVER_PASSWORD=ServerPwd-123 SQLSERVER_GROUP=None
```

Complete install in French:

```
"Security Center Setup.exe" /silent FEATURESET=CLIENTSERVER /language:3084 AGREETOLICENSE=Yes SQLSERVER_GROUP=NewServer COLLECTPOLICY=Off MAINSERVER_PASSWORD=ServerPwd-123
```

Client and server against an Azure SQL database:

```
"Security Center Setup.exe" /silent FEATURESET=CLIENTSERVER /language:3084 AGREETOLICENSE=Yes COLLECTPOLICY=On MAINSERVER_PASSWORD=ServerPwd-123 SQLSERVER_GROUP=AzureServer SQLSERVER_AUTHENTICATION=1 GLOBAL_SERVER=MyDbName.database.windows.net SQLSERVER_USERNAME=scdbadmin SQLSERVER_PASSWORD=SeCret123!
```

Server installation examples assume SQL Server is not yet installed; to use an existing server pass `SQLSERVER_GROUP=ExistingServer` or `SQLSERVER_GROUP=AzureServer`, and set `GLOBAL_SERVER` if the local instance is not `(LOCAL)\SQLEXPRESS`.

## 9. Silent uninstall, Drivers and SDK [S7]

Uninstall (run from `SC Packages`):

```
"Security Center Setup.exe" /silent /remove
```

Drivers (separate package from your Genetec representative):

```
setup.exe /s /v"/qn /l*v "<msiLog>" <restart_option>"
```

`<restart_option>` is `RESTART_GENETEC_SERVER=1` (default) or `RESTART_GENETEC_SERVER=0`; if you choose 0 you must restart Genetec Server later for the new drivers to take effect. The MSI log folder must already exist.

SDK (separate package):

```
setup.exe /debuglog<setupLog> /s /v"/qn /l*v <msiLog> <SDK_options>"
```

| SDK option | Description |
|---|---|
| `AGREETOLICENSE` | Mandatory; only `Yes` accepted. |
| `CREATE_FIREWALL_RULES` | `1` (default) or `0`. |
| `INSTALLDIR` | Default `[ProgramFilesFolder]Genetec Security Center <version> SDK`. |

Sample:

```
setup.exe /debuglog"C:\Users\Public\prereqinstall.log" /s /v"/qn /l*v "C:\Users\Public\sdkmsi.log" AGREETOLICENSE=Yes CREATE_FIREWALL_RULES=0 INSTALLDIR="C:\NewFolder""
```

## 10. Patch (cumulative update) installation [S10]

The patch must be installed on **all** Security Center 5.14 computers with Server or Client installed unless Genetec specifies otherwise. Prerequisite: Security Center 5.13.3.0 or later installed, plus administrator privileges (the 5.14.0.1 notes state this for both the interactive and silent procedures).

Interactive: download from the Genetec Portal (**Technical Assistance > Product Download > Download Finder > Security Center**, then the **Cumulative Updates** section), exit all Genetec applications, double-click `Genetec Security Center Update 5.14.0.1.exe`, unzip (default `C:\Genetec`), then right-click the extracted `.exe` and **Run as administrator**, click **Update**, then **Finish**.

Silent:

```
"NAME_OF_THE_PATCH.exe" /s /v"/qn"
"Patch release for Genetec Security Center 5.14.exe" /s /v"/qn"
"C:\Genetec\Patch release for Genetec Security Center 5.14.exe" /s /v"/qn"
```

Verify with **Control Panel > Programs > Programs and Features > View installed updates**.

Uninstalling a patch stops the `Genetec Watchdog` and `Genetec Server` services on all servers. Afterwards set both services' Startup Type to **Automatic** and restart them manually on every server.

## 11. Licensing activation [S1]

Activation is required on the main server after installing, or after promoting an expansion server to main. Server Admin is reached at `https://computer:port/Genetec` (or the Start-menu shortcut on the main server).

**Web activation** (recommended): Server Admin **Overview > License > Modify > Web activation**, enter **System ID** and **Password** (from the Security Center License Information document), then **Activate**. A forgotten system password can be reset from the Genetec Portal **Systems** page using **Reset password** - only some users have that permission.

**Manual activation** (no internet): Server Admin **License > Modify > Manual activation > Save to file** produces `validation.vk`, a hexadecimal validation key that uniquely identifies the server. On an internet-connected machine sign in to `https://www.genetec.com/portal`, choose **Manage my licenses**, find the system by **System ID**, then **License content > Activate license > Continue**, drop the `.vk` file, **Submit**, and **Download license** (default name `<systemID>_Directory_License.lic`). Back in Server Admin, paste the content or browse for the `.lic` file and click **Activate**.

**Reapplying** a license (after adding camera connections or extending expiry) does not require reactivation. With multiple Directory servers configured for failover, reapply in **Config Tool** instead of Server Admin.

You **cannot** update the license in silent mode. [S7]

## 12. Supported upgrade paths to 5.14.0.0 [S7]

| Path | From |
|---|---|
| **Direct** | 5.13.x.y, 5.12.x.y, 5.11.x.y |
| **Two-step** | 5.10.x.y, 5.9.x.y, 5.8 GA and all SRs - first upgrade to the latest 5.11 release, then directly to 5.14.0.0 |
| Contact Genetec | 5.7 and earlier |

A **major version** is indicated by zeros in the third and fourth positions (X.Y.0.0), adds features, behavioural changes, SDK capabilities, new device support and performance improvements, and **requires a license update**. Major versions are compatible with up to three previous major versions in backward compatibility mode.

## 13. Pre-upgrade checklist (from an earlier major version) [S7]

| # | Task |
|---|---|
| 1 | Read the release notes for known issues and limitations. |
| 2 | Review the backward compatibility requirements. |
| 3 | Have the service logon username and password for all servers, and the name of the database server hosting the Directory database. |
| 4 | Back up the Directory and role databases to a secure location separate from the main server. |
| 5 | Close all Microsoft Management Console applications (Services, Event Viewer, and so on) - they can lock Security Center services and prevent them being updated. |
| 6 | If using Global Cardholder Management and the GCS role, review the sharing host/guest compatibility limits. |
| 7 | **CAUTION:** if you have an Active Directory role, ensure the Windows user configured to connect to Windows Active Directory has **Read** access to the `accountExpires` attribute. Without it, all cardholders and credentials previously imported from that Active Directory are **deleted** on the next synchronization after the upgrade. |

Other notes: different **client** versions can coexist on one machine, but different **Server** versions cannot. Not all settings are kept if you uninstall the current version before installing the new one. If the Active Directory role is in a different domain from the Active Directory it synchronizes with, set up a domain trust relationship.

## 14. Backward compatibility [S7]

5.14.0.0 is backward-compatible with components from the three previous major versions. A server or workstation three major versions behind can connect to a 5.14.0.0 Directory; one four major versions behind cannot. For systems four to six major versions behind, upgrade in two steps. **Adding backward-compatible connections slows the Directory** and is recommended only as a temporary measure.

Rules:

- Always upgrade the primary server hosting the Directory. Always upgrade expansion servers hosting non-backward-compatible roles.
- To use new 5.14.0.0 features you must upgrade the servers.
- If a role is assigned to multiple servers (for example failover), **all** its servers must run the same version.
- **All Directory servers must match on all four version digits.**
- **Config Tool** is backward-compatible as of 5.13.3.0 but only from older to newer: an older Config Tool can log on to a newer server, not the reverse. In backward-compatible mode only read-only tasks (reports, system status) are available; configuration tasks are greyed out.

**Roles NOT backward-compatible with 5.11 / 5.12 / 5.13:** ALPR Matcher, Authentication Service (OpenID and SAML2), Authentication Service (WS-Federation), Authentication Service (WS-Trust), Directory Manager, Global Cardholder Synchronizer, Health Monitor, Incident Manager, Media Router, Wearable Camera Manager.

**Roles that are backward-compatible:** Access Manager, Active Directory, ALPR Manager, Archiver, Automation Manager, Auxiliary Archiver, Camera Integrity Monitor (hidden), Cloud Playback, Intrusion Manager, Map Manager, Media Gateway, Mobile Credential Manager, Mobile Server, Plugin (see Supported plugins), Record Caching Service, Record Fusion Service, Report Manager, Reverse Tunnel, Reverse Tunnel Server, Security Center Federation, Unit Assistant (5.10.1.0 and later, **unit password management only** - unit certificate management arrived in 5.11.0.0), Web App Server (5.13.0.0 and later; replaces the Web Server role from 5.12.0), Web-based SDK, Zone Manager.

**Tasks not backward-compatible with Security Desk 5.11-5.13:** Remote, Asset activities, Asset inventory. Task backward compatibility applies to Security Desk only.

**GCS sharing host / guest compatibility** (minimum guest version is 5.8; the host version must be equal to or higher than its guests):

| Sharing host | Compatible guests |
|---|---|
| 5.14 | 5.8 - 5.14 |
| 5.13 | 5.8 - 5.13 (not 5.14) |
| 5.12 | 5.8 - 5.12 (not 5.13+) |
| 5.11 | 5.8 - 5.11 (not 5.12+) |
| 5.10 | 5.8 - 5.10 (not 5.11+) |

## 15. Upgrade procedures [S7]

**From 5.11, 5.12 or 5.13 to 5.14:**

1. Upgrade the main server (single-Directory systems).
2. If Directory failover is configured, upgrade the Directory failover servers - **Directory servers are not backward-compatible**, so they must be updated with the main server.
3. Upgrade expansion servers. **Role failover does not work until all servers assigned to a role run the same major version.**
4. Upgrade client workstations. If Client and Server are on the same machine, upgrade them together.
5. Reapply the previous settings: passwords, databases, ports, general properties.

Before you begin: Omnicast Federation is disabled and unsupported from 5.12.0.0 - **remove all Omnicast Federation roles before upgrading**. If you upgrade the ALPR Manager, the Archiver it is linked to must also be upgraded; an upgraded ALPR Manager does not work against a backward-compatible Archiver.

After you finish: if `AllowedSynchronizationConfiguration.xml` was used to set HID VertX unit synchronization times, reapply those settings manually from Config Tool (configure one unit then use the **Copy configuration** tool).

**From 5.8, 5.9 or 5.10 to 5.14** (two-step): upgrade to the latest 5.11 release first (you need a temporary license and the latest 5.11 package from a Genetec representative), upgrade the main server to 5.11, turn the system on (un-upgraded machines run in backward compatibility - stage one), upgrade the rest of the system to the latest 5.11 (stage two, which may itself be split into several stages), then upgrade to 5.14.

**What still works while the Directory service is down** (all Directory servers must be shut down for a period during upgrade): [S7]

| Available | Not available |
|---|---|
| Security Desk continues streaming live video | Config Tool and Security Desk features |
| Video continues recording on schedule while Archivers are online | All manual actions from Security Desk widgets (manual recording, lock/unlock, camera call-ups) |
| All access control functions except those relayed by the Directory (event-to-actions, door open/unlock issued from Security Desk) | Alarms and live events in Security Desk |
| Doors can be opened by an input switch if all inputs and outputs are on the same access control unit | |

Other upgrade tasks in the guide: upgrading the Directory database, **shrinking Security Center databases after an upgrade**, upgrading with Global Cardholder Synchronizer roles, reactivating and reapplying the license on Directory failover systems.

## 16. Backup and restore [S7]

**CAUTION:** do not use virtual machine snapshots to back up Security Center databases - the snapshot suspends all VM I/O, which can affect stability and performance.

Where to run the backup:

| Database | Where |
|---|---|
| Directory, no failover | Server Admin |
| Directory, with failover | Config Tool > Directory Manager > **Directory failover** page |
| Any other role database | Config Tool > the role's **Resources** page |
| Archiver / Auxiliary Archiver | Back up the database, then perform an **archive transfer** to back up the video files (video is not in the database) |

**Directory backup (Server Admin):** select the main server, click **Database properties**, then configure:

| Setting | Meaning |
|---|---|
| Destination folder | Path relative to the server performing the backup. Default `C:\SecurityCenterBackup` on the database server; created if absent. For a network share, type the path manually and give **both** the Genetec Server service user and the SQL Server service user write access. |
| Compress backup file | Produces a ZIP instead of a BAK; must be unzipped before restore. **Only works if the database is local to the server hosting the role.** |
| Enable automatic backup | Scheduled backups with frequency, time and number of files to keep. Manually created backups do not count toward the retained-file limit. |

Then **OK > Save**, then **Backup/Restore > Backup now**. The result is `<databasename>_ManualBackup_<date-time>.BAK` (or `.ZIP`).

**Role backup (Config Tool):** **System > Roles >** select role **> Resources > Backup/Restore**, choose the backup folder, optionally turn on **Compress backup file**, then **Backup now**.

Restrictions: there are restrictions on backup and restore of the Directory database when **Mirroring** failover mode is enabled - refer to Microsoft SQL Server database mirroring documentation. Configuration data for users, entities and alarms lives on the Directory **database** server; service-level configuration files live on the Directory **server**. [S7] Also see [S10]: in 5.14.0.0 the **Access Manager** database backup could be corrupted when **Compress backup file** was selected (issue 5296102, fixed in 5.14.0.1).

## 17. Installation troubleshooting [S7]

| Symptom | Cause and fix |
|---|---|
| SQL Server telemetry service still enabled | The installer always tries to disable the SQL Server CEIP service and warns if it fails. Disable `SQL Server CEIP service` in `services.msc`, then set `CustomerFeedback` and `EnableErrorReporting` (REG_DWORD) to `0` under `HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Microsoft SQL Server\150`, `HKEY_LOCAL_MACHINE\SOFTWARE\WOW6432Node\Microsoft\Microsoft SQL Server\150` and `HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Microsoft SQL Server\MSSQL15.<InstanceName>\CPE`. |
| Installation interrupted, missing cached MSI files | Click **List of missing cached MSI files**, download the matching setup packages from the Genetec Portal (match MSI version to the build number table in [S13]), unzip them to one folder, then run Microsoft's `FixMissingMSI.exe` as administrator, scan that folder with **All Products**, select **Missing or Mismatched Only**, and **Fix > Fix All > OK**. Re-run the interrupted install. |
| Cameras stop working after install with default security options | Basic access authentication is disabled by default and some cameras do not support digest. Per unit: Config Tool **Hardware inventory** task, run the report on inactive (red) units, select them and click **Reset authentication scheme** (becomes **Anonymous** until the Archiver connects). Per manufacturer: **Video** task > Archiver role > **Extensions** > select the manufacturer > turn off **Refuse basic authentication** > **Apply**. **Once the system has successfully authenticated to a unit using digest you cannot revert that unit to basic.** |
| .NET Framework error, return code `0x800f081f` | .NET Framework 3.5 cannot be enabled because .NET 3.5.1 files are missing. Mount the Windows 11 installation media and run `DISM /online /enable-feature /featurename:NetFx3 /All /Source:F:\sources\sxs` (replace `F:`), then enable **.NET Framework 3.5** in Windows Features and re-run the install. |
| Message about hotfix KB2494124 / KB2468871 | Install the Microsoft hotfixes. 64-bit: `NDP40-KB2468871-v2-IA64.exe`, `NDP40-KB2468871-v2-x64.exe`, `NDP40-KB294124-x64.exe`, `Windows6.1-KB2588507-v2-x64.msu`. 32-bit: `NDP40-KB2468871-v2-x86.exe`, `NDP40-KB294124-x86.exe`. Run them in download order and restart. |
| "Setup detected blocked file(s) in the download package" | Download `streams.exe` from Sysinternals and run `streams.exe -d <filename>` on the files that stay blocked. If you unblocked the whole ZIP, extract it again before installing. |
| One or more services failed to install | Check the Service Logon username format (`DOMAIN\username` or `username@domain.local`). Recreate manually from an elevated Command Prompt - adjust the path if not the default `C:\Program Files (x86)\Genetec Security Center 5.14`: |

```
sc create GenetecWatchdog binPath= "C:\Program Files (x86)\Genetec Security Center 5.14\GenetecWatchdog.exe" start= auto DisplayName= "Genetec Watchdog (SC)"
sc config GenetecServer binPath= "C:\Program Files (x86)\Genetec Security Center 5.14\GenetecServer.exe" start= auto depend= GenetecWatchdog/Winmgmt
sc start GenetecServer
sc create GenetecServer binPath= "C:\Program Files (x86)\Genetec Security Center 5.14\GenetecServer.exe" start= auto depend= GenetecWatchdog/Winmgmt DisplayName= "Genetec Server"
sc start GenetecServer
```

After creating `GenetecWatchdog`, open its properties in the Services console, set the **Recovery** options to match the screen capture in the guide (the exact values are an image and are therefore **not documented** in text - see `../known-gaps.md`), click **Apply**, then start the service.

| Symptom | Cause and fix |
|---|---|
| Exported PDF reports in Japanese or Chinese contain invalid characters | Happens when the Windows display language differs from the report language. Install the supplemental fonts: **Start > Settings > Apps > Apps & features > Optional features > Add a feature**, then Japanese, Chinese (Simplified) or Chinese (Traditional) Supplemental Fonts. |
| Omnicast Federation role disabled and red after upgrading to 5.12.0.0+ | Omnicast is no longer supported. Delete all Omnicast Federation roles (**System > Roles**, right-click **> Delete > Continue > Delete**) and uninstall every **Genetec Omnicast Compatibility Package** from Programs and Features. |
| Genetec Web App inaccessible after upgrading to 5.13+ | The Web App Server role must be hosted on a server running 5.13 or later. Either move the role to a compliant server or upgrade the expansion server hosting it. |
| Silent install fails with error 1603 | `/ISInstallDir` ends with a trailing backslash. Remove it. Error 1603 is a generic fatal-install error - review logs at `C:\ProgramData\Genetec\Installation`. Documented as a Security Center limitation. [S28] |
| GUS upgrade fails with error 1603 | The existing install path ends with a trailing backslash. Workaround: download the installers and upgrade each machine individually. To be fixed in a future GUS release. [S29] |
| .NET Framework `0x800f0906` on Windows Server 2012 / 2012 R2 | Mount the original Windows sources, set **Computer Configuration > Administrative Templates > System > Specify settings for optional component installation and component repair** to **Enabled** with **Download repair content ... from Windows Update instead of WSUS**, run `gpupdate /force`, then install **.NET Framework 3.5 Features** in Server Manager specifying the alternate source `<drive>:\sources\SxS`. Note: Windows Server 2012 and 2012 R2 are **no longer supported** from 5.12.0.0 and installation is blocked on them. [S30] [S9] |

## 18. Features that impact installation and upgrade [S9]

**Installation:** on a fresh installation of 5.13.2.0 or newer, Microsoft CCR and DSS are not installed by default. Install **Microsoft CCR and DSS Runtime 2008 R2 Redistributable** and **Microsoft CCR and DSS Runtime 2008 R3 Redistributable** manually on the system hosting the Stratocast Federation role, then restart the role.

**Upgrade:** .NET 8.0 required from 5.12.2.0 (.NET 6.0 for Sipelia; .NET 7.0 no longer supported). Windows Server 2012 / 2012 R2 unsupported and blocked from 5.12.0.0. JPEG2000 unsupported from 5.12.1.0 - cameras that only support JPEG2000 must be replaced. Omnicast Federation disabled from 5.12.0.0. Microsoft Visual C++ 2010 Redistributable removed from the package (Dahua dewarping and Ampleye decoder units are no longer supported). Newtonsoft updated from 12.0.2 to 12.0.3, which may break SDK environments. Map Manager requires client authentication for image maps from 5.9 and runs upgraded 5.8-or-earlier roles in backward compatibility (turn it off after all clients are upgraded). Redirector default port changed from TCP 5004 to TCP 960 in 5.8 GA. Archivers require both TCP 555 and TCP 605 from 5.6 GA. Server Admin password complexity enforced from 5.8 GA. The Directory field in the logon dialog can no longer be blank from 5.7 SR2. RTSP is usable only over HTTP or TCP combined with SDK access from 5.9.0.0.
