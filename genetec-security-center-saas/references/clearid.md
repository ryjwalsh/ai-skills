# Genetec ClearID in Security Center SaaS

Source: Genetec ClearID in Security Center SaaS. [S11]

ClearID is Genetec's identity and visitor-management service. In a Security Center SaaS deployment it owns **sites, areas, identities, access requests and visits**, while Security Center SaaS owns the **doors and the physical access control**. The two synchronise.

## Portal hosts and sign-in

| Region | Portal |
|---|---|
| United States | https://portal.clearid.io/ |
| Australia | https://portal.au.clearid.io/ |
| Canada | https://portal.ca.clearid.io/ |
| Europe | https://portal.eu.clearid.io/ |

Enable cookies, enter your username, click **Logon**, and you are redirected to your account's sign-in page. With corporate SSO (Microsoft 365 or similar) the account activates automatically and **no activation email is sent**. The **account ID appears in the URL of every page**, which is how you tell accounts apart. Log off from the name menu at the top of the page - and close all ClearID browser windows afterwards. Automatic sign-out follows a period of inactivity that varies by environment; **the default is 30 minutes**.

## Firewall ports

| Component | Requirement |
|---|---|
| ClearID web portal | TCP 443 outbound to `*.clearid.io`, `*.core.windows.net`, `*.launchdarkly.com` (allow all outbound traffic for each domain) |
| ClearID One Identity Synchronization Tool | TCP 443 outbound to `*.clearid.io` |
| ClearID Self-Service Kiosk | TCP 443 outbound plus the kiosk-specific requirements in the source topic |

## Supported hardware

Kiosk devices: **Apple iPad 10.9 inch** and **iPad 10.2 inch**, certified on **iOS 16.1 or later**. Other iPads may work without the kiosk stand if they meet the minimum iOS version. Certification levels used throughout the ClearID device list are **Certified** (tested and validated by Genetec) and **Supported by design** (same design characteristics as a certified device, but not tested by Genetec).

## Workflows

ClearID drives everything through workflows - sequences of system and human activities that change the state and properties of a request, affect other entities, or wait for a condition. Depending on site and area configuration, some steps may not apply.

| Workflow | What it governs |
|---|---|
| **Access request** | Life cycle of a request for area access. Spans ClearID and Synergis: new request, per-area approval (employee or supervisor approval, then area approval), then wait for start, update the Security Center access rule, wait for expiration, remove the access rule, notify area owners |
| **Visit request** | Life cycle of a visit. Approval, visitors created in Security Center SaaS, access card activated and assigned, wait for check-in, manual or automatic check-out, card deactivated on the last day of the visit |
| **Visit request watchlist** | Runs in parallel with the visit workflow when watchlists are enabled. Screens visitors during self-service check-in or self-registration and applies block or notify actions |
| **Identity request** | Creates one identity, or many via CSV import, and adds each to one or more roles so they inherit access for a period. Approval by supervisor and/or identity approver |

## Setup order

**Visitor management** [S11]

1. Learn workflows and email notifications.
2. Check firewall ports and supported devices.
3. Sign in, then **grant access to the web portal**.
4. Sites: create them, add site owners, configure visit profiles (check-in photos, badge settings, access control, compliance documents), review who can invite visitors, set a maximum site-access duration, customise the email banner.
5. Areas: learn about areas, create them, add doors (in Security Center SaaS), enable visitor management, configure nested areas.
6. Then invite visitors.

**Data synchronisation**

1. Check firewall ports, sign in, grant portal access.
2. **Authenticate** non-user system connections.
3. Choose one identity-synchronisation route: the **ClearID API**, the **SCIM integration**, or the **One Identity Synchronization Tool**.
4. Configure **webhooks** if third parties need notifying.

## Granting portal access

Only an **account administrator** can grant access, and the identity must already exist.

- **Organization > Identities**, find the user, click **User permissions**, then set the **Web portal access** slider to Enabled. A disabled slider means the identity cannot access the portal.
- The same path grants **Administrator** access.
- Some organisations deliberately leave portal access off for most identities because they do not need employee requests.
- When a new account is created, the designated account administrator receives *Welcome to Genetec ClearID* and *New ClearID Account - ACCOUNTNAME* emails, and **Administrator access defaults to whoever receives that email** - which matters when a system integrator is the initial recipient.

