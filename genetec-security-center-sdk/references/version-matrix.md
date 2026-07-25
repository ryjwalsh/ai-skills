# Version Matrix — Genetec Security Center SDK

Coverage: SDK release notes **5.11.0.0 → 5.14.0.0**, plus version-pinned statements from the Developer Guide 5.14.
Sources: S1 (Developer Guide 5.14), S3 (RN 5.14.0.0), S4 (RN 5.13.3.0), S5 (RN 5.13.0.0), S6 (RN 5.12.2.0), S7 (RN 5.12.0.0), S8 (RN 5.11.0.0), S9/S10 (Security Updates 5.13 / 5.12).

---

## 1. Behaviour-change timeline

The single most useful table in this skill for version-sensitive answers. Each row is a point where SDK behaviour genuinely changes.

| Version | Change | Source |
|---|---|---|
| 5.0 | Web SDK ("Web service SDK") introduced | S1 |
| 5.3 and earlier | Video apps must target `x86` | S1 |
| 5.4 GA | **TLS** encryption of Directory communication integrated. Video apps may target `x86`, `x64` or `Any CPU` | S1 |
| 5.4+ | SDK certificate acceptance is **opt-in**; without `Engine.RequestDirectoryCertificateValidation` the communication certificate is auto-white-listed on sign-in | S1 |
| 5.5 | RTSP `stream` parameter gains `Archiving` (previously `Live`, `Highres`, `Lowres`, `Remote`) | S1 |
| 5.6 | `GSC_SDK` and `GSC_SDK_##` environment variables introduced | S1 |
| 5.8 GA | Web SDK serialization moves to **Newtonsoft**; legacy serializer deprecated but still functional | S1 |
| 5.9.1 | `MediaPlayer` gains **hardware acceleration** support | S1 |
| 5.9.1.0+ | Archiver transfer behaviour documented separately from earlier releases | S1 |
| 5.10 | Minimum Security Center version for the **Genetec Web Player** sample | S1 |
| 5.10.4.1 | Media Gateway **CORS restrictions on by default** | S1 |
| 5.11.0.0 | `EventStream` table added to the Access Manager database (**off by default**) | S8 |
| 5.12.2.0 | **.NET 8.0** support added alongside .NET Framework 4.8; `GSC_SDK_CORE` introduced | S6 |
| 5.13.0.0 | Plugin/Workspace registration moves to **XML config files** in `C:\ProgramData\Genetec Security Center\PluginInstallations\Plugins` | S5 |
| 5.13.3.x | Plugin registration directory moves again, to `C:\Program Files (x86)\Common Files\Genetec System\PluginInstallations\Plugins` (admin-only, for security) | S1, S9 |
| 5.14.0.0 | **New required components** — the SDK installer must be run when upgrading | S3 |

---

## 2. Runtime support matrix [S1, S6]

| Security Center SDK version | Supported runtime |
|---|---|
| 5.12.1.0 and before | .NET Framework 4.8 |
| 5.12.2.0 and later | .NET Framework 4.8 **and** .NET Core (.NET 8.0) |

Constraints on the .NET 8 build:
- Not intended for Mac or Linux; WPF references are unsupported there
- `Genetec.Sdk.Media.dll` is **not available**
- `IWebMediaPlayer.GetBufferBoundaries()` and `IWebMediaPlayer.GetPlaybackSequencesList()` return `List<DateTimeRange>` (no `MS.JScript`)
- Before 5.14.0.0, reports with more than 20 results failed to deserialize (issue 4502494)

Build tooling: projects referencing SDK assemblies must target .NET Framework 4.8 or higher, requiring **Visual Studio 2017 or later** per S1 (RN 5.14 states 2012 or higher, plus the .NET Framework 4.8 Developer pack).

---

## 3. Third-party dependency versions — 5.14.0.0 SDK [S3]

| Assembly | Depends on |
|---|---|
| `Genetec.SDK.dll` | Autofac **4.9.2** |
| `Genetec.SDK.dll` | AutoMapper **8.1.0** (.NET Framework 4.8 edition) |
| `Genetec.SDK.dll` | AutoMapper **12.0.1** (.NET 8.0 edition) |
| `Genetec.SDK.dll` | Newtonsoft **13.0.3** |
| `Genetec.SDK.Controls.dll` | CefSharp **126.2.180.0** |

Doc warning: "Make sure that other applications that you use with the Security Center SDK applications all use the same versions of DLLs."

Dependency lists for 5.11–5.13 were not retrieved individually — see `known-gaps.md`.

---

## 4. Per-release feature history

### 5.14.0.0 [S3]
**"There are no new features in Security Center 5.14.0.0 SDK."**

