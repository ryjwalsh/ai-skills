# Human Attributes — Vaidio University TT7 "Human Attributes"

> Source: Vaidio University (university.vaidio.ai) course TT7, 7 lessons, captured 2026-10-17. Written-lesson content plus check-in questions; embedded videos were not transcribed except where noted. UI names reflect the Vaidio 7.x–9.x web UI shown in the course — verify against the deployed version. Full source table: ../sources.md.

## At a glance
Human Attributes (HA) extends conventional Object Search with a more robust set of parameters for finding a person: clothing type (full body, upper body sleeve length, lower body garment) and clothing colors. Mainly a forensic-analysis tool across many cameras; pairs with Cross Camera Tracking. No ROI is drawn; alerts use the normal `Object Detection` rule type. [TT7:introduction] [TT7:ha-setup] [TT7:alerts] [TT7:conclusion]

| Item | Value | Src |
|---|---|---|
| Engine / camera tab | `AI Engine` dropdown → `Human Attributes`; profile parameters in the `HA` tab; no ROI required | [TT7:ha-setup] [TT7:profile] |
| Camera | ≥ `2 megapixels`; people at least `200 × 200` pixels | [TT7:considerations] |
| `Minimum size` | default `200 × 200` pixels; can be increased up to `600` pixels | [TT7:profile] |
| `Quality detection` | enabled/disabled toggle; enabled = person must be fully visible head to toe | [TT7:profile] |
| Where results appear | Object Search: `Person` object type + `Clothing` option (`Full body`, `Upper body`, `Lower body`) + 10-color palette | [TT7:finding-target] |
| Alert type | configured under the `Object Detection` Alert Rule (cameras + clothing attributes); no separate HA alert type | [TT7:alerts] |
| Delivery | email, HTTP service, VMS | [TT7:alerts] |

## Camera and scene requirements
| Requirement | Value | Src |
|---|---|---|
| Minimum resolution | `2 megapixels` | [TT7:considerations] |
| Pixels on target | People at least `200 × 200` pixels; achieve by higher resolution or by placing the camera close enough to the subjects | [TT7:considerations] |
| Visibility | With `Quality detection` enabled, a person must be fully visible head to toe before HA runs; partially overlapped people (crowded scenes) are only analyzed with it disabled, at the cost of attribute accuracy | [TT7:profile] |
| ROI | None — HA has no ROI drawing step | [TT7:ha-setup] |

## Setup procedure
### Add HA to a camera [TT7:ha-setup]
1. Click the `pencil icon` (right side of the screen) on the chosen camera → `Camera Edit` window.
2. `AI Engine` dropdown (top right) → `Human Attributes`.
3. Save the camera — no ROI drawing is required.

### Profile parameters and save [TT7:profile]
4. In the `HA` tab of the camera profile set `Minimum size` and `Quality detection` (see Parameters).
5. Click `save` at the bottom of the popup → dialog asks for a profile name → name it and save → press `save` once more to assign the profile to the current camera.
6. Reuse: open another camera's profile window → choose the profile in the `profile dropdown list` → `save`. Same process applies the profile to multiple cameras; a saved profile is not tied to the camera it was created for. [TT7:profile] [TT7:conclusion]

## Parameters
Two adjustable parameters in the `HA` tab. [TT7:profile]

| Parameter | Default | Range / options | Effect of raising | Effect of lowering | Src |
|---|---|---|---|---|---|
| `Minimum size` (lesson heading calls it "Minimum Face Size") | `200 × 200` pixels | can be increased up to `600` pixels | Demands larger people on screen before HA runs; ensures a level of accuracy | Smaller people analyzed | [TT7:profile] |
| `Quality detection` | not stated | enabled · disabled | Enabled: a person must be fully visible head to toe before HA runs | Disabled: HA may run on partially overlapped people — helps in crowded scenes, but some or all attributes may be captured inaccurately | [TT7:profile] |

There is no maximum size parameter and no color option in the profile. [TT7:conclusion]

## Dashboard, history and search
### Finding a target in Object Search [TT7:finding-target]
1. Start as for an Object Detection search: select the `Person` object type.
2. With HA enabled a `Clothing` option appears, split into three sections — any combination can be selected:

| Section | Attributes | Src |
|---|---|---|
| `Full body` | full-body outfit | [TT7:finding-target] |
| `Upper body` | long sleeves / short sleeves | [TT7:finding-target] |
| `Lower body` | pants, shorts, skirts | [TT7:finding-target] |

