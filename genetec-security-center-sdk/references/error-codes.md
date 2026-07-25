# Error Codes & Messages — Genetec Security Center SDK

Sources: S1 (Developer Guide 5.14), S3 (RN 5.14.0.0), S9 (Security Updates SDK 5.13), S10 (Security Updates SDK 5.12).
Code names, error strings and issue numbers below are reproduced **verbatim**; the surrounding explanation is paraphrased.

## Contents
1. How to obtain the codes
2. `ConnectionStateCode` catalogue
3. `SdkError` values under `CertificateRegistrationError`
4. `ReportError`
5. `StreamingConnectionStatus` (Web Player)
6. HTTP status codes (Web SDK)
7. .NET exception strings you will actually see
8. Web SDK response envelope and `SdkErrorCode`
9. Release-note issue IDs
10. Security advisories / CVEs

---

## 1. How to obtain the codes [S1]

"FailureCodes are codes implemented in the Security Center SDK to allow developers to track and sort data, and gain insight on failure trends."

Subscribe to `Engine.LoginManager.LogonFailed` and read `LogonFailedEventArgs`:

| Property | Contents |
|---|---|
| `FailureCode` | The error causing the log-on failure (a `ConnectionStateCode`) |
| `FormattedErrorMessage` | "Gets the code and the exception message as a formatted string. The format is as follows: `SDK Engine failed to log on on server '{The server name}'. Failure code : {The error code} Exception message : {The message}` The message is only shown when there is a message for the error code." |
| `SdkException` | "Gets the exception that may have caused the logon failure." **Can be null.** |
| `ServerName` | Name of the AccessDatastore on which a connection was attempted |

Related event args: `LoggedOnEventArgs` (`ServerName`, `UserName`), `LoggedOffEventArgs` (`AutoReconnect`), `LogonStatusChangedEventArgs` (`ServerName`, `Status`).

Doc caution: "Make sure the `LogonFailed` event is properly coded" before trying to interpret anything.

---

## 2. `ConnectionStateCode` catalogue [S1]

