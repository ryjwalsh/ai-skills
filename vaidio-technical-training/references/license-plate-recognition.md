# License Plate Recognition — Vaidio University TT4 "License Plate Recognition"

> Source: Vaidio University (university.vaidio.ai) course TT4, 13 lessons, captured 2026-10-17. Written-lesson content plus check-in questions; embedded videos were not transcribed except where noted. UI names reflect the Vaidio 7.x–9.x web UI shown in the course — verify against the deployed version. Full source table: ../sources.md.

## At a glance
License Plate Recognition (LPR) reads plates inside an ROI, matches them against LPR lists and drives alerts/access control. Use cases: safety, security, access control, forensic analysis, missing-vehicle search, flagging stolen license plates — "investigations to access control". Chain covered: camera placement → `LPR` tab ROI → LPR mode / vehicle types → profile parameters → lists/targets → Dashboard/History → alerts → troubleshooting. [TT4:introduction] [TT4:summary]

| Item | Value | Src |
|---|---|---|
| Engine / camera tab | `AI Engines` dropdown → `License Plate Recognition`; tab `LPR` | [TT4:camera-setup] |
| Camera | ≥ `2 megapixels` (`1920×1080`), facing front directly toward plates, mounted relatively close to the vehicles and low to the ground | [TT4:considerations] [TT4:troubleshooting] |
| LPR mode | `Parking Lot` < 10 mph (1×) · `City Road` 10–40 mph (2×) · `Highway` > 40 mph (3×) | [TT4:analytic-setup] |
| Vehicle Types | default all vehicle types selected | [TT4:analytic-setup] |
| Profile defaults | `License Plate confidence level` `30%` (shown `.3`); minimum plate `40 px` wide × `20 px` tall; no maximum | [TT4:profile] |
| Where results appear | License Plate Recognition tab: `Dashboard` (real time) and `History` (forensic, up to 30 days) | [TT4:dashboard] [TT4:history] |
| Lists / targets | list = named group with list color; target = `name` + list; optional `expiration date` auto-deletes the target | [TT4:lpr-list] [TT4:lpr-target] |
| Alerts | `Alert Dashboard > Alert Rule` → `Alert Type` = `License Plate Recognition`; channels HTTP, email (SMTP), Vaidio App, VMS | [TT4:alerts] |
| Written reference | License Plate Recognition User Guide on the Partner Portal | [TT4:lpr-list] [TT4:summary] |

## Camera and scene requirements
| Requirement | Value | Src |
|---|---|---|
| Minimum resolution | `2 megapixels`; most deployments need at least 2 MP (`1920×1080`), and the camera must be imported into Vaidio at 2 MP minimum (not only capable of it) | [TT4:considerations] [TT4:troubleshooting] |
| Orientation | Camera faces front, directly toward license plates | [TT4:considerations] |
| Mounting | Relatively close to the vehicles and low to the ground; a camera mounted high above the vehicle is not recommended | [TT4:considerations] [TT4:summary] |
| Plate size | Plates must exceed the `40 × 20` px minimum detection size and be clearly legible in the ROI | [TT4:profile] [TT4:troubleshooting] |
| ROI placement | Cover the area where plates are fully visible and legible | [TT4:camera-setup] |
| Plate on vehicle | Plates must be attached to a vehicle to trigger a read; a plate held up by hand is not read | [TT4:troubleshooting] |
| Lighting | Night / under-lit scenes need external lighting or IR | [TT4:troubleshooting] |
| Shutter | Slow shutter → motion blur; increase shutter speed | [TT4:troubleshooting] |
| Network | Packet loss corrupts frames; constant uptime required | [TT4:troubleshooting] |
| Effectiveness factors | Camera resolution, vehicle speed, lighting conditions | [TT4:summary] |

## Setup procedure
### Enable LPR and draw the ROI [TT4:camera-setup]
1. `Camera` page → select the camera → `edit` button → `Edit Camera` popup.
2. `AI Engines` dropdown (top of the popup) → `License Plate Recognition` → `LPR` tab appears.
3. In `LPR`: click the `Pencil icon` → click in the preview to drop anchor points defining the ROI polygon → click the `checkmark` to finish.
4. Place the ROI where plates are fully visible and legible.

### Analytic setup — right side of the Edit Camera screen, LPR tab [TT4:analytic-setup]
5. `LPR mode`: pick by vehicle speed (see Parameters). Sizing: a server running only Parking Lot-speed cameras supports many more total LPR channels than one running City Road / Highway cameras.
6. `Vehicle Types`: choose which vehicle types' plates to detect (e.g. trucks only). Default all selected.
7. Click the `gear icon` (top center of the screen) → profile parameters.

