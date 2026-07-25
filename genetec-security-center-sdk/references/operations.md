# Operations — Genetec Security Center SDK

Sources: S1 (Developer Guide 5.14), S6 (RN 5.12.2.0), S8 (RN 5.11.0.0), S11 (DAP).

Everything here is what the SDK documentation states. Platform-level operations (Genetec Server service management, database maintenance plans, failover configuration) belong to the Administrator Guide and are **not** in this doc set — see `known-gaps.md`.

## Contents
1. Start / stop / restart
2. Server Admin debug console
3. Loggers worth knowing
4. Trace logger (export logs to file)
5. Application-side diagnostic consoles
6. Custom Server Admin commands (debug methods)
7. Health checks
8. Monitoring hooks
9. Session and connection lifecycle
10. Scheduled / periodic behaviour
11. Scalability and throttling
12. Macro operations

---

## 1. Start / stop / restart [S1]

| Target | Procedure |
|---|---|
| **Web-based SDK role** | Config Tool → right-click the role → **Maintenance** → deactivate, then activate. "To restart the role, you must first deactivate it and then activate it again." Required after modifying user privileges "to ensure that all active sessions are closed, and changes are applied" |
| **Directory** | Check whether it is turned off in **Server Admin**; turn it back on. Also check whether the Directory database needs an upgrade |
| **Genetec Server service** | "restarting the Genetec Server service usually resolves this issue" — documented remedy for `ConnectionStateCode.Failed` |
| **Plugin discovery** | Kill the `Genetec.Utility32` process in Windows. "The process will restart automatically and create logs that show the plugins loading and errors for the plugins that are not working" |
| **Config Tool / Security Desk** | Restart after enabling the diagnostics module, or after adding/removing `.cert` files (removing a certificate and restarting is the documented way to disable a feature without recompiling) |
| **Media Gateway agent** | Editing `ConfigurationFiles\MediaGateway.gconfig` is per-agent; the doc does not state whether a restart is required — **[INFERRED — verify]** a role or service restart is likely needed for CORS changes to take effect |
| **Your SDK application** | `Engine.LogOff()` / `BeginLogOff()` releases the SDK connection. Dispose `MediaPlayer`/`VideoSourceFilter` only after calling `Stop()` |

No `sc.exe`, `net start`, PowerShell cmdlet or CLI service name is given anywhere in this doc set. Logged in `known-gaps.md`.

---

## 2. Server Admin debug console [S1]

Two documented ways in:
- Open **Server Admin**, select your server, go to **Actions → Console**
- Browse directly to `/localhost/genetec/DebugConsole?serverId=`

Adding loggers:
1. Click the **Add (+)** button.
2. Search for the logger by name.
3. Select it from the list.
4. Enable the severities that matter (Debug, Warning, Error, Fatal, Information, Performance).
5. **Add**.

"You can double-click logs in the console to get more information."

---

## 3. Loggers worth knowing [S1, S6]

| Problem area | Logger name |
|---|---|
| Connection issues | `Genetec.Directory.BusinessObjects.Workflows.WFLogin` |
| Connection issues | `Genetec.Directory.Proxy.Workflows.Login.WFLogin` |
| Query issues | `Genetec.Directory.BusinessObjects.Workflows.WFQuery` |
| Query issues | `Genetec.Sentinel.DSProxy.Workflows.WFEntity` |
| Event issues | `Genetec.Sentinel.DSProxy.Workflows.WFEvent` |
| Alarm issues | `Genetec.Sentinel.DSProxy.Workflows.WFAlarm` |
| Alarm issues | `Genetec.Directory.BusinessObjects.Workflows.Alarm.WFAlarm` |
| Plugin discovery | `Genetec.Reflection.PluginProvider` |
| Plugin installation | `Genetec.Platform.Common.Core.PluginInstaller.PluginInstaller` |
| Web SDK sessions | `Genetec.Sdk.Web` — set the **Debug** log-level to `true` to get session traces from `UpdateLastUsageTime()`, `InitializeCleanupTimer()` and `CheckSdkSessionsTimeout()` (added 5.12.2.0) |
| Media Gateway | `Genetec.Media.Gateway` (via `http://localhost:6001/genetec/DebugConsole`) |
| Your macro | The **macro's own name** — "Be careful not to confuse the name of your macro with its name as an entity in Config Tool" |

