# ClearID web portal navigation map

Master reference for every page, tab, sub-tab and settings card in the ClearID web portal, captured from a full operator walkthrough of a live tenant on 2026-07-29. [S2]

Base URL for every route below: `https://portal.clearid.io/{accountId}/` (swap the host for `portal.ca.clearid.io`, `portal.eu.clearid.io` or `portal.au.clearid.io` in those regions). The account ID is visible in the URL of every page. [S3]

Notation: `[site]`, `[area]`, `[person]`, `[role]`, `[profile]`, `[system]` mean "the record the user selects".

---

## 1. Shell

The left sidebar has two groups.

### My workspace

| Item | Route | What it holds |
|---|---|---|
| Requests | `/requests` | The signed-in user's own requests. Landing page after logon (*My requests*). Filter by status; **My requests** and **My tasks** views; **Invite visitors** and **Request access** action buttons |
| Tasks | `/tasks` | Items waiting on the signed-in user as an approver |
| Visits | `/visit-events` | Visit events the user hosts or can see |

### Access management

| Item | Route |
|---|---|
| Organization | `/organization` |
| Reports | `/reports` |
| Administration | `/administration` |

### Bottom of the sidebar

**Help** opens the Help Center panel: Home and News tabs, plus links to the User guide, Support contact and Privacy policy.

The **user name** button opens: My Profile, Preview features, Preferences, Change account, Log off.

---

## 2. Access Management > Administration

Route `/administration`. Ten tabs, in portal order.

| # | Tab | Route |
|---|---|---|
| 1 | Systems | `/administration/systems` |
| 2 | API integrations | `/administration/service-principals` |
| 3 | Webhooks | `/administration/webhooks` |
| 4 | Permissions | `/administration/permissions` |
| 5 | Credentials | `/administration/credentials` |
| 6 | Account configuration | `/administration/account-configuration` |
| 7 | Notifications | `/administration/account-notification-preferences` |
| 8 | Custom fields | `/administration/custom-fields` |
| 9 | SCIM integration | `/administration/scim` |
| 10 | Identity synchronization | `/administration/sync` (internal tab name "Unified Sync") |

### 2.1 Systems

`/administration/systems` lists the connected access control systems. Open a system to get:

- **System information** - Status, Security Center system ID, Security Center version, Plugin version, Last plugin response, Last plugin query.
- **Cardholder and credential management** - the source of truth selector: **ClearID** or **Security Center**. This decides which side owns cardholder and credential records.
- **Supported credential formats**.
- **Delete system**.

Use this page first for any "is ClearID talking to Security Center?" or "which side owns cardholders?" question.

### 2.2 API integrations

`/administration/service-principals`. Lists API keys and offers **Add API integration**. This is where machine-to-machine credentials live, including the key used by the **Local Agent** for identity synchronization.

### 2.3 Webhooks

`/administration/webhooks`, new webhook at `/administration/webhooks/new`. Three settings groups plus the event selector:

- **General** - Name, Description, Enabled.
- **Webhook details** - URL, Secret, Additional headers.
- **Event** - exactly one event per webhook, chosen from the catalogue below.

Event catalogue:

| Category | Events |
|---|---|
| Accesses | granted, revoked |
| Identities | created, updated, deleted, picture updated |
| Identity requests | created, updated |
| Visitors | check-in, check-out |
| Credentials | assigned, unassigned, created, updated, deleted |
| Visit events | approved, canceled, created, denied, expired |

Webhook logs are documented as a separate view - see `references/techdocs-index.md` ("Viewing webhook logs in ClearID").

### 2.4 Permissions

`/administration/permissions` with three sub-tabs:

| Sub-tab | Route | Purpose |
|---|---|---|
| Identities | `/administration/permissions/identities` | Per-identity portal permissions |
| Supervisors | `/administration/permissions/supervisors` | "Grant supervisors access to manage their direct reports" |
| Administrators | `/administration/permissions/administrators` | Administrator list, with columns for the Administration section, Administrators and Systems |

### 2.5 Credentials

`/administration/credentials`:

- **Credential synchronization mode**.
- **Credential synchronization logs** - **View logs** button.

### 2.6 Account configuration

`/administration/account-configuration`. Account-wide behaviour and look and feel.

