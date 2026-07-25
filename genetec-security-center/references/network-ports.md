# Network and ports

Phase 2 section C. Every port below is a **default**; administrators can change most of them. Primary sources: [S3] for 5.14 and [S4] for 5.13. Read the Inbound column as "the component listens here" and the Outbound column as "the component initiates to this destination port".

## Contents

1. Firewall behaviour and the http.sys rule
2. Core platform ports (5.14)
3. Video / Omnicast ports
4. Access control / Synergis ports
5. ALPR / AutoVu ports
6. Intrusion detection ports
7. Sipelia ports
8. KiwiVision ports (documented in the 5.13 guide only)
9. Mission Control ports
10. Security Center SaaS cloud endpoints
11. 5.13 vs 5.14 differences
12. Checking port reachability
13. TLS, certificates and proxy support

## 1. Firewall behaviour and the http.sys rule [S3]

During installation you may let Security Center create Windows Firewall rules for its applications (silent option `CREATE_FIREWALL_RULES=1`, which is the default). This only adds the applications as exceptions to the **internal Windows firewall** - you must still open the ports on the network.

Ports handled by Windows HTTP components (`http.sys`) need this rule form:

```
dir="in" protocol="6" lport="<SPECIFY PORT USED HERE: CAN BE 80, 443, or CUSTOM>" binary="System"
```

Ports marked with footnote 1 in the source (Server Admin REST 80/443, Map Manager 8012, Record Caching Service 80/443, GUS 4594/4595/443, SAMA 443) use `http.sys`.

Genetec states explicitly: before exposing Security Center to the internet, implement the advanced security level in the Hardening Guide, or use a trusted VPN. Exposing AutoVu to the internet is discouraged without hardening first.

## 2. Core platform ports (5.14) [S3]

| Component | Purpose | Inbound | Outbound | Protocol | Executable |
|---|---|---|---|---|---|
| Directory | Server connections | TCP 5500 | | TLS 1.2 | `Genetec.Directory.exe` |
| Directory | Client connections | | TCP 5500 | TLS 1.2 | `SecurityDesk.exe`, `ConfigTool.exe` |
| Security Desk | Communication with Directory | | TCP 5500 | TLS 1.2 | `GenetecServer.exe` |
| Security Desk | Image map download from Map Manager | | TCP 8012 | HTTPS | `GenetecMapManager.exe` |
| Security Desk | Authentication role, geographic map providers | | TCP 443 | HTTPS / TLS 1.2 | `SecurityDesk.exe` |
| Security Desk / Config Tool | Embedded web browser | | TCP 443 | HTTPS | `Genetec.WebBrowserWorker.exe` |
| SDK | SDK application to Directory | | TCP 5500 | TLS 1.2 | `GenetecServer.exe` |
| SDK | Image map download from Map Manager | | TCP 8012 | HTTPS | `GenetecMapManager.exe` |
| Config Tool | Communication with Directory | | TCP 5500 | TLS 1.2 | `GenetecServer.exe` |
| Config Tool | Image map download from Map Manager | | TCP 8012 | HTTPS | `GenetecMapManager.exe` |
| Config Tool | Authentication role, GTAP (Genetec Advantage validation), geographic maps | | TCP 443 | HTTPS / TLS 1.2 | `ConfigTool.exe` |
| Active Directory | LDAP without SSL | | TCP 389 | HTTP | `GenetecActiveDirectory.exe` |
| Active Directory | LDAP with SSL | | TCP 636 | HTTPS | `GenetecActiveDirectory.exe` |
| Active Directory | Global catalog without SSL | | TCP 3268 | HTTP | `GenetecActiveDirectory.exe` |
| Active Directory | Global catalog with SSL | | TCP 3269 | HTTPS | `GenetecActiveDirectory.exe` |
| All roles | Expansion server to Directory (previously 4502; a system upgraded from 5.3 or earlier keeps 4502) | TCP 5500 | TCP 5500 | Genetec proprietary | `GenetecServer.exe` |
| All roles | Server Admin and REST | TCP 80 | TCP 80 | HTTP | `GenetecInterface.exe` |
| All roles | Secured REST or Authentication role (OIDC / SAML2) | TCP 443 | TCP 443 | HTTPS | `GenetecInterface.exe`, `GenetecAuth.exe` |
| All roles | SQL Database Engine on another server | | TCP 1433 | TDS | role-dependent |
| All roles | SQL Server Browser (named instance on another server) | | UDP 1434 | SSRP | role-dependent |
| Map Manager | Image map download requests from clients | TCP 8012 | | HTTPS | `GenetecMapManager.exe` |
| Mobile Server | Mobile app to Mobile Server | TCP 80, 443 | | HTTPS | `GenetecMobileRole.exe`, `GenetecMobileAgent.exe` |
| Mobile Server | Mobile Server to Media Gateway | | TCP 80, 443 | HTTPS | `GenetecMobileRole.exe`, `GenetecMobileAgent.exe` |
| Mobile Server | Mobile devices added to an Archiver for streaming/storage | TCP 9000-10000 | | HTTP | `GenetecMobileRole.exe`, `GenetecMobileAgent.exe` |
| Record Caching Service | Non-secured REST | TCP 80 | TCP 80 | HTTP | `GenetecIngestion.exe` |
| Record Caching Service | Secured REST or Authentication role | TCP 443 | TCP 443 | HTTPS | `GenetecIngestion.exe` |
| Unit Assistant | Communication with devices | TCP 5500 | TCP 5500 | Genetec proprietary | `GenetecUnitAssistantRole.exe` |
| Wearable Camera Manager | Axis SCU | | TCP 48830 | Genetec Clearance protocol | `GenetecBwcManagerRole.exe` |
| Wearable Camera Manager | Axis SCU, multiple roles on one server | | TCP 48831, 48832, 48833 | Clearance protocol | `GenetecBwcAgentService.exe` |
| Web App Server | Initial browser connection (redirected to HTTPS afterwards) | TCP 80 | TCP 80 | HTTP | `Genetec.WebApp.Console.exe` |
| Web App Server | Browser connection, secured REST or Authentication role | TCP 443 | TCP 443 | HTTPS | `Genetec.WebApp.Console.exe` |
| Web App Server | Web App stream requests to Media Gateway | | TCP 443 | HTTPS | `Genetec.WebApp.Console.exe` |
| GUS | GUS Sidecar to GUS | TCP 4596 | TCP 4596 | n/a | `GenetecUpdaterService.Sidecar.exe` |
| GUS | **Deprecated** legacy web page port; redirects to 4595 | TCP 4594 | | n/a | `GenetecUpdateService.exe` |
| GUS | Secure GUS web page and other GUS servers | TCP 4595 | TCP 4595 | HTTPS | `GenetecUpdateService.exe` |
| GUS | Microsoft Azure and Genetec Inc. | TCP 443 | TCP 443 | HTTPS | `GenetecUpdateService.exe`, `GenetecUpdaterService.Sidecar.exe` |
| SQL Server | Database Engine from roles on other servers | TCP 1433 | | TDS | `sqlservr.exe` |
| SQL Server | SQL Server Browser | UDP 1434 | | SSRP | `sqlbrowser.exe` |
| SAMA | Security Center servers | | TCP 443 | HTTPS | `Genetec.HealthMonitor.Agent.exe` |
| SAMA | Health Service in the cloud | | TCP 443 | HTTPS | `Genetec.HealthMonitor.Agent.exe` |

