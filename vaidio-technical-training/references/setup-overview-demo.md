# Vaidio Setup Overview (end-to-end demo) — Vaidio University TT1 "Vaidio Setup Overview"

> Source: Vaidio University (university.vaidio.ai) course TT1, 8 video-only lessons (~22 min of screen recording), captured 2026-10-17 from burned-in captions sampled every 2–3 s plus UI frames every 15–20 s (lesson 8's second half in a second pass the same day). No lesson text exists on these pages. Demo server runs **Vaidio 7.2.0-1**; menu and dialog names below are as shown in that UI and may differ in 9.x/10.x — verify against the deployed version. Full source table: ../sources.md.

## At a glance
A recorded "Vaidio Demo" walk-through: Admin Portal network/time/upgrade settings → add cameras (ONVIF and RTSP) → configure Intrusion, Object Counting and LPR → build LPR lists → read the per-analytic event dashboards → open the Alert page. It is the fastest single source for *where things live* in the Core web UI and what the dialogs contain.

| Item | Value | Src |
|---|---|---|
| Core web UI | `http://<server-ip>/login` — login fields `User Account`, `Password`, link `Forgot password?`, footer `Version: 7.2.0-1` | [TT1:the-admin-portal] |
| Admin Portal | `http://<server-ip>:8000/` (login `Account` / `Password`, lands on `/system/`); `Port Configuration` default `8000` | [TT1:the-admin-portal] |
| Add Camera, ONVIF path | `Type: Camera IP Address/Domain Name` → IP + port (default `80`) + `User Name`/`Password` → `Get RTSP` → pick highest-resolution stream → still image + `Resolution` + estimated `FPS` → `OK` | [TT1:adding-cameras] |
| Add Camera, RTSP path | `Type: RTSP` → paste full `rtsp://…` URL (+ credentials) — no port field, no `Get RTSP` | [TT1:setting-up-object-counting] |
| Ports for ONVIF cameras | camera UI port (default `80`) **and** RTSP port (default `554`) | [TT1:adding-cameras] |
| Default AI model | `PowerModel-Core-7.2g2-Pro-3.4` — 28 object types on the demo server; narration says "30+" built-in objects | [TT1:setting-up-license-plate-recognition] [TT1:setting-up-intrusion-detection] |
| Profile defaults | `Confidence[0.01 ~ 1.00]` = `0.50` for almost every class; `Minimum ~ Maximum pxl` = `30` / blank; scene-change classes `0.30` with min `80` (major) / `40` (minor) px | [TT1:setting-up-intrusion-detection] |
| Intrusion rule defaults | `Sensitivity` `5` scenes `(1~20)` every `10` s `(1~30)`; `Dedupe Events` ON; `Cooldown Interval` `9` s, range `1 ~ 3,600` | [TT1:setting-up-intrusion-detection] |
| LPR modes | `Parking lot` ≤10 mph 2 fps · `City Road` ≤50 mph 4 fps · `Highway` >50 mph 6 fps; 3 parking-lot channels ≈ 1 highway channel | [TT1:setting-up-license-plate-recognition] |
| Engine tab codes seen | `ID` Intrusion, `OC` Object Counting, `LPR`, plus list codes `CD`, `PC`, `PWD`, `FR` | [TT1:setting-up-intrusion-detection] [TT1:setting-up-object-counting] |

## Admin Portal (`:8000/system/`)
[TT1:the-admin-portal]
Purpose: get a freshly installed server onto the network (servers ship with a default IP like a camera), set time/NTP, and run software upgrades. Page sections top to bottom:

| Section | Controls | Notes |
|---|---|---|
| Password | `New Password`, `Confirm Password` | Admin Portal account |
| `Port Configuration` | `Port Number:` spinner (default `8000`) | the portal's own port |
| `Time` | `Time Zone:` dropdown (demo `America/New_York`); `System Time:` date + hh:mm:ss (greyed while NTP on); `Sync with NTP Server` checkbox; NTP host list (one per line, default `pool.ntp.org`); `Synchronize the system time regularly` checkbox; `Check Connection` | NTP sync recommended for all time-based features |
| `Network` | `Interface:` (NIC, e.g. `enp3s0`, shows `MAC Address:`); `Mode:` `Static Configuration` or DHCP; when static `* IPv4 Address`, `* Netmask`, `Gateway`, `DNS Server`; green `Apply` | `*` = required |
| `Upgrade` | `Online` \| `Offline` toggle; channel `dev / prerelease / release`; `Step 1 — Admin Portal` (`Current Version`, `Check for Update`, `Upgrade`); `Step 2 — Main System` (`Current Version`, `Check for Update`, `(Optional) Upload Profile`, `Upgrade`) | on-screen rule: **"Admin Portal upgrade MUST be done before Main System upgrade."** |
| `Factory Reset` | `Factory Reset` button | destructive |

## Add Camera dialog — field inventory
[TT1:adding-cameras] [TT1:setting-up-object-counting]
- `Camera Info`: `* Camera Name`; `Group:` (`Please select`); `Location Type:` (`None`); `Description:`; `Activate:` toggle `Activate` (default) / `Deactivate`. Empty required field → error `Cannot leave empty field.`
- `Camera URL`: `Type:` (`Camera IP Address/Domain Name` or `RTSP`); for IP type `* IP/ Domain Name:` + port spinner (default `80`), `User Name:`, `Password:` (eye icon), `Get RTSP` + stream dropdown; for RTSP type a single `* RTSP` URL box; both: `FPS:` (`Estimated` + value auto-filled, e.g. `25`, `29.97`, `30`), `TCP/UDP:` (default `Both`), `Detail Extraction:` (default `Standard`).
- `NVR`: `Internal Video Recorder` checkbox (unchecked); `NVR:` and `Channel ID:` (`Please select`).
- `Advanced` (right pane): `AI Model:` (`1 selected`); `AI Engines:` (`Select AI Engines`); gear icon = `Profile : Default`; tab `General ROI` with pencil/reset icons, `Resolution: 0x0 pixel` until a stream loads, `Preview`, flip-horizontal/vertical icons; engine tabs appear here as engines are ticked.
- Footer: `Cancel`, `OK` (enabled once the stream validates). Toasts on success: `Activate Success`, `Update successful`.
- What the preview is: a **still image** of the stream (not live video) — all ROI/line drawing is done on it.
- Stream pick after `Get RTSP`: the entry with the highest resolution; the dropdown shows the resolved URL, pattern `rtsp://<user>:<pass>@<camera-ip>:<rtsp-port>/<path>` (the demo camera used RTSP port `8554`).
- RTSP type: every brand's URL format differs; Vaidio can also ingest re-streams from NVR/VMS "as long as we can receive it". Video-in-flight security is a network-layer matter — Vaidio only receives the stream.

## Camera list page (`VAIDIO > Camera`, `/camera/cameraManagement`)
[TT1:setting-up-intrusion-detection]
Filters `AI Engines: All`, `Actions: All`, `Group: All`, `Camera Name` + `Search`; buttons `Add Camera`, `Auto Discovery`, `Group`; `Columns` picker; table `No.`, `Camera Name` (thumbnail), `Resolution`, `Group`, `AI Engines` (codes), `Status` (`Connected` / `Not in use`), `Abnormal Check`, `Actions` (enable toggle + `…`).

## Intrusion configuration (`ID` tab)
[TT1:setting-up-intrusion-detection]
Concept: the AI Model does base object detection on every camera all the time; an AI Engine is a *filter* on those detections. Intrusion = "anything you can express as objects inside a region, optionally on a schedule" (AND/OR, with/without); sensitivity settings exist so no-one is bombarded with false alerts.
1. `Advanced` → `AI Engines:` dropdown lists licensed engines with checkboxes (seen: `Intrusion`, `License Plate Recognition`, `Loitering`, `Make Model Recognition`, `Object Counting`, `Object Left Behind`, `Object Wrong Direction`, `People Counting`, …). Tick `Intrusion` → `1 selected`, tab `ID` appears with an empty ROI table (`No.`, `Name`).
2. On `ID`, pencil → draw the polygon on the still (avoid walls / areas nobody enters) → ✓. Toolbar while drawing: cancel ⊘, copy, ✓. ROI row shows wrench, enable toggle, trash.
3. Wrench → rule panel: `Name` (must be unique per server); `Object Type` picker with family icons (vehicle, person, animal/paw, fire-smoke/drop, other/warning) and `AND` \| `OR`; each class has a `>` sub-menu for `Color` (`Include` + swatches) and `With`/without a secondary object. Demo tags: `Forklift w/o (Person)` (unattended forklift), `Person` AND `Handgun` (weapon use case). Vehicle class list seen: `Vehicle`, `Bicycle`, `Bus`, `Car`, `Forklift`, `Jeepney`, `Motorcycle`, `Tricycle`, `Truck`, `Tuktuk`.
4. `Schedule` button (time-of-day; not configured in demo).
5. `Sensitivity`: `Detect [5] (1~20) scene(s) with defined object every [10] (1~30) second(s)` — demo changes to **2 scenes in 5 seconds** ("usually enough to filter out a lot of false detections").
6. `Dedupe Events` ON (default) = one alert per occurrence; OFF = repeat every cooldown while the condition persists. `Cooldown Interval` `9` s, `1 ~ 3,600`.
7. `Save` (panel) → `OK` (dialog). Camera row now shows `ID`, `Connected`.

### Profile dialog (gear icon, `Profile : Default`)
- Header: `Profile List`, profile dropdown (`Default`); tabs `Object Type` \| `VS`; `Resolution : 2,048 X 1,536 pxl`.
- Table: enable checkbox · `Object Type` · `Confidence[0.01 ~ 1.00]` (slider + value; header has a global `0.50` box and apply-to-all) · `Suggested Value` · `Minimum ~ Maximum pxl` (apply-to-all icon).
- Classes seen: `Backpack`, `Bag`, `Bicycle`, `Bird`, `Bus`, `Car`, `Cat`, `Major_scene_change` (0.30 / min 80), `Minor_scene_change` (0.30 / min 40), `Motorcycle`, `Person` (0.50 / 30), `Rifle`, `Smoke`, `Tricycle`, `Truck`, `Tuktuk`, `Umbrella`, `Wheelchair`, `Wild_animal`; bags/birds/weapons unticked by default.
- Guidance: `0.50` is usually right; for a low-resolution camera watching people far away drop `Person` to ~`0.3`; minimum pixel size can go as low as `10`; a maximum is rarely used (filters by apparent size/distance); untick classes you never need. Save as a named profile and apply it to many cameras instead of configuring each.

## Object Counting configuration (`OC` tab)
[TT1:setting-up-object-counting]
- Camera added as `Type: RTSP` (public EarthCam `https://…earthcam.com/…` stream); `FPS` auto-fills `29.97002997002997`; `Resolution: 1920x1080 pixel`.
- Object Counting uses **line sets, not ROIs**: each counting line is a pair of lines numbered `1` and `2`, each with an `In`/`Out` arrow; an object counts when it passes through line 1 and then all the way through line 2, so the pair must follow the real 3-D path. Table columns `No.`, `Line`, wrench, trash.
- Per-line settings: `Name` (demo `vehicle line`, `person line`); `Object Type` multi-select from the model list (demo `Bus`, `Car`, `Truck`; `Person`); `Line Direction Count` with `Enable In Count` / `Enable Out Count` (both default on — untick one for one-way flows); direction can be flipped. `Save` → `OK`.
- Anything the model detects can be counted (vehicles, people, drones, cows, river inner-tubes with a custom model).

## License Plate Recognition configuration (`LPR` tab) and custom models
[TT1:setting-up-license-plate-recognition]
- Camera `Type: RTSP`, `* RTSP` = `rtsp://192.168.100.19/plates.mp4` (plain RTSP server replaying a clip); `FPS` `30`, `1920x1080`.
- Tick `License Plate Recognition` → `LPR` tab with one auto-created rectangular ROI named `License Plate Recognition ROI`; wrench → `LPR Configuration`: `Mode` (`Parking lot` / `City Road` / `Highway`) and `Vehicle Type` (`Vehicle`).

| `Mode` | Vehicle speed | Frames analysed | Src |
|---|---|---|---|
| `Parking lot` | up to 10 mph | 2 fps | [TT1:setting-up-license-plate-recognition] |
| `City Road` | up to 50 mph | 4 fps | [TT1:setting-up-license-plate-recognition] |
| `Highway` | > 50 mph | 6 fps | [TT1:setting-up-license-plate-recognition] |
Rule of thumb: 3 parking-lot channels cost the same resources as 1 highway channel. (TT4 and ST4 give different speed bands for the same modes — see Source notes.)

- Custom models: `VAIDIO > System` → tab `AI Model` (`/system/aimodel`): `Upload`; table `AI Model Name` · `Object Type` (class count, click to list) · `Replace`/trash; active-model checkbox; `Apply`; second table `Specialized Object Model Name`. System tabs: `General`, `Time`, `Storage`, `Mail`, `Authentication`, `Log`, `Audit Trail`, `License`, `Setting`, `AI Model`, `Utility`; `Restart` button.
- Demo custom models (name pattern `<prefix>-<Use>-Core-7.2g2-Pro-<ver>`): `PS-InnerTube-Core-7.2g2-Pro-2.0` (3 classes), `PS-FisheyeFall-Core-7.2g2-Pro-6.2` (5: `Bed`, `fall`, `Head`, `lying_on_the_bed`, `Person` — in-bed/out-of-bed via person-bed overlap), `EM-Trolley-Core-7.2g2-Pro-1.0` (9), `PS-BlueUniform-Core-7.2g2-Pro-1.0` (`person_in_blue_uniform`, `person_without_uniform`), `PowerModel-Core-7.2g2-Pro-3.4` (28, active); specialized `PS-SOIWeapon-Core-7.2g2-Pro-2.11` (3). Message: if it is visible and data can be collected, a model can be trained and every analytic filter then applies.
- LPR results: `VAIDIO > License Plate Recognition` (`/licensePlateRecognition/dashboard`), tabs `Dashboard` \| `History` \| `List`; left pane `License Plate Detected`; columns `Detected Image`, `License Plate Image`, `License Plate` (text + confidence, e.g. `TLCLEAN (0.92)`), `Time`, `Camera Name`; rows also show vehicle type, `Make & Model:`, `List:` (`Not in list` / list name) and `Description:`; a blue row = list match. Rows arrive in real time (~3 s refresh).

## LPR lists
[TT1:creating-lists]
- `License Plate Recognition` → `List` tab (`/licensePlateRecognition/list`): filter `List:` (`All`), `License Plate:` search, export; buttons `List` (manage) and `Add License Plate`; columns `License Plate`, `List` (coloured tag), `Vehicle Owner`, `Registration Date`, `Address`, `Expiration Date`, `Description`, `Created Time`, row `…`; bulk checkbox + trash.
- `List` → `List` dialog (`New List`; rows `List Name`, `Created Time`, pencil / import-folder / trash) → `New List`: `* List Name :`, `* List Color :` (10 swatches). A list name is just a string — lists are generic (access control, monitoring, anything). Toast `Add successful`.
- `Add License Plate`: `*License Plate :`, `*List :`, `Vehicle Owner :`, `Registration Date :`, `Address :`, `Expiration Date :`, `Description :`; `OK`.
- Bulk import: folder icon on the list row; fixed-format template supplied by Vaidio; imported rows get `Description` = `Imported`. Face lists are harder to import — "import our existing database" is a common vendor-assisted request.

## Event dashboards
[TT1:managing-incoming-alerts]
Everything so far (LPR reads, intrusion hits, counts) are **events**; alerts are a layer on top (next section).
- `VAIDIO > Intrusion` (`/intrusion/intrusionDashboard`): tabs `Dashboard` \| `History`; `Select Camera`; live/clip player left; right column of event cards (thumbnail with red ROI polygon + green box, timestamp, camera, ROI name).
- `VAIDIO > Object Counting` (`/objectCounting/dashboard`): `Dashboard` — toggles `Counting List` / `Object Type`, `Since <date> 00:00:00`, object chips, checkboxes `In` `Out` `Occupancy`, KPI tiles `Total In` / `Total Out` / `Total Occupancy`, table `Object Type` · `Camera Name` · `Line` · `In` · `Out` · `Occupancy` (an In-only line shows `NaN` for Out/Occupancy), live view with line overlays, per-minute `Count` chart. `History` — granularity `Hourly` (also daily/monthly), date-time range, `Search`, chart/table toggle, `Clear`, `Previous Period`, KPI tiles, hourly bars + occupancy line, export icon; narration: exportable to Excel and usable in real time via alerts.
- `VAIDIO > Alert` (`/alert/alertDashboard`): tabs `Dashboard` \| `History` \| `Alert Rule`; Dashboard opens on a world map (list / map-pin / grid toggles, zoom, bell filter, refresh).

## Alert rules
[TT1:the-alert-tab]
- Philosophy: Vaidio sits beside existing cameras and VMSs, "make as little noise as possible", and forwards events where they need to go; alerts are the export layer.
- `Alert Rule` tab (`/alert/alertRule`): filter `Alert Name` + camera; `Add Alert`; table `Alert Name`, type, target/list, schedule (`Forever`), camera, trigger (`HTTP`, …), `Actions`. Demo rule examples: `Welcome Message` (Face Recognition / Forever / Entrance Camera / HTTP), `Whaaat` (Video Search / `#danger` / Office Overview).
- `Add Alert`: `Alert Name`, `Add Notes`; left `Define Rule` — `Alert Type:` (default `Video Search`; list is per analytic: `License Plate Recognition`, Intrusion, Face Recognition, Crowd Detection, Scene Change, …), camera picker with count, type-specific pickers (Video Search: tag box + object-family icons with `AND`\|`OR`; LPR: list picker with count), `Schedule` (default `Forever`); right `Trigger (Optional)` — `Trigger Action:` default `Email Notification` with `Email:` ("Please enter emails separated by ;"), `Subject:`, body template using placeholders `{cameraName}`, `{eventTimeStamp…}` and an alert-image placeholder [exact spelling partly inferred from a small frame]; bottom table `Action` \| `Trigger (Optional)`; `Cancel` / `OK`.
- LPR example: "notify me when a blacklisted plate shows up" goes out as an email or an HTTP notification.
- `Trigger Action:` **`HTTP`**: method dropdown (default `GET`) + `Enter http URL`; tabs `Params` | `Authorization` | `Headers`, each a `Key` / `Value` table with `+`; buttons: image icon (attach the event image [inferred]), `+ Add`, `Check Connection` (tests the endpoint). Anything that can receive a message or a service call "is all built in, you just need to set it up".
- `Trigger Action:` **`APP Notification`**: push to the Vaidio iOS / Android app (pane shows only `Save`).
- VMS integrations named: Genetec, Network Optix, Milestone — built to receive events and alerts as they occur.
- Second example, `Alert Type: Object Counting` (manufacturing): line picker (chart icon + `2 Lines`) opens the `Line List` dialog (`Camera Name` filter, `Search...`, `Clear Selection`, `2 of 2 selected`, table `Camera Name` / `Group Name`, row `Abbey Road (2)`, preview, `OK`); `Object Type:` chips (demo `Car`); `Counting Rule :` = count type (`Occupancy` default, `In`, `Out` [inferred]) + comparison (`>`) + number (demo `In > 100`); checkboxes `Repeat every [5] minutes after occurrence` (default on) and `Repeat every [100] object count` (demo turned this on and the minutes option off, so the alert repeats for every further 100 objects crossing the line); `Schedule`; `OK`. Use: fire an HTTP call each time 100 parts pass so another system can measure production rate.
- Vaidio also exposes a full REST API for the same data; IronYun uses it for its own custom applications. Closing message: set up the server, add cameras, enable analytics, forward the relevant information to existing systems — the Vaidio UI need not be watched afterwards.
- The Alert `History` tab is not demonstrated in this lesson.

## Knowledge checks (facts the course tests)
[TT1:the-alert-tab]
- An ONVIF camera connection needs both the UI port (default `80`) and the RTSP port (default `554`).
- A camera can have as many object types applied as needed (not capped at 1, 10 or 30).
- The Profile `Confidence` value can be calibrated to how certain the AI must be before an alert triggers (True).
- Object Counting is the analytic configured with line sets rather than regions of interest.
- `Parking Lot` is the LPR mode that needs the fewest resources.

## Lesson index
| # | Lesson (slug) | Min | Video | Topic |
|---|---|---|---|---|
| 1 | the-admin-portal | 2 | mp4 `Vaidio Demo Course/1 Demo Course - The Admin Portal-1.mp4` (101 s) | Admin Portal `/system/` sections |
| 2 | adding-cameras | 2 | mp4 `…/2 Demo Course - Adding Cameras.mp4` (129 s) | ONVIF add-camera flow, dialog fields |
| 3 | setting-up-intrusion-detection | 6 | mp4 `…/3 Demo Course - Intrusion Detection.mp4` (388 s) | AI Model vs Engines, `ID` tab, rule panel, Profile dialog |
| 4 | setting-up-object-counting | 3 | mp4 `…/4 Demo Course - Object Counting.mp4` (181 s) | RTSP add-camera, `OC` line sets |
| 5 | setting-up-license-plate-recognition | 3 | mp4 `…/5 Demo Course - LPR.mp4` (164 s) | `LPR` tab, modes, custom models, LPR dashboard |
| 6 | creating-lists | 1 | mp4 `…/6 Demo Course - Creating Lists.mp4` (79 s) | LPR lists, add plate, bulk import |
| 7 | managing-incoming-alerts | 2 | mp4 `…/7 Demo Course - Managing Incoming Alerts.mp4` (99 s) | Intrusion / Object Counting dashboards and History |
| 8 | the-alert-tab | 3 | mp4 `…/8 Demo Course - The Alert Tab.mp4` (183 s) | Alert Dashboard, Alert Rule, `Add Alert`; 5 check-ins |

## Source notes
- Lesson 8 never shows the Alert `History` tab; the whole lesson stays in the `Alert Rule` tab and the `Add Alert` dialog.
- Narration is reconstructed from burned-in captions; short connective phrases were missed at a few timestamps, none affecting a stated value.
- LPR mode speed bands differ between courses: TT1 says `City Road` up to 50 mph / `Highway` > 50 mph with 2/4/6 fps; TT4 and ST4 say Parking Lot < 10 mph, City Road 10–40 mph, Highway > 40 mph with 1×/2×/3× cost. Treat the mode→cost ratio (3:1) as consistent and the mph boundaries as version-dependent.
- The demo camera's ONVIF-returned RTSP URL used port `8554`, so "RTSP port default 554" must be confirmed per camera.
- Default confidence `0.50`, minimum `30` px and the scene-change class defaults are read from the 7.2.0-1 Profile dialog; the vendor PDFs in the sibling `vaidio` skill document the same ranges for 9.3.
- The on-screen Admin Portal rule "Admin Portal upgrade MUST be done before Main System upgrade" matches the upgrade guide in the `vaidio` skill (references/install-upgrade.md).
