# API and integration

Phase 2 section J. **This is the thinnest area of the retrieved corpus.** The Administrator Guide, Installation Guide, System Requirements Guide, Hardening Guide, release notes and port guides describe *where* the SDK surfaces live and how to configure and firewall them, but they are not the SDK reference. Method-level documentation lives in the Genetec Developer portal and the SDK package, which were not retrieved. Everything missing is recorded in `../known-gaps.md`.

## 1. Integration surfaces at a glance

| Surface | What it is | Transport and default port | Src |
|---|---|---|---|
| **Security Center SDK** (.NET) | The native SDK. Installed from the full package or a separate SDK package; default install folder `[ProgramFilesFolder]Genetec Security Center <version> SDK`. | Connects to the Directory on **TCP 5500** (TLS 1.2) via `GenetecServer.exe`; requests image maps from Map Manager on **TCP 8012** (HTTPS). | S7, S3 |
| **Web-based SDK** (role) | Exposes Security Center SDK methods and objects as **web services** for cross-platform development, so developers on non-Windows platforms (for example Linux) can write custom programs that interact with Security Center. Exists mainly for customers needing custom development; Genetec Professional Services can build it. | Address is derived from **Port** + **Base URI**: with Port 4590 and Base URI `WebSdk` the service address is `http://<computer>:4590/WebSdk/`. Separate **Streaming port** carries events. `https` when SSL is on. | S1 |
| **Media Gateway** (role) | Supports **RTSP**, which external applications use to request raw video streams from Security Center. Also serves transcoded video to Genetec Mobile and Genetec Web App. | RTSP clients on **TCP 654**; Mobile and Web App on **TCP 80 / 443**; agents to role on **TCP 5500**. | S1, S3, S5 |
| **Mission Control Web API / UI SDK** | REST-style API for Mission Control incidents plus a UI SDK. | **TCP 9550** inbound on the Web API SDK. If 9550 is blocked, the Directory forwards requests to the expansion server hosting the Incident Manager role on **port 443**. `GENETEC_PORT=9550` and `ENABLE_WEBAPI_DOCUMENTATION=1` are the silent-install options. | S15 |
| **Server Admin REST** | REST interface on every server. | **TCP 80** (HTTP) and **TCP 443** (HTTPS), served by `GenetecInterface.exe` through `http.sys`. | S3 |
| **Record Caching Service** (role) | Imports data from external sources into Security Center. Requires the **Record caching** license option; **Number of record types for caching** caps the custom record types. | REST on **TCP 80** and **TCP 443** via `GenetecIngestion.exe`. | S1, S3 |
| **Record Fusion Service** (role) | Unifies records across sources for the **Unified report** task. | Configuration tabs documented; no dedicated port row in the port guide. | S1 |
| **Plugin SDK** | Creates plugin roles. Licensed by the **Plugin SDK** option. | Plugin roles run in `GenetecPlugin.exe` / `GenetecPlugin32.exe`. | S1, S3 |
| **Media SDK** | Creates Media SDK roles. Licensed by the **Media SDK** option. | Not documented further. | S1 |
| **Security Center Federation** | Federates other Security Center systems, including into SaaS. | **TCP 5500** (TLS 1.2) plus **TCP 554, 560, 9603** for streams. Into SaaS: outbound **TCP 5500** to `*.gsc-cloud.com` (reverse tunnel). | S3, S17 |
| **Genetec PowerShell module** | Referenced in 5.14.0.0 as an alternative to Server Admin for running the `ShowFederatedStreams` debug command. | Not documented further. | S9 |

## 2. Web-based SDK role configuration [S1]

Configured in Config Tool: **System task > Roles view > Web-based SDK**.

**Properties tab**

| Setting | Meaning |
|---|---|
| **Port** + **Base URI** | Together determine the web service address. Example: Port `4590` and Base URI `WebSdk` give `http://<computer>:4590/WebSdk/`, where `<computer>` is the DNS name or public IP of the server hosting the role. |
| **Streaming port** | Port used to stream **events**. You can configure which events to listen to. |
| **Use SSL connection** | Default **off**. Turn on for SSL encryption; the service address then uses `https` instead of `http`. |
| **Certificate** | Name of the certificate, in the form `CN=NameOfTheCertificate`. The certificate must be registered in Windows. |
| **Bind certificate to port** | Default **off**. Binds the certificate to the port - the same operation you would normally perform in Windows. |

**Resources tab** - servers assigned to the role. **The Web-based SDK role does not require a database.**

Licensing: the **Web SDK** license option allows you to create Web-based SDK roles. [S1]

Availability: the Web-based SDK role **is** backward-compatible with 5.11, 5.12 and 5.13. [S7]

## 3. Authentication

