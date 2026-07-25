# Troubleshooting — Genetec Security Center SDK

Organised **symptom-first**. Each entry: Symptom → probable causes (ordered by likelihood) → checks → resolution → source.
Sources: S1 (Developer Guide 5.14), S3 (RN 5.14.0.0), S6 (RN 5.12.2.0), S11 (DAP).
Error-code lookups live in `error-codes.md`. Log collection is in `operations.md`.

## Contents
1. .NET SDK app cannot connect to the Directory
2. Certificate present but connection still refused
3. Tile view / tile widget / tile properties silently missing
4. Workspace module or plugin does not load
5. Web SDK — connection actively refused
6. Web SDK — HTTP 403 Forbidden
7. Web SDK — HTTP 404 Not Found
8. Web SDK — TLS handshake failed
9. Web SDK — SSL trust relationship could not be established
10. Not receiving EntitiesInvalidated or other events
11. AuditTrailQuery returns TooManyResults
12. Query returns no results, or the app hangs at the query
13. Timestamps are wrong
14. ASP.NET app works in Visual Studio but fails under IIS
15. ASP.NET 64-bit application does not start
16. Cannot view video in an SDK application
17. Unexpected GenetecServerHost32.exe / GenetecMediaComponent32.exe processes
18. FileNotFoundException: Genetec.FeatureFlag.Settings.exe after upgrade
19. Mixed mode assembly exception / odd runtime behaviour
20. Web Player — Unsupported codec
21. Web Player — cannot connect or stream drops
22. Macro does not appear in the Server Admin logger list
23. Web SDK custom field name returns an error
24. CustomCardFormat causes compile-time errors
25. .NET Core report deserialization fails past 20 results
26. Cardholder group membership not reflected after removal
27. Security Desk / Config Tool deadlock from a Contextual Action

---

## 1. .NET SDK app cannot connect to the Directory

**Symptom** — `LogOn`/`LogOnAsync` fails, or `LogonFailed` fires.

**Probable causes, most likely first** [S1]
1. SDK certificate missing, invalid, or not in the license (`CertificateRegistrationError` — "This one is by far the most commonly found problem")
2. Certificate connection count exhausted
3. User lacks the `Log on using the SDK` privilege
4. Wrong username/password
5. SDK version newer than the server
6. TLS communication certificate not accepted
7. Directory off, or its database needs an upgrade
8. Licence, schedule, workstation-count, security-level, password-expiry or Active Directory conditions

**Checks**
- Implement and read `Engine.LoginManager.LogonFailed`; log `e.FormattedErrorMessage`, and compare `e.FailureCode` and `e.SdkException` against the catalogue in `error-codes.md`. `SdkException` **can be null**.
- Confirm the `Certificates` folder sits beside the executable and the file is named exactly `<exe>.cert`.
- Config Tool → **About → Certificates**: is your certificate listed, and is the count below maximum?
- Config Tool → **Security → Privileges → Log on using the SDK**.
- Server Admin: is the Directory running? Does the Directory database need an upgrade? Is the licence valid?

**Resolution** — fix per code; the full per-code table with Config Tool paths is in `error-codes.md`. Generic last resort documented for `ConnectionStateCode.Failed`: "restarting the Genetec Server service usually resolves this issue." [S1]

---

## 2. Certificate present but connection still refused

**Symptom** — the `.cert` file exists and looks right, but logon still fails.

**Probable causes** [S1]
1. **Certificate/licence mismatch** — "A certificate only allows the integration to connect to a license that has the corresponding part number. For instance, the demo certificate only connects to licenses that have the part number `GSC-SDK`. It does not connect to any other license."
2. Development certificate used on a demo or production system, or a production certificate on a development licence. Development part numbers (`GSC-SDK-EXTENDED`) "cannot be deployed on a demo or production system."
3. `<ApplicationId>` tag empty or corrupted
4. Connection limit reached
5. Your `Module.Load()` threw during component registration