Redirector history note carried in both port guides: **TCP 960** applies to new installations of 5.8 and later. 5.6 and 5.7 used **TCP 5004**, so any system upgraded to 5.14 through 5.6 or 5.7 keeps 5004. [S3]

## 3. Video / Omnicast ports (5.14) [S3]

| Component | Purpose | Inbound | Outbound | Protocol | Executable |
|---|---|---|---|---|---|
| Archiver | Cloud Storage | | TCP 804, 4434 | HTTPS / TLS 1.2 | `GenetecArchiverAgent32.exe` |
| Archiver | Communication with Media Router | | TCP 554 | RTSP (over TLS when secure comms enabled) | `GenetecArchiverAgent32.exe` |
| Archiver | Live and playback stream requests | TCP 555 | | RTSP over TLS | `GenetecArchiverAgent32.exe` |
| Archiver | Edge playback stream requests | TCP 605 | | RTSP over TLS | `GenetecVideoUnitControl32.exe` |
| Archiver | Mobile streaming through Mobile Server | | TCP 9000-10000 | HTTP | `GenetecVideoUnitControl32.exe` |
| Archiver | Primary Archiver to backup servers | TCP 5500 | TCP 5500 | TLS 1.2 | `GenetecArchiver.exe`, `GenetecArchiverAgent32.exe`, `GenetecVideoUnitControl32.exe` |
| Archiver | Telnet console connection requests | TCP 5602 | | Telnet | `GenetecArchiverAgent32.exe` |
| Archiver | Live unicast stream requests from IP cameras | UDP 15000-19999 | | SRTP when encrypting | `GenetecVideoUnitControl32.exe` |
| Archiver | Live video and audio multicast | UDP 47806, 47807 | UDP 47806, 47807 | SRTP when encrypting | `GenetecVideoUnitControl32.exe` |
| Archiver | Wearable Camera Manager API | TCP 48831-48833 | | | |
| Archiver | Vendor-specific camera ports | TCP and UDP | TCP 80, 443, 554, 322 commonly | HTTP / HTTPS / RTSP / RTSP over TLS | `GenetecVideoUnitControl32.exe` |
| Redirector | Live and playback stream requests | TCP 560 | | RTSP over TLS | `GenetecRedirector.exe` |
| Redirector | Media Router (Security Center Federation) | | TCP 554 | RTSP over TLS | `GenetecRedirector.exe` |
| Redirector | Archiver | | TCP 555 | RTSP over TLS | `GenetecRedirector.exe` |
| Redirector | Auxiliary Archiver | | TCP 558 | RTSP over TLS | `GenetecRedirector.exe` |
| Redirector | Cloud Playback requests | | TCP 5704 | RTSP over TLS | `GenetecRedirector.exe` |
| Redirector | Edge playback | | TCP 605 | RTSP over TLS | `GenetecRedirector.exe` |
| Redirector | Privacy Protector | | TCP 754 | RTSP over TLS | `GenetecRedirector.exe` |
| Redirector | Stream requests to other redirectors | | TCP 560 | RTSP over TLS | `GenetecRedirector.exe` |
| Redirector | Media transmission to client applications | TCP 9603 | UDP 6000-6500, TCP 9603 | SRTP when encrypting | `GenetecRedirector.exe` |
| Redirector | Media transmission to other redirectors | UDP 8000-12000 | UDP 8000-12000 | SRTP when encrypting | `GenetecRedirector.exe`, `GenetecVideoUnitControl.exe`, `GenetecCloudPlaybackAgent.exe` |
| Redirector | Live video and audio multicast | UDP 47806, 47807 | UDP 47806, 47807 | SRTP when encrypting | `GenetecRedirector.exe` |
| Redirector | Live video multicast (Federation) | UDP 65246 | UDP 65246 | SRTP when encrypting | `GenetecRedirector.exe` |
| Auxiliary Archiver | Live and playback stream requests | TCP 558 | | RTSP over TLS | `GenetecAuxiliaryArchiver.exe` |
| Auxiliary Archiver | Unicast media stream requests | UDP 6000-6500 | | SRTP when encrypting | `GenetecAuxiliaryArchiver.exe` |
| Auxiliary Archiver | Multicast video and audio | UDP 47806, 47807 | | SRTP when encrypting | `GenetecAuxiliaryArchiver.exe` |
| Auxiliary Archiver | Multicast video (Federation) | UDP 65246 | | SRTP when encrypting | `GenetecAuxiliaryArchiver.exe` |
| Auxiliary Archiver | Live stream requests | | TCP 554, 555, 560 | RTSP over TLS | `GenetecAuxiliaryArchiver.exe` |
| Auxiliary Archiver | Media transmission | | TCP 9603 | SRTP when encrypting | `GenetecAuxiliaryArchiver.exe` |
| Cloud Playback | Stream requests from within Security Center | TCP 570 | | RTSP over TLS | `GenetecCloudPlaybackRole.exe`, `GenetecCloudPlaybackAgent.exe` |
| Cloud Playback | Cloud Storage | | TCP 80, 443 | TLS 1.2 | `GenetecCloudPlaybackRole.exe`, `GenetecCloudPlaybackAgent.exe` |
| Media Router | Live and playback stream requests | TCP 554 | | RTSP over TLS | `GenetecMediaRouter.exe` |
| Media Router | Federated Media Router stream requests | | TCP 554 | RTSP over TLS | `GenetecMediaRouter.exe` |
| Media Router | Communication with redirectors | TCP 5500 | TCP 5500 | TLS 1.2 | `GenetecMediaRouter.exe` |
| Media Gateway | Stream requests from RTSP clients | TCP 654 | | RTSP over TLS | `Genetec.MediaGateway.exe` |
| Media Gateway | Stream requests from Mobile or Web App | TCP 80, 443 | | HTTP / HTTPS | `Genetec.MediaGateway.exe` |
| Media Gateway | Agents to role | TCP 5500 | TCP 5500 | TLS 1.2 | `Genetec.MediaGateway.exe` |
| Media Gateway | Live video unicast | UDP 6000-6500 | | SRTP when encrypting | `Genetec.MediaComponent32.exe` |
| Media Gateway | Multicast video and audio | UDP 47806, 47807 | UDP 51914 | SRTP when encrypting | `Genetec.MediaComponent32.exe` |
| Media Gateway | Multicast video (Federation) | UDP 65246 | | SRTP when encrypting | `Genetec.MediaComponent32.exe` |
| Media Gateway | Live and playback stream requests | | TCP 554, 555, 558, 560, 605 | RTSP over TLS | `Genetec.MediaComponent32.exe` |
| Media Gateway | Cloud Playback requests | | TCP 5704 | RTSP over TLS | `Genetec.MediaComponent32.exe` |
| Security Center Federation | Connection to remote systems | | TCP 5500 | TLS 1.2 | `GenetecSecurityCenterFederation.exe` |
| Security Center Federation | Live and playback stream requests | TCP 554, 560, 9603 | TCP 554, 560, 9603 | RTSP over TLS | `Genetec.MediaComponent32.exe` |
| Security Desk | Unicast UDP live streams | UDP 6000-6200 | | SRTP when encrypting | `SecurityDesk.exe`, `Genetec.MediaComponent32.exe` |
| Security Desk | Multicast video and audio | UDP 47806, 47807 | | SRTP when encrypting | `SecurityDesk.exe`, `Genetec.MediaComponent32.exe` |
| Security Desk | Multicast video (Federation) | UDP 65246 | | SRTP when encrypting | `SecurityDesk.exe`, `Genetec.MediaComponent32.exe` |
| Security Desk | Stream requests from RTSP clients | | TCP 554, 555, 558, 560, 605 | RTSP over TLS | `SecurityDesk.exe`, `Genetec.MediaComponent32.exe` |
| Security Desk | Media transmission | | TCP 9603 | SRTP when encrypting | `SecurityDesk.exe`, `Genetec.MediaComponent32.exe` |
| Security Desk | Cloud Playback requests | | TCP 5704 | RTSP over TLS | `SecurityDesk.exe`, `Genetec.MediaComponent32.exe` |
| Config Tool | Unicast UDP live streams | UDP 6000-6200 | | SRTP when encrypting | `ConfigTool.exe`, `Genetec.MediaComponent32.exe` |
| Config Tool | Multicast video and audio | UDP 47806, 47807 | | SRTP when encrypting | `ConfigTool.exe`, `Genetec.MediaComponent32.exe` |
| Config Tool | Multicast video (Federation) | UDP 65246 | | SRTP when encrypting | `ConfigTool.exe`, `Genetec.MediaComponent32.exe` |
| Config Tool | Stream requests from RTSP clients | | TCP 554, 555, 560 | RTSP over TLS | `ConfigTool.exe`, `Genetec.MediaComponent32.exe` |
| Config Tool | Media transmission | | TCP 9603 | SRTP when encrypting | `ConfigTool.exe`, `Genetec.MediaComponent32.exe` |
| Config Tool | Unit discovery (Unit enrollment tool) and firmware upgrade | | vendor-specific TCP and UDP | vendor-specific | `ConfigTool.exe` |
| Config Tool | Cloud Storage reporting and configuration | | TCP 804, 4434 | HTTP | `ConfigTool.exe` |
| SQL Server | Connections from Media Router, Auxiliary Archiver, Directory | TCP 1433 | | TDS | `sqlservr.exe` |
| SQL Server | SQL Server Browser | UDP 1434 | | SSRP | `sqlbrowser.exe` |

