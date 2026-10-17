# POC and demo playbook — Vaidio University TT14 "Vaidio Proof of Concept & Customer Specific Demos"

> Source: Vaidio University (university.vaidio.ai) course TT14, 26 lessons, captured 2026-10-17. Written-lesson content plus check-in questions; embedded videos were not transcribed except where noted (the `verifying-pixel-size` lesson's 0:53 video was). UI names reflect the Vaidio 7.x–9.x web UI shown in the course — verify against the deployed version. Full source table: ../sources.md.

## At a glance
Vision AI clients usually need to see how the technology works for them, so a proof of concept (POC) or demonstration has to be prepared and executed. Two starting situations: a customer wants to test specific Vaidio analytics, or a demo is being built to show multiple prospects. The course is a field playbook: scope the solution → prepare hardware → connect cameras (ONVIF/RTSP) → set the common parameters → integrate NVR/VMS/SMTP → test → troubleshoot. Expected outcome: plan and deploy a successful POC; the Vaidio team is available to help. [TT14:introduction] [TT14:scope] [TT14:summary]

| Item | Value | Src |
|---|---|---|
| Analytics to showcase | 3–4 meaningful analytics, not the whole platform | [TT14:choosing-the-right-analytics] |
| Accuracy expectation | many use cases reach 99% with fine tuning; all AI is imperfect | [TT14:choosing-the-right-analytics] |
| Trial length | 30-day or 60-day; POCs usually run longer than planned | [TT14:choosing-the-right-analytics] |
| Platform | containerized, primarily Ubuntu, requires Nvidia GPUs; runs on VMs | [TT14:high-level-considerations] |
| Sizing tool | Appliance Calculator (Partner Portal) | [TT14:high-level-considerations] |
| Add camera via ONVIF | IP address, HTTP port (usually 80), username/password; ports 80 and 554 reachable | [TT14:onvif-vs-rtsp] |
| Add camera via RTSP | stream URL + RTSP port reachable from the Vaidio server | [TT14:onvif-vs-rtsp] |
| RTSP test | VLC `Media` → `Open Network Stream` | [TT14:testing-rtsp-streams] |
| NVR clips | 30-second clip around an event; import up to 1 hour; 5-minute cooldown before retrieval | [TT14:nvr-connectivity] |
| SMTP | `System -> Mail`: `IP`, `port`, `username`, `password`, `protocol`; no default port given | [TT14:smtp-connectivity] |
| Minimum resolution | 1920x1080p / 2 megapixels for most use cases | [TT14:camera-resolution] |
| Minimum pixel size | 30 px; lowerable to 10 by 10 in `Profile` with caution | [TT14:verifying-pixel-size] |

## Scoping
[TT14:scope] [TT14:choosing-the-right-analytics]
- Demoing a large number of analytics at once overwhelms; showcase **3–4 meaningful analytics** that resonate with the end user. Vertical-application resources are on the **Partner Portal**.
- Set the right expectations: Vision AI is not miraculous — many use cases reach **99% accuracy with fine tuning**, but all AI is imperfect. Customers can expect safety/security gains and BI ROI, but it takes work; promising perfection produces disappointed customers.
- Set success criteria: time frame (e.g. **30-day** or **60-day** trial), the criteria for success, and the point at which the customer moves to production. POCs usually run longer than planned — set and reinforce expectations early and often.
- Crucial factors for success criteria: number of analytics demonstrated, duration of the trial period, realistic expectations on analytic performance. The types of camera used are not one of them.

## Hardware
[TT14:hardware-considerations] [TT14:high-level-considerations]
- Vaidio is a **containerized** solution running primarily on **Ubuntu**; it **requires Nvidia GPUs**; otherwise it tolerates many hardware configurations.
- First step: determine the **number of analytics** that will run in the POC.
- **Appliance Calculator** (Vaidio **Partner Portal**): specs how many servers are needed and the compute each requires. Good for planning a long-term (especially paid) POC; if hardware is not available internally it may require a purchase.
- **Virtual machine**: because Vaidio is containerized it deploys easily on a VM. The VM has the same compute requirements, including the Nvidia GPUs; VMs make spinning up a new Vaidio instance easy.

## Camera connectivity
Adding cameras is the first server-setup step after the POC is confirmed and the most common POC question. [TT14:camera-connectivity]

| Method | Needs | Caveats | Src |
|---|---|---|---|
| **ONVIF** (Open Network Video Interface Forum) | camera **IP address**, **HTTP port** (usually **80**), **username and password** | camera must support ONVIF; ports **80 and 554** must be reachable on the camera from the network. An RTSP stream URL is not required | [TT14:onvif-vs-rtsp] |
| **RTSP** (Real Time Streaming Protocol) direct | the **stream URL**, and the **RTSP port** reachable from the Vaidio server | HTTP port not needed | [TT14:onvif-vs-rtsp] |

- **Port 554** is where the RTSP stream is pulled from — it must be accessible regardless of the method chosen. [TT14:onvif-vs-rtsp]
- **Finding the RTSP URL**: syntax depends on the camera **make**, and sometimes make **and model**. Sources: the camera's documentation and online references (typically well documented). Vaidio's own approach is the same — research and verify the syntax for the customer/environment. No tool or URL pattern is named. [TT14:finding-rtsp-streams]
- **Testing the stream**: **VLC media player** → menu `Media` → `Open Network Stream` → paste the RTSP URL. Rule of thumb: if VLC can pull the stream, Vaidio can pull it with the **same URL**. [TT14:testing-rtsp-streams]

## Common configuration
The most common analytic-setup considerations once cameras are tested and added. [TT14:common-set-up-considerations]

| Setting | Where | Rule / numbers | Src |
|---|---|---|---|
| **Dedupe** | many ROI-based analytics (e.g. **Intrusion Detection**, **Person Fall**); the cooldown setting sits **below Dedupe** in the UI | Governs repeated event triggers while an incident continues. **ON** → one event trigger; for another, the object must **leave the ROI for the duration of the cooldown timer**, come back and repeat the event conditions. **OFF** → triggers for as long as the object stays in the ROI and the event continues. Choose per end-user expectation: one trigger per incident → leave ON; multiple events more impactful for a demonstration → turn OFF | [TT14:dedupe] |
| **Sensitivity** | many ROI-based analytics (Intrusion Detection, Person Fall) | How fast an event triggers. Faster = fewer frames evaluated = object need not remain in the ROI long; quicker but possibly less accurate (more false positives). These analytics process **2 frames per second**; default requires detection in **5 of every 20 processed frames** (= every **10 seconds** of video) → **2.5 seconds minimum** to trigger. Faster setting **2 frames in 5 seconds** → triggers in **1 second** | [TT14:sensitivity] |
| **Confidence** | `Profile` button (`Gear icon`) at the top right of the camera edit window | Scale of roughly **0 to 1**; how sure the AI must be before recording a found object. Lower → may find more objects but more false positives. Higher → AI must be more certain; too high ignores true detections. Default is typically fine | [TT14:confidence] |
| **Line crossings** | line analytics: **Object Counting**, **Object Wrong Direction** | Missing or over-counting is often fixed with small line adjustments. The line is 2D applied to 3D space — model the 3D trajectory people/objects follow. Draw the pair of counting lines in the **middle of the camera field of view** with little space between them; too much space → tracking lost → object cannot be counted | [TT14:line-crossings] |

## Integrations
Vaidio integrates with external services both to pull information in and to send it out; a POC should demonstrate at least one integration's value. [TT14:integrations]

| Integration | Setup | Behavior and caveats | Src |
|---|---|---|---|
| **NVR** (Network Video Recorder) | `NVR` tab on the left side of the page. External NVR needs the NVR server's **brand**, **IP**, **port** and **admin credentials** | Vaidio pulls a short (**30 second**) clip around an event and can import **up to an hour-long clip** from the NVR for AI Vision processing. **Internal NVR** exists but is **licensed separately**, not available by default, and needs more storage (video is not normally stored on the server). All NVRs have a **5 minute cooldown** before video can be retrieved → event clips cannot be demoed the moment they happen. Hidden network considerations are common: configure and test **ahead of the demo**; decide whether NVR integration makes sense for the POC and allow adequate time | [TT14:nvr-connectivity] |
| **VMS** (Video Management System) | Vaidio forwards alerts/information to many VMS platforms; each integration differs — some need a **middleware bridge**, others **specific licenses from the VMS vendor** | Not plug-and-play; budget adequate time for configuration and testing before the demo. No vendors or ports are named | [TT14:vms-connectivity] |
| **SMTP** (email alerts) | `System -> Mail`: `IP`, `port`, `username` (the address alerts are sent from), `password`, `protocol` | Typically the easiest integration to set up and test. The SMTP server must be reachable from the Vaidio appliance — an isolated no-internet environment cannot reach Google's mail server. No default port given | [TT14:smtp-connectivity] |

## Testing and verification
[TT14:testing-the-solution] [TT14:verifying-analytic-performance]
- After setup and integrations, test and verify before presenting to the end user/stakeholders; make sure it meets your expectations and theirs.
- Best resource: Vaidio's **analytic guides** on the **Partner Portal** (in-depth per-analytic optimization).
- Where results appear: the `Search` tab (top left) or each analytic's own tab along the left-hand side.
- Confirm the analytic matches the use case — e.g. a **Face Recognition** POC that needs a **blacklist and a whitelist** should have those lists set up and tested now. More end-user value → better POC.
- Open scenes in detail from any relevant tab to verify every relevant object/event triggered (were all faces detected? did weapons detection fire?).
- Success is not always instant; reviewing data over time shows where improvements are needed.

## Troubleshooting
Common places to check when the analytic setup has problems: pixel size, object detail, network, camera resolution. [TT14:troubleshooting-the-solution]

| Symptom | Cause | Fix | Src |
|---|---|---|---|
| Objects not detected | Object below the minimum pixel size (30 px) | Verify the pixel size (method below). The minimum can be lowered to **10 by 10** in the `Profile` (Object Type tab, `Minimum` field) — 10x10 may be too small for more advanced use cases; consider carefully | [TT14:verifying-pixel-size] |
| Plates not legible, faces not recognizable, analytic lacks detail | Too few **pixels per foot** — camera FoV too wide for the detail the analytic needs | Tighter camera field of view = more pixels per foot = more detail per frame. Vaidio does not invent information: license plates need **legible characters**, faces must be **fully recognizable**. Per-analytic **User Guides** (Partner Portal) state ideal setup conditions | [TT14:object-detail] |
| In `Live View`: screen turning **green**; missing or corrupted sections of video; lag between incoming video and the real stream; flat disconnection | Network not sustaining the stream — connected, but not **staying** connected; insufficient bandwidth | A constant camera stream is critical for most analytics. Vaidio pulls the stream from the camera or forwarded from a **VMS/NVR**; the network must have the bandwidth for it. Vaidio's team can help diagnose where the issue originates, but the **partner** is expected to verify and resolve it | [TT14:network-considerations] |
| Poor results from resolution | Vaidio receiving less than the recommended 1920x1080p / 2 megapixels (any resolution works, this is the recommended minimum for most use cases) | Check the resolution Vaidio actually receives in the `Camera Tab` and in each `Camera Edit` window. Pull a different (correct) RTSP stream (e.g. main stream instead of sub-stream [inferred]) or change the resolution on the camera's side | [TT14:camera-resolution] |

**Verifying pixel size** [TT14:verifying-pixel-size]
1. Open a scene from the `Search` page → the `Original Snapshot | Scene ID : <n>` dialog shows the frame with metadata. The dialog header shows the timestamp (`2025-03-13 15:03:00` in the video), the file name (`scene_255361593.jpg`) and `1 of 1`.
2. Below the detected-object thumbnail strip (green bounding boxes; the selected object outlined red), a metadata panel lists `Object Type`, `Color` (swatches), `Confidence`, `Width` and `Height` in pixels. Video examples: Person — Confidence 0.98, Width 71, Height 215; Head — Confidence 0.89, Width 39, Height 50.
3. For objects Vaidio did **not** detect, two options: (a) **download the scene** (scene toolbar download icon) and physically draw bounding boxes around the missed objects in an image tool to measure their size in pixels; or (b) **compare against a detected object** in the same frame — a detected head reading 39 px wide means a similar undetected head nearby can reasonably be estimated to have fallen **below the 30 px minimum**.
4. Remedy: lower the minimum to **10 by 10** in the `Profile` (Object Type tab, `Minimum` field), with the caution above.

## Knowledge checks (facts the course tests)
- Showcasing 3–4 meaningful analytics instead of everything allows deeper understanding and relevance to the client's needs. [TT14:choosing-the-right-analytics]
- Crucial factors when setting POC success criteria (multi-select, three correct): the number of analytics being demonstrated, the duration of the trial period, realistic expectations on analytic performance — not "the types of camera used". [TT14:choosing-the-right-analytics]
- The RTSP stream URL is not a requirement for the ONVIF method; IP address, HTTP port and username/password are. [TT14:onvif-vs-rtsp]
- The primary purpose of the Appliance Calculator on the Partner Portal is to determine server requirements for analytics (not camera settings, RTSP testing, or success criteria). [TT14:summary]
- "Dedupe" refers to the repeated trigger of events while an incident continues — i.e. the control over it (not false-positive reduction, not multi-event per occurrence, not area counting). [TT14:summary]
- The significant networking consideration for a POC is maintaining a constant camera stream for analytics to succeed (not same-manufacturer cameras, wired-only, or server location). [TT14:summary]
- The sensitivity trade-off: faster triggering may lead to more false positives. [TT14:summary]
- Minimum recommended camera resolution for most use cases is 1920x1080p (options: 1280x720p / 1920x1080p / 640x480p / 2560x1440p). [TT14:summary]

## Lesson index
| # | Lesson (slug) | Min | Video | Topic |
|---|---|---|---|---|
| 1 | introduction | 1 | HubSpot 187439384737 | Why POCs; module outline |
| 2 | scope | 1 | HubSpot 187445369217 | Two starting situations |
| 3 | choosing-the-right-analytics | 1 | HubSpot 187445433223 | 3–4 analytics, expectations, success criteria; 2 check-ins |
| 4 | hardware-considerations | 1 | HubSpot 187445433205 | Section intro |
| 5 | high-level-considerations | 1 | HubSpot 187445830021 | Ubuntu containers, Nvidia GPUs, Appliance Calculator, VMs |
| 6 | camera-connectivity | 1 | HubSpot 187445830024 | Section intro |
| 7 | onvif-vs-rtsp | 1 | HubSpot 187445369220 | ONVIF vs RTSP requirements, ports 80/554; 1 check-in |
| 8 | finding-rtsp-streams | 1 | HubSpot 187439384734 | URL syntax by make/model |
| 9 | testing-rtsp-streams | 1 | HubSpot 187445432621 | VLC `Open Network Stream` |
| 10 | common-set-up-considerations | 1 | HubSpot 187445829972 | Section intro |
| 11 | dedupe | 1 | HubSpot 187445433220 | Dedupe ON/OFF, cooldown placement |
| 12 | sensitivity | 1 | HubSpot 187445830030 | 2 fps, 5 of 20, 2.5 s, 1 s |
| 13 | confidence | 1 | HubSpot 187445369214 | 0–1 scale, `Profile` gear |
| 14 | line-crossings | 1 | HubSpot 187445432627 | 3D trajectory, line gap |
| 15 | integrations | 1 | HubSpot 187445433217 | Section intro |
| 16 | nvr-connectivity | 1 | HubSpot 187445830033 | `NVR` tab, 30 s clips, 1 h import, 5 min cooldown |
| 17 | vms-connectivity | 1 | HubSpot 187445433214 | Middleware / vendor licenses |
| 18 | smtp-connectivity | 1 | HubSpot 187445433211 | `System -> Mail` fields |
| 19 | testing-the-solution | 1 | HubSpot 187445829920 | Analytic guides, `Search` tab, lists |
| 20 | verifying-analytic-performance | 1 | HubSpot 187445829975 | Scene review over time |
| 21 | troubleshooting-the-solution | 1 | HubSpot 187445433208 | Section intro |
| 22 | verifying-pixel-size | 1 | HubSpot 187445432624 | `Original Snapshot` metadata, estimation, 10x10 |
| 23 | object-detail | 1 | HubSpot 187445829978 | Pixels per foot, User Guides |
| 24 | network-considerations | 1 | HubSpot 187445830027 | Live View symptoms, partner owns network |
| 25 | camera-resolution | 1 | HubSpot 187445369211 | 1920x1080p / 2 MP, `Camera Tab` check |
| 26 | summary | 1 | HubSpot 187445829981 | Recap; 5 check-ins |

## Source notes
- Lessons 2, 4, 6, 10, 15 and 21 are section intros with no facts beyond the section outline.
- The `verifying-pixel-size` page text is two sentences; the method, UI labels and example values come from its embedded 0:53 video. The `Original Snapshot | Scene ID : <n>` dialog, metadata fields and `scene_<n>.jpg` file name are read from the video frames.
- No default SMTP port, no VMS vendor names or ports, and no RTSP URL patterns or discovery tools are given; the course defers to camera documentation and the Partner Portal (vertical-application resources, Appliance Calculator, analytic guides, per-analytic User Guides).
- The sensitivity figures match TT9 [TT9:analytics-setup] exactly. The Dedupe-ON rule (object must leave the ROI for the cooldown duration) matches TT12 [TT12:roi-settings]; TT9 states only "leave and re-enter".
- Pixel size is quoted as a single-dimension "30 px minimum" here versus "30x30 pixels" in TT9/TT10/TT12/TT13; the remedy "10 by 10" matches TT13's `Minimum` lowered to 10.
- Resolution is stated as "1920x1080p / 2 megapixels" (the quiz accepts `1920x1080p`); TT9/TT10 say "2 megapixels", TT10/TT13 troubleshooting say "2 megapixels (1920x1080)".
- The summary quiz's Dedupe answer describes the phenomenon ("the repeated trigger of events while an incident continues") rather than the control, as phrased in the source.
- `[inferred]` marks the main-stream-vs-sub-stream example under camera resolution; the lesson says only "pull a different (correct) RTSP stream".
