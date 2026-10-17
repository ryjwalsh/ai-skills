---
name: vaidio-technical-training
description: Hands-on configuration knowledge of the Vaidio AI Vision Platform from the Vaidio University Technical Certificate Track (TT1-TT14) - adding cameras by ONVIF or RTSP, Admin Portal network/NTP/upgrade settings, the Add/Edit Camera > AI Model / Profile / AI Engines workflow, per-engine setup and tuning for Intrusion (ID), Object Counting (OC), Object Wrong Direction (OWD), Object Left Behind (OLB), Crowd (CD), Dwell (DD), Person Fall (PF), Face Recognition (FR), License Plate Recognition (LPR), Human Attributes (HA) and Object Detection/Video Search, parameter defaults (confidence 0.50, min 30 px, sensitivity 5 scenes/10 s, dedupe, cooldown 9 s, FR 64x64, LPR 30% and 40x20 px, HA 200x200, Person Fall 100x100), dashboards/history/search, alert rules and triggers, the POC/demo playbook and troubleshooting. Use whenever someone is setting up, demoing, tuning or troubleshooting a Vaidio analytic, asks how to add a camera, where a setting lives in the Vaidio UI, what a default or minimum pixel size is, why detections or alerts are missing, or mentions Vaidio University technical courses or a Vaidio POC.
---

# Vaidio Technical Training (Vaidio University Technical Track)

Field knowledge from the 14 Vaidio University technical courses: how an integrator actually configures Vaidio Core in the browser, analytic by analytic, and how to run a proof of concept. It complements the sibling `vaidio` skill (vendor PDFs: install, ports, upgrade, operations, API) and the `vaidio-sales-track` skill (positioning, licensing, sizing). [TT1]-[TT14]

## Scope and freshness
- Captured **2026-10-17** from university.vaidio.ai (partner login). 14 courses, 174 lessons; **144 captured** (TT1 lesson 8 partial, TT2 lessons 1-13 not captured - see known-gaps.md).
- Courses TT3-TT14 are written lessons with check-in questions; TT1-TT2 are screen recordings of **Vaidio 7.2.0-1**, transcribed from burned-in captions. UI names are therefore 7.x-9.x; 8.1 redesigned the `Edit Camera` page and 10.0 changed the container model. **Verify menu names and defaults against the deployed version.**
- The courses never state a software version for the written lessons; where a default is "not stated" the references say so - do not invent one.

## Quick facts
| Item | Value | Src |
|---|---|---|
| Core web UI / Admin Portal | `http://<ip>/login` ; `http://<ip>:8000/` (`/system/`: NIC, static/DHCP, `Time Zone`, NTP `pool.ntp.org`, `Upgrade` online/offline, `Factory Reset`) | TT1 |
| Post-login landing page | `Search` - Video Search is on for every class of the camera's model with no engine enabled | TT2 |
| Add camera (ONVIF) | `Camera` > `Add Camera` > `Type` `Camera IP Address/Domain Name` > IP + web port (usually `80`) + credentials > `Get RTSP` > pick main stream > `Preview` > `OK`; needs camera ports `80` **and** `554` reachable | TT1 TT2 TT14 |
| Add camera (RTSP) | `Type` `RTSP` > `rtsp://<ip>:<port, usually 554>/<vendor path>` + credentials > `Preview` > `OK`; test the URL first in VLC `Media > Open Network Stream` | TT2 TT14 |
| Universal analytic workflow | `Edit Camera > Advanced`: confirm `AI Model` (`PowerModel-...`) > gear `Profile` (classes, `Confidence[0.01 ~ 1.00]` default `0.50`, `Minimum ~ Maximum pxl` default `30`/none) > `AI Engines` tick > engine tab > pencil draw ROI/line > ✓ > wrench rules > `Save` > `OK` | TT1 TT2 TT9 |
| Engine tab codes | `ID` Intrusion, `OC` Object Counting, `OWD` Wrong Direction, `OLB` Left Behind, `CD` Crowd, `DD` Dwell, `PF` Person Fall, `FR`, `LPR`, `HA`; also seen `PC`, `PWD`, `MMR` | TT1-TT13 |
| ROI rule defaults (7.2 UI) | `Sensitivity` `5` scenes `(1~20)` every `10` s `(1~30)` = 2 fps, 5 of 20 frames, 2.5 s to trigger; fast option `2` in `5` s = 1 s; `Dedupe Events` ON; `Cooldown Interval` `9` s, `1 ~ 3,600` | TT1 TT2 TT9 TT14 |
| Max object types | 10 per Intrusion/Dwell/OLB ROI and per OC/OWD line | TT9 TT6 TT12 TT11 TT10 |
| Pixels on target | 30x30 px general (lowerable to 10); FR face 64x64 default / 100x100 recommended; LPR plate 40x20; HA person 200x200 (to 600); Person Fall 100x100 | TT13 TT3 TT4 TT7 TT8 |
| Camera baseline | 2 MP (1920x1080) minimum for most use cases; FR frontal at 6-8 ft; LPR frontal, low and close; crowd `Head` type when bodies occlude | TT14 TT3 TT4 TT5 |
| LPR modes | `Parking Lot` 1x (<10 mph) / `City Road` 2x (10-40) / `Highway` 3x (>40); 3 parking-lot channels ~ 1 highway channel; plate confidence default `30%` | TT4 TT1 |
| Where results appear | own pages: `Intrusion`, `Object Counting`, `License Plate Recognition`, `Face Recognition`, `Search`; `Abnormal` (`!`) dashboard aggregates Crowd, Dwell, OWD, OLB, Person Fall; every `History` tab looks back 30 days, most export to Excel | TT5-TT13 |
| Alerts | `Alert` (bell) > `Alert Rule` > `Add Alert` > `Define Rule` (`Alert Type` per engine, cameras/ROIs/lines/lists, `Schedule`) > `Trigger (Optional)` (`Email Notification` default; HTTP, Vaidio App, VMS) | TT1 TT4 TT9 |
| NVR / SMTP | external NVR = brand + IP + port + admin creds, 30-s clips, <=1-h import, 5-min retrieval cooldown, internal recorder licensed separately; SMTP under `System -> Mail` (IP, port, username, password, protocol) | TT14 |

