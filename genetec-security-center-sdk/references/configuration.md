# Configuration — Genetec Security Center SDK

Sources: S1 (Developer Guide 5.14), S3 (RN 5.14.0.0), S5 (RN 5.13.0.0), S6 (RN 5.12.2.0), S8 (RN 5.11.0.0).

## Contents
1. Configuration file inventory
2. Application logging — `.gconfig`
3. Application config — `.exe.config`
4. Plugin / Workspace registration files
5. Registry values
6. Diagnostics module toggle
7. Web-based SDK role settings
8. Media Gateway settings
9. Custom privileges XML
10. Environment variables
11. Web SDK request-level settings
12. Config Tool navigation paths
13. Advanced settings
14. Directory / SSO integration

---

## 1. Configuration file inventory [S1]

| File | Location | Format | Purpose |
|---|---|---|---|
| `<yourapp>.exe.gconfig` | Beside your executable | XML | SDK log targets and traces for **your** application |
| `logTargets.gconfig` | Shipped in the SDK samples | XML | Ready-made log config; copy into the MediaPlayer sample folder to produce a `Logs` subfolder |
| `SecurityDesk.exe.gconfig` | Security Center installation folder | XML | Log traces for Security Desk |
| `ConfigTool.exe.gconfig` | Security Center installation folder | XML | Log traces for Config Tool |
| `<yourapp>.exe.config` | Beside your executable | XML | `useLegacyV2RuntimeActivationPolicy`, `supportedRuntime`, `bindingRedirect` |
| `web.config` | ASP.NET project root | XML | `<hostingEnvironment shadowCopyBinAssemblies="false"/>` |
| `<anything>.Plugin.xml` | See §4 | XML | Registers a Workspace module or Plugin |
| `ConfigTool.Modules.xml` | Security Center installation folder | XML | Enables the Config Tool diagnostics module |
| `ConfigurationFiles\MediaGateway.gconfig` | Media Gateway installation folder, **on each agent** | XML | CORS allow-list for the Media Gateway |
| Privilege descriptor XML | With your module | XML (UTF-16 in the sample) | Declares custom privileges and their images |
| `Privileges.xml` | SDK folder, Security Center folder, or beside your executable | XML | Read at logon; missing → `ConnectionStateCode.UnableToRetrievePrivileges` |
| `<exe>.cert` / `<FullClassName>.cert` | `Certificates\` folder beside the binary | XML | SDK certificate containing `<ApplicationID>` |

---

## 2. Application logging — `.gconfig` [S1]

Naming rule, verbatim: "The file should be named after your application, including its extension, and end with `.gconfig`. For example, if your application is called `MyApp.exe`, the configuration file should be named `MyApp.exe.gconfig`."

Skeleton:
```xml
<?xml version="1.0" encoding="utf-8"?>
<configuration>
  <logTargets>
  </logTargets>
</configuration>
```

Each `logTarget`:
```xml
<logTarget type="logTargetType">
  <settings>
    <add key="setting1" value="value1" />
  </settings>
  <traces>
    <add loggerName="MyCompany.MyProject.*" severity="Warning | Error | Fatal"/>
    <add loggerName="MyCompany.MyProject.MyClass" severity="Performance"/>
  </traces>
