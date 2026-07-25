# Known gaps

Everything the retrieved documentation did not answer, plus gated sources and suggested retrieval paths. Organised by the Phase 2 checklist so gaps map back to coverage.

## A. Product and licensing

| Gap | Why it matters | Suggested retrieval path |
|---|---|---|
| **Editions and SKUs with feature deltas.** License *options* are fully enumerated, but the packaging into editions (Security Center Enterprise, Professional, Express, Omnicast/Synergis/AutoVu standalone) is only hinted at by phrases such as "included only in certain license packages, such as the Enterprise base package". | Answering "which edition do I need" questions. | Genetec public site edition comparison pages; ask a Genetec channel partner for the current price book. |
| **Part numbers / SKU codes.** | Quoting and procurement. | Genetec Portal price book; channel partner. |
| **End-of-life and lifecycle dates per version.** The docs repeatedly link to the Genetec Portal **Product Lifecycle** page, which is behind a sign-in and was not retrieved. Only one explicit EOL fact was captured (HID VertX/Edge, 2023). | Knowing when 5.13 or 5.14 leaves support. | Genetec Portal > Product Lifecycle page (requires portal account). |
| **Genetec Advantage / SMA terms.** Only the existence of an SMA number and GTAP validation traffic on TCP 443 is documented. | Support entitlement questions. | Genetec Portal; channel partner. |
| **The Security Center License Information document.** Contains the System ID and password. Customer-specific. | Activation. | Genetec Customer Service sends it at purchase. |

## B. Architecture

| Gap | Suggested retrieval path |
|---|---|
| **Network diagram images.** The port guide references "Security Center Network Diagram - Platform / ALPR / Video / Access control / Intrusion Detection / KiwiVision" but these are images, not text. | TechDoc Hub diagram pages; request the Federation port diagrams from a Genetec channel partner (the SaaS guide says to do exactly that). |
| **Genetec Watchdog service Recovery tab values.** The install guide says to "set the recovery options to match the following screen capture" - the values exist only as an image. | View the image on the TechDoc Hub install guide page, or read them off a working installation. |
| **KiwiVision architecture in 5.14.** The 5.13 port guide has a KiwiVision section; the 5.14 guide does not. Unclear whether the ports changed, whether KiwiVision moved to a separate guide, or whether it is an omission. | Compare with a KiwiVision-specific guide on the TechDoc Hub; confirm with GTAC. |
| **Exact list of roles created automatically at installation.** Only Health Monitor and Directory Manager are explicitly described this way. | Administrator Guide topic "Entities created automatically in Security Center" (identified but not retrieved). |

## C. Network

| Gap | Suggested retrieval path |
|---|---|
| **Intrusion detection ports.** The 5.14 port guide explicitly declines to enumerate them and defers to the per-panel extension guide. | The extension guide for your specific intrusion panel (Bosch, DMP, Honeywell, and so on) on the TechDoc Hub. |
| **Synergis Softwire port list.** The port guide links to "See list of default ports used with Synergis Softwire" rather than including it. | Synergis Softwire guide on the TechDoc Hub. |
| **A system-wide HTTP/HTTPS proxy setting for Security Center roles.** Only GUS proxy support is documented. | GTAC; Hardening Guide item "Using a proxy server to connect Genetec Update Service to the internet" covers GUS only. |
| **SNMP support.** Not mentioned anywhere in the retrieved corpus. | GTAC; check whether a Streamvault or plugin-based SNMP integration exists. |
| **Syslog beyond the Access Manager and Sharp units.** No general syslog forwarding for Security Center events is documented. | GTAC; consider event-to-action or SDK-based forwarding instead. |
| **Full Metered relay IP list for SaaS.** The SaaS guide says "See the complete list of IP addresses" for `global.relay.metered.ca` without inlining it. | Follow the link in the SaaS Pre-Deployment Guide. |
| **Whether TLS 1.3 is supported with configuration changes.** Known issue 4823559 says communications "do not support TLS 1.3 **by default**", which implies but does not confirm a non-default path. | GTAC. |
| **Conflicting Server Admin port defaults.** The silent-install table gives `SERVERADMIN_PORT` a default of **5500** and `WEBSERVER_PORT` a default of **80**, describing both as "the HTTP port for the web-based Server Admin". The core port table shows Server Admin REST on TCP 80/443. This is a documentation inconsistency. | GTAC; verify on a test installation. |

