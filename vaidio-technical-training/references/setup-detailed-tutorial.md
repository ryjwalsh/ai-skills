# Vaidio Setup Detailed Tutorial — Vaidio University TT2 "Vaidio Setup Detailed Tutorial"

> Source: Vaidio University (university.vaidio.ai) course TT2, 33 video-only lessons in 6 sections (Network Setup, License Management, Camera Setup, Intrusion Setup, Video Search, Alert Setup). **PARTIAL: sections 3–6 (lessons 14–33) captured 2026-10-17** from burned-in captions sampled every 2–3 s plus UI frame zooms; **sections 1–2 (lessons 1–13, Network Setup and License Management) are NOT captured** — see Source notes. Recorded on **Vaidio 7.2.0-1**; verify names against the deployed version. Full source table: ../sources.md.

## At a glance
The instructor-led version of TT1: add a camera by IP/ONVIF and by RTSP, trim the General ROI, add Intrusion Detection as the first analytic, use Video Search, and understand where alerts surface. Network Setup and License Management sections exist but were not captured.

| Item | Value | Src |
|---|---|---|
| Post-login landing page | `Search` (`VAIDIO > Search`, magnifier at top of the icon rail) | [TT2:search-page] |
| Video Search coverage | automatically on for every object class of the camera's model (`PowerModel` default) — no engine needed | [TT2:video-search-overview] |
| Add camera by IP (ONVIF) | `Type` `Camera IP Address/Domain Name` → IP + web-UI port (typically `80`) + credentials → `Get RTSP` → first (max-resolution) stream → `Preview` → `OK` | [TT2:camera-page--ip-address-set-up] |
| Add camera by RTSP | `Type` `RTSP` → `rtsp://<ip>:<port, usually 554>/<vendor path>` + credentials → `Preview` → `OK`; test the URL in VLC first | [TT2:rtsp-set-up] |
| General ROI | blue quadrilateral on the still; drag corners to exclude areas; outside it every analytic ignores objects | [TT2:general-roi] |
| Intrusion rule defaults | `Sensitivity` `5` scenes `(1~20)` every `10` s `(1~30)`, `Dedupe Events` ON, `Cooldown Interval` `9` s `(1 ~ 3,600)` | [TT2:camera-popup-window] |
| Profile defaults | `Confidence[0.01 ~ 1.00]` `0.50` (`Suggested Value` `0.50`), `Minimum ~ Maximum pxl` `30` / `--` | [TT2:camera-popup-window] |
| Engine column codes seen | `ID`, `DD`, `MMR`, `OC`, `OWD`, `CD` | [TT2:video-search-overview] |

## Section 3 — Camera Setup (lessons 14–19)
### Camera page layout
[TT2:camera-page--ip-address-set-up]
- Reach it from the camera icon in the left icon rail, or expand the rail (hamburger ≡) for labelled entries; the bottom of the expanded menu shows `NVR`, `User`, `System`.
- Filter bar `Cluster: All`, `AI Engines: All`, `Actions: All`, `Group: All`, `Camera Name`, `Search` (+ export icon), lightning-bolt button; buttons `Add Camera`, `Auto Discovery`, `Group`; `Columns` picker; pager.
- Columns: checkbox, `No.`, `Camera Name` (thumbnail), `Resolution`, `Group`, `AI Engines`, `Status`, `Abnormal Check` (calendar + history icons per row), `Actions` (on/off toggle, `...` menu); header has bulk delete and export/move icons. Empty table reads `No matching records found`.

