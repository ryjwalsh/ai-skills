# Analytics parameter matrix — cross-course synthesis (TT1–TT14)

> Synthesised from the per-analytic references in this folder; every cell carries the course tag it came from. Where courses disagree the matrix shows both values and the discrepancy is listed at the end and in ../known-gaps.md. "—" = the course did not state it (do not invent a value).

## 1. Engine selection, geometry and where results appear

| Analytic | `AI Engine` entry → tab code | Drawn on the camera still | Max object types | Results page | `Alert Type` | Src |
|---|---|---|---|---|---|---|
| Object Detection (foundation) | none — always on from the first `OK` on a camera; tuned via `General ROI` + `Profile` | `General ROI` quadrilateral (applies to **all** analytics on the camera) | all classes of the active model (tick per class in `Profile > Object Type`) | `Search` page (all cameras), `Heatmap` on the statistics tab | `Object Detection` (vendor recommends alerting from purpose-built engines instead) | [TT13:analytic-setup] [TT13:alerts] [TT2:general-roi] |
| Intrusion Detection | `Intrusion` → `ID` | polygon ROI(s) of any shape + optional `Exclude ROI` | 10 per ROI | `Intrusion` page: `Dashboard` / `History` (30 days) | `Intrusion` | [TT9:roi-setup] [TT9:analytics-setup] [TT9:history] |
| Object Counting | `Object Counting` → `OC` | **line pair** (lines `1` and `2`, four draggable points, `In`/`Out` arrows) | 10 per line | `Object Counting` page: `Dashboard` / `History` (hourly / daily / monthly, Excel export) | Object Counting rule with `Counting Rule` `In` / `Out` | [TT11:line-setup] [TT11:line-settings] [TT1:managing-incoming-alerts] [TT11:alerts] |
| Object Wrong Direction | `Object Wrong Direction` → `OWD` | line pair; red arrow = the *wrong* direction | 10 per line | `Abnormal` dashboard (exclamation icon) / `History` (30 days, Excel) | `OWD` | [TT10:line-setup] [TT10:dashboard] [TT10:alerts] |
| Object Left Behind | `Object Left Behind` → `OLB` | polygon ROI(s); prefer several small ROIs | 10 per ROI, combined with OR | `Abnormal` dashboard / `History` (30 days, Excel) | `Object Left Behind` | [TT12:analytic-setup] [TT12:roi-settings] [TT12:alerts] |
| Crowd Detection | `Crowd` → `CD` | polygon ROI | — | `Abnormal` dashboard / `History` (30 days) | `Crowd` | [TT5:roi-setup] [TT5:dashboard] [TT5:alerts] |
| Dwell Detection | `Dwell` → `DD` | polygon ROI of any shape | 10 per ROI | `Abnormal` dashboard / `History` (30 days, Excel) | `Dwell` | [TT6:roi-setup] [TT6:roi-settings] [TT6:alerts] |
| Person Fall | `Person Fall` → `PF` | polygon ROI of any shape | — | `Abnormal` dashboard / `History` (30 days, Excel) | `Person Fall` | [TT8:roi-setup] [TT8:abnormal-tab] [TT8:alerts] |
| Face Recognition | `Face Recognition` → `FR` | ROI where faces are largest and frontal | n/a (lists + targets) | `Face Recognition` page: `Dashboard` / `History` (30 days) / lists | Face Recognition rule scoped by cameras + lists (incl. `not in list`) | [TT3:camera-setup] [TT3:history] [TT3:alerts] |
| License Plate Recognition | `License Plate Recognition` → `LPR` | one rectangular ROI auto-created as `License Plate Recognition ROI` (7.2 UI) / drawn polygon where plates are legible (TT4) | n/a (vehicle types + lists) | `License Plate Recognition` page: `Dashboard` / `History` (30 days) / `List` | `License Plate Recognition` | [TT1:setting-up-license-plate-recognition] [TT4:camera-setup] [TT4:alerts] |
| Human Attributes | `Human Attributes` → `HA` profile tab | none (no ROI) | n/a | `Search` → `Person` + `Clothing` filters | via `Object Detection` rule (clothing attributes) | [TT7:ha-setup] [TT7:finding-target] [TT7:alerts] |

The `Abnormal` dashboard aggregates Crowd, Dwell, Object Wrong Direction, Object Left Behind and Person Fall; filter it by camera name, camera group and analytic/abnormal type. `Refresh` **pauses** the real-time feed on that dashboard. [TT5:dashboard] [TT6:dashboard] [TT10:dashboard]

## 2. Camera and scene requirements