Notable non-feature changes:
- New required components; the SDK installer must be run on upgrade or you get `FileNotFoundException: Unable to run Genetec.FeatureFlag.Settings.exe.`
- Eight resolved issues (full list in `error-codes.md` §9.1), including the .NET Core >20-result deserialization bug (4502494), the SSL-on-by-default Web SDK role creation error (5032013), and non-admin SDK execution when the Plugins folder is absent (4749948)
- One new known issue: `CustomCardFormat` compile-time errors (4900071)

### 5.13.3.0 [S4]
- **Read advanced settings using the SDK** — `AdvancedSettings.GetAdvancedSetting(string name)` and `GetAllAdvancedSettings()`. Requires the `GeneralSettingsAdvancedSettings` privilege. Read-only.
- **Retrieve entity-specific properties using the Web SDK** — name, description, logical ID and entity GUID in a single `EntityConfigurationQuery`. Examples in the public Web SDK collection.

### 5.13.0.0 [S5]
- **Register plugins and workspace components using configuration file** — removes the need for admin access to the Windows Registry. Registry method still supported; existing plugins are migrated at startup; the registry is monitored for changes.
  Migration rules: automated file creation at startup for existing plugins; migration runs for client **and** server apps; runtime change detection is **server-only**; the plugin file is now the **source of truth** and registry edits do not sync to it; uninstalling requires deleting both the registry entry and the plugin file or DLL; deleting a plugin file also removes its registry entry. "This update only changes how plugin paths are retrieved, not how they are loaded into memory."
- **Support for custom card formats** — new `CustomCardFormatService` on the `SystemConfiguration` entity. Create, update, search, export and delete by ID or name. Requires `AccessControlGeneralSettingsTabPrivilege`.
- **Set color property for alarm entities** — new `AlarmColor` property on `Alarm`. Caveat: "If a new color is added to the UI color list, it can cause issues with the `AlarmColor` property in the SDK. This issue causes errors when the color can't be found or parsed correctly."

### 5.12.2.0 [S6]
- **Filter credentials using card format** — new `FormatType` field on `CredentialConfigurationQuery`.
- **Start archive transfer** — new `StartArchiveTransfer` action type, usable from event-to-actions or scheduled tasks.
- **Support for .NET 8 framework** — installer now ships .NET 8 libraries alongside .NET Framework 4.8, "to enhance security".
- **Retrieve secure connection status and secure command port** — new `SecureConnection` and `SecureCommandPort` properties on `VideoUnit`. "This feature enables information retrieval only; it doesn't allow configuration."
- **Display images in Monitoring task** — new `IsImage` property on `EventExtender` (platform + workspace SDK).
- **Add custom field parameters during entity creation** (Web SDK) — `RestSdkReflector.UpdateObject` modified.
- **Generate detailed logger trace for session handling** (Web SDK) — new log entries in `UpdateLastUsageTime()`, `InitializeCleanupTimer()`, `CheckSdkSessionsTimeout()`. "To enable this feature, you must activate the `Genetec.Sdk.Web` logger in Server Admin and set the Debug log-level to true."

### 5.12.0.0 [S7]
- **Expose partition-specific management of privilege exceptions** — read, create, modify and delete privilege exceptions per partition.
  Methods added to the `Partition` class: `GetPartitionExceptions(Guid privilegedEntityGuid)`, `CreateOrUpdatePartitionException(Guid privilegedEntityGuid, SdkPrivilege sdkPrivilege, PrivilegeAccess access)`, `RemovePartitionException(Guid privilegedEntityGuid, SdkPrivilege sdkPrivilege)`, `SetConfigurationPrivilegesPartitionExceptions(Guid privilegedEntityGuid, bool isReadOnly)`.
  A new `Partition` class was also added with the same four methods keyed on `Guid partitionGuid`.

### 5.11.0.0 [S8]
- **Expose `IBackgroundProcessNotificationService` as an SDK service** — notify a Security Desk user of background-operation state through the Workspace SDK. Actions: Add, Clear completed tasks, Complete with success/warning/error, Send notifications, Update progress.
- **Retrieve access control events based on insertion timestamps** — new `AccessControlRawEventReportQuery` class. Backed by a new `EventStream` table in the Access Manager database. "By default, events are not added to the EventStream table when they are added to the Access Manager database. To add them, you must manually enable the EventStream table by adding an advanced setting in Config Tool." Note: "the Access Manager database requires disk space for additional event data when this feature is enabled."

---

## 5. Breaking changes and deprecations

### 5.1 The contract [S1]
Genetec maintains backward compatibility: "your methods, properties, and class signatures remain unchanged across software versions, despite the introduction of new methods, properties, and classes in each release."

Supported and unsupported cases:

| Case | Supported |
|---|---|
| Use publicly exposed types | Yes |
| Call publicly exposed members | Yes |
| Create type instances | Yes |
| Extend class and call protected members | Yes |
| Extend abstract class | Yes |
| Extend a class that contains virtual members | Yes |
| Implement interfaces | Yes, with exceptions |
| Implement interfaces and add default values to arguments | Yes |
| Call private members through reflection | **No** |
| Add extension methods | **No** |

Interface caveat, verbatim: "This case does not apply to all interfaces. Some interfaces, such as `IEngine`, have had breaking changes introduced in them… some interfaces in the SDK are for designing and testing purposes only, and the user should not implement them."

Other stated realities:
- "Breaking changes are hard to avoid completely."
- "Backward compatibility breaks might appear when fixing a security issue."
- "Backward Compatibility cannot be guaranteed for code using reflection."
- Undocumented objects and methods carry no forward or backward compatibility guarantee at all.

### 5.2 Client/server compatibility window [S1]
"The Security Center 5.12 Directory is backward-compatible with clients that are three major versions older. Your Genetec 5.9, 5.10, 5.11 or 5.12 application can still connect to it." Two conditions:
- You must allow older client versions to connect, in **Server Admin**
- You "may experience performance issues, which limit your access to the latest features"

The reverse never works: an SDK newer than the server produces `ConnectionStateCode.InvalidVersion`.

### 5.3 Deprecations
- Legacy Web SDK XML/JSON serializer — superseded by Newtonsoft at 5.8 GA; still functional, "highly recommended" to move to new JSON [S1]
- Registry-based plugin registration — superseded by `.Plugin.xml` at 5.13.0.0; still supported and auto-migrated [S5]
- Obsolete members are surfaced at compile time when you recompile: "If your application uses obsolete features, it is recommended to update the application to use the replacement features… it ensures that the application keeps working when the obsolete features are removed from the SDK" [S1]
- The Web SDK response envelope carries an `ObsoletedMembers` node listing obsoleted members hit by a request, with their messages [S1]

No explicit end-of-life or lifecycle-support dates for any SDK version appear in this doc set — see `known-gaps.md`.

---

## 6. Security fixes by version

| SDK version | Issue | CVE | Severity | Summary |
|---|---|---|---|---|
| 5.13 | 4401536 | Not applicable | Medium | Default plugin paths moved to an admin-only location, preventing privilege escalation by non-admin Windows users [S9] |
| 5.12 | 4037079 | CVE-2026-46578 | **High** | Arbitrary code execution on systems hosting the **Web SDK role** [S10] |

---

## 7. Documentation versions available on the portal [S24]

Useful when a question is pinned to an older release.

| Doc set | Versions retrieved / seen |
|---|---|
| Security Center SDK **Developer Guide** | 5.12, 5.13, **5.14 (primary source for this skill)** |
| Security Center SDK **Reference Guide** | 5.11, 5.12, 5.13, 5.14 |
| Security Center SDK **Release Notes** | 5.11.0.0, 5.11.1.0, 5.11.2.0, 5.11.3.0, 5.12.0.0, 5.12.1.0, 5.12.2.0, 5.13.0.0, 5.13.1.0, 5.13.2.0, 5.13.3.0, 5.14.0.0 |
| **Security Updates for Security Center SDK** | 5.12, 5.13 |
| Document archives | 5.7, 5.8, 5.9, 5.10, 5.11 |

Release notes actually **read in full** for this skill: 5.14.0.0. "What's new" sections read: 5.14.0.0, 5.13.3.0, 5.13.0.0, 5.12.2.0, 5.12.0.0, 5.11.0.0. The remaining service-release notes (5.11.1.0–5.11.3.0, 5.12.1.0, 5.13.1.0, 5.13.2.0) were catalogued but not extracted — see `known-gaps.md`.

---

## 8. Version-pinning rules of thumb

1. Ask which **Security Center** version and which **SDK** version are in play — they can differ.
2. Anything involving plugin or Workspace registration paths: the answer differs across ≤5.12, 5.13.0–5.13.2, and ≥5.13.3.
3. Anything involving .NET: the answer differs before and after 5.12.2.0.
4. Anything involving TLS or certificate acceptance: the answer differs before and after 5.4 GA.
5. Anything involving Web Player CORS: the answer differs before and after 5.10.4.1.
6. Anything involving Web SDK serialization: the answer differs before and after 5.8 GA.
7. When upgrading **to** 5.14: run the SDK installer, or expect `Genetec.FeatureFlag.Settings.exe` to be missing.
8. No `DEPLOYED_VERSION` was supplied when this skill was built, so **nothing here has been checked against a specific deployed release.**