| Code | Meaning | Fix / where to look |
|---|---|---|
| `AuthenticationAgentImportFailure` | "The Active Directory could not import the user who logged in." | Make sure the Active Directory role is able to import the user |
| `AuthenticationAgentResponseTimeout` | "The Active Directory failed to respond in a timely manner." | Investigate AD availability / latency |
| `CantSuperviseSelf` | Supervisor username and user username are the same. "This situation also arrives when a username belongs to a user group and this user group's credentials are entered as the supervisor username." | Use a different supervisor account |
| `CertificateRegistrationError` | "This one is by far the most commonly found problem and it can have several values for SdkException." | See §3 |
| `Connecting` | "Logon failed while connecting." | Transient/network |
| `ConnectionEstablished` | "Logon failed after connection was established." | — |
| `ConnectionLost` | "The application was connected but got disconnected." | "Try to connect again" |
| `DirectoryCertificateNotTrusted` | The Directory has a TLS channel enabled and the app registered `Engine.RequestDirectoryCertificateValidation` without accepting the certificate | "In the same Windows user session, connect a Client Application (Security Desk or Config Tool) to the Directory, inspect, and accept the valid certificate. The SDK application connects with the white-listed certificate." |
| `DirectoryRedirect` | "The application is being redirected to a different directory." | — |
| `DisallowedBySchedule` | User may only sign in during a specific schedule | Config Tool → **Security → Properties → User logon Schedule** |
| `ExceededNumberOfWorkstations` | User exceeded its maximum simultaneous workstations | Config Tool → **Security → Properties → Limit concurrent logons** |
| `Failed` | "The specified user name is an empty string, or this error is a symptom of a problem with the server." | Check the Directory is on in Server Admin; check whether the Directory database needs an upgrade; "restarting the Genetec Server service usually resolves this issue" |
| `InsufficientPrivileges` | User cannot connect through an SDK application | Config Tool → **Security → Privileges → Log on using the SDK** |
| `InsufficientSecurityLevel` | User security level too low. "The user level goes from 1 to 254 where 1 is the highest level and 254 is the lowest. By default, the security level for any user is 254 and the security level in Security Center is also 254, so under normal circumstances, this error should not occur. This failure code is linked to threat levels." | Config Tool → **Security → Security**; raise the level to a higher number |
| `InvalidCredential` | "The username or password is invalid." | Verify user exists and password is right |
| `InvalidSupervisor` | Supervisor sign-in required but the supervisor username is not valid | Provide a valid supervisor, or use a different sign-in method |
| `InvalidVersion` | "The running application is using a newer version of the Security Center SDK than the server that it is trying to connect to." Example given: an app built on 5.2 SDK connecting to Security Center 5.0/5.1. "The reverse is not true however, an SDK application compiled with 5.1 SDK (for example) can connect to Security Center 5.2." | Rebuild against the server's SDK version, or upgrade the server |
| `LicenseError` | Problem with the licence | Verify in Security Desk → About, or Server Admin licence section. "If the license is invalid, open a regular Support Ticket to fix the license." |
| `MissingRequestUserChangePassordEvent` | Password change required/expired but no delegate is set. (Spelling is the SDK's, not a typo here.) | Subscribe to and handle `Engine.RequestUserChangePassword`, or reset the password in Config Tool |
| `NewBackupConnection` | "Not implemented. It is there for future usage." | — |
| `NoAuthenticationAgent` | Domain name differs from the one configured in the Active Directory role, or the role is misconfigured | Verify the domain name and permissions |
| `PasswordExpired` | Password has expired | Change it, or Config Tool → **Security → Properties → Password Expiration** |
| `SpecifyDomain` | "There are multiple Active Directories but the username did not specify the domain." | Qualify the username with a domain |
| `SupervisorPasswordIsEmpty` | Supervisor password is empty | Supply one |
| `Timeout` | "A Timeout has been specified and has been reached." | Raise the timeout / check connectivity |
| `UnableToRetrievePrivileges` | `Privileges.xml` not found in the SDK installation folder, the Security Center installation folder, or the application's folder — possibly because the registry location could not be read | "Ensure that the SDK or Security Center is installed. Otherwise, manually copying the file to the application folder of the integration resolves the issue." |
| `UserAccountDisabledOrLocked` | The AD user is disabled or locked | Enable/unlock in Active Directory |
| `UserAndSupervisorOnDifferentDomains` | "Both the user and its supervisor should be in the same Active Directory domain." | Align domains |

---

## 3. `SdkError` values seen with `CertificateRegistrationError` [S1]

| `SdkError` | Documented message | What it actually means → fix |
|---|---|---|
| `MissingClientCertificate` | "The client certificate could not be located on disk." | File absent. Must be `<exe>.cert` in a folder called `Certificates` where the application executable lives |
| `InvalidClientCertificate` | "The client certificate located on disk is invalid." | File found but invalid — "make sure the `ApplicationId` tag in the certificate file is not empty" |
| `MissingCertificate` | "The specified client certificate not part of your Security Center license." | You have a certificate, but the licence lacks the corresponding **part number** |
| `CertificateCountExceeded` | "The specified client certificate registration exceeded the limit allowed by your Security Center license." | All connections in use. "if the application is named TEST ABC, and in Config Tool > About > Certificates, TEST ABC shows 10/10, then there are no more open connections" |
| `InvalidApplicationId` | "The client certificate's application ID is invalid or corrupted." | "The application ID string is invalid, meaning it looks similar to a correct one but differs by one or more characters" |

---

## 4. `ReportError` [S1]

| Value | When | Handling |
|---|---|---|
| `TooManyResults` | Result set exceeds `MaximumResultCount`, or the `AuditTrailQuery` default of **100,000** | Batch by time window, advancing on `AuditTrailQuery.ModificationTimestampColumnName`; loop until `queryAudit.Error != ReportError.TooManyResults`. Full pattern in `troubleshooting.md` §11 |

Useful column-name constants documented alongside: `AuditTrailQuery.ModificationTimestampColumnName`, `AuditTrailQuery.EntityTypeColumnName`, `AuditTrailQuery.EntityGuidColumnName`.

---

## 5. `StreamingConnectionStatus` — Genetec Web Player [S1]

Raised through `onStreamStatusChanged`.

| Value | Class | Meaning / action |
|---|---|---|
| `ConnectingToMediaGateway` | Recoverable | Raised "once the connection timed out"; the player reconnects and resumes by itself |
| `NotEnoughBandwidth` | **Non-recoverable** | Must call `stop()` then `start()` again |
| `MediaRouterStreamNotFound` | **Non-recoverable** | Must restart the player |
| `StreamUnreachable` | **Non-recoverable** | Must restart the player |
| `UnauthorizedToken` | **Non-recoverable** | Must restart the player; renew the token |

Doc note: "There are various other values to report other streaming problem (see `StreamingConnectionStatus` enum documentation)." The complete enum is in `gwp.d.ts`, which "contains the whole API with comments documenting each member and enum" and is served from `<mediaGatewayAddress>/v2/files/gwp.d.ts`. The remaining values are **Not documented** in the guide itself — see `known-gaps.md`.

---

## 6. HTTP status codes — Web SDK [S1]

| Code | Documented meaning | Documented causes | Fix |
|---|---|---|---|
| **401** | "Unauthorized" — "issued when the server requires user authentication to access the requested resource… you are not authenticated" | Missing authorization header | Supply HTTP Basic credentials in the `<user>;<ApplicationId>` form |
| **403** | "Forbidden" — "the server understands the request but refuses to fulfill it… you are not allowed to access the requested webpage or resource" | Missing authorization header; incorrect username; incorrect password; invalid application ID; production certificate on a development server or vice-versa; user not granted "Log on using the SDK" | Fix credentials/certificate/privilege. Restart the role (deactivate then activate) after privilege changes. Also raised when the part number is not visible in the licence options |
| **404** | "Not Found" | Wrong syntax; base URL not matching the role's Base URI; unrecognised command; known bug; lack of user privileges | Compare Base URI in Config Tool; validate the command against the Postman collection |

Dev-licence check documented under the 403 discussion: "To verify a development Security Center license, check the system ID. If it starts with \"DEM,\" it is a development license. You can find the system ID on the About page in Security Desk and Config Tool, or the System Management page on GTAP."

Other documented non-HTTP-code symptoms in the same family: "Alarm or Event not received -> Are you subscribed to receive this event?" and "Receiving non-standard serialization response -> Use the latest json or xml format (Header/Accept)".

---

## 7. .NET exception strings you will actually see [S1]

Reproduced verbatim because these are the strings people paste into a search box.

| Exception string | Cause | Fix |
|---|---|---|
| `System.Net.WebException: Unable to connect to the remote server ---> System.Net.Sockets.SocketException: No connection could be made because the target machine actively refused it` | WebSdk role not added, or deactivated | Add/activate the role in Config Tool → System → Roles |
| `System.Net.WebException: The remote server returned an error: (403) Forbidden.` | Wrong credentials, or certificate not concatenated to the username | See §6 |
| `System.Net.WebException: The underlying connection was closed: An unexpected error occurred on a send. ---> System.IO.IOException: The handshake failed due to an unexpected packet format.` | URL uses HTTPS but the role is not configured for SSL | Use HTTP, or enable SSL on the role |
| `System.Net.WebException: The remote server returned an error: (404) Not Found.` | Malformed URL, wrong Base URI, or unrecognised command | See §6 |
| `System.Net.WebException: The underlying connection was closed: Could not establish trust relationship for the SSL/TLS secure channel. ---> System.Security.Authentication.AuthenticationException: The remote certificate is invalid according to the validation procedure.` | Client does not trust the role's certificate, or hostname ≠ certificate `CN` | Match the hostname to the `CN`; add the root CA to Trusted Root Certification Authorities |
| `Mixed mode assembly is built against version 'v2.0.50727' of the runtime and cannot be loaded in the 4.0 runtime without more configuration information` | Legacy runtime activation policy not enabled | `useLegacyV2RuntimeActivationPolicy="true"` |
| `FileNotFoundException: Unable to run Genetec.FeatureFlag.Settings.exe.` | SDK upgraded to 5.14.0.0+ without running the SDK installer | Reinstall Platform SDK and Media SDK from the 5.14.x.y package [S3] |

Typical stack frames accompanying the Web SDK exceptions, as printed in the docs: `at System.Net.HttpWebRequest.EndGetResponse(IAsyncResult asyncResult)` and `at WebSDKStudio.Form1.OnGetResponse(IAsyncResult ar)`.

---

## 8. Web SDK response envelope and `SdkErrorCode` [S1]

Success envelope:
```
Rsp
  Status              -> Ok or Fail
  Result              -> the resulting object
  ObsoletedMembers    -> hidden when empty
```

Error envelope:
```
Rsp
  Status
  Result
  SdkErrorCode        -> the name of the SdkErrorCode
  Message             -> the actual error message
```

`ObsoletedMembers` structure:
```
Rsp
  ObsoletedMembers
    Member            -> the obsoleted member, with namespace
    Message           -> the obsolete message
```

Documented common-operation errors are returned as readable messages rather than numeric codes, e.g. **"Entity does not exist"** and **"Wrong address"**. The full enumeration of `SdkErrorCode` names returned by the Web SDK is **Not documented** in the guide — see `known-gaps.md`.

Concrete shapes for comparison:
```
JSON       {"Rsp":{"Status":"Ok","Result":{"Value":true}}}
Old JSON   {"rsp": {\r\n"status":"ok",\r\n"result": {\r\n"Value":"True"\r\n}}\r\n}\r\n
XML        <WebSdk><Rsp><Status>Ok</Status><Result><Value>true</Value></Result></Rsp></WebSdk>
Old XML    <rsp status="ok">\r\n<result>\r\n<Value>True</Value>\r\n</rsp>\r\n
```

---

## 9. Release-note issue IDs

### 9.1 Resolved in Security Center 5.14.0.0 SDK [S3]

| Issue | Description |
|---|---|
| 4938215 | "When adding a plugin within a partition, executing a hot action as a non-administrator fails." |
| 4720955 | "When reusing an archived visitor through the `CreateVisitor` method, the visitor's image is not preserved." |
| 4749948 | "A non-admin Windows user cannot run SDK applications on machines where the Plugins folder does not exist at: `C:\Program Files (x86)\Common Files\Genetec System\PluginInstallations\`." |
| 4899660 | "`CustomQueries` does not allow `IEnumerable` in dataset columns, preventing SDK custom queries from returning lists in custom query results." |
| 5032013 | "In Config Tool, creating a new Web-based SDK role with the `Use SSL Connection` setting turned on (default) results in a connection error." |
| 4772959 | "SDK doesn't indicate which alarm instances were acknowledged, affecting plugins that listen for acknowledgements." |
| 4690532 | "In the Security Center SDK, temporary user creation fails when enrolling units with the i-PRO product type." |
| 4502494 | "SDKs using .NET Core can't deserialize reports that contain more than 20 results." |

### 9.2 Known issues in 5.14.0.0 SDK [S3]

| Issue | First reported | Description and workaround |
|---|---|---|
| 4900071 | 5.14.0.0 | `CustomCardFormat` "exposes properties (`Type`, `Data`, `FormatFields`, and `ParityChecks`) whose types are not part of the SDK, resulting in compile-time errors if no additional assemblies are referenced." **Workaround:** "Add references to `Genetec.Data.dll`, `Genetec.Sentinel.Credentials.dll`, and the assemblies that define `FormatFieldDefinition` and `ParityCheck`" |

### 9.3 Limitations still open as of 5.14.0.0 SDK [S3]

| Issue | First reported | Description | Workaround |
|---|---|---|---|
| 4291307 | 5.13.2.0 | "Calling `EnablePTZ(true)` on a camera through the Web SDK returns an error." | — |
| 3819660 | 5.12.2.0 | Cardholder deleted while the Access Manager is offline: "the area incorrectly continues to report that the cardholder is present." | "Retry the action after the Access Manager is back online." |
| 2911778 | 5.10.3.0 | After removing a cardholder from a cardholder group via SDK/Web SDK, the Cardholder entity still shows the group while Config Tool does not. | "Ensure that the cardholder and cardholder group properties are both removed at the same time from the SDK or Web SDK." |
| 2483630 | 5.9.3.0 | "Running synchronous queries from the `CanExecute` method of Contextual Action components deadlocks Security Desk and Config Tool." | "Use asynchronous queries (`BeginQuery`) instead." |
| 1766032 | 5.7 SR3 | "Can't use asynchronous operations within an SDK transaction. When used, the operations aren't completed inside the transaction as expected." | "Use synchronous methods for these operations, when available." |
| 1537301 | 5.7 SR2 | "For a privilege check to be performed when a Custom entity is declared with a Custom privilege in its descriptor, the client module describing the custom privilege must be installed on the main server." | — |
| 1051547 | 5.7 GA | "When calling `StopRecording(Guid, TimeSpan)` on BOCamera, the `recordingLengthBeforeStop` is ignored and the recording is stopped instantly." | — |
| 999439 | 5.6 SR4 | "If you try to add a camera shortly after removing it, an `Already added` event is triggered, and the camera can't be added." | — |
| 240792 | 5.3 LA | "`SetVisualTrackingConfiguration` isn't supported for federated cameras. Configuration of those cameras can be read, but not set." | — |

### 9.4 New features per release
Feature-level changes are in `version-matrix.md`. Note that **"There are no new features in Security Center 5.14.0.0 SDK."** [S3]

---

## 10. Security advisories / CVEs

| SDK version | Issue | CVE ID | Severity | Description |
|---|---|---|---|---|
| 5.13 | 4401536 | Not applicable | **Medium** | "In Security Center, default plugin paths have been moved to an admin-only location. This prevents users without Windows administrative privileges from modifying them and thereby prevents privilege escalation." [S9] |
| 5.12 | 4037079 | **CVE-2026-46578** | **High** | "A high-severity vulnerability that could lead to arbitrary code execution on systems hosting the Web SDK role has been fixed in the Genetec Security Center product line." [S10] |

Highest severity of resolved issues: **Medium** for 5.13 [S9], **High** for 5.12 [S10].

Operational consequence worth flagging to anyone running the Web SDK role: 4037079 is a remote-code-execution class issue on the Web SDK host, so the Web-based SDK role should be patched to a build that contains the fix. The 5.13 change (4401536) is the security rationale behind the plugin-path move to `C:\Program Files (x86)\Common Files\Genetec System\PluginInstallations\Plugins\` at 5.13.3.x — an admin-only location.

Genetec publishes these under "Security Updates for Security Center SDK"; the docs point there "to view the resolved security-related issues in all versions of Security Center SDK." Only the 5.12 and 5.13 pages were retrieved for this skill — see `known-gaps.md`.
