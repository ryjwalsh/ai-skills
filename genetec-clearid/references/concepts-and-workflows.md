# ClearID concepts, workflows and requirements

What the features *are* and how they behave. Pair every explanation here with a breadcrumb from `navigation-map.md` or `where-is-it-index.md`.

---

## 1. Object model

| Object | What it is | Where it lives |
|---|---|---|
| Account | One ClearID tenant. Its ID is in every URL. A user can belong to several and switch with Change account | `/{accountId}/...` |
| System | The connection to an access control system (Security Center / Synergis), with plugin status and the cardholder source-of-truth setting | Administration > Systems |
| Site | A physical location. Owns the time zone, the access control system binding, visitor management settings, devices and notification wording | Organization > Sites |
| Area | A requestable space inside a site, mapped to doors in the access control system. Owns its own approval workflow, requestable credential types and visitor exposure | Organization > Areas (route `locations`) |
| Visit profile | A reusable rule set for one kind of visit at one site - who may invite, what is approved, what the visitor must supply, how the badge and credential work | Sites > [site] > Visitor management > [profile] |
| Identity | A person record: attributes, vehicles, access, roles, credentials, reporting line and portal rights | Organization > Identities |
| Identity template | A preset used when creating identities or identity requests | Organization > Identity templates |
| Role | A group of identities that carries access. Has owners, managers, members, a membership approval workflow and an optional provisioning policy | Organization > Roles (route `teams`) |
| Credential | Card, mobile, license plate or PIN. Which types can be requested is an area setting; how they sync is an account setting | Areas / Administration > Credentials |
| Watchlist | A screening list of individuals or companies used against visitors | Organization > Watchlists |
| Access review | A periodic campaign asking owners to confirm access is still needed, by Area, Role or Identity | Organization > Access reviews |

## 2. Request and approval workflows

ClearID processes and approves or rejects requests using workflows - a series of activities carried out by the system or by authorized people over the life of a request. Activities can change the state and properties of the request, affect other objects, or wait for a condition. Which activities apply depends on how the site and area are configured, so the same request type can behave differently in two areas of the same tenant. [S9]

| Workflow | Covers | Key configuration point |
|---|---|---|
| Access request | A person asking for access to an area | Areas > [area] > Access request configurations |
| Role request | A person asking to join a role | Roles > [role] > General > Request approval workflow |
| Identity request | Creating or changing an identity, including requesting one or many at once | Administration > Account configuration > Request visibility and Request expiry |
| Visit request | A host inviting a visitor, or a walk-in registering | Sites > [site] > Visitor management > [profile] > Planned visits / Walk-in visits |
| Visit request watchlist | Screening a visitor against watchlists as part of the visit request | Organization > Watchlists, plus watchlist managers per site |

The access request workflow spans both products: ClearID handles the request, approval and expiry; Synergis enforces the resulting cardholder and credential state at the door. [S10]

Every request type has an expiry policy so that a request left un-actioned does not sit open forever. All four policies (Roles, Accesses, Visits, Identities) are set together at **Administration > Account configuration > Request expiry**. [S2]

Approval can be automatic. When the workflow is set to auto-approve, no approval e-mail is sent at all. [S11]

## 3. E-mail notifications

ClearID sends e-mail on defined events, and the recipient depends on the event and on the workflow configuration. The shape of the matrix, useful for answering "who gets told when X happens": [S11]

- Account created for an identity - administrators only.
- Area access request submitted - the requester.
- Area access request canceled - the requester, the area approvers and the area owners.
- Area access request needs a decision - the supervisor and/or area approver, depending on workflow settings. Nothing is sent when the request auto-approves.
- Area access request approved or denied - the identity and the area owners, including both the submitter and the person the access is for when they differ.
- Area access granted, revoked or expired - the identity and their supervisor.
- Role requests follow the same submitted / decision / outcome pattern with role managers and role owners in place of area approvers.

Three layers control whether the mail actually arrives:

1. **Administration > Notifications** - account-wide Enabled and Can opt out per group, plus recipient-role columns on Access request and Role request.
2. **Sites > [site] > Notifications** - the language and region, the banner image, per-type customization and visitor check-in SMS.
3. **My Profile > Preferences** - the individual user's own opt-ins.

