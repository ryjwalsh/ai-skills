# Object Left Behind — Vaidio University TT12 "Object Left Behind"

> Source: Vaidio University (university.vaidio.ai) course TT12, 9 lessons, captured 2026-10-17. Written-lesson content plus check-in questions; embedded videos were not transcribed except where noted. UI names reflect the Vaidio 7.x–9.x web UI shown in the course — verify against the deployed version. Full source table: ../sources.md.

## At a glance
Object Left Behind (OLB) detects and alerts when an object has been left by itself for an extended period — for environments where a lost or out-of-place object is a safety, security or operational hazard. An OLB event fires when a selected object type is detected in an ROI **and no person appears in that ROI within the trigger time**; the countdown restarts whenever a person is detected. The course covers ROI setup, tuning (trigger time, dedupe, cooldown), reviewing events and alerts. Course outcome: get OLB running on a camera and apply/adjust it to specific use cases. [TT12:introduction] [TT12:analytic-setup] [TT12:summary]

| Item | Value | Src |
|---|---|---|
| `AI Engine` selection | `Object Left Behind` | [TT12:analytic-setup] |
| Engine tab above camera preview | `OLB` | [TT12:analytic-setup] |
| ROI shape | any polygon, drawn by dropping anchor points; several small ROIs recommended | [TT12:analytic-setup] |
| Object types per ROI | max 10, combined with `OR` logic | [TT12:roi-settings] |
| `Object Left Behind trigger time` | example 10 seconds; default not stated | [TT12:roi-settings] |
| `Dedupe Events` | recommended ON for OLB | [TT12:roi-settings] |
| Recommended minimum target size | 30x30 pixels | [TT12:troubleshooting] |
| Results | `Abnormal Dashboard` (exclamation point icon) + `History` (30 days, Excel export) | [TT12:dashboard] [TT12:history] |
| `Alert Type` | `Object Left Behind` | [TT12:alerts] |

## Camera and scene requirements
[TT12:considerations] [TT12:troubleshooting]
- Cameras must have an adequate view of the objects being looked for.
- Angle cameras so detections are not obstructed; one object obscuring another causes inaccurate tracking.
- Keep targets at or above the recommended minimum `30x30 pixels` — far-off objects and wide angles of view fall below it quickly (camera placement/zoom).
- Stable network connection: dropped frames/packets distort or lose objects in the frame.
- The considerations lesson itself gives no resolution or pixel figure; the 30x30 px figure comes from the troubleshooting lesson.

## Setup procedure
**Add the engine and draw ROIs** [TT12:analytic-setup]
1. Click the `pencil icon` (right side of the screen) on the chosen camera → `Camera Edit` window.
2. `AI Engine` dropdown (top right) → `Object Left Behind`. A new tab `OLB` appears above the camera preview.
3. On `OLB`, click the `Pencil icon`, then click in the preview to drop **anchor points** that define the ROI shape — any shape (polygon, not just a rectangle).
4. Click the `checkmark` when done drawing the ROI(s).

ROI strategy: use **multiple small ROIs** across the view instead of one large ROI, especially where foot traffic is heavy. OLB fires only when the specified object is detected **and no people appear in the ROI within the set time**; the countdown **restarts as soon as a person is detected in the ROI**, so a big ROI in a busy area rarely times out. [TT12:analytic-setup]

**ROI settings** (right side of the screen) [TT12:roi-settings]
5. Name each ROI (lesson example `OLB detected`).
6. Select object types: any type in the AI Model, max 10 per ROI; the rule is an `OR` statement — the event fires if **any** selected type is in the ROI (lesson example: `Bag` and `Backpack`).
7. Set `Object Left Behind trigger time`, `Dedupe Events` and `Cooldown Interval` (table below).
8. Analytic changes save automatically; click `Save` on the Edit Camera popup to save all settings.

## Parameters
| Parameter | Default | Range / options | Effect of raising (longer / ON) | Effect of lowering (shorter / OFF) | Src |
|---|---|---|---|---|---|
| `Object Left Behind trigger time` | not stated (example 10 seconds) | seconds | Object must stay in the ROI without a person for longer before an event fires (10 s → a bag that enters and stays 10 s or longer triggers) | Fires after a shorter unattended period | [TT12:roi-settings] |
| `Dedupe Events` | not stated; **recommended ON** for OLB to avoid being bombarded with events | ON / OFF | ON: no re-trigger while the conditions continue to be met — one event per episode; a new event needs the bag to leave and re-enter the ROI under the same conditions | OFF: events keep triggering as long as the bag stays in the OLB ROI | [TT12:roi-settings] |
| `Cooldown Interval` | not stated (example 5 seconds) | seconds | Dedupe OFF: time between event triggers while conditions persist (5 s → an event every 5 s). Dedupe ON: how long the object must be **out of the ROI** after the initial event before tracking restarts | — | [TT12:roi-settings] |
| Object types | — | max 10 per ROI, `OR` logic | — | — | [TT12:roi-settings] |
| ROI count and size | — | several small ROIs rather than one large one | Larger ROI in a busy area: countdown keeps restarting on people, rarely times out | Smaller ROIs: more likely to see the object without a person | [TT12:analytic-setup] |

## Dashboard, history and search
**Abnormal Dashboard** [TT12:dashboard]
- OLB results live in the `Abnormal Dashboard`: `exclamation point icon` on the left-hand menu, or expand the tab and find it by name.
- `Select Camera` dropdown → live view with OLB event results; results also populate in real time on the right-hand side.
- Click an image → shows the OLB ROI plus the **highlighted bounding box** of the object that triggered the event.

