# Appliance Calculator — Vaidio University ST4 "Appliance Calculator"

> Source: Vaidio University (university.vaidio.ai) course ST4, 3 lessons, captured 2026-10-17. Text-only course: written-lesson content, check-in questions and two screenshots of the calculator spreadsheet; no lesson embeds a video. Sheet labels reflect the calculator version shown in the course (screenshot file names dated 2024-03-14) — verify against the current Partner Portal calculator. Full source table: ../sources.md.

## At a glance
The "IronYun Appliance calculator" (IronYun = Vaidio's company name) computes the server appliances required to support a given set of cameras and analytics functions — which servers are needed to run the desired analytic engines on the desired number of camera channels. It has exactly TWO input sections: (1) Project requirements — the `Setting` table; (2) the number and type of each analytic — the `Analytics needed:` channel-count table. The calculator lives in the Partner Portal `Calculators` tab, where it is the "Appliance Core calculator" (partner-portal.md). [ST4:appliance-calculator-overview]

| Quick fact | Value | Src |
|---|---|---|
| Objective | `(A) Lowest cost (Default)` — lesson text calls it "Lowest price"; `(B)` = expansion capacity (larger servers) | [ST4:appliance-calculator-part-1--project-requirements] |
| Form factor | `(A) Any (Default)`; `(B) Rackmount only` | [ST4:appliance-calculator-part-1--project-requirements] |
| Buffer | `0` entered; `Recommended: 5%` | [ST4:appliance-calculator-part-1--project-requirements] |
| Detail extraction | `(A) Standard (Default)` 1x; `(B) Plus` 4x compute per channel (4K); `(C) Ultra` 7x (8K); `Core Platform only` | [ST4:appliance-calculator-part-1--project-requirements] |
| Channel | A camera STREAM being analysed, not a physical camera; one camera × two analytics = 2 channels | [ST4:analytics-channel-counts] |
| `+VS` | Video Search is bundled in every row and never adds a channel | [ST4:analytics-channel-counts] |
| Multi-function engines | Face Recognition, Intrusion Detection, Object Tracking — several functions of one engine on one camera = `1` | [ST4:analytics-channel-counts] |
| Smoke & Fire | No row of its own; counts in the Intrusion row even on cameras without Intrusion | [ST4:analytics-channel-counts] |
| Recording cap | `Vaidio Video Recording` channels must not exceed total analytics channels | [ST4:analytics-channel-counts] |
| PMA sizing | Contact `helpdesk@ironyun.com` for the number of parking spots per camera | [ST4:analytics-channel-counts] |
| Totals | `Total channels per site (Vaidio Core)` auto-sums; shows `0` when empty | [ST4:analytics-channel-counts] |

## Project Requirements (`Setting` table)  [ST4:appliance-calculator-part-1--project-requirements]
Sheet header `Setting`; sub-header `Describe your project scope (skip if all default settings are acceptable)`. Each row has a one-letter/number answer cell on the right; answers are entered as the letter A/B/C, or a percentage for Buffer. [inferred]

| Setting (lesson wording) | Exact sheet label | Choices (lesson wording) | Cell value / default | Behaviour |
|---|---|---|---|---|
| Objective | `Objective: (A) Lowest cost (Default); (B) More room for additional analytics channels in the future` | Lowest price, or Expansion capacity | `A` = Lowest price | Lowest price → the lowest-cost configuration of appliances that can support the required cameras + analytics. Expansion capacity → the minimal combination of LARGER servers, leaving headroom for growth |
| Form factor | `Form factor: (A) Any (Default); (B) Rackmount only` | Any form factor, or Rackmount only | `A` = Any | — |
| Buffer | `Buffer for future upgrades (%); Recommended: 5%` | Buffer percentage for future additions | `0` entered; recommended 5% | Percentage of capacity reserved for future additions/upgrades |
| Detail | `Detail extraction (Core Platform only): (A) Standard (Default); (B) Plus; (C) Ultra` | Standard, Plus, or Ultra detail extraction | `A` = Standard | Applies to the Core Platform only, i.e. not Edge devices; compute multipliers below |

Detail-extraction multipliers (compute is per camera channel):

| Level | Use | Best resolution | Compute vs Standard |
|---|---|---|---|
| Standard | default | — | 1x |
| Plus | detecting small details in a large field | 4K | 4x more compute per channel (raises hardware requirements) |
| Ultra | long distances | 8K | 7x more compute per channel |

## Channel-counting rules  [ST4:analytics-channel-counts]
1. "Number of channels" = number of camera STREAMS being analysed, NOT the number of physical cameras. Vaidio can run multiple analytics on one camera (given enough compute), so one camera running two different analytics counts as two channels. Example: Intrusion Detection + PPE on the same camera → `1` in the Intrusion count column and `1` in the PPE count column = 2 channels total.
2. Exception 1 — Engines / `+VS`: every analytic row includes `+VS` (Video Search). Video Search is bundled and never adds to the analytic count. Example: Intrusion Detection + Video Search on one camera → add just `1` to the Analytic Count (Intrusion 1, Video Search 0).
3. Exception 2 — Counts / multi-function engines: Face Recognition, Intrusion Detection and Object Tracking are engines that each support several analytic functions. If several functions of ONE engine run on ONE camera, add only `1` to that engine's count. Example: Intrusion Detection + Distancing on one camera → add just `1` (Intrusion). The Intrusion Detection engine also covers Smoke & Fire and Distancing.
4. Corollary: there is NO separate Smoke & Fire row; Smoke & Fire running on a camera WITHOUT Intrusion still counts as `1` in the Intrusion row.
5. Enter counts per site, or once for all sites when all sites are connected to a control center (Command Center). Sheet instruction: `Input the number of channels of each analytics for EACH site (or all sites if all sites are connected to a control center)`. Every row's count cell defaults to `0`.

## Calculator rows (`Analytics needed:` table)  [ST4:analytics-channel-counts]
| # | Row label (verbatim) | Engine family / bundled functions |
|---|---|---|
| 1 | `Video Search (object detection) + Heatmap` | Standalone VS-only channel |
| 2 | `Intrusion Detection + Smoke & Fire Detection + Distancing Detection + VS` | Intrusion engine |
| 3 | `PPE (helmet, safety vest) + VS` | PPE |
| 4 | `Age & Gender + VS` | Age & Gender standalone |
| 5 | `Face Recognition + Age & Gender + Emotion + Face Mask + VS` | Face Recognition engine |
| 6 | `Object Left Behind + VS` | OLB |
| 7 | `Vehicle Make and Model (MMR) + VS` | MMR |
| 8 | `LPR - parking lot (<10 mph) + VS` | LPR, slow traffic |
| 9 | `LPR - city road (~10-40 mph) + VS` | LPR, medium speed |
| 10 | `LPR - highway (>40 mph) + VS` | LPR, high speed |
| 11 | `Object Tracking + Counting + Dwell Time + Wrong Direction + VS` | Object Tracking engine |
| 12 | `Cross Camera Tracking (CCT) + VS` | CCT |
| 13 | `Scene Change + VS` | Scene Change |
| 14 | `Crowd Detection (counting more than 30 people) + VS` | Crowd |
| 15 | `Person Fall/Crouch Detection + VS` | Person Fall |
| 16 | `Specialized Object (e.g., weapon) + VS` | Custom / specialized object models |
| 17 | `Parking Facility Management (contact helpdesk@ironyun.com for # parking spots per camera) + VS` | PMA — spots per camera must be sized with the IronYun helpdesk |
| 18 | `Vaidio Video Recording (must not exceed total number of analytics channels)` | Recording channels; capped at the analytics total |
| — | `Total channels per site (Vaidio Core)` | Auto-sum row (shows `0` when empty) |

Sizing facts embedded in the row labels:
- LPR is split into three speed bands — `<10 mph` parking lot, `~10-40 mph` city road, `>40 mph` highway — because compute differs by vehicle speed.
- Crowd Detection is defined as counting more than 30 people.
- Vaidio Video Recording channels may not exceed the total analytics channels.
- Parking Facility Management needs `helpdesk@ironyun.com` to size parking spots per camera.

## Worked examples (check-in questions)  [ST4:analytics-channel-counts]
| # | Scenario | Enter | Why | Rejected options and why |
|---|---|---|---|---|
| 1 | Intrusion Detection + Video Search + PPE on one camera | `Video Search: 0; Intrusion: 1; PPE: 1` | Intrusion Detection includes Video Search, so together they count as Intrusion 1 / Video Search 0; PPE is a separate analytic and counts as PPE 1 | `VS 0 / Intrusion 2 / PPE 1`; `VS 0 / Intrusion 3 / PPE 0`; `VS 1 / Intrusion 1 / PPE 1` |
| 2 | Intrusion Detection on 10 cameras, Smoke & Fire on 3 separate cameras, Face Recognition on 7 additional cameras, Video Search on all of them | `Video Search: 0; Intrusion: 13; Face Recognition: 7` (20 channels total) | All analytics include Video Search, so it adds nothing; Smoke & Fire has no separate row and is counted in the Intrusion row even on cameras without Intrusion (10 + 3 = 13); Face Recognition adds 7 | `VS 0; Intrusion 10; Smoke & Fire 3; FR 7` — total 20 is right but there is no Smoke & Fire option; `VS 20; Intrusion 13; FR 7` — VS must not be added; `VS 0; Intrusion 10; FR 7` — omits the 3 Smoke & Fire cameras |

## Knowledge checks (facts the course tests)
- Intrusion Detection + Video Search + PPE on one camera is entered as `Video Search: 0; Intrusion: 1; PPE: 1` — Video Search is included in Intrusion; PPE is a separate analytic (worked example 1). [ST4:analytics-channel-counts]
- Intrusion on 10 cameras + Smoke & Fire on 3 other cameras + Face Recognition on 7 more, with Video Search on all, is entered as `Video Search: 0; Intrusion: 13; Face Recognition: 7` = 20 channels — Smoke & Fire is counted in the Intrusion row (worked example 2). [ST4:analytics-channel-counts]
- Lessons 1 and 2 have no check-in questions. [ST4:appliance-calculator-overview] [ST4:appliance-calculator-part-1--project-requirements]

## Lesson index
| # | Lesson (slug) | Min | Video | Topic |
|---|---|---|---|---|
| 1 | appliance-calculator-overview | 1 | none | What the calculator computes; its two input sections |
| 2 | appliance-calculator-part-1--project-requirements | 5 | none (one screenshot of the `Setting` table) | Objective, Form factor, Buffer, Detail extraction |
| 3 | analytics-channel-counts | 8 | none (one screenshot of the `Analytics needed:` table) | Channel definition, `+VS` and multi-function-engine exceptions, 18 analytic rows, two check-ins |

## Source notes
- Official name in the lesson: "IronYun Appliance calculator"; IronYun is Vaidio's company name and the helpdesk domain (`helpdesk@ironyun.com`). [ST4:appliance-calculator-overview] [ST4:analytics-channel-counts]
- Wording differs between lesson text and sheet: Objective (A) is "Lowest price" in the text and `Lowest cost` on the sheet; (B) is "Expansion capacity" in the text and `More room for additional analytics channels in the future` on the sheet — same options. [ST4:appliance-calculator-part-1--project-requirements]
- The sheet scopes Detail extraction to `Core Platform only` (not Edge devices); the lesson text does not mention that limit. [ST4:appliance-calculator-part-1--project-requirements]
- That answers are typed as the letters A/B/C (or a percentage for Buffer) is read from the screenshot cells, not stated in the text. [inferred]
- The sheet instruction says "control center" where the platform component is named Command Center (platform-components-and-terminology.md). [ST4:analytics-channel-counts]
- Row 17 is labelled `Parking Facility Management`; ST6 calls the product Parking Management Application (PMA). [ST4:analytics-channel-counts]
- The two calculator screenshots are `Screenshot 2024-03-14 at 7-26-42 PM.png` and `Screenshot 2024-03-14 at 7-50-02 PM.png`; no lesson embeds a video.
- The Partner Portal hosts four calculators (Appliance Core, Appliance Edge, Capacity, Storage) and says each has a calculator-specific course; only this Core appliance calculator course is in the capture. [ST2:calculators]
