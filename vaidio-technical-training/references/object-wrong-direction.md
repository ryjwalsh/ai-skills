# Object Wrong Direction — Vaidio University TT10 "Object Wrong Direction"

> Source: Vaidio University (university.vaidio.ai) course TT10, 9 lessons, captured 2026-10-17. Written-lesson content plus check-in questions; embedded videos were not transcribed except where noted. UI names reflect the Vaidio 7.x–9.x web UI shown in the course — verify against the deployed version. Full source table: ../sources.md.

## At a glance
Object Wrong Direction (OWD) tracks objects across a **pair of lines**; crossing them in the wrong direction generates an event and, optionally, an alert. Example applications: vehicles traveling the wrong way down one-way streets; shoplifting (people taking carts of goods out through the entrance). The course covers setup from camera to alerts, viewing events, considerations, testing and troubleshooting. Course outcome: get OWD running on a camera and apply/adjust it to specific use cases. [TT10:introduction] [TT10:summary]

| Item | Value | Src |
|---|---|---|
| `AI Engine` selection | `Object Wrong Direction` | [TT10:line-setup] |
| Engine tab above camera preview | `OWD` | [TT10:line-setup] |
| Detection geometry | one drawn "line" = a pair of lines with four draggable endpoints; objects crossing in the direction of the **red arrow** trigger | [TT10:line-setup] |
| Object types per line | up to 10, each tracked individually; custom-model types allowed | [TT10:line-settings] |
| Minimum camera resolution | 2 megapixels (1920x1080), imported into Vaidio at 2MP minimum | [TT10:considerations] [TT10:troubleshooting] |
| Minimum target size | 30x30 pixels | [TT10:considerations] |
| Network | strong and stable connection to the camera | [TT10:considerations] |
| Results | `Abnormal Dashboard` (exclamation point icon) + `History` (30 days, Excel export) | [TT10:dashboard] [TT10:history] |
| `Alert Type` | `OWD` | [TT10:alerts] |
| Sensitivity / dedupe / cooldown | not listed for this analytic | — |

## Camera and scene requirements
[TT10:considerations] [TT10:troubleshooting]
- Minimum resolution `2 megapixels`; targets captured at `30x30 pixels` or larger.
- A strong and stable network connection to the camera — added for this analytic because tracking across lines depends on continuous frames [inferred]. Dropped frames from an inconsistent connection make the server lose tracking.
- The camera must be capable of, and imported into Vaidio at, 2MP (1920x1080) minimum — a lower import resolution gives poor results.

## Setup procedure
**Draw the line pair** [TT10:line-setup]
1. Click the `pencil icon` (right side of the screen) on the chosen camera → `Camera Edit` window.
2. `AI Engine` dropdown (top of the view) → `Object Wrong Direction`. A new tab `OWD` appears above the camera preview.
3. On `OWD`, click the `pencil icon`, then click-and-drag across the preview to draw a basic line.
4. Drag each of the **four points** individually to fine-tune (the "line" is a pair of lines with four endpoints).
5. The line is 2D but applied to 3D space: think about the 3D trajectory people/objects travel and adjust the line to match.
6. Objects passing through the lines in the **same direction as the red arrow** trigger an Object Wrong Direction alert.
7. Press the `green checkmark` above the camera preview to confirm the line.

Placement rules: draw the pair of lines in the **middle of the camera field of view**; do not leave too much space between the two lines — too much gap can make Vaidio lose track of the object, and an object with lost tracking cannot be counted. [TT10:line-setup]

**Line settings** (right side of the screen) [TT10:line-settings]
8. Give every line a **name** (lesson example `OWD Car`).
9. `Object Type` box: any object type available on the AI models, including **custom model** types if present on the server; up to 10 per line, each tracked individually (lesson example: `car`).
10. Line changes save automatically; press `Save` to finalize the camera changes. OWD events then start appearing.

## Parameters
| Parameter | Default | Range / options | Effect of raising | Effect of lowering | Src |
|---|---|---|---|---|---|
| Line name | — | required per line (e.g. `OWD Car`) | — | — | [TT10:line-settings] |
| `Object Type` | — | up to 10 per line; any AI-model type incl. custom model types | — | — | [TT10:line-settings] |
| Direction | — | red arrow = the wrong direction; crossings in that direction trigger | — | — | [TT10:line-setup] |
| Gap between the two lines | — | keep small | Larger gap: tracking may be lost → object not counted | Smaller gap: can increase true positive detections | [TT10:line-setup] [TT10:troubleshooting] |
| Line position | — | middle of the camera field of view; four points adjusted to the 3D trajectory | — | — | [TT10:line-setup] |