Two footnotes that matter operationally: [S3]

- TCP 555 / 5602 apply to a server hosting **one** Archiver role. Each additional Archiver role on the same server uses the next free port.
- Each Archiver **agent** assigns a unique UDP port per video unit. Each additional agent on the same server adds 5000 to its starting UDP port: agent 1 uses 15000-19999, agent 2 uses 20000-24999, agent 3 uses 25000-29999, and so on. Live-streaming reception UDP ports can be assigned manually from the Archiver role **Resource** tab.
- In the Cloud Storage context, TCP 80, 443 and 570 are used only when Cloud Storage is enabled.

## 4. Access control / Synergis ports (5.14) [S3]

| Component | Purpose | Inbound | Outbound | Protocol | Executable |
|---|---|---|---|---|---|
| Access Manager | Synergis extension discovery | | UDP 2000 | Genetec proprietary | `GenetecAccessManager.exe` |
| Access Manager | Secure communication with Synergis and HID units | | TCP 443 | HTTPS / TLS 1.2 | `GenetecAccessManager.exe` |
| Access Manager | HID extension - FTP data and command | TCP 20 | TCP 21 | FTP | `GenetecAccessManager.exe` |
| Access Manager | HID extension - SSH | | TCP 22 | SSH | `GenetecAccessManager.exe` |
| Access Manager | HID extension - Telnet | | TCP 23 | Telnet | `GenetecAccessManager.exe` |
| Access Manager | HID extension - HTTP | | TCP 80 | HTTP | `GenetecAccessManager.exe` |
| Access Manager | HID extension - VertX OPIN protocol | | TCP 4050 or 4433 | 4050 proprietary, 4433 HTTPS/TLS 1.2 | `GenetecAccessManager.exe` |
| Access Manager | HID extension - VertX discovery | UDP 4070 | UDP 4070 | n/a | `GenetecAccessManager.exe` |
| Access Manager | Remote syslog server | UDP 514 | | n/a | `GenetecAccessManager.exe` |
| Global Cardholder Synchronizer | Connection to sharing host | | TCP 5500 | TLS 1.2 | `GenetecGlobalCardholderManagement.exe` |
| Mobile Credential Manager | Mobile credential provider portal | | TCP 443 | HTTPS / TLS 1.2 | `GenetecMobileCredentialManager.exe` |

