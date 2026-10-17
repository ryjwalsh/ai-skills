# Crowd Detection — Vaidio University TT5 "Crowd Detection"

> Source: Vaidio University (university.vaidio.ai) course TT5, 9 lessons, captured 2026-10-17. Written-lesson content plus check-in questions; embedded videos were not transcribed except where noted. UI names reflect the Vaidio 7.x–9.x web UI shown in the course — verify against the deployed version. Full source table: ../sources.md.

## At a glance
Crowd Detection is a specialized analytic that detects and alerts on large crowds inside an ROI; best used for 30+ people. It counts heads or persons and fires an event when the count reaches the `Crowd Threshold` (a minimum). Chain covered: camera → `CD` tab ROI → analytic settings → Abnormal Dashboard/History → alerts → troubleshooting. [TT5:introduction] [TT5:summary]

| Item | Value | Src |
|---|---|---|
| Engine / camera tab | `AI Engine` dropdown → `Crowd`; tab `CD` appears above the camera preview | [TT5:roi-setup] |
| Camera | ≥ `2 megapixels` (`1920×1080`); people at least `30 × 30` pixels | [TT5:considerations] [TT5:troubleshooting] |
| Detection type | `Head` (occluded, dense crowds) or `Person` (bodies do not overlap) | [TT5:analytic-settings] |
| `Crowd Threshold` | minimum people in ROI to trigger (e.g. `30` → 30+); no default stated | [TT5:analytic-settings] |
| Event cadence | `Dedupe Events` on/off; `Cooldown Interval` in seconds (e.g. `5`) | [TT5:analytic-settings] |
| Where results appear | Abnormal Dashboard (`exclamation-point icon`), with crowd count; `History` up to 30 days | [TT5:dashboard] [TT5:history] |
| Alert type | `Alert Type` = `Crowd`, scoped to Crowd Detection ROIs | [TT5:alerts] |
| Save | ROI changes save automatically; `OK` on the Edit Camera popup saves all settings | [TT5:analytic-settings] |

## Camera and scene requirements
| Requirement | Value | Src |
|---|---|---|
| Minimum resolution | `2 megapixels`; most deployments need at least 2 MP (`1920×1080`), and the camera must be imported into Vaidio at 2 MP minimum (not only capable of it) | [TT5:considerations] [TT5:troubleshooting] |
| Pixels on target | People (desired targets) at least `30 × 30` pixels | [TT5:considerations] [TT5:troubleshooting] |
| Occlusion | Where bodies are blocked by other people (e.g. a concession-stand line) use `Head` type, not `Person` | [TT5:analytic-settings] [TT5:troubleshooting] |
| Network | Consistent connection so events are detected and triggered as soon as they occur | [TT5:troubleshooting] |
| ROI | The area Vaidio concentrates on in this view; the count is taken inside the ROI | [TT5:roi-setup] [TT5:analytic-settings] |

## Setup procedure
### Add Crowd Detection and draw the ROI [TT5:roi-setup]
1. Click the `pencil icon` (right side of the screen) on the chosen camera → `Camera Edit` window.
2. `AI Engine` dropdown (top right of the view) → `Crowd` → new tab `CD` appears above the camera preview.
3. In `CD` draw the ROI.

### Analytic settings — right side of the Edit Camera page [TT5:analytic-settings]
4. `ROI name` — required (lesson example `Crowd Detected`).
5. `Crowd Detection type` — `Head` or `Person`.
6. `Crowd Threshold` — minimum number of people inside the ROI that triggers an event (type `30` to trigger on crowds of 30+).
7. `Dedupe Events` toggle and `Cooldown Interval` (see Parameters).
8. ROI changes are saved automatically; click `OK` on the Edit Camera popup to save all settings.

## Parameters
| Parameter | Default | Range / options | Effect of raising | Effect of lowering | Src |
|---|---|---|---|---|---|
| `ROI name` | — (required) | free text, e.g. `Crowd Detected` | — | — | [TT5:analytic-settings] |
| `Crowd Detection type` | not stated | `Head` · `Person` | `Head`: heavily crowded areas where bodies are occluded by other people (concession-stand line) | `Person`: scenes where bodies do not overlap | [TT5:analytic-settings] |
| `Crowd Threshold` | not stated | people count (e.g. `30`) | Larger crowd needed before an event fires | Smaller crowds trigger events | [TT5:analytic-settings] [TT5:roi-setup] |
| `Dedupe Events` | not stated | On · Off | On: the threshold event fires once and does not re-trigger while the condition persists; re-arms only after the count drops below the threshold and reaches it again | Off: events keep triggering continuously for as long as the crowd condition persists in the ROI | [TT5:analytic-settings] |
| `Cooldown Interval` | not stated | seconds (e.g. `5` → an event every 5 s while the crowd persists) | Longer gap between event triggers while conditions are met | More frequent events | [TT5:analytic-settings] |