## Where to look (decision table)
| If the question is about | Read |
|---|---|
| Which engine does what, tab codes, max object types, camera requirements, every default side by side | references/analytics-parameter-matrix.md |
| Where a page, tab, dialog or setting lives in the UI; URL paths; "how do I get to X" | references/ui-navigation-map.md |
| Admin Portal, Add Camera dialog fields, Profile dialog, custom AI models, LPR lists, event dashboards, `Add Alert` dialog (7.2 demo) | references/setup-overview-demo.md (TT1) |
| ONVIF vs RTSP camera onboarding step by step, General ROI, first Intrusion rule, Video Search and `Camera ROI` search, alert dashboard | references/setup-detailed-tutorial.md (TT2) |
| Intrusion Detection (`ID`): Exclude ROI, AND/OR, with/without, schedule, sensitivity | references/intrusion-detection.md (TT9) |
| Object Counting (`OC`): line pairs, In/Out, occupancy, Counting Rule alerts | references/object-counting.md (TT11) |
| Object Wrong Direction (`OWD`): line pair, red arrow, line spacing | references/object-wrong-direction.md (TT10) |
| Object Left Behind (`OLB`): small ROIs, trigger time, dedupe | references/object-left-behind.md (TT12) |
| Crowd Detection (`CD`): Head vs Person, Crowd Threshold | references/crowd-detection.md (TT5) |
| Dwell Detection (`DD`): Time Threshold, cooldown semantics with dedupe | references/dwell-detection.md (TT6) |
| Person Fall (`PF`): unobstructed view, 100x100 px, sensitivity | references/person-fall.md (TT8) |
| Face Recognition (`FR`): face size, similarity, quality modes, lists/targets, privacy protection | references/face-recognition.md (TT3) |
| License Plate Recognition (`LPR`): modes, confidence, plate size, lists, expiration, add-from-detection | references/license-plate-recognition.md (TT4) |
| Human Attributes (`HA`): clothing/colour search, 200x200 px | references/human-attributes.md (TT7) |
| Object Detection / Video Search / Profile / Heatmap / hashtags | references/object-detection.md (TT13) |
| Scoping and running a POC or demo: expectations, hardware, RTSP discovery, integrations, verification, pixel-size check, network symptoms | references/poc-and-demo-playbook.md (TT14) |
| Something the courses did not cover, missing lessons, course inconsistencies | known-gaps.md |
| Install, ports, firewall, upgrade paths, HTTP trigger parameters, Vaidio Data, Command Center, Enterprise | the `vaidio` skill |
| Positioning, licensing SKUs, Appliance Calculator channel counting, verticals | the `vaidio-sales-track` skill |

