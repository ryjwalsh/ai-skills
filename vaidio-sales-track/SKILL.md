---
name: vaidio-sales-track
description: Sales and pre-sales knowledge of the Vaidio AI Vision Platform from the Vaidio University Sales Certificate Track (ST1-ST6) - platform components (Pro Core, Enterprise Core, Edge, TED, Command Center, Vaidio Data, Vaidio DIY, Parking Management Application), licensing tiers and SKUs (Essentials / Advanced x Pro / Enterprise), Vaidio vocabulary (AI Model vs AI Engine, Profile, ROI, Resources, Events vs Alerts, AoV and pixels per foot), opportunity qualification (ideal vs poor-fit profiles, the 14 key verticals and their use-case lists, discovery questions, deal sizing by camera count), Partner Portal navigation, Appliance Calculator channel-counting rules, and the 8.1 release features. Use whenever someone needs to position, qualify, size, quote, explain or demo-plan Vaidio for a prospect, asks what a Vaidio term or component means, which license option applies, how to count analytics channels for the calculator, what is in the Partner Portal, or mentions Vaidio University, IronYun or the Vaidio sales track.
---

# Vaidio Sales Track (Vaidio University Sales Certificate Track)

What Vaidio (formerly IronYun) teaches its channel partners about selling the platform: vocabulary, components, licensing, who to sell to, how to size, where the partner resources are, and what changed in release 8.1. Pair it with `vaidio-technical-training` (how to configure it) and `vaidio` (vendor PDFs: install, ports, operations). [ST1]-[ST6]

## Scope and freshness
- Captured **2026-10-17** from university.vaidio.ai (partner login). 6 courses, 80 lessons, **63 captured**: ST1 is partial (4 of 21 lessons; see known-gaps.md) and ST5 is video-only, reconstructed from frames without narration.
- The Sales Certificate Track page says completed courses are logged toward certification and that "Certifications will come online soon" - there is no sales exam yet.
- The content predates Vaidio 9.x/10.x in places (8.1 GA September 2024 is the newest release covered). Licence names and SKUs should be confirmed against the current IronYun pricebook before quoting.

## Quick facts
| Item | Value | Src |
|---|---|---|
| What Vaidio is | Open, multi-functional AI Vision software platform; any IP camera, dozens of VMSs, NVIDIA GPUs; converts video into actionable, searchable data; hundreds of object types, thousands of vehicle models | ST1 |
| Three value vectors (every analytic delivers all three) | 1 real-time monitoring/alerting, 2 forensic video search, 3 business data/BI - usually one is the prospect's primary driver | ST3 ST1 |
| Components | Pro Core (GPU, non-Kubernetes, SMB-to-mid), Enterprise Core (Kubernetes/cloud/HA, ~1,000 cameras), Edge (Jetson, one analytic: LPR / FR / Intrusion / Object Tracking), TED (GenAI edge, early access), Command Center (no analytics, no GPU, alerts from up to 100 servers), Vaidio Data (BI charts), Vaidio DIY (labelling for custom models), PMA (parking app on Intrusion + MMR + LPR) | ST6 |
| Licensing | Flexible License = Essentials (any 2 analytics) or Advanced (any analytic) x Pro Core or Enterprise Core -> SKUs Pro Essentials, Enterprise Essentials, Pro Advanced, Enterprise Advanced; scope per subscribed camera; recommend <= 3 analytics per camera; 8.1 slide: term licence includes core software, analytics and annual maintenance | ST6 ST5 |
| Vocabulary | AI Model = detector; AI Engine = Analytic = use-case logic on the model's output; Profile = per-camera detection settings, reusable; ROI = Region of Interest; Resources = licence-set analytics capacity in `System -> License`; Events stay on the server, Alerts get exported | ST6 |
| Ideal opportunity | 100+ cameras, extend life of existing cameras, multiple sites, multiple Vision AI uses, security plus vertical use cases | ST3 |
| Poor fit | < 10 cameras, basic motion/intrusion only, price-driven, limited budget -> refer to a "Vaidio as a Service" provider | ST3 |
| Deal-size proxy | number of cameras that need Vaidio analytics (bounds licence, hardware and compute) | ST3 |
| 14 key verticals | Education; Energy & Utility; Enterprise, Corporate; Fed, Defense; Finance, Banking; Healthcare; Hospitality, Casinos, HOAs; Law Enforcement; Logistics, Shipping, Trucking; Manufacturing; Retail; SLED, Smart Cities; Stadiums, Events; Transportation Planes, Trains, Transit | ST3 |
| Appliance Calculator | Partner Portal sheet: 4 project settings (`Objective` A/B, `Form factor` A/B, `Buffer` % recommended 5%, `Detail extraction` A Standard / B Plus 4x / C Ultra 7x) + 18 "Analytics needed" rows; channel = camera stream per analytic; `+VS` never counts; several functions of one engine on one camera count once; Smoke & Fire counts in the Intrusion row | ST4 |
| Partner Portal | `IRONYUN PARTNER PORTAL` tabs: `Resource Library`, `Calculators` (Appliance Core, Appliance Edge, Capacity, Storage), `Support` (user guides as PDFs; tickets to Tech Support / Sales Support / Marketing), `New Deal Registration`, `FAQ`, `Vaidio Demo Site` | ST2 |
| 8.1 release (GA Sept 2024) | redesigned `Edit Camera` page with per-engine tabs and GPS/indoor `Location Type`; LPR plate `State` and `License Plate Type` search; Alert Dashboard map with `Unclaimed` / `Claimed` / `Cleared` triage; Cross Camera Tracking with `Similarity` and path map; Container ID; GenAI Tunable Edge Device with `VLM Prompt` | ST5 |