| Analytic | Minimum resolution | Pixels on target | Placement / view | Src |
|---|---|---|---|---|
| Object Detection | 2 MP (1920x1080) stated in troubleshooting | 30x30 px (lowerable to 10 in `Profile`) | camera on the same network as Vaidio; objects fully visible | [TT13:considerations] [TT13:troubleshooting] |
| Intrusion | 2 MP | 30x30 px | — | [TT9:considerations] |
| Object Counting | — (not stated) | — | adequate, unobstructed view; smooth traffic flow through the line pair | [TT11:considerations] [TT11:troubleshooting] |
| Object Wrong Direction | 2 MP | 30x30 px | strong, stable network; lines in the middle of the FoV, small gap | [TT10:considerations] [TT10:line-setup] |
| Object Left Behind | — | 30x30 px (troubleshooting) | adequate, unobstructed view | [TT12:considerations] [TT12:troubleshooting] |
| Crowd | 2 MP | 30x30 px | use `Head` type where bodies occlude each other | [TT5:considerations] [TT5:analytic-settings] |
| Dwell | — | 30x30 px | adequate, unobstructed view | [TT6:considerations] |
| Person Fall | 2 MP (troubleshooting + quiz) | 100x100 px (larger than other analytics because of pose complexity) | complete, unobstructed view; nothing may block part of a person | [TT8:considerations] [TT8:troubleshooting] |
| Face Recognition | 2 MP | face ≥ 64x64 px (default minimum), ≥ 100x100 px recommended | frontal, camera mounted 6–8 ft; adjust height with distance | [TT3:considerations] [TT3:fr-parameters] |
| License Plate Recognition | 2 MP | plate ≥ 40x20 px (default minimum) | frontal to plates, close to vehicles and low to the ground; lighting/IR at night | [TT4:considerations] [TT4:profile] [TT4:troubleshooting] |
| Human Attributes | 2 MP | person ≥ 200x200 px (default; raisable to 600) | — | [TT7:considerations] [TT7:profile] |
| POC general rule | 1920x1080p / 2 MP recommended minimum for most use cases | 30 px minimum (single dimension quoted) | tighter FoV = more pixels per foot | [TT14:camera-resolution] [TT14:verifying-pixel-size] [TT14:object-detail] |

## 3. Shared parameters (ROI-based engines)

| Parameter | Where | Default | Range / options | Semantics | Src |
|---|---|---|---|---|---|
| `Confidence[0.01 ~ 1.00]` | `Profile > Object Type`, per class | `0.50` (`Suggested Value` `0.50`); scene-change classes `0.30` | 0.01–1.00 | Lower → more detections and more false positives; higher → fewer true positives | [TT1:setting-up-intrusion-detection] [TT2:camera-popup-window] [TT13:profile] [TT14:confidence] |
| `Minimum ~ Maximum pxl` | `Profile > Object Type`, per class | min `30`, max blank (`--`) | min can be lowered to `10` | Object width **and** height must exceed the minimum | [TT1:setting-up-intrusion-detection] [TT13:profile] [TT14:verifying-pixel-size] |
| `Include Still Object`, `Motion Detection Minimum Object Size`, `Motion Detection Sensitivity` | `Profile` second tab (`VS` per heading/quiz, `OD` per body text) | — | toggle / px / sensitivity | Still-object = stationary objects keep generating events; leave motion sensitivity alone except edge cases | [TT13:profile] |
| `Sensitivity` | ROI rule panel (Intrusion, Person Fall; "many ROI-based analytics") | `5` scenes every `10` s (engine samples 2 fps → 5 of 20 frames → 2.5 s minimum) | scenes `1~20`, seconds `1~30`; fast example `2` in `5` s → 1 s | Fewer scenes / shorter window = faster trigger, more false positives | [TT9:analytics-setup] [TT8:roi-settings] [TT1:setting-up-intrusion-detection] [TT14:sensitivity] |
| `Dedupe Events` | ROI rule panel (Intrusion, Crowd, Dwell, OLB, Person Fall) | ON in the 7.2 UI (TT1/TT2); not stated in the written courses | ON / OFF | ON = one event per episode, re-arm when the object leaves and re-enters (Crowd: count drops below threshold and climbs back); OFF = repeat every cooldown while the condition persists | [TT1:setting-up-intrusion-detection] [TT9:analytics-setup] [TT5:analytic-settings] [TT6:roi-settings] [TT12:roi-settings] [TT8:roi-settings] [TT14:dedupe] |
| `Cooldown Interval` | ROI rule panel | `9` s in the 7.2 UI; written courses use 5 s / 9 s examples, no default | `1 ~ 3,600` seconds | Dedupe OFF: time between repeated events. Dedupe ON (Dwell, OLB, TT14): how long the object must stay **out** of the ROI before tracking restarts | [TT1:setting-up-intrusion-detection] [TT6:roi-settings] [TT12:roi-settings] [TT14:dedupe] |
| Object-type logic | Intrusion rule | `AND` / `OR` toggle; `With` / `Without`; colour include/exclude; quantity | — | `AND` requires every selected class present at once — a common cause of "no detections" | [TT9:analytics-setup] [TT9:troubleshooting] |
| Schedule | ROI rule (`Schedule`) and alert rule | 24/7 (`Forever`) | `Clear All` → `Add Time` → interval → days → `OK` | Same rules on camera side and alert side | [TT9:analytics-setup] [TT9:alerts] [TT1:the-alert-tab] |

