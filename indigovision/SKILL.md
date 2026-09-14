---
name: indigovision
description: Technician knowledge of IndigoVision (Motorola Solutions) Control Center video management - License Server, Site Database Server, NVR-AS (Windows and NVR-AS 4000 appliances), Control Center front-end/Client, Control Center Web and Mobile, Camera Gateway, Video Stream Manager, FrontLine body-worn, CyberVigilant, IndigoVision cameras (BX/GX/Ultra ranges) - install order, licensing (fingerprint/License Manager), upgrades 16→17+, firewall ports (8130/8131/8133/8135, UDP 49300…), NVR-AS 4000 web configuration, troubleshooting, and where the docs live (docs.avigilon.com IndigoVision category, partners.indigovision.com). Use whenever IndigoVision, Control Center (non-Avigilon), NVR-AS, Site Database Server, IndigoUltra/Pro/Lite, FrontLine, CyberVigilant or BX/GX cameras are mentioned.
---

# IndigoVision Control Center

IndigoVision (Edinburgh, acquired by Motorola Solutions in 2020) makes the **Control Center** VMS suite: a Windows front-end, a **Site Database Server** (+ Site Database Files share), **NVR-AS** recorders/alarm servers (software or NVR-AS 4000 appliances) and a **License Server**, extended by Camera Gateway, Video Stream Manager, Control Center Web/Mobile, FrontLine body-worn and CyberVigilant. Tiers are IndigoLite / IndigoPro / IndigoUltra. Documentation is hosted on the Avigilon Documentation Center under the IndigoVision category; software and partner docs are on partners.indigovision.com. [S1]-[S3]

## Scope and freshness
Built 2026-09-14 from the 28 IndigoVision PDF bundles on docs.avigilon.com: the Control Center Installation Guide v61 (2024) read in full; Operator's Guide, Web Admin, Site Database Server, License Server and Compact NVR-AS 4000 guides read at TOC level. Control Center 17.x/18/19-era navigation; older Control Center 15/16 differs (see upgrade notes).

## Quick facts
| Item | Value | Src |
|---|---|---|
| Docs | docs.avigilon.com/category/indigovision (User Guides / Datasheets); bundles `iv-*` | S1 |
| Software / partner portal | partners.indigovision.com ; KB "IndigoVision Software Downloads" on support.avigilon.com; technical.support@indigovision.com | S1, S3 |
| Install order | License Server → Site Database Server → NVR-AS → Control Center front-end | S2 |
| Licensing | License Manager tool: fingerprint file → IndigoVision Sales Orders (+ order ack number) → apply .lic; 45-day IndigoUltra trial (5 cameras, 1 Windows NVR-AS), one trial per machine; components keep a 30-day backup license if the License Server is unreachable | S2 |
| Key ports | License Server TCP 8133; Site Database Server TCP 8135 (+8134 MongoDB for failover); NVR control TCP 8130; Alarm Server TCP 8131; FrontLine TCP 8132; playback TCP 49299; device control UDP 49300; NVR events UDP 49301/49303; video TCP 49400-49402/49420-49422, multicast UDP 49400-49425; PTZ/serial TCP 49500-49509; ONVIF 80/443/554, WS-Discovery 3702 | S2 |
| Site DB tools | Start > IndigoVision > Site Database Server Setup (create/use/upgrade/failover) ; Control Center Setup (re-point a workstation) | S2 |
| NVR-AS (Windows) | NVR-AS Administrator (Video Library UNC path by IP/FQDN, never mapped drive); service "IndigoVision NVR-AS"; authentication mandatory from 17.1 | S2 |
| NVR-AS 4000 appliance web pages | Home, Network, Date & Time, Disk, NVR, Alarms, Status Monitoring, Network Security, Email, Bandwidth Management, License, Firmware Upgrade, Diagnostics (http(s)://<appliance>) | S6 |

## Answer contract
Give the component first, then the tool/menu, then the field: "On the Site Database Server host open **Start > IndigoVision > Site Database Server Setup > Use an existing site database > License Server page** and change the IP." For ports give protocol, number and direction (who initiates). Say which Control Center version the answer was written for (v17.1+ 64-bit). If the page was not read (most operator/admin how-to bodies), name the guide and section title from the TOC instead of inventing steps.

## Where to look
| Question | Open |
|---|---|
| Components, architecture, install steps per component, site database create/failover/segmentation, NVR-AS video library, upgrades 15/16/17→current, install troubleshooting, the complete firewall port tables, NVR-AS 4000 web pages, front-end panel/menu map and troubleshooting topics | `references/control-center-install-ports.md` |
| Which of the 28 documents to hand over | `references/techdocs-index.md` |
| Sources / gaps | `sources.md`, `known-gaps.md` |

## High-frequency answers
| Question | Answer |
|---|---|
| "Unable to contact the License Server" | License Server service running + valid license; open TCP 8133 both directions between the client/NVR and the License Server |
| Trial license expired / no trial after reinstall | trial is one-time; request a full license via License Manager fingerprint |
| Move Control Center to a new Site Database Server | Start > IndigoVision > Control Center Setup on each workstation |
| Change License Server IP in the site database | Site Database Server Setup > Use an existing site database > License Server page |
| Add a failover Site Database Server | install Site Database Server on a second PC > "Configure as a failover Site Database Server" > primary FQDN + Site Database Server Administrator creds; open TCP 8134/8135; sync the Files share yourself |
| Record to a NAS | NVR-AS service Log On account with share rights → NVR-AS Administrator > Video Library = \\ip-or-fqdn\share > Set > restart service |
| Cameras won't authenticate after 17.1 upgrade | enable "allow unauthenticated access" on each NVR-AS during migration, upgrade all front-ends, then set NVR-AS credentials + Device Access credentials in Control Center |
| Site database cannot be edited | user needs share Full Control + NTFS synchronize/read/write-attributes/delete/change-permissions |
| Control Center Web login/video problems | see Web Admin Guide troubleshooting list (Windows auth login, service unavailable, no live video, PTZ presets, Mobile certificate install) |
| Where are the manuals / software | docs.avigilon.com IndigoVision category; partners.indigovision.com; support.avigilon.com article "IndigoVision Software Downloads" |

## Working rules
- Facts trace to `sources.md`; **[INFERRED - verify]** marks anything else.
- Only the Installation Guide was read in full; operator/admin bodies were not - quote TOC section titles, do not fabricate click paths.
- Read-only knowledge; flag destructive actions (deleting site database files, disk format on NVR-AS, factory reset).