</logTarget>
```

`loggerName` accepts a full class name, a namespace, or a namespace with the `*` wildcard meaning "all `Logger` instances created within that namespace".

### 2.1 Log severities [S1]

| Severity | Meaning |
|---|---|
| `Performance` | Speed, efficiency, resource usage |
| `Debug` | Debugging information |
| `Information` | General informational messages |
| `Warning` | Potential issues; system still functioning correctly |
| `Error` | Error or unexpected condition preventing intended function |
| `Fatal` | Critical errors resulting in termination or shutdown |
| `Full` | All severities — equivalent to `Performance \| Debug \| Information \| Warning \| Error \| Fatal` |
| `All` | All **except** Debug and Performance — equivalent to `Information \| Warning \| Error \| Fatal` |

Combine with the bitwise OR operator, e.g. `"Warning | Error | Fatal"`.

### 2.2 `logTarget` types, keys and documented default values [S1]

**Application console** — `Genetec.Diagnostics.Logging.Targets.ConsoleTarget, Genetec`

| Key | Documented value |
|---|---|
| `TraceExceptionStacks` | `true` |
| `IncludeThreadId` | `true` |

**Visual Studio debug console** — `Genetec.Diagnostics.Logging.Targets.DebugTarget, Genetec`

| Key | Documented value |
|---|---|
| `TraceWithoutDebugger` | `false` |
| `HideExceptionStack` | `false` |

**Event Tracing for Windows** — `Genetec.Diagnostics.Logging.Targets.EtwLogTarget, Genetec`

| Key | Documented value |
|---|---|
| `providerName` | `""` |
| `AutoRegisterEventLog` | `false` |
| `EventLogMaxSizeInMegabyte` | `100` |

**Windows Event Viewer** — `Genetec.Diagnostics.Logging.Targets.EventLogTarget, Genetec`

| Key | Documented value |
|---|---|
| `EventViewerLoggerName` | `""` |

**File** — `Genetec.Diagnostics.Logging.Targets.LogFileTarget, Genetec`

| Key | Documented value | Note |
|---|---|---|
| `deleteOlderThanNDays` | `14` | Retention |
| `logMaxLine` | `-1` | `-1` = unlimited |
| `maxDiskUsage` | `9223372036854775807` | `Int64.MaxValue` = effectively unbounded |
| `minDiskSpace` | `0` | |
| `maxFileSize` | `9223372036854775807` | `Int64.MaxValue` |
| `zipFiles` | `false` | |
| `detailedHeader` | `true` | |
| `format` | `Text` | |
| `reuseFiles` | `true` | |
| `prefix` | `""` | |
| `prefixWithMachineName` | `false` | |
| `logFolder` | `""` | |

**SQL Server** — `Genetec.Diagnostics.Logging.Targets.SqlServerLogTarget, Genetec`

| Key | Documented value |
|---|---|
| `Server` | `""` |
| `Database` | `""` |
| `MaxNumberOfErrors` | `10` |
| `MaxWorkItems` | `2000` |
| `MaxLogEntries` | `2000` |
| `CleanupTime` | `0` |

**XML file** — `Genetec.Diagnostics.Logging.Targets.XmlLogTarget, Genetec`

| Key | Documented value |
|---|---|
| `prefix` | `""` |
| `logFolder` | `Logs` |
| `maximumFileSizeInMegabytes` | `100` |
| `TotalMaximumFileSizeInMegabytes` | `1024` |
| `retentionPeriodInDays` | `-1` |

> Valid ranges for these keys are **Not documented** — only the sample values above are given. Logged in `known-gaps.md`.

### 2.3 In-process diagnostic web console [S1]
```csharp
DiagnosticServer server = DiagnosticServer.Instance;
server.InitializeServer(diagnosticServerPort: 4523, webServerPort: 6023);
```
Then browse `localhost:6023/console`. "Ensure that `webServerPort` is not used by another application and is bound to a certificate."

---

## 3. Application config — `.exe.config` [S1, S3]

| Element | Value | Why |
|---|---|---|
| `<startup useLegacyV2RuntimeActivationPolicy="true">` | required for media and mixed-mode assemblies | Fixes `Mixed mode assembly is built against version 'v2.0.50727'…` |
| `<supportedRuntime version="v4.0" sku=".NETFramework, Version=v4.8"/>` | as shown | Target runtime |
| `<bindingRedirect oldVersion="1.2.0.0-65535.85535.85535.85535" newVersion="5.14.0.0"/>` | per SDK assembly | Adapt without recompiling; `publicKeyToken="a446968a32b751de"` |
| `<hostingEnvironment shadowCopyBinAssemblies="false"/>` (web.config) | `false` | Stops IIS shadow copy breaking SDK assembly loading |

---

## 4. Plugin / Workspace registration files [S1, S5]

Directory by version:

| Version | Directory |
|---|---|
| 5.13.0.0 – 5.13.2.x | `C:\ProgramData\Genetec Security Center\PluginInstallations\Plugins\` |
| 5.13.3.x and later | `C:\Program Files (x86)\Common Files\Genetec System\PluginInstallations\Plugins\` |

Naming: "Each file must end with `.Plugin.xml`. The prefix is arbitrary and does not affect plugin identity." Valid examples: `CodeMyWorkspace.Plugin.xml`, `CustomWorkspace.Plugin.xml`.

Client-only Workspace module:
```xml
<PluginInstallation>
  <Version>1</Version>
  <Configuration>
    <Item Key="Enabled" Value="True" />
    <Item Key="ClientModule" Value="C:\Program Files\Genetec\Plugins\MyMonitor\MyClientModule.dll" />
    <Item Key="AddFoldersToAssemblyProbe" Value="True" />
  </Configuration>
