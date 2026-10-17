# Person Fall — Vaidio University TT8 "Person Fall"

> Source: Vaidio University (university.vaidio.ai) course TT8, 9 lessons, captured 2026-10-17. Written-lesson content plus check-in questions; embedded videos were not transcribed except where noted. UI names reflect the Vaidio 7.x–9.x web UI shown in the course — verify against the deployed version. Full source table: ../sources.md.

## At a glance
The Person Fall AI Engine triggers when a person lies down, crouches, squats, kneels, or is in another abnormal position on the floor for more than a few seconds inside the ROI. Use cases: patient health/safety monitoring in healthcare, workplace safety, alerting on abnormal activity in public spaces. Chain covered: camera view → `PF` tab ROI → sensitivity / dedupe / cooldown → Abnormal Dashboard/History → alerts → troubleshooting. [TT8:introduction] [TT8:summary]

| Item | Value | Src |
|---|---|---|
| Engine / camera tab | `AI Engine` dropdown → `Person Fall`; tab `PF` appears above the camera preview | [TT8:roi-setup] |
| Camera | Complete, unobstructed view; ≥ `2 megapixels` (`1920×1080`); target at least `100 × 100` pixels | [TT8:considerations] [TT8:troubleshooting] [TT8:summary] |
| Processing rate | `2 FPS` by default → 20 frames in 10 seconds | [TT8:roi-settings] |
| Sensitivity default | event must be detected in `5` scenes out of the 20 frames seen in `10` seconds (5 scenes / 10 s) | [TT8:roi-settings] |
| More sensitive | `2` scenes in `5` seconds (person very small in the FoV) | [TT8:roi-settings] |
| Event cadence | `Dedupe Events` on/off; `Cooldown Interval` seconds (e.g. `5`) | [TT8:roi-settings] |
| Where results appear | Abnormal Dashboard (`exclamation-point icon`); `History` up to 30 days, export to Excel | [TT8:abnormal-tab] [TT8:history] |
| Alert type | `Alert Type` = `Person Fall`, scoped to Person Fall ROIs | [TT8:alerts] |
| Save | ROI changes save automatically; `Save` saves the camera and closes the window | [TT8:roi-settings] |

## Camera and scene requirements
| Requirement | Value | Src |
|---|---|---|
| View | Complete, unobstructed view of the subjects; angle cameras so nothing can block some or all of an individual — partial occlusion defeats fall detection | [TT8:considerations] |
| Pixels on target | At least `100 × 100` pixels — a larger default minimum than other analytics because of pose complexity | [TT8:troubleshooting] [TT8:summary] |
| Minimum resolution | Most deployments need at least `2 megapixels (1920×1080)`, and the camera must be imported into Vaidio at 2 MP minimum (not only capable of it) | [TT8:troubleshooting] [TT8:summary] |
| ROI size | Large enough to give time to detect the fall event; default settings normally work when it is | [TT8:roi-settings] |
| Network | Consistent connection so events are detected and triggered as they occur | [TT8:troubleshooting] |

The Considerations lesson itself gives no resolution or pixel-size figures; those come from Troubleshooting and the summary quiz. [TT8:considerations]

## Setup procedure
### Add Person Fall and draw the ROI [TT8:roi-setup]
1. Click the `pencil icon` (right side of the screen) on the chosen camera → `Camera Edit` window.
2. `AI Engine` dropdown (top of the view) → `Person Fall` → new tab `PF` appears above the camera preview.
3. In `PF` click the `Pencil icon` to start the ROI; click to drop anchor points — the ROI can be any shape.
4. Click the `checkmark` to finish.

The ROI specifies where Person Fall events will be detected (it does not limit the field of view, raise resolution or adjust sensitivity). [TT8:roi-setup]

### ROI settings — right side of the screen [TT8:roi-settings]
5. Sensitivity ("scenes in N seconds") — leave default `5` scenes / `10` s, or `2` scenes / `5` s when the person is very small in the FoV.
6. `Dedupe Events` toggle and `Cooldown Interval` (see Parameters).
7. ROI changes are saved automatically; press `Save` to save the camera and close the window.

## Parameters
| Parameter | Default | Range / options | Effect of raising | Effect of lowering | Src |
|---|---|---|---|---|---|
| Processing rate | `2 FPS` (20 frames in 10 s) | — | — | — | [TT8:roi-settings] |
| Sensitivity — scenes in N seconds | `5` scenes in `10` seconds (5 of the 20 frames) | e.g. `2` scenes in `5` seconds | More scenes / longer window → less sensitive | Fewer scenes / shorter window → more sensitive (faster, more triggers); use `2` / `5` s for very small persons | [TT8:roi-settings] [TT8:summary] |
| `Dedupe Events` | not stated | On · Off | On: the person who triggered the event must leave the ROI and return before a new event is sent | Off: events trigger continuously for as long as that person stays in the ROI | [TT8:roi-settings] |
| `Cooldown Interval` | not stated | seconds (e.g. `5` → an event every 5 s while conditions persist) | Longer gap between event triggers | More frequent events | [TT8:roi-settings] |

## Dashboard, history and search
### Abnormal Dashboard [TT8:abnormal-tab]
- Person Fall events appear on the Abnormal Dashboard: left-hand menu `exclamation-point icon`, or expand the menu and find it by name.
- `Select Camera` dropdown → live view of that camera's Person Fall event results.
- Results populate in real time on the right-hand side of the screen.
- Clicking a frame opens the triggering Person Fall event in greater detail.

### History [TT8:history]
- `History` page = not real time; more control over past data.
- Narrow by abnormal event type and time period (up to `30 days`).
- Results can be exported to an Excel spreadsheet.

