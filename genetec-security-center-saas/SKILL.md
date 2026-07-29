hello
world test 123---
name: genetec-security-center-saas
description: Comprehensive knowledge of Genetec Security Center SaaS, the unified hybrid-cloud physical security platform - architecture, data centre regions, pre-deployment requirements, firewall ports and cloud endpoints, user management with SSO and SCIM provisioning, device onboarding (Axis/Bosch/Hanwha/i-PRO direct-to-cloud, Genetec Cloudlink, Synergis Cloud Link, Axis Powered by Genetec, Mercury controllers, Bosch and Honeywell Galaxy intrusion panels), recording profiles and video, system automation and threat levels, Map designer, operator tasks, Genetec ClearID visitor management, Federation and reverse tunneling, Cloudlink appliance hardware, and troubleshooting. Use whenever Security Center SaaS, SC SaaS, Genetec Cloudlink, Genetec Configuration desktop, Genetec Operation desktop, Synergis Softwire on Cloudlink, Genetec Edge OS, ClearID, securitycentersaas.genetec.cloud or "SaaS Edition (Classic)" are mentioned.
---

# Genetec Security Center SaaS

Security Center SaaS is Genetec's unified hybrid-cloud physical security service. It combines video, access control, intrusion, intercom and visitor management, and it can run workloads on premises (on Genetec Cloudlink appliances and other edge devices), in the Genetec cloud, or across both. Administrators and operators reach the system through a browser, two Windows desktop clients, and a mobile app. [S1] [S6]

## Coverage and currency

> Built from the Security Center SaaS documentation portal on **techdocs.genetec.com/p/security-center-saas**, retrieved **2026-07-29**. Source guides carried edition dates up to **2026-07-24**. Cloud services change without version numbers, so treat endpoint lists, feature-plan boundaries and device maxima as point-in-time and re-verify before you commit a design.

**Do not confuse the two products.** *Security Center SaaS* is the current cloud-native offering. *Security Center SaaS Edition (Classic)* is the older hosted-Security-Center offering; several KB articles and the cipher-suite change notice apply only to Classic. Ask which one the user runs before answering. [S12] [S13] [S14] [S15] [S16] [S17]

## Quick facts

| Item | Value | Src |
|---|---|---|
| Sign-in entry point | securitycentersaas.genetec.cloud - redirects to the regional host | S6 |
| Regional hosts | au. / ca. / eu. / uk. / us. .securitycentersaas.genetec.cloud (Australia, Canada, Europe, United Kingdom, United States) | S2 |
| Identity provider | Genetec SSO at login.genetec.com; every user needs a login.genetec.com account. Self-service password and MFA changes at login.genetec.com/profile | S1 S6 |
| Clients | Security Center SaaS web client; Genetec Configuration desktop (full admin, Map designer, Automation); Genetec Operation desktop (dashboards, people counting, activity trails); SC SaaS Operation mobile | S6 |
| Roles | Owner, Administrator, Operator, Front desk. Owner grants/removes Owner and accepts terms | S6 |
| Plans | Standard and Premium. Premium is required for intelligent search, visual trajectory and automatic user provisioning (SCIM) | S6 S11 |
| Latency requirement | 150 ms or less to the nearest Azure data centre is mandatory; 99.9% ISP SLA strongly recommended | S2 |
| Plugin integrations | Not supported | S2 |
| Federated video | H.264 only. H.265/AV1 federated streams need an NVIDIA GPU or 11th-gen-or-newer Intel Quick Sync plus current Chrome or Edge | S2 |
| Reverse tunnel port | Outbound TCP 5500 from the on-premises Directory to `*.gsc-cloud.com` | S2 S10 |
| Max video retention | 1,096 days (3 years) | S6 |
| Recording profiles | Up to 37 custom profiles in addition to the default cloud, appliance and edge profiles | S6 |
| Appliance family | Genetec Cloudlink 110, 210, 310, 2210, all on Genetec Edge OS (Linux) | S3 S4 S18 S19 S20 |
| Appliance portal | https://<hostname-or-ip>, user `admin`, first password on the pull tab / label (self-signed certificate) | S18 S19 S20 |
| Genetec reference | Format SCC followed by 12 digits, e.g. SCC-232136-654353; used in `{GenetecReference}.gsc-cloud.com` endpoints. Obtain it from the channel partner | S2 |
| System ID | e.g. SCC-200012-345678, shown in the License section of the About page in Genetec Configuration desktop | S6 |
| Service status | status.genetec.com, with a 90-day incident log and subscribable notifications | S21 |
| Supported devices | Security Center SaaS Supported Device List (SDL); the SDL Feature Matrix records per-device capabilities such as PTZ and timeline thumbnails | S2 S22 |

## Where to look

