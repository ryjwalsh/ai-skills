# Vaidio Sales Track — Source Inventory

All sources are Vaidio University courses at https://university.vaidio.ai (HubSpot-hosted "hubLMS" site, partner login required), read on **2026-10-17** through an authenticated browser session. Course pages: `https://university.vaidio.ai/<course-slug>`; lesson pages: `https://university.vaidio.ai/<course-slug>?lesson=<lesson-slug>`. Citations in this skill use `[<ID>:<lesson-slug>]`.

The Sales Certificate Track page (`/training-plan-courses/12702050648`) lists 6 courses, "approximately 3 hours", and states that completed courses are logged for credit toward certification and that "Certifications will come online soon" — no certification exam existed at capture time.

## Courses

| ID | Course | URL slug | Lessons | Min | Format | Captured | Reference |
|----|--------|----------|---------|-----|--------|----------|-----------|
| ST1 | Vaidio AI Vision Platform Introduction | vaidio-ai-vision-platform-introduction | 21 (4 sections) | 58 | written lessons, some with HubSpot video | **4/21** (introduction, interface-overview, visionai--basics, object-recognition…) | references/platform-introduction.md |
| ST2 | The Vaidio Partner Portal | the-vaidio-partner-portal | 6 | 12 | written lessons + how-to screen videos (poster frames read, videos not played) | 6/6 | references/partner-portal.md |
| ST3 | Identifying Opportunities | identifying-opportunities | 17 (2 sections) | 45 | written lessons, 1 check-in | 17/17 | references/identifying-opportunities.md |
| ST4 | Appliance Calculator | appliance-calculator | 3 | 14 | written lessons + 2 screenshots of the calculator sheet (read), 2 check-ins | 3/3 | references/appliance-calculator.md |
| ST5 | Vaidio 8.1 Release | vaidio-8.1-release | 9 | 16 | **video-only** (HubSpot screen recordings and slides, no captions, no text, no check-ins) — frames sampled every ~10 s, narration not recovered | 9/9 (frames only) | references/release-8.1.md |
| ST6 | Vaidio Terminology & Key Concepts | vaidio-terminology-and-key-concepts | 24 | 25 | written lessons + HubSpot video per lesson, 3 check-ins + 5-question summary | 24/24 | references/platform-components-and-terminology.md |

Totals: 80 lessons, ~170 minutes; 63 lessons captured (79%). Lesson-level HubSpot video IDs (`play.hubspotvideo.com/v/7620582/id/<id>`) are in each reference's "Lesson index".

## Lesson slugs per course (for `?lesson=` URLs)
- **ST1** vaidio-ai-vision-platform-introduction: introduction, interface-overview, visionai--basics, visionai-compute, object-recognition-the-foundation-of-vaidio-visionai, examples-of-vaidio-visionai, the-opportunity, problems-vaidio-solves, a-dropin-solution, vaidio-summary, vaidio-analytics, adding-cameras-and-analytics-increases-compute-requirements, aienabled-cameras-vs-vaidio, vaidio-verticals, vaidio-education, vaidio-retail, vaidio-smart-cities, vaidio-healthcare, ironyun-custom-model-development, vaidio-value, value-proposition-summary
- **ST2** the-vaidio-partner-portal: resource-library, calculators, support, deal-registration, faqs, demo-site
- **ST3** identifying-opportunities: start-here-a-camerabased-solution, four-keys-to-effective-prospecting, vaidio--vision-ai-is-a-camerabased-solution, vaidio--realtime-search-and-data-applications, initial-sizing-the-number-of-cameras, ideal-opportunities, what-makes-these-opportunities-ideal, less-suitable-opportunities, key-verticals--overview, surveillance-and-security-applications, vertical-applications, vertical-application-examples--education, vertical-application-examples--retail, vertical-application-examples--smart-cities, vertical-application-examples--healthcare, logistics-shipping-trucking, clarifying-the-need-and-the-value
- **ST4** appliance-calculator: appliance-calculator-overview, appliance-calculator-part-1--project-requirements, analytics-channel-counts
- **ST5** vaidio-8.1-release: introduction, platform-overview, camera-page, lpr, alert-dashboard, cross-camera-tracking, container-id, tunable-edge-device, 81-release-summary
- **ST6** vaidio-terminology-and-key-concepts: introduction, vaidio-platform-components, pro-core, edge, ted, command-center, enterprise-core, vaidio-data, vaidio-diy, parking-management-application-pma, licensing-terminology, vaidio-terminology, ai-model, ai-engine--analytic, profile, roi, resources, events-vs-alerts, video-surveillance-terminology, nvr, vms, ip-camera, angle-of-view-aov, summary

## Related external resources named by the courses (not retrieved)
| Resource | Where | Why it matters |
|---|---|---|
| IronYun Partner Portal (`www.vaidio.ai/partner-resources/...`) | Vaidio University header link `Partner Portal`; ST2 | Resource Library (datasheets, videos, presentations), four calculators, user-guide PDFs, ticketing, deal registration, FAQ, demo site |
| Appliance Core / Edge, Capacity and Storage calculators | Partner Portal > `Calculators` | Sizing; only the Appliance (Core) calculator's inputs are documented (ST4) |
| Vaidio Demo Site | Partner Portal > `Vaidio Demo Site` | Public camera streams for partner demos; shared login published in ST2 (not reproduced) |
| IronYun pricebook | referenced in ST6 | SKU names for the four licence options |
| helpdesk@ironyun.com | ST4 row 17 | Sizing parking spots per camera for Parking Facility Management |

## Retrieval notes
- Written lessons were read as page text; check-in questions were read with their correct-answer markup, so "Knowledge checks" facts reflect the graded answer.
- ST5 has no text or captions; its reference is reconstructed from UI frames and slides and is explicitly marked as partial.
- ST2's how-to videos were not played; filter labels and form fields were read from their poster frames.
- Nothing was submitted or marked complete on the training account; course completion for certification credit is left to the account holder.
- Sibling skills: `vaidio` (vendor PDFs retrieved 2026-07-25, Vaidio 9.0–10.0) and `vaidio-technical-training` (Technical Track, same capture date).