Footnotes: the FTP / SSH / Telnet / HTTP ports are **not used when HID units run in Secure mode** (enabling secure mode on all HID units is the documented best practice). Legacy HID units, or EVO units on firmware earlier than 3.7, use TCP 4050; HID EVO units in secure mode on firmware 3.7 and later use TCP 4433. The HID discovery port is fixed at UDP 4070. **Starting in Security Center 5.10.1.0 the remote syslog port UDP 514 is no longer enabled by default.** [S3]

Security Desk, Config Tool and the Mobile Credential Manager role all need access to `https://api.origo.hidglobal.com` and `https://ma.api.assaabloy.com/credential-management/`. [S3]

## 5. ALPR / AutoVu ports (5.14) [S3]

**Sharp units (inbound to the unit):** TCP 22 SSH (optional on SharpV G3 OS for Support), TCP 80 video/HTTP (communication port for SharpOS 12.7 and lower), TCP 443 secure port (LPM protocol, video, Genetec protocol), TCP 554 and UDP 554 RTSP, **TCP 2222 LPM protocol over SSH tunnel (SharpV G3 running SharpOS 14.1 and later)**, **TCP 2323 used by the SharpV to determine which extension to load**, UDP 2728 appliance discovery service, TCP 3389 RDP (optional), TCP 4502-4534 Silverlight and image feed service (Sharp models earlier than SharpV), TCP 4545 control port (mobile installation), TCP 8001 control port (fixed installation).