</PluginInstallation>
```

Plugin with both client and server modules:
```xml
<PluginInstallation>
  <Version>1</Version>
  <Configuration>
    <Item Key="Enabled" Value="True" />
    <Item Key="ServerModule" Value="C:\Program Files\Genetec\Plugins\MyPlugin\MyPlugin.dll" />
    <Item Key="ClientModule" Value="C:\Program Files\Genetec\Plugins\MyPlugin\MyPlugin.dll" />
    <Item Key="AddFoldersToAssemblyProbe" Value="True" />
  </Configuration>
</PluginInstallation>
```

Behavioural rules, verbatim [S1]:
- "Set `<AddFoldersToAssemblyProbe>` to True if your module uses other non-SDK DLLs located in the same folder. If you omit this line or set it to false, and your main DLL has dependencies in the same directory, **the module will not load**."
- "If both `<ServerModule>` and `<ClientModule>` are declared, both DLLs will be loaded. If one of the paths is invalid or the DLL is missing, the corresponding component will **fail silently**. Security Center does not display an error or warning in the user interface."
- "If `<ClientModule>` is declared, the client extension will be loaded when Security Desk or Config Tool starts."
- 5.13+ "will automatically scan both registry locations and create XML files for any registry entries that do not already have corresponding XML files."

---

## 5. Registry values (5.12.x and earlier) [S1]

Both paths must be populated:
```
HKEY_LOCAL_MACHINE\SOFTWARE\Genetec\Security Center\Plugins\          (64-bit)
HKEY_LOCAL_MACHINE\SOFTWARE\WOW6432Node\Genetec\Security Center\Plugins\   (32-bit)
```
Each integration gets its own subkey (e.g. `ModuleSample`) containing:

| Name | Type | Required | Description |
|---|---|---|---|
| `Enabled` | `REG_SZ` or `REG_DWORD` | Yes | `"True"`/`"1"` to enable, `"False"`/`"0"` to disable (case-insensitive). For the legacy Workspace path the doc specifies `Enabled` (DWORD) = `1` loads the module; "All other values disable the module" |
| `ServerModule` | `REG_SZ` | For Plugins | Full absolute path to the server DLL |
| `ClientModule` | `REG_SZ` | For Workspace modules | Full absolute path to the client DLL |
| `Client` | `REG_SZ` | For .NET plugins | Full absolute path to the .NET Framework client assembly (lets Config Tool list the plugin) |
| `AddFoldersToAssemblyProbe` | `REG_SZ` or `REG_DWORD` | Optional | `"True"` if the DLL has dependencies in the same folder |
| `NetCore` | `REG_SZ` or `REG_DWORD` | Optional | `"True"` for .NET plugins (5.13+) |

Example `.reg` content [S1]:
```
[HKEY_LOCAL_MACHINE\SOFTWARE\Genetec\Security Center\Plugins\ModuleSample]
"ClientModule"="C:\\SDK\\Samples\\ModuleSample\\bin\\Debug\\ModuleSample.dll"
"Enabled"=dword:00000001
```
Creating or modifying these entries "requires administrative privileges" — which is exactly why 5.13 moved to files. The SDK samples ship a `RegisterModule.bat` that does it for you.

---

## 6. Diagnostics module toggle [S1]

To surface Workspace/custom-task load errors in Config Tool:
1. Go to the Security Center installation folder.
2. Open `ConfigTool.Modules.xml`.
3. For the `Genetec.Platform.Module.Diagnostic.dll` module, change `Enabled="true"`.
4. Save, then start or restart Config Tool.

A biohazard icon appears in the notification tray; clicking it opens the Diagnostics window (**Application logs** and **Application diagnostics** tabs).

---

## 7. Web-based SDK role settings [S1]

Reached via **Config Tool → System → Roles → select the WebSdk role → Properties**.

| Setting | Notes |
|---|---|
| **Port** | Owned by the role. Documented defaults in every sample: `4590` (HTTP), `4591` (HTTPS) |
| **Base URI** | Path segment after host:port. Samples use `WebSdk`. A mismatch is a top cause of HTTP 404 |
| **Use SSL connection** | `On`/`Off`. Default is **On** when creating a new role (per defect 5032013 in S3) |
| **Certificate** | Textbox must contain the certificate name. The role otherwise uses the same SSL certificate as the Genetec Server and auto-detects changes to it |
| **Bind certificate to port** | `Off` → Windows performs the binding. `On` → the Web SDK performs it, and the certificate must be registered as a **local computer personal certificate** |

Supported TLS versions: **1.0, 1.1, 1.2, 1.3**.
After changing user privileges, restart the role by **deactivating then reactivating** it via the Maintenance contextual menu, "to ensure that all active sessions are closed, and changes are applied."

---

## 8. Media Gateway settings [S1]

| Setting | Where | Notes |
|---|---|---|
| RTSP port | Config Tool → Media Gateway role → Properties | Default **654** |
| Public endpoint URI | Media Gateway configuration page in Config Tool | e.g. `https://hostname.com/medi` — passed as the second argument to `webPlayer.start()` |
| Transcoding | Media Gateway role configuration | **Disabled by default** "because of its intensive CPU requirement"; without it, codecs your browser cannot handle produce an `Unsupported codec` error |
| CORS | `ConfigurationFiles\MediaGateway.gconfig`, on **each agent** | See below |

