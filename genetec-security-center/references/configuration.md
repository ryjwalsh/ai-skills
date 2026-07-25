# Configuration

Phase 2 section F. Covers configuration file locations and keys, client command-line arguments, directory and SSO integration, license options, and the hardening settings that change defaults.

## Contents

1. Configuration file locations
2. Documented .gconfig keys
3. Config Tool / Security Desk command-line arguments
4. Shortcut arguments
5. Debug console addresses
6. Registry keys
7. Active Directory integration
8. Third-party authentication (OIDC, SAML2, WS-Federation, WS-Trust)
9. License options
10. Hardening settings that change defaults
11. Mission Control configuration

## 1. Configuration file locations

| File | Default location | Purpose |
|---|---|---|
| `*.gconfig` (all) | `C:\Program Files (x86)\Genetec Security Center 5.x\ConfigurationFiles` (64-bit) or `C:\Program Files\Genetec Security Center 5.x\ConfigurationFiles` (32-bit). Modifiable at install time. | Service-level settings. [S23] |
| `GenetecServer.gconfig` | as above | Server Admin password reset, Server Admin HTTP enable/disable. [S23] [S21] |
| `Archiver.gconfig` | as above | Two sections, `ArchiverRole` and `ArchiverAgent`; settings apply to all Archiver roles or agents hosted on that server. [S20] |
| `License.gconfig` | as above | License and validation key. [S31] |
| `SecurityDesk.Workspace.Settings`, `ConfigTool.Workspace.Settings` | `C:\Users\<username>\AppData\Local\Genetec Security Center 5.x` | Per-user client workspace, including the workstation GUID. [S33] |
| `SipServer.config` | `C:\ProgramData\Genetec Sipelia\SipServer` | Sipelia Server `MinimumPortRange` / `MaximumPortRange`. [S3] |
| `CallService.appsettings.json` | `C:\ProgramData\Genetec Sipelia` | Sipelia Gateway WebRTC `Min.PortRange` / `Max.PortRange`. [S3] |
| `WebApi.appsettings.json` | `C:\ProgramData\Genetec Sipelia` | Sipelia Gateway Web API port (default 7550). [S3] |
| `AllowedSynchronizationConfiguration.xml` | not stated | Optional HID VertX unit synchronization times. Settings must be **re-applied manually from Config Tool after an upgrade**. [S7] |

**CAUTION repeated throughout the docs:** incorrect modifications to a `.gconfig` file can cause system issues or take the system offline. Always save a backup copy first. [S23] [S20] [S31]

## 2. Documented .gconfig keys

| File / section | Key | Values and meaning | Src |
|---|---|---|---|
| `GenetecServer.gconfig` > `<genetecServer>` | `<password password="my_new_password" encrypted="false" />` | Resets the Server Admin password. **Use for Security Center 5.13.0.0 and earlier.** | S23 |
| `GenetecServer.gconfig` > `<genetecServer>` | `<resetPassword input="my_new_password" updated="false" />` | Resets the Server Admin password. **Use for Security Center 5.13.1.0 and later.** | S23 |
| `GenetecServer.gconfig` | `<ServerAdminService http="false" />` | `false` means the HTTP port of the Security Center server is disabled - a documented cause of being unable to log on to Server Admin. | S21 |
| `Archiver.gconfig` > `ArchiverAgent` | `ArchiverLogPath="C:\ArchiverLogs\"` | Where Archiver logs are written. Change to move them off C:, for example `ArchiverLogPath="D:\ArchiverLogs\"`. | S20 |
| `Archiver.gconfig` > `ArchiverAgent` | `logDaysToKeep="90"` | Archiver log retention in days; default 90. Example `logDaysToKeep="60"`. | S20 |
| `License.gconfig` | `<Licensing License="" ValidationKey="" />` | Reducing the file to this cleared form is the documented workaround for an "Invalid license" error, after which you reset the computer license and reactivate. | S31 |

**Password caveat:** password strength is **not** validated when you set a password in `GenetecServer.gconfig`. Do not set a blank or weak value even briefly; log on to Server Admin as soon as possible and change it there, where Security Center password standards are enforced (Server Admin **Overview > Connection settings > Modify > Change password**, supplying the old password). [S23]

