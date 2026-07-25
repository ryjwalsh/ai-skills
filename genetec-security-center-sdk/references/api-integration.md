# API & Integration — Genetec Security Center SDK

Sources: S1 (Developer Guide 5.14), S2 (Reference Guide 5.14), S4 (RN 5.13.3.0), S5 (RN 5.13.0.0), S6 (RN 5.12.2.0), S8 (RN 5.11.0.0), S11 (DAP), S19 (code samples), S22 (Operations Center API).

## Contents
1. API surfaces at a glance
2. Platform SDK — authentication
3. Platform SDK — entities, queries, events, transactions, actions
4. Web SDK — base path and authentication
5. Web SDK — endpoint reference
6. Web SDK — query syntax
7. Web SDK — worked examples
8. Web SDK — serialization
9. Genetec Web Player — JavaScript API
10. Media Gateway — RTSP
11. Macro SDK
12. Workspace and Plugin SDK extension points
13. SDK connection consumption (licensing arithmetic)
14. Rate limits and quotas
15. Third-party integrations named in the docs
16. Adjacent Genetec REST APIs

---

## 1. API surfaces at a glance [S1]

| Surface | Type | Transport | Auth |
|---|---|---|---|
| Platform SDK | .NET class library (`Genetec.Sdk`) | TCP 5500, TLS | SDK certificate + Security Center user (or Windows credential, or security token) |
| Web SDK | "partly based on a REST style architecture" | HTTP 4590 / HTTPS 4591 | HTTP Basic, username field = `user;ApplicationId` |
| Media SDK | .NET class library (`Genetec.Sdk.Media`) | in-process + RTSP/RTP | Inherits the Platform SDK session; needs Media SDK licence option |
| Genetec Web Player | JavaScript / TypeScript library (`gwp.js`) | WebSocket over 80/443 | Media Gateway token from `POST /v2/token/{cameraId}` |
| Media Gateway RTSP | RFC 2326 RTSP | RTSP 654 | Credentials embedded in the RTSP URL |
| Macro SDK | C# source pasted into Config Tool | in-process in the Directory | Runs as `admin`; no certificate, no SDK connection |
| Workspace SDK | .NET extension points | in-process in Security Desk / Config Tool | SDK certificate per registered component |
| Plugin SDK | .NET role entity | in-process on the server | One connection per plugin role |

---

## 2. Platform SDK — authentication [S1]

Prerequisites: Security Center or SDK installed; a user with the `Log On using the SDK` privilege (or `Admin` by default).

```csharp
using Genetec.Sdk;

private readonly Engine m_sdkEngine;
m_sdkEngine = new Engine();
```
"you should only create one instance of the engine per project to avoid multiple communication channels to the directory."

| Method | Description (verbatim) |
|---|---|
| `LogOn` | "Overloaded. Synchronously log on to the Directory, specifying the port and a certificate key." |
| `LogOnAsync` | "Overloaded. Asynchronously log on to the Directory using a password." |
| `LogOnUsingSecurityToken` | "Overloaded. Synchronously log on to the directory." |
| `LogOnUsingSecurityTokenAsync` | "Overloaded. Asynchronously log on to the Directory using a security token obtained externally." |
| `LogOnUsingWindowsCredential` | "Overloaded. Synchronously log on to the Directory using windows credentials." |
| `LogOnUsingWindowsCredentialAsync` | "Overloaded. Asynchronously log on to the Directory using the current Windows credential." |
| `BeginLogOn` | "Overloaded. Asynchronously log on to the Directory" |
| `BeginLogOnUsingSecurityToken` | "Overloaded. Asynchronously log on to the Directory." |
| `BeginLogOnUsingWindowsCredential` | "Overloaded. Asynchronously log on to the Directory using windows credentials." |
| `BeginLogOff` | "Asynchronously log off" |
| `LogOff` | "Log off from the Directory" |

`BeginLogOn` and `LogOnAsync` are interchangeable; the former returns `IAsyncResult`, the latter a `Task` "and has more overload choices".

```csharp
var logonResult = await m_sdkEngine.LogOnAsync(directory, username, password);
m_sdkEngine.LogOn(directory, username, password);
m_sdkEngine.LoginManager.LogOnUsingSecurityToken(server, SecurityToken);
m_sdkEngine.BeginLogOff();
```

