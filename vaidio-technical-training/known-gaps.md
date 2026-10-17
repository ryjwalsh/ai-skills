# Vaidio Technical Training - Known Gaps

Anything listed here was **not** answered by the Vaidio University technical courses captured on 2026-10-17. Do not fill these from general knowledge; retrieve them (re-run the capture, open the vendor guide, or ask Vaidio SA) and then update the references.

## 1. Lessons not captured (30 of 174)

| Course | Missing | Why | How to close |
|---|---|---|---|
| TT2 Vaidio Setup Detailed Tutorial | Lessons 1-13: network-setup-instructor-introduction, network-setup-overview, accessing-vaidio-through-windows, accessing-vaidio-through-mac, accessing-vaidio, admin-portal, network-setup-conclusion, license-management-instructor-introduction, license-management-overview, license-page-part-1, support-portal, license-page-part-2, license-management-conclusion | Browser extension stopped responding during the capture run; these video lessons were never opened | Re-run the video capture (seek every 2-3 s, read captions) for `https://university.vaidio.ai/vaidio-setup-detailed-tutorial?lesson=<slug>`; expected content: first-login from Windows/Mac, Admin Portal, `System > License` export/import and Support Portal licence request. Interim coverage: setup-overview-demo.md (Admin Portal) and `vaidio/references/operations.md` (licensing workflow). |
| TT1 Vaidio Setup Overview | Lesson 8 `the-alert-tab`, video time 60-183 s | Same outage | Re-run from t = 60 s: HTTP notification trigger walk-through, a second alert example, Alert `History` tab. Interim: `vaidio/references/api-integration.md` documents HTTP alert triggers from the 9.3 vendor guide. |

## 2. Facts the courses never state

### A. Defaults and ranges
- `Dedupe Events` default and `Cooldown Interval` default are not stated in any written course (the 7.2 UI showed ON and `9` s). Crowd `Crowd Threshold`, Dwell `Time Threshold`, OLB trigger time, FR `Similarity threshold`, FR `Quality detection` mode, HA `Quality detection` state, LPR `Mode` default and the `Include Still Object` / `Motion Detection` defaults: **no default stated**.
- Sensitivity steps other than the default (5 scenes / 10 s) and the quoted fast setting (2 / 5 s); whether the 2 fps sampling rate is configurable. **Not documented.**
- SMTP port, NVR ports and VMS vendor list/ports. **Not documented** (fields exist; see `vaidio/references/network-ports.md`).
- RTSP URL patterns per camera brand: deferred by the course to the "Technical Support User Guide" (vendor PDF S3 in `vaidio/sources.md`). Only Dahua-style examples were observed in the videos.
- LPR list import file format: deferred to the "License Plate Recognition User Guide" on the Partner Portal.
- Essentials-tier eligible analytics, licence SKUs and resource costs per engine: sales-track material; see `vaidio-sales-track/known-gaps.md`.

### B. Features mentioned but not taught
- Make & Model Recognition, Cross Camera Tracking, Scene Change, PPE, Age & Gender, Illegal Parking, Loitering, People Counting (`PC`), `PWD`, Smoke & Fire, Specialized Object (weapons), Container ID, Vaidio DIY labelling, Parking Management Application - named in engine lists or other courses, no technical course exists for them in the track.
- The `Alert Rule` tab contents in TT2 are explicitly deferred to "future courses"; the HTTP trigger payload is in the uncaptured TT1 segment.
- Command Center, Vaidio Data, Vaidio Enterprise/Manager, Edge/TED configuration: not in the technical track (see the `vaidio` skill).
- Vaidio App (mobile) notification setup: named as an alert channel only.

### C. Version coverage
- TT1/TT2 videos show Vaidio **7.2.0-1**; written courses do not state a version. 8.1 redesigned the `Edit Camera` page (per-engine tabs, GPS/indoor `Location Type`, alert `Unclaimed/Claimed/Cleared` triage) and 9.x/10.x changed further. Re-verify dialog layouts, the `Cluster` field, and tab names on the deployed build.
- 8.1 features (State/plate-type search, Container ID, CCT `Similarity`, TED `VLM Prompt`) are documented only from frames in `vaidio-sales-track/references/release-8.1.md`.