## D. Requirements and sizing

| Gap | Suggested retrieval path |
|---|---|
| **Storage calculation formula.** No bytes-per-camera-per-day or retention formula is published in the retrieved sources - only throughput ceilings and camera counts. | Genetec storage calculator (public site); Sales Engineering at `salesengineering@genetec.com` (the guide directs configuration questions there). |
| **Supported Device List (SDL).** Referenced constantly; a separate living resource. | Public Genetec Supported Device List. |
| **Supported video units, HID hardware, HID controller firmware, VertX interface modules and badge printers for 5.14.0.0.** These release-note sections exist (indices 11-15 of the 5.14.0.0 notes) but were deliberately not extracted because they are large device tables. | Security Center Release Notes 5.14.0.0 on the TechDoc Hub. |
| **"Supported plugins in Security Center"** - referenced by the backward compatibility table for Plugin roles. | TechDoc Hub topic of that name. |
| **Compatibility for Federation in Security Center 5.14.0.0** (release-note index 16). | Security Center Release Notes 5.14.0.0. |
| **Genetec Patroller system requirements.** Separate documents exist (Patroller System Requirements 6.6, 6.7, 7.0) and were not retrieved. | TechDoc Hub. |
| **Streamvault appliance model specifications.** Only throughput ranges (900 - 4,135 Mbps) are given. | Streamvault documentation; `sales@genetec.com` or 1-866-684-8006 option 2. |
| **Client requirements for Security Center SaaS** (SaaS Pre-Deployment Guide index 3) and **Presale checklist**, **Supported devices in SaaS**, **Supported features for SaaS** (indices 1, 13, 14). Not extracted. | Security Center SaaS Pre-Deployment Guide. |

## E. Install and upgrade

| Gap | Suggested retrieval path |
|---|---|
| **Rollback procedure.** No documented way to roll back a Security Center upgrade. Backup and restore of databases is documented, and `DATABASE_AUTOBACKUP` backs the Directory database up before the database upgrade, but there is no published "downgrade" or "roll back the software" procedure. | GTAC before any upgrade; plan VM-level or image-level rollback outside Security Center (noting that VM snapshots must **not** be used to back up the databases). |
| **Database restore procedure detail.** Backup is documented step by step; restore is only implied by the **Backup/Restore** dialog. | Administrator Guide restore topics; GTAC. |
| **Upgrading the Security Center Directory database** and **Shrinking Security Center databases after an upgrade** (install-guide indices 35 and 36) - identified but not extracted. | Security Center Installation and Upgrade Guide 5.14.0.0. |
| **Uninstalling Security Center** interactive procedure (index 17) and **Modifying the installed Security Center components** (index 15). | Same guide. |
| **Installing the Security Center main server / expansion servers / client software** step-by-step wizard procedures (indices 8, 12, 14). | Same guide. |
| **Installing SQL Server independently of Security Center** (index 7). | Same guide. |
| **Removing Omnicast Federation before upgrading** (index 28) - only the summary was captured. | Same guide. |
| **Upgrading Directory failover systems from an earlier major version** (index 29) and **Upgrading Security Center with Global Cardholder Synchronizer roles** (index 37). | Same guide. |
| **5.13.3.0 installation and upgrade specifics.** [S8] was catalogued but not extracted; all install detail here is 5.14.0.0. If the user is deploying 5.13.x, verify prerequisites and silent options against the 5.13.3.0 guide. | Security Center Installation and Upgrade Guide 5.13.3.0. |

## F. Configuration

