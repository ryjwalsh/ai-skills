# Install & Upgrade — Genetec Security Center SDK

Scope: installing the SDK on a developer / build / runtime machine, and upgrading integrations across SDK versions. This is **not** the Security Center server install guide (separate doc set — see `known-gaps.md`).
Sources: S1 (Developer Guide 5.14), S3 (RN 5.14.0.0), S5 (RN 5.13.0.0), S6 (RN 5.12.2.0), S11 (DAP).

## Contents
1. Obtaining the SDK
2. Prerequisites
3. Install method
4. Project setup
5. Media SDK post-build steps
6. Upgrade paths
7. Rollback
8. Backup & restore

---

## 1. Obtaining the SDK [S11]

| Step | Detail |
|---|---|
| Cost | "API and SDK packages are available at no charge." |
| How | Submit the online SDK application form and accept the **SDK License Terms**; the DAP team seeks approval from the relevant team; packages are sent once approved. |
| Contents | Security Center SDK **development license valid for one year**; Security Center installation and upgrade guide; Security Center and SDK release notes; SDK documentation and samples. |
| Dev part number | `GSC-SDK-EXTENDED` — matches the development certificate shipped in the SDK samples. **Cannot be deployed on a demo or production system.** |
| Extended / Media SDK | The basic package available with Terms and Conditions **does not include the Media SDK option**. An **NDA is required** to get a license with the Media SDK option. Contact `TechPartners@genetec.com`. |
| Support | "Technical assistance isn't included with our API and SDK packages." Requires a purchased DAP technical assistance plan (Bronze = ticket-based; Silver/Gold add personalized guidance, extra dev tools, and access to integration certification). Pricing via `DAP@genetec.com`. |

Sample projects included in the package cover: creating/updating entities, reports, user privileges, maps and map objects, macros, custom tasks, interacting with Security Desk and Config Tool, Web SDK, custom entities and credential formats, live/recorded video with `MediaPlayer`, YUV/RGB frame capture with `VideoSourceFilter`, snapshots and digital zoom, PTZ, export to G64/MPEG-4/ASF, video encryption and overlays. [S11]

---

## 2. Prerequisites

### 2.1 Build machine [S1, S3]

| Requirement | Value |
|---|---|
| Language / runtime | SDK written in C#; targets **.NET Framework 4.8** and **.NET 8.0** (the latter as of Security Center **5.12.2.0**) |
| Compiler | Projects referencing SDK assemblies must target .NET Framework 4.8 or later → **requires Visual Studio 2017 or later** [S1]. RN 5.14 instead states "Visual Studio 2012 or higher" plus the **Microsoft .NET Framework 4.8 Developer pack** [S3]. |
| .NET 8 development | ".NET 8.0 SDK & Runtime" must be installed on **both the developer's and the build machine**. |
| Compatible languages | C#, VB.NET, F#, C++/CLI [S11] |

> **Version conflict inside the same doc set**: S1 says "Visual Studio 2017 or later"; S3 says "Visual Studio 2012 or higher". Prefer S1's stricter figure. Flagged in `known-gaps.md`.

### 2.2 Runtime machine [S1, S11]
- "Ensure that you install the Genetec SDK on the server where your application runs. However, if your application runs on the server where Security Center is installed, there's no need to install the Genetec SDK."
- End users of a shipped integration "do not need to install the SDK package, only your SDK integration."

### 2.3 Security Center side [S1]
- A user holding the **`Log on using the SDK`** privilege (Config Tool → Security → Privileges). `Admin` has it by default.
- License must contain the part number matching your SDK certificate.
- **Web SDK:** license must have the **Web SDK** option activated, and a role of type **Web-based SDK** must be created and running (it is *not* a default role).
- **Media SDK:** license must have the **Media SDK** option. Web Player requires the **Genetec Web Player library** option (validated when connecting to the Media Gateway).
- **Web Player:** Media Gateway role configured; Node.js for the sample; Security Center **5.10 or later**; camera GUIDs.
- **Macro SDK:** an administrator user to create the macro in Config Tool, plus Server Admin access for logging.

---

## 3. Install method

The SDK ships as an **installer inside the `Security Center 5.14.x.y SDK` package** [S3]. Default install location pattern [S1]:

```
C:\Program Files (x86)\Genetec Security Center <major.minor> SDK
C:\Program Files (x86)\Genetec Security Center <major.minor> SDK\net8.0-windows   (.NET 8 binaries, 5.12.2.0+)
```

Silent / unattended switches, MSI properties and command-line install syntax are **Not documented** in this doc set. Logged in `known-gaps.md`.