**Regenerating a missing `Archiver.gconfig`:** Server Admin > select the server hosting the Archiver role > **Actions > Console > Commands > Archiver Agent commands > GenerateConfigFile**. If the file exists but lacks the `ArchiverAgent` options, it is either outdated or was generated from **Archiver Role commands > GenerateConfigFile** instead - regenerate from the Agent command. With Archiver failover, the role may be running on a different server: generate the file there and copy it across. Restart the Archiver role after editing. [S20]

## 3. Config Tool / Security Desk command-line arguments [S24]

Syntax: `Application.exe -d directory_name -u username -w password`. Usable in logon scripts or added to shortcuts. Quotation marks around the executable path are only needed when folders contain spaces.

| Argument | Meaning |
|---|---|
| `-d` / `-Directory` | Directory to connect to. **Mandatory.** |
| `-u` / `-Username` | Security Center user name. |
| `-w` / `-Password` | User password. |
| `-we` / `-PasswordEncrypted` | Path to an encrypted password file created from Config Tool, used instead of `-w`. Example `-u David -we C:\DavidPasswordFile.pwd`. Available from 5.3. |
| `-iwa` / `-UseWindowsAuthentication` | Use Windows credentials instead of `-u`/`-w`. Requires Active Directory integration; the signed-in user's profile must have been imported from an Active Directory. |
| `-su` / `-SupervisorUsername` | Supervisor user name (only if the user has a logon supervisor). |
| `-sw` / `-SupervisorPassword` | Supervisor password. |
| `-swe` / `-SupervisorPasswordEncrypted` | Supervisor encrypted password file. Example `-su Admin -swe C:\AdminPasswordFile.pwd`. Available from 5.3. |
| `-f` / `-FullScreen` | Open in full screen. |
| `-ff` / `-ForceFullscreen` | Force full screen and prevent switching to windowed mode. |
| `-nohwa` / `-NoHardwareAcceleration` | Disable hardware acceleration. |
| `-nominsize` / `-NoMinSize` | Disable the minimum window size restriction. |
| `-ih` / `-InitialHeight` | Initial window height. |
| `-iw` / `-InitialWidth` | Initial window width. |
| `-lang` / `-Language` | UI language code: `ar`, `bg`, `zh-Hans`, `zh-Hant`, `hr`, `cs`, `nl`, `en`, `fr`, `fr-CA`, `de`, `el`, `he`, `hu`, `it`, `ja`, `ko`, `no`, `fa`, `pl`, `pt`, `ro`, `ru`, `sl`, `es`, `sv`, `th-TH`, `tr`, `vi`. Your version may not support all of them. |
| `-nosplash` / `-NoSplash` | Bypass the splash screen. |
| `-safe` / `-Safemode` | **Prevents plugins from loading** in Config Tool and Security Desk. |
| `-fr` / `-FirstRun` | Open the Security Center installer assistant. Only applies at first logon after installing; available from 5.4. |
| `-mon` / `-Monitor` | Monitor ID on which to open. Available from 5.2 SR4. |

Examples:

```
"C:\Program Files (x86)\Genetec Security Center 5.x\ConfigTool.exe" -d Video-Server -u David -w 123456
"C:\Program Files (x86)\Genetec Security Center 5.x\SecurityDesk.exe" -lang fr -ff
```

## 4. Shortcut arguments [S25]

Right-click the Config Tool or Security Desk shortcut > **Properties > Shortcut**, and append arguments to **Target**. This form uses forward-slash switches:

```
"C:\Program Files (x86)\Genetec Security Center 5.x\SecurityDesk.exe" /Directory Video-Server /Username David /PasswordEncrypted ******
```

`/Directory` is the directory name, `/Username` the user name, and `/PasswordEncrypted` the encrypted version of the user's password from the directory database. Use `/help` or `/?` for more options.

## 5. Debug console addresses [S22]

| Application | Console address |
|---|---|
| Server Admin | `localhost/Genetec/Overview` |
| Security Desk | `localhost:6020/Genetec/Overview` |
| Config Tool | `localhost:6021/Genetec/Overview` |
| Genetec Mobile | `localhost:9001/Genetec/console#/Diagnostic` |

Debug consoles for Security Desk and Config Tool are **disabled by default**; enable them from **About > Debug console** in the application, and run Security Desk or Config Tool **as administrator** to use their consoles.

## 6. Registry keys

Only one set of registry keys is documented in the retrieved sources, for disabling SQL Server telemetry after installation. Set each to `0` (REG_DWORD): [S7]