| Mechanism | Documented facts |
|---|---|
| Security Center user credentials | Client and SDK applications authenticate to the Directory, which performs "client application connection authentication". Command-line logon accepts `-u` / `-w`, an encrypted password file (`-we`), or Windows authentication (`-iwa`, which requires Active Directory integration and an imported profile). [S1] [S24] |
| Directory certificate validation | `SECURE_COMMUNICATION=1` at install time enforces Directory authentication (default is not enforced). Clients can be forced to always validate the Directory certificate. [S7] [S12] |
| Third-party identity providers | OpenID Connect, SAML 2.0, WS-Federation and WS-Trust through **Authentication Service** roles on **TCP 443** (`GenetecAuth.exe`), each capped by its own license option. **SAML 2.0 is incompatible with ECDSA Directory certificates.** [S1] [S3] [S9] |
| Web-based SDK transport security | SSL via the **Use SSL connection**, **Certificate** and **Bind certificate to port** settings above. [S1] |
| Mission Control Web API | Reached over HTTPS on TCP 9550, or via the Directory on 443 when 9550 is blocked. The specific auth scheme is **not documented** in the retrieved sources. [S15] |
| **API keys / bearer tokens / OAuth scopes for the SDKs** | **Not documented** in the retrieved sources. Logged in `../known-gaps.md`. |

## 4. Events and webhooks

- The Web-based SDK has a dedicated **Streaming port** for events, and the events to listen to are configurable. [S1]
- **RabbitMQ** is the message broker for Mission Control (AMQPS on **TCP 5671**), used by the Incident Manager, Directory, Report Manager, Web API SDK and Security Desk. [S15]
- **Event-to-actions** and **automations** are the in-product mechanism for reacting to events, including **Send an email** and **Email a report** actions (license option **Automatic email notification**). From 5.14.0.0 automations support a **Wait for event** step and time zones for scheduling. [S1] [S9]
- **AutoVu Data Exporter** securely exports ALPR events to external endpoints over **TCP 443**, optionally through RabbitMQ on **TCP 5671**; the **Number of endpoints for the AutoVu Data Exporter** license option caps them. [S1] [S3]
- **Genetec Cloudrunner** integration sends reads over **TCP 5671** (with **5672** also needing to be unblocked per limitation 4340455). Enabled by the **Cloudrunner integration** setting on the ALPR Manager Properties page - which had a known bug where the change was not saved on Apply (issue 5190012, fixed in 5.14.0.1). [S3] [S9] [S10] |
- **HTTP webhooks** as a first-class outbound integration are **not documented** in the retrieved sources. Logged in `../known-gaps.md`.

## 5. RTSP integration through the Media Gateway [S5]

External applications request raw video over RTSP from the Media Gateway. Transcoding is decided by the requesting application:

| Requesting application | Transcoded? |
|---|---|
| External RTSP connections | **Never** |
| Genetec Mobile | Only when all of: the Media Gateway **Allow transcoding** setting is enabled for the Mobile Server role, the Mobile role allows MJPEG streams, and the original stream is not H.264 |
| Genetec Web App | Only when: the requesting user has video watermarking enabled, or the user is streaming and moving a PTZ camera, or the browser cannot decode H.264 through Media Source Extensions, or the original stream is not H.264 |

Capacity on a dedicated Media Gateway server, without transcoding, at 30 FPS:

| Resolution and codec | Average bit rate per camera | Recommended server | High-performance server |
|---|---|---|---|
| Full HD 1920x1080 H.264 | 4.76 Mbps | 127 streams | 170 streams |
| Full HD HEVC (H.265) | 3.21 Mbps | 153 streams | 198 streams |
| Full HD AV1 | 3.06 Mbps | 151 streams | 184 streams |
| Ultra HD 3840x2160 H.264 | 19 Mbps | 50 streams | 110 streams |
| Ultra HD HEVC (H.265) | 13.35 Mbps | 72 streams | 129 streams |
| Ultra HD AV1 | 12.74 Mbps | 66 streams | 123 streams |

Constraints and rate limits:

- **There is a hard limit of around 500 connections.**
- The **Number of Media Gateway RTSP streams** license option caps simultaneous stream requests from the role. [S1]
- Bit rates are for input streams only; transcoded output is resized to **640 x 480 (VGA) or less**, preserving aspect ratio.
- Video watermarking on all streams reduces the maximum stream count by **30%**.
- The values assume 30 FPS; at lower frame rates, with throughput still under the maxima, connections scale linearly.
- **CAUTION: do not host Media Gateway on the same server as an Archiver.** The role can use significant processing power, and high CPU on an Archiver server can cause "Archiving queue full" situations that lead to data loss.
- **RTSP usage restriction:** from 5.9.0.0 you can only use RTSP over HTTP or TCP **when combined with SDK access**. [S9]

No other documented rate limits or throttling for the SDKs were found - logged in `../known-gaps.md`.

## 6. SDK installation [S7]

From the separate SDK package, silent mode:

```
setup.exe /debuglog<setupLog> /s /v"/qn /l*v <msiLog> <SDK_options>"
```

| SDK option | Description |
|---|---|
| `AGREETOLICENSE` | Mandatory; only `Yes` is accepted, otherwise the install fails. |
| `CREATE_FIREWALL_RULES` | `1` add Security Center applications to the Windows Firewall exceptions list (default), `0` do not. |
| `INSTALLDIR` | Folder for the SDK package. Default `[ProgramFilesFolder]Genetec Security Center <version> SDK`. |

