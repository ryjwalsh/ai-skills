---
name: genetec-security-center-sdk
description: Comprehensive knowledge of the Genetec Security Center SDK covering the Platform SDK, Web SDK, Media SDK, Workspace SDK, Plugin SDK, Macro SDK, Genetec Web Player and Media Gateway RTSP. Use whenever the user mentions Genetec, Security Center, Genetec.Sdk.dll, Engine.LogOn, Web-based SDK role, GSC_SDK, DAP part numbers, or asks about SDK certificates, ConnectionStateCode/SdkError failures, ports 5500/4590/654, licensing, or diagnosing SDK integrations.
---

# Genetec Security Center SDK

The Security Center SDK is a set of Windows/.NET and REST toolkits that let a third-party application authenticate to the Security Center **Directory** and read or drive its entities, events, reports, actions and video — licensed per-integration through a Genetec-issued **SDK certificate** plus a matching **part number** in the customer's license.

> **Version coverage banner** — Knowledge current as of docs retrieved **2026-07-24**, covering versions **5.11–5.14** (primary source: Security Center SDK Developer Guide **5.14**; release notes 5.11.0.0 through 5.14.0.0). Verify version-sensitive answers against current docs.

No `DEPLOYED_VERSION` was supplied when this skill was built, so nothing has been flagged as conflicting with a deployed release. Ask the user which Security Center / SDK version they run before giving version-sensitive answers — behaviour changes materially at 5.4, 5.6, 5.8, 5.9, 5.10.4.1, 5.12.2.0, 5.13.0.0 and 5.13.3.0.

---

## Quick facts

| Item | Value | Source |
|---|---|---|
| Toolkits in scope | Platform SDK (.NET), Web SDK (REST), Media SDK (.NET video), Workspace SDK (Security Desk/Config Tool extensions), Plugin SDK (server-side roles), Macro SDK, Genetec Web Player (JS), Media Gateway RTSP | S1, S12–S18 |
| Root object | `Genetec.Sdk.Engine` — one instance per application | S1 |
| Key assemblies | `Genetec.Sdk.dll`, `Genetec.Sdk.Media.dll`, `Genetec.Sdk.Workspace.dll`, `Genetec.Sdk.Controls.dll` (all `Copy Local = False`) | S1 |
| Roles / services you depend on | **Directory** (Platform SDK), **Web-based SDK** role (Web SDK — not a default role), **Media Gateway** role (Web Player + RTSP), **Access Manager**, **Archiver**, **Unit Assistant (UAR)** | S1 |
| Windows processes seen at runtime | `GenetecServerHost32.exe`, `GenetecMediaComponent32.exe` (out-of-process decoding), `Genetec.Utility32` (plugin discovery), `Genetec.FeatureFlag.Settings.exe` | S1, S3 |
| Key ports | **TCP 5500** Directory · **TCP 4590/4591** Web SDK role · **RTSP 654** Media Gateway · **TCP 80/443** Media Gateway public/WebSocket · **UDP 6000–6200** unicast video · **UDP 47806/47807** multicast video · **TCP 554/560** video requests | S1 |
| Diagnostic console ports | 6020 Security Desk · 6021 Config Tool · 6001 Media Gateway agent · 4523/6023 your own `DiagnosticServer` | S1 |
| SDK install path | `C:\Program Files (x86)\Genetec Security Center <ver> SDK` and `...\net8.0-windows` for .NET 8 | S1 |
| Environment variables | `GSC_SDK` (highest .NET 4.8 install), `GSC_SDK_##` (per version), `GSC_SDK_CORE` (.NET 8, 5.12.2.0+) | S1 |
| SDK certificate location | `Certificates\` folder beside the executable/DLL; file named `<exe>.cert` or `<FullClassName>.cert` | S1 |
| Plugin/Workspace registration | 5.12 and earlier: registry `HKLM\SOFTWARE\Genetec\Security Center\Plugins\` (+ `Wow6432Node`). 5.13.0.0–5.13.2.x: `C:\ProgramData\Genetec Security Center\PluginInstallations\Plugins\`. 5.13.3.x+: `C:\Program Files (x86)\Common Files\Genetec System\PluginInstallations\Plugins\`. Files must end `.Plugin.xml` | S1 |
| App logging config | `<yourapp>.exe.gconfig` (XML, `<logTargets>`); client apps use `SecurityDesk.exe.gconfig` / `ConfigTool.exe.gconfig` | S1 |
| Admin URL patterns | Server Admin console `/localhost/genetec/DebugConsole?serverId=` · Media Gateway console `http://localhost:6001/genetec/DebugConsole` · Web SDK `http(s)://<server>:4590/<baseUri>/` · Web Player library `<mediaGateway>/v2/files/gwp.js` · token `POST <mediaGateway>/v2/token/{cameraId}` | S1 |
| Default credentials policy | Docs use `Admin` with an **empty password** in samples and in WebSdkStudio ("defaults to user admin and an empty password"). This is a **sample default, not a product default** — treat as dev-only and always change it. The user must hold the `Log on using the SDK` privilege. Active Directory users **cannot** sign in to the Web SDK. | S1 |
| Demo vs production certificate | Demo/dev part number `GSC-SDK-EXTENDED` (dev license only); demo sample ApplicationId maps to part number `GSC-SDK`; production part numbers look like `GSC-1SDK-DevelopmentCompany-Application`. Development parts cannot go on demo or production systems. | S1, S11 |
| Dev-license tell | System ID starting with `DEM` = development license (About page in Security Desk/Config Tool, or GTAP) | S1 |
| Timestamps | SDK produces and uses **UTC**; convert with `ToLocalTime`/`ToUniversalTime` | S1 |
| Licensing contacts | `DAP@genetec.com` (part numbers, certificates, demo licenses), `TechPartners@genetec.com` (Media SDK NDA) | S11 |

