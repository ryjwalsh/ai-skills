# Known gaps

What this skill cannot answer from its sources. Say so plainly and hand the technician the right bundle from `references/techdocs-index.md` instead of improvising.

## Read as table of contents only (bodies not captured)
| Subject | What to say |
|---|---|
| Unity Access **User Guide** 7.22 beyond admin topics (identities, roles/delegations detail, reports, elevator access levels, mustering, badge templates, event types) | Give the menu family (Identities / Roles / Reports / Physical Access) and point to `unity-access-user-7-22`. |
| Unity Video **Investigator / Security Operator** guides (search filters, export options, incident reports, redaction) | Search entry points are known (New Task > Search…); field-level options are in `unity-video-investigators-8-8`. |
| Web Endpoint API routes, event query / media API, webhooks vs Socket.IO | Only install/port/CORS/log config captured. Route list requires the Technology Partner Program docs. |
| System Design Tool 4 | TOC only (Designs, Map view, cameras, storage, licensing, export). No field detail. |
| ACC7 + ACM6 **Unification** guide | TOC only; the equivalent 8.8 flow is in the Client guide (ACM section). |
| Unity Access Mobile 1.18, Unity Video Mobile Android | TOC only; iOS 4.5 guide read for connection/troubleshooting. |
| Privilege Management (Unity Cloud roles/policies) | TOC + scenarios only. |
| Analytics site-design guide (lux, detection ranges, camera placement numbers) | TOC only. |

## Not read at all
| Subject | Bundle to open |
|---|---|
| Other appliance user guides: AI NVR 2X, AI NVR 2 Premium Plus / Standard / Value, AI Appliance 2/2X, ENVR2 Plus, ENVR1, ACC ES, NVR6/NVR5 Windows recorders, HDVA Series 3, workstations | `ai-nvr-2x-premium-form-d`, `ai-nvr-2-premium-plus-form-h`, `ai-appliance-2x`, `envr2-plus-appliance`, `nvr6-*`, `hdva-series-3-3x` … LED/reset steps differ per model; AI NVR 2 Premium Form D procedures are a close analogue for hardened-OS units. |
| Camera **installation** guides (mounting, dip switches on H4 IR PTZ, connector pinouts, physical reset button location per model) | `h6-a-dome-camera`, `h5-a-ptz-camera`, etc. |
| Fisheye, multisensor, pro, thermal, video intercom, Z-Wave camera web-interface guides | Layout matches the fixed/PTZ guides; model-specific pages (dewarp, head alignment, radiometry) not captured. |
| Third-party integration guides (CCure, OnGuard, Netbox, AMAG, Gallagher, Edesix, IP speakers, RadioAlert, ViRDI) | Titles only. |
| ACM 6.50 legacy guides, Unity Access 7.2-7.20 | Same navigation as 7.22 in most areas; verify labels. |
| Motorola Technical Notices (PDF) | Titles/numbers only. |
| Hardware upgrade kits (RAM, 10G, GPU analytics kits), storage expansion, Video Archive | Titles only. |
| Support Community knowledge articles | Not indexed; article numbers 8555, 9804, 9988, 10085, 10202 are cited by the guides. |

## Genuinely absent
| Subject | Note |
|---|---|
| Part-number pricing, license SKU commercial rules beyond those named | Not in documentation. |
| Support entitlement / RMA process detail | Only the phone number and community links. |
| Exact registry/config keys beyond those listed (LoginControlPolicy, EnforceUsernameOverlay, RequireKerberos, MinRetentionNotificationTimeoutMins, DisablePing, discovery enable keys, TransactIdleTimeout_s) | Do not invent others. |
| Camera firmware version-to-feature matrix | Use `camera-release-notes`. |
| Step-level Windows procedures for Dell BIOS/iDRAC/PERC beyond what the hardening/troubleshooting guides give | Refer to Dell documentation. |