**Sharp units (outbound from the unit):** TCP 80 SharpV HTTP extension, UDP 514 syslog on demand, **TCP 9001 LPM protocol for Security Center 5.8**, TCP 10001 LPM protocol communication.

**Sharp extensions (outbound file upload):** FTP any port (default TCP 21), HTTP any port, SFTP any port (default TCP 22; optional in SharpOS 14).

| Component | Purpose | Inbound | Outbound | Protocol | Executable |
|---|---|---|---|---|---|
| ALPR Manager | Secure port between Patroller and Security Center | **TCP 18731** | | TCP | `GenetecLicensePlateManager.exe` |
| ALPR Manager | LPM protocol listening port | TCP 10001 | | HTTPS | `GenetecLicensePlateManager.exe` |
| ALPR Manager | Secure communication for DataExporter | | TCP 443 | HTTPS | `GenetecLicensePlateManager.exe` |
| ALPR Manager | Fixed Sharp unit discovery | | UDP 5000 | n/a | `GenetecLicensePlateManager.exe` |
| ALPR Manager | RabbitMQ for DataExporter (optional) | | TCP 5671 | HTTPS | `GenetecLicensePlateManager.exe` |
| ALPR Manager | Sending reads to Cloudrunner | | TCP 5671 | HTTPS | `GenetecLicensePlateManager.exe` |
| ALPR Manager | Sharp control port (live connections, not LPM) | | TCP 8001 | HTTP | `GenetecLicensePlateManager.exe` |
| ALPR Manager | Pay-by-Plate Sync plugin | | TCP 8787 / TCP 8788 | HTTP / HTTPS | `GenetecLicensePlateManager.exe` |
| Archiver (for Sharp as video unit) | Default Media Router RTSP port | TCP 554 | | RTSP | `GenetecArchiverAgent32.exe` |
| Archiver (for Sharp as video unit) | Default Archiver port | TCP 555 | | RTSP | `GenetecArchiverAgent32.exe` |
| Patroller (in-vehicle) | Communication with mobile Sharp units | TCP 4545 | TCP 4545 | TCP / HTTPS | `Patroller.exe` |
| Patroller | Time synchronization service for Sharp units | TCP 4546 | | SNTP | `Patroller.exe` |
| Patroller | Communication with Simple Host | TCP 8001 | | HTTP | `Patroller.exe` |
| Patroller | Pay-by-Plate Sync plugin | TCP 8787 | | HTTP | `Patroller.exe` |
| Patroller | Curb Sense and Plate Link | | TCP 443 | HTTPS | `Patroller.exe` |
| Patroller | Sharp camera discovery | | UDP 5000 | UDP | `Patroller.exe`, `PatrollerConfigTool.exe` |
| Patroller | Secure port to Security Center | | **TCP 18731** | HTTPS | `Patroller.exe` |
| Pay-by-Plate Sync | Free-Flow and Patroller | TCP 8787 | TCP 8787 | HTTP | `GenetecPlugin.exe` |
| Pay-by-Plate Sync | Secure communication with Free-Flow | TCP 8788 | TCP 8788 | HTTPS | `GenetecPlugin.exe` |

**5.14 behaviour change:** Patroller must connect through the secure service port **TCP 18731** and must be registered with Security Center using authenticated credentials. Sharp cameras can no longer use the legacy WCF connection - the LPM protocol is mandatory. [S9]

## 6. Intrusion detection ports [S3]

Not enumerated in the port guide. Refer to the extension guide for the specific intrusion panel extension and to the "Security Center Network Diagram - Intrusion Detection". Logged in `../known-gaps.md`.

## 7. Sipelia ports [S3]

**Sipelia Server** (`GenetecPlugin32.exe`):