**History** [TT12:history]
- `History` page is not real time; more control over past data.
- Search by **date and time up to 30 days back**, specific **cameras**, and **types of abnormal events**.
- Export to an **Excel spreadsheet**.

## Alerts
[TT12:alerts]
- Reasons for an alert: see all analytics in one dashboard, or push notifications to external devices such as a VMS.
- Path: `Alert` menu (`bell icon`, or expand the tab by name) → `Alert Rule` tab → `Add Alert` → `Define Rule`: alert type, conditions, optional schedule.
- `Alert Type` = `Object Left Behind` → select the associated OLB ROIs. Filter cameras by typing `Camera` or `Camera Group`. Name the alert → `Save`.
- With `Dedupe Events` enabled, duplicate alerts are suppressed for as long as the conditions are still met.

## Troubleshooting
| Symptom | Cause | Fix | Src |
|---|---|---|---|
| False negatives (network connection) | Dropped frames/packets distort or lose objects in the frame | Provide a stable network connection | [TT12:troubleshooting] |
| Objects not watched (object size) | Objects fall below the recommended minimum `30x30 pixels` — happens quickly for far-off objects or wide angles of view | Keep targets at or above 30x30 px (camera placement/zoom) | [TT12:troubleshooting] |
| Inaccurate tracking (object visibility) | One object obscures another | Minimize object overlap via camera positioning | [TT12:troubleshooting] |
| Events rarely fire in a busy area | One large ROI — people keep restarting the countdown | Use multiple small ROIs across the view | [TT12:analytic-setup] |
| Bombarded with repeat events | `Dedupe Events` OFF | Turn `Dedupe Events` ON (recommended for OLB) | [TT12:roi-settings] |

## Knowledge checks (facts the course tests)
- Multiple smaller ROIs are used instead of one large one to cover an area more effectively to see the object without a person (not for simpler setup or lower processing load). The question lists "To reduce the processing load on the camera" twice among its distractors — a quiz-authoring error. [TT12:analytic-setup]
- `OR` logic for the selected object types means the event is triggered if any one of the selected object types is detected (not all required, no person needed, not an event-count limit). [TT12:roi-settings]
- `Dedupe Events` enabled in OLB prevents duplicate alerts as long as the conditions are still met (not multiple events per trigger, not an event-type change, not higher sensitivity). [TT12:alerts]
- Maximum object types per OLB ROI is 10 (options: 10 / 5 / 15 / 20). [TT12:summary]
- With the trigger time set to 10 seconds, an object must remain in the ROI without a person for 10 seconds. [TT12:summary]
- With Dedupe disabled, the Cooldown Interval sets the time between event triggers (not ROI dwell length, resolution, or sensitivity). [TT12:summary]
- A common OLB troubleshooting tip is to ensure objects are at least 30x30 pixels in size (wrong options: low-res cameras, more distance between ROIs, fewer ROIs). [TT12:summary]
- Turning `Dedupe Events` OFF makes events continue to trigger as long as the object remains in the ROI. [TT12:summary]

## Lesson index
| # | Lesson (slug) | Min | Video | Topic |
|---|---|---|---|---|
| 1 | introduction | 1 | HubSpot 187399373115 | Unattended-object detection, scope |
| 2 | considerations | 1 | HubSpot 187401624396 | View and angle; no numbers |
| 3 | analytic-setup | 1 | HubSpot 187399373112 | `OLB` tab, polygon ROIs, multiple small ROIs; 1 check-in |
| 4 | roi-settings | 2 | HubSpot 187399373121 | Name, object types (10, OR), trigger time, dedupe, cooldown; 1 check-in |
| 5 | dashboard | 1 | HubSpot 187401624399 | `Abnormal Dashboard`, bounding box |
| 6 | history | 1 | HubSpot 187399373106 | 30 days, Excel export |
| 7 | alerts | 1 | HubSpot 187399373109 | `Alert Type` `Object Left Behind`; 1 check-in |
| 8 | troubleshooting | 1 | HubSpot 187399478826 | Network, 30x30 px, occlusion |
| 9 | summary | 1 | HubSpot 187399472436 | Recap; 5 check-ins |

## Source notes
- Quiz-authoring error: the analytic-setup check-in lists the distractor "To reduce the processing load on the camera" twice.
- Defaults for `Object Left Behind trigger time`, `Dedupe Events` and `Cooldown Interval` are not stated; the lesson gives 10 s and 5 s examples and recommends Dedupe ON.
- The cooldown's meaning changes with Dedupe ON (time the object must be out of the ROI before tracking restarts); TT14 [TT14:dedupe] describes the same rule, while TT9 [TT9:analytics-setup] describes Dedupe ON only as "leave and re-enter".
- The considerations lesson gives no resolution/pixel figure; the 30x30 px minimum appears only in troubleshooting and the quiz. No 2 MP figure is given in this course (TT9/TT10/TT13/TT14 give one).
- Alert camera filter offers `Camera` or `Camera Group` only (TT9 adds `ROI`, TT10 adds `Line`); the rule is finished with `Save` (TT9 `OK`, TT10 `save`).
- The last two troubleshooting rows are derived from the setup lessons' own guidance rather than the troubleshooting lesson, as cited.