Events to subscribe on `Engine.LoginManager` — and to **unsubscribe at shutdown** "to avoid keeping events subscription in the memory": `LoggedOn`, `LoggedOff`, `LogonFailed`, `LogonStatusChanged`. Using an Active Directory user requires the Active Directory role to be configured in Security Center.

---

## 3. Platform SDK — entities, queries, events, transactions, actions [S1]

| Concern | API |
|---|---|
| Fetch one entity | `Engine.GetEntity(guid)` — hits the database if not cached. Do **not** loop over this on large systems |
| Fetch cached set | `Engine.GetEntities(EntityType.Camera)` after an `EntityConfigurationQuery` has warmed the cache |
| Prefetch / cache | `ReportManager.CreateReportQuery(ReportType.EntityConfiguration) as EntityConfigurationQuery`; set `MaximumResultCount`, `EntityTypes`, `DownloadAllRelatedData = true`; `BeginQuery(null, null)`; handle `QueryCompleted` |
| Pagination | `query.Page`, `query.PageSize` on `EntityConfigurationQuery` and subclasses. Loop until returned rows ≤ `pageSize` |
| Reports | `ReportType` enum. Named report queries include `AuditTrailQuery`, `CredentialConfigurationQuery` (`FormatType` filter added 5.12.2.0), `AccessControlRawEventReportQuery` (added 5.11.0.0), `VideoThumbnailQuery`, alarm activity, audit trail, door activity |
| Events | `Engine.EventReceived`; `Engine.SetEventFilter(new[] { EventType.AlarmTriggered, EventType.AlarmAcknowledged })`; `Engine.EntitiesInvalidated` (only fires for entities you have touched) |
| Custom events | Raise via `ActionManager`; register in the SystemConfiguration entity |
| Transactions | `Engine.TransactionManager.CreateTransaction()` — batch bulk edits. **No queries inside a transaction** unless on another thread; **no async operations inside a transaction** (limitation 1766032) |
| Actions | `ActionManager` — raise custom events, create event-to-actions, trigger alarms, display in tile |
| Alarms | `AlarmManager` — trigger, acknowledge |
| Incidents | `IncidentManager` |
| Privileges | `SecurityManager.IsPrivilegeGranted(...)`; partition exceptions via `Partition` methods added in 5.12.0.0 |
| Advanced settings | `AdvancedSettings.GetAdvancedSetting(string name)`, `GetAllAdvancedSettings()` — **read-only**, added 5.13.3.0, needs `GeneralSettingsAdvancedSettings` |
| Media | `MediaPlayer.Initialize(engine, cameraGuid)`, `PlayLive()`, `PlayArchive(DateTime utc)`, `Pause()`, `ResumePlaying()`, `Rewind()`, `PlaySpeed` (`PlaySpeed.Speed1X`, `Speed4X`), `State` (`PlayerState.Paused`), `Stop()` then `Dispose()` |

Entity GUIDs of note documented as literals: SystemConfiguration entity `00000000000000000000000000000007`, admin user `00000000000000000000000000000003`, a schedule `00000000000000000000000000000006`. [S1]

Class-level reference for every type and member is the **Security Center SDK Reference Guide 5.14** (S2), reachable at `/r/en-us/security-center-sdk-reference-guide-5.14/at-a-glance`.

---

## 4. Web SDK — base path and authentication [S1]

Base path pattern:
```
http(s)://<ServerAddress>:<HttpPort>/<baseUri>/
```
Samples throughout the docs use `http://localhost:4590/WebSdk/`. The **Port** and **Base URI** are properties of the Web-based SDK role.

Authentication is **HTTP Basic**, with a twist:
- Username field = the Security Center username, then a **semicolon**, then the `<ApplicationID>` content of your SDK certificate
- Password field = that user's password

```
Login:    jsmith;KxsD11z743Hf5Gq9mv3+5ekxzemlCiUXkTFY5ba1NOGcLCmGstt2n0zYE9NsNimv
Password: ilOveSc!
```

