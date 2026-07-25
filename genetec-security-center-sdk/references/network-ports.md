# Network & Ports — Genetec Security Center SDK

Doc set: Security Center SDK Developer Guide 5.14 (S1), SDK Release Notes 5.14.0.0 (S3), Development Acceleration Program (S11).
All port values below are **defaults as documented**; several are administrator-configurable in Config Tool (noted per row).

---

## 1. Port table

### 1.1 Platform SDK (.NET) to Directory  [S1]

| Port | Protocol | Direction | Source → Destination | Purpose | Required/Optional |
|---|---|---|---|---|---|
| 5500 | TCP | Inbound | SDK app / Security Desk / Config Tool → Directory | Client connection (Directory listens) | Required |
| 5500 | TCP | Outbound | Client application (Security Desk, Config Tool, SDK) → Directory | Directory connection | Required |

Verbatim framing from the doc: the SDK "uses a Genetec-provided certificate and Security Center user credentials to authenticate against the Directory Server. The communication is done over the TCP protocol." [S1]

### 1.2 Video components (e.g. SDK Media Player) [S1]

| Port | Protocol | Direction | Source → Destination | Purpose | Required/Optional |
|---|---|---|---|---|---|
| 6000–6200 | UDP | Inbound | Archiver / Media Router → Client applications (Security Desk, Config Tool, SDK) | Unicast media streams | Required for unicast video |
| 47806, 47807 | UDP | Inbound | Multicast source → Client applications | Live video and audio **multicast** streams | Required for multicast video |
| 554, 560 | TCP | Outbound | Client applications → video source | Live and playback video and audio requests | Required for video |

### 1.3 Web SDK role [S1]

| Port | Protocol | Direction | Source → Destination | Purpose | Required/Optional |
|---|---|---|---|---|---|
| 4590 | TCP (HTTP) | Inbound | REST client → server hosting the Web-based SDK role | Web SDK API (non-SSL). Appears in every documented sample URL, e.g. `http://localhost:4590/WebSdk/` | Required (configurable) |
| 4591 | TCP (HTTPS) | Inbound | REST client → Web-based SDK role | Web SDK API over SSL | Required if SSL used (configurable) |

Doc wording: "verify that a rule exists allowing the Web SDK application to communicate using the ports 4590/4591. If inside the WebSDK role in Config Tool, a different set of ports have been chosen, adjust accordingly." [S1]
The Web-based SDK role entity itself "contains the Port and base URI configuration." [S1]

### 1.4 Media Gateway (RTSP + Web Player) [S1]

| Port | Protocol | Direction | Source → Destination | Purpose | Required/Optional |
|---|---|---|---|---|---|
| 654 | RTSP/TCP | Inbound | RTSP client → Media Gateway role | Default RTSP port for the Media Gateway role. "The port number can be set in the Config Tool application in the Properties tab of the Role." | Required for RTSP (configurable) |
| 80 | TCP (HTTP) | Inbound | Browser → Media Gateway agent | Genetec Web Player prerequisite: "Open ports 80 and 443 for public access." | Required for Web Player |
| 443 | TCP (HTTPS) | Inbound | Browser → Media Gateway agent | Same as above; also serves `/v2/files/gwp.js` and `/v2/token/{cameraId}` | Required for Web Player |
| — | WebSocket | Outbound | Browser → Media Gateway agent | "WebSocket protocol is used for this connection." Carried over the HTTP/HTTPS listener above | Required for Web Player |

### 1.5 Diagnostic / debug consoles [S1]

| Port | Protocol | Direction | Source → Destination | Purpose | Required/Optional |
|---|---|---|---|---|---|
| 4523 | TCP | Inbound (loopback) | — | `DiagnosticServer.InitializeServer(diagnosticServerPort: 4523, ...)` for an external SDK app | Optional (diagnostics) |
| 6023 | TCP (HTTP) | Inbound (loopback) | Browser → your SDK app | `webServerPort: 6023` → console at `localhost:6023/console` | Optional (diagnostics) |
| 6020 | TCP (HTTP) | Inbound (loopback) | Browser → Security Desk | Console at `localhost:6020/Genetec/Overview` | Optional (diagnostics) |
| 6021 | TCP (HTTP) | Inbound (loopback) | Browser → Config Tool | Console at `localhost:6021/Genetec/Overview` | Optional (diagnostics) |
| 6001 | TCP (HTTP) | Inbound (loopback) | Browser → Media Gateway agent | Console at `http://localhost:6001/genetec/DebugConsole` | Optional (diagnostics) |
| 3000 | TCP (HTTP) | Inbound (loopback) | Browser → GWP Node.js sample | Web Player sample server: `node start.js` → `http://localhost:3000/index.html` | Optional (sample only) |