### Profile parameters and save [TT4:profile]
8. Set `License Plate confidence level`, minimum and maximum plate width/height (see Parameters). The 30% default "will work perfectly" for most deployments; `40 × 20` px minimum with no maximum suits most deployments.
9. Click `save` at the bottom of the popup → dialog asks for a profile name → name it and save → press `save` once more to assign the profile to the current camera → finish with `Save` and `OK`.
10. Reuse: open another camera's profile window → pick the profile from the `profile dropdown list` → `save`. Same process applies the profile to multiple cameras.

### Lists and targets
11. Open the License Plate Recognition tab (its icon in the left navigation, or expand the navigation and find it by name) → `List` → create new lists. A list = entries grouped by an organizing principle: blacklist, whitelist, temporary access, specific security permissions, etc. Lists must be named (example `whitelist`); each has an adjustable list color. [TT4:lpr-list]
12. Batch import: `Import LPR List` button on the list page. File syntax/format is in the License Plate Recognition User Guide on the Partner Portal. [TT4:lpr-list]
13. Targets — added directly to a list or created from detections: [TT4:lpr-target]
   - Required: `name` and a list.
   - Optional: `vehicle owner`, `registration date`, `address`, free-text `description`.
   - Optional `expiration date`: the target is automatically deleted when the date is reached (temporary access).
   - Click `OK` to save; event notifications begin when the plate is detected on cameras running LPR.

## Parameters
| Parameter | Default | Range / options | Effect of raising | Effect of lowering | Src |
|---|---|---|---|---|---|
| `LPR mode` (ROI option, right side of Edit Camera) | not stated | `Parking Lot` (< 10 mph, 1× processing) · `City Road` (10–40 mph, 2× Parking Lot) · `Highway` (> 40 mph, 3× Parking Lot) | Higher-speed mode → more processing per stream (`Highway` uses the most), fewer LPR channels per server | Lower-speed mode → 1 Highway stream's resources run 3 Parking Lot streams | [TT4:analytic-setup] [TT4:profile] [TT4:summary] |
| `Vehicle Types` | all vehicle types selected | any subset (e.g. trucks only) | — | Fewer types → only those vehicles' plates detected | [TT4:analytic-setup] |
| `License Plate confidence level` | `30%` (shown as `.3`) | — | Fewer false plate detections — use when non-plates are identified as plates | Catches plates the AI is missing — use when plates are missed | [TT4:profile] |
| Minimum width / height of license plates | `40 px` wide × `20 px` tall | — | Eliminates small, low-detail plates | Accepts smaller plates | [TT4:profile] |
| Maximum width / height of license plates | no maximum | — | — | Set a maximum when plates fill too much of the screen before they can be read fully | [TT4:profile] |

Profile parameters live in the camera profile under the `LPR` tab, opened via the `gear icon`. [TT4:profile]

## Dashboard, history and search
### Dashboard [TT4:dashboard]
Real-time results as detections occur. Each result shows:
- image snapshot
- license plate number and its confidence reading
- vehicle color and type (e.g. "black car")
- make & model — only if Make & Model Recognition is enabled on the camera (separate lesson/module)
- `List name`, or `Not in List` if the plate is in no list
- the list entry's `Description` field, when present

Filters: camera name or camera group name; most recent results also filterable by vehicle type (e.g. trucks only).

### History [TT4:history]
- `History` tab = forensic plate searching/filtering; does not update in real time.
- Look-back up to `30 days`.
- Filters: camera, time period, lists, vehicle types.

### Add a detection to an LPR list [TT4:add-detection-to-lpr-list]
1. Click the detection's icon → view with the scene image on the left and a close-up of the detected plate.
2. If the OCR'd plate text is wrong, correct it manually before adding.
3. Click `Add to LPR List` → `Add License Plate` popup → fill any additional target info (owner, dates, description, etc.) and save.
- All detected plates appear on the LPR dashboard whether or not they are in a list; list membership matters for alerts (configured in the Alert dashboard).

## Alerts [TT4:alerts]
- Path: `Alert Dashboard` → `Alert Rule` tab → add a new alert → `Alert Type` dropdown = `License Plate Recognition`.
- Scope: the cameras to alert on, and the specific license plate lists (e.g. a "Watchlist"). `Not in list` vehicles can also be alerted on.
- Delivery / action channels:

| Channel | Use | Src |
|---|---|---|
| HTTP | Talk to external devices such as a gate sensor for access control | [TT4:alerts] |
| Email via SMTP | Notification | [TT4:alerts] |
| Vaidio App | Push notifications | [TT4:alerts] |
| VMS integrations | Many supported | [TT4:alerts] |

## Troubleshooting
Review scenes in `Object Search` after the camera has processed plates. [TT4:troubleshooting]