```
HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Microsoft SQL Server\150
    CustomerFeedback
    EnableErrorReporting
HKEY_LOCAL_MACHINE\SOFTWARE\WOW6432Node\Microsoft\Microsoft SQL Server\150
    CustomerFeedback
    EnableErrorReporting
HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Microsoft SQL Server\MSSQL15.<InstanceName>\CPE
    CustomerFeedback
    EnableErrorReporting
```

Security Center's own settings live in `.gconfig` files and the Directory database, not the registry, in every documented case retrieved. No Security Center-specific registry keys or environment variables were found - logged in `../known-gaps.md`.

## 7. Active Directory integration [S1] [S36]

Config Tool navigation: **System task > Roles view > Active Directory role**. Configuration tabs cover synchronization settings and attribute mapping; the Administrator Guide documents "Default Active Directory attribute mapping", importing security groups, selecting which credential fields to synchronize, resolving conflicts caused by imported entities, deactivating imported users, and releasing ownership of Active Directory entities to Security Center.

Ports: LDAP TCP 389, LDAPS TCP 636, global catalog TCP 3268, global catalog over SSL TCP 3269, all outbound from `GenetecActiveDirectory.exe`. [S3]

Prerequisites and gotchas:

- Creating the Active Directory role requires logging on with the **Admin** account - otherwise the role does not appear in the list. [S36]
- The Windows user used to connect must have **read access** to the Active Directory server, be a member of the domain, and hold local administrator rights. [S36]
- With **Use Windows credentials** selected, the role uses the `Genetec Server` service logon account; change it in Windows Services (**Properties > Log On > This account**). Without that option, supply explicit credentials on the role's **Properties** tab. [S36]
- Status messages `Error: Connection to Active Directory denied. Check service permissions` and `Server invalid credentials` both indicate a credential problem. [S36]
- If the Active Directory role is in a different domain from the Active Directory it synchronizes with, set up a **domain trust relationship**. [S7]
- **Before upgrading:** the Windows user must have Read access to the `accountExpires` attribute or all previously imported cardholders and credentials are deleted at the next synchronization. [S7]
- Users are not listed in **User management** if the groups are missing from **Synchronized groups**, or if **As user group** is not selected next to the group name. [S36]

## 8. Third-party authentication [S1]

The Administrator Guide documents four protocols, each handled by an **Authentication Service** role:

| Protocol | Role tab | Notes |
|---|---|---|
| OpenID Connect | **Authentication Service - Properties tab (OpenID)** | Integration overviews exist for **Microsoft Entra ID** and **Okta**. Client authentication is configured separately. |
| SAML 2.0 | **Authentication Service - Properties tab (SAML2)** | Integration overview exists for **Okta**. **Incompatible with ECDSA Directory certificates.** [S9] |
| WS-Federation | **Authentication Service - Properties tab (WS-Federation or WS-Trust)** | Deployed through ADFS; requires adding a relying party trust for Security Center. |
| WS-Trust | same tab | Deployed through ADFS. |

Operational points: the Authentication Service role runs on the same server as the Directory, and with Directory failover **every Directory server endpoint URI must be added to the identity provider configuration**. [S1] User groups can be imported from a CSV file for third-party authentication, and a **Testing a third-party authentication setup** procedure exists. Authentication traffic uses TCP 443 (`GenetecAuth.exe`). [S3]

License caps apply: **Number of OpenID Connect integrations**, **Number of SAML2 integrations** and **Number of ADFS integrations** (WS-Trust and WS-Federation) each limit how many identity providers can be connected. [S1]

Related 5.14 feature: **Microsoft Entra OAuth for SMTP authentication**, as a replacement for Basic authentication being phased out by Microsoft (**Configuring Microsoft Entra OAuth authentication**). [S9]

## 9. License options [S1]

View from Config Tool **About** page (maximize the window or click the **License** list if options are hidden) or Server Admin **Overview > License > Details**, then click a category. Includes the SMA number, expiration date and supported features.

