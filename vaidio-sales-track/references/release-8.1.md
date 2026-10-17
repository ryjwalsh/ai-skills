# Vaidio 8.1 release — Vaidio University ST5 "Vaidio 8.1 Release"

> Source: Vaidio University (university.vaidio.ai) course ST5, 9 lessons, captured 2026-10-17. **Video-only course**: every lesson is a HubSpot-hosted screen recording or slide talk with no page text, no captions track and no check-in questions. The narration was not recovered; the content below is reconstructed from sampled video frames (slides and the Vaidio 8.1 UI shown) and is therefore partial. `[frame]` = read off a frame; `[inferred]` = deduced from what the frames show, not stated. UI names reflect the Vaidio 8.1 web UI in the videos — verify against the deployed version. Full source table: ../sources.md.

## At a glance
Vaidio 8.1 (GA September 2024) is presented after a one-slide platform refresher. New or changed in 8.1: a redesigned Camera page where the AI Model, AI Engines and each engine's ROI are configured on one `Edit Camera` page; LPR reports and searches the plate's issuing `State` and `License Plate Type`; a new Alert `Dashboard` with `Unclaimed` / `Claimed` / `Cleared` acknowledgement and a `Map View`; Cross Camera Tracking driven by a `Similarity` score with the person's path drawn on an indoor or GPS map; a new `Container ID` analytic (shipping-container numbers); and the GenAI-enabled Tunable Edge Device (TED), tuned with a natural-language `VLM Prompt`. Closing claim: 8.1 "orchestrates between object-recognition and generative AI" to expand accuracy and use cases, which translates into more end-user customer value. [ST5:introduction] [ST5:81-release-summary]

| Quick fact | Value | Src |
|---|---|---|
| GA | September 2024 (summary slide dated 10/25/24) | [ST5:81-release-summary] |
| Hardware line | `HW: Edge, Appliance, K8S, Cloud or SaaS with NVIDIA GPU` | [ST5:platform-overview] |
| Licensing line | `SW: Vaidio Term License includes Vaidio core software, analytics software, annual maintenance` | [ST5:platform-overview] |
| Camera management | `/camera/cameraManagement`; `Edit Camera` page with `AI Model`, `AI Engines`, `Profile` and per-engine ROI tabs | [ST5:camera-page] |
| LPR | `/licensePlateRecognition/dashboard`; tabs `Dashboard`, `History`, `List`; plate state in the form `US_AZ` | [ST5:lpr] |
| Search | `/videoSearch`; vehicle attributes include `State` and `License Plate Type` | [ST5:lpr] |
| Alert rules | `/alertRule`; tabs `Dashboard`, `History`, `Alert Rule`; rule syntax `Vehicle(License Plate: BAF1768;State=US_AZ)>0` | [ST5:lpr] |
| Alert dashboard | `/alert/alertDashboard`; counters `Unclaimed` (blue) / `Claimed` (red) / `Cleared` (green); `Map View` | [ST5:alert-dashboard] |
| Cross Camera Tracking | `/videoSearch/crossCameraTracking/<sceneId>/<objectId>`; `Similarity` (demo `90`); `Track` button | [ST5:cross-camera-tracking] |
| Container ID | `/containerID/dashboard`; tabs `Dashboard`, `History`, `List`; `Brand` = decoded owner prefix | [ST5:container-id] |
| TED | Web app `Vaidio Edge` at `edgeted.ironyun.com:3093`; `Settings > GenAI` (`/abnormal/genAi`) with `VLM Prompt :`; `Tunable Edge > Dashboard` (`/abnormal/dashboard`) | [ST5:tunable-edge-device] |

## Release agenda  [ST5:introduction]
Slide "Vaidio 8.1 Release Introduction" [frame]:
- Platform Review
- Vaidio 8.1 Release: Camera Page; LPR; Alert Dashboard; Cross Camera Tracking; Container ID; New GenAI-enabled Tunable Edge Device (TED)

## Platform overview  [ST5:platform-overview]
Slide "Platform Overview" — four-stage architecture, left to right [frame]:

| # | Stage (slide label) | Content |
|---|---|---|
| 1 | `CAMERAS AND SENSORS` | IP camera streams and sensors feed in |
| 2 | `VAIDIO VIDEO & AI ANALYTICS` | A bank of Vaidio analytics servers; output is "Alert & Object Metadata" |
| 3 | `VIDEO & ALERT MANAGEMENT` | Recorders / VMS servers receiving alert and object metadata |
| 4 | `OPERATIONS & VMS INTERFACE` | "Video Wall and Management UI" for operators |