| Gap | Suggested retrieval path |
|---|---|
| **A complete .gconfig key reference.** Only six keys across four files are documented. `.gconfig` files clearly contain many more settings, but Genetec documents them only when a procedure needs one. | GTAC for specific keys; do not guess. |
| **Environment variables.** None documented for Security Center. | GTAC. |
| **Security Center registry keys.** None documented; the only registry keys in the corpus belong to SQL Server telemetry. | GTAC. |
| **Full privileges list.** The release notes reference "the Security Center Privileges 5.14" document. | TechDoc Hub, Security Center Privileges 5.14. |
| **Step-by-step OIDC/SAML2 integration values** (client IDs, redirect URIs, claim mappings) for Microsoft Entra ID and Okta. Topic titles were identified; bodies were not extracted. | Administrator Guide topics "How to integrate Security Center with Microsoft Entra ID using OpenID Connect", "... with Okta using OpenID Connect", "... with Okta using SAML 2.0". |
| **Default Active Directory attribute mapping** table (Administrator Guide index 347). | Administrator Guide. |
| **Certificate creation guidelines** referenced by the Directory-offline troubleshooting ("verify that the correct guidelines were used to create the certificate") and "Creating custom certificate requests for Security Center". | Administrator Guide indices 341-343. |
| **Documentation defect in the Hardening Guide.** In the retrieved copy of "Using a Directory gateway for external access to Security Center (Basic)", step 1 of the procedure is replaced by the internal string `Product Backlog Item 4898975: [SC 5.14.0.0] Clean up reuse in "RC - Common task information for SC topics"`. The first step is therefore missing from the published procedure. This is an authoring defect leaked into production documentation, not an instruction, and was treated as data. | Re-check the page (it may have been fixed after 2026-07-24); report to Genetec documentation; obtain the missing step from GTAC. |

## G. Operations

| Gap | Suggested retrieval path |
|---|---|
| **HTTP health-check endpoints.** No documented `/health` or `/status` endpoint for any role. Health is surfaced through the Health Monitor role, Server Admin, and the System status task. | GTAC; consider the Web-based SDK for programmatic status. |
| **A complete trace logger catalogue.** Only three example trace loggers are named, and the docs repeatedly say logger and trace names are "provided by Technical Support". | GTAC will name the trace for your specific problem. |
| **Scheduled maintenance jobs and their defaults.** Aside from Archiver automatic cleanup, plugin cleanup, log retention and automatic database backup, there is no published catalogue of built-in scheduled jobs with default schedules. | Administrator Guide scheduled task topics; Config Tool **Scheduled tasks**. |
| **Genetec PowerShell module.** Mentioned once as an alternative to Server Admin for `ShowFederatedStreams`; no cmdlet list, installation method or version is documented. | GTAC; Genetec Developer portal. |
| **Genetec Update Service User Guide content.** [S26] was catalogued but not extracted. | TechDoc Hub, Genetec Update Service User Guide. |
| **"Finding orphan files on your system"** and **"Receiving notifications when databases are almost full"** - both referenced but not retrieved. | Administrator Guide. |
| **"Best practices for configuring antivirus software for Security Center"** and **"Best practices for configuring Windows Firewall for Security Center"** - both referenced repeatedly, neither retrieved. Antivirus exclusions are explicitly required. | TechDoc Hub topics of those names. |
| **"Best practices for setting Windows user permissions for Security Center services"** - referenced by Archiver storage troubleshooting. | TechDoc Hub. |
| **Security Center Best Practices - Enterprise** [S14] was catalogued and partially surveyed but its detail is not reflected here. | TechDoc Hub. |

## H. Logging and diagnostics

