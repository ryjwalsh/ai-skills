---
name: motorola-tool-hub
description: Index/router for the Motorola Solutions Video Security & Access "Tool Hub" (loginvsa.motorolasolutions.com) and every portal behind its 17 tiles - Avigilon Documentation (docs.avigilon.com), Support Community, Software Download, Camera Configuration Tool, System Design Tool, Alta Access/Video Support, Alta DMP, Compass, Envysion, IndigoVision, Learning Center, Pelco Calipsa/Camera Configuration/Software Download/Support Community, Videotec. Use it to decide which product skill applies (avigilon-unity, avigilon-alta, pelco, indigovision, compass, envysion, videotec) and where a technician should log in, download, open a case or find a manual. Trigger on Tool Hub, loginvsa, "where do I download/find/open a case", Motorola Solutions video security portals, or any product name in this family when the specific skill is unclear.
---

# Motorola Solutions VS&A Tool Hub - index skill

The **Tool Hub** (https://loginvsa.motorolasolutions.com/s/) is the single-sign-on launcher for Motorola Solutions' video security and access control brands: Avigilon Unity, Avigilon Alta, Pelco, IndigoVision, Compass, Envysion and Videotec. Its 17 tiles fan out to documentation sites, support communities, download portals, design tools and training. This skill maps each tile to its destination and hands the question to the right product skill. [S1]

## Scope and freshness
All tiles were opened and their destinations recorded on **2026-09-14**. Tile names or destinations may change; when a tile is missing, use `references/portal-directory.md` URLs directly.

## Routing table
| The question is about… | Use skill | Primary portals |
|---|---|---|
| Unity Video 8 / ACC 7 Client, Server, Admin Tool, Software Manager, licensing, multi-server, Unity Cloud, Web Endpoint, Unity Access (ACM) + Mercury, H4/H5/H6 camera web UI, CCT, NVR6/AI NVR/ENVR/HDVA appliances, ports, hardening, OS recovery | **avigilon-unity** | docs.avigilon.com, support.avigilon.com, avigilon.com/software-downloads, licensing.avigilon.com, cloud.avigilon.com |
| Alta Access (Openpath) web/mobile apps, ACU/SDC/Smart Hubs/readers, Alta Video (Ava) cloud VMS, cloud cameras, Cloud Connectors, Alta Protect, DMP, Alta Open app | **avigilon-alta** | alta.avigilon.com, docs.avigilon.com (Alta bundles), support.avigilon.com, dmp.alta.avigilon.com |
| VideoXpert (VxToolbox, VxOpsCenter, VxPro/VxE, VxStorage), Sarix/Spectra/Optera cameras, Pelco CCT, Pelco licensing, Calipsa | **pelco** | support.pelco.com, pelco.com/updates, pelco.com/docs, pelco.com/camera-configuration-tool, licensing.pelco.com |
| IndigoVision Control Center, NVR-AS, Site Database Server, License Server, FrontLine, CyberVigilant | **indigovision** | docs.avigilon.com/category/indigovision, partners.indigovision.com |
| Compass Decision Management System (PSIM), Compass drivers | **compass** | partners.indigovision.com, avigilon.com/fs/documents/MSI-Compass-* |
| Envysion app, EnVR, POS reports, Smart Site Protection | **envysion** | learning.envysion.com, video.envysion.com |
| Videotec housings / PTZ positioning units | **videotec** | support.pelco.com |
| System Design Tool, Learning Center, generic "where do I log in" | this skill | sdt.motorolasolutions.com, learningcenter-vsa.motorolasolutions.com |

## Tile map (17 tiles)
| Tile | Destination |
|---|---|
| Alta Access Support · Alta Video Support · Avigilon Support Community | https://support.avigilon.com/s/ (Avigilon Support Community; SSO) |
| Alta DMP | https://dmp.alta.avigilon.com/login |
| Avigilon Camera Configuration | https://www.avigilon.com/security-cameras/configuration-tool |
| Avigilon Documentation | https://docs.avigilon.com |
| Avigilon Software Download | https://www.avigilon.com/software-downloads |
| Avigilon System Design Tool | https://sdt.motorolasolutions.com (OAuth) |
| Compass Documentation & Software | https://partners.indigovision.com |
| Envysion Training & Support | https://learning.envysion.com |
| IndigoVision Documentation | https://docs.avigilon.com/category/indigovision |
| Learning Center | https://learningcenter-vsa.motorolasolutions.com |
| Pelco Calipsa Support · Pelco Support Community · Videotec Support | https://support.pelco.com/s/ (Pelco Support Community; SSO) |
| Pelco Camera Configuration | https://www.pelco.com/camera-configuration-tool/ |
| Pelco Software Download | https://www.pelco.com/updates/ |

## Answer contract
Answer "where" questions with the portal URL, the tile name, what the technician needs to have (SSO account, partner login), and then hand off: "For the actual setting, see the avigilon-unity skill (Site Setup > …)". Do not answer deep product questions from this skill.

## Where to look
| Question | Open |
|---|---|
| Tile → URL table with notes on what each portal contains | `references/tool-hub-map.md` |
| Directory of every portal by need (docs, downloads, licensing, support, cloud, training, phones) | `references/portal-directory.md` |
| Sources | `sources.md` |

## Working rules
- Portal facts trace to `sources.md` (verified by opening the tiles). Anything not verified is **[INFERRED - verify]**.
- Never guess a login method; SSO tiles go through loginvsa `/idp/login?app=…`.