**Checks**
- Determine which licence you are hitting: system ID beginning `DEM` = development licence (About page in Security Desk/Config Tool, or GTAP System Management).
- Verify the certificate appears under About → Certificates with available connections.
- Confirm `Module.Load()` "does not throw any exception when initializing and registering the Workspace components."

**Resolution** — obtain the correct certificate/part number from `DAP@genetec.com`; a demo licence containing your production part number can be requested for testing. The customer must reapply their licence after the part number is added. [S1, S11]

---

## 3. Tile view / tile widget / tile properties silently missing

**Symptom** — no error anywhere, the component just never appears.

**Cause** — verbatim: "When your application attempts to use an invalid certificate or the certificate is missing, some modules, like a custom task, indicate the error. Other modules, however, like tile views, tile widgets, and tile properties **fail to load without indicating an error**." [S1]

**Checks**
- Certificate file present in the deployment folder, inside `Certificates\`.
- Named after the **full class name** of the builder, e.g. `MyWorkspaceModule.MyTileViewBuilder.cert`.
- Certificate listed in the licence, connections available.

**Resolution** — add or rename the certificate and restart the client application. Removing a `.cert` file and restarting is also the documented way to *deliberately* disable a component without recompiling. [S1]

---

## 4. Workspace module or plugin does not load

**Symptom** — your Task, Tile or Plugin is absent from the list in Config Tool or Security Desk.

**Probable causes** [S1]
1. Registration missing or in the wrong place for the Security Center version
2. `AddFoldersToAssemblyProbe` not set while the DLL has sibling dependencies — "the module will not load" and "Security Center does not display an error or warning in the user interface"
3. Invalid or missing DLL path — "the corresponding component will fail silently"
4. Missing or wrong certificate
5. `Enabled` not `True`/`1`
6. Server-side plugin not discovered by `Genetec.Utility32`

**Checks — in order**
1. **About → Installed Components → File versions**: find your integration; the `Path` should point at your DLLs.
2. Registration location matches the version:
   - 5.12.x and earlier → registry, **both** `HKEY_LOCAL_MACHINE\SOFTWARE\Genetec\Security Center\Plugins\` and `…\WOW6432Node\…`
   - 5.13.0.0–5.13.2.x → `C:\ProgramData\Genetec Security Center\PluginInstallations\Plugins\`
   - 5.13.3.x+ → `C:\Program Files (x86)\Common Files\Genetec System\PluginInstallations\Plugins\`
   - filename must end `.Plugin.xml`
3. Certificate mandatory for this component type? Is its `ApplicationID` the one tied to the part number on this licence?
4. Enable the Config Tool diagnostics module: installation folder → `ConfigTool.Modules.xml` → set `Enabled="true"` for `Genetec.Platform.Module.Diagnostic.dll` → restart Config Tool → biohazard tray icon → **Application logs → Loading workspace modules → Loading custom tasks modules (Connected = False)**. Errors appear in red; **Application diagnostics** has more detail.
5. Server-side plugin missing from the **Add Plugin** window: in Server Admin add loggers `Genetec.Reflection.PluginProvider` and `Genetec.Platform.Common.Core.PluginInstaller.PluginInstaller`, then kill the `Genetec.Utility32` process ("The process will restart automatically and create logs that show the plugins loading and errors for the plugins that are not working"), then retry adding the plugin and re-read the logs.

**Resolution** — correct the registration entry, add `AddFoldersToAssemblyProbe = True`, fix the DLL path, or supply the right certificate. On 5.13+ remember the plugin **file** is the source of truth; registry edits do not sync back to it, and uninstalling requires removing both. [S5]

---

## 5. Web SDK — connection actively refused

**Symptom** — `System.Net.WebException: Unable to connect to the remote server ---> System.Net.Sockets.SocketException: No connection could be made because the target machine actively refused it`

**Probable causes** [S1]
1. The **Web-based SDK** role is not added in Security Center
2. The role is deactivated
3. Ports 4590/4591 blocked, or the role uses different ports
4. Wrong server address or port
5. DNS resolution failure

**Checks**
- Config Tool → **System → Roles**: is `WebSdk` present, activated, and neither in warning nor error mode? "The WebSdk needs to be normally running."
- Send the request locally on the role's own server, e.g. `http://localhost:4590/WebSdk`, to rule out the network.
- Try the server's IP address instead of a DNS name.
- Confirm a firewall rule exists for 4590/4591 (Wireshark for stubborn cases).