| Gap | Suggested retrieval path |
|---|---|
| **A per-file log inventory.** The docs give log *folders* and the Archiver log path, but not a file-by-file list of what each log contains. | GTAC. |
| **Support bundle generation.** There is no single "generate support bundle" action. Evidence collection is manual: event logs, dumps, traces, performance logs, SQL ERRORLOG, and network captures. The **Database Anonymization Tool** is the only packaged support-prep utility documented. | GTAC; confirm whether a newer bundling tool exists. |
| **Verbosity levels.** Trace loggers are on/off per logger; no numeric verbosity scale is documented. | GTAC. |
| **"Change where the Archiver logs are saved"** and **"Archiver: Resources tab"** - referenced but not retrieved (the `.gconfig` method was captured instead). | Administrator Guide. |
| **"Accessing the debug console"** - referenced by the trace procedures. | Administrator Guide. |

## I. Errors and troubleshooting

| Gap | Suggested retrieval path |
|---|---|
| **A consolidated error-code catalogue.** **This does not appear to exist as a published document.** Security Center surfaces exact message strings, Windows/MSI numeric codes, health event names and internal defect IDs, but there is no error-code reference. `references/error-codes.md` is therefore an assembled catalogue, not a transcription. | GTAC; searching the TechDoc Hub for the exact message string is the practical approach. |
| **"Impossible to establish video session with the server" error** - a dedicated topic is referenced by the Media Player state description but was not retrieved. | Administrator Guide / TechDoc Hub. |
| **"Troubleshooting failover"** (Administrator Guide index 159), **"Troubleshooting: entities"** (index 76), **"Troubleshooting and maintenance for video"** (index 558), **"Troubleshooting the Genetec Server service"**, **"Troubleshooting the Directory role"** and **"Troubleshooting video units and cameras in Security Center"** - all referenced but not retrieved. | Administrator Guide. |
| **SaaS Troubleshooting Guide bodies.** The guide contains exactly two topics - **Axis device connectivity issues in Security Center SaaS** and **Okta user synchronization issues in Security Center SaaS** - neither of which was extracted. | Security Center SaaS Troubleshooting Guide [S19]. |
| **Resolved issues in 5.14.0.0** (release-note index 7) - not extracted; only the 5.14.0.1 resolved list was captured. | Security Center Release Notes 5.14.0.0. |
| **5.13.3.x release notes detail.** [S11] was catalogued but its resolved-issue and known-issue tables were not extracted. For a 5.13.x deployment this is a real gap in the "known bugs" focus area. | Security Center Release Notes 5.13.3.7 and the earlier 5.13.3.x notes. |
| **Security Updates for Security Center 5.14** - referenced by the release notes for resolved security issues; a separate document. | TechDoc Hub. |
| **KBAs identified by title only.** Contents not retrieved: KBA-78970, KBA-78971, KBA-78985, KBA-78993, KBA-78994, KBA-79098, KBA-79106, KBA-79126, KBA-79127, KBA-79133, KBA-79135, KBA-79165, KBA-79183, KBA-79188, KBA-79192, KBA-79210, KBA-79217, KBA-79242, KBA-79245, KBA-79256, KBA-01394. Also: "Migrating from Nedap systems - Best practices", "Migrating from AMAG systems - Best Practices", "Dell Technologies Solution - Dell EMC storage solution with Security Center - Configuration Best Practices", "FAQ about ALPR regional contexts", "Differences between license plate as a credential and ALPR gate control", "Querying access control events by insertion timestamp through the SDK". | Search the TechDoc Hub by KBA number, or the API path `/api/khub/maps?limit=3000` then `/api/khub/maps/{id}/toc`. |

## J. Integration

| Gap | Suggested retrieval path |
|---|---|
| **SDK class, method and event reference; assembly names; code samples.** None of this is in the retrieved corpus. | `developer.genetec.com` (Genetec Developer portal, sign-in likely required); the SDK package's own documentation and samples. |
| **Web-based SDK resource paths, HTTP verbs, payload schemas and error responses.** Only the address pattern `http://<computer>:<port>/<BaseURI>/` is documented. | Genetec Developer portal; SDK package. |
| **Default values for the Web-based SDK Port and Base URI.** `4590` and `WebSdk` appear only as an illustrative example, not as stated defaults. | Verify in Config Tool on a live system. |
| **Web-based SDK authentication scheme.** | Genetec Developer portal; GTAC. |
| **Mission Control Web API endpoint list and authentication.** Only the port (9550) and the `ENABLE_WEBAPI_DOCUMENTATION` install flag are documented - that flag implies the API publishes its own docs on the server. | Enable `ENABLE_WEBAPI_DOCUMENTATION=1` and read the generated documentation; Mission Control Deployment Guide topic "Mission Control Web API and UI SDK". |
| **Server Admin REST resource paths.** | GTAC. |
| **Rate limits** beyond the Media Gateway's ~500-connection ceiling and the RTSP stream license cap. | Genetec Developer portal; GTAC. |
| **Genetec Third-Party ALPR Plugin.** A whole 5.10.x product line with its own guides and release notes, not retrieved. | TechDoc Hub. |