```xml
<MediaGateway EnforceStrictCrossOrigin="true">
  <AllowedOrigin Origin="https://example1.com" />
  <AllowedOrigin Origin="https://example2.com" />
  <AllowedOrigin Origin="https://web.example3.com" />
</MediaGateway>
```
With no `<AllowedOrigin>` children, access is restricted to Web Client agents only. An explicit list is **required for custom web pages**. Since 5.10.4.1 the default posture allows any origin to call and authenticate.

---

## 9. Custom privileges XML [S1]

Custom privileges appear in the **User management** task of Config Tool and can be assigned to users or user groups like built-in privileges.

```xml
<?xml version="1.0"?>
<ModulePrivileges>
  <Resources fallbackLanguage="en">
    <Image name="MyPrivilegeImage" type="Base64">iVBORw0KGgo…UVORK5CYII=</Image>
  </Resources>
  <Privileges>
    <Privilege id="{2A8E2390-ED25-4081-B2D6-730CAA7E0B8B}"
               parentId="{940D69AC-45F4-47A0-94DB-E0C08DBFA09D}"
               type="Group"
               description="MyModule"
               priority="20"
               image="MyPrivilegeImage"/>
  </Privileges>
</ModulePrivileges>
```

| Attribute / concept | Values and meaning |
|---|---|
| `type` | `Task` — global privileges (see a task, perform a global action); not shown in a partition's privilege tree. `Entity` — depends on the user's access to the entity; shown in the partition tree. `Group` — logical grouping, "considered granted when all children's privileges are granted"; **cannot be modified with the SDK** |
| `hierarchical` | Optional. Default **not** blocked. `hierarchical=true` blocks the privilege to its parent's state when the parent is denied or undefined |
| `<Image>` `type` | `Base64`; image must be **16x16 pixels** |
| Privilege checks | `engine.SecurityManager.IsPrivilegeGranted(Guid privilegeId)`, `(privilegeId, userId, Guid.Empty)`, `(privilegeId, entityId)`, `(privilegeId, userId, entityId)` |

Constraint [S3, limitation 1537301]: "For a privilege check to be performed when a Custom entity is declared with a Custom privilege in its descriptor, the client module describing the custom privilege must be installed on the main server."

---

## 10. Environment variables [S1]

| Variable | Meaning |
|---|---|
| `GSC_SDK` | Install path of the highest installed SDK version (.NET Framework 4.8 binaries) |
| `GSC_SDK_##` | Install path of a specific version (`GSC_SDK_56`, `GSC_SDK_57`, `GSC_SDK_512`…) |
| `GSC_SDK_CORE` | Install path of the latest .NET 8.0 SDK binaries (5.12.2.0+) |

Consumed by `SdkResolver.GetProbingPath()` and by Media SDK post-build `xcopy` steps.

---

## 11. Web SDK request-level settings [S1]

| Setting | Values | Default | Notes |
|---|---|---|---|
| `Accept` header | `text/JSON` (new JSON), `text/xml` (new XML), plus the two legacy MIMEs | **Legacy XML** — "If you do not set the Accept Header, the default is the former XML" | New MIMEs "start with `text` instead of `application`". JSON strongly recommended; event monitoring with legacy JSON took "~3-4 minutes per event versus less than a second per event with the new one" |
| Serialization engine | Newtonsoft from **5.8 GA**; deprecated XML/JSON serializer in 5.7 and earlier | — | Old serialization still works after upgrade; can be mixed per request |
| `Page` / `PageSize` | Integers | — | Supported on `/report/EntityConfiguration`, `/report/CardholderConfiguration`, `/report/CredentialConfiguration`. Response returns **one extra** entity when another page exists |
| `DownloadAllRelatedData` | `true`/`false` | `false` (implied) | `true` loads full entity details into the Web SDK cache; not advisable if you only need basic properties |
| Session keep-alive | — | 5 minutes | Ping the base URL `https://{server}:{port}/{baseUrl}/` |