### Add a camera by IP address / ONVIF
[TT2:camera-page--ip-address-set-up]
1. `Add Camera` → dialog sections `Camera Info` (`* Camera Name`, `Cluster` default `localhost`, `Group`, `Location Type` default `None`, `Description`, `Activate` \| `Deactivate`), `Camera URL`, `NVR` (`Internal Video Recorder`, `NVR`, `Channel ID`), right pane `Advanced` (`AI Model` `1 selected`, `AI Engines` `Select AI Engines`, gear → `Profile : Default`, tab `General ROI` with pencil/refresh, `Resolution: 0x0 pixel`, `Preview`).
2. `Camera URL > Type` = `Camera IP Address/Domain Name` (default). Enter `* IP/ Domain Name` and the port — the camera's **web-UI port, typically `80`**. Works when the camera (or its user profile) is ONVIF-compliant.
3. Enter `User Name` / `Password`.
4. `Get RTSP` → Vaidio queries the camera over ONVIF and fills the dropdown with its RTSP streams: first entry = main stream at maximum resolution, others = sub-streams. Demo result (Dahua-style): `rtsp://admin:<password>@192.168.100.233:554/cam/realmonitor?channel=1&subtype=0&unicast=true&proto=Onvif` (second entry `subtype=1` [inferred]).
5. Pick the main stream → `Preview` → still image + `Resolution: 1920x1080 pixel`; `FPS` auto-fills (`Estimated` / `30`). The still is what ROIs are drawn on.
6. `OK` → toasts `Activate Success`, `Update successful.`; row shows `Connected`. These are the minimum steps for basic object detection.

