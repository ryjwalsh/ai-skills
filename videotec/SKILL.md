---
name: videotec
description: Where to get help for Videotec (Motorola Solutions / Pelco family) rugged, explosion-proof and PTZ camera housings, positioning units and washers - support runs through the Pelco Support Community (support.pelco.com) via the Tool Hub "Videotec Support" tile, with product manuals on videotec.com and Pelco portals. Use whenever Videotec, Ulisse, Maximus, NXPTZ, Verso, Punto, MPX housings, or explosion-proof/rugged PTZ support questions come up.
---

# Videotec support

Videotec (Schio, Italy) is the Motorola Solutions brand for rugged, marine, explosion-proof (ATEX/IECEx) and heavy-duty PTZ positioning units, housings, washers and illuminators - product lines such as **Ulisse** (PTZ/positioning), **Maximus** (explosion-proof MPX/MVX/MHX), **NXPTZ**, **Verso / Punto / Housings**, wash systems and Wiper/illuminator accessories. Since the Pelco/Videotec integration, technical support is delivered through the **Pelco Support Community**: the Tool Hub tile "Videotec Support" opens https://support.pelco.com/s/. [S1]

## Scope and freshness
Portal verified 2026-09-14 from the Motorola Tool Hub. No Videotec product manuals were captured in this skill - it is a routing skill. For product configuration (Videotec web interface, ONVIF settings, RS-485 protocols, wiring, heater/wiper/washer control) point to the product manual and to the VMS-side notes in the pelco / avigilon-unity skills (Videotec MACRO and Legacy PTZ protocols are selectable in Unity Video: Site Setup > [camera] > General > Enable PTZ controls > Protocol).

## Quick facts
| Item | Value | Src |
|---|---|---|
| Support portal | https://support.pelco.com/s/ (Trust & Status, Ideas, Discussions, Groups, Learning Center, Videos, Returns, Software & Firmware; New Case) | S1 |
| Manuals / firmware | videotec.com product pages (manuals, firmware, CAD) [INFERRED - verify]; Pelco Document Center pelco.com/docs and pelco.com/updates for Pelco-branded Videotec models | S1 |
| Phone | Pelco product support 1-800-289-9100 (US/CA), +1-559-292-1981 international - see support.pelco.com article "Which-Is-the-Pelco-Technical-Support-Number" | S1 |
| VMS integration | ONVIF Profile S to Unity Video / VideoXpert / Alta Cloud Connector; analog PTZ via Videotec MACRO / Videotec Legacy protocol on Avigilon encoders | S2 |

## Answer contract
Route first (which portal, what to have ready: model, serial, firmware, wiring diagram, VMS in use), then hand off to the product manual; do not invent Videotec web-UI paths.

## High-frequency answers
| Question | Answer |
|---|---|
| Open a Videotec ticket | support.pelco.com > New Case (log in via Tool Hub SSO); include model/serial/firmware/photos |
| Firmware or manual | videotec.com product page or pelco.com/docs; RMA via support.pelco.com Returns |
| PTZ won't move from Avigilon Unity | Site Setup > [camera] > General > Enable PTZ controls > Protocol Videotec MACRO/Legacy, address, baud, parity (see avigilon-unity skill) |
| Check outages | support.pelco.com > Trust & Status |

## Working rules
- Facts trace to `sources.md`; anything about Videotec product internals is **[INFERRED - verify]**.