### 3.1 Environment variables created by the installer [S1]

| Variable | Introduced | Points to |
|---|---|---|
| `GSC_SDK` | 5.6 | Install path of the **highest installed** SDK version (.NET Framework 4.8 binaries) |
| `GSC_SDK_##` | 5.6 | Install path of that specific version (`GSC_SDK_56`, `GSC_SDK_57`, …). One per installed version |
| `GSC_SDK_CORE` | 5.12.2.0 | Install path of the latest **.NET 8.0** SDK binaries, e.g. `C:\Program Files (x86)\Genetec Security Center 5.12 SDK\net8.0-windows` |

Ordering behaviour is explicit: installing 5.6 *after* 5.7 leaves `GSC_SDK` pointing at **5.7** — `GSC_SDK` always tracks the highest version, not the most recently installed one.

### 3.2 Registry locations the SDK reads [S1]
`SdkResolver` probes `GSC_SDK` first, then these roots, taking the highest parseable `Version` subkey whose folder exists:
```
SOFTWARE\Genetec\Security Center\
SOFTWARE\Wow6432Node\Genetec\Security Center\
```
Values read per version subkey: `Installation Path`, else `InstallDir`.

---

## 4. Project setup (the per-integration "install")

### 4.1 Assembly references [S1]

| Assembly | When needed |
|---|---|
| `Genetec.Sdk.dll` | Always (platform integration) |
| `Genetec.Sdk.Media.dll` | Media components. **Not available in .NET Core / .NET 8** |
| `Genetec.Sdk.Workspace.dll` | Workspace components |
| `Genetec.Sdk.Controls.dll` | Workspace UI controls and styles |

**Set `Copy Local` = `False` for every Genetec assembly**, then load them at runtime from the SDK or Security Center install directory via `AppDomain.CurrentDomain.AssemblyResolve`. The Developer Guide ships a complete `SdkResolver` class; call `SdkResolver.Initialize()` at application start, e.g. from a static constructor:

```csharp
class Program
{
    static Program() => SdkResolver.Initialize();

    static async Task Main()
    {
        using (var engine = new Engine())
        {
            await engine.LogOnAsync(server: "localhost", username: "admin", password: "");
        }
    }
}
```
Stated benefit: "a smaller deployment without any Genetec assemblies included."

### 4.2 Legacy runtime activation [S1]
Required in `app.config` / `<yourapp>.exe.config` for media, and for the exception `Mixed mode assembly is built against version 'v2.0.50727' of the runtime and cannot be loaded in the 4.0 runtime without more configuration information`, and for symptoms such as "setting the cardholder status disconnects the SDK":
```xml
<startup useLegacyV2RuntimeActivationPolicy="true">
  <supportedRuntime version="v4.0" sku=".NETFramework, Version=v4.8"/>
</startup>
```

### 4.3 Platform target [S1]

| SDK version / scenario | Required `Platform target` |
|---|---|
| 5.3 SDK and earlier, video apps | `x86` |
| 5.4 SDK and later, video apps | `x86`, `x64` or `Any CPU` |
| Any version, `VideoSourceFilter` with YUV→RGB colour conversion | `x86` |

### 4.4 .NET 8 project layout [S1]
Because ".NET Core cannot load .NET Framework 4.8 assemblies and vice-versa":

| Project | `TargetFramework` | Contents |
|---|---|---|
| `Application.Client` | `net48` | Anything loaded by .NET Framework 4.8 hosts (Security Desk, Config Tool); Windows and WPF controls |
| `Application.Shared` | `net48;net8.0-windows` | Code shared by both |
| `Application.Server` | `net8.0-windows` | .NET Core-only code |

.NET 8 limitations: `Genetec.Sdk.Media.dll` unavailable; `IWebMediaPlayer.GetBufferBoundaries()` and `IWebMediaPlayer.GetPlaybackSequencesList()` return `List<DateTimeRange>` because `MS.JScript` is absent [S1, S6]. Defect 4502494 ("SDKs using .NET Core can't deserialize reports that contain more than 20 results") was resolved in 5.14.0.0 [S3].

### 4.5 Certificate deployment [S1]
Create a folder named **`Certificates`** next to the built executable/DLL and copy the `.cert` file in, named per component type:

| Module | Certificate filename | Example |
|---|---|---|
| Standalone app | `<executable name>.cert` | `MyExternalApp.exe.cert` |
| Custom task | `<full class name inheriting Genetec.Sdk.Workspace.Pages.Page>.cert` | `MyWorkspaceModule.MyCustomPage.cert` |
| TileView | `<…Components.TileView.TileViewBuilder subclass>.cert` | `MyWorkspaceModule.MyTileViewBuilder.cert` |
| TileWidget | `<…Components.TileWidget.TileWidgetBuilder subclass>.cert` | `MyWorkspaceModule.MyTileWidgetBuilder.cert` |
| TileProperties | `<…Components.TileProperties.TilePropertiesBuilder subclass>.cert` | `MyWorkspaceModule.MyTilePropertiesBuilder.cert` |

Example for a Workspace module: `C:\SDK\Samples\ModuleSample\bin\debug\Certificates`.

Alternative for services / ASP.NET: set `Engine.ClientCertificate` to the **`<ApplicationID>` string only** (the encrypted text inside the tag) *before* calling `LogOn`:
```csharp
Engine.ClientCertificate = "KxsD11z743Hf5Gq9mv3+5ekxzemlCiUXkTFY5ba1NOGcLCmGstt2n0zYE9NsNimv";
Engine.LogOn("", "Admin", "");
```
"Setting the ClientCertificate property can only be used for projects that are standalone applications." (That literal ApplicationId is the **demo** certificate, valid on demo systems only; part number `GSC-SDK`.)

No certificate required for: `Notification`, `ContextualAction`, `Workspace Service` (`IService`), `MapObjectProvider`, `MapObjectViewBuilder`, `MapSearcher`, `ReportPage`, `ConfigPage`, `Macro` (`Genetec.Sdk.Scripting.UserMacro`), and per S11 the content menu.

To disable features without recompiling: **remove the related certificate files and restart the client application.** [S1]

### 4.6 ASP.NET on IIS [S1]
IIS shadow copy breaks SDK assembly loading ("The error would refer to DLLs that cannot be found even if the DLL is present in the deployment folder"). Two documented fixes:
1. In web.config: `<hostingEnvironment shadowCopyBinAssemblies="false"/>`
2. Add `[assembly: PreApplicationStartMethod(typeof(YourNamespace.Initializer), "Initialize")]` to `AssemblyInfo.cs` and hook `AppDomain.CurrentDomain.AssemblyResolve` in that `Initializer`.

For a 64-bit ASP.NET app that will not start, add these post-build deletes [S1]:
```bat
del /F "$(TargetDir)Genetec.*.Interop.dll"
del /F "$(TargetDir)Genetec.Codec.AvCodec.dll"
del /F "$(TargetDir)DecodingBenchmark.dll"
del /F "$(TargetDir)Genetec.Nvidia.dll"
del /F "$(TargetDir)Genetec.QuickSync.dll"
```

### 4.7 Workspace / Plugin registration [S1, S5]