**Generic Security Center options:** Advanced automation (response delays, event-based responses, automation import/export - included only in some packages such as the Enterprise base package), Advanced correlation (for future use), Asset management, Automatic email notification (email server, Watchdog notifications, **Send an email** and **Email a report** actions), Basic automation (automations plus the **Unified report** investigation task), Charts, Dashboards, Intrusion detection, Macros, Media SDK, Number of Active Directories, Number of additional Directory servers, Number of ADFS integrations, Number of cash registers, Number of custom fields, Number of federated systems, Number of input points (only inputs on dedicated I/O subpanels such as HID V200 or Mercury MR16IN are counted, not controller-board inputs), Number of intrusion detection units, Number of mobile device servers, Number of OpenID Connect integrations, Number of output relays (dedicated subpanels only, such as HID V300 or Mercury MR16OUT), Number of record types for caching, Number of reverse tunnels, Number of SAML2 integrations, Plugin SDK, Record caching, Remote Security Desk, Threat level, Web SDK.

**Synergis options:** Antipassback, Badge template, Card requests, Import tool, Maximum occupancy, MIFARE DESFire configuration, Number of Access Managers, Number of cardholders and visitors (including Active Directory imports), Number of Global Cardholder Synchronizers (limits concurrent sharing-guest connections at the host), Number of Mobile Credential Managers, Number of readers, People counting, Smart card encoding, Synergis IX, USB enrollment reader, Visitors.

**Mission Control options:** Number of active incidents, Number of concurrent operator connections, Number of incident types.

**Omnicast options:** Archiver encryption, Audio, Camera blocking, Edge recording, Forensic search, Hardware acceleration, Number of Auxiliary Archivers, Number of cameras and analog monitors (cumulative - five cameras plus five analog monitors consume ten entities), Number of CCTV keyboards, Number of DVR inputs, Number of integrity-monitored cameras, Number of Media Gateway RTSP streams, Number of OVReady cameras, Number of panoramic cameras (each still needs a regular camera license), Number of privacy-protected streams, Number of promotional cameras, Number of restricted cameras (also needs a regular camera license; see the Restricted License Type filter on the Supported Device List), Number of standby Archiver servers.

**AutoVu options:** Geocoder (BeNomad map engine used by the ALPR Manager), Number of endpoints for the AutoVu Data Exporter, Number of fixed Sharp analytic streams, and further AutoVu counters.

Licensing mechanics: entity-count and feature-based, enforced by the Directory role. Adding entities beyond the license raises errors on the Config Tool **About** page; remove unneeded entities or contact Customer Service to update the license. [S21] Directory gateways must be added to the license after promotion. [S12] **Use static MAC addresses when installing a Directory on a VM - changing the MAC invalidates the system license.** [S5]

## 10. Hardening settings that change defaults [S12]

The Hardening Guide labels each item **(Basic)** or **(Advanced)**. Items that alter documented defaults or ports:

| Area | Setting | Effect |
|---|---|---|
| Users | Changing the default Admin password (Basic) | Config Tool **About > Change password**. Only use passwords rated **Very strong**; avoid reused passwords, dictionary words, repetitive or sequential characters, and context-specific words such as company name or username. |
| Users | Deactivating the default Admin user profile (Basic) | Removes the well-known account from use. |
| Users | Enforcing a strong password policy (Advanced), Changing password settings for users | System-wide policy. |
| Users | Using a local service account for Genetec Server (Basic) | Avoids over-privileged domain accounts. |
| Users | Activating auto lock or auto disconnect on desktop clients (Basic) | Idle session control. |
| Users | Restricting Server Admin access to local connections (Advanced) | Server Admin **Overview > Connection Settings > Server admin remote access > Local machine only**, then **Save**. Server Admin then only answers on the local machine. |
| Users | Restricting client application connections to a specific Directory (Advanced) | Prevents clients pointing at rogue Directories. |
| Users | Restricting the privileges of Federation users (Basic), Deactivating all local users (Advanced), Restricting user privileges (Advanced) | Least privilege. |
| System | Using trusted certificates on Security Center servers (Advanced) | Select **Always validate the Directory certificate** on the InstallShield **Security Settings** page, then in Server Admin choose the server, **Secure communication > Select certificate > Select > Save**. |
| System | Disabling backward compatibility (Advanced) and for the Map Manager role (Advanced) | Map Manager backward compatibility grants image-map access **without authentication**; turn it off after all clients are upgraded. |
| System | Deactivating unused roles (Basic) | Reduces attack surface. |
| System | Running macros with limited access rights (Advanced) | |
| System | Using the recommended security settings in InstallShield (Basic) | Includes disabling basic camera authentication (`DEACTIVBASIC=1` is the silent default). |
| System | Controlling access to your resources using partitions (Advanced) | |
| System | Using a Directory gateway for external access (Basic) | Config Tool **Directory Manager > Directory servers** tab, click **Advanced** to reveal the **Gateway** column, add servers, select **Gateway**, then **Apply**. A gateway must sit on the non-secured network, must reach the main server, and must **not** access the Directory database. Load balancing does not span gateways and Directory servers, and **Disaster recovery** applies only to Directory servers. Update the license for the promoted servers. |
| GUS | Keeping Security Center up to date (Basic), Connecting to GUS with Server Admin credentials (Basic), Using a proxy server (Basic) | |
| Video | Refusing / enabling basic authentication (Basic) | Basic camera authentication is disabled by default in 5.14. |
| Video | Enabling secure communication in the Media Router (Basic) | Turns RTSP into RTSP over TLS on ports 554/555/558/560/605. |
| Video | Setting strong admin passwords for cameras, rotating camera passwords periodically, connecting to cameras through HTTPS, deactivating unused services on video units | |
| Video | Encrypting data in transit and at rest with fusion stream encryption (Advanced) | Costs 30% Archiver capacity for the first certificate plus 4% per additional certificate; do not exceed 20 per Archiver. [S5] |
| Video | Enabling digital signature (Basic), setting up a cryptographic key | Ed25519 from 5.8.1.1. [S9] |
| Video | Securing access to the Media Gateway role (Basic) | |
| Access control | Enabling Secure mode on HID units (Basic) | Stops FTP/SSH/Telnet/HTTP usage; EVO firmware 3.7+ in secure mode uses TCP 4433 instead of 4050. [S3] |
| Access control | Using strong passwords on access control units, safeguarding the Synergis Softwire diagnostic service account, applying critical firmware and platform updates, using trusted certificates on Synergis units, disabling output relay driving from the Synergis unit web interface, using secure reader connections, disabling peer-to-peer and global antipassback for Access Manager roles, rotating Synergis unit passwords | |
| Access control | Using dedicated users with restricted privileges for GCS roles (Basic) | |
| Logging | Logging activity trails for security-related events (Basic) | |
| Web Client Server (legacy) | Disabling unlimited session time, installing a valid certificate, changing default ports, moving to Genetec Web App | Web App replaces Web Client in 5.14.0.0. [S9] |
| Web App Server | Changing the default Web App Server port (Basic) | Defaults are 80 and 443. Config Tool **System > Roles > Web App Server > Properties**, clear **Use the default secure HTTP port of the server**, enter a new HTTPS port, **Apply**. |
| Web App Server | Disabling support for unused features (Basic), changing the certificate (Advanced) | |
| Genetec Mobile | Changing the default Mobile Server port (Basic) | Default is 443, the same port as Security Center servers. Config Tool **System > Roles > Mobile Server > Properties > General settings**, set **Use the default secure HTTP port of the server** to OFF and enter a new **Secure HTTP port**, **Apply**. |
| Genetec Mobile | Always use trusted connections by enforcing certificate validity (Advanced), removing lost or stolen mobile devices (Advanced) | |
| ALPR | Changing default passwords for SharpV, SharpZ3 and SharpX units (Basic); encrypting the connection to each web portal with a self-signed or CA certificate (Basic) | |
| ALPR | Using the LPM protocol to connect SharpV and SharpZ3 units (Basic) | Mandatory from 5.14. [S9] |
| ALPR | Encrypting the Patroller database (Advanced), selecting a Patroller logon type (Basic), disabling SimpleHost functionality (Basic), restricting access to the AutoVu root folder (Basic), using a network location for the AutoVu root folder (Advanced), restricting access to the Patroller workstation (Basic) | |
| Database | Avoiding SQL connections with administrative privileges (Basic) | Full matrix in `architecture.md` section 10. |
| Database | Encrypting communication between database servers and Genetec services (Basic), restricting access to database backups (Basic), encrypting database data files (Advanced), authenticating database connections (Advanced), revoking execution permissions for specific stored procedures (Advanced) | Includes revoking `EXECUTE` on `xp_dirtree`. |
| Windows | Applying the latest OS security updates (Basic), synchronizing all clocks (Advanced), running client applications without administrative privileges (Basic), applying the latest Windows security baselines (Basic), using safe TLS versions (Advanced), using BitLocker full volume encryption (Advanced) | TLS details in `network-ports.md` section 13. |