| Port usage | Inbound | Protocol | Notes |
|---|---|---|---|
| SIP port | UDP 5060 | SIP | Basis of all SIP communication. Every SIP endpoint (softphones, SIP intercoms) must carry this value. |
| SIP trunks port | UDP 5060 | SIP | SIP trunks are SIP servers, so the default is also 5060. |
| SIP TCP port | TCP 5060 | SIP | **Disabled by default.** |
| SIP secure port | TCP 5061 | SIP over TLS | TLS must be configured in Config Tool for the secure port to appear. The SIP device must trust the Server Admin certificate. |
| Session transfer port | TCP 8202 | TLS | Downloads call-session recordings to the Security Desk **Call report** task. |
| UDP port range | UDP 20000-20500 | RTP | Set by `MinimumPortRange` and `MaximumPortRange` in `C:\ProgramData\Genetec Sipelia\SipServer\SipServer.config`. |

**Sipelia Client** (`SecurityDesk.exe`): outbound UDP 5060 (value retrieved from the server, not changeable client-side), TCP 5060, TCP 5061, TCP 8202, and UDP 20000-20500 both directions. The client UDP range is changed from **Options > Sipelia > Advanced** in Security Desk.

**Sipelia Gateway role** (`GenetecPlugin.exe`):

| Port usage | Direction | Protocol | Notes |
|---|---|---|---|
| WebRTC port range | outbound UDP 49152-65535 | WebRTC | Windows dynamic range. Set by `Min.PortRange` and `Max.PortRange` in `C:\ProgramData\Genetec Sipelia\CallService.appsettings.json`. |
| STUN servers | outbound UDP 443, 3478, 19302 | STUN | `stun:turn.video.geneteccloud.com:443`, `stun:stun.freeswitch.org:3478`, `stun:stun.l.google.com:19302`, `stun:global.stun.twilio.com:3478` |
| TURN server | outbound UDP 80 (provider dependent) | TURN | Sipelia does not provide a TURN server; obtain an account and configure it at **System > Roles > Sipelia Gateway > Properties**. |
| Web API port | inbound 7550 | HTTPS | Used by Mobile Server and Web App Server to reach the Sipelia Gateway. Configurable in `C:\ProgramData\Genetec Sipelia\WebApi.appsettings.json`. |

## 8. KiwiVision ports - documented in the 5.13 guide only [S4]

The 5.13 port guide contains a **Ports used by KiwiVision modules** section that has **no counterpart in the 5.14 guide**. Treat these as the last documented values and verify before relying on them for a 5.14 system (logged in `../known-gaps.md`).

| Component | Purpose | Inbound | Outbound | Protocol | Executable |
|---|---|---|---|---|---|
| Privacy Protector / Camera Integrity Monitor | Live video unicast stream requests | UDP 7000-7500 | | SRTP when encrypting | `Genetec.MediaProcessor.exe` |
| Privacy Protector / Camera Integrity Monitor | Media transmission | | TCP 9601 | SRTP when encrypting | `Genetec.MediaProcessor.exe` |
| KiwiVision Manager | KiwiVision Manager database | | TCP 1433 | TDS | `GenetecPlugin.exe` |
| KiwiVision Analyzer | Live and playback stream requests | | TCP 554, 560, 9601 | RTSP over TLS | `GenetecPlugin.exe`, `Genetec.MediaComponent32.exe` |
| KiwiVision Analyzer | KiwiVision Manager database | | TCP 1433 | TDS | `GenetecPlugin.exe` |
| SQL Server | Connections from KiwiVision Manager and Analyzer roles | TCP 1433 | | TDS | `sqlservr.exe` |

The Privacy Protector redirector path (`Redirector -> TCP 754`) is present in **both** the 5.13 and 5.14 guides. [S3] [S4]

## 9. Mission Control ports [S15]

| Application | Inbound | Outbound | Purpose |
|---|---|---|---|
| Client applications (Security Desk, Config Tool) | | TCP 5500 | Directory communication |
| | | TCP 8012 | Map background web requests to Map Manager |
| | | TCP 443 | GTAP (Advantage validation), Authentication role, Web API SDK |
| | | TCP 5671 | RabbitMQ SSL port (Security Desk) |
| RabbitMQ | TCP 5671 | | RabbitMQ SSL port |
| RabbitMQ | TCP 4369 | | Erlang port |
| RabbitMQ | TCP 15671 | | HTTPS API port |
| RabbitMQ | TCP 25672 | | Node clustering port |
| Incident Manager | TCP 5500 / TCP 4502 | TCP 5500 / TCP 4502 | Genetec Server and Directory communication (4502 replaces 5500 for roles originally created in 5.3 and earlier) |
| Incident Manager | TCP 80 / TCP 443 | TCP 80 / TCP 443 | REST and Server Admin, secured REST, Authentication role, Web API SDK |
| Incident Manager | | TCP 1433 / UDP 1434 | Remote SQL Database Engine and SQL Server Browser |
| Incident Manager | | TCP 5671 / TCP 15671 | RabbitMQ AMQPS and HTTPS API |
| Directory | TCP 4502 | TCP 4502 | Genetec Server communication |
| Directory | TCP 80 / TCP 443 | TCP 80 / TCP 443 | Directory web server, secured web server |
| Directory | TCP 5500 | | Client connections |
| Directory | | TCP 5671 | RabbitMQ SSL port |
| Directory | | TCP 9550 | Web API SDK |
| Web API SDK | **TCP 9550** | | API secured web server. **If this port is blocked, the Directory forwards requests to the expansion server hosting the Incident Manager role on port 443.** |
| Web API SDK | | TCP 443 / TCP 5671 | Directory secured web server, RabbitMQ |
| Mobile Server, Incident Document Service, Web App Server | TCP 5500 / 4502, 80, 443 | TCP 5500 / 4502, 80, 443, 1433, 1434 | Same pattern as Incident Manager |
| Report Manager | | TCP 5671 | RabbitMQ SSL port |
| External SQL Server | TCP 1433 / UDP 1434 | | Incoming role connections and SQL Server Browser |