## Sites

A **site** is a logical entity containing one or more areas. Sites and areas can have different owners. A site normally maps to a building or a campus.

Design guidance from the docs:

- Multiple buildings under one security team or one visitor policy can be a **single site**.
- Buildings spread across a city are usually **one site each**.
- Each site can have its own policies and site owners.
- Multiple sites can share the same Security Center SaaS access control system.
- **Implementation choices affect ClearID solution cost.**

Creating a site (**account administrator only**): **Organization > Sites > Add site**, then on the General page enter **Name**, **Description** (geographical or physical location) and the **Access control system**.

**Site owners** are identities with authority over the site's areas. Add them before assigning area owners, configuring site-owner-only settings, or managing site access reviews: **Organization > Sites > select site > Permissions > Add identity**, search and select, Add. Clicking the identity link in the Identity column shows company, department and other details.

**Maximum duration for site access** (site owner): **Organization > Sites > select site > Access configurations**. When enabled - and it is on by default if the feature is activated for the account - identities with temporary access lose it when the limit is reached. It applies **only to individual identities or manually granted access**, never to **role** access. Use role groups for people who need permanent access.

**Email banner** (site owner or account administrator): **Organization > Sites > select site > Images**. Banner changes sync to the site **every 60 seconds**. Best practice: transparent PNG. Size requirements are in the tooltip on the Images page.

### Visit profiles

Visit profiles let a site owner run different visitor-management settings for different needs within one site.

- Each profile covers up to two visit types: **Planned** and **Walk-in**.
- A site can hold **unlimited planned** profiles and **up to 10 walk-in** profiles.
- Users choosing a profile when creating a visit request get meetup and parking locations, areas to access, and more prefilled. Where several options exist, the visitor can choose.
- ClearID adds a **default visit profile** to any system that previously had visitor management enabled; that profile **cannot be deleted** but can be renamed and configured.
- **Sites with no configured visit profile have visitor management disabled.**
- **A site needs at least one pre-authorized area before walk-in visits can be enabled.**

Configure at **Organization > Sites > Visitor management > Add visit profile**. Under **General profile settings**:

| Section | Settings |
|---|---|
| Visitor check-in photos | **Take visitor photo during check-in** (on by default) at the Self-Service Kiosk, and **Store visitor photos in ClearID** for retention in the portal |
| Kiosk badge configuration | **Allow badge re-printing** lets visitors reprint a lost or damaged temporary badge from a kiosk. **Label printed on badge** identifies the visitor type. Note: **visitor QR codes used as credentials should only open non-secure areas** |
| Access control | **Automatically create QR code credentials for visitors in Synergis** - the QR code goes in the visitor confirmation email and can open parking entrances, turnstiles or gated facilities, or be used at check-in with security or reception |
| Visitor compliance documents | Upload NDAs, waivers and similar for signature at kiosk check-in. **Up to five documents**, **PDF only**. Per document: a name, the file, and whether to **Show document on the kiosk** |

**Site-level visitor management settings** (account administrator or site owner): **Organization > Sites > select site > Visitor management**. Controls whether **QR code credentials appear in visit confirmation emails**, and Security Center options such as **Display registration code in visitor last name field** - which makes the last-name field show the surname plus the QR code value in the Visitor management task in Security Desk.

**Who can invite visitors:** **Organization > Identities > select user > Visitor management** lists the sites. Only account administrators can view that list or grant invite permission through roles. **Users are automatically granted *Invite visitors* for their home site by default**, provided site visitor-management options allow it.

## Areas

An **area** in ClearID is a logical entity defining the relationship between **Synergis doors** and **area owners**. The area owner defines policies, assigns managers, controls access and approves or denies requests. Each area is associated with a Security Center SaaS system.

**Doors are not managed in ClearID.** They are managed in Security Center SaaS, deliberately - managing doors from ClearID is impractical given the distance from the hardware. The sequence is:

1. Create the area in ClearID (**Organization > Areas > Create area**, choosing the **Site**; the **Access control system** is prefilled from the site - a warning instead of the ACS name means something is wrong).
2. ClearID automatically creates matching areas in Security Center SaaS.
3. In Security Center SaaS, add doors to those areas. **Doors moved under an area inherit the area's access rules.** Requires the **View door properties** privilege in Genetec Configuration desktop.

Doors in an area are either **Perimeter** (used to enter and exit, controlling access) or **Captive** (internal).

**Enabling visitor management for an area** (area owner or site owner): **Organization > Sites > Areas > select area > Visitor management**. Visitor approval options:

| Option | Meaning |
|---|---|
| Automatically approve visitors | No human approval for this area |
| Use the area permissions | Only area managers can approve or deny |
| Define visit approvers | Only the named Visit approvers can approve |

### Nested areas

Nested areas let access to one area automatically grant access to the areas you must pass through. Useful where secure areas depend on outer areas.

- Example: requesting access to a server room automatically grants access to the floor it sits on.
- Example: requesting access to a restricted area grants the floor and the building containing it.

Only a Security Center SaaS administrator or system integrator can configure the nesting, and **if the schedule for any nested area changes, the area relationships (access rules) must be reconfigured**. Best practice: nest areas using the **Access rules** options in the **Relationships** section of the Area view so access is inherited. Plan the logical grouping before you build it.

## Visitors

### Inviting

**Self-service portal**, with area approvers specified so approvals do not interrupt a chain of people who may not be the right approvers.

- **Fewer than five visitors** - add them manually.
- **More than five** - prepare a **CSV** and import. The system provides a sample CSV.
- If your identity **home site** is configured you are automatically granted permission to invite visitors there, provided the site's visitor-management options allow it.
- The fields shown vary with the site and visitor-management settings. Mandatory fields carry an asterisk.

### Managing visit events

| Task | How |
|---|---|
| Review visits | **Dashboard > Visits**. Search matches words in the visit **name** - typing "training" returns visits whose name contains *training*. **Current and upcoming visits** shows 10 by default |
| Copy an event | **Dashboard > Visits > select the event > Copy event**, then modify and Save. Any user can copy their own visits. Intended for repeat visitors, meetings with similar attendees, monthly customer visits, yearly partner conferences |
| Modify an event | **Only before the visit event starts.** Changes are highlighted in the updated email notifications. If visit-event approval is enabled, any modification other than to the **Reason** field re-triggers approval |

### SMS alerts

Used in the visit-event wizard to notify hosts automatically when visitors check in. Supported countries include Austria (+43), Australia (+61), Belgium (+32), Brazil (+55), Canada (+1), Chile (+56), Colombia (+57), Croatia (+385), Czechia (+420), Denmark (+45), Finland (+358), France (+33), Germany (+49), Greece (+30), Iceland (+354), India (+91), Ireland (+353), Italy (+39), Japan (+81), Luxembourg (+352), Malaysia (+60), Mexico (+52), Monaco (+377), Netherlands (+31), Norway (+47), Peru (+51), Philippines (+63), Portugal (+351) and others - check the source topic for the complete current list.

### QR codes as visitor credentials

Supported third-party readers: **Qscan barcode readers** and **STid QR code readers**. The QR code arrives in the visitor confirmation email and can be shown on a phone or printed. Hosts get SMS notification on arrival if enabled.

Setup sequence:

1. **Import the custom card format into Synergis.** Genetec Configuration desktop > **Access control > General settings > Credentials > Custom card formats > Add an item**, then load the ClearID **QRcode.xml** file supplied by the documentation. Requires an administrator or the *modify credential properties* privilege.
2. **Enable QR code credentials in ClearID** (site owner or account administrator). The custom card format **must already exist in the Security Center SaaS system the site is connected to**. When a QR code is generated, the visitor is created **inactive** with a credential containing the generated QR code, matching the code in the email exactly.
3. **Configure the readers.**

**Qscan:** intended for system integrators or account administrators. **Safety warning from the docs: do not look directly into the Qscan barcode reader - the laser can cause permanent vision damage.** Connect the reader to the **Reader 1 connection block** on a Mercury MP1502 controller so it can talk to Synergis. Then configure the reader to support **40-bit hexadecimal QR codes**, which is what Synergis Cloud Link expects from ClearID-generated codes.

