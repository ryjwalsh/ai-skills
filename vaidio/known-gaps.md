# Vaidio - Known Gaps

Anything listed here was **not** answered by the sources in sources.md. Do not fill these from general knowledge. Retrieve them, then update the reference files.

## 1. Gated sources encountered

| Source | URL | Why it matters | How to retrieve |
|---|---|---|---|
| Vaidio Customer Support Portal | https://vaidio.myportallogin.com (register at https://www.vaidio.ai/support) | Formal release notes, per-release known issues and fixed defects, offline upgrade binaries (13+ GB), license keys, brand-specific NVR/VMS integration instructions, Nvidia offline driver bundles | Log in with a Google or Microsoft business email, or Sign up and activate via the email from DoNotReply@connectwise.com. Support tickets: Submit a Ticket > Licensing / Technical |
| Vaidio University | https://university.vaidio.ai/dashboard | Vaidio Technical Training, Fundamentals - likely contains architecture and troubleshooting detail not in the PDFs | Partner Portal credentials |
| Partner Portal (some areas) | https://www.vaidio.ai/partner-resources/homepage and Deals & Quotes | SKU/edition comparison and pricing tiers | Partner Portal login |
| Appliance Calculator | https://www.vaidio.ai/partner-resources/appliance-calculator-ivedaai | The actual sizing formulas (server and storage from camera sets and analytics) | Interactive tool - run it and record the formula inputs/outputs, or ask Vaidio SA for the underlying model |
| Storage Calculator | Referenced from the Privacy Protection section of the Core Setup Guide as being on the Partner Portal | Storage sizing including the Privacy Protection doubling factor | Partner Portal |
| profile*.bin and offline installer images | Google Drive links embedded in vendor PDFs | Required install artefacts | Obtain from Vaidio or an authorised partner; do not rely on the embedded Drive links |
| PowerModel-Core-8.2g2-Pro-3.4 | Google Drive link in the Upgrade guide | Required model upgrade artefact | Same as above |

## 2. Phase 2 checklist items the docs did not answer

### A. Product and licensing
- Edition / SKU names and feature deltas. Hardware SKUs (VSB-110 to VSB-630) are documented, but there is no software edition matrix (for example Standard vs Enterprise feature deltas). Licensing is per-analytic-channel, so 'editions' may not exist. **Not documented.**
- Formal **EOL and lifecycle policy**: no end-of-support dates, no supported-version window, no N-2 policy. Only 'quarterly releases' and the mandatory maintenance percentages are published. **Not documented.**
- Subscription versus perpetual options beyond the stated perpetual license plus annual maintenance. Vaidio Enterprise Manager licenses are term-based ('end of the configured term defined in the purchase order') but the term lengths are **not documented**.
- License file format details, node-locking mechanism, and what exactly is inside the .info file. **Not documented.**

### B. Architecture
- **Which DBMS Vaidio uses.** The guides refer to 'the Vaidio Database' on the system volume and to Vaidio Data 'Database Setting' credentials, but never name the engine or version. **Not documented.**
- Individual internal service or process names inside the container (only the container 'vaidio' and image family 'ainvr' are named). No systemd unit names for the analytics stack. **Not documented.**
- Inter-component protocols and ports between Main and Remote cluster members, and between a node and Command Center beyond 'default CC port is 7000'. **Not documented.**
- High availability: no active/passive or failover design is documented for Core. Command Center federation gives node independence and CC daily backups, and Vaidio Enterprise relies on Kubernetes plus Ceph, but there is no documented HA pair or clustering for the Core database. **Not documented.**
- Cloud deployment specifics (supported cloud SKUs, GPU instance types, marketplace images). The FAQ says Vaidio 'can also run in the cloud' and VE names AWS EKS, GKE, OKE and AKS, but there is no cloud deployment guide. **Not documented.**
- Gateway component in Vaidio Enterprise: named in the component-interaction diagram but not specified (software, ports, configuration). **Not documented.**

### C. Network
- SMTP port numbers, LDAP port default, and NTP port. Fields exist in the UI; no defaults are published.
- Ports used **between** cluster Main and Remote servers, and any ports needed for Vaidio Data to pull metadata from Core nodes. **Not documented.**
- Whether 18888 is TCP, UDP or both. The guide only says it is required by ONVIF auto discovery. **Not documented.**
- Proxy configuration: no proxy settings, environment variables or UI fields are documented; proxies are only mentioned as a possible cause of failure. **Not documented.**
- Outbound destinations and FQDNs that need allow-listing for online upgrade, model downloads, GenAI features and false-detection reporting (only ironyun.github.io is named). **Not documented.**
- Minimum TLS version, cipher suites, and certificate requirements beyond accepted file extensions. **Not documented.**