## 3. Course inconsistencies to keep in view (not errors in this skill)
| Topic | Discrepancy | Where |
|---|---|---|
| LPR mode speed bands | TT4/ST4: Parking Lot <10 mph, City Road 10-40, Highway >40 (1x/2x/3x cost). TT1 narration: Parking lot <=10, City Road <=50, Highway >50 at 2/4/6 fps | license-plate-recognition.md, setup-overview-demo.md |
| Minimum-size wording | TT8 calls Person Fall's 100x100 px "a larger default minimum than other analytics", yet HA defaults to 200x200 px | person-fall.md, human-attributes.md |
| `Quality detection` | three-level mode (Low/Medium/High) for FR; on/off toggle for HA | face-recognition.md, human-attributes.md |
| HA size parameter name | "Minimum Face Size" (lesson heading, one quiz) vs `Minimum size` (conclusion quiz) | human-attributes.md |
| Profile second tab | `VS` (TT13 heading + quiz, 7.2 UI) vs `OD` (TT13 body text) | object-detection.md |
| Default model spelling | `PowerModel` (TT9, UI: `PowerModel-Core-7.2g2-Pro-3.4`) vs `Power Model` (TT13) | analytics-parameter-matrix.md |
| Confirm buttons | engine setup ends with `Save` (TT6/8/9/10/12), `OK` (TT1/2/11/13) or `Save` then `OK` (TT4); alert rule ends with `OK` (TT6/9) or `Save` (TT5/8/10/12) | analytics-parameter-matrix.md |
| Entry point wording | `pencil icon` / `Camera Edit` window / `AI Engine` (most courses) vs `edit` button / `Edit Camera` popup / `AI Engines` (TT4, 7.2 UI) | all per-engine references |
| Camera requirements stated unevenly | 2 MP + 30x30 px in TT9/TT10/TT5 Considerations; TT11 none; TT12/TT13 only in troubleshooting; TT6 no resolution; TT8 only in troubleshooting/quiz | analytics-parameter-matrix.md |
| Dedupe-ON cooldown semantics | TT6/TT12/TT14: cooldown = time the object must be out of the ROI; TT5/TT8/TT9 omit this | analytics-parameter-matrix.md |
| Alert channel lists | TT4: HTTP, SMTP, Vaidio App, VMS; TT7: email, HTTP, VMS; TT3: email, VMS, door signal; TT2: email, text, apps, third party | analytics-parameter-matrix.md |
| History filters / export | 30 days everywhere; Excel export named only in TT6/TT8/TT10/TT11/TT12; filter sets differ per engine | per-engine references |
| Quiz authoring errors | TT8 summary Q4 marks both "every 5 seconds" and "once every 5 minutes" correct (lesson supports 5 s); TT12 analytic-setup check-in lists one distractor twice; TT8 dedupe check-in has two lesson-consistent options with one graded | person-fall.md, object-left-behind.md |
| Course labels | TT4 page `<title>` says "TT6"; TT6 summary says "Object Counting"; TT14 quiz defines "Dedupe" as the phenomenon rather than the control | license-plate-recognition.md, dwell-detection.md, poc-and-demo-playbook.md |

## 4. Suggested retrieval order
1. Re-capture TT2 lessons 1-13 and TT1 lesson 8 tail (browser session, ~20 min of video).
2. Pull the per-analytic User Guides and the Technical Support User Guide from the Partner Portal (ungated PDFs listed in `vaidio/known-gaps.md` section 3) to fill defaults the courses omit.
3. Confirm with Vaidio SA which LPR speed bands apply to the deployed release.
4. Confirm the 9.x/10.x names for `Camera Edit` dialog sections, `Profile` tabs and the `Abnormal` dashboard.