**Resolution** — add or activate the role; open the ports; correct host/port.

---

## 6. Web SDK — HTTP 403 Forbidden

**Symptom** — `System.Net.WebException: The remote server returned an error: (403) Forbidden.`

**Probable causes** [S1]
1. Certificate `ApplicationId` not concatenated to the username
2. Wrong username or password
3. User lacks the `Log on using the SDK` privilege
4. Production certificate on a development system, or the reverse
5. Part number absent from the licence, or the licence has expired
6. Missing authorization header entirely

**Checks**
- The username field must be `<SCUser>;<ApplicationId>`:
```csharp
string securityCenterUsername = "Admin";
string securityCenterUserPassword = string.Empty;
string sdkCertificateApplicationId = "KxsD11z743Hf5Gq9mv3+5ekxzemlCiUXkTFY5ba1NOGcLCmGstt2n0zYE9NsNimv";
string webRequestUsername = string.Format("{0};{1}", securityCenterUsername, sdkCertificateApplicationId);
ICredentials webRequestCredentials = new NetworkCredential(webRequestUsername, securityCenterUserPassword);
```
- System ID prefix `DEM` = development licence.
- Reproduce locally with Postman against `http://localhost:4590/WebSdk` to eliminate the network.
- In Postman, temporarily disable SSL certificate validation to rule the CA out.

**Resolution** — fix the credential concatenation, grant the privilege, or use the matching certificate. "Note: Restart the Web-based SDK role after modifying users' privileges to ensure that all active sessions are closed, and changes are applied. To restart the role, you must first deactivate it and then activate it again." Distinction to keep straight: 401 = not authenticated; 403 = authenticated but not allowed. [S1]

---

## 7. Web SDK — HTTP 404 Not Found

**Symptom** — `System.Net.WebException: The remote server returned an error: (404) Not Found.`

**Probable causes** [S1]
1. Base URI in the request does not match the role's configured **Base URI**
2. The command is not a recognised API command / wrong syntax
3. Known bug
4. Lack of user privileges

**Checks**
- Config Tool → **System → Roles → WebSdk → Properties → Base URI** — compare character-for-character with your URL.
- Validate the command against the Web SDK **Postman collection**.
- Remember GUID dashes "must either be escaped or removed in an HTTP request", and `#` is an excluded character.

**Resolution** — correct the base URI or the command syntax. For values containing URL-encoded slashes (`%2f`), switch to the documented query-parameter forms, e.g. `/customField/{entityGuid}/{customFieldName}?val={value}`. [S1]

---

## 8. Web SDK — TLS handshake failed

**Symptom** — `System.IO.IOException: The handshake failed due to an unexpected packet format.` inside `The underlying connection was closed: An unexpected error occurred on a send.`

**Cause** — "The URL request is formed with an HTTPS but the WebSdk role is not configured to use SSL." [S1]

**Resolution** — either use `http://`, or turn on SSL for the role: Config Tool → System → Roles → WebSdk → Properties → **Use SSL connection = On** → Save. Requirements: valid SSL certificate installed on the host, certificate name in the **Certificate** textbox, and the certificate bound to the port (`Bind certificate to port = On` requires it registered as a local computer personal certificate). Supported: TLS 1.0–1.3. [S1]

---

## 9. Web SDK — SSL trust relationship could not be established