## 4. Engine-specific parameters

| Analytic | Parameter | Default | Notes | Src |
|---|---|---|---|---|
| Crowd | `Crowd Detection type` | — | `Head` (occluded crowds, e.g. queues) or `Person` (no overlap) | [TT5:analytic-settings] |
| Crowd | `Crowd Threshold` | — | **minimum** people in the ROI to trigger (e.g. 30); best for 30+ people | [TT5:analytic-settings] [TT5:introduction] |
| Dwell | `Time Threshold` | — | seconds the object must remain (example 30 s; parking example 60 s) | [TT6:roi-settings] [TT6:summary] |
| Object Left Behind | trigger time | — | seconds the object stays with **no person** in the ROI; the countdown restarts whenever a person enters | [TT12:roi-settings] [TT12:analytic-setup] |
| Object Counting | `Enable In Count` / `Enable Out Count` (`Line Direction Count`) | both on | untick one for one-way flows (conveyor, river); direction can be flipped | [TT1:setting-up-object-counting] [TT11:line-settings] |
| Object Counting alert | `Counting Rule` `In` / `Out` | — | exposes "repeat by object count instead of by minutes" | [TT11:alerts] |
| Face Recognition | `Minimum face size` | `64 x 64` px | ≥ 100x100 recommended | [TT3:fr-parameters] |
| Face Recognition | `Similarity threshold` | — | higher = fewer, more accurate matches; affects alerts, authorisations, searches | [TT3:fr-parameters] |
| Face Recognition | `Quality detection` | — | `Low` / `Medium` / `High`; access control → High/Medium, forensics → Medium/Low | [TT3:fr-parameters] |
| Face Recognition (server) | face upload quality threshold | `Low` | `System > Settings`; same Low/Medium/High meaning | [TT3:face-upload-quality-threshold] |
| Face Recognition | targets | — | up to 5 variants per target; required `Name` + list; optional gender, birthday, description | [TT3:face-target] |
| LPR | `Mode` | — | `Parking Lot` 1× (<10 mph) · `City Road` 2× (10–40 mph) · `Highway` 3× (>40 mph) per TT4/ST4; TT1 quotes ≤10 / ≤50 / >50 mph at 2 / 4 / 6 fps | [TT4:analytic-setup] [TT1:setting-up-license-plate-recognition] |
| LPR | `Vehicle Types` | all selected | restrict e.g. to trucks | [TT4:analytic-setup] |
| LPR | plate confidence | `30%` (`.3`) | raise when non-plates are read, lower when plates are missed | [TT4:profile] |
| LPR | plate min / max size | `40` x `20` px / none | set a maximum when plates fill the frame before they can be read | [TT4:profile] |
| LPR | target expiration date | — | target auto-deletes when reached | [TT4:lpr-target] |
| Human Attributes | `Minimum size` ("Minimum Face Size" in one heading) | `200 x 200` px | up to `600` | [TT7:profile] |
| Human Attributes | `Quality detection` | — | enabled = person must be fully visible head to toe; disabled = runs on partially overlapped people | [TT7:profile] |
| Human Attributes search | `Clothing` | — | `Full body`, `Upper body` (long/short sleeves), `Lower body` (pants, shorts, skirts); 10-colour palette | [TT7:finding-target] |

## 5. Alert delivery channels named by the courses
Email (SMTP, `System -> Mail`), HTTP notification (e.g. gate sensor / webhook), Vaidio App push, VMS integrations, text/SMS (mentioned once), door/relay signal via HTTP. Rule anatomy everywhere: `Alert` (bell) → `Alert Rule` → `Add Alert` → `Define Rule` (`Alert Type`, cameras / ROIs / lines / lists, optional `Schedule`) → `Trigger (Optional)` (`Trigger Action`, default `Email Notification`) → name → `Save`/`OK`. [TT4:alerts] [TT7:alerts] [TT2:alert-setup-overview] [TT1:the-alert-tab] [TT14:smtp-connectivity]

## 6. Discrepancies to keep in mind
- LPR mode speed boundaries: 10/40 mph (TT4, ST4) vs 10/50 mph (TT1); cost ratio 1:2:3 is consistent.
- Minimum-size terminology: Person Fall's 100x100 is called the "larger default minimum" yet HA defaults to 200x200.
- `Quality detection` is a three-level mode for FR and an on/off toggle for HA.
- Save/confirm button after engine setup: `Save` (TT9/TT10/TT12/TT6/TT8), `OK` (TT11/TT13/TT1/TT2), `Save` then `OK` (TT4). Alert-rule confirm: `OK` (TT9/TT6) vs `Save` (TT5/TT8/TT10/TT12).
- Default model written `PowerModel` (TT9, 7.2 UI shows `PowerModel-Core-7.2g2-Pro-3.4`) and `Power Model` (TT13).
- Profile second-tab name: `VS` (TT13 heading and quiz, TT1/TT2 UI) vs `OD` (TT13 body text).