Plugin console path documented without a port: `localhost/Genetec/Overview`. [S1]
Server Admin debug console path: `/localhost/genetec/DebugConsole?serverId=` [S1]

> Not documented: any port list for the Directory database (SQL Server), the Server Admin web port itself, Archiver ports, or the Genetec Server service port. Those live in the Security Center Administrator / Hardening guides, which are outside this doc set — see `known-gaps.md`.

---

## 2. Firewall requirements [S1]

1. **Web SDK** — ensure a rule exists allowing the Web SDK application to communicate on 4590/4591 (adjust if the role was reconfigured). If the ports are blocked you get `System.Net.Sockets.SocketException: No connection could be made because the target machine actively refused it`, or a generic "Connection refused"; the doc's checklist for that symptom is: role inactive, wrong address/port, firewall/network restriction, DNS resolution failure.
2. **Media SDK / video reception** — "The Security Center client installer (Security Desk/Config Tool) creates firewall exceptions automatically for these applications." A **standalone SDK application is not covered by those exceptions**: "You might have to add your application to the exception list."
   Diagnostic signature of a firewall block: run the MediaPlayer SDK sample — "When the player remains in starting state, no bitrate is shown, and the stream is not received, the most likely issue is the firewall." If a bitrate *is* shown, the stream arrives and the problem is missing decoder/renderer files instead.
3. **Media Gateway / Web Player** — ports 80 and 443 must be reachable *by the browser*, and both the hosting web page and the Media Gateway must be independently reachable: "The web page and Media Gateway must both be accessible by the browser."
4. **Wireshark** is the documented tool for firewall-class problems ("This tool can be used to help solving firewall issues and is more advanced").
5. **Multi-NIC hosts** — not a firewall issue but frequently mistaken for one: if the machine has more than one NIC, use the `MediaPlayer`/`VideoSourceFilter` `Initialize` overload accepting `PhysicalAddress networkAdapterBinding`, or the overload accepting `Guid clientSubnet` to pin the client network.

---

## 3. Proxy support

**Not documented.** No proxy configuration, `WebProxy`, PAC, or upstream-proxy guidance appears anywhere in the SDK doc set for Platform SDK, Web SDK, Media SDK, or the Web Player. Logged in `known-gaps.md`.

---

## 4. Certificate & TLS requirements

There are **two unrelated things called "certificate"** in this product. Confusing them is the single most common source of connection failures. [S1]

| | SDK certificate (licensing) | Communication certificate (TLS) |
|---|---|---|
| What it is | XML file containing an `<ApplicationID>`; identifies *your integration* | X.509 server certificate presented by the Directory / Web SDK role / Media Gateway |
| Where it lives | `Certificates\` subfolder beside your `.exe`/DLL, named `<exe>.cert` or `<FullClassName>.cert` | Windows certificate store; configured in Server Admin / Config Tool |
| Purpose | Matched against a **part number** in the Security Center license | Encrypts the channel |
| Failure mode | `SdkError.MissingClientCertificate` / `InvalidClientCertificate` / `MissingCertificate` / `CertificateCountExceeded` / `InvalidApplicationId`; HTTP 403 on Web SDK | `ConnectionStateCode.DirectoryCertificateNotTrusted`; `Could not establish trust relationship for the SSL/TLS secure channel` |

### 4.1 Directory TLS (Platform SDK) [S1]
- "Communication with the Security Center Directory is encrypted with Transport Layer Security (TLS) … integrated in Security Center starting with version 5.4 GA."
- Client applications have an install-time setting for whether the user must inspect/accept the communication certificate. **The SDK installer has no such setting and does not read the client's setting.**
- **Default SDK behaviour: "if nothing particular is done in the SDK application, the communication certificate is automatically white-listed upon sign in."**
- To opt in to inspection, register `Engine.RequestDirectoryCertificateValidation` **before** logging on. Accepting white-lists it; refusing fails the connection.
- The white-list is shared between client applications and SDK applications for the same Windows user + Directory pair, in both directions.
- White-list cache location (for dev/test reset): `localappdata\Genetec Security Center 5.#\CertificateCache`
- Hardening note: pre-5.4 SDK applications could auto-accept communication certificates, so "it is important to control what earlier (5.3 or earlier) SDK applications execute on client computers."

