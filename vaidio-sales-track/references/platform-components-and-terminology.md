# Platform components and terminology — Vaidio University ST6 "Vaidio Terminology & Key Concepts"

> Source: Vaidio University (university.vaidio.ai) course ST6, 24 lessons, captured 2026-10-17. Written-lesson content plus check-in questions; embedded videos were not transcribed except where noted. UI names reflect the Vaidio 7.x–9.x web UI shown in the course — verify against the deployed version. Full source table: ../sources.md.

## At a glance
The vocabulary course for sellers: the eight "most common" platform components (Pro Core, Edge, TED, Command Center, Enterprise Core, Vaidio Data, Vaidio DIY, PMA), the licensing model (two analytics tiers × two core types = four SKUs), the terms met when setting up and operating a server (AI Model, AI Engine/Analytic, Profile, ROI, Resources, Events vs Alerts) and four surveillance-industry terms (NVR, VMS, IP camera, Angle of View). Vaidio is framed as a constantly expanding platform, so these terms recur in self-learning and in customer conversations; the stated outcome is to speak the same language the Vaidio team uses. [ST6:introduction] [ST6:summary]

| Quick fact | Value | Src |
|---|---|---|
| Most common / most mature component | Pro Core — 10+ years of development, NVIDIA GPUs, non-Kubernetes, small-to-medium installations | [ST6:pro-core] |
| Kubernetes core | Enterprise Core — on-prem data center or cloud, high availability; at ~1,000 cameras dramatically less hardware than Pro Core; same analytics as Pro Core | [ST6:enterprise-core] |
| Edge analytics (one per device) | License Plate Recognition, Face Recognition, Intrusion, Object Tracking; NVIDIA Jetson; a few streams per device | [ST6:edge] |
| TED | Tunable Edge Device — a "5th type" of Edge; first Vaidio implementation of Generative AI; early-access, experimental; small channel count | [ST6:ted] |
| Command Center | Runs no analytics, needs no GPU; receives alerts from up to 100 other Vaidio servers | [ST6:command-center] |
| License options | Essentials (any 2 analytics) or Advanced (any analytic) × Pro Core or Enterprise Core = 4 SKUs; scope is per subscribed camera | [ST6:licensing-terminology] |
| Analytics per camera | Recommend no more than 3 | [ST6:licensing-terminology] |
| Resources | Unit of how many analytics a server can run; `System -> License` tab; set by the license | [ST6:resources] |
| ROI | Region of Interest (not return on investment) | [ST6:roi] |
| Events vs Alerts | Events stay on the server; alerts are what get exported (email, VMS) | [ST6:events-vs-alerts] |
| AoV | Angle of View; detail is quantified as pixels per foot and falls off quickly with distance on wide lenses | [ST6:angle-of-view-aov] |

## Components
The platform has several components covering use cases from a few cameras up to large, complex enterprise deployments; choosing and using the right component correctly is called out as a major success factor. The eight below are the "most common components". [ST6:vaidio-platform-components]