RabbitMQ ports can be changed during or after installation (`SSLPORT` and `MANPLUGPORT` silent options; see `install-upgrade.md`). [S15]

## 10. Security Center SaaS cloud endpoints [S17]

SaaS is Genetec-hosted, so the relevant control is **outbound** firewall/proxy allow-listing. All five regional data centres share the same endpoint pattern; only the region-specific hosts differ.

| Region | Host sign-in URL | Regional SaaS endpoint | Video endpoint | RTSP endpoint | RTSP static IPs |
|---|---|---|---|---|---|
| United States | `https://us.securitycentersaas.genetec.cloud/` | `us.securitycentersaas.genetec.cloud` | `eastus2.video.genetec.cloud` | `rtsp.eastus2.video.genetec.cloud` | `20.157.76.128/28` |
| Canada | `https://ca.securitycentersaas.genetec.cloud/` | `ca.securitycentersaas.genetec.cloud` | `centralca.video.genetec.cloud` | `rtsp.centralca.video.genetec.cloud` | `20.157.121.64/28` |
| Europe | `https://eu.securitycentersaas.genetec.cloud/` | `eu.securitycentersaas.genetec.cloud` | `westeu.video.genetec.cloud` | `rtsp.westeu.video.genetec.cloud` | `20.157.123.144/28` |
| United Kingdom | `https://uk.securitycentersaas.genetec.cloud/` | `uk.securitycentersaas.genetec.cloud` | `southuk.video.genetec.cloud` | `rtsp.southuk.video.genetec.cloud` | `20.47.68.192/28` |
| Australia | `https://au.securitycentersaas.genetec.cloud/` | `au.securitycentersaas.genetec.cloud` | `eastau.video.genetec.cloud` | `rtsp.eastau.video.genetec.cloud` | `20.47.123.48/28` |

Common to every region: `securitycentersaas.genetec.cloud` with static IPs `208.88.71.3` and `208.88.71.4` on **TCP 443**.

| Outbound port | Endpoints | Purpose |
|---|---|---|
| TCP 443 | `login.genetec.com`, `id.login.genetec.com`, `assets.login.genetec.com`, `challenges.cloudflare.com` | Genetec single sign-on |
| TCP 443 | `login.microsoftonline.com`, `aadcdn.msauth.net`, `login.live.com` | Microsoft sign-in |
| TCP 443 | `events.launchdarkly.com`, `app.launchdarkly.com`, `clientstream.launchdarkly.com` | Genetec feature management |
| TCP 443 | `sgnlr-uni-prodglobal-<region>.service.signalr.net`, `canadacentral-1.in.applicationinsights.azure.com` | Monitoring and eventing |
| TCP 443 | `https://api-js.mixpanel.com` | Product analytics |
| TCP 443 | `https://app.productfruits.com`, `https://my.productfruits.com`, `wss://ws2.productfruits.com` | Product adoption platform |
| TCP 443 | `maps.googleapis.com`, `maps.gstatic.com`, `fonts.googleapis.com`, `fonts.gstatic.com` | Google Maps |
| TCP 443 | `az416426.vo.msecnd.net`, `dc.services.visualstudio.com` | Other dependencies |
| TCP 443 | `a.tile.openstreetmap.org`, `b.tile.openstreetmap.org`, `{GenetecReference}.gsc-cloud.com` | Operator tasks (web and mobile) |
| UDP 20000-60000 | `global.relay.metered.ca` | Call media (audio and video) |
| UDP 80 | `stun.relay.metered.ca` | STUN, resolving public addresses |
| TCP 443 | `mobile.launchdarkly.com`, `firebaselogging-pa.googleapis.com`, `app-measurement.com`, `device.login.microsoftonline.com`, `config.edge.skype.com`, `mobile.events.data.microsoft.com`, `authenticator-azureidentity-tas.msedge.net`, `fcmtoken.googleapis.com` | Configuration on iOS and Android |
| TCP 5500 | `{GenetecReference}.gsc-cloud.com` | Security Center TLS proxy (desktop apps) |
| TCP 554, 560, 960 | `{GenetecReference}.gsc-cloud.com` | RTSP over TLS (desktop apps) |
| TCP 554, 1935 | `*.genetec.cloud` (recommended) | RTSP over TLS and ICE TCP in WebRTC for live streaming |
| TCP 443 | `downloadcenter1.genetec.com` | HTTPS downloads |
| TCP 8012 | `{GenetecReference}.gsc-cloud.com` | Map Manager to desktop clients |