**Symptom** — `System.Security.Authentication.AuthenticationException: The remote certificate is invalid according to the validation procedure.` inside `Could not establish trust relationship for the SSL/TLS secure channel.`

**Probable causes** [S1]
1. The client computer does not trust the certificate used by the WebSdk role
2. The domain name in the URL does not match the certificate's Common Name (`CN=`)

**Checks**
- Compare the URL hostname with the certificate `CN`.
- Was the certificate signed by a trusted root CA?

**Resolution** — use the certificate's own domain name in the URL; or add the root CA to **Trusted Root Certification Authorities** on the client using `mmc.exe` / Windows *Install Certificate*. Doc caution: "Perform this action with caution because your computer trusts all certificates signed by this Root Authority." For the Genetec Server certificate specifically, the signing root CA "needs to be present in the 'Trusted Root certificate authorities' of Windows" on every client. [S1]

---

## 10. Not receiving EntitiesInvalidated or other events

**Symptom** — you subscribed to `Engine.EntitiesInvalidated` (or `EventReceived`) but the handler never fires after a configuration change.

**Cause** — verbatim: "The problem is that the system does not know what data you want to receive updates for… When an entity is modified by an application, the Directory only sends invalidated events to applications that are **using** that entity." [S1]

**Resolution** — touch at least one property of the entity so the Directory registers your interest:
```csharp
m_sdkEngine.EntitiesInvalidated += new EventHandler<EntitiesInvalidatedEventArgs>(OnSdkEngineEntitiesInvalidated);
Alarm myAlarm = m_sdkEngine.GetEntity(GuidOfYourFavoriteAlarm) as Alarm;
string name = myAlarm.Name; // touching a property registers interest
```
The doc notes this "applies to events of any type (for example, `EventReceived`, and so on)."

Related trap: if you called `Engine.SetEventFilter(...)` to reduce load, events outside the filter will never arrive by design. [S1]

---

## 11. AuditTrailQuery returns TooManyResults

**Symptom** — `ReportError.TooManyResults` from an `AuditTrailQuery`.

**Cause** — the result set exceeds `MaximumResultCount`, or the default of **100,000 results**. [S1]

**Resolution** — loop in time-sliced batches, advancing the window using the last row's timestamp. Documented pattern:
```csharp
var auditQuery = Sdk.ReportManager.CreateReportQuery(ReportType.AuditTrailsReport) as AuditTrailQuery;
var completed = false;
while (!completed)
{
    auditQuery.TimeRange.SetTimeRange(startTime, lastTimeStamp);
    auditQuery.MaximumResultCount = 1000;

    var queryAudit = await Task.Factory.FromAsync(auditQuery.BeginQuery(null, null),
        asyncResult => auditQuery.EndQuery(asyncResult)).ConfigureAwait(false);

    foreach (DataRow entities in queryAudit.Data.Rows)
    {
        lastTimeStamp = (DateTime)entities[AuditTrailQuery.ModificationTimestampColumnName];
        // ... collect
    }

    if (queryAudit.Error != ReportError.TooManyResults) completed = true;
    else await Task.Delay(100);
}
```
Store results in a `HashSet<Guid>` and `Distinct()` at the end, because batch boundaries overlap on the timestamp. [S1]

---

## 12. Query returns no results, or the app hangs at the query

**Symptom** — a query completes with zero rows, or execution blocks at the query call.

**Probable causes, most likely first** [S1]
1. **Not actually connected yet** — "Wait for the `Engine.LoggedOn` event to be raised before trying to query the server."
2. **Running inside a Transaction** — "Queries cannot be run inside a Transaction, unless triggered on a different thread. If your application hangs at the Query method, make sure you are not trying to run the query after a `Engine.TransactionManager.CreateTransaction` statement."
3. **Scalability** — criteria too broad. Security Desk caps at 10,000 results. Overly general criteria "could cause the SQL fail, the role to run out of memory, or the application to freeze."
4. **Invalid query criteria.**

