# Dwell Detection — Vaidio University TT6 "Dwell Detection"

> Source: Vaidio University (university.vaidio.ai) course TT6, 9 lessons, captured 2026-10-17. Written-lesson content plus check-in questions; embedded videos were not transcribed except where noted. UI names reflect the Vaidio 7.x–9.x web UI shown in the course — verify against the deployed version. Full source table: ../sources.md.

## At a glance
Dwell Detection ("Dwell") monitors objects over time; if an object remains in a defined ROI for a set duration (`Time Threshold`) an event and alert can be generated. Use cases: loiterers, illegal parking on roads, any scenario where something should not stay in an area for an extended period. Chain covered: camera → `DD` tab ROI → object types / time threshold / dedupe / cooldown → Abnormal Dashboard/History → alerts → troubleshooting. [TT6:introduction] [TT6:summary]

| Item | Value | Src |
|---|---|---|
| Engine / camera tab | `AI Engine` dropdown → `Dwell`; tab `DD` appears above the camera preview | [TT6:roi-setup] |
| Camera | Adequate, unobstructed view; objects at least `30 × 30` pixels wherever tracked | [TT6:considerations] |
| ROI | Any shape (polygon via anchor points), not only rectangles | [TT6:roi-setup] |
| Object types | Any object type in the AI Model (custom models included); maximum 10 per ROI | [TT6:roi-settings] |
| `Time Threshold` | How long the object must stay before an event (e.g. `30 seconds`); no default stated | [TT6:roi-settings] |
| Event cadence | `Dedupe Events` on/off; `Cooldown Interval` seconds — meaning changes when Dedupe is on | [TT6:roi-settings] |
| Where results appear | Abnormal Dashboard (`exclamation-point icon`) with time stayed; `History` up to 30 days, export to Excel | [TT6:dashboard] [TT6:history] |
| Alert type | `Alert Type` = `Dwell`, scoped to Dwell ROIs | [TT6:alerts] |
| Save | Changes apply automatically; `Save` on the Edit Camera popup saves all settings | [TT6:roi-settings] |

## Camera and scene requirements
| Requirement | Value | Src |
|---|---|---|
| View | Adequate, unobstructed view of the subjects; obstructions cause loss of accurate tracking | [TT6:considerations] |
| Pixels on target | Objects at least the recommended minimum `30 × 30` pixels wherever they need to be tracked | [TT6:considerations] |
| Resolution / mounting | No explicit resolution or mounting figures given in this course | [TT6:considerations] |
| Overlap | Minimize object overlap through camera positioning; one object obscuring another breaks tracking | [TT6:troubleshooting] |
| Network / stream | Consistent connection; dropped frames or camera/RTSP downtime make dwell timing inaccurate | [TT6:troubleshooting] |
| Accuracy factors | Network speed, object visibility, camera angle (not the number of cameras on the server) | [TT6:summary] |

## Setup procedure
### Add Dwell and draw the ROI [TT6:roi-setup]
1. Click the `pencil icon` (right side of the screen) on the chosen camera → `Camera Edit` window.
2. `AI Engine` dropdown (top right) → `Dwell` → new tab `DD` appears above the camera preview.
3. In `DD` click the `Pencil icon` to start drawing; click to drop anchor points defining the shape — any shape, not only rectangles.
4. Click the `checkmark` to finish the ROI.

### ROI settings — menu on the right side of the screen [TT6:roi-settings]
5. `ROI name` — required (example `Person Dwell`).
6. Object types — pick up to 10 object types per ROI (example `Person`). Any object type in the AI Model works; a customized AI model deployed on the server is automatically available in Dwell.
7. `Time Threshold` — e.g. Person in ROI for more than `30 seconds`.
8. `Dedupe Events` toggle and `Cooldown Interval` (see Parameters).
9. Changes apply to the camera automatically; click `Save` on the Edit Camera popup to save all settings.

## Parameters
| Parameter | Default | Range / options | Effect of raising | Effect of lowering | Src |
|---|---|---|---|---|---|
| `ROI name` | — (required) | free text, e.g. `Person Dwell`, `Parking Lot` | — | — | [TT6:roi-settings] [TT6:summary] |
| Object types | not stated | any object type in the AI Model, incl. custom models; max 10 per ROI | More types → more object classes tracked for dwell | Fewer types → only those classes tracked | [TT6:roi-settings] |
| `Time Threshold` | not stated | seconds (e.g. `30`; `60` for "parked more than a minute") | Object must stay longer before an event | Shorter stays trigger events | [TT6:roi-settings] [TT6:summary] |
| `Dedupe Events` | not stated | On · Off | On: triggers once per occurrence; no re-trigger while the object remains in the ROI; new event only if the object leaves and re-enters (and again exceeds the threshold) | Off: events trigger continuously for as long as the object stays in the ROI beyond the threshold | [TT6:roi-settings] [TT6:summary] |
| `Cooldown Interval` | not stated | seconds (e.g. `5` → an event every 5 s). **Dedupe off**: time between event triggers while the condition is met. **Dedupe on**: how long the object must be out of the ROI after the initial event before tracking (and a new event) can start again | Longer gap between events, or longer required absence (Dedupe on) | More frequent events, or shorter required absence | [TT6:roi-settings] |