- Hardware: `HW: Edge, Appliance, K8S, Cloud or SaaS with NVIDIA GPU` — Vaidio runs on Edge devices, appliances, Kubernetes, cloud or SaaS, on NVIDIA GPU. [frame]
- Software: `SW: Vaidio Term License includes Vaidio core software, analytics software, annual maintenance` — the term licence bundles core + analytics + maintenance. [frame]

## Camera page  [ST5:camera-page]
Screen recording of a Vaidio 8.1 server (demo host 192.168.100.107; browser tabs "Vaidio", "Vaidio", "Vaidio Edge"); path `/camera/cameraManagement`. [frame]

Camera list page (`Camera`) [frame]:
- Filter bar: `AI Engines: All`, `Actions: All`, `Group: All`, `Camera Name` search box, `Search` button.
- Action buttons: `Add Camera`, `Auto Discovery`, `Group`; `Manage Columns` control.
- Columns: `No.`, `Camera Name`, `Resolution`, `Group`, `AI Engines`, `Status`, `Abnormal Check`, `Actions` (enable toggle, edit pencil, "..." menu).
- Demo rows: `DEMO - CCT 1` … `DEMO - CCT 4` (1920x1080, engine CCT, status "Not in use"); `DEMO - LPR` (1280x720, engine LPR, "Not in use").

`Edit Camera` page — the 8.1 redesign demonstrated [frame]:

| Area | Controls |
|---|---|
| Left panel `Camera Configuration` | `* Camera Name` (DEMO - CCT 1); `Description`; `Activated` / `Deactivated` toggle buttons; `Group` (Please select); `Location Type` = `None` / `GPS Map` / `Indoor Map` (+ `Indoor Map` picker button); `Camera Type` (shown as `Video File`, file `68.mp4`); `* Play` (`Once`); `Detail Extraction` (`Standard`); `Preview` button; `Internal Video Recorder` toggle; `VMS/NVR` (Please select); `Channel ID` (Please select) |
| Right pane, top | `AI Model : 1` dropdown; `AI Engines : N` dropdown (count rose from 1 to 2 when an engine was added); `Profile` gear showing `Default` |
| Engine tabs | `General ROI` always present; adding an engine (LPR in the demo) adds an `LPR ×` tab where that engine's ROI polygon is drawn on the frame — tools: draw/cancel, confirm tick, delete; reset. Right side: `Resolution: 1920x1080 pixel`, `Preview`, flip-horizontal / flip-vertical icons |
| Bottom buttons | `Cancel`, `Save` |

Takeaway [inferred]: in 8.1 the per-camera analytics are configured from one `Edit Camera` page — pick the AI Model + AI Engines, then draw each engine's ROI in its own tab — instead of separate per-analytic setup pages.