Sample:

```
setup.exe /debuglog"C:\Users\Public\prereqinstall.log" /s /v"/qn /l*v "C:\Users\Public\sdkmsi.log" AGREETOLICENSE=Yes CREATE_FIREWALL_RULES=0 INSTALLDIR="C:\NewFolder""
```

Both log folder paths must already exist - the setup program does not create them.

## 7. Documented third-party integrations

| Category | Integrations named in the retrieved sources | Src |
|---|---|---|
| Access control hardware | HID VertX and Edge (**end of life since 2023**; supported through the 5.14 lifecycle but plan hardware replacement before 5.15), HID EVO, HID V1000 / V2000 / V200 / V300, Mercury EP and MR panels (MR16IN, MR16OUT), Synergis Cloud Link, Cloud Link Roadrunner, Axis Powered by Genetec, Synergis IX, STid readers and desktop readers, OSS Standard Offline locks | S9, S1, S5 |
| Credentials | HID Origo (`https://api.origo.hidglobal.com`), ASSA ABLOY (`https://ma.api.assaabloy.com/credential-management/`), MIFARE DESFire, Evolis Primacy 2 printer with a STid SSCPv2 reader module | S3, S9 |
| Directory and identity | Windows Active Directory, Microsoft Entra ID, Okta, ADFS | S1 |
| Email | SMTP with Basic authentication or **Microsoft Entra OAuth** (new in 5.14.0.0) | S9 |
| Video | ONVIF-era vendor-specific ports; Axis (including M4317-PLVE, Axis SCU for wearable cameras), Bosch, Dahua (dewarping removed with the VC++ 2010 runtime), Ampleye decoders (removed) | S3, S9 |
| Cloud | Microsoft Azure (Cloud Storage on TCP 804/4434, Azure SQL databases via `SQLSERVER_GROUP=AzureServer`), Genetec Cloudrunner, Genetec Clearance, Stratocast Federation (needs Microsoft CCR and DSS Runtime 2008 R2 and R3 Redistributables installed manually from 5.13.2.0) | S3, S7, S9 |
| Communications | Sipelia with SIP trunks and external IP PBX, STUN (`turn.video.geneteccloud.com`, `stun.freeswitch.org`, `stun.l.google.com`, `global.stun.twilio.com`), a customer-supplied TURN server | S3 |
| Analytics | KiwiVision Privacy Protector, Camera Integrity Monitor, Security video analytics, People Counter | S4, S1 |
| Point of sale | Cash registers imported from an external point of sale system (**Number of cash registers** license option); a **Point of Sale** role appears in the SQL permission matrix | S1, S12 |
| Mapping | Esri ArcGIS Runtime 200 (a prerequisite), Google Maps, OpenStreetMap tiles, BeNomad geocoder for ALPR | S7, S17, S1 |
| Storage | Dell EMC storage configuration best practices; NAS and SAN via data store, Raw Device Mapping for Fibre Channel, or in-guest iSCSI | S14, S5 |
| Migration | Documented best-practice guides exist for migrating from **Nedap** and **AMAG** systems (titles only; contents not retrieved) | see known-gaps |
| Third-party ALPR | Genetec Third-Party ALPR Plugin (5.10.x line, with its own guides and release notes) | see known-gaps |

## 8. Backward compatibility of integration components [S7]

| Component | Backward-compatible with 5.11 / 5.12 / 5.13 |
|---|---|
| Web-based SDK | Yes |
| Record Caching Service | Yes |
| Record Fusion Service | Yes |
| Security Center Federation | Yes |
| Reverse Tunnel and Reverse Tunnel Server | Yes |
| Web App Server | Yes, 5.13.0.0 and later |
| Authentication Service (OpenID and SAML2) | **No** |
| Authentication Service (WS-Federation) | **No** |
| Authentication Service (WS-Trust) | **No** |
| Incident Manager (Mission Control) | **No** |
| Plugin roles | See "Supported plugins in Security Center" |

Two SDK-relevant upgrade cautions: **updating Newtonsoft from v12.0.2 to v12.0.3 might cause compatibility failures in your SDK environment**, and plugin users might need to upgrade integrated software to a version supported by 5.14.0.0. [S9]

## 9. What is NOT documented here

None of the following were available in the retrieved sources, and all are listed with retrieval paths in `../known-gaps.md`:

- SDK class, method and event reference; assembly names; code samples.
- Web-based SDK resource paths, verbs, payload schemas and error responses (only the address pattern `http://<computer>:<port>/<BaseURI>/` is documented).
- Web-based SDK authentication scheme and the default value of **Port** and **Base URI** (`4590` and `WebSdk` appear only as an example).
- Mission Control Web API endpoint list and authentication scheme.
- Any published rate limits other than the Media Gateway's ~500-connection ceiling and the RTSP stream license cap.
- Server Admin REST resource paths.
- SDK licensing entitlements beyond the option names **Web SDK**, **Plugin SDK** and **Media SDK**.
- Genetec Developer portal content (`developer.genetec.com`) - not retrieved in this session.
