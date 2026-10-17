# Vaidio Technical Training — Source Inventory

All sources are Vaidio University courses at https://university.vaidio.ai (HubSpot-hosted "hubLMS" site, partner login required), read on **2026-10-17** through an authenticated browser session. Course pages: `https://university.vaidio.ai/<course-slug>`; lesson pages: `https://university.vaidio.ai/<course-slug>?lesson=<lesson-slug>`. Citations in this skill use `[<ID>:<lesson-slug>]`.

The Technical Certificate Track page (`/training-plan-courses/12702069561`) lists 14 courses, "approximately 3-4 hours", and states that completed courses are logged for credit toward certification and that "Certifications will come online soon" — no certification exam existed at capture time.

## Courses

| ID | Course | URL slug | Lessons | Min | Format | Captured | Reference |
|----|--------|----------|---------|-----|--------|----------|-----------|
| TT1 | Vaidio Setup Overview | vaidio-setup-overview | 8 | 22 | bare mp4 videos (Vaidio 7.2.0-1 demo), burned-in captions, 5 check-ins on the last lesson | 8/8 | references/setup-overview-demo.md |
| TT2 | Vaidio Setup Detailed Tutorial | vaidio-setup-detailed-tutorial | 33 | 41 | bare mp4 videos in 6 sections (7.2.0-1), burned-in captions, check-ins on lessons 7 and 13 | 33/33 | references/setup-detailed-tutorial.md |
| TT3 | Face Recognition | face-recognition | 14 | 15 | written lessons + HubSpot video per lesson + check-ins | 14/14 | references/face-recognition.md |
| TT4 | License Plate Recognition | license-plate-recognition | 13 | 15 | written + video + check-ins | 13/13 | references/license-plate-recognition.md |
| TT5 | Crowd Detection | crowd-detection | 9 | 10 | written + video + check-ins | 9/9 | references/crowd-detection.md |
| TT6 | Dwell Detection | dwell-detection | 9 | 10 | written + video + check-ins | 9/9 | references/dwell-detection.md |
| TT7 | Human Attributes | human-attributes | 7 | 12 | written + video + check-ins | 7/7 | references/human-attributes.md |
| TT8 | Person Fall | person-fall | 9 | 9 | written + video + check-ins | 9/9 | references/person-fall.md |
| TT9 | Intrusion Detection | intrusion-detection | 9 | 12 | written + video + check-ins | 9/9 | references/intrusion-detection.md |
| TT10 | Object Wrong Direction | object-wrong-direction | 9 | 9 | written + video + check-ins | 9/9 | references/object-wrong-direction.md |
| TT11 | Object Counting | object-counting | 9 | 9 | written + video + check-ins | 9/9 | references/object-counting.md |
| TT12 | Object Left Behind | object-left-behind | 9 | 10 | written + video + check-ins | 9/9 | references/object-left-behind.md |
| TT13 | Object Detection | object-detection | 10 | 12 | written + video + check-ins | 10/10 | references/object-detection.md |
| TT14 | Vaidio Proof of Concept & Customer Specific Demos | vaidio-proof-of-concept-customer-specific-demos | 26 | 26 | written + video + check-ins (one video transcribed: verifying-pixel-size) | 26/26 | references/poc-and-demo-playbook.md |
| — | Synthesis across TT1–TT14 | — | — | — | — | — | references/analytics-parameter-matrix.md, references/ui-navigation-map.md |

Totals: 174 lessons, ~212 minutes; 174 lessons captured (100%). Lesson-level video IDs (HubSpot `play.hubspotvideo.com/v/7620582/id/<id>`) and mp4 names are in each reference's "Lesson index".

