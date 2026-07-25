# Known Gaps

What the public Genetec developer documentation did **not** answer, what was behind a login wall, and where to go instead. Nothing in this list was filled in from general knowledge.

Retrieved 2026-07-24 from `developer.genetec.com`.

---

## 1. Gated sources

The developer portal shows a DAP membership wall on SDK/API pages. The notice encountered verbatim:

> "If you are a DAP member, sign in to see more information on the Security Center SDK and APIs. Access rights will be granted within 30 minutes after signing in. If you are not a member, visit the DAP page to apply."

| Gated / unavailable item | Where it is referenced | How to obtain |
|---|---|---|
| Additional Security Center SDK and API content shown only to signed-in DAP members | `/r/en-us/overview-of-the-platform-sdk/overview-of-the-platform-sdk` and sibling overview pages | Sign in as a DAP member on developer.genetec.com, wait up to 30 minutes for rights to propagate, then re-read the SDK pages |
| **API and SDK integration certification — Process document** | DAP → Program documents | DAP portal / `DAP@genetec.com` |
| **API and SDK integration certification — Checklist document** | DAP → Program documents | DAP portal / `DAP@genetec.com` |
| **API and SDK integration certification — Criteria document** | DAP → Program documents | DAP portal / `DAP@genetec.com` |
| Supporting document templates: SDK & API integration, Quality assurance, Genetec security questionnaire, Deployment and installation guide, Administration and configuration guide, User guide | DAP → Supporting document templates | DAP portal |
| **DAP technical assistance brochure** (tier contents and pricing) | DAP → "What are the costs associated with the SDK?" — the tier comparison is presented as a screenshot, not as text | `DAP@genetec.com` |
| **DAP SharePoint folder** (solution listing submission) | DAP → part numbers and certificates | Provided to partners by the DAP team |
| **SDK package itself** — installer, samples (`SDK-Samples-Standard`, `WebSdkStudio`, `ModuleSample`, `VideoViewer`), and the development licence | Referenced throughout S1 | Submit the online SDK application form and accept the SDK License Terms; the package is sent after approval |
| **Web SDK Postman collection** | S1 references a download link for it | Developer portal (DAP sign-in likely required) |
| **Compatibility Pack ("CPack")** for Omnicast federated video | S1 troubleshooting | "Contact the SDK support and request the Compatibility Pack by providing them with the Omnicast Version" |
| **Media SDK licence option** | S1 licensing topic | Requires an **NDA**; contact `TechPartners@genetec.com` |
| `gwp.d.ts` — full Web Player API surface and complete enums | S1 Web Player topics | `https://<MediaGatewayAddress>/v2/files/gwp.d.ts` — needs a running Media Gateway |
| Security Center **Administrator Guide**, **Installation and Upgrade Guide**, **Hardening Guide**, **System Requirements** | Repeatedly cross-referenced by S1 ("Refer to the Security Center Administration guide…") | Genetec TechDoc portal / GTAP; not on developer.genetec.com |
| Non-English variants of the same guides (`es-mx`, `fr-fr` locales) | Portal sitemap | Deliberately excluded from this skill; switch locale on the portal |

---

## 2. Phase-2 checklist items the documentation did not answer

### A. Product & licensing
| Gap | Notes | Where to look |
|---|---|---|
| Editions/SKU feature deltas beyond SDK options | Only Standard vs Extended (Media) SDK is described, plus the Web SDK licence option | GTAP price list; `DAP@genetec.com` |
| Per-camera / per-server / subscription licensing of Security Center itself | Out of scope of the SDK docs. SDK licensing is per **certificate connection** via part numbers | Genetec sales / Channel Partner |
| Activation mechanics | Only "reapply their license using the web or manually" is stated | Administrator Guide, GTAP |
| **EOL and lifecycle policy; support dates per SDK version** | **Not documented anywhere in this doc set** | Genetec TAC / GTAP lifecycle bulletins |
| Certificate connection **cost** per part number | "this part number is associated with a per-certificate cost" — no figures given | `DAP@genetec.com` |

### B. Architecture
| Gap | Notes |
|---|---|
| Directory / role **database schemas**, table sizes, growth | Not documented. Only the `EventStream` table is named |
| Full inventory of Windows **services** (as opposed to processes) | Only the "Genetec Server service" is named in passing; no service short names, no dependencies |
| HA / clustering / failover topology detail | Only "the Plugin SDK server-side component benefits from having failover and database support" |
| Cloud or hybrid deployment | Not documented |