### Add a camera by RTSP
[TT2:rtsp-set-up]
- Use when the source is not ONVIF (streaming server, NVR/appliance re-stream). Uses the RTSP port, usually `554`.
1. `Camera URL > Type` = `RTSP` → the IP/port row becomes a single `* RTSP` field; `Get RTSP` disappears; `User Name`, `Password`, `FPS`, `TCP/UDP` (`Both`), `Detail Extraction` (`Standard`) remain.
2. URL format: `rtsp://` + IP + `:` + port (confirm with the stream's provider) + `/` + provider path; formats vary by brand/appliance — the "Technical Support User Guide" lists common brands' paths. Demo: `rtsp://192.168.100.232:8554/cam/realmonitor?channel=1&subtype=0&unicast=true&proto=Onvif` (non-default port 8554).
3. Put credentials in the `User Name` / `Password` fields rather than in the URL.
4. Verify first in VLC: `Media > Open Network Stream` → `Network` tab → `Please enter a network URL:` → `Play`. If VLC plays it from a PC that can reach the camera, the syntax is right.
5. `Preview` → `Resolution:` (demo `2048x1536 pixel`), `FPS` `Estimated` / `25` → `OK`.

### General ROI
[TT2:general-roi]
- Shown in `Edit Camera` (same layout as Add; `Cluster` read-only once the camera exists).
- After a successful preview a blue box spans the four corners of the image in `Advanced > General ROI`. It defines where Vaidio looks for objects; full frame is fine. Drag corners to exclude false-detection sources (example: a tree line); the ROI becomes an arbitrary quadrilateral. Everything outside it is ignored by all analytics on that camera.
- Tab tools: pencil (edit), circular arrow (reset), `Resolution` readout, `Preview`, flip horizontal/vertical.

## Section 4 — Intrusion Setup (lessons 20–24)
### Vocabulary
[TT2:intrusion-setup-overview]
- `AI Model` = the detector, selected per camera (`AI Model :` → `1 selected`), supports detection of many object classes.
- `AI Engines` = analytics applied to detected objects for a use case (`Intrusion`, `Counting`, …). "AI Engine" ≡ "AI Analytic" ≡ "analytic". Workflow: choose the Model, then one or more Engines.

### Add Intrusion to a camera (Edit Camera > Advanced)
[TT2:camera-popup-window]
1. `AI Model :` → open to confirm the default `PowerModel-…` is checked (contains the most-requested object types).
2. Gear icon → `Profile` window: `Profile List` button, selector `Default`; tabs `Object Type` \| `VS`; thumbnail with `Resolution : 1,920 X 1,080 pxl`; table `Object Type` (checkbox per class) · `Confidence[0.01 ~ 1.00]` (slider + box, default `0.50`) · `Suggested Value` (`0.50`) · `Minimum ~ Maximum pxl` (`30` / `--`) · copy icon; `Cancel` / `Save`. Classes seen: `Backpack`, `Bag`, `Bicycle` ✓, `Bird`, `Bus` ✓, `Car` ✓, `Cow`, `Head` ✓, `Tricycle`, `Wild_animal`. Checked rows = classes detected for this camera/profile.
3. `AI Engines :` dropdown lists every engine in the licence file with checkboxes (seen: `Age & Gender`, `Crowd`, `Dwell`, `Illegal Parking`, `Intrusion`, `Loitering`, `Make Model Recognition`, …). Tick `Intrusion` → `1 selected`; tab `ID` (with ×) appears beside `General ROI`.
4. `ID` tab → pencil → click to drop vertices (any polygon; demo 4-point corridor), drag to adjust; toolbar ⊘ / copy / green ✓ while editing → ✓ to confirm. Region appears in the table (`No.`, `Name`, trash).
5. Wrench on the region row → rule panel: `Name` (unique; demo `Intrusion Test`); `Object Type` ⓘ icons (vehicle, person, animal, fire/drop, warning) + `AND` \| `OR`; chips for chosen classes (`Person ×`); `Schedule` (calendar); `Sensitivity` `Detect 5 (1~20) scene(s) with defined object every 10 (1~30) second(s)`; `Dedupe Events` ⓘ ON; `Cooldown Interval` ⓘ `9 second(s)` `1 ~ 3,600 seconds`; `Save`.
6. `Save` (panel) → `OK` (dialog) → `Activate Success`. Camera row now shows `ID` under `AI Engines`; region row shows wrench, enable toggle, trash.
Meaning: a Person inside the region for the defined window generates an event notification.

### Intrusion results page
[TT2:intrusion-tab]
- `VAIDIO > Intrusion` (running-person icon, 4th analytic icon in the rail, or by name in the expanded rail). Tabs `Dashboard` \| `History`.
- `Dashboard`: intrusion icon, camera icon, `Select Camera`, refresh; live video of the selected camera; right column of real-time event cards (thumbnail with red ROI + green box, timestamp, camera, rule name).
- `Select Camera` → `Intrusion List` dialog: preview pane; filters `Cluster All`, `Camera Name`, `Search...`; `Clear Selection`; `0 of 1 selected`; table `Camera Name` (expandable row `IP Camera (1)` — count = ROIs) and `Group Name`; `OK`. Expand a row to pick specific ROIs.
- `History`: rule/ROI picker (tooltip shows rule name), date range with time spinners, `Search`, export icon, result count, trash + pager, cards with checkbox for bulk delete/export; toast `Search successful.`

## Section 5 — Video Search (lessons 25–29)
[TT2:video-search-overview] [TT2:search-page] [TT2:narrowing-searches]
- Forensic tool: sifts large volumes of video in seconds; runs on every connected camera; the Model recognises objects, Engines are use-case logic on top (Intrusion for people, Vehicle Counting, Dwell Time).
- Camera page on this server shows an extra column `AI Model Enabled` (`PowerModel-Core-7…`) and `Group` `EarthCam` public demo cameras.
- `Search` toolbar: camera picker, report/list icon, start date + time `~` end date + time, `Search`, snapshot icon; right: save (floppy), list view, share/export. Second row: `Advanced`, then category icons vehicle / person / animal (paw) / fire-liquid (drop) / warning / tag.
- No filters → every recognised object since midnight (demo `387,444 results in 1.8 second.`); header shows `Retention Time:<from> ~ <to>` = searchable window; pager and grid / map-pin / layout toggles; toast `Search successful.`
- Scene window `Original Snapshot | Scene ID : <id>`: timestamp, camera, `<` `>` scene stepping; toolbar: bounding-box toggle, object-detail/search-similar magnifier, tag, download, crop/zoom icons, map, more; right group: snapshot view, play clip, location pin, full frame. Bounding-box toggle opens a crop strip labelled by class; selecting a crop shows `Object Type:`, `Confidence:`, `Color:`, `Width:` / `Height:` (px) and attribute columns `Age:`, `Gender:`, `FR List:`, `Name:`, `Emotion:`, `Make:`, `Model:`, `LPR List:`, `License Plate:`, `Speed:`, `Mask:`, `PPE:` (`-` when the engine is off).
- Narrowing: `Select Camera` → `Camera List` dialog (`Camera Name` filter, `Search...`, list/preview toggles, `Select All`, `83 of 83 selected`, columns `Camera Name` / `Group Name`, `OK`); date/time calendar picker; object menus under each icon (person icon → `More` header with `Backpack`, `Bag`, `Cell_phone`, `Luggage`, `Major_scene_change`, `Minor_scene_change`, `person_in_blue_uniform`, `person_without_uniform`, `Stroller`, `Umbrella`, each with `>` attributes) producing chips (`Person ×`, `Backpack ×`); demo person-with-backpack over two days: `1,927,606 results in 2.3 second.` → `4,485 results in 4.2 second.` after camera/ROI narrowing.
- `Save Filter` (floppy icon) → dialog `* Name :` → `OK`; reload from the adjacent list icon [inferred].
- `Camera ROI` search: in `Camera List` pick one camera (radio), switch to preview view (refresh icon reloads the snapshot), click `Camera ROI`, draw a polygon, `OK` → only objects inside the region are returned (e.g. a sidewalk vs the road).

## Section 6 — Alert Setup (lessons 30–33)
[TT2:alert-setup-instructor-introduction] [TT2:alert-setup-overview] [TT2:alert-dashboard-tab]
- Alerts can be created from **any** analytic event configuration; they are real-time indicators sent to email, text (SMS), apps and third-party systems (examples: signal on a face detection; email on an intruder).
- `VAIDIO > Alert`, tabs `Dashboard` \| `History` \| `Alert Rule`. `Dashboard` default view = bell filter + world map (`+`/`−`, `1000 km / 500 mi` scale) with list / map-pin / layout toggles; empty state `No matching records found`; refresh top-right.
- If a camera has an indoor map or outdoor GPS coordinates, the Dashboard also places the alert on the map.
- Rule creation (`Alert Rule` tab, delivery channels) is explicitly deferred to other courses — not shown here; see setup-overview-demo.md (`Add Alert` dialog) and the per-analytic references.

## Knowledge checks
No check-in questions were present on lessons 14–33. Lessons 1–13 not captured.

## Lesson index
| # | Lesson (slug) | Min | Video | Topic |
|---|---|---|---|---|
| 1 | network-setup-instructor-introduction | 1 | not captured | Section 1 intro |
| 2 | network-setup-overview | 1 | not captured | Network setup overview |
| 3 | accessing-vaidio-through-windows | 1 | not captured | Reach the server from Windows |
| 4 | accessing-vaidio-through-mac | 1 | not captured | Reach the server from Mac |
| 5 | accessing-vaidio | 1 | not captured | Login |
| 6 | admin-portal | 2 | mp4 `Network Setup/Network Setup - Admin Portal.mp4` (not transcribed) | Admin Portal (see setup-overview-demo.md) |
| 7 | network-setup-conclusion | 1 | not captured | Recap |
| 8 | license-management-instructor-introduction | 1 | not captured | Section 2 intro |
| 9 | license-management-overview | 1 | not captured | Licensing overview |
| 10 | license-page-part-1 | 2 | not captured | `System > License` export |
| 11 | support-portal | 2 | not captured | Support Portal / licence request |
| 12 | license-page-part-2 | 1 | not captured | Licence import |
| 13 | license-management-conclusion | 1 | not captured | Recap |
| 14 | camera-setup-instructor-introduction | 1 | mp4 `Camera Setup/Camera Setup - Instructor Introduction.mp4` (17 s) | Section 3 intro; login page shows `Version: 7.2.0-1` |
| 15 | camera-setup-overview | 1 | mp4 `Camera Setup/Camera Setup - Overview.mp4` (20 s) | Framing; Object Counting dashboard shown |
| 16 | camera-page--ip-address-set-up | 2 | mp4 `Camera Setup/Camera Setup - Camera Page & IP Address Set Up.mp4` (123 s) | Camera page, ONVIF add |
| 17 | rtsp-set-up | 2 | mp4 `Camera Setup/Camera Setup - RTSP Set Up.mp4` (90 s) | RTSP add, VLC test |
| 18 | general-roi | 1 | mp4 `Camera Setup/Camera Setup - General ROI.mp4` (26 s) | General ROI |
| 19 | camera-setup-conclusion | 1 | mp4 `Camera Setup/Camera Setup - Conclusion.mp4` (11 s) | Recap |
| 20 | intrusion-setup-instructor-introduction | 1 | mp4 `Intrusion Setup/Intrusion Setup - Instructor Introduction.mp4` (13 s) | Section 4 intro |
| 21 | intrusion-setup-overview | 1 | mp4 `Intrusion Setup/Intrusion Setup - Overview.mp4` (38 s) | Model vs Engine |
| 22 | camera-popup-window | 2 | mp4 `Intrusion Setup/Intrusion Setup - Camera Popup Window.mp4` (98 s) | Profile dialog, `ID` tab, rule panel |
| 23 | intrusion-tab | 1 | mp4 `Intrusion Setup/Intrusion Setup - Intrusion Tab.mp4` (35 s) | Intrusion Dashboard / History |
| 24 | intrusion-setup-conclusion | 1 | mp4 `Intrusion Setup/Intrusion Setup - Conclusion.mp4` (15 s) | Recap |
| 25 | video-search-instructor-introduction | 1 | mp4 `Video Search/Video Search - Instructor Introduction.mp4` (11 s) | Section 5 intro |
| 26 | video-search-overview | 1 | mp4 `Video Search/Video Search - Overview.mp4` (37 s) | Search on for all model classes |
| 27 | search-page | 2 | mp4 `Video Search/Video Search - Search Page.mp4` (81 s) | Search toolbar, scene window |
| 28 | narrowing-searches | 2 | mp4 `Video Search/Video Search - Narrowing Searches.mp4` (74 s) | Camera, time, object, ROI, saved filters |
| 29 | video-search-conclusion | 1 | mp4 `Video Search/Video Search - Conclusion.mp4` (17 s) | Recap |
| 30 | alert-setup-instructor-introduction | 1 | mp4 `Alert Setup/Alert Setup - Instructor Introduction.mp4` (13 s) | Section 6 intro |
| 31 | alert-setup-overview | 1 | mp4 `Alert Setup/Alert Setup - Overview.mp4` (21 s) | What alerts are |
| 32 | alert-dashboard-tab | 1 | mp4 `Alert Setup/Alert Setup - Alert Dashboard Tab.mp4` (16 s) | Map dashboard |
| 33 | alert-setup-conclusion | 1 | mp4 `Alert Setup/Alert Setup - Conclusion.mp4` (18 s) | Recap |

## Source notes
- **Not captured:** lessons 1–13 (Network Setup: Windows/Mac access, login, Admin Portal; License Management: licence page parts 1–2, Support Portal). The Admin Portal content is covered by TT1 (setup-overview-demo.md) and the vendor install guide in the sibling `vaidio` skill; the licence export/import workflow is covered by `vaidio/references/operations.md`. Re-run the capture for these 13 lessons to close the gap.
- Lesson 17 shows an alternate `Add Camera` layout without the `Cluster` row and with flip icons next to `Preview`; lesson 16 shows `Cluster` (default `localhost`). Both were recorded on 7.2.0-1 — the dialog varies by server build.
- "Technical Support User Guide" (RTSP paths per brand) is the vendor PDF indexed as S3 in `vaidio/sources.md`.
- Section 6 never shows the `Alert Rule` tab contents; the `Add Alert` dialog is documented from TT1 instead.