## Dashboard, history and search
### Abnormal Dashboard [TT6:dashboard]
- Dwell events appear on the Abnormal Dashboard: left-hand menu `exclamation-point icon`, or expand the menu and find it by name.
- Real-time results populate on the right-hand side with the time the object type stayed in the ROI.
- `Refresh` button pauses real-time event notifications.
- Clicking a result image shows the Dwell ROI and the dwell time threshold that triggered it.
- Filters: camera name and camera group name; the bar next to the camera filter filters by analytic type (e.g. show only Dwell) — the Abnormal dashboard aggregates many analytics.

### History [TT6:history]
- `History` page = not real time; more control over past data.
- Search by date and time (up to `30 days` back), specific cameras, and types of abnormal events.
- Results can be exported to an Excel spreadsheet.

## Alerts [TT6:alerts]
`Alert` menu — `bell icon`, or expand the menu and find it by name. Use alerts to view all analytics in one dashboard or to push notifications to external devices such as a VMS.
1. `Alert Rule` tab → `Add Alert`.
2. Under `Define Rule` set the alert type, the conditions, and optionally a schedule.
3. `Alert Type` = `Dwell`; select the associated Dwell ROIs. Filter cameras by typing `Camera`, `Camera Group` or `ROI` names.
4. Give the alert a name → click `OK`.

Schedule is set on the alert rule, not on the camera ROI. [TT6:alerts]

## Troubleshooting
| Symptom | Cause | Fix | Src |
|---|---|---|---|
| Inaccurate dwell timing / lost tracks | Dropped frames or downtime on the camera / RTSP stream (Dwell needs a consistent connection) | Fix network speed/stability; ensure no dropped frames or camera downtime | [TT6:troubleshooting] |
| Inaccurate tracking when objects overlap | One object obscures another | Minimize object overlap through camera positioning | [TT6:troubleshooting] |
| Objects not tracked | Objects below the recommended minimum size, or view obstructed | Objects at least `30 × 30` px wherever tracked; unobstructed view | [TT6:considerations] |
| Only Dwell events wanted on the Abnormal Dashboard | Dashboard aggregates many analytics | Filter the analytic type to Dwell | [TT6:dashboard] [TT6:summary] |
| Repeated events for one continuous stay | `Dedupe Events` off | Turn `Dedupe Events` on — one event per occurrence until the object leaves and re-enters | [TT6:roi-settings] |

## Knowledge checks (facts the course tests)
- The Dwell ROI can be drawn in any shape, not only as a rectangle. [TT6:roi-setup]
- Parameters defined for Dwell on the `Edit Camera` page: object types, period of time (`Time Threshold`), and cooldown. Schedule is not one — it is set on the alert rule. [TT6:alerts]
- Primary function of Dwell Detection: track objects that remain in a defined area for a specific time. [TT6:summary]
- With `Dedupe Events` on, the Dwell event triggers once while conditions are met, until the object leaves and re-enters the ROI (and again exceeds the threshold) — it does not re-trigger on every re-entry regardless of time spent. [TT6:summary]
- To trigger once when a vehicle stays parked more than a minute: set `Time Threshold` to `60 seconds` and give the ROI an appropriate name such as `Parking Lot` (not toggling Dedupe off, not exporting History). [TT6:summary]
- Factors affecting Dwell accuracy: network speed, object visibility, camera angle — not the number of cameras on the server. [TT6:summary]
- To show only Dwell events in the Abnormal Dashboard, filter the analytic type to Dwell. [TT6:summary]

## Lesson index
| # | Lesson (slug) | Min | Video | Topic |
|---|---|---|---|---|
| 1 | introduction | 1 | HubSpot 187320444544 | Dwell definition, loitering / illegal parking use cases |
| 2 | considerations | 1 | HubSpot 187320493597 | Unobstructed view, `30 × 30` px |
| 3 | roi-setup | 1 | HubSpot 187320493603 | `pencil icon` → `AI Engine` → `Dwell` → `DD` tab, any-shape ROI |
| 4 | roi-settings | 2 | HubSpot 187320401279 | `ROI name`, object types (max 10), `Time Threshold`, `Dedupe Events`, `Cooldown Interval` |
| 5 | dashboard | 1 | HubSpot 187311289922 | Abnormal Dashboard, time stayed, filters |
| 6 | history | 1 | HubSpot 187320444541 | 30-day search, Excel export |
| 7 | alerts | 1 | HubSpot 187320548642 | `Alert Type` = `Dwell`, ROIs, `OK` |
| 8 | troubleshooting | 1 | HubSpot 187320401282 | Stream consistency, object overlap |
| 9 | summary | 1 | HubSpot 187320493600 | Recap, 5-question check-in |

## Source notes
- Vendor copy-paste slip: the summary page text says "Considerations for best results with Object Counting" although the module is Dwell. [TT6:summary]
- Defaults not stated: object types, `Time Threshold`, `Dedupe Events`, `Cooldown Interval` (only examples `30 seconds` and `5 seconds` given).
- No explicit resolution (2 MP) or mounting figures are given anywhere in this course, unlike the other analytic courses. [TT6:considerations]
- The lesson gives Dwell's special `Cooldown Interval` semantics when `Dedupe Events` is on (required time out of the ROI); the Crowd Detection and Person Fall courses do not describe this. [TT6:roi-settings]
- The alert-rule final button is `OK` here, `Save` in the Crowd Detection and Person Fall courses. [TT6:alerts]
- Course is complete (all 9 lessons captured); videos not transcribed.