The docs note the full logger list "is extensive"; the above are the ones called out as most pertinent.

---

## 4. Trace logger — exporting to text files [S1]

1. Open the **Trace logger** tab.
2. Click **Add (+)** to create a new tracer.
3. Fill in the required fields — the name of the tracer and the folder location for the logs.
4. Click **Add (+)** to add loggers to the tracer.
5. Search and add loggers, same as in the console.
6. **Save**.
7. Start (or enable) the tracer using the **Start** button.

"Tracers that are currently running are displayed in green."

---

## 5. Application-side diagnostic consoles [S1]

| Application | URL |
|---|---|
| Security Desk | `localhost:6020/Genetec/Overview` |
| Config Tool | `localhost:6021/Genetec/Overview` |
| Plugin | `localhost/Genetec/Overview` |
| Media Gateway agent | `http://localhost:6001/genetec/DebugConsole` |
| Your own SDK application | `localhost:6023/console` after `DiagnosticServer.Instance.InitializeServer(diagnosticServerPort: 4523, webServerPort: 6023)` |

Constraint: "Ensure that `webServerPort` is not used by another application and is bound to a certificate."

Config Tool also has a richer diagnostics window once `Genetec.Platform.Module.Diagnostic.dll` is enabled in `ConfigTool.Modules.xml` — biohazard tray icon → **Application logs** / **Application diagnostics**.

---

## 6. Custom Server Admin commands (debug methods) [S1]

You can add your own commands to the **Commands** list of the Server Admin console. "Clicking on the command executes the code."

Instance variant (class holds an instance logger):
```csharp
class InstanceClass : IDisposable
{
    private readonly Logger m_logger;
    private InstanceClass() => m_logger = Logger.CreateInstanceLogger(this);
    public void Dispose() => m_logger.Dispose();

    [UserCommand("MyCategory")]
    [DebugMethod()]
    public void InstanceCommand() => m_logger.TraceDebug($"{nameof(InstanceCommand)} was called");
}
```

Static variant (class holds a class logger):
```csharp
static class StaticClass
{
    private static readonly Logger s_logger = Logger.CreateClassLogger(typeof(StaticClass));

    [UserCommand("MyCategory")]
    [DebugMethod()]
    public static void StaticCommand() => s_logger.TraceDebug($"{nameof(StaticCommand)} was called");
}
```

"Debug methods are capable of accepting zero or more primitive type parameters and can either return a string or have a void return type."

---

## 7. Health checks

There is **no documented health-check endpoint or command** for the Platform SDK, the Directory, or the Media Gateway. What the docs do give:

| Check | How | Expected healthy result | Source |
|---|---|---|---|
| Web SDK role reachable and credentials valid | `GET http://localhost:4590/WebSdk/` in a web browser | A **Sign in** prompt. "Failing to get a Sign In window from your web browser could indicate that the configuration of your WebSDK role might be problematic." Invalid credentials produce a 403 | S1 |
| Web SDK session keep-alive / warm | `GET https://{server}:{port}/{baseUrl}/` every ≤5 minutes | 200; session and entity cache stay warm | S1 |
| Web SDK role state | Config Tool → System → Roles | Role displayed in **white** — not red (error) or yellow (warning) | S1 |
| License and certificate state | Config Tool → About → **Certificates** | Your certificate listed, connection count below the maximum (e.g. not `10/10`) | S1 |
| Web SDK licensed | Config Tool → About → Security Center | **Web SDK** shown as supported | S1 |
| Development vs production license | System ID on the About page or GTAP | Prefix `DEM` = development license | S1 |
| Integration DLLs actually loaded | About → **Installed Components** → File versions | Your DLL listed with the expected `Path` | S1 |
| Video path healthy | Run the MediaPlayer SDK sample | Bitrate displayed and picture rendered | S1 |
| Web Player health | `gwp.version` in the console; `showDebugOverlay()` / `Ctrl+Shift+A` | Version matches the Media Gateway version | S1 |
| Macro is alive | Add the macro's logger in Server Admin after running it once | Trace entries appear | S1 |

Because the docs contain no deterministic read-only CLI or PowerShell commands, this skill ships **no `scripts/` directory**.

---

## 8. Monitoring hooks