Rules [S1]:
- "Active Directory users cannot sign in to the Web SDK."
- The `ApplicationId` in the request is matched against the licence's SDK certificates. The sample `Kxs…Nimv` value "is for a SDK certificate valid on demo systems only. The related part number is `GSC-SDK`."
- "A production certificate is associated with a production part number. The part number must be visible in the Security Center license options. Otherwise, requests are forbidden (HTTP error 403)."
- "The part number format typically is `GSC-1SDK-DevelopmentCompany-Application`."

Dependencies: the licence needs the **Web SDK** option and an SDK certificate, and a **Web-based SDK** role must exist and be running — "since it is not a default role."

---

## 5. Web SDK — endpoint reference [S1]

All paths are relative to the base URI. Bracketed content is not literal.

**Entities**

| URL | Method | Description |
|---|---|---|
| `/entity/exists/{id}` | GET | "Validates that an entity exists." |
| `/entity/{id}` | GET | "Returns the public properties information of the entity." |
| `/entity/basic/{id}` | GET | "Returns base class public property of the entity." |
| `/entity?q={query}` | POST | "Gets/sets properties or call methods of an entity." |
| `/entity/{id}` | DELETE | "Deletes an entity." |

**Events**

| URL | Method | Description |
|---|---|---|
| `/events` | GET | "Listens for streaming events that the user has subscribe to." |
| `/events/subscribe?q={query}` | GET | "Subscribes to event types on given source entities." |
| `/events/unsubscribe?q={query}` | GET | "Unsubscribe event types on given source entities." |

**Alarms / Actions / Macros / Reports**

| URL | Method | Description |
|---|---|---|
| `/activealarms` | GET | "Get the active alarms." |
| `/action?q={query}` | POST | "Launches an action." |
| `/activemacros` | GET | "Get list of running macros" |
| `/report/{reportType}?q={query}` | GET | "Runs a Security Center reports and returns the results." |

**Custom fields**

| URL | Method | Description |
|---|---|---|
| `/customField/{entityType}/{customFieldName}/{customFieldType}/{defaultValue}` | POST | "Creates a custom field." |
| `/customField/{entityType}/{customFieldName}` | DELETE | "Deletes a custom field." |
| `/customField/{entityGuid}/{customFieldName}` | GET | "Retrieves the value of the custom field for a given entity." |
| `/customField/{entityGuid}/{customFieldName}/{value}` | PUT | Sets the value |
| `/customField/{entityType}/{customFieldName}/{customFieldType}?val={defaultValue}` | POST | Use when the value contains URL-encoded slashes (`%2f`) |
| `/customField/{entityGuid}/{customFieldName}?val={value}` | PUT | Same reason |

**Reports supporting paging**: `/report/EntityConfiguration`, `/report/CardholderConfiguration`, `/report/CredentialConfiguration` — these also accept `DownloadAllRelatedData`.

**Custom event helper endpoints**
```
/events/RaiseCustomEvent/{customEventId}/{entityId}/{message}
/events/RaiseCustomEvent/{customEventId}/{entityId}?msg={message}   (when message contains %2f)
```

---

## 6. Web SDK — query syntax [S1]

Special characters in the `q=` expression:

| Character | Meaning |
|---|---|
| `=` | "Set a property. Can be used for modification or research purposes." |
| `( )` | "Used to provide parameter values for a method." In a collection context, refers to an item at a specified index |
| `{ }` | "Used as a delimiter to enclose a value." In a collection context, initializes a new collection |
| `.` | "Used to call a method that belongs to the prepended item." |
| `@` | "When used as a prefix within an item collection, add the item to the collection." Chainable |
| `-` | "When used as a prefix within an item collection, remove the item from the collection." Chainable |
| `*` | "When used as a prefix within an item collection, clear the collection." |
| `\\` | "When used as a prefix for a parameter value, consider the value as a name. (As opposed to a method call)" |
| `#` | "Not supported. This is an excluded character." |

Encoding rules:
- "The dashes in guids must either be escaped or removed in an HTTP request."
- "Values need to be encoded in URLs. '%20' is used to encode the space character."
- "TimeSpan values are represented as strings with the format HH:MM:SS."

---

## 7. Web SDK — worked examples [S1]

Reproduced verbatim from the guide.