### C. Network
| Gap | Notes |
|---|---|
| **Proxy support** for any SDK surface | Not documented at all |
| Ports for Directory database (SQL Server), Server Admin web UI, Archiver, Genetec Server service | Not in the SDK doc set |
| Whether UDP 6000–6200 is configurable | Not stated |
| Complete list of ports for the Media Gateway beyond 654 / 80 / 443 | Not stated |

### D. Requirements & sizing
| Gap | Notes |
|---|---|
| **Hardware minimum/recommended** — CPU, RAM, disk for an SDK application host | Not documented |
| **GPU model, driver version, VRAM** for hardware-accelerated decoding | Not documented; only that acceleration exists from 5.9.1 and that `Genetec.Nvidia.dll` / `Genetec.QuickSync.dll` ship |
| Supported **Windows OS versions** | Not documented in the SDK doc set |
| Supported **SQL Server versions** | Not documented |
| **Sizing formulas** per camera / user / stream | Not documented. Only qualitative guidance (throttle to 2 exports, pool players, cap query results) |
| **Storage calculation and retention behaviour** for video archives | Not documented here (Archiver territory). Log retention defaults *are* documented |
| Browser support matrix detail for the Web Player | Named browsers only ("Firefox, Chrome, Edge, Safari, and Internet Explorer 11"), no versions; "Some features are not available for IE11" without saying which |

### E. Install & upgrade
| Gap | Notes |
|---|---|
| **Silent / unattended install switches**, MSI properties, command-line syntax | Not documented |
| **Rollback / downgrade procedure** | Not documented |
| **Backup and restore** procedure | Not documented |
| Exact supported upgrade paths between specific SDK builds | Only the three-major-version client compatibility rule and "run the installer for 5.14" |
| Which SDK versions ship with which Security Center installer | Not enumerated |

### F. Configuration
| Gap | Notes |
|---|---|
| **Valid ranges** for `logTarget` settings | Only sample/default values are given |
| The **advanced setting name** that enables the Access Manager `EventStream` table | Referenced but not named |
| A **write** API for advanced settings | Only read methods exist (5.13.3.0) |
| **LDAP** (direct), **SAML**, **OIDC/OAuth 2.0** configuration | Not documented. Only Active Directory and externally-obtained security tokens |
| Complete `ConfigTool.Modules.xml` schema | Only the one diagnostics module toggle is described |
| Whether a restart is required after editing `MediaGateway.gconfig` | Not stated (flagged `[INFERRED — verify]` in `operations.md`) |

### G. Operations
| Gap | Notes |
|---|---|
| **Service start/stop/restart commands** (`sc.exe`, `net`, PowerShell) and service short names | Not documented; only UI procedures |
| **Health-check endpoints** | None exist. The closest documented substitute is a browser GET to the Web SDK base URL expecting a sign-in prompt |
| **SNMP**, **syslog**, metrics endpoints | Not documented |
| Native outbound **webhooks** | Not documented; closest is HTTP requests from a macro, or event-to-action |
| **Database cleanup behaviour** for Directory and role databases | Not documented |
| Complete logger name catalogue | Docs say the list "is extensive" and name only the most pertinent ones |

### H. Logging & diagnostics
| Gap | Notes |
|---|---|
| **Default log file paths** for Security Center components (Directory, roles, client apps) | Not documented. Only *your* application's configurable `logFolder` and the `Logs` subfolder convention |
| **Support-bundle generation** utility | None documented. The manual equivalent is: zip a Wireshark capture with the `Logs` subfolder |
| Named diagnostic **utilities** shipped with the product | Only `WebSdkStudio`, `MacroStudio`, the Config Tool diagnostics module, Server Admin console/tracer, and `DiagnosticServer` |
| Log rotation behaviour details beyond the listed keys | Not documented |

### I. Errors & troubleshooting
| Gap | Notes |
|---|---|
| Complete **`SdkErrorCode`** enumeration returned by the Web SDK | Not enumerated; only the envelope shape and a few example messages |
| Complete **`StreamingConnectionStatus`** enumeration | Only 5 values named; the rest live in `gwp.d.ts` |
| Complete **`SdkError`** enumeration | Only the 5 values relevant to `CertificateRegistrationError` |
| **List of invalid characters for Custom Field names (Web SDK)** | The topic exists and states such characters exist, but the retrieved page body does not enumerate them |
| Numeric error codes | The SDK uses named enum values, not numbers, so there is nothing to tabulate |
| Security advisories for SDK 5.11 and 5.14 | Only the 5.12 and 5.13 "Security Updates" pages were retrieved |