## Answering rules for this skill
1. Give the UI path in order (`Page > tab > control`) using the exact labels in backticks; say which Vaidio version the label was observed in when it matters (7.2 videos vs written courses).
2. Quote defaults only where a reference states them; if a reference says "not stated", say so and point to `vaidio/references/configuration.md` or the vendor guide rather than guessing.
3. Cite lesson tags (`[TT9:analytics-setup]`) so the user can open the exact lesson at `https://university.vaidio.ai/<course-slug>?lesson=<slug>` (slugs are in each reference's Lesson index and in sources.md).
4. When two courses disagree (LPR speed bands, save-button labels, `VS` vs `OD` tab), present both and flag it - the matrix lists the known discrepancies.
5. Destructive or disruptive controls (`Factory Reset`, `Restart`, deleting lists/ROIs) - state the consequence before recommending them.
6. These are training-course facts, not release notes; for licensing, support-portal or install questions defer to the `vaidio` and `vaidio-sales-track` skills.

## The universal setup flow (memorise this)
1. **Network first**: Admin Portal `:8000` > `Network` (NIC, static/DHCP) and `Time` (NTP) > `Apply`. [TT1]
2. **Add the camera**: `Camera` > `Add Camera` > name it > ONVIF (IP + port 80 + creds > `Get RTSP`) or `RTSP` URL > `Preview` shows a **still image** and the real `Resolution`/`FPS` > `OK`. Check the `Resolution` column - sub-streams below 2 MP starve every analytic. [TT2] [TT14]
3. **Trim the General ROI** if sky/treelines cause noise - it applies to every analytic on that camera. [TT2] [TT13]
4. **Profile** (gear): enable only the classes you need; `Confidence` 0.50 default (drop to ~0.3 for small/far people); minimum size 30 px (down to 10 with care). Save as a named profile and reuse it across cameras. [TT1] [TT13]
5. **AI Engines**: tick the engine > its tab appears > pencil to draw the ROI (polygon, any shape; `Exclude ROI` for dead zones) or the line pair (middle of the FoV, small gap, arrows match real travel) > ✓ > wrench for rules: unique `Name`, object types (<=10, AND/OR, with/without, colour, quantity), `Schedule`, `Sensitivity`, `Dedupe Events`, `Cooldown Interval` > `Save` > `OK`. [TT9] [TT11] [TT10]
6. **Verify**: open the engine's `Dashboard` (or `Abnormal`) and `Search`; open a scene and read `Width`/`Height` to confirm pixels on target. [TT14]
7. **Alert**: `Alert` > `Alert Rule` > `Add Alert` > `Alert Type` = the engine > pick cameras/ROIs/lines/lists > `Schedule` > `Trigger` (email needs `System > Mail` first; HTTP for gates/VMS; Vaidio App) > `Save`. [TT1] [TT4]

## Top troubleshooting flows (inline)

### 1. No detections / events from an analytic
1. Pixels on target: open the scene in `Search`, toggle bounding boxes, read `Width`/`Height`; below 30x30 px (FR 64x64, Person Fall 100x100, HA 200x200, LPR 40x20) move/zoom the camera or lower `Minimum` in `Profile` (10 px minimum, with care). [TT14:verifying-pixel-size] [TT13:profile]
2. Resolution: confirm the camera is imported at >= 2 MP (`Camera` table `Resolution`); pull the main stream, not a sub-stream. [TT14:camera-resolution]
3. Class enabled? `Profile > Object Type` checkbox for that class; confidence too high -> lower it. [TT13:troubleshooting]
4. Rule logic: `AND` requires every selected class at once - switch to `OR`; check the ROI/`Exclude ROI` covers the path; check `Schedule`. [TT9:troubleshooting]
5. Fast movers: raise sensitivity to `2` scenes in `5` s. [TT9:troubleshooting]
6. Network: green screen, corrupted frames, lag or disconnects in Live View mean dropped frames - fix bandwidth/stability before tuning. [TT14:network-considerations]

### 2. Too many or too few repeated events
- One event per episode wanted -> `Dedupe Events` ON (object must leave and re-enter; for Dwell/OLB the cooldown then means time *out* of the ROI). Continuous reminders wanted -> Dedupe OFF and set `Cooldown Interval` (events every N seconds). Demo audiences usually prefer OFF. [TT12:roi-settings] [TT6:roi-settings] [TT14:dedupe]

### 3. Line analytics (Counting / Wrong Direction) miss or double count
- Lines in the middle of the FoV, small gap between the pair, pair oriented along the real 3-D path, no stopping/turning inside the pair; pull line ends outward to cover the full lane; verify In/Out direction arrows (red = wrong direction for OWD). [TT11:troubleshooting] [TT10:troubleshooting]

### 4. Faces or plates not recognised
- FR: frontal 6-8 ft mount, >=100x100 px faces, raise shutter speed (motion blur), enable WDR for backlight, Quality `High` only where people face the camera, similarity threshold trades false positives vs negatives, targets need clear frontal images (<=5 variants). [TT3:troubleshooting] [TT3:fr-parameters]
- LPR: plate must be on a vehicle, >=40x20 px, correct `Mode` for speed, raise shutter speed, add lighting/IR at night, confidence 30% default (raise if junk reads, lower if misses). [TT4:troubleshooting] [TT4:profile]

### 5. Integration or demo blockers
- NVR clips need brand/IP/port/admin creds and have a 5-minute retrieval cooldown - never demo them live. VMS integrations may need middleware or VMS-side licences. SMTP server must be reachable from the appliance (isolated sites cannot reach Google). Configure and test integrations before the demo day. [TT14:nvr-connectivity] [TT14:vms-connectivity] [TT14:smtp-connectivity]

## Knowledge-check highlights (what Vaidio tests)
ONVIF needs ports 80 and 554; Object Counting uses line sets, not ROIs; `Parking Lot` is the cheapest LPR mode and `Highway` the most expensive; Crowd Threshold is a *minimum*; the `Schedule` setting limits triggers to times of day; `History` tabs are not real time; Privacy Protection does not stop analytics; lowering confidence raises false positives; Object Detection is the foundation layer for every other analytic and for search. [TT1] [TT4] [TT5] [TT9] [TT3] [TT13]