---

## Which reference file to open

| If the question is about… | Read |
|---|---|
| What the components are, Engine/entities/events/managers, which SDK to choose, topologies, dependency stack | `references/architecture.md` |
| Ports, firewall rules, TLS/SSL, communication certificates, CORS, tokens, rate/scale ceilings | `references/network-ports.md` |
| Getting the SDK, prerequisites, install paths, env vars, project/reference setup, .NET 8 layout, post-build steps, upgrade paths, binding redirection, rollback | `references/install-upgrade.md` |
| `.gconfig` files, `logTarget` keys and defaults, `.Plugin.xml`, registry values, Web SDK role settings, `MediaGateway.gconfig`, privilege XML, custom fields | `references/configuration.md` |
| Starting/stopping roles, Server Admin console, loggers and tracers, health checks, session keep-alive, scalability and throttling, maintenance | `references/operations.md` |
| **Any "it doesn't work" question** — symptom-first flows | `references/troubleshooting.md` |
| `ConnectionStateCode` / `SdkError` values, HTTP 401/403/404, .NET exception texts, release-note issue IDs, CVEs | `references/error-codes.md` |
| Web SDK endpoints and query syntax, authentication, serialization, Web Player API, RTSP URL format, Macro SDK, Workspace services, SDK-connection consumption | `references/api-integration.md` |
| What changed in 5.11 / 5.12 / 5.13 / 5.14, breaking changes, deprecations, third-party DLL versions, backward-compatibility rules | `references/version-matrix.md` |
| Where a fact came from | `sources.md` |
| What the docs never answered, and where to get it | `known-gaps.md` |

---

## The five most common troubleshooting flows

### 1. .NET SDK application cannot connect to the Directory
Read `FailureCode` and `SdkException` from the `Engine.LoginManager.LogonFailed` event first — everything else is guesswork without them. [S1]