### D. Requirements and sizing
- Explicit **channels-per-GPU** tables for Core (Edge has a per-Jetson channel table, Core does not). The Appliance Calculator holds this. **Not documented in text.**
- Per-engine resource cost (relative GPU/CPU weight per analytic), other than Detail Extraction multipliers of 3x and 7x.
- A storage formula. Only worked examples are published, no per-camera-per-day metadata rate.
- Maximum cameras per Core server, maximum users per Core, and maximum concurrent Live View streams. **Not documented.**
- Database sizing or growth guidance. **Not documented.**
- Virtualisation support statement: the license request form asks whether a VM is used and names AWS and GCP, but there is no supported-hypervisor list or GPU passthrough guidance. **Not documented.**

### E. Install and upgrade
- **Rollback / downgrade procedure. Not documented anywhere.** Only configuration restore, container removal and Factory Reset exist.
- Silent or unattended switches for the APT path (the offline USB installer is the unattended mechanism, but there is no answer-file or preseed documentation, and no way to script an install with a pre-set IP or credentials). **Not documented.**
- Where the offline installer stores its autoinstall configuration, and whether it can be customised. **Not documented.**
- Air-gapped upgrade of the Docker image itself outside the Admin Portal offline flow. **Not documented.**
- Vaidio Data and Command Center **installation** procedures. Both guides describe post-install configuration only; the actual installers are not documented. **Not documented.**
- Vaidio Enterprise install detail: Kubernetes version, Ceph version, Helm charts or manifests, Vaidio Manager installation commands. **Not documented.**
- Whether upgrading from 9.x to 10.0 preserves the container_tool workflow, and what the 10.0 upgrade path looks like given the multi-container change. **Not documented.**

### F. Configuration
- Any configuration key not in /etc/vaidio/vaidio.conf. No application settings file, no environment variables, no CLI for application configuration. **Not documented.**
- Valid ranges for many UI settings (for example SMTP timeouts, camera FPS bounds beyond Manual 1-60 on Edge, S3 retry behaviour). Partially documented.
- **SAML** support. Only LDAP and OpenID Connect (Entra ID) are documented. Other OIDC providers (Okta, Google Workspace, Keycloak) are not mentioned. **Not documented.**
- LDAP over StartTLS, certificate pinning, and nested-group resolution behaviour. **Not documented.**
- Password complexity rules for Core (Command Center publishes 8-128 characters with mixed case and a number; Core only says 'strong password requirements'). **Not documented for Core.**
- Role-based permission list at field granularity, and whether custom roles beyond Admin / Co-Admin / User exist. Partially documented.

### G. Operations
- **A health-check endpoint or API** for Core. Vaidio Data serves /docs but that is documentation, not a probe. **Not documented.**
- **SNMP and syslog** support. **Not documented.**
- Any metrics endpoint (Prometheus, StatsD). **Not documented.**
- Automated or scheduled configuration backup for Core itself (Command Center can back up node configuration daily; Core has manual Export Configuration only). **Not documented.**
- Database maintenance operations (vacuum, reindex, integrity check). **Not documented.**
- Documented restart order for a cluster, and safe maintenance-window procedure. **Not documented.**

### H. Logging and diagnostics
- Log paths **inside** the container, and any per-component log files. Only /opt/data/sys/vaidio/log/app/start_service.log is named. **Not documented.**
- Verbosity or debug-mode toggles, and log-level configuration. The UI filters by severity but no log level is settable. **Not documented.**
- Log rotation settings and on-disk log size limits. **Not documented.**
- A single support-bundle command. Does not exist; the equivalent is a manual collection (see references/operations.md).
- How to decrypt or interpret the Diagnostic log locally - it is encrypted and intended only for Vaidio Support. **By design.**

### I. Errors and troubleshooting
- **A numbered error-code catalogue does not exist publicly.** references/error-codes.md is a catalogue of verbatim message strings instead.
- Per-release known-issues and fixed-defect lists. Only inferable from guide notes and press releases. **Gated in the Support Portal.**
- Troubleshooting for Vaidio Data and Vaidio Enterprise. Neither guide has a troubleshooting section beyond Export Log / Export Diagnostic Log and Recreate Core. **Not documented.**

### J. Integration
- **Core REST API specification**: base path, endpoints, request and response schemas, HTTP status codes, pagination, versioning. Only the API key mechanism is documented. **Not documented.**
- **API rate limits.** **Not documented.**
- **SDK availability** in any language. **Not documented.**
- Inbound webhooks or event subscriptions (Vaidio receiving events). **Not documented** - triggers are outbound only.
- Streaming metadata export (Kafka, MQTT, gRPC, Milestone Analytics Events and similar). **Not documented.**
- The Vaidio Data API endpoint list (self-served at /docs on a running instance, so retrievable only from a live system).
- Vaidio Enterprise Manager API for image and version-tag management: referenced but not specified. **Not documented.**