### 4.2 Web SDK TLS [S1]
Requirements to run the Web-based SDK role encrypted:
1. The computer running the service must have a valid SSL certificate installed.
2. **Use SSL** must be checked on the Web SDK configuration page in Config Tool; the **Certificate** textbox must contain the certificate name.
3. The certificate must be bound to the port. `Bind certificate to port = Off` → Windows performs the binding. `= On` → the Web SDK performs it, and the certificate must be registered as a **local computer personal certificate**.

Config path: **Config Tool → System → Roles → select the WebSDK role → Properties → Use SSL connection = On → Save**. Click **View** to inspect certificate details.
- The Web SDK role "uses the same SSL Certificate as configured for the Genetec™ Server in the Genetec Server Admin", and auto-detects changes to it.
- **Supported protocol versions: TLS 1.0, 1.1, 1.2, and 1.3.**
- Client trust requirement: the root CA that signed the server certificate must be in the client's Windows **Trusted Root Certification Authorities**. `Install Certificate` / `mmc.exe` are the documented remedies.
- Once SSL is on, URLs must use `https://`. Using `https://` against a non-SSL role yields `The handshake failed due to an unexpected packet format`.
- Known defect: creating a new Web-based SDK role with **Use SSL Connection** on (the default) caused a connection error — issue **5032013**, resolved in 5.14.0.0. [S3]

### 4.3 Media Gateway / Web Player CORS [S1]
Since **Security Center 5.10.4.1** the Media Gateway has CORS restrictions on by default; any origin may call and authenticate. To restrict, edit `ConfigurationFiles\MediaGateway.gconfig` in the installation folder **on each Media Gateway agent**:

```xml
<MediaGateway EnforceStrictCrossOrigin="true">
  <AllowedOrigin Origin="https://example1.com" />
  <AllowedOrigin Origin="https://example2.com" />
  <AllowedOrigin Origin="https://web.example3.com" />
</MediaGateway>
```
`<MediaGateway EnforceStrictCrossOrigin="true">` with no children restricts to Web Client agents only. A custom list is **required for custom web pages**.

### 4.4 Web Player token endpoint [S1]
```
POST /v2/token/{cameraId}
Authorization: Basic <Base64(username;sdkCertificate:password)>
```
Tokens carry all Security Center user privileges and session validity, and are enforced by the Media Gateway. They expire and must be renewed or the connection is dropped. Doc guidance: "Do Not Hardcode Credentials: Use server-side logic to fetch tokens securely."

---

## 5. Rate limits and throughput ceilings that behave like network limits

| Limit | Value | Source |
|---|---|---|
| Web SDK session idle timeout | Session stays alive "as long as it receives a request every five minutes or less"; keep alive by pinging `https://{server}:{port}/{baseUrl}/` | S1 |
| Web SDK connection consumption | One SDK connection per request; freed after 5 minutes idle; an event listener consumes a **persistent** connection | S11 |
| Simultaneous video exports | "Only two simultaneous video exports are permitted by the Archiver in Security Desk; you should throttle to the same number." | S1 |
| Security Desk query ceiling | 10,000 results max | S1 |
| `AuditTrailQuery` default `MaxResultCount` | 100,000 results, then `ReportError.TooManyResults` | S1 |
| Web SDK paging | `Page` / `PageSize`; response returns *one extra* entity when another page exists | S1 |
| Directory backward compatibility window | "backward-compatible with clients that are three major versions older" (5.12 Directory example: 5.9–5.12 clients); older clients must be explicitly allowed in Server Admin | S1 |

No HTTP-level request-per-second rate limit is documented for the Web SDK. Logged in `known-gaps.md`.