Response envelope: `Rsp` → `Status` (`Ok`/`Fail`) → `Result`, plus `ObsoletedMembers` (hidden when empty). Errors carry `SdkErrorCode` and `Message`.

Documented JSON vs XML shapes:
```
JSON      {"Rsp":{"Status":"Ok","Result":{"Value":true}}}
XML       <WebSdk><Rsp><Status>Ok</Status><Result><Value>true</Value></Result></Rsp></WebSdk>
```

---

## 12. Config Tool navigation paths [S1]

| Goal | Path |
|---|---|
| Grant SDK logon | Security → Privileges → **Log on using the SDK** |
| Check certificates in the license and connection counts | About → **Certificates** |
| Verify Web SDK is licensed | About → Security Center → confirm **Web SDK** is supported |
| Web SDK role settings | System → Roles → WebSdk → Properties (Port, Base URI, Use SSL connection, Certificate, Bind certificate to port) |
| Restart the Web SDK role | Right-click role → **Maintenance** → deactivate, then activate |
| User logon schedule | Security → Properties → **User logon Schedule** |
| Concurrent workstation limit | Security → Properties → **Limit concurrent logons** |
| Password expiration | Security → Properties → **Password Expiration** |
| Security level / threat levels | Security → **Security** |
| Installed components and DLL paths | About → **Installed Components** → File versions |
| Access control general settings (custom card formats) | Requires `AccessControlGeneralSettingsTabPrivilege` |
| Advanced settings read access | Requires `GeneralSettingsAdvancedSettings` privilege |
| Custom privileges appear in | **User management** task |
| Network / client subnets | Config Tool **Network** page |

---

## 13. Advanced settings [S1, S4, S8]

- **5.13.3.0** added read access via the `AdvancedSettings` class: `GetAdvancedSetting(string name)` and `GetAllAdvancedSettings()`. Requires the `GeneralSettingsAdvancedSettings` privilege. **Read-only — no write API is documented.** [S4]
- The Access Manager `EventStream` table (5.11.0.0+) is enabled "by adding an advanced setting in Config Tool"; the specific setting name is **Not documented** here. Note: "the Access Manager database requires disk space for additional event data when this feature is enabled." [S8]
- Enabling detailed Web SDK session tracing: "activate the `Genetec.Sdk.Web` logger in Server Admin and set the Debug log-level to true." [S6]

---

## 14. Directory / SSO integration

| Mechanism | Status | Detail |
|---|---|---|
| **Active Directory** | Supported for the Platform SDK | `LogOnUsingWindowsCredential` / `…Async`; requires the **Active Directory role** to be set up in Security Center. Failure codes `AuthenticationAgentImportFailure`, `AuthenticationAgentResponseTimeout`, `NoAuthenticationAgent`, `SpecifyDomain`, `UserAndSupervisorOnDifferentDomains`, `UserAccountDisabledOrLocked` are all AD-specific [S1] |
| **Active Directory + Web SDK** | **Not supported** | "Active Directory users cannot sign in to the Web SDK." [S1] |
| **Security tokens** | Supported | `LogOnUsingSecurityToken` / `…Async` / `BeginLogOnUsingSecurityToken` — "using a security token obtained externally" [S1] |
| **Supervisor (dual) logon** | Supported | Codes `InvalidSupervisor`, `CantSuperviseSelf`, `SupervisorPasswordIsEmpty` [S1] |
| **Password change flow** | Supported | Subscribe to `Engine.RequestUserChangePassword`, else `MissingRequestUserChangePassordEvent` [S1] |
| **LDAP (direct)** | **Not documented** | — |
| **SAML** | **Not documented** | — |
| **OIDC / OAuth 2.0** | **Not documented** | — |

The Web Player uses Media Gateway tokens (`POST /v2/token/{cameraId}`) that "encapsulate user credentials, permissions, and session validity" — not an SSO protocol. [S1]

LDAP/SAML/OIDC gaps are logged in `known-gaps.md`.