| `FailureCode` | Meaning → fix |
|---|---|
| `CertificateRegistrationError` + `SdkError.MissingClientCertificate` | `.cert` not on disk. Must be `<exe>.cert` inside a `Certificates` folder next to the executable. |
| `… + SdkError.InvalidClientCertificate` | File found but invalid — check the `<ApplicationId>` tag is not empty. |
| `… + SdkError.MissingCertificate` | Certificate is not in the license → the license lacks the matching **part number**. |
| `… + SdkError.CertificateCountExceeded` | All connections in use. Config Tool → **About → Certificates** shows e.g. `10/10`. |
| `… + SdkError.InvalidApplicationId` | ApplicationId string corrupted / off by characters. |
| `InsufficientPrivileges` | Grant **Config Tool → Security → Privileges → Log on using the SDK**. |
| `InvalidCredential` | Bad username/password. |
| `InvalidVersion` | Your SDK is **newer** than the server. Older SDK → newer server is fine; the reverse is not. |
| `DirectoryCertificateNotTrusted` | App registered `Engine.RequestDirectoryCertificateValidation` but never accepted. Accept the certificate once in Security Desk/Config Tool as the same Windows user, or handle the event. |
| `Failed` | Empty username, **or** the Directory is off / DB needs upgrade (check Server Admin) → restarting the **Genetec Server** service usually resolves it. |
| `UnableToRetrievePrivileges` | `Privileges.xml` not found — install the SDK or copy the file next to your executable. |
| `LicenseError`, `PasswordExpired`, `DisallowedBySchedule`, `ExceededNumberOfWorkstations`, `InsufficientSecurityLevel`, `MissingRequestUserChangePassordEvent`, `SpecifyDomain`, `NoAuthenticationAgent`, `UserAccountDisabledOrLocked` | See `references/error-codes.md` for the full catalogue and per-code Config Tool paths. |

Silent-failure warning: custom tasks surface certificate errors, but **tile views, tile widgets and tile properties fail to load with no error at all.** [S1]

### 2. Web SDK client gets 403 / 404 / connection refused
Order of checks straight from the docs [S1]:
1. **Connection actively refused** → the **Web-based SDK** role is missing or deactivated (Config Tool → System → Roles); or ports **4590/4591** blocked; or wrong host/port; or DNS.
2. **403 Forbidden** → credentials. The Web SDK uses **HTTP basic auth** where the username field is `SCUser;<ApplicationId>` — the certificate must be concatenated to the username with a semicolon. Also: user lacks `Log on using the SDK`; production certificate used against a dev system (or vice-versa — system ID starting `DEM` = dev); part number absent from the license.
3. **404 Not Found** → the **Base URI** in your URL does not match Config Tool → Roles → WebSdk → Properties → **Base URI**, or the command is not a real API command (verify against the Postman collection), or missing privileges.
4. **Handshake failed due to an unexpected packet format** → you used `https://` but the role has SSL off.
5. **Could not establish trust relationship for the SSL/TLS secure channel** → client does not trust the role's certificate, or the URL hostname does not match the certificate `CN`.
6. After changing user privileges, **deactivate then reactivate the Web-based SDK role** (Maintenance contextual menu) so active sessions close.

### 3. Workspace module / plugin does not appear in Config Tool or Security Desk
1. **About → Installed Components → File versions** — is your DLL listed, with the expected `Path`? [S1]
2. Registration mechanism must match the version: registry for 5.12 and earlier, `.Plugin.xml` for 5.13+ (path moved again at 5.13.3.x). 5.13+ scans both and auto-creates XML from registry entries.
3. `AddFoldersToAssemblyProbe = True` if your DLL has non-SDK dependencies in the same folder — otherwise **the module will not load** and "Security Center does not display an error or warning in the user interface."
4. Certificate present and named after the **full class name**? Is the ApplicationId the one tied to the part number?
5. Enable the Config Tool diagnostics module: in the Security Center installation folder edit `ConfigTool.Modules.xml`, set `Enabled="true"` for `Genetec.Platform.Module.Diagnostic.dll`, restart Config Tool, then click the biohazard icon in the notification tray → **Application logs → Loading workspace modules → Loading custom tasks modules**; errors show in red.
6. Server-side plugins missing from the **Add Plugin** window: in Server Admin add loggers `Genetec.Reflection.PluginProvider` and `Genetec.Platform.Common.Core.PluginInstaller.PluginInstaller`, kill the `Genetec.Utility32` process (it restarts itself), then retry.