| Security Center version | Mechanism |
|---|---|
| 5.12.x and earlier | Windows registry, **both** `HKEY_LOCAL_MACHINE\SOFTWARE\Genetec\Security Center\Plugins\` and `HKEY_LOCAL_MACHINE\SOFTWARE\WOW6432Node\Genetec\Security Center\Plugins\` |
| 5.13.0.0 – 5.13.2.x | `C:\ProgramData\Genetec Security Center\PluginInstallations\Plugins\` |
| 5.13.3.x and later | `C:\Program Files (x86)\Common Files\Genetec System\PluginInstallations\Plugins\` |

Each XML file must end `.Plugin.xml`; "the prefix is arbitrary and does not affect plugin identity" (e.g. `CodeMyWorkspace.Plugin.xml`). Full key/value reference is in `configuration.md`.

Cross-version guidance verbatim [S1]:
- "If you are developing on Security Center version 5.11 and onwards, you can stick to using registry keys."
- "If you are developing starting version 5.13, we recommend that you create XML files directly."
- "If you need to work on cross-versions, we recommend you to use both methods simultaneously by creating registry entries and XML files, and then let Security Center handle the migration automatically."

---

## 5. Media SDK post-build steps [S1]

Required so decoder/renderer natives land in the output folder. For SDK **5.9 and above** (uses `$(GSC_SDK)`):
```bat
xcopy /R /Y "$(GSC_SDK)avcodec*.dll" "$(TargetDir)"
xcopy /R /Y "$(GSC_SDK)avformat*.dll" "$(TargetDir)"
xcopy /R /Y "$(GSC_SDK)avutil*.dll" "$(TargetDir)"
xcopy /R /Y "$(GSC_SDK)Genetec.*MediaComponent*" "$(TargetDir)"
xcopy /R /Y "$(GSC_SDK)libajpeg2000.dll" "$(TargetDir)"
xcopy /R /Y "$(GSC_SDK)swscale*.dll" "$(TargetDir)"
xcopy /R /Y "$(GSC_SDK)swresample*.dll" "$(TargetDir)"
xcopy /R /Y "$(GSC_SDK)\x86\Genetec.Nvidia.dll" "$(TargetDir)\x86"
xcopy /R /Y "$(GSC_SDK)\x64\Genetec.Nvidia.dll" "$(TargetDir)\x64"
xcopy /R /Y "$(GSC_SDK)\x86\Genetec.QuickSync.dll" "$(TargetDir)\x86"
xcopy /R /Y "$(GSC_SDK)\x64\Genetec.QuickSync.dll" "$(TargetDir)\x64"
xcopy /R /Y "$(GSC_SDK)\x86\avcodec-58.dll" "$(TargetDir)\x86"
xcopy /R /Y "$(GSC_SDK)\x64\avcodec-58.dll" "$(TargetDir)\x64"
xcopy /R /Y "$(GSC_SDK)\x86\avfilter-7.dll" "$(TargetDir)\x86"
xcopy /R /Y "$(GSC_SDK)\x64\avfilter-7.dll" "$(TargetDir)\x64"
xcopy /R /Y "$(GSC_SDK)\x86\avutil-56.dll" "$(TargetDir)\x86"
xcopy /R /Y "$(GSC_SDK)\x64\avutil-56.dll" "$(TargetDir)\x64"
xcopy /R /Y "$(GSC_SDK)\x86\swscale-5.dll" "$(TargetDir)\x86"
xcopy /R /Y "$(GSC_SDK)\x64\swscale-5.dll" "$(TargetDir)\x64"
```
For **5.6 – 5.8** the same list is used without the `avcodec-58` / `avfilter-7` / `avutil-56` / `swscale-5` architecture-specific lines. For versions without the environment variable, the docs substitute a literal path such as `C:\Program Files (x86)\Genetec Security Center 5.9 SDK\`.

Federated **Omnicast** video additionally requires the **Compatibility Pack ("CPack")** installed on the client machine (request it from SDK support, quoting your Omnicast version) followed by a **reboot**, plus:
```bat
xcopy /R /Y "$(GSC_SDK)Genetec.Media.OmnicastMediaExtension.dll" "$(TargetDir)"
xcopy /R /Y "$(GSC_SDK)Genetec.Platform.Resources.Core.dll" "$(TargetDir)"
xcopy /R /Y "$(GSC_SDK)Genetec.Omnicast.Sdk.dll" "$(TargetDir)"
xcopy /R /Y "$(GSC_SDK)Genetec.ServiceModel.Compatibility.dll" "$(TargetDir)"
```
Purpose stated: these copy "the EXE, DLL and configuration files required for decoding and rendering", enabling **out-of-process decoding** — improved memory usage spread over several processes, and fault isolation when decoding.

WPF projects displaying video must also reference `Genetec.SDK.Media.dll` with **`copyLocal` = true** (the one documented exception to the Copy Local = False rule). [S1]

---

## 6. Upgrade paths

### 6.1 Upgrading the SDK itself to 5.14 [S3]
- "When upgrading the SDK to version 5.14.0.0 or later, it's important to run the SDK installer to ensure that all components are deployed successfully."
- Running the SDK installer "is necessary only if you initially installed the SDK separately. If you used the Security Center installer, which includes the SDK components, a separate SDK installation isn't required."
- **Failure signature of skipping it:** `FileNotFoundException: Unable to run Genetec.FeatureFlag.Settings.exe.`
- **Recovery:** "reinstall the Platform SDK and the Media SDK by running the installer inside the Security Center 5.14.x.y SDK package."

### 6.2 Upgrading an existing integration — three documented options [S1]

| Option | What happens | Trade-off |
|---|---|---|
| **Do nothing** | "The Security Center 5.12 Directory is backward-compatible with clients that are three major versions older. Your Genetec 5.9, 5.10, 5.11 or 5.12 application can still connect to it." | "you may experience performance issues, which limit your access to the latest features." **You must allow older client versions to connect in Server Admin.** |
| **Recompile** (recommended) | Gains latest features, fixes and improvements; surfaces obsolete members at compile time | Must re-deploy to customers. "The updated integration isn't compatible with earlier versions of the Security Center SDK." |
| **Binding redirection** | Reconfigure the app to use a newer assembly without recompiling | "Warning: Using this option can cause run-time exceptions. Recompiling the application with the targeted SDK version fixes these errors." |

### 6.3 Binding-redirect template for 5.14 [S3]
Deploy alongside the executable as `<yourapp>.exe.config`, then **copy all files from the SDK installation folder to the application folder**:
```xml
<?xml version="1.0"?>
<configuration>
  <startup useLegacyV2RuntimeActivationPolicy="true">
    <supportedRuntime version="v4.0" sku=".NETFramework,Version=v4.8"/>
  </startup>
  <runtime>
    <assemblyBinding xmlns="urn:schemas-microsoft-com:asm.v1">
      <dependentAssembly>
        <assemblyIdentity name="Genetec.Sdk"
                          publicKeyToken="a446968a32b751de" culture="neutral"/>
        <bindingRedirect oldVersion="1.2.0.0-65535.85535.85535.85535"
                         newVersion="5.14.0.0"/>
      </dependentAssembly>
      <dependentAssembly>
        <assemblyIdentity name="Genetec.Sdk.Media"
                          publicKeyToken="a446968a32b751de" culture="neutral"/>
        <bindingRedirect oldVersion="1.2.0.0-65535.85535.85535.85535"
                         newVersion="5.14.0.0"/>
      </dependentAssembly>
    </assemblyBinding>
  </runtime>
