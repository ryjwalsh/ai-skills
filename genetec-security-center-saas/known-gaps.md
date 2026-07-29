# Known gaps

Things a user is likely to ask that the Security Center SaaS documentation portal does **not** answer, as captured on 2026-07-29. If a question falls in here, say so and point at the authoritative source rather than guessing.

## Deliberately held elsewhere

These are referenced constantly by the docs but live in documents outside the portal. They change often, so do not hard-code answers.

| Question | Authoritative source |
|---|---|
| Is camera / intercom / controller / panel model X supported, and on which firmware? | Security Center SaaS **Supported Device List (SDL)** |
| Does device X support PTZ, timeline thumbnails, edge recording, metadata, forensic search? | SDL **Feature Matrix** |
| Exactly which features are Standard vs Premium? What differs from Security Center on-premises? | **Security Center SaaS Features Matrix** |
| Where is my data physically stored? | **Genetec Subprocessors list** |
| How many device connections does my licence allow? | **Subscriptions Portal**, system General page |
| What is my maintenance schedule for Synergis Cloud Link? | **Updates** page in the Configuration task |
| Which interface-module firmware should I load? | **GTAP Product Download** page (Download Finder > Genetec Cloudlink) |
| How much retention will this camera load produce? | https://svcalculator.genetec.com/ |
| Is the service degraded right now? | https://status.genetec.com |
| Full list of TURN/STUN relay IP addresses | Linked "complete list of IP addresses" page from the port tables |
| Federation port diagrams | Genetec channel partner |

## Not documented in the captured material

### Commercial and licensing

- Pricing, package tiers and what each subscription package includes in terms of cameras, retention or FPS.
- How to buy, renew or resize a subscription. The Setup Guide describes the commissioning flow (quote, order, activate) but not the commercial mechanics.
- Whether Federation is licensed per host, per remote site or per federated camera. Only that it is **not automatically included**.

### Platform internals

- Cloudlink **2210** disk capacity, weight, retention scenarios and warranty - the other three models publish these, the 2210 guide did not.
- Which specific cloud roles exist in a Security Center SaaS tenant, and their resource limits. Named roles appear incidentally (Intrusion, Map Manager, Automation Manager, Access Manager, Reverse Tunnel Server) but there is no role reference.
- Backup and restore of the **cloud** configuration. Only the Cloudlink Synergis Softwire configuration file export/import is documented.
- Any published RTO, RPO, uptime SLA or data-durability commitment.
- Audit-log retention for the **cloud** system. Only the 90-day default for Synergis Softwire audit logs on a Cloudlink is documented.
- Rate limits, throttling or concurrency ceilings for the web client, mobile app or desktop clients.
- Whether or how you migrate an existing Security Center SaaS Edition (Classic) system to Security Center SaaS.

### APIs and integration

- **There is no Security Center SaaS SDK or REST API documentation in this portal.** Plugin integrations are explicitly **not supported**. The only API documented anywhere in the captured set is the **ClearID** REST API. Anyone asking about programmatic access to Security Center SaaS should be pointed at the Genetec Developer Hub, not at this skill.
- Webhooks exist for **ClearID only**, not for Security Center SaaS.
- Whether the Genetec Web-based SDK, Media Gateway RTSP or Mission Control Web API are available in SaaS.

### Devices

- Direct-to-cloud onboarding for manufacturers other than Axis, Bosch, Hanwha Vision and i-PRO.
- Access-control integrations other than **Mercury** on Genetec Cloudlink. The Synergis Softwire guide states Mercury is currently the only supported integration.
- Which intrusion panel manufacturers beyond **Bosch** and **Honeywell Galaxy** are supported.
- Speaker configuration in detail. Speakers appear in the calling and port topics but have no setup topic of their own.
- ALPR configuration. ALPR is stated to be **available only through Federation** and is otherwise absent.
- Elevator configuration in Security Center SaaS specifically, beyond passing references.
- Whether IPv6 will be supported on Cloudlink - only that it currently is not.

### Operations

- The complete list of **event types** available in Security Center SaaS. The docs repeatedly warn that "not all event types are available" without enumerating them.
- The complete list of **automation action types** - the response-configuration topic defers to an "Action types" list that was not part of the captured set.
- The complete **privilege** list.
- The complete **map object** table (it is long and was truncated in capture) - re-read the *Supported map objects* topic for the full version.
- Threat-level actions beyond *Set minimum security clearance*, which is the only exclusive action documented in detail.
- Dashboards, people counting and activity trails in Genetec Operation desktop. These are named as Operation-desktop-only features but have no procedures in the SaaS portal.
- Forensic report and Anything report procedures, beyond their one-line descriptions.
- Any documented workflow for reviewing or exporting the cloud audit trail.

### Security and compliance

- Hardening guidance for Security Center SaaS itself. There is no hardening guide equivalent to the on-premises one in this portal.
- Certification and compliance attestations (SOC 2, ISO 27001 and similar).
- Whether customer-managed encryption keys are possible.
- Cipher suites supported by **Security Center SaaS**. The cipher notice covers **SaaS Edition (Classic)** only.
- Certificate management for the cloud tenant. Only Cloudlink's self-signed appliance certificate and the reverse-tunnel identity certificates are mentioned.
- Password complexity rules for Genetec-managed accounts.
- Session timeout for the web client. ClearID's default (30 minutes) is documented; Security Center SaaS's is not.

### Front desk and screening

- What data source backs **security screening**, and what "screens US people only" means in practice.
- Retention period for walk-in check-in photos stored in Azure. ClearID's visitor-photo retention is described as a minimum period; the Front desk equivalent is not quantified.

## Deprecated or transitional areas to be careful with

- **Event-to-actions** and **scheduled tasks** are described as legacy and convertible to automations. Prefer automations in new designs, and be aware of the documented conversion exclusions.
- **Security Center SaaS Edition (Classic)** content is present in the portal purely as KB articles and a cipher notice. Do not apply it to Security Center SaaS.
- Several Cloudlink 110 and 210 hardware interfaces (RS-485 ports, supervised inputs, output relay, USB, second video output) are documented as **reserved for future use**. Do not design against them.

## How to close a gap

1. Check `references/topic-index.md` for a topic that might cover it.
2. Check the external sources in `sources.md`.
3. If the answer genuinely is not published, say so and route the user to their Genetec channel partner or the Genetec Technical Assistance Center (GTAC) - which is also the only documented path for corporate SSO and SCIM provisioning setup.