**Checks**
- Run the equivalent query in **Security Desk**. If Security Desk returns rows, the fault is in your criteria — strip the query back and reintroduce criteria until it breaks.
- Add Server Admin loggers `Genetec.Directory.BusinessObjects.Workflows.WFQuery` and `Genetec.Sentinel.DSProxy.Workflows.WFEntity`.

**Resolution** — set `MaxResultCount`, narrow the time range, or split into several short-range queries. Use pagination (`Page`/`PageSize`) on `EntityConfigurationQuery` as standard practice. Move the query off the transaction thread. [S1]

---

## 13. Timestamps are wrong

**Symptom** — timestamps from the SDK do not match local time.

**Cause** — "By default, the SDK produces and uses **UTC-based timestamps**." [S1]

**Resolution** — convert with `ToLocalTime` and `ToUniversalTime` on `DateTime` "unless specified otherwise." The same applies to the Web Player: "Internally, all dates and time in Security Center are UTC. Convert them to the local time zone for display." [S1]

---

## 14. ASP.NET app works in Visual Studio but fails under IIS

**Symptom** — under IIS the app reports DLLs that cannot be found "even if the DLL is present in the deployment folder."

**Cause** — IIS **shadow copy** is enabled by default. "When the Shadow copy is performed, IIS copies the web-service files to a temporary folder and has all the assemblies loaded from that folder. Unfortunately the shadow copy process does not copy all the required DLLs." [S1]

**Resolution — two documented options**
1. Disable shadow copy in web.config: `<hostingEnvironment shadowCopyBinAssemblies="false"/>` — "At this point, the assemblies are loaded from the deployment folder."
2. Resolve assemblies yourself: add to `AssemblyInfo.cs`
```csharp
[assembly: PreApplicationStartMethod(typeof(YourNamespace.Initializer), "Initialize")]
```
   and hook `AppDomain.CurrentDomain.AssemblyResolve` in that `Initializer`, probing the executing assembly's folder and then the Security Center install folder.

Either way, reference `Genetec.SDK.dll` with **Copy Local = False** for it and every other SDK DLL. [S1]

---

## 15. ASP.NET 64-bit application does not start

**Symptom** — the 64-bit ASP.NET application will not start.

**Causes** [S1]
1. `Genetec.Sdk.dll` or other required files are not imported into the project
2. Some DLLs are auto-copied to `bin/debug` by the build and **need to be removed**

**Resolution** — add these post-build event commands:
```bat
del /F "$(TargetDir)Genetec.*.Interop.dll"
del /F "$(TargetDir)Genetec.Codec.AvCodec.dll"
del /F "$(TargetDir)DecodingBenchmark.dll"
del /F "$(TargetDir)Genetec.Nvidia.dll"
del /F "$(TargetDir)Genetec.QuickSync.dll"
```

---

## 16. Cannot view video in an SDK application

**Symptom** — the application runs but no video appears, or the player never leaves *starting*.

**Ordered procedure straight from the docs** [S1]

1. **Check the platform the app runs under.** For projects in development check project properties; for deployed apps use Task Manager (a **Platform** column on newer OS, or `*32` suffix on older ones).
   - 5.3 SDK or earlier: Platform target must be `x86`
   - 5.4 SDK or later: `x86`, `x64` or `Any CPU`
   - Exception, any version: `VideoSourceFilter` with YUV→RGB colour conversion requires `x86`