## LPR  [ST5:lpr]
- `License Plate Recognition` page (`/licensePlateRecognition/dashboard`), tabs `Dashboard`, `History`, `List` [frame]. Dashboard columns: `Detected Image`, `License Plate Image`, `Vehicle Information`, `Time`, `Camera Name / File Name`, row "..." menu. Each row shows plate text with confidence (e.g. `BKN6514 (1.00)`, `DPALUMR (1.00)`, `BFX9180 (0.91)`), vehicle type (`Car`, `Bus`, `Truck`), a colour dot, and `List: Not in list`.
- Detection detail popup `Original Snapshot | Scene ID : 1550154` [frame]: header shows timestamp and camera (`DEMO - LPR`), pager `15 of 100`; toolbar icons tag, zoom, download, snapshot, brightness, map pin; fields `Object Type: Car`, `Color:` (swatches), `Confidence: 0.96`, `LPR List: Not in list`, `Width: 1280`, `Height: 685`, `License Plate: BAE3978`, `State: US_AZ`. New in 8.1: LPR reports the plate's issuing STATE, format `US_AZ`.
- `Search` page (`/videoSearch`) [frame]: date/time range pickers (demo 2024-10-25 00:00 ~ 2024-10-26 00:00), `Search` button, snapshot icon, `Advanced` link, object-type icons (vehicle, person, …). Vehicle filter flyout: object sub-types `More | Vehicle | Bicycle | Bus | Car | Motorcycle | Truck`; attribute panel `Color` with `Include` / `Exclude` toggle and colour swatches, `List` (All), `License Plate` text, `Make` text, `State` (e.g. `US_AZ`), `License Plate Type` (icon selector — the demo shows the disabled/accessible-parking plate symbol), `Speed` (Please Select), `Quantity` (operator `>=` + number), `Cancel` / `Add`. New in 8.1: `State` and `License Plate Type` are searchable LPR attributes.
- Applied filters show as chips: `Vehicle US_AZ ×` → 32 results in 0.2 second; `Vehicle BAF1768,US_AZ ×` → 6 results. The result header also shows `Retention Time: 2024-10-21 10:47:00 ~ 2024-10-25 11:09:53`; thumbnails are timestamped and have map-pin / grid view toggles.
- `Alert` page (`/alertRule`), tabs `Dashboard`, `History`, `Alert Rule`; `Add Alert` button; columns `Alert Name`, `Alert Type`, `Rule`, `Alert Schedule`, `Camera Name`, `Trigger Action`, `Actions` (on/off toggle). Demo rules: `High Alert` — Object Detection — rule `Vehicle(License Plate: BAF1768;State=US_AZ)>0` — schedule `Forever` — camera `DEMO - LPR`; `Vehicle Alert` — Object Detection — rule `Vehicle>0`.
- `Edit Alert` dialog [frame]: name field + `Add Notes`; `Define Rule` (Alert Type `Object Detection`, camera selector, tag field, object-type icons, `AND` / `OR` toggle, `Type` chips e.g. `Vehicle BAF1768,US_AZ ×`, `Schedule` button); `Trigger (Optional)`: `Trigger Action` = `Email Notification`, `Email` ("Please enter emails separated by ;"), `Subject`, body template `Hi, An event was detected on camera {cameraName} at {eventTimeStamp:%MMM dd, yyyy hh:mm:ss a}, Please see the following screenshot. Thank you. {alertImage.jpg}`; `Save`; dialog buttons `Cancel` / `Save`. An alert can therefore key on plate + state.

## Alert Dashboard  [ST5:alert-dashboard]
New 8.1 `Alert` > `Dashboard` (`/alert/alertDashboard`) layout [frame]:
- Three status counters across the top: `Unclaimed` (blue), `Claimed` (red), `Cleared` (green) — demo 306 / 0 / 0 for all alerts; clicking a counter filters the card list to that status.
- Left half: `Map View` (dropdown at top right; world map with +/- zoom, 1000 km / 500 mi scale) plots alerts from cameras that have a GPS location — set through the 8.1 Camera page `Location Type` = `GPS Map` / `Indoor Map` (see Camera page).
- Right half: alert cards in a grid — thumbnail with red pin, badge `OD` (object detection) with magnifier, timestamp (e.g. `2024-10-25 09:58:39`), alert-rule name (`Vehicle Alert`, `High Alert`), camera link (`DEMO - LPR`). A bell/filter icon under the tabs filters by alert rule (demo: 306 unclaimed overall → 10 for `High Alert`).
- Refresh button at top right next to `Map View`. Tabs on the Alert page remain `Dashboard`, `History`, `Alert Rule`.

Alert triage workflow (new in 8.1):
1. Open a card → `Original Snapshot | Scene ID : …` popup (pager `1 of 10`, timestamp, camera, tag/zoom/download/snapshot/map icons).
2. Its status dropdown offers `Unclaim`, `Claim`, `Clear`.
3. Demo: claiming moved the counters to Unclaimed 9 / Claimed 1 / Cleared 0 and tagged the card `Claimed`; clearing it moved the counters to 9 / 0 / 1 and the card turned grey with a `Cleared` tag.