</configuration>
```
`publicKeyToken` for Genetec SDK assemblies: **`a446968a32b751de`**.

**Workspace SDK modules need none of this**: "Modules built on Workspace SDK are loaded from the Config Tool or Security Desk application, which already have the required settings in their associated config files." [S3]

### 6.4 Backward-compatibility contract [S1]

| Case (types and members from the SDK) | Supported |
|---|---|
| Use publicly exposed types | Yes |
| Call publicly exposed members | Yes |
| Create type instances | Yes |
| Extend class and call protected members | Yes |
| Extend abstract class | Yes |
| Extend a class that contains virtual members | Yes |
| Implement interfaces | Yes\* |
| Implement interfaces and add default values to arguments | Yes |
| Call private members through reflection | **No** |
| Add extension methods | **No** |

\* Not all interfaces — `IEngine` has had breaking changes. Some SDK interfaces exist for design/testing only and should not be implemented; concrete types already exist (e.g. `Engine` for `IEngine`).

Additional guidance: test after any recompile or redirect; migrate off obsolete members before they are removed; prefix/suffix your extension method names to avoid future signature collisions; "Backward Compatibility cannot be guaranteed for code using reflection"; and "Backward compatibility breaks might appear when fixing a security issue."

### 6.5 Plugin/Workspace registration migration at 5.13.0.0 [S5]
- An automated migration creates configuration files at startup for existing registry-registered plugins.
- Migration runs at startup for **both client and server apps**; **runtime change detection is server-only**.
- **The plugin file is now the source of truth; registry modifications don't sync to the plugin file.**
- To uninstall a plugin you must delete **both** the registry entry and the plugin file or DLL.
- Deleting a plugin file also removes its registry entry, preventing duplicate files on reload.
- "This update only changes how plugin paths are retrieved, not how they are loaded into memory."

### 6.6 .NET Framework upgrade impact [S3]
The 5.14 SDK assemblies are compiled against .NET Framework 4.8. Standalone applications and Workspace SDK modules are affected. Projects referencing SDK assemblies "need to target .NET Framework 4.8 or higher".

---

## 7. Rollback

**Not documented.** The SDK doc set describes no rollback or downgrade procedure for the SDK installer, and no supported path for reverting a Security Center upgrade.

What *is* documented and functions as a partial mitigation:
- Multiple SDK versions can coexist; each keeps its own `GSC_SDK_##` variable and install folder, so an older toolchain remains addressable after installing a newer SDK. [S1]
- An older integration can keep running against a newer Directory within the three-major-version window, provided older clients are allowed in Server Admin. [S1]
- Features can be disabled without recompiling by deleting the relevant `.cert` files and restarting the client application. [S1]
- If a binding redirect misbehaves, "recompiling the application with the targeted SDK version fixes these errors." [S1]

Logged in `known-gaps.md`.

---

## 8. Backup & restore

**Not documented** in the SDK doc set. No backup or restore procedure is given for the Directory database, role databases, licences, certificates or plugin registrations. This is Security Center Administrator Guide territory — see `known-gaps.md`.

Practical items the docs *do* identify as needing preservation before an upgrade or machine rebuild, which are worth capturing manually:
- Your production `.cert` file(s) and the associated part number(s) [S1, S11]
- `<app>.exe.config` / `<app>.exe.gconfig` files [S1]
- `.Plugin.xml` registration files or the equivalent registry keys [S1]
- `ConfigurationFiles\MediaGateway.gconfig` on each Media Gateway agent, if CORS was customised [S1]
- Custom privilege XML files [S1]