| Hook | Status | Detail |
|---|---|---|
| **Event Tracing for Windows (ETW)** | Supported | `EtwLogTarget` — keys `providerName`, `AutoRegisterEventLog`, `EventLogMaxSizeInMegabyte` (100) |
| **Windows Event Viewer** | Supported | `EventLogTarget` — key `EventViewerLoggerName` |
| **SQL Server log sink** | Supported | `SqlServerLogTarget` — `Server`, `Database`, `MaxNumberOfErrors` (10), `MaxWorkItems` (2000), `MaxLogEntries` (2000), `CleanupTime` (0) |
| **File / XML log sinks** | Supported | `LogFileTarget`, `XmlLogTarget` |
| **Event subscription via SDK** | Supported | `Engine.EventReceived` + `Engine.SetEventFilter(...)`; Web SDK `/events`, `/events/subscribe`, `/events/unsubscribe` |
| **Entity change notification** | Supported | `Engine.EntitiesInvalidated` — **but you only receive it for entities you have touched** (see `troubleshooting.md`) |
| **Background task notifications to operators** | Supported (5.11.0.0+) | `IBackgroundProcessNotificationService` |
| **SNMP** | **Not documented** | — |
| **Syslog** | **Not documented** | — |
| **Prometheus / metrics endpoint** | **Not documented** | — |
| **Webhooks (outbound HTTP from Security Center)** | **Not documented** as a first-class feature. Closest documented mechanism: a macro can send HTTP requests ("Sending HTTP requests from a Macro"), and Event-to-Action can trigger SDK actions | S1 |

---

## 9. Session and connection lifecycle

### 9.1 Platform SDK [S1, S11]
- One SDK connection is consumed per successful `LogOn`; released on `LogOff`. "If you are running X instances of an application concurrently or if you have X Engine used at the same time, you need X SDK connections."
- Subscribe to `LoggedOn`, `LoggedOff`, `LogonFailed`, `LogonStatusChanged` on `Engine.LoginManager`; **unsubscribe at shutdown** "to avoid keeping events subscription in the memory".
- `LoggedOffEventArgs.AutoReconnect` indicates whether the SDK will retry by itself.

### 9.2 Web SDK [S1, S11]
- The server "initiates a session for each user and application ID combination upon receiving its first request." Creating it involves connecting to the Directory, authenticating the user, and validating the user privilege and application ID.
- The session maintains an **internal entity cache**.
- "Each session remains active as long as it receives a request every five minutes or less."
- One SDK connection per request; an **event listener consumes a persistent connection**.
- "Having a single user per application is advisable to prevent multiple entity caches from loading the same entities."
- A second concurrent user requires a second certificate connection.

### 9.3 Workspace SDK [S1, S11]
- One SDK connection **per registered component, per signed-in client application**. A component is a class inheriting `Genetec.Sdk.Workspace.Components.Component`, registered by `Workspace.Components.Register(myComponent)`.
- Documented example: "if a user is logged in Config Tool and Security Desk simultaneously, with three registered components, the application consumes six SDK connections."
- Each open task using a `CustomPage` consumes one connection; two open custom pages = two connections.
- Multiple tiles sharing one overlay still consume only one connection. `ContentBuilder` takes one connection.

### 9.4 Plugin SDK [S11]
- "only one connection is required per plugin role added to the system." Two plugin roles = two connections.

### 9.5 Macro SDK [S11]
- "The usage of macros doesn't require a certificate part. Thus, no SDK connections are needed."

---

## 10. Scheduled / periodic behaviour

| Job | Default | Source |
|---|---|---|
| Web SDK session timeout sweep | Session expires after **5 minutes** without a request; internals are `InitializeCleanupTimer()` / `CheckSdkSessionsTimeout()` / `UpdateLastUsageTime()` | S1, S6 |
| `LogFileTarget` retention | `deleteOlderThanNDays = 14` | S1 |
| `XmlLogTarget` retention | `retentionPeriodInDays = -1` (no expiry); `TotalMaximumFileSizeInMegabytes = 1024` | S1 |
| `SqlServerLogTarget` cleanup | `CleanupTime = 0` | S1 |
| Macros | Run manually, on a **schedule**, or on a triggering event; configured in Config Tool | S1 |
| Archive transfer | Can be triggered by event-to-action or scheduled task using the `StartArchiveTransfer` action (5.12.2.0+) | S6 |
| Saved report tasks | Can be executed from the SDK and from the Web SDK | S1 |