2. **Legacy runtime activated** in the `.exe.config` alongside the application at runtime:
```xml
<configuration>
  <startup useLegacyV2RuntimeActivationPolicy="true">
    <supportedRuntime version="v4.0" sku=".NETFramework, Version=v4.8"/>
  </startup>
</configuration>
```
3. **Firewall.** The Security Center client installer creates firewall exceptions for Security Desk/Config Tool; your app may need adding manually. Run the **MediaPlayer SDK sample**: "When the player remains in starting state, no bitrate is shown, and the stream is not received, the most likely issue is the firewall. If the MediaPlayer shows a bitrate for a live stream, the stream is received but is not rendered because of missing files."
4. **Dependency issues.** Try running the app from the `Program Files (x86)\Genetec Security Center SDK` folder, or (5.7+) from the `GSC_SDK` location with administrator privileges. Then add the `xcopy` post-build steps (`avcodec*`, `avformat*`, `avutil*`, `Genetec.*MediaComponent*`, `Genetec.Nvidia.dll`, `Genetec.QuickSync.dll`, `libajpeg2000.dll`, `swscale*`, `swresample*`) — full lists in `install-upgrade.md`.
5. **Omnicast federated cameras** — install the **Compatibility Pack ("CPack")** on the client computer (request it from SDK support, giving the Omnicast version), **restart the computer**, and add the three extra `xcopy` lines for `Genetec.Media.OmnicastMediaExtension.dll`, `Genetec.Omnicast.Sdk.dll`, `Genetec.ServiceModel.Compatibility.dll`.
6. **Wrong NIC** — on a multi-NIC machine, experiment with the network card options in the MediaPlayer sample and compare with Security Desk/Config Tool. If that fixes it, use the `Initialize` overload taking `PhysicalAddress networkAdapterBinding`.
7. **Wrong client network** — same approach; check the Config Tool **Network** page. If that fixes it, use the `Initialize` overload taking `Guid clientSubnet`.
8. **Prove it is an SDK problem** — "Make sure that you can view video using Security Desk or Config Tool, on the same computer. If it does not work in the Security Center client application, the issue is unrelated to the SDK."
9. **Collect diagnostics** (optional but "highly valuable"): stop all video streams everywhere; copy `logTargets.gconfig` from the SDK samples into the MediaPlayer sample execution folder (creates a `Logs` subfolder); start a network capture; run the sample and request a stream; note the time; stop the capture and close the player; zip the capture with the `Logs` subfolder.
10. **Contact the Genetec TAC** with: your observations for your app, the MediaPlayer sample and Security Desk; everything from the steps above; and the product version of all Genetec products on the computer.

Also check the licence: "Using objects from the `Genetec.Sdk.Media` assembly requires specific licensing options" — **Media SDK**, and the **Genetec Web Player library** option where relevant. The basic SDK package does not include Media SDK; an NDA is required. [S1]

---

## 17. Unexpected GenetecServerHost32.exe / GenetecMediaComponent32.exe processes

**Symptom** — multiple copies of these processes in Task Manager while using `MediaPlayer` or `VideoSourceFilter`.

**Cause** — expected behaviour: this is **out-of-process decoding**. "The number of these extra copies depends on the number of cores in your system (`GenetecServerHost32.exe`) and the number of cameras being streamed (`GenetecMediaComponent32.exe`)." Benefits stated: memory usage spread over several processes, and fault isolation when decoding. [S1]

**Resolution** — only act if there are **more `GenetecServerHost32.exe` copies than CPU cores**: "run your application as Administrator to resolve the issue." The `GenetecMediaComponent32.exe` count "is not controlled by the SDK and cannot be changed." [S1]

---

## 18. FileNotFoundException: Genetec.FeatureFlag.Settings.exe after upgrade

**Symptom** — after upgrading the SDK to 5.14.0.0 or later: `FileNotFoundException: Unable to run Genetec.FeatureFlag.Settings.exe.`

**Cause** — "New required components have been added to the Security Center 5.14 SDK… If you attempt to upgrade to Security Center 5.14 SDK without running the SDK installer, the required components aren't all deployed to the correct location." [S3]

**Resolution** — "reinstall the Platform SDK and the Media SDK by running the installer inside the Security Center 5.14.x.y SDK package."

**Note** — "Running the SDK installer is necessary only if you initially installed the SDK separately. If you used the Security Center installer, which includes the SDK components, a separate SDK installation isn't required." [S3]