### J. Integration
| Gap | Notes |
|---|---|
| **Rate limits** (requests/second) for the Web SDK | Not documented; only the 5-minute session idle rule and result caps |
| Consistent JSON MIME token | Docs use both `text/JSON` and `text/json`, and `application/jsonrequest` for the legacy path |
| Full `ReportType`, `EntityType`, `EventType` enumerations | These live in the Reference Guide (S2), which was confirmed accessible but not exhaustively extracted (2,426 topics) |
| Adjacent REST APIs (Operations Center, Principal, Identity, Location, Device, Case, Document Store, Vehicle/Fleet Monitoring, CAD Ingestion) and Clearance / ClearID / Curb Sense / Transaction Finder / Dispatch System Connector / RMS Connector guides | Catalogued but deliberately out of scope for this skill |

### K. Version history
| Gap | Notes |
|---|---|
| Service-release notes **5.11.1.0, 5.11.2.0, 5.11.3.0, 5.12.1.0, 5.13.1.0, 5.13.2.0** | Catalogued on the portal but not extracted |
| Third-party dependency versions for 5.11–5.13 | Only the 5.14.0.0 dependency list was retrieved |
| Resolved-issue lists for releases other than 5.14.0.0 | Not extracted |
| Release dates for any version | Not documented on these pages |

---

## 3. Internal documentation inconsistencies to be aware of

| Conflict | Detail | Recommendation |
|---|---|---|
| **Visual Studio minimum** | S1: "This requires Visual Studio 2017 or later." S3: "Visual Studio 2012 or higher". | Use the stricter 2017+ |
| **Install path examples** | `Project requirements` names `C:\Program Files (x86)\Genetec Security Center 5.12 SDK` inside the 5.14 guide | Treat the version number in path examples as illustrative |
| **JSON MIME token** | `text/JSON` vs `text/json` | Either appears to work; test |
| **Certificate list for Workspace components** | The "Adding Certificates" topic and the "SDK certificates for the Workspace SDK" topic give slightly different no-certificate lists (the latter omits `MapSearcher`/`MapObjectViewBuilder`, S11 adds "Content menu") | Union of the lists is in `install-upgrade.md` §4.5 |
| **ASP.NET expansion** | S1 glosses ASP.NET as "Archive Server Pages Network Enabled Technologies", which is not the real expansion | Ignore; a documentation error |
| **Legacy path in IIS sample** | Hard-codes `C:\Program Files (x86)\Genetec Security Center 5.X` | Use `GSC_SDK` instead, as the doc itself notes |

---

## 4. Items carrying `[INFERRED — verify]` in this skill

Only three statements in the whole skill are inferred rather than documented:

1. **Media Gateway restart after `MediaGateway.gconfig` edits** (`operations.md` §1) — the docs describe editing the file per agent but never state whether a restart is needed.
2. **Workaround for the pre-5.14 .NET Core 20-result deserialization bug** (`troubleshooting.md` §25) — the docs record the defect and its fix, but no workaround for people who cannot upgrade.
3. **Practical floor for Visual Studio version** — resolving the S1/S3 conflict in favour of 2017+ is a judgement call, not a documented statement.

---

## 5. Suggested retrieval paths

| Need | Route |
|---|---|
| Gated SDK/API pages | Sign in to developer.genetec.com as a DAP member |
| Part numbers, certificates, demo licences, solution listing | `DAP@genetec.com` |
| Media SDK / Extended SDK licence (NDA required) | `TechPartners@genetec.com` |
| Technical help with SDK code | Purchase a DAP technical assistance plan (Bronze / Silver / Gold) — assistance is **not** included with the free SDK package |
| Platform install, sizing, hardening, ports beyond SDK traffic, database maintenance | Security Center Administrator Guide, Installation and Upgrade Guide, Hardening Guide, System Requirements — Genetec TechDoc portal / GTAP |
| Licence validity problems | "open a regular Support Ticket to fix the license" |
| Video/media faults after exhausting the documented steps | Genetec Technical Assistance Center, with observations for your app + the MediaPlayer sample + Security Desk, a Wireshark capture, the `Logs` folder, and the version of every Genetec product on the machine |
| Full class/member reference | Security Center SDK Reference Guide 5.14 (S2) |
| Web Player full API and enums | `https://<MediaGatewayAddress>/v2/files/gwp.d.ts` |
| Code samples | `https://github.com/Genetec/Security-Center-SDK-Samples` (linked from S1) and the SDK package samples |