| Card | Contents |
|---|---|
| Branding | Theme, Logo, Accent color, Restore default theme |
| Request expiry | Separate expiry policies for **Roles**, **Accesses**, **Visits**, **Identities** |
| Request visibility | Show or hide Request access, Request role, Request an identity, Request multiple identities, Invite visitors |
| Identity picture synchronization | Whether identity photos sync |
| Custom links | Extra links surfaced in the portal |

### 2.7 Notifications

`/administration/account-notification-preferences`. Account-wide e-mail settings: **Emails and recipients**, with **Enabled** and **Can opt out** per notification group.

Groups: Weekly activity summary, Access, Access review, Access request, Role membership, Role request, Identity request, Visit event, Visit request.

**Access request** and **Role request** additionally expose recipient-role columns: Requester, Role manager, Role owner, Supervisor, Area manager, Area owner.

Per-user opt-ins live in **User name > My Profile > Preferences**, not here.

### 2.8 Custom fields

`/administration/custom-fields`, two areas:

- **Sections** - **Add custom field section**.
- **Custom fields** - **Add custom field** opens `/administration/custom-fields/new-field` with: Display name, Custom field ID, data type (**Boolean, Date, Date-Time, Decimal, Numeric, Text**), Read-only, Enable synchronization.

### 2.9 SCIM integration

`/administration/scim`:

- **Endpoint URL** - two values, one for **Entra ID** and one for **Other identity providers**.
- **Generate key**.
- **Active keys** - the list of live SCIM keys.
- **Force reset and replace**.

### 2.10 Identity synchronization

`/administration/sync`. Top-level actions: **Download local agent** and **Add synchronization**, plus the list of synchronization configurations. Open a configuration for:

| Section | Contents |
|---|---|
| Overview | hostname, agent version, last sync |
| Local agent authentication | agent credential binding (key issued under API integrations) |
| Synchronization folder | watched folder path |
| CSV template | template download / definition |
| Identity field mappings | source column to ClearID identity field |
| Credential field mappings | source column to credential field |
| Advanced configurations | Delimiter, Encoding |
| Management | activate the configuration, upload a single CSV |
| Synchronization logs | run history and errors |
| Delete synchronization | removes the configuration |

---

## 3. Access Management > Organization

Route `/organization`. Seven tabs.

| Tab | Route |
|---|---|
| Sites | `/organization/sites` |
| Areas | `/organization/locations` |
| Identities | `/organization/identities` |
| Roles | `/organization/teams` |
| Watchlists | `/organization/watchlists` |
| Identity templates | `/organization/identity-templates` |
| Access reviews | `/organization/access-reviews` |

### 3.1 Site detail

`/organization/sites/{siteId}`. Nine tabs.

| Tab | Route suffix | Contents |
|---|---|---|
| General | (none) | Name, Description, Access control system, Time zone, Address, Tags, Map pin, Delete site |
| Areas | `/locations` | Areas belonging to the site |
| Access configurations | `/access-configurations` | Access duration time limit, Access request documents |
| Visitor management | `/visitors` | Visit profiles list, Site display name, Check-in options (QR, ID, Email, Check-out), Kiosk theme, Kiosk welcome screen, Printed badge logo, Visitor email options, Security Center options, Visitor information retention period |
| Devices | `/devices` | Kiosk / iPad activation codes |
| Permissions | `/permissions` | Site owner, watchlist manager |
| Notifications | `/notifications` | Language and region, Email banner, Customize email notifications by type, Visitor check-in SMS |
| Site configurations | `/site-configurations` | Site External ID |
| Site activity | `/activity` | Audit trail for the site |

### 3.2 Visit profile detail

`/organization/sites/{siteId}/visitors/{profileId}`. A visit profile is the reusable rule set for one kind of visit at one site.

| Section | Contents |
|---|---|
| Visit type configurations | Pre-authorized areas, Planned visits, Walk-in visits |
| Planned visits | Who can invite, approval workflow, Visitor instructions file, Check-out rules and grace period, Parking locations, Host meetup locations, Reasons for visit, Site requirements / additional fields, ADA, Vehicle |
| Walk-in visits | Kiosk profile display name, Security screening |
| General profile configurations | Visitor check-in photos, Kiosk badge configuration, Access control (including QR credentials in Synergis and the escort rule), Visitor compliance documents |
| Delete profile | Removes the profile |

### 3.3 Area detail

`/organization/locations/{areaId}`.

