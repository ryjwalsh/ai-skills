# Intrusion Detection — Vaidio University TT9 "Intrusion Detection"

> Source: Vaidio University (university.vaidio.ai) course TT9, 9 lessons, captured 2026-10-17. Written-lesson content plus check-in questions; embedded videos were not transcribed except where noted. UI names reflect the Vaidio 7.x–9.x web UI shown in the course — verify against the deployed version. Full source table: ../sources.md.

## At a glance
Intrusion Detection is presented as one of the most versatile AI analytic engines on the platform: Vaidio Object Detection plus configurable, boundary-based (ROI-defined) events. The course runs camera → ROI → analytic parameters → dashboard/history → alerts → troubleshooting, including processing and forwarding alerts to third-party systems. Course outcome: get Intrusion Detection running on a camera, set up the ROI, alert parameters and alert rules, and adapt it to specific use cases. [TT9:introduction] [TT9:summary]

| Item | Value | Src |
|---|---|---|
| `AI Engine` selection | `Intrusion` | [TT9:roi-setup] |
| Engine tab above camera preview | `ID` | [TT9:roi-setup] |
| Default AI Model | `PowerModel` — any object type in the active model can trigger | [TT9:analytics-setup] |
| Object types per ROI | max 10 | [TT9:analytics-setup] |
| Minimum camera resolution | 2 megapixels | [TT9:considerations] |
| Minimum target size | 30x30 pixels (default minimum pixel size) | [TT9:considerations] [TT9:troubleshooting] |
| Default sensitivity | 2 frames/s processed; detect in 5 of every 20 processed frames (= 10 s of video) → 2.5 s minimum to trigger | [TT9:analytics-setup] |
| Default schedule | 24/7 (trigger any time conditions are met) | [TT9:analytics-setup] |
| Results | Intrusion Detection dashboard (own icon in side navigation) + `History` tab, 30 days back | [TT9:dashboard] [TT9:history] |
| `Alert Type` | `Intrusion` | [TT9:alerts] |
| Alert outputs | email, app, VMS partner integration | [TT9:alerts] |

## Camera and scene requirements
[TT9:considerations] [TT9:troubleshooting]
- Analytics are not one-size-fits-all; each engine has its own camera considerations.
- Minimum resolution `2 megapixels`; desired targets captured at `30x30 pixels` or larger.
- Rule of thumb for the 30x30 minimum: the target is clearly visible and unmistakable to the human eye in the camera view.

## Setup procedure
**Add the engine and draw ROIs** [TT9:roi-setup]
1. Click the `pencil icon` (right side of the screen) on the chosen camera → `Camera Edit` window.
2. `AI Engine` dropdown (top of the view) → `Intrusion`. A new tab `ID` appears above the camera preview.
3. On `ID`, draw the region of interest = the area Vaidio concentrates on (monitors for objects).
4. Click the `checkmark` to complete the ROI.
5. Multiple ROIs on the same camera are allowed: repeat steps 3–4.
6. Optional `Exclude ROI` button (next to the pencil icon): draws an Exclusion ROI inside the Intrusion ROI that never triggers events — for areas of no concern, or parts of the camera FoV that would produce too many unnecessary events.

**Configure each ROI** (ROI list on the right side of the Edit Camera screen) [TT9:analytics-setup]
7. Name the ROI after the event it should trigger (lesson example `Person Event Detected`).
8. Select object types: any type in the active AI Model (default `PowerModel`), max 10 per ROI (example: Person).
9. Per object type, optionally include/exclude specific colors and set quantities (example: a group of more than 3 people wearing red).
10. `With` / `Without`: trigger on an object with or without another object (example lost pets = dog **without** person).
11. `AND` / `OR`: `AND` = all selected object types must be present in the ROI at once; `OR` = any one selected type triggers.
12. Schedule (default any time, 24/7). To restrict: `Clear All` (resets the schedule) → `Add Time` → pick the time interval → specific days of the week or everyday → `OK`. Example: everyday, midnight to 6am.
13. Set `Sensitivity`, `Dedupe Events` and `Cooldown Interval` (table below).
14. ROI changes save automatically; click `Save` on the Edit Camera popup to save all settings.