`Crowd Threshold` is a minimum, not a maximum. [TT5:roi-setup]

## Dashboard, history and search
### Abnormal Dashboard [TT5:dashboard]
- Crowd Detection events appear on the Abnormal Dashboard: left-hand menu `exclamation-point icon`, or expand the menu and find it by name.
- `Select Camera` dropdown → live view of that camera's crowd events.
- Real-time results populate on the right-hand side with the crowd count number.
- `Refresh` button pauses the real-time event notifications.
- Clicking a result image shows the Crowd Detection ROI and the crowd size that triggered it.
- Filters: camera name and camera group name (the Abnormal dashboard aggregates many analytics); the bar next to the camera filter filters by analytic type (e.g. only Crowd Detection).

### History [TT5:history]
- `History` tab on the Abnormal dashboard = forensic search/filter; not real time.
- Look-back up to `30 days`.
- Filters: camera, time period, type of abnormal event.

## Alerts [TT5:alerts]
Alerts live in the `Alert` menu — `bell icon` in the left menu, or expand the menu and find it by name. Reasons to create a rule: view all analytics in one dashboard; send notifications to external devices such as a VMS.
1. `Alert Rule` tab → `Add Alert`.
2. Under `Define Rule` set the alert type, the conditions, and optionally a schedule.
3. `Alert Type` = `Crowd`; select the associated Crowd Detection ROIs. Cameras can be filtered by typing `Camera`, `Camera Group` or `ROI` names.
4. Give the alert a name → `Save`.

Schedule belongs to the alert rule, not to the camera ROI settings. [TT5:alerts]

## Troubleshooting
| Symptom | Cause | Fix | Src |
|---|---|---|---|
| People not detected / counts low | Objects too small | Ensure people are at least `30 × 30` pixels | [TT5:troubleshooting] |
| Poor detection generally | Camera resolution below 2 MP, or imported below 2 MP | At least `2 megapixels (1920×1080)`; confirm the camera supports it **and** is imported into Vaidio at 2 MP minimum | [TT5:troubleshooting] |
| ROI set to `Person` misses people in the scene | Bodies blocked by other people (occlusion) | Change `Crowd Detection type` to `Head` | [TT5:troubleshooting] |
| Events missed / stream corruption | Inconsistent network | Provide a consistent network connection so events are detected and triggered as soon as they occur | [TT5:troubleshooting] |
| Only one event while the crowd persists | `Dedupe Events` on | Turn `Dedupe Events` off (continuous events at the `Cooldown Interval`) | [TT5:analytic-settings] |

## Knowledge checks (facts the course tests)
- `Crowd Threshold` is the minimum number of people required in the ROI to trigger an event — not the maximum. [TT5:roi-setup]
- Parameters defined for Crowd Detection on the `Edit Camera` page: `Crowd detection type`, the minimum crowd size threshold to trigger an alert (`Crowd Threshold`), and `Cooldown interval`. Camera model is not one; schedule is set on the alert rule, not the camera ROI. [TT5:alerts]
- The summary lesson has no check-in question. [TT5:summary]

## Lesson index
| # | Lesson (slug) | Min | Video | Topic |
|---|---|---|---|---|
| 1 | introduction | 1 | HubSpot 187317594670 | Large crowds, best for 30+ people |
| 2 | considerations | 1 | HubSpot 187314851165 | 2 MP, `30 × 30` px people |
| 3 | roi-setup | 1 | HubSpot 187314851168 | `pencil icon` → `AI Engine` → `Crowd` → `CD` tab, ROI |
| 4 | analytic-settings | 2 | HubSpot 187317775270 | `ROI name`, `Head`/`Person`, `Crowd Threshold`, `Dedupe Events`, `Cooldown Interval` |
| 5 | dashboard | 1 | HubSpot 187314772497 | Abnormal Dashboard, crowd count, filters |
| 6 | history | 1 | HubSpot 187317335453 | 30-day forensic search |
| 7 | alerts | 1 | HubSpot 187317384753 | `Alert Type` = `Crowd`, ROIs, `Save` |
| 8 | troubleshooting | 1 | HubSpot 187311289636 | Pixel size, resolution, `Head` vs `Person`, network |
| 9 | summary | 1 | HubSpot 187314772494 | Recap; no check-in |

## Source notes
- Defaults not stated: `Crowd Detection type`, `Crowd Threshold`, `Dedupe Events`, `Cooldown Interval` (only examples `30` and `5 seconds` given).
- No mounting-height or camera-angle figures are given for Crowd Detection.
- The Considerations lesson gives `30 × 30` px without a resolution-import caveat; the 2 MP import requirement comes from the Troubleshooting lesson. [TT5:considerations] [TT5:troubleshooting]
- Unlike Dwell Detection (TT6), this course does not describe a changed meaning of `Cooldown Interval` when `Dedupe Events` is on.
- Course is complete (all 9 lessons captured); videos not transcribed.