Create a door:
```
POST http://localhost:4590/WebSdk/entity?q=entity=NewEntity(Door),Name=Front%20Door,Guid
```
(The trailing `Guid` returns the new entity's GUID in the response.)

Create an alarm with properties:
```
POST http://localhost:4590/WebSdk/entity?q=entity=NewEntity(Alarm),Name=Alarm1,Priority=2,AutoAcknowledgmentDelay=0:05:00,ReactivationThreshold=0:01:00,Schedule=00000000000000000000000000000006
```

Read an entity by logical ID or GUID:
```
GET http://localhost:4590/WebSdk/entity/LogicalId(Alarm,1)
GET http://localhost:4590/WebSdk/entity/543b686c06e14304afa6fcef50242a5e
```

Set a property:
```
POST http://localhost:4590/WebSdk/entity?q=entity=LogicalId(Door,1),Name=Back%20Door
POST http://localhost:4590/WebSdk/entity?q=entity=a374769385ec49c0a8f653ac10ca0381,Name=Back%20Door
```

Call a method on an entity:
```
POST http://localhost:4590/WebSdk/entity?q=entity=6265b60e6a9741008296eceb656a610f,SetExtendedGrantTimeSeconds(30)
```

Add custom events to the SystemConfiguration entity:
```
POST http://localhost:4590/WebSdk/entity?q=entity=00000000000000000000000000000007,CustomEvents.Add(5000,test,Camera)
POST http://localhost:4590/WebSdk/entity?q=entity=00000000000000000000000000000007,CustomEvents.Add(123,\\CardEvent(5),Cardholder)
```
"If you wish to input a name in a format that can be confused for a method call, prefix it with a backslash."

Raise a custom event:
```
POST http://localhost:4590/WebSDK/action?q=RaiseCustomEvent(CustomEventId(5000))
```

Add a bookmark:
```
POST http://localhost:4590/WebSDK/action?q=AddCameraBookmark(a374769385ec49c0a8f653ac10ca0381,2011-08-26T14:10:00,Stolen%20iPod)
```

Open a door:
```
POST http://localhost:4590/WebSDK/action?q=Open(a374769385ec49c0a8f653ac10ca0381)
```

Send email / message to the admin user:
```
POST http://localhost:4590/WebSdk/action?q=SendEmail(00000000000000000000000000000003,Hello)
POST http://localhost:4590/WebSdk/action?q=SendMessage(00000000000000000000000000000003,Hello%20World!)
```

List cardholders, users and user groups:
```
GET http://localhost:4590/WebSdk/report/EntityConfiguration?q=EntityTypes@Cardholder
GET http://localhost:4590/WebSdk/report/EntityConfiguration?q=EntityTypes@User@UserGroup
```

Door activity report:
```
GET http://localhost:4590/WebSdk/report/DoorActivity?q=Doors@a374769385ec49c0a8f653ac10ca0381,TimeRange.SetTimeRange(2016-12-15T21:17:00,2016-12-15T21:18:00)
```

Add a cardholder to a cardholder group:
```
POST http://localhost:4590/WebSDK/entity?q=entity=f646c822c03841f8990f38c6cb04f868,Members@(e9c565bdd1294567b3cc9e2c2bf6b27e)
```

Create a licence-plate credential valid 6 days after first use, assign it, then query it:
```
POST http://localhost:4590/WebSdk/entity?q=entity=NewEntity(Credential),LogicalId=31,Name=MyPlateCredential,Format=LicensePlateCredentialFormat(JXB443),ActivationMode=RelativeDeactivation(6.00:00:00)
POST http://localhost:4590/WebSdk/entity?q=entity=LogicalId(Cardholder, 5),Credentials@LogicalId(Credential, 31)
GET  http://localhost:4590/WebSdk/report/CredentialConfiguration?q=UniqueIds@JXB443
```

Efficient multi-entity read and paging:
```
/entity?q=entity={cardholder},FirstName,LastName,EmailAddress,MobilePhoneNumber
/entity?q=entity={cardholder1},FirstName,LastName,entity={cardholder2},FirstName,LastName
/entity?q=entity={cardholder},FirstName,LastName,entity={credential},Name,ActivationDate,ExpirationDate,State
/report/CardholderConfiguration?q=DownloadAllRelatedData=true
/report/CardholderConfiguration?q=Page=1,PageSize=1000
```
"The only limitation is the query string length." Paging returns **one extra** entity when a further page exists.

Basic entity properties returned by `/entity/basic` [S1]: `Application`, `Behaviors`, `CreatedOn`, `CustomFields`, `Description`, `EntitySubType`, `EntityType`, `EventToActions`, `Guid`, `HiddenFromUI`, `HierarchicalChildren`, `HierarchicalParents`, `IsInMaintenance`, `IsMaintenanceSupported`, `IsOnline`, `LinkedMaps`, `LogicalId`, `MaintenanceEndTime`, `MaintenanceReason`, `Name`, `OwnerRole`, `OwnerRoleType`, `RunningState`, `SupportedCustomEvents`, `SupportedEvents`, `Synchronized`.

**Tooling** — a **Postman collection** of sample requests is published for import; `WebSdkStudio` ships in the SDK samples (`SDK-Samples-Standard`) with a prebuilt binary in `bin/Release`; a browser can issue GETs only; Wireshark for firewall issues.

---

## 8. Web SDK — serialization [S1]

| Aspect | Detail |
|---|---|
| Engine | Newtonsoft from **5.8 GA**; a deprecated XML/JSON serializer in 5.7 and earlier. Old serialization keeps working after upgrade |
| Default | **Legacy XML** if no `Accept` header is set |
| Recommended | `Accept: text/JSON` — "The new MIMEs start with `text` instead of `application`" |
| Why | Shorter payloads, and single-line responses which matter for event monitoring: legacy JSON took "~3-4 minutes per event versus less than a second per event with the new one" |
| Mixing | Allowed per request — "you can switch the Event Monitoring requests to use the new JSON, and still make other requests with any of the other three MIMEs" |
| Setting it in C# | `webRequest.Accept = "text/JSON";` |

Note the docs are internally inconsistent on the exact JSON MIME token, using both `text/JSON` and `text/json`, and elsewhere `application/jsonrequest` for the legacy path. Flagged in `known-gaps.md`.

---

## 9. Genetec Web Player — JavaScript API [S1]

Library source, version-locked to the Media Gateway:
```html
<script src="https://<MediaGatewayAddress>/v2/files/gwp.js"></script>
```
```javascript
const gwp = require('<MediaGatewayAddress>/v2/files/gwp');
```
TypeScript typings — and the full documented API surface — live in `<MediaGatewayAddress>/v2/files/gwp.d.ts`.

Token callback:
```javascript
const getTokenFct = async (cameraId) => {
  const response = await fetch(\`\${mediaGatewayEndpoint}/v2/token/\${cameraId}\`, {
    credentials: 'include',
    headers: { 'Authorization': \`Basic \${btoa(username + ";" + sdkCertificate + ":" + password)}\` }
  });
  if (!response.ok) throw new Error(\`Failed to fetch token: \${response.statusText}\`);
  return await response.text();
};
```

Player lifecycle:
```javascript
const divContainer = document.getElementById('playerContainer');
const webPlayer = gwp.buildPlayer(divContainer);
await webPlayer.start(cameraGuid, mediaGatewayEndpoint, getTokenFct);
webPlayer.playLive();
webPlayer.seek(new Date('2023-12-24T10:00:00Z'));
webPlayer.pause();
webPlayer.resume();
webPlayer.setPlaySpeed(2);
webPlayer.stop();
webPlayer.dispose();
```

| Item | Notes |
|---|---|
| `start(cameraGuid, endpoint, tokenFn)` | Camera GUID in 8-4-4-4-12 form, e.g. `"00000001-0000-babe-0000-080023e940c6"`. Endpoint is the **public address of one specific agent**, e.g. `"https://hostname.com/medi"`. Returns a promise; nothing else can be done with the player until it settles |
| `startWithService(...)` | Shares a single WebSocket across players — "a communication failure of this socket impacts all players" |
| `gwp.version` | GWP library version, independent of the Security Center version. Must match the Media Gateway |
| Diagnostics | `showDebugOverlay()`, `Ctrl+Shift+A`, `gwp.enableLogs()`, `gwp.disableLogs()` |
| Feature set | Live and playback, AAC audio, PTZ, dynamic stream selection, digital zoom, fisheye dewarping, Timeline API (bookmarks and motion events), hardware-accelerated decoding where available, watermarking, snapshots |
| Limits | AAC audio only; smooth reverse playback only for MJPEG; CORS must allow your origin; tokens expire; transcoding needed for some codecs; page and gateway must both be browser-reachable |
| Browsers | "Firefox, Chrome, Edge, Safari, and Internet Explorer 11, the same as Security Center Web Client. NOTE: Some features are not available for IE11." |
| Boundary | "The Genetec Web Player is designed to play streams: Do not to send commands (ex: Adding a bookmark). Use the standard SDK or REST SDK for these use cases. The only exception is PTZ control." |
| Sample | Node.js server in the `sample` folder: `node start.js` → `http://localhost:3000/index.html`; needs Security Center 5.10+ and an SDK certificate in the licence |
| Load balancing | Your responsibility across agents; consider server load, camera-sharing efficiency, and network geography |

---

## 10. Media Gateway — RTSP [S1]

Security Center "provides compressed video (H.264, MPEG-4, MPEG-2, or MJPEG) to any application that requests it through a standard RTSP URL." The Media Gateway role handles the request.

```
rtsp://<username:password>@<IP>:<port>/<camera guid>/<stream> [? <attributes>]
```

| Parameter | Detail |
|---|---|
| `username:password` | Security Center credentials |
| `IP` | IP of the Media Gateway role; must be reachable. "DNS names or Public IP addresses can be used" |
| `port` | Set in Config Tool → Properties tab of the Role. "The default RTSP port used for the Media Gateway role is 654" |
| `camera guid` | GUID of the camera, obtainable from the entity property via the SDK |
| `stream` | **5.3 / 5.4:** `Live`, `Highres`, `Lowres`, `Remote`. **5.5 and later:** `Live`, `Archiving`, `Highres`, `Lowres`, `Remote`. For live, must reflect the stream usage configured in Config Tool for that camera |
| Playback | Set `stream` to `playback` and include the desired playback time **in the body of the RTSP PLAY request** |

Client responsibility: the Media Gateway supplies raw RTP; "it is the Tech Partner who is in charge of decoding and rendering the stream. Because some manufacturers use proprietary codecs, it might not be possible to decode the streams for certain camera manufacturers or models."

The docs also cover typical RTSP exchanges for live and playback, and setting up **Wowza Streaming Engine** for RTSP live streaming. [S1]

---

## 11. Macro SDK [S1]

```csharp
using System;
using Genetec.Sdk.Entities;
using Genetec.Sdk.Scripting;

namespace Genetec.Sdk.Macros.SamplesDebug
{
    public class AddBookmark : UserMacro
    {
        public Guid CameraGuid { get; set; }
        public override void Execute()
        {
            Camera camera = Sdk.GetEntity(CameraGuid) as Camera;
            if (camera != null)
                camera.AddBookmark(DateTime.UtcNow, "Macro Simple Test");
        }
    }
}
```

| Aspect | Detail |
|---|---|
| Base classes | `UserMacro` (default application domain) or `UserMacroWithSetup` (exposes **ApplicationDomain** under *Default execution context*) |
| Execution host | The **Directory server** |
| Identity | "The .NET SDK provided to you is already logged as the admin user" — no logon code |
| Triggering | Manually, on a schedule, or on an event |
| Properties UI | Public properties become configurable in Config Tool |
| Attributes | `SingleInstance` to guarantee one instance at a time |
| Licensing | No certificate, **no SDK connection consumed** |
| Logging | `MacroLogger.TraceDebug/TraceWarning/TraceError/TraceFatal/TraceInformation/TracePerformance`, or `MacroLogger.Trace(LogSeverity, TraceEntry)` |
| Also documented | Creating macros through the SDK, using external libraries in macros, optimizing startup with ApplicationDomains, sending HTTP requests from a macro, debugging macros, MacroStudio |

---

## 12. Workspace and Plugin SDK extension points [S1, S13]

Workspace extension types: custom **task/Page**, **ReportPage**, **ConfigPage**, **TileView**, **TileWidget**, **TileProperties**, **Notification**, **ContextualAction**, **Workspace Service**, **MapObjectProvider**, **MapObjectViewBuilder**, **MapSearcher**, **custom dashboard widgets**, **custom privileges**, **hooks for Security Desk events**, **VideoContent** tile video control, **TilePattern** manipulation.

Services available through `Workspace.Services.Get<T>()` are tabulated in `architecture.md` §7.

Plugin SDK: "allows Tech Partners to create their own role entities… similar to the roles that are available in Security Center such as the Archiver role, the Access Manager role". Server-side component "benefits from having failover and database support"; the client-side component generates custom reports and tasks. [S13]

---

## 13. SDK connection consumption (licensing arithmetic) [S11]

| Surface | Rule |
|---|---|
| Standalone apps (Console, WPF, WinForms, Windows service, ASP.NET) | One connection per successful `LogOn`, released on `LogOff`. "If you are running X instances of an application concurrently or if you have X Engine used at the same time, you need X SDK connections." |
| Web SDK | One per request; held while requests keep arriving within 5 minutes; **an event listener consumes a persistent connection**. Same user re-requesting does not add a connection; a second concurrent user requires a second certificate part |
| Macro SDK | None |
| Workspace SDK | One per **registered component** per signed-in client application, regardless of tile count. Documented example: Config Tool + Security Desk with three registered components = **six** connections. `ContentBuilder` = one. Each open custom task = one certificate |
| Plugin SDK | One per plugin role added; two roles = two connections |

Components that need **no** certificate: Notification, Contextual action, Workspace service, Map object provider, Map object view builder, Map searcher, Report page, Config page, Content menu.

"You need to indicate the licensing structure of your solution in the solution listing when it's complete and ready for deployment. For example, it could be one connection per workstation, two connections per server, or any other combination of connections."

Production part numbers: obtained from `DAP@genetec.com` after completing the solution listing. "The part number is specific to your integration and remains the same for all end users and Security Center versions." Development part numbers (`GSC-SDK-EXTENDED`) cannot be added to a demo licence.

---

## 14. Rate limits and quotas

No HTTP request-rate limit is documented. The documented ceilings are behavioural:

| Limit | Value |
|---|---|
| Web SDK session idle expiry | 5 minutes |
| Security Desk query result cap | 10,000 |
| `AuditTrailQuery` default max results | 100,000 → `ReportError.TooManyResults` |
| Simultaneous Archiver video exports | 2 |
| Directory backward-compatibility window | three major versions |
| Web SDK batch request size | bounded only by query-string length |
| .NET Core report deserialization (pre-5.14.0.0) | broke above 20 results (issue 4502494) |

---

## 15. Third-party integrations named in the docs

| Name | Context |
|---|---|
| **Wowza Streaming Engine** | "Setting up Wowza Streaming Engine for RTSP live streaming" [S1] |
| **Mercury controllers** | "Working with Mercury controllers" under Access Control Unit [S1] |
| **HID Origo mobile credentials** | Cardholders and credentials [S1] |
| **i-PRO** | Unit enrolment; defect 4690532 concerned temporary user creation for the i-PRO product type [S3] |
| **Omnicast** (Genetec legacy) | Federated video via the Compatibility Pack [S1] |
| **Postman** | Official collection for the Web SDK [S1] |
| **Wireshark** | Recommended for firewall diagnosis [S1] |
| **Node.js** | Web Player sample server [S1] |
| **CefSharp / Autofac / AutoMapper / Newtonsoft** | Third-party dependencies of the SDK assemblies [S3] |

---

## 16. Adjacent Genetec REST APIs [S22, S24]

The developer portal also publishes separate REST API doc sets that are **outside this skill's scope** but worth knowing exist when a question turns out not to be about the Security Center SDK: the **Operations Center API** [S22], and versioned REST APIs for Principal (1.0, 2.0), Identity (1.0, 2.0), Location (1.0, 2.0, 3.0), Device 1.0, Case 1.0, Document Store 1.0, Vehicle Monitoring 1.0, Fleet Monitoring 1.0 and CAD Ingestion (1.0, 1.0.1), plus developer guides for Clearance, ClearID, Curb Sense, Transaction Finder, Dispatch System Connector and RMS Connector. [S24]

Sipelia and general product documentation are signposted from the portal but hosted elsewhere. [S21, S23]