**STid:** the docs explain why **OSDP is preferred over Wiegand** - Wiegand always sends a fixed-length format regardless of the credential. Create the reader configuration with the **STid SECard** high-security programming kit software, write it to an **STid OCB smart card**, then transfer it to the reader. For supported OSDP readers see the ClearID supported-devices list.

## Watchlists

Watchlists screen visitors by name or company details and can **block** or **notify**, at **site** or **global** level. They are managed by **watchlist managers**.

Two types: **Individuals** (persons of interest) and **Companies**.

Match rules:

| Type | Match occurs on |
|---|---|
| Individuals | First name **and** last name match, first name **and** last name **alias** match, or **email address** match |
| Companies | Company name, company domain, or email-address domain match |

**Adding watchlist managers** (account administrator): **Organization > Sites > select site > Permissions > Add identity**, search and select, Add.

**Creating a watchlist**: **Organization > Watchlists > Add watchlist**, toggle **Enabled**, then configure. Any watchlist manager or account administrator can modify or delete a **global** watchlist. Only the creating watchlist manager can delete a site watchlist or a watchlist entry.

**Entries**: **Organization > Watchlists > select watchlist > Add entry**, toggle Enabled, complete. Only a watchlist manager can add entries and view the reasons a visitor is on a notify or block list.

| Operation | Notes |
|---|---|
| Import entries | From **CSV**. A sample CSV is downloadable. Typical sources named: SharePoint, Excel, a BOLO (be-on-the-lookout) list |
| Export entries | To CSV for mass editing, deduplication, merging or backup |
| Test entries | Enter a person or company's details to check whether a screening match occurs |
| Delete entries | Filter with **Created by me** if the list is long |
| Modify a watchlist | You **cannot** convert a global watchlist to a site watchlist or vice versa - delete and recreate. **Watchlist entry permissions cannot be modified after creation** |
| Screen manually | Watchlist managers and account administrators only. Used to find watchlists containing a person of interest, or to validate a new hire against an internal list |
| Unblock a false positive | Add the visitor's email to an **always allow** list. **Cannot be set to Always allow**: individuals-watchlist *email* matches, company-watchlist entry matches, and notify-watchlist entry matches |

## Self-Service Kiosk

A mobile app on an iPad for visitor centres and gated facilities where guests check themselves in.

Check-in methods: scan the invitation QR code, or find the visitor another way. **Visitors can check in up to 1 hour before a visit event.**

Two documented check-in scenarios:

1. **Paper badge** - visitor scans the QR code from the invitation email, takes a photo, and a badge prints with their name and event details.
2. **Cardholder credential** - the visitor is issued a Security Center SaaS credential.

**Self-registration** handles unplanned visitors who arrive without an invitation and are not found in the system, if the feature is enabled for the account. It is tied to a site, visitors are accepted automatically with default entry-level access, and **prefilled entries cannot be modified**.

### Kiosk setup

1. Enable **Wi-Fi** on the device before activation.
2. Add the iPad in ClearID and generate a **device activation code** - **site administrator only**.
3. Register and activate the device in the kiosk app. **A kiosk can be associated with one site at a time.**

**Customising** (site owners and account administrators): kiosk themes, logos, and personalised welcome and assistance messages shown during check-in and check-out. **Welcome screen images: 1440x360, maximum 1024 KB.** **Visitor badge logo: 230x100, maximum 500 KB.** Best practice is transparent PNG. **Kiosk option changes sync every 60 seconds.**

**Hard reset** the app when you hit problems selecting the printer, printing labels or listing people, or when moving a kiosk to another site. You need the Apple ID and Wi-Fi details, and only a site administrator can generate a new activation code. **The hard reset erases all application data, user data, and visit and check-in data.**

### Label printers

Two supported families: **Brother QL-820NWBc / QL-820NWB / QL-810W** and **Brother TD-4550DNWB**. Each supports **Bluetooth**, **Wi-Fi** and **Ethernet** modes.