## Where to look (decision table)
| If the question is about | Read |
|---|---|
| What a component, licence tier, SKU or Vaidio term means; Edge vs Core; Command Center capacity; NVR/VMS/AoV basics | references/platform-components-and-terminology.md (ST6) |
| Qualifying a prospect, deal sizing, ideal/poor-fit profile, verticals and use-case lists, discovery questions | references/identifying-opportunities.md (ST3) |
| Counting channels for a quote or the Appliance Calculator, detail-extraction multipliers, LPR speed rows, Crowd 30+ definition | references/appliance-calculator.md (ST4) |
| Where something is in the Partner Portal, support routing, deal registration, demo site | references/partner-portal.md (ST2) |
| What changed in 8.1 and how the new screens look (Alert triage, CCT, Container ID, TED) | references/release-8.1.md (ST5) |
| The value proposition, VisionAI basics, NVIDIA proof point, three vectors (partial) | references/platform-introduction.md (ST1) |
| Something the courses did not cover or lessons not captured | known-gaps.md |
| Configuring the analytics the seller just promised | the `vaidio-technical-training` skill |
| Hardware specs, ports, install, licensing mechanics (.info/.key files), maintenance percentages | the `vaidio` skill |

## Answering rules for this skill
1. Keep vendor claims attributed ("the course states...") - accuracy figures, camera counts and ROI stories are marketing positions, not test results.
2. Quote licence/SKU names exactly as the course gives them and recommend confirming against the current IronYun pricebook; term lengths and prices are not in the course.
3. Channel counting: always apply the three rules (channel = camera stream per analytic; `+VS` adds nothing; one engine's several functions on one camera count once) and show the per-row arithmetic.
4. Do not reproduce the shared demo-site credentials from ST2; say they are published in the course lesson.
5. Cite lesson tags (`[ST4:analytics-channel-counts]`); lesson URLs are `https://university.vaidio.ai/<course-slug>?lesson=<slug>` (slugs in sources.md).
6. For anything 9.x/10.x (modular architecture, GenAI features beyond TED) defer to the `vaidio` skill's release coverage.

## Qualification script (condensed from ST3)
1. Vertical? (one of the 14; most sales to date are security and safety).
2. How many cameras need Vaidio intelligence (not total cameras)? -> deal size and compute bounds.
3. Which vector matters most - real-time alerts, investigation speed, or business data? Ask: "Do you need to detect, alert, search, or get data on [__]?" and "Are you focused on security or would you like to explore broader applications for Vision AI?"
4. Fit check: 100+ cameras, multi-site, multiple uses, existing cameras to extend = ideal; < 10 cameras / basic intrusion / price-first = refer to a VaaS partner.
5. Proof points: open platform (any IP camera), new and existing cameras, scales 10s to 1,000s, proven on tens of thousands of cameras, dozens of analytics out of the box, custom-model professional services (IronYun differentiator).

## Channel-count worked examples (ST4 check-ins)
- Intrusion + Video Search + PPE on one camera -> `Video Search 0 / Intrusion 1 / PPE 1`.
- Intrusion on 10 cameras, Smoke & Fire on 3 other cameras, Face Recognition on 7 more, Video Search everywhere -> `Video Search 0 / Intrusion 13 / Face Recognition 7` (20 channels).

## Knowledge-check highlights
AI Model is the tool that detects objects; Command Center cannot run analytics; Enterprise Core is the Kubernetes-enabled core; a Profile controls detection parameters at camera level; events live only on the server and alerts are what export; Resources = how many analytics can run simultaneously; a wide angle of view makes plates and faces unusable with distance; TED is the GenAI component limited to a small channel count; the best deal-size estimator is the number of cameras needing analytics. [ST6] [ST3]
