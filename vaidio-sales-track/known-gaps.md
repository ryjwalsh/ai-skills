# Vaidio Sales Track - Known Gaps

Anything listed here was **not** answered by the Vaidio University sales courses captured on 2026-10-17. Do not fill these from general knowledge; retrieve them (re-run the capture, open the Partner Portal, or ask Vaidio sales support) and then update the references.

## 1. Lessons not captured

None - all 80 lessons were read (ST1 lessons 4 and 6-21 in a second pass on 2026-10-17).

## 2. Content present in the course but not recoverable from the page
- **ST5 Vaidio 8.1 Release**: all nine lessons are narrated videos with no text or captions; release-8.1.md holds only what the slides and screens show. The spoken rationale, any numbers quoted aloud, and the "Modularization" bullet of the summary slide are not captured. Retrieve: Partner Portal Resource Library ("AI Friday Forum | 8.0 Release" recording and 8.1 release materials) or the 8.1 release notes on the Support Portal.
- **ST6 licensing-terminology**: the list of Essentials-tier-eligible analytics is shown in a chart in the video only. **Not captured.**
- **ST6 TED / ST5 TED**: the TED channel count is "small" but never quantified. **Not documented.**
- **ST2 Resource Library**: the dropdown option values for `Resource type`, `Category` and `Analytics` filters and the full deal-registration form (fields below the fold) are visible only in the how-to videos. **Not captured.**
- **ST2 Demo Site**: the shared partner demo login is published in the lesson and deliberately omitted from this skill.

## 3. Facts the courses never state
- Prices, term lengths, maintenance percentages, discount tiers, or how Essentials/Advanced map to the per-channel perpetual licence described in the vendor PDFs (`vaidio/SKILL.md` says perpetual per-analytic-channel plus 15%/5% maintenance; ST5 says "Vaidio Term License includes core software, analytics, annual maintenance"). **Reconcile with the current pricebook before quoting.**
- Hardware SKUs, GPU models or channels-per-server - the Appliance Calculator computes them but its formulas are not exposed (see `vaidio/known-gaps.md`).
- Competitive positioning against named competitors; partner tiers, margins, MDF, certification requirements or benefits.
- Which analytics are "Specialized Object" models beyond weapons; which verticals have reference customers; any case-study numbers beyond the truck-yard narrative.
- Whether "Vaidio as a Service" providers are named partners (ST3 says to refer small deals to them without naming any).

## 4. Course inconsistencies to keep in view
| Topic | Discrepancy | Where |
|---|---|---|
| Calculator wording | Lesson text `Lowest price` / `Expansion capacity` vs sheet `Lowest cost` / `More room for additional analytics channels in the future` | appliance-calculator.md |
| Enterprise Core naming | Summary quiz says "Pro Enterprise"; AoV check-in says "Area of View" | platform-components-and-terminology.md |
| Parking product name | PMA / Parking Management Application (ST6), `Parking Facility Management` (ST4 row 17), "Parking management" (ST3) | all three references |
| Command Center naming | ST4 sheet says "control center" | appliance-calculator.md |
| Ideal camera threshold | ">100 cameras" (ST3 L06) vs "100+ cameras" (ST3 L07) | identifying-opportunities.md |
| VMS and analytics counts | "dozens" of VMSs (ST1 L01) vs 30 (ST1 L09); "30 AI video analytics" (ST1 L10/quiz) vs a 41-item catalogue (ST1 L11) | platform-introduction.md |
| False-alert percentage | ST1 L20 states a 99.995% reduction for 2,000 -> 10 alerts/month (arithmetically 99.5%) | platform-introduction.md |
| Vertical lists | ST1 names 11 verticals and 12/7/10/11-item application lists; ST3 names 14 key verticals and 10/9/10/10-item lists | platform-introduction.md, identifying-opportunities.md |
| Vertical counts | ST3 L11 announces five target verticals with examples; L09 lists 14 key verticals | identifying-opportunities.md |
| GPU requirement | ST5 slide: every deployment form "with NVIDIA GPU"; ST6: Command Center needs no GPU | release-8.1.md, platform-components-and-terminology.md |
| Dates | ST5 slides carry a 2025 confidentiality footer, a 10/25/24 summary slide and "GA September 2024" | release-8.1.md |
| LPR speed bands | ST4 rows: parking lot <10 mph, city road ~10-40, highway >40 - matches TT4, differs from the TT1 narration (<=10 / <=50 / >50) | appliance-calculator.md, `vaidio-technical-training/known-gaps.md` |
| Vendor name | Courses alternate between IronYun (pricebook, helpdesk, portal branding, professional services) and Vaidio (product, university) | all references |

## 5. Suggested retrieval order
1. Partner Portal > Resource Library: pull the 8.1 and later release decks to replace the frame-only ST5 reference, and the Essentials analytics chart.
2. Ask Vaidio sales support for the current pricebook SKU list and licence term definitions.
3. Partner Portal > Calculators: run the Capacity and Storage calculators and record inputs/outputs (also a `vaidio` skill gap).
