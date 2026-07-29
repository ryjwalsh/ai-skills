# Known gaps

What this skill cannot answer from its sources. When a question lands here, say so plainly and give the user the next place to look rather than improvising.

## Not captured in the portal walkthrough

| Gap | What to say |
|---|---|
| Field-level contents of **Organization > Identity templates** | The tab and its route are confirmed; the individual settings inside a template were not recorded. Point the user at the tab and ask them to read the form. |
| Field-level contents of **My workspace > Requests / Tasks / Visits** beyond the visible action buttons and status filter | Confirm the location, then say the column and filter set was not recorded. |
| **My Profile** sub-routes for Delegations, Direct reports and Credentials | The tabs exist; their URL suffixes were not recorded. Give the tab name only. |
| Webhook **log** viewing in the portal | The documentation has "Viewing webhook logs in ClearID" but the walkthrough did not record where the log view lives in the Webhooks tab. Say it is reached from Administration > Webhooks and hand over the topic. |
| Any per-record dialog: create-site wizard, create-area wizard, invite-visitor form, request-access form | Only the settings pages were walked. Do not invent field lists for wizards. |
| Role-based visibility of tabs | Which tabs a non-administrator actually sees was not tested. The map reflects an administrator's view. |

## Not read in full from the documentation

The titles and locations of all 142 topics are known, but only nine topic bodies were read (listed at the end of `references/techdocs-index.md`). For anything procedural in the other 133 topics - step-by-step install of the One Identity Synchronization Tool, the exact Azure enterprise-application steps, Qscan and STid reader configuration, individual printer setup, nested-area behaviour, automatic area access granting - give the location and the TechDoc slug and let the user read the steps.

## Genuinely absent from these sources

| Subject | Note |
|---|---|
| ClearID REST endpoint list, request and response schemas, rate limits, auth flow detail | The publication describes the API only in concept. The developer portal is the source, and it was out of scope. |
| Webhook payload schemas per event | The documentation states that a schema describes the object sent, but the schemas themselves were not captured. |
| Licensing, part numbers, commercial packaging | Not in this publication. |
| SLA, data residency detail beyond the four regional portal hosts, retention defaults other than the per-site visitor retention setting | Not in this publication. |
| Security Center / Synergis-side configuration except where the ClearID docs call it out (QR custom card format import, custom fields in Genetec Configuration desktop, nested areas) | Use the Security Center documentation set instead. |
| Exact e-mail templates and their wording | Only the event-to-recipient matrix and the per-site customization location are known. |
| SMS provider, coverage and cost for visitor check-in SMS | The setting location is known; the service behind it is not documented here. |
| Audit retention periods for Site activity, User activity and identity Logs | Locations known, retention not documented. |
| Behaviour when the Security Center plugin is offline - queueing, retry, conflict resolution | The Systems page reports last plugin response and last plugin query, but the failure semantics were not captured. |

## Version and drift risk

ClearID ships continuously and has no version number to pin to. Labels, tab order and routes were true on **2026-07-29**. Two specific drift risks worth flagging when answering:

1. The **Identity synchronization** tab is externally labelled that way but internally still called "Unified Sync", which suggests the feature is recent and may be renamed again.
2. **Preview features** exists in the user menu, so a tenant may legitimately show controls that are not in this map, and may not show controls that are.

When a user reports that a path does not match, treat the tenant as correct, tell them the map is dated, and ask what they see.