The Genetec reference format is `SCC` followed by 12 digits, for example `SCC-232136-654353`; obtain it from your Genetec channel partner.

**Federating an on-premises system into SaaS:** the on-premises **Directory** needs outbound **TCP 5500** to `*.gsc-cloud.com` for reverse tunnel communication. That is the only row in the published Federation port table. [S17]

**SaaS network requirements:** latency of **150 ms or less** to the closest Azure data centre is mandatory; a 99.9% ISP SLA is highly recommended; cameras at remote sites should support multiple streams so outbound video can use a lower-bandwidth stream (only a single stream is supported for managed devices). [S17]

## 11. 5.13 vs 5.14 differences

Derived from a programmatic comparison of the two port guides. [S3] [S4]

| Change | 5.13 | 5.14 |
|---|---|---|
| Patroller / Sharp to Security Center secure service port | **TCP 8731** ("Genetec Patroller communication and fixed Sharp units, not used for LPM protocol connections"; Patroller side described as "ALPR Manager connection", HTTP with message-level encryption) | **TCP 18731** ("Secure port for communication between Patroller and Security Center", HTTPS) |
| SharpV G3 LPM over SSH tunnel | not listed | **TCP 2222** (SharpOS 14.1 and later) |
| SharpV extension selector | not listed | **TCP 2323** |
| LPM protocol for Security Center 5.8 (Sharp outbound) | not listed | **TCP 9001** |
| SAMA legacy path | **TCP 4592** "Communication with Security Center (Legacy)" | removed |
| KiwiVision module ports | present (UDP 7000-7500, TCP 9601, TCP 1433) | **section absent** |

Everything else in the two guides matches on port numbers.

## 12. Checking port reachability [S20] [S21]

Documented read-only checks:

```
netstat -na | find"[PortNumber]"
telnet <IP address> <port number>
tnc -computer (IP or DNS name of the server) -port (port number)
```

`telnet` requires the Telnet Client Windows feature (**Control Panel > Programs and Features > Turn Windows features on or off**). `tnc` is the PowerShell `Test-NetConnection` alias. See `../scripts/healthcheck.ps1` for a packaged read-only version.

## 13. TLS, certificates and proxy support

**TLS versions.** Directory and server-to-server links are documented as TLS 1.2. A published known issue states that **Security Center communications do not support TLS 1.3 by default** (issue 4823559). [S9] The Hardening Guide recommends disabling SSL 3.0 and TLS 1.0, enabling TLS 1.1 only if another program still requires it, and allowing only TLS 1.2 and later. [S12]

**Certificate requirements (Hardening Guide recommendations):** [S12]

- Server certificate signed with an RSA key of at least **2,048 bits** or an ECC key of at least **256 bits**; signed by a public CA where possible.
- Certificate must use **SHA-2** or better with a digest of at least **256 bits** (SHA-256 or greater).
- Connection must use **TLS 1.2** or later.
- Data exchanged with **AES-128** or **AES-256**.
- The link must support perfect forward secrecy through **ECDHE** key exchange.

**Replacing the self-signed certificate:** Server Admin > select the server > **Secure communication > Select certificate > Select > Save**. When installing Security Center, select **Always validate the Directory certificate** on the InstallShield Security Settings page. If a client does not trust the certificate the logon dialog offers "Proceed and do not ask again (not recommended)", "Cancel logon", and "View certificate details". [S12]

**ECDSA certificates** for Directory communication are available from 5.9.3.0 with three restrictions: servers on 5.9.3.0+ using ECDSA are incompatible with servers on 5.9.2.0 or earlier; systems using ECDSA are incompatible with third-party authentication over SAML 2.0; and a Federation host using ECDSA can only stream video from federated sites that also use ECDSA. [S9]

**Video digital signatures** use Ed25519 (EdDSA) from 5.8.1.1. Files signed by earlier versions still validate but are reported as authenticated with an obsolete algorithm. [S9]

**Proxy support.** Documented for the Genetec Update Service: "Using a proxy server to connect Genetec Update Service to the internet (Basic)". [S12] [S26] A general system-wide HTTP proxy setting for Security Center roles is **not documented** in the retrieved sources - logged in `../known-gaps.md`.

**Encryption cost.** Fusion stream encryption reduces Archiver capacity by 30% for the first certificate and a further 4% per additional certificate applied to all cameras; do not exceed 20 certificates per Archiver. Client-side, video encryption can raise CPU by up to 40% for CIF video, becoming negligible at HD and Ultra-HD. [S5]