If a visitor says they never received their invitation, work down those three layers, then check the visit profile and the site's Visitor email options. The TechDoc troubleshooting topic for this is "Visit email notifications not received by visitors". [S12]

## 4. Webhooks

A webhook is a user-defined HTTP callback: an event in ClearID triggers an HTTP call to a third-party API so that system can react. After a webhook is created, the webhook service listens for the chosen events from other ClearID services and posts to the URL configured in Webhook details. Each webhook carries a name, description, enabled flag, URL, secret, optional additional headers, and one event. [S13]

Available events: Accesses (granted, revoked); Identities (created, updated, deleted, picture updated); Identity requests (created, updated); Visitors (check-in, check-out); Credentials (assigned, unassigned, created, updated, deleted); Visit events (approved, canceled, created, denied, expired). [S2]

Typical use: notify a third party when an identity is updated, or fan out to other stakeholders when an identity request is created or updated. [S13]

## 5. Visitor management

Three visit types are enabled per visit profile: **pre-authorized areas**, **planned visits** and **walk-in visits**. [S2]

- **Planned visits** are host-initiated invitations. The profile controls who can invite, the approval workflow, the instructions file sent to the visitor, check-out rules and grace period, parking and host meetup locations, the list of reasons for visit, extra site requirement fields, and ADA and vehicle details.
- **Walk-in visits** are kiosk self-registrations. The profile controls the display name shown on the kiosk and whether security screening applies.
- **Pre-authorization** lets a visitor be granted areas ahead of arrival. It must also be permitted on the area itself, at **Areas > [area] > Visitor management > Allow pre-authorization**, which is also where the per-visitor approval workflow and the visitor-facing area name live.

Site-level visitor settings sit above all profiles: the site display name shown to visitors, check-in options (QR, ID, Email, Check-out), kiosk theme, kiosk welcome screen, printed badge logo, visitor e-mail options, Security Center options and the visitor information retention period. [S2]

Per profile, the General profile configurations card controls visitor check-in photos, the kiosk badge, access control (including QR credentials in Synergis and the escort rule) and visitor compliance documents. [S2]

Visitors can be invited one at a time or by importing a visitor list, and SMS alerts can be sent. Visit events can be reviewed, copied and modified after the fact. [S1]

### QR codes as a visitor credential

QR code credentials require work on both sides: import the custom card format for the QR code credential in Synergis, then enable QR code credentials for visitors in ClearID on the visit profile. Supported reader families documented for this are **Qscan** barcode readers (including connection to a Mercury controller, and a specific configuration to support 40-bit hexadecimal QR codes) and **STid** QR code readers (create a reader configuration, then transfer it to the reader). [S1]

## 6. Self-Service Kiosk

The kiosk is an iPad app used for visitor **check-in** and **self-registration**. It is bound to a site with an activation code from **Sites > [site] > Devices**, and its look is set by the site's kiosk theme, welcome screen and badge logo. [S1] [S2]

- Supported hardware: Apple iPad 10.9 inch and iPad 10.2 inch, certified on iOS 16.1 or later. Other iPads may work but do not fit the kiosk stand - the iPad Pro is the documented example. The 10.2 inch iPad and its stand enclosure are no longer sold. [S6]
- Accessories documented: kiosk floor stand, floor stand printer shelf, tabletop stand. [S1]
- Label printers documented: Brother QL-820NWBc, QL-820NWB and QL-810W, and Brother TD-4550DNWB, each with Bluetooth, Wi-Fi and Ethernet setup topics. Wi-Fi mode uses Bonjour for device discovery. A test badge can be printed from the kiosk. [S1] [S5]
- Identity documents are read and processed **locally on the iPad**. ID data and pictures are never sent to the cloud. The supported document list is large and organized by region, and covers ID cards, passports and driving licences with per-country notes on supported side, orientation and script - some entries are marked BETA. [S8]
- The kiosk app can be reset, and a printer selected, from the app itself. [S1]

## 7. Watchlists

A watchlist screens visitors against known individuals or companies. Entries can be added by hand as individuals or as companies, imported from a file, exported to a file, tested, and deleted. Watchlists themselves can be modified and deleted. [S1]