| Component | What it is | Runs on | Limits / notes | Src |
|---|---|---|---|---|
| Pro Core | Most common component and most mature product line (developed over 10+ years); standard, non-Kubernetes core platform software optimized for straightforward deployments | NVIDIA GPUs; non-Kubernetes environments | Ideal for small-to-medium installations that do not need advanced orchestration or cloud compatibility. Supports the same analytics functions as Enterprise Core; the two differ only in operational/scalability fit | [ST6:pro-core] [ST6:enterprise-core] [ST6:licensing-terminology] |
| Edge | Small, single-analytic servers; lightweight and easy to deploy for small, simple use cases | NVIDIA Jetson devices | Only a few camera streams per device. One analytic per device, from: License Plate Recognition, Face Recognition, Intrusion, Object Tracking | [ST6:edge] |
| TED (Tunable Edge Device) | A "5th type" of Edge component (beyond the four Edge analytics); the first Vaidio implementation of Generative AI for safety and security; positioned as the future of the platform | Edge component; hardware not stated in this course (the 8.1 TED web app is in release-8.1.md) | Still supports only a small number of channels. Status early-access, experimental: the Vaidio team may recommend it only for the right customer who wants to partner and experiment — not a general-purpose sell | [ST6:ted] |
| Command Center | Consolidates information from all other Vaidio platform components; the central hub for reviewing data at scale | No GPU required | Runs NO analytics of its own. Can receive alerts from up to 100 other Vaidio servers | [ST6:command-center] |
| Enterprise Core | Advanced, Kubernetes-enabled core platform software for on-premises data centers and cloud-based deployments; built for large-scale, enterprise-grade environments needing high availability and seamless scalability across complex infrastructure | Kubernetes (on-prem data center or cloud) | At a ~1,000-camera scale, dramatically reduces hardware requirements compared with Pro Core. Same analytics functions as Pro Core | [ST6:enterprise-core] [ST6:licensing-terminology] |
| Vaidio Data | Business-intelligence component: integrated graphs and charts that process information coming from a Vaidio Core (Pro Core or Enterprise Core); manages and visualizes all types of data produced by the analytics | Fed by a Vaidio Core component | — | [ST6:vaidio-data] |
| Vaidio DIY | Image-labeling tool used to build a custom AI model for objects of interest NOT in Vaidio's standard object-type catalog; described as user-friendly, aimed at partners | — | Workflow: partner labels the dataset in DIY → partner sends the labeled data to Vaidio/IronYun → Vaidio trains and returns a custom AI model | [ST6:vaidio-diy] |
| PMA (Parking Management Application) | Automates monitoring of parking spaces and sends real-time alerts based on user-defined rules per parking spot; a full-featured, AI-enabled parking-lot management solution | Built on top of Vaidio Core and Edge | Uses three analytic engines: Intrusion Detection, Vehicle Make & Model Recognition, License Plate Recognition | [ST6:parking-management-application-pma] |

## Licensing  [ST6:licensing-terminology]
- "Flexible License" = a choice of two Analytics Tiers × two Core Types.

| Analytics Tier | Entitlement |
|---|---|
| Essentials Tier | Customer picks any TWO analytics functions and can flexibly deploy those two |
| Advanced Tier | Customer can use / flexibly deploy ANY analytics function supported by the current Vaidio release |

| Core Type | Definition |
|---|---|
| Pro Core | Standard, non-Kubernetes core platform software |
| Enterprise Core | Advanced, Kubernetes-enabled core platform software for on-prem data center and cloud deployments |