### 4. SDK application runs but shows no video
1. **Platform target** — must be `x86` on 5.3 SDK or earlier, and always `x86` when using `VideoSourceFilter` with YUV→RGB conversion. [S1]
2. `useLegacyV2RuntimeActivationPolicy="true"` present in `<app>.exe.config`?
3. **Firewall** — the Security Desk/Config Tool installer adds exceptions; a standalone SDK app usually needs adding manually. Run the MediaPlayer sample: stuck in *starting* with no bitrate means firewall. Bitrate present but no picture means missing native DLLs — go to step 4.
4. **Post-build `xcopy` steps** missing (`avcodec*`, `avformat*`, `avutil*`, `swscale*`, `swresample*`, `Genetec.*MediaComponent*`, `libajpeg2000.dll`, `Genetec.Nvidia.dll`, `Genetec.QuickSync.dll`) — see `references/install-upgrade.md`.
5. Federated Omnicast cameras need the **Compatibility Pack ("CPack")** from SDK support plus three extra `xcopy` lines, and a reboot.
6. Multi-NIC or multi-subnet host → use the `Initialize` overload taking `PhysicalAddress networkAdapterBinding` or `Guid clientSubnet`.
7. Confirm video works in Security Desk on the same machine — if not, it is not an SDK problem.
8. Web Player instead of Media SDK? `Unsupported codec` is expected: **transcoding is disabled on the Media Gateway role by default** because of CPU cost.

### 5. Which logs to collect before opening a Genetec ticket
| Layer | What to collect | How |
|---|---|---|
| Your SDK app | `Logs` folder produced by a `LogFileTarget`/`XmlLogTarget` in `<app>.exe.gconfig` | `references/configuration.md` |
| Media SDK | Copy `logTargets.gconfig` from the SDK samples into the MediaPlayer sample's execution folder — creates a `Logs` subfolder | S1 |
| Network | Wireshark capture taken while reproducing; note the exact time | S1 |
| Server | Server Admin → select server → **Actions → Console**; add loggers (connection: `Genetec.Directory.BusinessObjects.Workflows.WFLogin`, `Genetec.Directory.Proxy.Workflows.Login.WFLogin`; queries: `Genetec.Directory.BusinessObjects.Workflows.WFQuery`, `Genetec.Sentinel.DSProxy.Workflows.WFEntity`; events: `Genetec.Sentinel.DSProxy.Workflows.WFEvent`; alarms: `Genetec.Sentinel.DSProxy.Workflows.WFAlarm`, `Genetec.Directory.BusinessObjects.Workflows.Alarm.WFAlarm`; Web SDK sessions: `Genetec.Sdk.Web` at Debug; Media Gateway: `Genetec.Media.Gateway`) and use **Trace logger** to write them to a folder | S1, S6 |
| Web Player | `gwp.enableLogs()` in the browser console (entries prefixed with a hamster emoji); `Ctrl+Shift+A` or `player.showDebugOverlay(true)` for the diagnostic overlay | S1 |
| Versions | Product version of **every** Genetec product on the machine, plus GWP library version (`gwp.version`) — the docs ask for this explicitly | S1 |

Zip the network capture together with the `Logs` subfolder before contacting the Genetec Technical Assistance Center. [S1]

---

## Ground rules when using this skill

- Every claim in the reference files carries a source ID (`S1`…`S24`) resolvable in `sources.md`. If a statement has no ID, do not trust it.
- Statements tagged `[INFERRED — verify]` were not stated outright in the docs. Verify before acting.
- "Not documented" means the vendor docs genuinely did not answer it — it is recorded in `known-gaps.md`, not a gap in reading.
- **Scope**: this covers *developing against* Security Center. Installing, sizing and hardening the Security Center **platform itself** is a different doc set (Administrator Guide, Hardening Guide, System Requirements) that is **not** included here.
- Large parts of `developer.genetec.com` sit behind a DAP-member sign-in wall. Gated pages are listed in `known-gaps.md`; their contents were never guessed.
- No `scripts/` directory ships with this skill: the docs contain no deterministic read-only health-check commands (only Visual Studio post-build `xcopy` steps and `node start.js`), so per the build rules the directory was omitted.