**Documentation defect note:** in the retrieved 5.14 Hardening Guide, step 1 of "Using a Directory gateway for external access to Security Center (Basic)" is replaced by the internal string `Product Backlog Item 4898975: [SC 5.14.0.0] Clean up reuse in "RC - Common task information for SC topics"`. The first step of that procedure is therefore effectively missing. Recorded in `../known-gaps.md`.

## 11. Mission Control configuration [S15]

Config Tool navigation: create the **Incident Manager** role and the **Incident Document Service** role. Separate topics cover Mission Control privileges, modifying RabbitMQ ports, certificates for RabbitMQ (creating custom certificate requests and integrating custom certificates), assigning SQL permissions on remote SQL Servers, configuring high availability for RabbitMQ, creating a RabbitMQ cluster and adding nodes, and disabling Windows automatic root certificate updates before installing.

Silent install syntax:

```
"MC Packages\MCInstaller.exe" <installer_options>
```

| Option | Description |
|---|---|
| `/ISFeatureInstall` | Comma-separated with no spaces: `Server` (Mission Control), `DocServer` (Incident Document Service), `RabbitMQ`. `RabbitMQ` must be used with `RABBITUSER=<username> RABBITPWD=<password> CONFIRMPWD=<password>`. Feature names must immediately follow `/ISFeatureInstall`. |
| `/silent` | No user interaction. |
| `/debuglog<FilePath>` | Debug log path; the folder must already exist. |
| `/log<FolderPath>` | Log folder; must already exist. |
| `/remove` | Removes the installed features. |

Documented examples:

```
/ISFeatureInstall=Server,DocServer,RabbitMQ ISInstallDir_MissionControlWebAPI="C:\Program Files (x86)\Genetec\Genetec Mission Control Web API" RESTART_GENETEC_SERVER=1 GENETEC_PORT=9550 ENABLE_WEBAPI_DOCUMENTATION=1 ISInstallDir_DocumentService="C:\Program Files (x86)\Genetec\Genetec Document Service RABBITUSER=localadmin RABBITPWD=Password_1! CONFIRMPWD=Password_1! SSLPORT=5671 MANPLUGPORT=15671"
/ISFeatureInstall=Server ISInstallDir_MissionControlWebAPI="C:\Program Files (x86)\Genetec\Genetec Mission Control Web API" RESTART_GENETEC_SERVER=1 GENETEC_PORT=9550 ENABLE_WEBAPI_DOCUMENTATION=1"
/ISFeatureInstall=DocServer ISInstallDir_DocumentService="C:\Program Files (x86)\Genetec\Genetec Document Service"
/ISFeatureInstall=RabbitMQ RABBITUSER=localadmin RABBITPWD=Password_1! CONFIRMPWD=Password_1! SSLPORT=5671 MANPLUGPORT=15671
```

Key options: `GENETEC_PORT` sets the Web API SDK port (9550), `ENABLE_WEBAPI_DOCUMENTATION=1` publishes the Web API docs, `SSLPORT` and `MANPLUGPORT` set the RabbitMQ AMQPS and management ports, `RESTART_GENETEC_SERVER=1` restarts Genetec Server after installation.

**Mission Control upgrade paths to 3.4.0.0.** Direct upgrade only if Document Service is **not** used, from 2.13.4.x (end of life), 3.0.6.x, 3.1.3.x, 3.2.0.x, 3.2.1.x, 3.3.0.x, 3.3.1.x, 3.3.2.x or 3.3.3.x. If Document Service **is** used and you are on 3.2.0.x or earlier, a **two-step upgrade is mandatory** to migrate documents from MongoDB to SQL without data loss: first upgrade to 3.2.1.x (Document Service 1.6), 3.3.0.x (1.7), 3.3.1.x/3.3.2.x/3.3.3.x (1.8), keep the **Incident Manager role configured and online** on that intermediate version so it performs the migration (the installer does not), let it finish, then upgrade to 3.4.0.0 (Incident Document Service 25.11.0.2). Upgrading from 3.2.0.x or earlier with Document Service in use does **not** migrate documents from MongoDB to SQL.

Mission Control 3.4.0.0 systems must meet or exceed the **recommended** Security Center server requirements. Also documented: **Mission Control Web API and UI SDK**, staging-to-production practice, a phased approach to incident configuration deployment, and considerations when importing incident configurations.