| Symptom | Cause | Fix | Src |
|---|---|---|---|
| Plates tiny in Object Search, characters not legible | Insufficient pixels on plate; AI cannot invent detail | Better-suited camera/view so plates exceed the `40 × 20` px minimum detection size and are clearly legible | [TT4:troubleshooting] |
| Plate held up by hand in front of the camera is not read | Plates must be attached to a vehicle to trigger a read | Test with a plate mounted on a vehicle | [TT4:troubleshooting] |
| Plates exceed minimum size but are blurred / unreadable (motion) | Shutter speed too slow → motion blur | Increase camera shutter speed | [TT4:troubleshooting] |
| Plates unreadable — low resolution | Camera < 2 MP, or imported into Vaidio below 2 MP | At least `2 megapixels (1920×1080)`; confirm camera capability **and** import at 2 MP minimum | [TT4:troubleshooting] |
| Plates not readable at night / under-lit | Insufficient illumination | Add external lighting or deploy IR at night | [TT4:troubleshooting] |
| Plates intermittently corrupted / invisible | Network packet loss corrupting frames | Ensure constant network uptime | [TT4:troubleshooting] |
| Non-plates identified as plates | Confidence level too low | Raise `License Plate confidence level` above `30%` | [TT4:profile] |
| Real plates missed | Confidence level too high | Lower `License Plate confidence level` | [TT4:profile] |
| Plates fill too much of the screen before they can be read fully | No maximum plate size set | Set maximum width / height | [TT4:profile] |

## Knowledge checks (facts the course tests)
- Three best practices for optimal LPR: minimum resolution of 2 megapixels, camera facing front, camera mounted low (not 1 MP / high / sideways; not 4 MP / rear / high). [TT4:considerations]
- For every 1 stream of LPR in `Highway` mode you could run 3 streams in `Parking Lot` mode; `City Road` costs 2× Parking Lot — the modes do not use equal processing. [TT4:profile]
- LPR alerts for listed vehicles entering a parking garage can go to an external system through HTTP, email, Vaidio App notifications and VMS integrations; alerts can drive access control (not email-only). [TT4:alerts]
- Key components for LPR effectiveness across environments: camera resolution, vehicle speed and lighting conditions (not brand/UI/updates; not bandwidth/permissions/history). [TT4:summary]
- A camera mounted high above the vehicle is not a recommended LPR spec; recommended: ≥ 2 MP, facing directly toward plates, mounted low. [TT4:summary]
- `Highway` mode uses the most processing power. [TT4:summary]
- Default license-plate detection confidence level is `30%`. [TT4:summary]
- Any type of list can be created with a name; blacklist, whitelist and temporary access are only examples. [TT4:summary]

## Lesson index
| # | Lesson (slug) | Min | Video | Topic |
|---|---|---|---|---|
| 1 | introduction | 1 | HubSpot 187319161104 | Module goals, LPR use cases |
| 2 | considerations | 1 | HubSpot 187315447865 | 2 MP, facing plates, mounted low |
| 3 | camera-setup | 1 | HubSpot 187319093649 | `Edit Camera` → `AI Engines` → `LPR` tab, ROI drawing |
| 4 | analytic-setup | 1 | HubSpot 187316203853 | `LPR mode` (3 modes), `Vehicle Types`, `gear icon` |
| 5 | profile | 2 | HubSpot 187316488114 | Confidence `30%`, `40 × 20` px min, no max, save profile |
| 6 | lpr-list | 1 | HubSpot 187316203847 | Lists, list color, `Import LPR List` |
| 7 | lpr-target | 1 | HubSpot 187316203850 | Target fields, `expiration date` auto-delete |
| 8 | dashboard | 1 | HubSpot 187316296758 | Real-time result fields and filters |
| 9 | history | 1 | HubSpot 187316296752 | 30-day forensic search, filters |
| 10 | add-detection-to-lpr-list | 1 | HubSpot 187319093652 | Detection → list, manual OCR correction |
| 11 | alerts | 1 | HubSpot 187316296755 | `Alert Type` = `License Plate Recognition`, channels |
| 12 | troubleshooting | 2 | HubSpot 187316203856 | Object Search review, plate-on-vehicle, IR/lighting |
| 13 | summary | 1 | HubSpot 187311289738 | Recap, 5-question check-in |

## Source notes
- Course-code inconsistency: the course page title reads `TT6. License Plate Recognition` while the course header reads `TT4. License Plate Recognition`; TT4 is the inventory code used here.
- `Import LPR List` file syntax/format is not shown in the lesson; it is documented in the License Plate Recognition User Guide on the Partner Portal (external, not captured). [TT4:lpr-list] [TT4:summary]
- Make & Model Recognition is referenced (dashboard field; summary says the module covered the LPR and Make & Model Recognition AI Engines) but is taught in a separate lesson/module not part of this course. [TT4:dashboard] [TT4:summary]
- Default `LPR mode` is not stated.
- Naming differs from the other analytic courses: this course says `edit` button / `Edit Camera` popup / `AI Engines` dropdown where others say `pencil icon` / `Camera Edit` window / `AI Engine`.
- The profile save sequence is given twice: `save` → name → `save`, then "finish with `Save` and `OK`". [TT4:profile]
- Course is complete (all 13 lessons captured); videos not transcribed.
