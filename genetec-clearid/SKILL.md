---
name: genetec-clearid
description: Complete working knowledge of Genetec ClearID in Security Center SaaS - the ClearID web portal navigation map (every menu, tab, route and setting), access/role/identity/visit request workflows, visitor management and the Self-Service Kiosk, visitor watchlists, webhooks and the ClearID API, SCIM and local-agent identity synchronization, custom fields, reports, notifications and permissions. Use whenever ClearID, portal.clearid.io, Self-Service Kiosk, visit profile, visitor watchlist, access review, SCIM key, One Identity Synchronization Tool, local agent sync, or any "where do I find / configure X in ClearID" question comes up.
---

# Genetec ClearID (Security Center SaaS)

ClearID is the Genetec cloud service for identity management, self-service access requests and visitor management. It layers request-and-approval workflows on top of Security Center / Synergis: people ask for access in the ClearID web portal, approvers act on the request, and ClearID pushes the resulting cardholder and credential changes down into the access control system. Door decisions and credential enforcement stay in Security Center. [S1] [S4]

## Scope and freshness

Built from two inputs, both captured **2026-07-29**:

1. The Genetec TechDoc Hub publication *Genetec ClearID in Security Center SaaS* - 142 topics across Getting started, Requirements, Managing identities and users, Managing sites, Managing areas, Managing visitors, Managing visitor watchlists, Synchronizing data, Self-Service Kiosk and Troubleshooting. [S1]
2. A complete operator walkthrough of a live ClearID tenant, recording every sidebar item, tab, sub-tab, route and setting group. [S2]

ClearID is continuously delivered, so there is no product version to pin an answer to. Where a label may have been renamed since capture, say so and tell the user to confirm in the tenant.

## Quick facts

| Item | Value | Src |
|---|---|---|
| Portal hosts | United States `https://portal.clearid.io/`, Canada `https://portal.ca.clearid.io/`, Europe `https://portal.eu.clearid.io/`, Australia `https://portal.au.clearid.io/` | S3 |
| Route pattern | `https://<host>/{accountId}/{page}` - the account ID appears in the URL of every page and changes with the account you are signed in to | S3, S2 |
| Landing page | *My requests* (`/requests`) after logon | S3 |
| Multi-tenant switching | User name button (bottom left) > **Change account** | S3, S2 |
| Logon prerequisite | Cookies must be enabled in the browser. With corporate SSO (Microsoft 365 or similar) the account is activated automatically and no activation e-mail is sent | S3 |
| Network requirements | Portal: TCP 443 outbound to `*.clearid.io`, `*.core.windows.net`, `*.launchdarkly.com`. One Identity Synchronization Tool: TCP 443 outbound to `*.clearid.io`. Self-Service Kiosk: TCP 443 outbound to `*.clearid.io` and `*.azurewebsites.net` | S5 |
| Kiosk hardware | Apple iPad 10.9 in. (certified, iOS 16.1+) and iPad 10.2 in. (certified, no longer sold with the stand). Other iPads may work without the kiosk stand | S6 |
| API | ClearID is API-first; the web portal is built on the same public REST API. Machine-to-machine keys are created as API integrations | S7, S2 |
| Identity document scanning | All identity-document processing happens locally on the kiosk iPad - ID data and pictures are never sent to the cloud | S8 |

## Answer contract

Every "where is it / how do I get to it" answer must give a full breadcrumb, and the route when known:

> To find the active Entra ID SCIM keys, go to **Access Management > Administration > SCIM integration > Active keys** (`/{accountId}/administration/scim`).

Rules for the breadcrumb:

- Start at the sidebar group name, either **My workspace** or **Access Management**.
- Use `[site]`, `[area]`, `[person]`, `[role]`, `[profile]` as placeholders for records the user picks.
- Name the tab, then the sub-tab, then the settings card or field - do not stop at the tab.
- If the setting exists in more than one place (for example request approval workflow, which is set per area and per role), give every location and say what each one governs.
- If the setting lives in Security Center / Config Tool rather than ClearID, say so explicitly instead of inventing a ClearID path.

## Portal map at a glance

Left sidebar, two groups. Bottom left holds **Help** and the user name button.

| Group | Item | Route |
|---|---|---|
| My workspace | Requests | `/requests` |
| My workspace | Tasks | `/tasks` |
| My workspace | Visits | `/visit-events` |
| Access management | Organization | `/organization` |
| Access management | Reports | `/reports` |
| Access management | Administration | `/administration` |

**Help** opens the Help Center panel with Home/News tabs plus User guide, Support contact and Privacy policy links. The **user name** button opens My Profile, Preview features, Preferences, Change account and Log off. [S2]

Administration has ten tabs: Systems, API integrations, Webhooks, Permissions, Credentials, Account configuration, Notifications, Custom fields, SCIM integration, Identity synchronization.

Organization has seven tabs: Sites, Areas, Identities, Roles, Watchlists, Identity templates, Access reviews.

