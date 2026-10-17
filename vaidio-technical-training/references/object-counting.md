# Object Counting — Vaidio University TT11 "Object Counting"

> Source: Vaidio University (university.vaidio.ai) course TT11, 9 lessons, captured 2026-10-17. Written-lesson content plus check-in questions; embedded videos were not transcribed except where noted. UI names reflect the Vaidio 7.x–9.x web UI shown in the course — verify against the deployed version. Full source table: ../sources.md.

## At a glance
Object Counting is a **statistical** analytic that tracks objects across a line pair and counts crossings in each direction. Use cases: foot traffic, traffic patterns on a road, counting objects processed on a manufacturing line. The course covers setting up counting lines, fine-tuning the line sets, reviewing/exporting counts and processing alerts. Course outcome: get Object Counting running on a camera and apply/adjust it to specific use cases. [TT11:introduction] [TT11:summary]

| Item | Value | Src |
|---|---|---|
| `AI Engine` selection | `Object Counting` | [TT11:line-setup] |
| Engine tab above camera preview | `OC` | [TT11:line-setup] |
| Detection geometry | line set = a pair of lines with four draggable points | [TT11:line-setup] |
| Object types per line | up to 10, each tracked individually; custom-model types allowed | [TT11:line-settings] |
| Direction counting | in/out ("on and off") counts can be enabled or disabled per direction | [TT11:line-settings] |
| Save | `OK` saves the lines to the camera; counting starts when saving finishes | [TT11:line-settings] |
| Results | Object Counting dashboard (icon: teardrop with a line) + `History` (Excel export) | [TT11:dashboard] [TT11:history] |
| Alert | Object Counting alert rule with `Counting Rule` `In` / `Out` | [TT11:alerts] |
| Resolution / pixel-size figures | none given in this course | [TT11:considerations] |

## Camera and scene requirements
[TT11:considerations] [TT11:troubleshooting]
- Cameras must have an adequate view of the subjects to be counted.
- Angle cameras so individuals/objects are not obstructed — occlusion (one object obscuring another) breaks counting.
- A consistent connection to the camera or RTSP stream: dropped frames or downtime cause missed counts.
- No resolution or pixel-size numbers are given (TT9/TT10 specify 2 MP and 30x30 px for their analytics).

## Setup procedure
**Draw the line pair** [TT11:line-setup]
1. Click the `pencil icon` (right side of the screen) on the chosen camera → `Camera Edit` window.
2. `AI Engine` dropdown (top right of the view) → `Object Counting`. A new tab `OC` appears above the camera preview.
3. On `OC`, click the `pencil icon`, then click-and-drag across the preview to draw a basic line.
4. Fine-tune by dragging each of the **four points** (the line set is a pair of lines).
5. The 2D line is applied to 3D space — consider the 3D trajectory of people/objects and adjust accordingly.
6. Press the `green checkmark` above the camera preview to confirm.

Placement rules: draw the pair of counting lines in the **middle of the camera field of view**; keep the gap between the two lines small — too much space can make Vaidio lose track, and a lost object cannot be counted. [TT11:line-setup]

**Line settings** (right side of the screen) [TT11:line-settings]
7. Give every line a **name** (lesson example `Person Counting Line`).
8. `Object Type` box: any object type available on the server, including **custom model** types; up to 10 per line, each tracked individually (lesson example: Person).
9. Enable or disable the **on and off counts** (in/out counting) per use case — e.g. objects on a conveyor belt only travel "in", so disable the other direction.
10. Line changes apply automatically; click `OK` to save the lines to the camera. Counts start once saving finishes.

## Parameters
| Parameter | Default | Range / options | Effect of raising | Effect of lowering | Src |
|---|---|---|---|---|---|
| Line name | — | required per line (e.g. `Person Counting Line`) | — | — | [TT11:line-settings] |
| `Object Type` | — | up to 10 per line; any server object type incl. custom model types | — | — | [TT11:line-settings] |
| In / out counts ("on and off counts") | — | enable or disable each direction | — | Disabling a direction removes counts that never occur (conveyor example) | [TT11:line-settings] |
| Gap between the two lines | — | keep minimal | Larger gap: Vaidio may lose track → object not counted | Smaller gap: tracking retained | [TT11:line-setup] [TT11:troubleshooting] |
| Line position / edges | — | middle of the FoV; edges pulled out to catch more of the 3D space | — | — | [TT11:line-setup] [TT11:troubleshooting] |

## Dashboard, history and search
**Dashboard** [TT11:dashboard]
- Icon: a **teardrop with a line**; or expand the nav tab and find it by name.
- Shows the live count from all cameras, broken down by **object type**, with **in count**, **out count** and **total occupancy** across all objects.
- Narrow the real-time counts by selecting/deselecting specific **lines** and specific **objects**.