## Parameters
| Parameter | Default | Range / options | Effect of raising (faster / ON) | Effect of lowering (slower / OFF) | Src |
|---|---|---|---|---|---|
| `Sensitivity` — how fast an event triggers | "very high accuracy" setting: 2 frames of video processed per second; object must be detected in 5 of every 20 processed frames (20 frames = 10 s of video) → minimum 2.5 s to trigger | Faster option quoted: 2 frames in 5 seconds → triggers in 1 s. Other steps not stated | Fewer frames evaluated, so the object need not stay in the ROI as long; quicker but potentially less accurate | Not described beyond the default being the high-accuracy setting | [TT9:analytics-setup] |
| `Dedupe Events` | not stated | ON / OFF | ON: the object must leave the ROI and re-enter before a new event fires; only one event while objects remain in the ROI (exists to eliminate repetitive alerts) | OFF: events fire continuously as long as the object type stays in the ROI | [TT9:analytics-setup] [TT9:troubleshooting] |
| `Cooldown Interval` | not stated | seconds (example 9) | Time between event triggers while conditions persist: Cooldown 9 seconds → an event every 9 seconds | — | [TT9:analytics-setup] |
| Object types | — | max 10 per ROI; any type in the active AI Model | — | — | [TT9:analytics-setup] |
| Color / quantity attributes | — | per object type: include or exclude colors; quantity (e.g. more than 3 people wearing red) | — | — | [TT9:analytics-setup] |
| `With` / `Without` | — | object with / without another object | — | — | [TT9:analytics-setup] |
| `AND` / `OR` | — | AND = all selected types present at once; OR = any one | — | — | [TT9:analytics-setup] |
| Schedule | 24/7 | `Clear All` → `Add Time` → interval → days of week or everyday → `OK` | — | — | [TT9:analytics-setup] |
| Minimum pixel size | 30x30 pixels | — | — | — | [TT9:troubleshooting] |

## Dashboard, history and search
**Dashboard** [TT9:dashboard]
- Open via the Intrusion Detection icon in the side navigation, or expand the nav tab and find it by name.
- `Select Camera` dropdown → live view with Intrusion results; results also populate in real time on the right-hand side.
- Click a result image → shows the Intrusion ROI together with the object that triggered it.
- Filters: camera name, camera group name, region of interest names.

**History** [TT9:history]
- `History` tab = search for specific Intrusion events over a chosen time period; does **not** update in real time (unlike the Dashboard); provides tools to review data over time.
- Depth up to 30 days back. Filters: camera, time period, ROI.

## Alerts
[TT9:alerts]
- Events are real-time results on the server; an alert is also real time but can be forwarded externally: email, app, or a VMS partner integration.
- Path: `Alert` menu (`bell icon`, or expand the nav to find it by name) → `Alert Rule` tab → `Add Alert`.
- `Define Rule`: alert type, alert conditions, optional schedule (e.g. intrusions midnight–6am). The schedule uses the same rules as the camera-side analytic schedule.
- `Alert Type` = `Intrusion` → select the associated Intrusion ROIs. Filter cameras by typing `Camera`, `Camera Group` or `ROI` names. Name the alert → `OK`.
- Necessary setup steps: select the alert type, define the conditions, set a schedule. Adjusting the camera's physical position is not an alert-setup step.