| Tab | Route suffix | Contents |
|---|---|---|
| General | (none) | Name, Description, Tags, Sync area, Delete area |
| Access request configurations | `/access-request/document-fields` | Request approval workflow, Access request visibility, Access request credentials (Card, Mobile, License plate, PIN), Include vs Exclude site documents, area documents |
| Permissions | `/managers` | Area owner, area manager |
| Schedules | `/schedules` | Schedules that apply to the area |
| Access | `/access` | Who currently has access |
| Visitor management | `/visitors` | Enable visitor management, Area name displayed to visitors, Allow pre-authorization, Per-visitor approval workflow |

### 3.4 Identity detail

`/organization/identities/{identityId}`.

| Tab | Route suffix | Contents |
|---|---|---|
| General | (none) | Core identity attributes |
| Vehicles | `/vehicles` | Vehicles / plates |
| Access | `/accesses` | Current and past area access |
| Roles | `/teams` | Role memberships |
| Delegations | `/delegations` | Approval delegations |
| Direct reports | `/direct-reports` | Reporting line |
| Access control | `/access-control` | Extended grant time, Cardholder activation / expiration, Provisioning attributes, Associated cardholders |
| User permissions | `/web-access` | **Web portal access** toggle |
| Visitor management | `/visitors` | Visitor-related rights for this identity |
| Credentials | `/credentials` | Assigned credentials |
| Logs | `/logs` | Per-identity history |

### 3.5 Role detail

`/organization/teams/{roleId}`.

| Tab | Route suffix | Contents |
|---|---|---|
| General | (none) | Name, Description, Internal notes, member add/remove notifications, Request approval workflow, Visibility, Expiry enforcement |
| Permissions | `/managers` | Role owner / role manager |
| Members | `/members` | Membership list |
| Access | `/accesses` | Access the role grants |
| Provisioning policy | `/provisioning` | Rules that add or remove members automatically |
| Role activity | `/audit` | Audit trail |

### 3.6 Watchlists

`/organization/watchlists`. **Add watchlist** creates a list. **Manual screening** screens a person on demand against First name, Last name, Email, Company and Date of birth.

Watchlist managers are granted per site at **Organization > Sites > [site] > Permissions**.

### 3.7 Identity templates

`/organization/identity-templates`. Reusable identity presets used when creating identities and identity requests.

### 3.8 Access reviews

`/organization/access-reviews`. An **Area / Role / Identity** toggle selects what is being reviewed. Actions:

- **Configure** > **Settings** - Enforce an expiration for access reviews, expire after N days.
- **Download CSV**.
- **Schedule access review**.

---

## 4. Access Management > Reports

Route `/reports`. Eight tabs. Every tab offers a **Display time** toggle (local or UTC) and **Download CSV**.

| Tab | Route |
|---|---|
| Access reviews | `/reports/access-reviews` |
| Access requests | `/reports/access-requests` |
| Identity requests | `/reports/identity-requests` |
| Visitors | `/reports/visitors` |
| Site activity | `/reports/audit-reports` |
| Site and Area owners | `/reports/site-location-managers` |
| User activity | `/reports/user-activities` |
| Role requests | `/reports/role-requests` |

Pick the tab by the noun in the question: a question about who approved an access goes to **Access requests**; a question about who changed a setting goes to **User activity**; a question about what happened at a site goes to **Site activity**.

---

## 5. My Profile

`/profile`, reached from the user name button.

| Tab | Route suffix | Contents |
|---|---|---|
| General | (none) | The signed-in user's own details |
| Access | `/accesses` | Their own access |
| Roles | `/teams` | Their own roles |
| Delegations | (none observed) | Their own delegations |
| Direct reports | (none observed) | Their own direct reports |
| Credentials | (none observed) | Their own credentials |
| Preferences | `/preferences` | Theme mode, Preferred language, per-user notification opt-ins |
| Manage | deep link | Jumps to the user's own identity record under Organization > Identities |

---

## 6. Route quick reference

Routes that do not match their menu label - the most common cause of a wrong answer:

| Menu label | Actual route |
|---|---|
| Areas | `/organization/locations` |
| Roles | `/organization/teams` |
| API integrations | `/administration/service-principals` |
| Notifications (account) | `/administration/account-notification-preferences` |
| Identity synchronization | `/administration/sync` |
| Site activity (report) | `/reports/audit-reports` |
| Site and Area owners (report) | `/reports/site-location-managers` |
| User activity (report) | `/reports/user-activities` |
| Visits (My workspace) | `/visit-events` |
| User permissions (identity) | `/web-access` |
| Access request configurations (area) | `/access-request/document-fields` |