Related defect: "A non-admin Windows user cannot run SDK applications on machines where the Plugins folder does not exist at: `C:\Program Files (x86)\Common Files\Genetec System\PluginInstallations\`" — issue **4749948**, resolved in 5.14.0.0. [S3]

---

## 19. Mixed mode assembly exception / odd runtime behaviour

**Symptom** — either `Mixed mode assembly is built against version 'v2.0.50727' of the runtime and cannot be loaded in the 4.0 runtime without more configuration information`, or "strange runtime behavior (for example, setting the cardholder status disconnects the SDK)".

**Cause** — legacy runtime activation policy not enabled. [S1]

**Resolution** — "turn the Legacy Runtime on":
```xml
<startup useLegacyV2RuntimeActivationPolicy="true">
  <supportedRuntime version="v4.0" sku=".NETFramework, Version=v4.8"/>
</startup>
```

---

## 20. Web Player — Unsupported codec

**Symptom** — the player shows an `Unsupported codec` error.

**Cause** — "By default, transcoding is disabled on the Media Gateway role because of its intensive CPU requirement. As a result, video codecs incompatible with your browser are not playable and an `Unsupported codec` error is displayed in the player." [S1]

**Resolution** — "If full compatibility with all cameras is required, you can enable transcoding in Media Gateway role configurations." Weigh the CPU cost. Note also that only **AAC** audio is supported, and reverse playback is only smooth for MJPEG. [S1]

---

## 21. Web Player — cannot connect or stream drops

**Symptom** — `webPlayer.start()` rejects, or streaming stops mid-session.

**Probable causes** [S1]
1. **CORS** — since 5.10.4.1 the Media Gateway enforces cross-origin rules. "Ensure the Media Gateway is configured to accept the web page's origin." A custom `<AllowedOrigin>` list in `ConfigurationFiles\MediaGateway.gconfig` is required for custom web pages.
2. **Token problems** — invalid token, or an expired token that was not renewed. "When the token expires, it must be renewed or the connection will be dropped."
3. **Version mismatch** — "The version of the `gwp.js` library must always match the version of the Media Gateway it is connected to." Cache `gwp.js` on your web server but "remember to refresh the cache when Security Center is updated or upgraded."
4. **Wrong parameters** — camera GUID must be in 8-4-4-4-12 string form, e.g. `"00000001-0000-babe-0000-080023e940c6"`; the Media Gateway endpoint must be the **public address of a specific agent**.
5. **Ports 80/443 not open**, or the page and gateway not both reachable by the browser.
6. **Licence** — the Genetec Web Player library option "is validated when connecting to Media Gateway".

**Reconnect semantics** — once started, the player retries by itself and raises `onStreamStatusChanged` with `ConnectingToMediaGateway` after a timeout. Some `StreamingConnectionStatus` values are **non-recoverable** and require `stop()` then `start()` again: **`NotEnoughBandwidth`, `MediaRouterStreamNotFound`, `StreamUnreachable`, `UnauthorizedToken`**. [S1]

**Diagnostics** [S1]
- `player.showDebugOverlay(true)` or **Ctrl+Shift+A** with the canvas focused (suppressible by intercepting `keydown` during the capture phase)
- `gwp.enableLogs()` / `gwp.disableLogs()` in the browser console; GWP log lines are prefixed with a distinctive Unicode hamster character to make filtering easy
- `console.log(gwp.version)` — "For support, always specify the GWP version and the Security Center version"
- Server side: `http://localhost:6001/genetec/DebugConsole` on the agent, enable the `Genetec.Media.Gateway` logger

**Design constraint worth checking** — "The Genetec Web Player is designed to play streams: Do not send commands (ex: Adding a bookmark). Use the standard SDK or REST SDK for these use cases. The only exception is PTZ control." [S1]

---

## 22. Macro does not appear in the Server Admin logger list

**Symptom** — you cannot find your macro when adding loggers in the debug console.