- Watchlist managers are granted per site: **Sites > [site] > Permissions**.
- **Manual screening** at **Organization > Watchlists** screens on First name, Last name, Email, Company and Date of birth without waiting for a visit request. [S2]
- When a watchlist blocks a visitor there is a documented unblock path ("Unblocking visitors blocked by a watchlist in ClearID"). [S1]
- Screening is wired into the visit request through the visit request watchlist workflow, and walk-ins have their own **Security screening** switch on the visit profile. [S2] [S9]

## 8. Access reviews

An access review campaign asks owners to confirm that existing access is still required. The toggle at the top of **Organization > Access reviews** selects the review dimension: **Area**, **Role** or **Identity**. **Configure > Settings** can enforce an expiration for reviews and set the number of days after which a review expires. Results are exportable with **Download CSV**, and there is a matching report at **Reports > Access reviews**. [S2]

## 9. Reporting

Eight report tabs, each with a local/UTC **Display time** toggle and **Download CSV**: Access reviews, Access requests, Identity requests, Visitors, Site activity, Site and Area owners, User activity, Role requests. [S2]

Choosing the right one:

| The question | The report |
|---|---|
| Who requested or approved access, and when | Access requests |
| Who asked for an identity to be created or changed | Identity requests |
| Who joined or left a role, and who approved it | Role requests |
| Who visited, when they checked in and out | Visitors |
| What happened at a site | Site activity |
| Who changed a setting in the portal | User activity |
| Current owner coverage across sites and areas | Site and Area owners |
| Outcome of a review campaign | Access reviews |

## 10. Network and platform requirements

All outbound, TCP port 443. [S5]

| Component | Destinations |
|---|---|
| ClearID web portal | `*.clearid.io`, `*.core.windows.net`, `*.launchdarkly.com` |
| One Identity Synchronization Tool | `*.clearid.io` |
| Self-Service Kiosk | `*.clearid.io`, `*.azurewebsites.net` |
| Label printer, Wi-Fi mode | Bonjour for device discovery |

Regional portal hosts: `portal.clearid.io` (US), `portal.ca.clearid.io` (Canada), `portal.eu.clearid.io` (Europe), `portal.au.clearid.io` (Australia). Cookies must be enabled. With corporate single sign-on the account activates automatically and no activation e-mail is sent. [S3]

Genetec grades devices as **Certified** (tested and validated by Genetec) or **Supported by design** (same design characteristics as a certified device, but not tested by Genetec). Quote the grade when answering hardware questions. [S6]

## 11. Troubleshooting entry points

The documentation carries six troubleshooting topics. Map the symptom to the topic, then give the portal path to check. [S12]

| Symptom | Documented topic | First places to look in the portal |
|---|---|---|
| Visitors do not receive visit e-mails | Visit email notifications not received by visitors | Sites > [site] > Notifications; Sites > [site] > Visitor management > Visitor email options; Administration > Notifications |
| Visitor host fields are empty in Genetec Operation | Visitor hosts fields in Genetec Operation are empty | Administration > Systems > [system] (plugin status and source of truth); Sites > [site] > Visitor management > Security Center options |
| Sync tool cannot connect | ClearID One Identity Synchronization Tool connectivity issues | Firewall to `*.clearid.io` on 443; Administration > API integrations; the tool's connection settings |
| Sync runs but data is wrong or missing | ClearID One Identity Synchronization Tool data synchronization issues | Attribute field mapping in the tool; Administration > Identity synchronization > [config] > Identity field mappings and Synchronization logs |
| Kiosk misbehaves | ClearID Self-Service Kiosk issues | Sites > [site] > Devices (activation); iOS version against the supported list; kiosk reset |
| Badges do not print | ClearID Self-Service Kiosk label printer issues | Printer connection mode topic for that model; Bonjour on the network for Wi-Fi; print a test badge |

For anything the portal cannot show, the plugin and cardholder ownership question at **Administration > Systems > [system]** is the single most useful diagnostic page in ClearID: it reports plugin version, last plugin response and last plugin query, which tells you whether ClearID and Security Center are actually talking. [S2]