## Dashboard, history and search
**Abnormal Dashboard** [TT10:dashboard]
- OWD results live in the `Abnormal Dashboard`: `exclamation point icon` on the left-hand menu, or expand the tab and find it by name.
- Click a frame → shows the Object Wrong Direction line with the object that triggered it.
- Filters: **camera name** and **abnormal type** — needed because the Abnormal Detection dashboard aggregates many analytics (the quiz calls this the "analytic type filter").

**History** [TT10:history]
- `History` page is not real time; more control for viewing past data.
- Narrow by **abnormal event** and **time period**, up to 30 days.
- Results export to an **Excel spreadsheet**.

## Alerts
[TT10:alerts]
- Reasons to create an alert: view all analytics in one dashboard, or send notifications to external devices such as a VMS.
- Path: `Alert` menu (`bell icon`, or expand the tab by name) → `Alert Rule` tab → `Add Alert` → `Define Rule`: alert type, alert conditions, optional schedule.
- `Alert Type` = `OWD` → select the associated Object Wrong Direction lines. Filter cameras by typing `Camera`, `Camera Group` or `Line` names. Name the alert → click `save`.

## Troubleshooting
| Symptom | Cause | Fix | Src |
|---|---|---|---|
| Objects not tracked (object size) | Objects smaller than `30x30 pixels` | Ensure objects are at least 30x30 pixels | [TT10:troubleshooting] |
| Poor results (camera resolution) | Camera below 2 megapixels (1920x1080), or imported into Vaidio at a lower resolution | Camera must be capable of, and imported into Vaidio at, 2MP minimum | [TT10:troubleshooting] |
| Missed detections (line distance) | Lines too far apart | Small line changes, e.g. bringing the lines closer together, can increase true positive detections | [TT10:troubleshooting] |
| Lost tracking (network) | Dropped frames from an inconsistent network connection | Provide a consistent network connection; dropped frames cause the server to lose tracking | [TT10:troubleshooting] |

## Knowledge checks (facts the course tests)
- Minimum recommended camera resolution for Object Wrong Direction is 2 megapixels. [TT10:line-setup]
- The lines are drawn close together to minimize the chance of losing track of an object (not for resolution, visibility from a distance, or processing load). [TT10:line-setup]
- One purpose of an OWD alert is to receive external notifications for events occurring in the wrong direction. [TT10:alerts]
- The red arrow shown when drawing OWD lines indicates the wrong direction of travel; objects crossing in that direction trigger the event. [TT10:summary]
- 10 object types can be tracked per line (options: 10 / 5 / 15 / 20). [TT10:summary]
- Minimum object size for effective OWD tracking is 30x30 pixels (options: 20x20 / 50x50 / 40x40 / 30x30). [TT10:summary]
- To filter alerts by analytic type in the Abnormal Dashboard, use the analytic type filter (not the camera name, time period, or object type filter). [TT10:summary]
- A common OWD troubleshooting recommendation is to reduce the distance between the lines (wrong options: cameras under 2MP, objects at least 10x10 pixels, disabling network connections). [TT10:summary]

## Lesson index
| # | Lesson (slug) | Min | Video | Topic |
|---|---|---|---|---|
| 1 | introduction | 1 | HubSpot 187396870750 | Line-pair direction detection, use cases |
| 2 | considerations | 1 | HubSpot 187397069887 | 2 MP, 30x30 px, stable network |
| 3 | line-setup | 1 | HubSpot 187395719494 | `OWD` tab, four points, red arrow, placement; 2 check-ins |
| 4 | line-settings | 1 | HubSpot 187397069890 | Name, `Object Type` (10), `Save` |
| 5 | dashboard | 1 | HubSpot 187396870744 | `Abnormal Dashboard` filters |
| 6 | history | 1 | HubSpot 187397069881 | 30 days, Excel export |
| 7 | alerts | 1 | HubSpot 187397069884 | `Alert Type` `OWD`; 1 check-in |
| 8 | troubleshooting | 1 | HubSpot 187396870753 | Size, resolution, line distance, network |
| 9 | summary | 1 | HubSpot 187396870747 | Recap; 5 check-ins |

## Source notes
- The dashboard lesson names the filter "abnormal type"; the summary quiz calls it the "analytic type filter".
- The placement-rule text calls the OWD line pair "counting lines" (same wording as TT11 Object Counting and TT14 [TT14:line-crossings]).
- No sensitivity, dedupe, cooldown or confidence setting is described for OWD; no defaults beyond the 10-object-type cap are stated.
- The alert rule is finished with `save` here; TT9 uses `OK`, TT12 uses `Save`.
- The `[inferred]` marker on the network-connection rationale comes from the notes; the lesson lists the requirement without explaining it.