- The **QL-820NWBc replaced the discontinued QL-820NWB**.
- Best practice for the TD-4550DNWB: **one label printer per kiosk, paired over Bluetooth**.
- In Wi-Fi or Ethernet mode **one printer can serve up to five kiosks**, and it must be on the same Wi-Fi network as the kiosks.
- Explicit warning for the TD-4550DNWB Ethernet mode: do not connect the product to certain LAN connections - see the source topic.
- Selecting a printer: kiosk app **Settings > ...**. For Wi-Fi or Ethernet you need the printer's **IP address** to verify the selection.
- **Test badge**: print one after initial setup and after replacing a label roll. Make sure labels are loaded and aligned. QL-820NWBc / QL-820NWB / QL-810W print **62 mm Black (Brother DK-2205)** or **62 mm Red and Black (Brother DK-2251)**.

### Kiosk stands

| Item | Part |
|---|---|
| Tabletop kiosk kit (iPad 10.9 inch Wi-Fi with AppleCare, printer not included) | CD-KIOSK-TABLETOP-KIT-V21 |
| Floor stand kit | See the source topic |
| Floor stand printer shelf | See the source topic |

Both stands support **portrait or landscape** iPad orientation; the tabletop stand rotates 90 degrees. Depending on printer size you may need to trim the floor stand's centre graphic panel for cable access. Dimension diagrams are in the source topics.

### Identity documents

The kiosk can read identity documents during check-in. **All identity-document processing happens locally on the iPad** - ID data and pictures are never sent to the cloud, which is the stated compliance and security position. The source topic lists supported document types by country or region, localised document names, supported side and orientation, and supported scripts.

## Identity synchronisation

Three routes. Pick one.

### 1. ClearID API

REST-first: ClearID is an API-first service and the web interface is built on top of the same REST API, so most web-interface functionality is reachable over REST. Design objectives are platform independence and standard REST semantics. Primary use is synchronising identities, but other scenarios are supported.

**Authentication** uses the **API integration key** with **OAuth 2.0** for non-user system connections. Store the key securely, never share it, and **update every application that uses it whenever you regenerate it**.

### 2. SCIM integration

Synchronises external identity attributes into ClearID identity attributes so they can drive role assignment and role-based access control.

- **Only Microsoft Entra ID is currently supported.** For another provider, contact your deployment representative.
- **ClearID does not support group synchronisation** - the Entra ID *Groups* setting in the enterprise application must be disabled.
- Most ClearID identity fields are **custom attributes** and must be prefixed with `urn:ietf:params:scim:schemas:extension:clearid:2.0:User`. The only fields used from the SCIM base schema are `active`, `username` and `displayname`.

Setup (ClearID deployment team, customer IT, or whoever administers Entra ID):