### K. Version history
- Formal release notes for every version. Only five press releases (9.0, 9.1, 9.2, 9.3, 10.0) plus in-guide version notes were available. Releases 4.2.0, 5.0, 5.1, 5.4, 6.2, 7.0 and 7.1 have blog posts that were **not** retrieved in this pass.
- Vaidio 10.0 administration, installation, ports and configuration. **No 10.0 guide was published at the docs root at retrieval time** - this is the single largest gap.

## 3. Vendor documents inventoried but not text-extracted in this pass

All are linked from https://www.vaidio.ai/partner-resources/vaidio/user-guides and are ungated, so they can be retrieved later without credentials.

Applications and tools: Vaidio DIY Labeling Tool User Guide; Parking Management Application User Guide.

Analytic engine guides: Container ID; Person Cross Camera Tracking; Crowd Detection; Face Recognition; PS Face Grouping; Intrusion Detection; License Plate Recognition; Natural Language Enhancement; Object Left Behind; Object Tracking; Object Detection; Person Fall; Personal Protective Equipment; QR Code Detection; Scene Change Detection; Specialized Object; Smoke & Fire; Vaidio City - Traffic Management; Vehicle Cross Camera Tracking; Vehicle Make & Model Recognition.

Edge guides: Edge Container ID; Edge Intrusion; Edge License Plate Recognition; Edge Face Recognition. (Tunable Edge was extracted.)

Older versioned PDFs also present at the docs root: Vaidio 7.2.0 Edge PS Object Tracking; Vaidio 7.3.0 Edge Face Recognition User Guide; Vaidio 7.1.0 Vehicle Tracking User Guide; Vaidio 7.0.0 Video Search User Guide.

Impact: per-engine tuning parameters, per-engine ROI rules, list management for FR and LPR, and Traffic Management (Vaidio City) configuration are therefore **thin** in this skill. Retrieve the relevant engine guide before answering detailed per-engine tuning questions.

## 4. Documentation inconsistencies to resolve with the vendor

| Inconsistency | Detail | Where |
|---|---|---|
| NVIDIA driver version | 535.183.06 (install guide, online upgrade slide, offline driver procedure) versus 535.138.06 (offline Main System upgrade slide) | S1 vs S2 |
| Alert Cooldown Interval range | 10-3,600 seconds (Setup Guide) versus 0-3,600 seconds (Core Functions Guide) | S4 vs S13 |
| Pixels on target | 'at least 10 px on target (e.g. 14 ppf for person)' versus 'Vaidio needs only 20 pixels on target' | S3 (two slides) |
| Server role capability matrix | Standalone and Main are marked as not supporting Video Page / Video Filters / FR-LPR list editing, which is counter-intuitive for a standalone deployment | S4 |
| Hardware recommendation version label | The table inside the 9.3.0 install guide is titled 'Vaidio v9.1.0 Hardware Specifications Recommendation (10/30/2025)' | S1 |
| Vaidio Data guide version | Vaidio Data guide is 9.2.0 while Core guides are 9.3.0, so some Data behaviour may already have changed | S10 vs S4 |
| Command Center guide version | CC guide is 9.2.0 while 10.0 claims new CC global search, live view and playback | S12 vs S16 |
| Edge trigger parameter vocabulary | Edge uses {eventimage}; Core 9.3.0 documents the {alertImage*} family. Whether {eventimage} is still valid on Core is unclear | S15 vs S8 |

## 5. Suggested retrieval order to close the biggest gaps

1. Support Portal: request the **Vaidio 10.0 administration and installation guide** plus formal 10.0 release notes.
2. Support Portal: request the **Core REST API reference** (endpoints, auth, rate limits) and confirm whether an SDK exists.
3. Support Portal or SA: ask for the **EOL / supported-version policy** and the DBMS in use.
4. Partner Portal: run the **Appliance Calculator** and **Storage Calculator** and record the sizing model, including channels per GPU.
5. Support Portal: ask for **Vaidio Data and Command Center installation guides** (not just configuration).
6. Support Portal: ask for the **Vaidio Enterprise deployment guide** (Kubernetes and Ceph versions, Manager install steps, Gateway spec).
7. Vendor TAC: confirm the driver-version and cooldown-range inconsistencies in section 4.
8. Public docs root: extract the remaining analytic-engine and Edge PDFs listed in section 3.