## Cross Camera Tracking  [ST5:cross-camera-tracking]
Workflow demonstrated [frame]:
1. `Search` page: set the date/time window (demo 2024-10-23 11:30 ~ 11:36), pick object `Person` (+ colour chip), `Search` → "88 results in 0.3 second" — thumbnails from the `DEMO - CCT 1…4` cameras (mall / elevator-lobby footage, e.g. "5F-Elevator Right Wing").
2. Open a hit → `Original Snapshot | Scene ID : 1524804` popup (camera `DEMO - CCT 4`, pager `20 of 88`; toolbar tag, zoom, download, snapshot, brightness, map-pin, plus crop thumbnails of each detected person). The new `Track` button at the bottom launches cross-camera tracking on the selected person.
3. `Search > Cross Camera Tracking` page (`/videoSearch/crossCameraTracking/<sceneId>/<objectId>`): inputs are the date/time range (demo 09:35 ~ 13:35), `Similarity` (demo value `90`) and the `Track` button; the seed person appears as a chip with thumbnail (`DEMO - CCT 4 ×`). First run: "66 results in 0.4 second"; at Similarity 90: "14 results in 0.7 second". Header also shows `Retention Time: 2024-10-21 10:47:00 ~ 2024-10-25 11:14:30`.
4. Curate the results: hovering a thumbnail shows `+` (add that appearance as an extra seed) and a trash icon (remove a false match); a trash badge counts removals (4 in the demo); re-running gave "10 results in 0.3 second". Each tile shows its timestamp and, on hover, the camera name (`DEMO - CCT 1`).
5. View toggles (top right): list/grid, map pin, timeline/chart, and export icons. Map mode shows a floor plan — layer picker `Map` / `Mall Map` (the demo uses an indoor mall plan with PENNEYS, MACY'S, SEARS, ICE ARENA, LIBERTY HOUSE); buttons `Map Pin All`, `Info Window`, `Path`. `Path` draws the person's route between camera pins with timestamps (`2024-10-23 10:34:01` → `2024-10-23 11:35:40`). A tile reads "GPS Coordinates is unavailable" when cameras have no GPS location (indoor map used instead). +/- zoom.

Takeaway [inferred]: CCT is re-identification by appearance similarity across cameras, tunable via `Similarity`, refinable by adding/removing matches, and visualised as a path on an indoor or GPS map.

## Container ID  [ST5:container-id]
- New 8.1 analytic `Container ID`: shipping-container number recognition (ISO 6346-style owner code + serial + check digit, e.g. `WHSU60497345G1`, `YMLU87513445G1`, `WHSU66539545G1`). It has its own left-nav icon (container/crane). Demonstrated on a second, cloud-hosted Vaidio server (`search2.ironyun.com/containerID/dashboard`) with camera/file `Demo - ContainerID`. [frame]
- Page tabs: `Dashboard`, `History`, `List` (same pattern as LPR).
- Dashboard columns: `Detected Image` (truck/trailer crop with green box), `Container Number Image` (cropped code), `Container Info` = container number with confidence (e.g. `WHSU60497345G1 (1.00)`, `YMLU87513445G1 (0.97)`, further rows `(0.99)`, `(0.93)`, `(0.98)`), `List: Not in list`, `Brand: WHSU` / `Brand: YMLU` (owner prefix decoded as brand/operator), `Time` (e.g. `2024-10-22 09:41:54`), `Camera Name / File Name`, "..." row menu; sortable column arrows; refresh button; camera/file toggle icons.
- `List` tab: `List:` dropdown + `Container Number` search box + `Search`; table columns `Container Number`, `List`, `Expiration Date`, `Description`, `Created Time` — watch-lists of container numbers with expiry, mirroring LPR lists; dashboard rows then show list membership (`List: Not in list` otherwise).
- Use case [inferred]: logistics / ports / yards — gate automation and container tracking; complements LPR for trucks (container tracking is a listed logistics use case in identifying-opportunities.md).

## Tunable Edge Device (TED)  [ST5:tunable-edge-device]
- TED = Tunable Edge Device, the GenAI-enabled Edge product introduced with 8.1 (component definition: platform-components-and-terminology.md). Demonstrated on a separate web app titled `Vaidio Edge` (browser tab) at `edgeted.ironyun.com:3093`. [frame]
- Top navigation: `Tunable Edge`, `Camera`, `Settings`. `Settings` sub-tabs: `General`, `License`, `Mail`, `Log`, `Storage`, `Users`, `Setting`, `AI Model`, `GenAI`.
- `Settings > GenAI` (`/abnormal/genAi`) — the "tuning" screen: section `Prompt` (with info tooltip); one field `VLM Prompt :` (VLM = vision-language model) containing the demo prompt "Is there people fighting or attacking others?"; a greyed second box with placeholder "Answer Yes or No without explanation" (the answer-format instruction appended to the prompt); `Apply` button. The analytic is defined in natural language: the operator types a question and the VLM answers Yes/No per frame/clip, so the device is "tuned" to a new behaviour without training a model.
- `Tunable Edge > Dashboard` (`/abnormal/dashboard`), tabs `Dashboard`, `History`, `Alert`; filters `Event` (event/alert toggle icons) and `Camera ROI` (person icon); counter `100 Results`; refresh. Result cards: thumbnail with green person box and red border, time (e.g. `23:20:10`), label `People Fighting` (shown twice: event type and prompt result), `NEW` badge on unreviewed events. Demo footage: street/yard fight clips.
- Event popup: title `People Fighting`, timestamp `2024-10-25 23:20:06`, pager `2 of 100`, toolbar (crop, zoom, download, snapshot, person-crop); per-object row `People Fighting` — `Object Type: Person`, `Confidence: 0.92`, `Width: 246`, `Height: 696`.
- Sales positioning [inferred from ST6 and the summary slide]: early-access/experimental, small channel count, offered to partners who want to experiment with GenAI safety use cases (fights, attacks, other behaviours expressible as a prompt).

## 8.1 release summary  [ST5:81-release-summary]
Slide "8.1 SUMMARY" (dated 10/25/24, slide 4) [frame]:
- GA September 2024 (Vaidio 8.1 general availability).
- Alert acknowledgement (the Unclaimed / Claimed / Cleared workflow — Alert Dashboard).
- Cross Camera Tracking improvements.
- Container ID.
- Modularization — not demonstrated in the videos; presumably the per-engine modular configuration seen on the Camera page. [inferred]
- Tunable Edge Device (T.E.D.).
- Closing claim: 8.1 "orchestrates between object-recognition and generative AI" to expand accuracy and use cases, which translates into more end-user customer value.

## Knowledge checks (facts the course tests)
- None — no lesson in this video-only course has a check-in question. [ST5:introduction] [ST5:platform-overview] [ST5:camera-page] [ST5:lpr] [ST5:alert-dashboard] [ST5:cross-camera-tracking] [ST5:container-id] [ST5:tunable-edge-device] [ST5:81-release-summary]

## Lesson index
| # | Lesson (slug) | Min | Video | Topic |
|---|---|---|---|---|
| 1 | introduction | 1 | 184698994699 (0:20, single slide) | Release agenda |
| 2 | platform-overview | 1 | 184699890196 (~0:45, single slide) | Four-stage architecture; HW and SW lines |
| 3 | camera-page | 1 | 183777699951 (0:42, screen recording) | Camera list and redesigned `Edit Camera` page |
| 4 | lpr | 2 | 183779322174 (1:56, screen recording) | LPR dashboard, `State`, search attributes, plate+state alert rule |
| 5 | alert-dashboard | 3 | 183777662803 (2:41, screen recording) | `Unclaimed` / `Claimed` / `Cleared`, `Map View`, triage |
| 6 | cross-camera-tracking | 3 | 183778385003 (2:54, screen recording) | `Track`, `Similarity`, result curation, `Path` on map |
| 7 | container-id | 2 | 183779852909 (1:29, screen recording) | `Container ID` dashboard and lists |
| 8 | tunable-edge-device | 2 | 183779878014 (2:45, screen recording) | `Vaidio Edge` TED app, `VLM Prompt :`, People Fighting events |
| 9 | 81-release-summary | 1 | 183023186434 (single slide) | Summary bullets; GA September 2024 |

## Source notes
- Video-only course: no page text, no captions track, no check-ins. Narration not recovered; facts come from sampled frames (`[frame]`), with gaps implied throughout. Deductions are marked `[inferred]`.
- Slide footer on all slides reads "© 2025 IronYun USA Inc. - Confidential", while the summary slide is dated 10/25/24 and states GA September 2024. [ST5:81-release-summary]
- The "Modularization" summary bullet is not demonstrated in any video; its link to the per-engine Camera page configuration is a deduction. [inferred] [ST5:81-release-summary]
- Three demo environments appear: an on-prem demo server at 192.168.100.107 (Camera, LPR, Alert, CCT), a cloud server `search2.ironyun.com` (Container ID) and the TED app at `edgeted.ironyun.com:3093`. All values shown (plates, container numbers, timestamps) come from demo footage on `DEMO - …` cameras. [ST5:camera-page] [ST5:container-id] [ST5:tunable-edge-device]
- `Retention Time` start is 2024-10-21 10:47:00 on both the LPR search (end 2024-10-25 11:09:53) and the CCT page (end 2024-10-25 11:14:30). [ST5:lpr] [ST5:cross-camera-tracking]
- The platform slide's HW line lists NVIDIA GPU across Edge, Appliance, K8S, Cloud and SaaS; ST6 states Command Center runs no analytics and needs no GPU (platform-components-and-terminology.md). [ST5:platform-overview]
- TED positioning (early-access, small channel count) comes from ST6, not from this course's frames; "VLM = vision-language model" is an expansion of the UI label. [ST5:tunable-edge-device]
- Cross-references: TED component definition in platform-components-and-terminology.md; container tracking as a logistics use case in identifying-opportunities.md.