3. Narrow by color: a palette of 10 colors; any colors can be picked (quiz wording: "color wheel").
4. Lesson example — person in a long red-sleeved shirt: `Person` + Long sleeve + Red. Blue pants + yellow shirt: `Person` + clothing attributes for pants and shirts + blue and yellow.
5. Selecting a result shows the person's details. HA pairs with Cross Camera Tracking: from one instance, search for the same person across all cameras.

## Alerts [TT7:alerts]
- Clothing-color alerts are configured under the normal `Object Detection` Alert Rule parameters — there is no separate HA alert type.
- In the rule select the cameras and the clothing attributes it applies to. Alertable attributes: top clothing color, specific pants styles, full-body outfit colors (not minimum face size). [TT7:conclusion]
- HA is mainly a forensic tool, but events can be forwarded to email, an HTTP service, or a VMS.

## Troubleshooting
The course has no troubleshooting lesson; rows restate the Considerations and Profile lessons.

| Symptom | Cause | Fix | Src |
|---|---|---|---|
| HA attributes not produced for people in the scene | People below `Minimum size` (`200 × 200` px default) | Raise resolution or move the camera closer to the subjects (raising `Minimum size` toward `600` demands even larger people on screen) | [TT7:considerations] [TT7:profile] |
| HA skips people in crowded / overlapping scenes | `Quality detection` enabled requires full head-to-toe visibility | Disable `Quality detection` (accept that some attributes may be inaccurate) | [TT7:profile] |
| Attributes inaccurate | `Quality detection` disabled is running HA on partially overlapped people | Enable `Quality detection` so only fully visible people are analyzed | [TT7:profile] |

## Knowledge checks (facts the course tests)
- Minimum recommended camera resolution for HA is `2 megapixels`. [TT7:ha-setup]
- The default HA minimum size is `200 × 200` pixels, not `100 × 100` (quiz phrases it as "minimum face size"). [TT7:ha-setup]
- To find a person in a long red-sleeve shirt use the `Person` object type, the Long sleeve clothing attribute and the Red color option — all three. [TT7:finding-target]
- Primary purpose of HA: provide a robust selection of parameters when searching for a person. [TT7:conclusion]
- A saved HA profile can be applied to multiple cameras, not only the camera it was created for. [TT7:conclusion]
- HA alert parameters: top clothing color, specific pants styles, full-body outfit colors (not minimum face size). [TT7:conclusion]
- Adjustable HA profile parameters: `Minimum size` and `Quality detection` (not maximum size, not color options). [TT7:conclusion]
- Search for blue pants + yellow shirt: select the `Person` object type, choose the clothing attributes for pants and shirts, use the color wheel to select blue and yellow (not "set minimum face size to 600 pixels"). [TT7:conclusion]

## Lesson index
| # | Lesson (slug) | Min | Video | Topic |
|---|---|---|---|---|
| 1 | introduction | 1 | HubSpot 187326808133 | HA as an expansion of Object Search |
| 2 | considerations | 1 | HubSpot 187323866941 | 2 MP, `200 × 200` px people |
| 3 | ha-setup | 1 | HubSpot 187324100398 | `pencil icon` → `AI Engine` → `Human Attributes`, no ROI |
| 4 | profile | 2 | HubSpot 187323866950 | `Minimum size` (200–600 px), `Quality detection`, save profile |
| 5 | finding-target | 3 | HubSpot 187323866947 | `Clothing` sections, 10-color palette, Cross Camera Tracking |
| 6 | alerts | 3 | HubSpot 187323866938 | `Object Detection` rule type, email/HTTP/VMS |
| 7 | conclusion | 1 | HubSpot 187324100401 | Recap, 5-question check-in |

## Source notes
- Parameter naming inconsistency: the profile lesson heading calls the size parameter "Minimum Face Size" and the ha-setup quiz says "minimum face size", while the parameter is the minimum person size (`200 × 200` px default, up to `600`); the conclusion quiz names it `Minimum size`. [TT7:profile] [TT7:ha-setup] [TT7:conclusion]
- `Quality detection` here is an enabled/disabled toggle; in Face Recognition (TT3) a parameter with the same name has `Low` / `Medium` / `High` modes. [TT7:profile]
- Default state of `Quality detection` is not stated.
- Color picker is called a "palette of 10 colors" in the lesson and a "color wheel" in the quiz. [TT7:finding-target] [TT7:conclusion]
- No dashboard, history or troubleshooting lesson exists; alert delivery lists email, HTTP and VMS (no Vaidio App, unlike LPR TT4). [TT7:alerts]
- Course is complete (all 7 lessons captured); videos not transcribed.