Four resulting license options, each with its own SKU in the IronYun pricebook (IronYun = Vaidio's parent company / pricebook owner):

| SKU / license option | Tier | Core |
|---|---|---|
| Pro Essentials | Essentials | Pro |
| Enterprise Essentials | Essentials | Enterprise |
| Pro Advanced | Advanced | Pro |
| Enterprise Advanced | Advanced | Enterprise |

- Scope is per subscribed camera: Essentials → either of the two chosen analytics on ALL subscribed cameras; Advanced → any analytic on all subscribed cameras. Worked example: Pro Advanced for 100 cameras → any analytics function may be applied within and across those 100 cameras.
- Hardware caveat: stacking multiple analytics on one camera drives up compute; the customer must have hardware that supports the demand.
- Recommendation: deploy no more than THREE analytics functions per camera, or carefully limit the cases where more than 3 analytics run on one camera.
- The lesson refers to a chart/table of Essentials-eligible analytics that is not on the lesson page (presumably shown in the video); the specific list is not captured. [inferred]

## Platform terminology
Terms met when setting up a Vaidio server and operating it in your own or a customer's environment. [ST6:vaidio-terminology]

| Term | Meaning | Detail | Src |
|---|---|---|---|
| AI Model | The AI tool that detects objects; performs the raw image processing — the first layer | Every detectable object class (people, vehicles, cows, weapons, etc.) is backed by an AI model; engines/analytics run on the model's output | [ST6:ai-model] |
| AI Engine / Analytic | Interchangeable terms. The second layer of detection: after the model processes an image, its results feed one or more engines that apply use-case logic | Examples: Face Recognition, Intrusion Detection. Pipeline: AI Model (raw detection) → one or more AI Engines/Analytics (use-case logic) → events/alerts | [ST6:ai-engine--analytic] |
| Profile | The function that controls a set of settings at the CAMERA level for an analytic | Examples of what it controls: how confident the AI must be that it spotted a weapon; how much leeway the server has to detect faces at non-ideal angles. Operates per camera; one profile can be applied to as many cameras as needed (reusable). Each analytic's profile settings are covered in that analytic's Technical Track course | [ST6:profile] |
| ROI | Region of Interest — NOT return on investment | The tool used to draw areas on a camera view for area-based analytics such as Intrusion Detection and Object Left Behind | [ST6:roi] |
| Resources | Vaidio's unit of measurement for how many analytics a server can run | Shown in the `System -> License` tab; the number is set/controlled by the license. Each analytic deployed on the server consumes a fixed amount. Production practice: servers are built and licensed so they never exceed the resource limit. Demo environments: the number of available analytics may not match the server's resource limit — enabling a camera that would push the server over the limit triggers an error message (the camera/analytic is refused rather than degrading) | [ST6:resources] |
| Event | Raw output of an analytic engine once analytics are configured | Lives ONLY on the Vaidio server; can be viewed and searched there | [ST6:events-vs-alerts] |
| Alert | The next level up from an event | What can be forwarded/exported to external systems (e.g. email, a VMS). Rule of thumb: events stay on the server; alerts are what get exported | [ST6:events-vs-alerts] |

## Video-surveillance terminology
Industry terms that Vaidio also uses, defined for people coming from outside video surveillance. [ST6:video-surveillance-terminology]

| Term | Meaning | Vaidio relevance | Src |
|---|---|---|---|
| NVR | Network Video Recorder — device/software that saves footage from connected cameras and lets users view it | Vaidio can connect to NVRs to pull recorded footage and play it back alongside events | [ST6:nvr] |
| VMS | Video Management System — advanced software for consolidating video/information from across the network; usually also stores and replays video (like an NVR) but adds advanced management functionality and extra features for running a surveillance environment | Alerts can be exported to a VMS | [ST6:vms] [ST6:events-vs-alerts] |
| IP camera | The most consistent/common devices connected into the Vaidio platform; they live on and communicate over the local network | NVRs, VMSs and the Vaidio AI Vision Platform all consume IP-camera streams to extract information from the environment | [ST6:ip-camera] |
| Angle of View (AoV) | How much coverage a camera has; important when troubleshooting analytics | More resolution does NOT automatically mean more detail: a wide AoV diminishes detail because objects get much less detailed the farther they are from the camera. Vaidio quantifies detail as pixels per foot captured by the camera; wide-angle lenses lose pixels-per-foot quickly with distance. The lesson's check-in calls the same concept "Area of View" | [ST6:angle-of-view-aov] |

## Knowledge checks (facts the course tests)
- TED is the component designed for Generative AI in safety and security; its main limitation versus other Edge components is that it supports only a small number of channels. Distractors stated as false: Edge with a larger stream count; Command Center requiring a GPU; Enterprise being lightweight. [ST6:parking-management-application-pma]
- Resources measure the total number of analytics that can run simultaneously without exceeding the server limit — which is why the figure is monitored when deploying analytics. Not: maximum camera count, server processing power, or video-stream quality. [ST6:events-vs-alerts]
- A wide Area/Angle of View leads to rapidly diminishing image quality the farther out the view gets, so plates and faces far from a wide-angle camera will not be usable for LPR and Face Recognition. False distractors: higher pixel-per-foot at distance; it shrinks an ROI; plates blurry but faces easy. [ST6:angle-of-view-aov]
- Summary quiz, 5 questions [ST6:summary]:
  1. The tool used to detect objects in Vaidio is the AI Model (not AI Engine, Camera Profile, or Line pair).
  2. False — Command Center cannot run its own analytics; it runs no analytics and needs no GPU.
  3. The primary difference between Pro Core and "Pro Enterprise" (the quiz's name for Enterprise Core — vendor naming inconsistency) is that Pro Enterprise is Kubernetes enabled and Pro Core is not. Not: Pro Core is single-analytic; not: they are virtually identical.
  4. A Profile exists to control detection parameters at the camera level (not camera count, enabling engines, or user permissions).
  5. False — events are not the engine output that can be exported: events live exclusively on the server; alerts are what can be exported to external systems.

## Lesson index
| # | Lesson (slug) | Min | Video | Topic |
|---|---|---|---|---|
| 1 | introduction | 1 | 187439250492 | Course framing; three term groups |
| 2 | vaidio-platform-components | 1 | 187437611681 | Section intro; right component = success factor |
| 3 | pro-core | 1 | 187439335331 | Pro Core |
| 4 | edge | 1 | 187437648168 | Edge (Jetson, one analytic per device) |
| 5 | ted | 1 | 187437941256 | Tunable Edge Device |
| 6 | command-center | 1 | 187437941250 | Command Center |
| 7 | enterprise-core | 1 | 187437611672 | Enterprise Core (Kubernetes) |
| 8 | vaidio-data | 1 | 187439352386 | Vaidio Data (BI) |
| 9 | vaidio-diy | 1 | 187439335337 | Vaidio DIY (custom-model labeling) |
| 10 | parking-management-application-pma | 1 | 187439335328 | PMA; check-in on TED |
| 11 | licensing-terminology | 2 | 187759793050 | Tiers, core types, four SKUs, ≤3 analytics per camera |
| 12 | vaidio-terminology | 1 | 187439352389 | Section intro |
| 13 | ai-model | 1 | 187439335319 | AI Model |
| 14 | ai-engine--analytic | 1 | 187760522375 | AI Engine / Analytic |
| 15 | profile | 1 | 187437941253 | Profile |
| 16 | roi | 1 | 187439335322 | ROI = Region of Interest |
| 17 | resources | 1 | 187437611675 | Resources (`System -> License`) |
| 18 | events-vs-alerts | 1 | 187437611669 | Events vs Alerts; check-in on Resources |
| 19 | video-surveillance-terminology | 1 | 187437611684 | Section intro |
| 20 | nvr | 1 | 187439384171 | NVR |
| 21 | vms | 1 | 187437648165 | VMS |
| 22 | ip-camera | 1 | 187437555562 | IP camera |
| 23 | angle-of-view-aov | 1 | 187439335334 | Angle of View; check-in |
| 24 | summary | 1 | 187437941259 | Recap; 5-question quiz |

## Source notes
- Vendor naming: the summary quiz says "Pro Enterprise" where the lessons say Enterprise Core [ST6:summary]; the AoV check-in says "Area of View" where the lesson says Angle of View [ST6:angle-of-view-aov].
- Vendor naming across courses: ST6 calls the parking product Parking Management Application (PMA); the ST4 calculator row is `Parking Facility Management` (appliance-calculator.md); ST3 lists "Parking management" as a use case (identifying-opportunities.md). [ST6:parking-management-application-pma]
- The Essentials-tier analytics chart/table referenced in the licensing lesson is not on the page; the list of Essentials-eligible analytics is not captured. [inferred] [ST6:licensing-terminology]
- TED hardware is not stated; the only TED channel-count statement is "a small number of channels" (no figure). ST5 shows the TED web app `Vaidio Edge` at `edgeted.ironyun.com:3093` (release-8.1.md). [ST6:ted]
- Per-analytic Profile settings are deferred to the Technical Track course for each analytic. [ST6:profile]
- IronYun is named as Vaidio's parent / owner of the pricebook; it is also the recipient of DIY-labeled data for custom-model training. [ST6:licensing-terminology] [ST6:vaidio-diy]
- The summary promises more advanced terms in future lessons. [ST6:summary]
- Check-in questions appear only in lessons 10, 18, 23 and 24; all other lessons have none.