**Database cleanup behaviour for Directory and role databases is Not documented** in the SDK doc set. Logged in `known-gaps.md`.

---

## 11. Scalability and throttling [S1]

Four scalability failure modes the docs call out, with their fixes:

| Problem | Fix |
|---|---|
| **Receiving too many entity events** — by default `Engine.EventReceived` fires for any event from monitored entities | `_sdk.SetEventFilter(new[] { EventType.AlarmTriggered, EventType.AlarmAcknowledged });` — restrict to what you need, reducing load on both sender and receiver |
| **Repeatedly fetching entities from the database** — "repeatedly using `Engine.GetEntity` to fetch entities can cause the server and the Directory to crash" | Prefetch with `EntityConfigurationQuery` (set `MaximumResultCount`, add `EntityTypes`, set `DownloadAllRelatedData = true`). After the query completes, entity access is served from the local cache with no round-trip |
| **Too many export requests** | "Only two simultaneous video exports are permitted by the Archiver in Security Desk; you should throttle to the same number" |
| **Video streaming leaks** | Explicitly call `MediaPlayer.Stop()` or `VideoSourceFilter.Stop()` **before** `Dispose()`. Use a **pool** of players/filters when switching cameras — "Security Desk uses a similar approach" |

Query hygiene [S1]:
- Wait for `Engine.LoggedOn` before querying.
- "Queries cannot be run inside a Transaction, unless triggered on a different thread." A hang at the query call usually means a query after `Engine.TransactionManager.CreateTransaction`.
- Security Desk caps queries at **10,000 results**. For activity queries always set `MaxResultCount` or narrow the time range; for wide ranges "perform multiple, small queries instead (each with shorter time frames)".
- Use **pagination** (`Page`, `PageSize`) on `EntityConfigurationQuery` and its subclasses as a matter of course: "pagination should be used whenever you are implementing an entity query to safeguard all future executions of your query, in case it grows in size."
- Group bulk entity modifications into a single transaction via `TransactionManager`.

Web SDK performance [S1]:
- Use `Accept: text/json`.
- Prefer `/entity?q=entity={entity},Prop1,Prop2` over `/entity/:id` or `/entity/basic/:id` and name only the properties you need.
- Batch multiple entities into one request (limited only by query-string length), including mixed entity types.
- `DownloadAllRelatedData=true` on `/report/EntityConfiguration`, `/report/CardholderConfiguration`, `/report/CredentialConfiguration` warms the cache — but "if you only need the basic information of an entity, it is not advisable".
- Keep sessions alive with a periodic request to the base URL.

---

## 12. Macro operations [S1]

- Macros run **on the Directory server** — relevant if the macro touches local resources such as files.
- Derive from `UserMacro` (default application domain) or `UserMacroWithSetup` (choose the **ApplicationDomain** shown under *Default execution context* on the macro's configuration page). "All macros with a matching ApplicationDomain are started in the same application domain by the Directory. To ensure isolation, it is recommended to use separate application domains, especially when a macro needs to trigger events that another macro must handle."
- The supplied `.NET` SDK inside a macro "is already logged as the admin user, so your code does have to deal with users and credentials" — no logon/logoff code required.
- Add the `SingleInstance` attribute to guarantee one instance at a time.
- Capacity guidance, verbatim: "Keep the number of running macros under control. For example, instead of using 1,000 macros to monitor individual cameras in a 1000-camera installation, write a single macro to monitor all 1,000 cameras simultaneously."
- Logging from a macro uses `MacroLogger`: `TraceDebug`, `TraceWarning`, `TraceError`, `TraceFatal`, `TraceInformation`, `TracePerformance`, or the structured form:
```csharp
var traceEntry = new Genetec.Sdk.Diagnostics.Logging.TraceEntry();
traceEntry.Message = "General message";
traceEntry.DetailedMessage = "Detailed message";
MacroLogger.Trace(Genetec.Sdk.Diagnostics.Logging.Core.LogSeverity.Information, traceEntry);
```
  `DetailedMessage` "is displayed when double-clicking a log entry".
- If the macro cannot be found in the console's logger list: add a `MacroLogger.Trace` call, run the macro at least once, then reload the Server Admin page and sign in again.