1. **Generate a SCIM key** - ClearID portal **Administration > SCIM Integration > Generate key**, name it (the docs' example is *GenetecSCIMIntegrationKey*). **Portal administrator only.**
2. **Create an enterprise application** in Microsoft Azure - **Enterprise applications > New application**.
3. **Connect** the integration by supplying the credentials in the Azure enterprise application.
4. **Disable the Microsoft Entra ID Groups setting.**
5. **Configure user settings and attribute mappings.**
6. **Configure synchronisation settings** on the Provisioning page - choose *Sync all users and groups* or a narrower scope - and activate provisioning.
7. **Review status** in the Azure provisioning logs to confirm the integration is working.

**Resetting SCIM identity data** replaces all SCIM identity data in ClearID from the current Entra ID values. Use it **only** to fix an identity-data problem - after manual manipulation, a discrepancy, or deleted data.

### 3. One Identity Synchronization Tool

A **Windows service** that imports identity information from an external system into ClearID.

Data sources: **Azure AD (Microsoft Entra ID)**, **Database** (Microsoft SQL Server, Oracle Database, ODBC) and **File (CSV)**. **Data source order matters - the first data source always overrides common fields.**

Components: **Genetec.ClearID.OneIdentity.SynchronizationTool** (the UI, OneIdentityConfigurationTool.exe) and **Genetec.ClearID.OneIdentity.SynchronizationService** (OneIdentityService.exe).

- **Install on its own dedicated server.** It does **not** need a Security Center SaaS server. The installer is **not** a public download - obtain it from your deployment contact.
- Attribute mapping requires a mandatory **Unique ID** field (alphanumeric) per identity.
- The **Azure web app** is what connects the tool to Azure AD data; you need the **tenant name (directory ID)**, **client ID** and **app key**, and the Azure AD API permissions must be in place.
- **CSV and other source files must be closed and not being edited** - the tool locks them during synchronisation.
- Synchronise manually with **Synchronize now** or automatically on an interval.
- **Upgrading**: back up \ProgramData\Genetec\OneIdentity\Configuration first - it holds ApiConfiguration.dat, ClearIdEntityMappingFile.xml, Configuration.xml and related settings.
- **Logging** uses Apache log4net, configurable independently for the service and the tool. Logs are split into **Configuration**, **Service** and a third folder; view them from the tool or on disk.
- **Updating existing identities**: when an external ID already exists in ClearID, that identity is updated with the values from the data sources. This matters for a newly installed service pointed at an environment that already holds those identities.

Check synchronisation status either in the tool's connection section or in the ClearID web portal.

## Webhooks

A webhook is a user-defined HTTP callback that ClearID fires when specific events occur, to notify third-party APIs.

- **Only an account administrator can create or modify webhooks.**
- The third party is responsible for building the API that consumes the callbacks.
- Create at **Administration > Webhooks > Add webhook**: an **Enabled** slider, a **General** section, **Additional headers**, and an **Event** section. Example events named in the docs: *Identity updated*, *Identity requests created*, *Identity requests updated*.
- After creation, the webhook service listens for the subscribed events.
- Disabling a webhook stops the HTTP callback entirely.
- **Logs** appear at the end of the webhook details **only after the first callback has occurred**, and show the status of every HTTP callback sent to the third-party URL. Visible to account administrators and third-party API owners.

## Custom fields in Security Center SaaS

ClearID writes to **custom fields** on visitors, credentials and cardholders. Those fields are grouped under the group name **ClearID**, visible in the Group name/Priority column.

**Treat ClearID custom fields as read-only.** ClearID populates and manages the values. If you already have custom fields whose **name and entity type match** the ClearID ones, ClearID will use yours - so make sure any custom fields you create do **not** collide, or your Security Center SaaS data can be overwritten during synchronisation.

Modify their visibility in Genetec Configuration desktop > **System > Custom fields**, double-clicking the Field name. Requires the *Modify custom field definitions* privilege, and **at least one identity must have synchronised** before any custom fields appear. A worked use case: show visit reason, registration code, expected arrival and expected departure to the security or reception group.

Cardholder custom fields created by ClearID include Company, Department, Employee Number, External ID, Home Site, Identity ID, Identity Management Status (type ClearIdManagementStateCustomType, default *Unreconciled*), Job Title and more - all in group **ClearID (1)**.

## Email notifications

ClearID emails on a defined set of events. Examples of triggers and recipients:

| Notification | Recipients |
|---|---|
| Account created for an identity | The identity - administrators only |
| Area access request submitted | The requester |
| Area access request cancelled | The requester, area approvers and area owners |
| Area access request requires approval or denial | Depending on workflow settings: supervisor and/or area approver. **No email if auto-approved** |
| Area access request approved or denied | The identity and the area owners |

The complete matrix is in the source topic.

## Troubleshooting

| Symptom | Cause and fix |
|---|---|
| **Visitors did not receive visit emails** | The visit event request was never approved. Review pending requests and approve the area access requests and visit events |
| **Visitor hosts fields empty in Genetec Operation** | The **Cardholder groups can escort visitors** setting is off. Turn it on in Genetec Configuration desktop > Access control > General settings > Visitors |
| **One Identity Synchronization Tool connectivity issues** | Check the API integration details or the Azure AD application connection details |
| **One Identity data synchronisation issues** | See the source topic's cause-and-solution list |
| **Self-Service Kiosk issues** | See the source topic; a hard reset is the escalation path |
| **Self-Service Kiosk label printer issues** | See the source topic; check labels loaded and aligned, printer mode, and IP address for Wi-Fi/Ethernet |