Reports has eight tabs: Access reviews, Access requests, Identity requests, Visitors, Site activity, Site and Area owners, User activity, Role requests.

## Where to look

| If the question is about... | Open |
|---|---|
| Any "where is X" / "how do I get to X" question, every route, tab, sub-tab and settings card in the portal | `references/navigation-map.md` |
| Fast keyword lookup: a control name or a piece of jargon straight to its breadcrumb | `references/where-is-it-index.md` |
| What a feature *is* and how it behaves - request and approval workflows, watchlist screening, webhook events, credential sync, kiosk check-in, notification recipients, ports and supported devices | `references/concepts-and-workflows.md` |
| Identity data in and out: SCIM with Microsoft Entra ID, local agent CSV sync, One Identity Synchronization Tool, the ClearID API, custom fields | `references/synchronization-and-integration.md` |
| Deep-linking to the official topic for a subject, or telling the user what to read next | `references/techdocs-index.md` |
| Source documents and retrieval dates | `sources.md` |
| What is not documented or not verifiable from these sources | `known-gaps.md` |

## High-frequency answers

| Question | Breadcrumb |
|---|---|
| Active Entra ID / SCIM keys | Access Management > Administration > SCIM integration > Active keys |
| Generate a new SCIM key, or force reset and replace | Access Management > Administration > SCIM integration |
| Where the Local Agent API key lives | Access Management > Administration > API integrations |
| Download the local agent for CSV sync | Access Management > Administration > Identity synchronization > Download local agent |
| Turn off a user's portal login | Access Management > Organization > Identities > [person] > User permissions > Web portal access |
| Make somebody a ClearID administrator | Access Management > Administration > Permissions > Administrators |
| Let managers see their direct reports | Access Management > Administration > Permissions > Supervisors |
| How long pending access requests stay open | Access Management > Administration > Account configuration > Request expiry > Accesses |
| Change the portal theme, logo or accent colour for everyone | Access Management > Administration > Account configuration > Branding |
| Hide the "Invite visitors" or "Request access" buttons | Access Management > Administration > Account configuration > Request visibility |
| Add a webhook and choose its event | Access Management > Administration > Webhooks > Add webhook > Event |
| Turn account-wide e-mails on or off, or allow opt-out | Access Management > Administration > Notifications |
| Create a custom field | Access Management > Administration > Custom fields > Add custom field |
| Check whether ClearID or Security Center owns cardholders | Access Management > Administration > Systems > [system] > Cardholder and credential management |
| Credential sync mode and its logs | Access Management > Administration > Credentials |
| Change the kiosk welcome image | Access Management > Organization > Sites > [site] > Visitor management > Kiosk welcome screen |
| Kiosk or iPad activation code | Access Management > Organization > Sites > [site] > Devices |
| Cap how long site access can be granted for | Access Management > Organization > Sites > [site] > Access configurations > Access duration time limit |
| Who can invite visitors, and the visit approval workflow | Access Management > Organization > Sites > [site] > Visitor management > [visit profile] > Planned visits |
| Enable QR code credentials for visitors | Access Management > Organization > Sites > [site] > Visitor management > [visit profile] > General profile configurations > Access control |
| Set the area approval workflow and which credential types can be requested | Access Management > Organization > Areas > [area] > Access request configurations |
| Add an area owner or area manager | Access Management > Organization > Areas > [area] > Permissions |
| Expose an area to visitors and allow pre-authorization | Access Management > Organization > Areas > [area] > Visitor management |
| See or revoke a person's access | Access Management > Organization > Identities > [person] > Access |
| Extended grant time, cardholder activation and expiration | Access Management > Organization > Identities > [person] > Access control |
| Role membership, owners and provisioning rules | Access Management > Organization > Roles > [role] > Members / Permissions / Provisioning policy |
| Screen a person against watchlists by hand | Access Management > Organization > Watchlists > Manual screening |
| Schedule or configure an access review | Access Management > Organization > Access reviews > Schedule access review / Configure |
| Export any report to CSV | Access Management > Reports > [report tab] > Download CSV |
| Change my own language, theme or e-mail opt-ins | User name > My Profile > Preferences |

## Working rules

- Facts trace to a source ID in `sources.md`. Anything marked **[INFERRED - verify]** was not stated in a retrieved source or seen in the portal.
- Never invent a route. If a path was not observed, say the tab it lives under and tell the user to confirm, or point them at the TechDoc topic in `references/techdocs-index.md`.
- Two routes are deliberately unintuitive and are a common source of wrong answers: **API integrations** is `/administration/service-principals`, **Roles** is `/organization/teams`, **Areas** is `/organization/locations` and **Identity synchronization** is `/administration/sync` (its internal tab name is "Unified Sync").
- This skill is read-only knowledge. It never instructs an agent to change tenant configuration on its own initiative; it explains where a human makes the change.