| If the question is about... | Open |
|---|---|
| What the product is, clients, hybrid topology, WebRTC, data-centre regions, Clearance sharing, plan differences | `references/architecture.md` |
| Presale checklist, network and workstation requirements, every firewall port and cloud endpoint, regional endpoint patterns | `references/requirements-and-ports.md` |
| Users, groups, roles, privileges, access rights, partitions, sign-in and operation settings, watermarking, corporate SSO, SCIM provisioning with Entra ID or Okta, MFA | `references/users-and-authentication.md` |
| Adding cameras and intercoms, direct-to-cloud onboarding per manufacturer, recording profiles, edge recording, dewarping, read-only cameras, analytics events and metadata, firmware updates and maintenance windows | `references/devices-and-video.md` |
| Cloudlink 110/210/310/2210 hardware, device and throughput maxima, appliance portal tasks, static IP, isolated networks, HTTP proxy, NTP, factory reset, touchscreen, spot monitor, Synergis Cloud Link enrollment | `references/appliances-cloudlink.md` |
| Cardholders, visitors, credentials, cardholder groups, access rules, Axis Powered by Genetec, Mercury controllers on Cloudlink, the Synergis Softwire portal, OSDP, MR51e/MR62e, Mercury triggers and procedures, automation engine | `references/access-control.md` |
| Genetec Intrusion Protocol architecture, Bosch and Honeywell Galaxy panels, intrusion areas, inputs, outputs, virtual alarms, cardholders on panels, network isolation best practice | `references/intrusion.md` |
| Events, custom events, schedules (daily/weekly/ordinal/specific/twilight), automation entities, triggers and responses, threat levels, Map designer, map objects, Map Manager providers | `references/automation-and-maps.md` |
| Operator work: Tiles, Maps, Investigation and intelligent search, Front desk, Reports, Access control task, voice/video calling, alarms, hot actions, watchlist, exporting and sharing video | `references/operations-tasks.md` |
| ClearID in Security Center SaaS: sites, areas, visit profiles, request workflows, watchlists, Self-Service Kiosk, identity synchronisation (API, SCIM, One Identity), webhooks, ClearID ports | `references/clearid.md` |
| Federation in both directions and reverse tunneling | `references/federation.md` |
| A symptom, an Axis or Okta failure, a KBA number, known issues and limitations, the Classic cipher-suite change | `references/troubleshooting-and-kbs.md` |
| "Which guide covers X?" - the complete topic map of the portal with deep links | `references/topic-index.md` |
| What the documentation does not answer | `known-gaps.md` |

Source IDs used throughout the reference files are defined in `sources.md`.

## Five flows that come up most

### 1. Commissioning a new system [S6]

Learn the product, then check the presale checklist, network requirements, ports and the SDL. The partner reviews requirements, builds a quote and places the order; the system is then activated. The end-user system administrator named on the order **must sign in and accept the Terms of Service first** - until they do, every other assigned user is locked out. Additional access is granted from the **Access** page of the target system in the System Management portal. Then create users and apply roles, create groups for inherited permissions, add devices, and turn on timeline thumbnails, camera analytics events and camera metadata where wanted. Local devices are only discoverable when the appliance sits on the same local network as the device.

### 2. Enrolling a Genetec Cloudlink appliance [S6] [S18]

Power the appliance and connect Ethernet port 1. If DHCP is unavailable, set a static IP from the appliance portal (or the touchscreen on a 210/2210 smart bezel). In the web client go to **Configuration > Devices > Add device > Appliance**, then either scan the QR code or type the serial number and activation code from the insert card. Name it. Time zone is owned by Security Center SaaS - enrolling makes the appliance-portal time-zone field read-only. Afterwards add cameras by automatic discovery or manually; cameras must be on the same subnet as the appliance.

### 3. A device will not come online [S23] [S2]

Confirm the model and firmware are on the SDL, then work outward: physical link, DNS resolution, then each required outbound endpoint and port for the right region. Axis devices expose two useful self-tests from the device web page - `/axis-cgi/pingtest.cgi?ip=<endpoint>` and `/axis-cgi/tcptest.cgi?address=<endpoint>&port=<port>`. Deep-packet-inspection firewalls and zero-trust proxies are a common cause. If device credentials fail on an Axis unit, the rescue account is user `DMrescue` (case sensitive) with the device Owner Authentication Key as the password. Devices previously enrolled elsewhere must be factory reset first.

### 4. Federating an on-premises Security Center into SaaS [S10]

SaaS is the Federation host, so **reverse tunneling is required**. On the host, add a reverse tunnel per remote site under **System > Roles > Reverse Tunnel Server** and export the keyfile. At the remote site create a **Reverse Tunnel** role and supply the keyfile - keyfiles are single-use. Then set the Security Center Federation role's **Directory** field to `directory.<sitename>.tunnel.genetec.com`. Encryption is required by default, and fusion-stream-encrypted video cannot be played in the SaaS web client or the mobile app. Federating the other direction (SaaS into on-premises Security Center) uses generated Federation-user credentials instead and no tunnel.

### 5. Users cannot sign in after an identity change [S6] [S24]

Check, in order: the administrator has accepted the Terms of Service; the user or their group has a role assigned (SCIM-provisioned groups show `SCIM provisioning` in the Source column and are flagged with a yellow dot until a role is set); the account exists at login.genetec.com; and, for Okta, the application assignment and system log outcome filters. Users moving to corporate SSO must complete a one-time transfer, confirming the change and entering a code sent to their original Genetec email.

## Working rules for this skill

- Facts trace to the source IDs in `sources.md`. Anything marked **[INFERRED - verify]** was not stated outright in a retrieved page.
- Where the documentation is silent, the files say **Not documented** and the item is logged in `known-gaps.md`.
- Always establish **which region** hosts the system before answering an endpoint, port or URL question - the domains differ per data centre.
- Always establish **Standard or Premium plan** before answering a question about intelligent search, visual trajectory or SCIM provisioning.
- Always establish **Security Center SaaS or SaaS Edition (Classic)**.
- Several administrative tasks exist only in Genetec Configuration desktop (Map designer, Automation, advanced user settings, Mercury controllers, intrusion configuration). Say so rather than sending users hunting through the web client.
- This skill is reference material written from public product documentation. It paraphrases and indexes; it does not reproduce the source pages. Deep links to the canonical topics are in `references/topic-index.md`.