**Resolution — documented sequence** [S1]
1. "Make sure you add a `MacroLogger.Trace` method to the macro."
2. "Run the macro at least once."
3. "Reload the Server Admin page and sign in again."

**Trap** — search by the macro's **program name**, not its entity name in Config Tool: "Be careful not to confuse the name of your macro with its name as an entity in Config Tool." [S1]

---

## 23. Web SDK custom field name returns an error

**Symptom** — fetching a custom field value through the Web SDK errors because of characters in the field's **name**.

**Cause** — "When using the Web SDK to fetch custom field values, there are characters that return an error if queried when they appear in the field's name." [S1]

**Note on grounding** — the source topic states that a list of invalid characters exists but the retrieved page body contains only the working example
```
GET http://localhost:4590/WebSdk/customField/{e18d974c-a019-46fd-a486-e0da356a3d7e}/fieldName
```
and does not enumerate the characters. **The specific invalid-character list is therefore recorded as a gap** — see `known-gaps.md`. Do not invent it.

**Related and documented** — `#` is an excluded character in Web SDK URLs generally, and values containing URL-encoded slashes (`%2f`) require the alternate query-parameter endpoints. [S1]

---

## 24. CustomCardFormat causes compile-time errors

**Symptom** — using the `CustomCardFormat` class produces compile-time errors.

**Cause** — issue **4900071**, first reported in 5.14.0.0: the class "exposes properties (`Type`, `Data`, `FormatFields`, and `ParityChecks`) whose types are not part of the SDK, resulting in compile-time errors if no additional assemblies are referenced." [S3]

**Workaround, verbatim** — "Add references to `Genetec.Data.dll`, `Genetec.Sentinel.Credentials.dll`, and the assemblies that define `FormatFieldDefinition` and `ParityCheck` in projects using these properties." [S3]

Custom card format management itself arrived in 5.13.0.0 via `CustomCardFormatService` on the `SystemConfiguration` entity, and needs the `AccessControlGeneralSettingsTabPrivilege`. [S5]

---

## 25. .NET Core report deserialization fails past 20 results

**Symptom** — on .NET Core / .NET 8, reports with more than 20 results fail to deserialize.

**Cause** — issue **4502494**. **Resolved in Security Center 5.14.0.0 SDK.** [S3]

**Resolution** — upgrade to the 5.14.0.0 SDK or later. Below that, keep result counts at or under 20 per call, or use the .NET Framework 4.8 build. **[INFERRED — verify]** the workaround wording is not in the docs; only the fix is.

---

## 26. Cardholder group membership not reflected after removal

**Symptom** — after removing a cardholder from a cardholder group via SDK or Web SDK, the `Cardholder` entity still lists the group, while Config Tool shows it removed.

**Cause** — limitation **2911778**, first reported 5.10.3.0, still listed in the 5.14.0.0 release notes. [S3]

**Workaround, verbatim** — "Ensure that the cardholder and cardholder group properties are both removed at the same time from the SDK or Web SDK." [S3]

Related area limitation **3819660** (5.12.2.0): "If a cardholder is in an area and is deleted while the Access Manager is offline, the area incorrectly continues to report that the cardholder is present." Workaround: "Retry the action after the Access Manager is back online." [S3]

---

## 27. Security Desk / Config Tool deadlock from a Contextual Action

**Symptom** — Security Desk and Config Tool deadlock.

**Cause** — limitation **2483630**, first reported 5.9.3.0: "Running synchronous queries from the `CanExecute` method of Contextual Action components deadlocks Security Desk and Config Tool." [S3]

**Workaround, verbatim** — "Use asynchronous queries (`BeginQuery`) instead." [S3]

Related: limitation **1766032** (5.7 SR3) — "Can't use asynchronous operations within an SDK transaction. When used, the operations aren't completed inside the transaction as expected." Workaround: "Use synchronous methods for these operations, when available." Note that these two limitations pull in opposite directions, so the choice depends on whether you are inside a transaction or inside `CanExecute`. [S3]