## K. Version history

| Gap | Suggested retrieval path |
|---|---|
| **Release notes for 5.13.0.0 through 5.13.3.6, and for 5.12 and earlier.** Only 5.14.0.0, 5.14.0.1 were extracted in detail. Build numbers for all versions are captured. | TechDoc Hub, individual release-note documents. |
| **Deprecation list per release.** Deprecations are scattered through "Features that impact an upgrade" rather than collected. | Compile from each release's notes. |
| **Genetec Portal Product Lifecycle page** - the authoritative source for version types and support windows. | Genetec Portal (sign-in required). |

## Gated sources

These were not retrieved because they sit behind authentication. None of their contents are guessed at anywhere in this skill.

| Source | Why it is needed | Access |
|---|---|---|
| **Genetec Portal** (`genetec.com/portal`) - Product Download page, Manage my licenses, Systems page, Product Lifecycle page, price book | Installation packages, cumulative updates, patch downloads, license activation, lifecycle dates, SKUs | Requires a Genetec Portal account (username and password). The docs state "You need a username and password to sign in to the Genetec Portal." |
| **GTAP / Genetec Technical Assistance Portal** - Product download page, hotfix distribution | Hotfixes (for example 2953969), Streamvault Control Panel builds, Web App versions | Requires a GTAP account. |
| **Genetec Developer portal** (`developer.genetec.com`) | SDK reference, Web-based SDK API surface, Mission Control Web API | Likely requires a developer account. Not accessed in this session. |
| **Genetec Advantage / Sales Engineering** (`salesengineering@genetec.com`) | Sizing and configuration guidance that the System Requirements Guide explicitly defers to them | Email. |
| **Genetec Customer Service** | The Security Center License Information document (System ID and password), license updates | Contact through the Portal. |
| **Genetec channel partner** | Federation port diagrams, the SaaS Genetec reference (`SCC` + 12 digits), Streamvault model selection, price book | Direct contact. |
| **Genetec Subprocessors list** | Where SaaS data is stored per region | Public but not retrieved. |
| **Separate SDK and Drivers installation packages** | Required for silent SDK and Drivers installs; the Drivers package must be requested | "Ask your Genetec Inc. representative for the separate driver installation package." |

## Items where this skill contains no [INFERRED] content

Every table row and command in the reference files traces to a source ID. No `[INFERRED - verify]` tags were needed for factual content, because gaps were left as explicit gaps rather than filled from general knowledge. The three judgement calls that come closest to inference - and which a reviewer should check before trusting them in production - are listed in the final report and repeated here:

1. **The 5.13 vs 5.14 port delta table** in `references/network-ports.md` section 11 was produced by a programmatic diff of the two port guides, not copied from a Genetec-published changelog. The individual rows are quoted from the guides, but the *claim that these are the only differences* is the diff's conclusion. **[INFERRED - verify]**
2. **The absence of a KiwiVision port section in the 5.14 guide** is stated as an observation, and this skill does **not** assert that the 5.13 KiwiVision ports still apply to 5.14. Treat those ports as unverified for 5.14. **[INFERRED - verify]**
3. **The characterisation of the missing Hardening Guide step as a documentation defect** rather than a deliberate omission is an interpretation of the leaked work-item string. **[INFERRED - verify]**