## Lesson slugs per course (for `?lesson=` URLs)
- **TT1** vaidio-setup-overview: the-admin-portal, adding-cameras, setting-up-intrusion-detection, setting-up-object-counting, setting-up-license-plate-recognition, creating-lists, managing-incoming-alerts, the-alert-tab
- **TT2** vaidio-setup-detailed-tutorial: network-setup-instructor-introduction, network-setup-overview, accessing-vaidio-through-windows, accessing-vaidio-through-mac, accessing-vaidio, admin-portal, network-setup-conclusion, license-management-instructor-introduction, license-management-overview, license-page-part-1, support-portal, license-page-part-2, license-management-conclusion, camera-setup-instructor-introduction, camera-setup-overview, camera-page--ip-address-set-up, rtsp-set-up, general-roi, camera-setup-conclusion, intrusion-setup-instructor-introduction, intrusion-setup-overview, camera-popup-window, intrusion-tab, intrusion-setup-conclusion, video-search-instructor-introduction, video-search-overview, search-page, narrowing-searches, video-search-conclusion, alert-setup-instructor-introduction, alert-setup-overview, alert-dashboard-tab, alert-setup-conclusion
- **TT3** face-recognition: introduction, considerations, camera-setup, fr-parameters, save-settings--save-profile, face-lists-and-face-matching, face-target, face-upload-quality-threshold, dashboard, history, privacy-protection, alerts, troubleshooting, summary
- **TT4** license-plate-recognition: introduction, considerations, camera-setup, analytic-setup, profile, lpr-list, lpr-target, dashboard, history, add-detection-to-lpr-list, alerts, troubleshooting, summary
- **TT5** crowd-detection: introduction, considerations, roi-setup, analytic-settings, dashboard, history, alerts, troubleshooting, summary
- **TT6** dwell-detection: introduction, considerations, roi-setup, roi-settings, dashboard, history, alerts, troubleshooting, summary
- **TT7** human-attributes: introduction, considerations, ha-setup, profile, finding-target, alerts, conclusion
- **TT8** person-fall: introduction, considerations, roi-setup, roi-settings, abnormal-tab, history, alerts, troubleshooting, summary
- **TT9** intrusion-detection: introduction, considerations, roi-setup, analytics-setup, dashboard, history, alerts, troubleshooting, summary
- **TT10** object-wrong-direction: introduction, considerations, line-setup, line-settings, dashboard, history, alerts, troubleshooting, summary
- **TT11** object-counting: introduction, considerations, line-setup, line-settings, dashboard, history, alerts, troubleshooting, summary
- **TT12** object-left-behind: introduction, considerations, analytic-setup, roi-settings, dashboard, history, alerts, troubleshooting, summary
- **TT13** object-detection: introduction, considerations, analytic-setup, profile, search-tab-review, other-search-features, heatmap, alerts, troubleshooting, summary
- **TT14** vaidio-proof-of-concept-customer-specific-demos: introduction, scope, choosing-the-right-analytics, hardware-considerations, high-level-considerations, camera-connectivity, onvif-vs-rtsp, finding-rtsp-streams, testing-rtsp-streams, common-set-up-considerations, dedupe, sensitivity, confidence, line-crossings, integrations, nvr-connectivity, vms-connectivity, smtp-connectivity, testing-the-solution, verifying-analytic-performance, troubleshooting-the-solution, verifying-pixel-size, object-detail, network-considerations, camera-resolution, summary

## Retrieval notes
- Written lessons were read as page text; check-in questions were read from the page including the correct-answer markup, so every "Knowledge checks" fact reflects the answer the course grades as correct (two apparent authoring errors are flagged in the references and known-gaps.md).
- Video-only lessons (TT1, TT2) have no text, transcript or caption track; narration was recovered from captions burned into the frames, sampled every 2–3 s, and UI details from full-frame samples every 10–20 s. Short connective phrases may be missing; no numeric value was taken from a frame that was unclear.
- Embedded HubSpot videos on the written courses were not transcribed (the page text is the lesson script) except TT14 `verifying-pixel-size`, whose page text is two sentences.
- Nothing was submitted, completed or marked on the training account: no `NEXT`, `COMPLETE AND LEAVE COURSE` or `CHECK ANSWER` clicks. Course completion for certification credit is left to the account holder.
- The courses are written against the Vaidio Core UI of 7.2–9.x; the sibling `vaidio` skill (vendor PDFs retrieved 2026-07-25) covers 9.0–10.0 installation and administration.
- External items the courses point to but which were not retrieved: Partner Portal user guides (per-analytic PDFs, "Technical Support User Guide" with RTSP paths, "License Plate Recognition User Guide" with the list-import file format), the Appliance Calculator, and the Vaidio Support Portal.