## Troubleshooting
| Symptom | Cause | Fix | Src |
|---|---|---|---|
| Objects not detected (visibility) | Object smaller than the minimum pixel size (default `30x30 pixels`) | Ensure the target meets the minimum pixel size; rule of thumb: clearly visible and unmistakable to the human eye in the camera view | [TT9:troubleshooting] |
| Fast-moving objects missed | Object passes through the ROI faster than the default sensitivity window | Increase the ROI sensitivity, e.g. `2 frames in 5 seconds`, to capture the event sooner | [TT9:troubleshooting] |
| Not getting regular event notifications | Dedupe setting does not match the use case | Verify dedupe is enabled/disabled appropriately; with dedupe enabled only one event fires while objects remain in the ROI (dedupe exists to eliminate repetitive alerts) | [TT9:troubleshooting] |
| No detections at all | Logic set to `AND` instead of `OR` for the object types | Double-check the AND/OR selection | [TT9:troubleshooting] |

## Knowledge checks (facts the course tests)
- Minimum recommended camera resolution for Intrusion Detection is 2 megapixels (options offered: 1 megapixel / 2 megapixels / 4 megapixels / 1080p). [TT9:considerations]
- An Exclude ROI exists to block areas that should not trigger events — not to increase FoV, resolution, or save processing time. [TT9:roi-setup]
- Alert setup consists of selecting the alert type, defining the conditions and setting a schedule; adjusting the camera's physical position is not a necessary step. [TT9:alerts]
- The primary function of Intrusion Detection is to detect and alert on specific boundary-based events (not video quality, continuous recording, or audio). [TT9:summary]
- The default Intrusion Detection setting processes 2 frames of video per second (True). [TT9:summary]
- `Schedule` is the setting that limits event triggers to specific times of day (not Sensitivity, ROI Setup, or Dedupe Events). [TT9:summary]
- When regular event notifications are not arriving, check "All of the above": the ROI sensitivity, the dedupe setting, and the camera's resolution. [TT9:summary]
- The History tab does not update in real time (False to "updates in real time"). [TT9:summary]

## Lesson index
| # | Lesson (slug) | Min | Video | Topic |
|---|---|---|---|---|
| 1 | introduction | 1 | HubSpot 187339020635 | Engine overview, module scope |
| 2 | considerations | 1 | HubSpot 187339217979 | 2 MP, 30x30 px; 1 check-in |
| 3 | roi-setup | 1 | HubSpot 187335551366 | `AI Engine` → `Intrusion`, `ID` tab, ROI, `Exclude ROI`; 1 check-in |
| 4 | analytics-setup | 4 | HubSpot 187339168799 | Naming, object types, attributes, With/Without, AND/OR, schedule, sensitivity, dedupe, cooldown |
| 5 | dashboard | 1 | HubSpot 187335635035 | Live results and filters |
| 6 | history | 1 | HubSpot 187339020632 | 30-day search |
| 7 | alerts | 1 | HubSpot 187335551363 | Alert rule, `Alert Type` `Intrusion`; 1 check-in |
| 8 | troubleshooting | 1 | HubSpot 187335862663 | Pixel size, sensitivity, dedupe, AND/OR |
| 9 | summary | 1 | HubSpot 187339168796 | Recap; 5 check-ins |

## Source notes
- Defaults for `Dedupe Events` and `Cooldown Interval` are not stated; the lesson gives only the 9-second cooldown example. Sensitivity values other than the default and the "2 frames in 5 seconds" option are not listed.
- The sensitivity figures (2 fps, 5 of 20 frames, 10 s window, 2.5 s minimum, 1 s fast option) are repeated verbatim in TT14 [TT14:sensitivity].
- Dedupe ON is described here only as "leave the ROI and re-enter"; TT12 [TT12:roi-settings] and TT14 [TT14:dedupe] add that with Dedupe ON the cooldown is the time the object must stay out of the ROI before tracking restarts.
- The alert rule is confirmed with `OK` in this course; TT10 and TT12 end the same dialog with `save` / `Save`.
- The default AI model is written `PowerModel` here and `Power Model` in TT13 [TT13:profile].
- Alert forwarding to "VMS partner" integrations is mentioned without naming vendors.