**History** [TT11:history]
- `History` page is not real time; more control over past data.
- Filters: **line**, **object type**, **time grain**, **time period**.
- Results export to an **Excel spreadsheet**.

## Alerts
[TT11:alerts]
- Alert Rules turn counts into actionable intelligence: e.g. email on building overcrowding, send data to a third-party VMS, or export data to a third-party dashboard.
- A new Object Counting alert rule selects the **cameras** and **lines** it applies to and the conditions needed.
- `Counting Rule` option: setting it to `In` or `Out` exposes an extra option to **repeat by object count instead of by minutes** — for time-between-events use cases (e.g. every N manufacturing parts produced, or gauging street traffic at a busy time of day).
- To be alerted when the count of objects going out exceeds a limit, select `Counting Rule: Out` (not `Counting Rule: In`, `Alert Frequency: Daily`, or `Alert Type: Email`).

## Troubleshooting
| Symptom | Cause | Fix | Src |
|---|---|---|---|
| Missed counts (network speed) | Dropped frames or camera/RTSP downtime | Object Counting needs a consistent connection to the camera or RTSP stream; eliminate dropped frames and downtime | [TT11:troubleshooting] |
| Inaccurate counts (object visibility) | One object obscures another | Minimize object overlap via camera positioning | [TT11:troubleshooting] |
| False or missed counts (object motion) | Objects stop or fully turn around while inside the line pair | Place lines where traffic flows smoothly | [TT11:troubleshooting] |
| Other missed/inaccurate counts | Line geometry does not match the 3D path | Adjust the line edges: pull them out further to catch more of the 3D space, or move the lines closer together within the pair | [TT11:troubleshooting] |

## Knowledge checks (facts the course tests)
- Counting lines are placed in the middle of the camera field of view with minimal space between the lines (not at the edges, the top, or anywhere). [TT11:line-setup]
- "Leave a large gap between lines for accurate tracking" is False: too much space may cause Vaidio to lose track of the object. [TT11:line-setup]
- To be alerted when the out-count exceeds a limit, select `Counting Rule: Out`. [TT11:alerts]
- Maximum object types per counting line is 10 (options: 5 / 7 / 10 / 12). [TT11:summary]
- Camera angle, object visibility and network connection are considerations for effective Object Counting setup; "what analytics to pair it with" is not. [TT11:summary]
- The Object Counting Dashboard gives real-time counts by object type and occupancy (True). [TT11:summary]
- The 3D trajectory is considered when adjusting counting lines to accurately track objects as they move through a 3D space. [TT11:summary]
- The Object Counting History page exports to an Excel Spreadsheet (not PDF, Word, or CSV). [TT11:summary]

## Lesson index
| # | Lesson (slug) | Min | Video | Topic |
|---|---|---|---|---|
| 1 | introduction | 1 | HubSpot 187397703272 | Statistical line-pair counting, use cases |
| 2 | considerations | 1 | HubSpot 187396007092 | View and angle; no numbers |
| 3 | line-setup | 1 | HubSpot 187397703269 | `OC` tab, four points, placement; 2 check-ins |
| 4 | line-settings | 1 | HubSpot 187395990839 | Name, `Object Type` (10), in/out enable, `OK` |
| 5 | dashboard | 1 | HubSpot 187396007095 | In/out/occupancy by object type |
| 6 | history | 1 | HubSpot 187396007089 | Line/object/time-grain/period filters, Excel |
| 7 | alerts | 1 | HubSpot 187397703263 | `Counting Rule` In/Out, repeat by count; 1 check-in |
| 8 | troubleshooting | 1 | HubSpot 187397703266 | Network, occlusion, motion, geometry |
| 9 | summary | 1 | HubSpot 187395990836 | Recap; 5 check-ins |

## Source notes
- The considerations lesson gives no resolution or minimum pixel-size figure, unlike TT9/TT10 (2 MP, 30x30 px); TT14 [TT14:camera-resolution] gives the platform-wide 1920x1080p / 2 MP recommendation.
- The summary quiz counts "network connection" among the setup considerations, but the considerations lesson itself lists only camera view and angle; the network requirement appears in the troubleshooting lesson.
- Lines are saved with `OK` here, whereas TT9, TT10 and TT12 save the analytic with `Save` on the Edit Camera popup.
- The `AI Engine` dropdown is placed "top right of the view" here and in TT12; TT9/TT10 say "top of the view".
- Defaults for the in/out toggles and for alert `Counting Rule` options are not stated; no vendor names are given for the VMS or third-party dashboard targets.