## Alerts [TT8:alerts]
`Alert` menu — `bell icon`, or expand the menu and find it by name. Use alerts to see all analytics' event alerts in one dashboard or to send notifications to external devices such as a VMS. Purpose of a Person Fall rule: receive and forward real-time notifications about Person Fall events.
1. `Alert Rule` tab → `Add Alert`.
2. Under `Define Rule` set the alert type, the conditions, and optionally a schedule.
3. `Alert Type` = `Person Fall`; select the associated Person Fall ROIs. Filter cameras by typing the `Camera` or group name.
4. Give the alert a name → `Save`.

## Troubleshooting
| Symptom | Cause | Fix | Src |
|---|---|---|---|
| Falls not detected on small subjects | Person Fall has a larger default minimum pixel size than other analytics because of pose complexity | Target at least `100 × 100` pixels — move/zoom the camera or raise resolution | [TT8:troubleshooting] |
| Poor detection generally | Camera below 2 MP, or imported below 2 MP | At least `2 megapixels (1920×1080)`; confirm the camera supports it **and** is imported into Vaidio at 2 MP minimum | [TT8:troubleshooting] |
| Events missed / stream corruption | Inconsistent network | Provide a consistent network connection so events are detected and triggered as they occur | [TT8:troubleshooting] |
| Stakeholder expects repeated alerts while the person stays down/crouched, but only one arrives | `Dedupe` is on | Turn `Dedupe` off in the camera (ROI) settings | [TT8:troubleshooting] |
| Falls missed on a very small person in the FoV | Default sensitivity `5` scenes / `10` s too strict | Change to `2` scenes in `5` seconds | [TT8:roi-settings] |
| Falls missed — subject partly hidden | Partial occlusion defeats fall detection | Make sure the target is fully visible and not obscured; re-angle the camera | [TT8:considerations] [TT8:summary] |

## Knowledge checks (facts the course tests)
- The Person Fall ROI specifies where Person Fall events will be detected (not to limit FoV, raise resolution or adjust sensitivity). [TT8:roi-setup]
- `Dedupe Events` enabled: the person must leave the ROI before a new event can be triggered — the graded answer. The option "if disabled, multiple events fire while the person remains in the ROI" also matches the lesson text but is not the graded answer; "prevents any events" and "auto-disables after a time" are wrong. [TT8:roi-settings]
- A Person Fall alert rule exists to receive and forward real-time notifications about Person Fall events (not camera settings, sensitivity or BI viewing). [TT8:alerts]
- Minimum pixel size for Person Fall to work effectively: `100 × 100` pixels. [TT8:summary]
- Frames needed to detect an event in a 10-second window at default: `5` (out of the 20 frames seen at 2 FPS). [TT8:summary]
- Minimum recommended camera resolution: `1920×1080p` (2 megapixels). [TT8:summary]
- `Cooldown Interval` of 5 seconds with Dedupe disabled → events trigger every 5 seconds while conditions are met. **Quiz-authoring error:** the quiz markup also flags "Events can only be triggered once every 5 minutes" as correct; this contradicts the lesson text and is almost certainly an authoring error — the lesson-consistent answer is "every 5 seconds". [TT8:summary]
- Common Person Fall troubleshooting recommendation: make sure the target is fully visible and not obscured (not < 2 MP cameras, not "keep Dedupe enabled for all alerts", not limiting the ROI to a small portion). [TT8:summary]

## Lesson index
| # | Lesson (slug) | Min | Video | Topic |
|---|---|---|---|---|
| 1 | introduction | 1 | HubSpot 187330066351 | Trigger postures, healthcare / workplace / public-space use cases |
| 2 | considerations | 1 | HubSpot 187330066345 | Complete, unobstructed view |
| 3 | roi-setup | 1 | HubSpot 187330368165 | `pencil icon` → `AI Engine` → `Person Fall` → `PF` tab, any-shape ROI |
| 4 | roi-settings | 1 | HubSpot 187330066357 | 2 FPS, 5 scenes / 10 s, 2 scenes / 5 s, `Dedupe Events`, `Cooldown Interval` |
| 5 | abnormal-tab | 1 | HubSpot 187333695236 | Abnormal Dashboard, `Select Camera`, real-time results |
| 6 | history | 1 | HubSpot 187330066348 | 30-day search, Excel export |
| 7 | alerts | 1 | HubSpot 187330615061 | `Alert Type` = `Person Fall`, ROIs, `Save` |
| 8 | troubleshooting | 1 | HubSpot 187333580383 | `100 × 100` px, 2 MP, network, Dedupe |
| 9 | summary | 1 | HubSpot 187330066354 | Recap, 5-question check-in |

## Source notes
- Quiz-authoring error (summary check-in): the 5-second cooldown question also marks "once every 5 minutes" as correct; the lesson text supports only "every 5 seconds". [TT8:summary]
- Dedupe check-in ambiguity: two options agree with the lesson text; only "person must leave the ROI before a new event" is graded correct. [TT8:roi-settings]
- Internal inconsistency: the Considerations lesson gives no resolution or pixel-size figures, while Troubleshooting gives `100 × 100` px and 2 MP (`1920×1080`) and the summary quiz tests both. [TT8:considerations] [TT8:troubleshooting] [TT8:summary]
- Defaults not stated: `Dedupe Events`, `Cooldown Interval` (only the `5 seconds` example). The sensitivity field's exact UI label is not given — the lesson describes it as "scenes in N seconds".
- Unlike Crowd Detection (TT5) and Dwell Detection (TT6), this course does not mention a `Refresh` (pause) button on the Abnormal Dashboard, and History filters list only event type and time period (no camera filter). [TT8:abnormal-tab] [TT8:history]
- Course is complete (all 9 lessons captured); videos not transcribed.
