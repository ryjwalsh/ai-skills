# Architecture, clients and platform

## What the product is

Security Center SaaS delivers physical security as a service on a hybrid-cloud architecture. It unifies video, access control, intrusion detection, intercom and visitor management, and it deliberately places workloads where they make sense: some on premises or at the edge, some in the Genetec cloud, and often both at once. The stated design goals are cybersecurity, privacy, and removing the operational burden of running the platform yourself. [S1]

The architecture has three tiers:

- **Cloud** - the Security Center SaaS services themselves (Directory-equivalent, video services, intrusion role, Map Manager, Automation Manager, and the identity layer at login.genetec.com), hosted in Microsoft Azure regions.
- **On premises / edge appliances** - Genetec Cloudlink appliances (video recording and redirection, access control via Synergis Softwire, intrusion bridging), Synergis Cloud Link appliances, and Axis Powered by Genetec door controllers.
- **Direct-to-cloud (D2C) devices** - cameras, intercoms and speakers that connect to the cloud without an on-premises appliance. [S1] [S2]

## Editions - keep them apart

| | Security Center SaaS | Security Center SaaS Edition (Classic) |
|---|---|---|
| What it is | Cloud-native service described by this skill | Older hosted deployment of Security Center |
| Appliances | Genetec Cloudlink, Synergis Cloud Link, Axis Powered by Genetec | Synergis Cloud Link, Cloud Link Roadrunner |
| Clients | Web client + Genetec Configuration/Operation desktop + SC SaaS Operation mobile | Config Tool / Security Desk |
| Documentation cues | "Configuration task", "Genetec Configuration desktop" | "Config Tool", "Security Desk", "hosted system" |

KBA-79003, KBA-79126, KBA-79183, KBA-79192 and the cipher-suite change notice are **Classic-only**. KBA-79210 and KBA-79217 apply to both. [S12] [S13] [S14] [S15] [S16] [S17] [S29]

## Clients

| Client | Purpose | Notes |
|---|---|---|
| Security Center SaaS (browser) | Day-to-day administration and monitoring: Configuration, Tiles, Maps, Investigation, Front desk, Reports, Access control | Requires cookies and JavaScript enabled |
| Genetec Configuration desktop | Full administrative surface. Holds features absent from the web client: **Map designer**, **Automation**, advanced user settings, Mercury controller management, intrusion detection configuration, custom fields, threat-level definition | Windows |
| Genetec Operation desktop | Operator features absent from the web client: dashboards, people counting, activity trails, full PTZ control, several report tasks | Windows |
| SC SaaS Operation (mobile) | Field use: video, notifications, alarms, location sharing so operators appear on georeferenced maps | iOS and Android |

Desktop clients and the mobile apps are downloaded from the Welcome page or the navigation menu of the web client. Administrator rights on the workstation are **not** required to deploy the clients. [S1] [S2] [S6]

**Rule of thumb:** if a task involves designing maps, building automations, defining threat levels, editing privileges at the partition level, or touching Mercury/intrusion hardware, it happens in Genetec Configuration desktop.

## Data centre regions

Your tenant lives in exactly one region, chosen so data stays inside the required geography. [S2]

| Region | Sign-in host |
|---|---|
| Australia | https://au.securitycentersaas.genetec.cloud/ |
| Canada | https://ca.securitycentersaas.genetec.cloud/ |
| Europe | https://eu.securitycentersaas.genetec.cloud/ |
| United Kingdom | https://uk.securitycentersaas.genetec.cloud/ |
| United States | https://us.securitycentersaas.genetec.cloud/ |

The generic entry point securitycentersaas.genetec.cloud routes users to the right region. Full URLs include the tenant ID, e.g. https://us.securitycentersaas.genetec.cloud/{TenantID}/apps - that tenant ID also appears in SIP endpoint names for intercoms and speakers. Physical storage locations are documented in the Genetec Subprocessors list rather than in the product docs. [S2]

Each region has its own internal endpoint prefix, which is the single most useful thing to know when reading the port tables:

| Region | Video/TDS prefix | RTSP host | Blob prefix |
|---|---|---|---|
| US | eastus2 / eastus2 | rtsp.eastus2.video.genetec.cloud | eus2scsaasNN |
| Canada | centralca / cancentral | rtsp.centralca.video.genetec.cloud | cacscsaasNN |
| Australia | eastau / australiaeast | rtsp.eastau.video.genetec.cloud | auescsaasNN |
| Europe | westeu / westeurope | rtsp.westeu.video.genetec.cloud | weuscsaasNN |
| UK | southuk / southuk | rtsp.southuk.video.genetec.cloud | sukscsaasNN |

See `requirements-and-ports.md` for the complete tables. [S2]

## WebRTC video path

Web clients can pull video peer-to-peer over WebRTC from Genetec Cloudlink appliances and supported direct-to-cloud cameras, which avoids a cloud round trip. [S1]

- Security Center SaaS acts as the **signalling server**, exchanging SDP and ICE candidates.
- **STUN** and **TURN** servers traverse NAT and firewalls (turn.video.geneteccloud.com, stun.relay.metered.ca, global.relay.metered.ca).
- The browser must be on the same network as the appliance or camera; otherwise both networks must allowlist a common TURN server.
- A camera or appliance can serve **only one** WebRTC stream. The first connecting user gets the direct peer-to-peer stream; later users fall back to the standard HTTPS stream served by Security Center SaaS.
- If WebRTC cannot be established at all, applications silently fall back to the HTTPS stream.

## Plans - Standard and Premium

Premium is explicitly required for:

- **Intelligent search** in both the Tiles task and the Investigation task. [S9]
- **Visual trajectory**. [S9]
- **Automatic user provisioning (SCIM 2.0)** with Microsoft Entra ID or Okta, which additionally needs at least an Entra ID P1 plan or an Okta Essential/Professional/Enterprise licence. [S24]

The authoritative boundary is the Security Center SaaS Features Matrix, which also lists the differences against Security Center on-premises. Federation is **not** automatically licensed - check the subscription. [S2] [S10]

## Genetec Clearance and video sharing

Security Center SaaS embeds a slice of Genetec Clearance so operators can share video clips with internal and external recipients from the browser. [S1] [S9]

- Every subscription includes file sharing with a **14-day retention** period for an unlimited number of clips.
- Maximum shareable clip length is **1 hour**.
- The person who shares gets Manage permission on the file; recipients do not need a Security Center SaaS account.
- Recipient access levels are View, View and download, Edit, Manage.
- Notification emails come from noreply@clearance.network.
- The full Clearance evidence-management product is **not** included in the subscription; only the sharing capability is.

## Access model at a glance

- **Users** - people who can sign in. Each needs a login.genetec.com account (they are prompted to create one if absent).
- **Groups** - collections of users that pass down properties and privileges; a user can belong to several.
- **Cardholders** - people who badge through doors; tracked, not sign-in accounts.
- **Roles** - Owner, Administrator, Operator, Front desk - preconfigured bundles of privileges and access rights.
- **Privileges** - what a user may do. **Access rights for partitions** - which entities they may do it to.

Details and inheritance rules are in `users-and-authentication.md`. [S6]

## Subscribing to system notifications

Administrators subscribe themselves (settings are per signed-in user) from **Configuration > user account icon > Settings**, choosing which system events generate email - offline-device notifications being the common one. [S25] Platform-wide availability and incident history live at status.genetec.com, which also offers subscriptions by email, SMS, Teams and other channels. [S21]
