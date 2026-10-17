# Face Recognition — Vaidio University TT3 "Face Recognition"

> Source: Vaidio University (university.vaidio.ai) course TT3, 14 lessons, captured 2026-10-17. Written-lesson content plus check-in questions; embedded videos were not transcribed except where noted. UI names reflect the Vaidio 7.x–9.x web UI shown in the course — verify against the deployed version. Full source table: ../sources.md.

## At a glance
Face Recognition (FR) detects faces on a camera and matches them against face targets grouped in lists. Use cases: safety, security, access control, forensic analysis, flagging persons of interest. The course covers the chain "from the camera to alerts": camera placement → `FR` tab parameters → profile → lists/targets → Dashboard/History → Privacy Protection → Alert Rules → troubleshooting. [TT3:introduction] [TT3:summary]

| Item | Value | Src |
|---|---|---|
| Engine / camera tab | `AI Engine` dropdown → `Face Recognition`; tab `FR` appears above the camera preview | [TT3:camera-setup] |
| Camera | ≥ `2 megapixels` (`1920×1080`), frontal view, mounted `6–8 ft` | [TT3:considerations] [TT3:troubleshooting] |
| Face size | `Minimum face size` default `64 × 64` px; `100 × 100` px or greater recommended | [TT3:fr-parameters] |
| Quality detection | `Low` / `Medium` / `High` on the camera; separate upload threshold at `System > Settings`, default `Low` | [TT3:fr-parameters] [TT3:face-upload-quality-threshold] |
| Similarity threshold | no default stated; lower → more matches and more false positives | [TT3:fr-parameters] [TT3:face-lists-and-face-matching] |
| Where results appear | Facial Recognition tab (`Face icon`): `Dashboard` (real time) and `History` (forensic, up to 30 days) | [TT3:face-lists-and-face-matching] [TT3:dashboard] [TT3:history] |
| Lists / targets | list = named group with a list color; target = `Name` + `List`, up to five image variants | [TT3:face-lists-and-face-matching] [TT3:face-target] |
| Alerts | Alert Rule for Face Recognition scoped by cameras + lists; `not in list` condition available | [TT3:alerts] |
| Privacy | `Privacy Protection` toggle at `System > Settings` blurs faces/people for viewers; analytics still run | [TT3:privacy-protection] |

## Camera and scene requirements
Each analytic has its own camera-setup considerations — not one-size-fits-all. Not configuring per these recommendations risks inaccurate face recognition results. [TT3:considerations] [TT3:camera-setup]

| Requirement | Value | Src |
|---|---|---|
| Minimum resolution | `2 megapixels`; most deployments need at least 2 MP (`1920×1080`), and the camera must be imported into Vaidio at 2 MP minimum (not only capable of it) | [TT3:considerations] [TT3:troubleshooting] |
| Orientation | Camera faces front, directly toward people's faces (frontal view) | [TT3:considerations] |
| Mounting height | `6–8 ft` vertically; a further target changes the required height — adjust mounting per scene | [TT3:considerations] |
| Pixels on target | Faces `100 × 100` px or greater for best results; the `64 × 64` default only gives flexibility when adding a camera; more pixels per face = more detail | [TT3:fr-parameters] |
| ROI placement | Where faces are largest, clearest and most likely facing front | [TT3:camera-setup] |
| Lighting | Poor lighting causes inconsistent detection; on WDR-capable cameras enable `Wide Dynamic Range (WDR)` when appropriate | [TT3:fr-parameters] [TT3:troubleshooting] |
| Shutter | Slow shutter speed → motion blur; increase shutter speed | [TT3:troubleshooting] |
| Network | Dropped packets corrupt frames; constant uptime required | [TT3:troubleshooting] |
| Angle vs resolution | Higher resolution alone does not guarantee results; angle and lighting are also critical | [TT3:summary] |

## Setup procedure
### Enable FR on a camera [TT3:camera-setup]
1. On the camera list click the `pencil icon` (right side of the screen) → `Camera Edit` window for that camera.
2. `AI Engine` dropdown (top of the Camera Edit view) → `Face Recognition` → new tab `FR` appears above the camera preview.
3. In `FR` draw the region of interest (ROI) — the area Vaidio concentrates on; for FR, where faces are largest/clearest and most likely facing front.
4. Set `Minimum face size`, `Similarity threshold` and `Quality detection` in the `FR` tab (see Parameters). [TT3:fr-parameters]

### Save settings as a profile and reuse it [TT3:save-settings--save-profile]
1. Click `save` at the bottom of the Camera Edit popup → dialog asks you to name the profile.
2. Enter a name and save the profile.
3. Press `save` one final time to assign the profile to the current camera.
- A saved profile means the camera can start running the analytic, and the same analytic + settings can be applied to any other camera.
- Reuse: open the other camera's profile window → pick the profile from the `profile dropdown list` → `save`. The same process applies one analytic profile to multiple cameras at the same time.

### Create lists, then face targets
1. Click the `Face icon` → Facial Recognition tab. Landing view is the `Dashboard`; target preparation starts on the `list` page. [TT3:face-lists-and-face-matching]
2. Create a list first, then add targets. A list = group of people organized by a principle: blacklist, whitelist, people authorized for a certain building, people authorized by security level, etc. Lists must be named (lesson example `whitelist`); each list has an adjustable list color to distinguish lists. [TT3:face-lists-and-face-matching]
3. Add face targets to the list: [TT3:face-target]
   - Image: high resolution, subject facing the camera; no blurry or heavily angled images.
   - Up to five variants per target (e.g. with/without glasses, with/without a hat).
   - Source: own uploaded reference pictures, or pulled directly from detections (better accuracy — the reference matches the camera environment; see Dashboard).
   - Required fields: `Name`, `List` (membership). Optional: `gender`, `birthday`, free-text `description`.
   - Save the target.
4. Server-side upload threshold: `System > Settings` → face image quality for uploads, default `Low`; raise it so only high-quality face targets are accepted. `High` / `Medium` / `Low` have the same meanings as the camera `Quality detection` modes. [TT3:face-upload-quality-threshold]

## Parameters
Three adjustable parameters in the `FR` tab of the camera profile, plus one server-wide upload threshold. [TT3:fr-parameters]

| Parameter | Default | Range / options | Effect of raising | Effect of lowering | Src |
|---|---|---|---|---|---|
| `Minimum face size` — smallest pixel dimension of a face Vaidio will analyze | `64 × 64` pixels | pixel dimensions; `≥ 100 × 100` recommended | Fewer small faces analyzed | More small, less detailed faces analyzed | [TT3:fr-parameters] |
| `Similarity threshold` — confidence required that a detected face matches a database picture; affects alerts, authorizations and searches | not stated | — | Fewer matches, usually more accurate | More matches, some lower accuracy; lower thresholds can increase false positives | [TT3:fr-parameters] [TT3:face-lists-and-face-matching] |
| `Quality detection` — clarity and angle the server requires before it detects or alerts on a face | not stated | `Low` / `Medium` / `High` | Requires frontal, sharp faces; more true positives can be lost (a head turned sideways is discarded under `High`, preventing further reporting) | More tolerant, more results, more false matches | [TT3:fr-parameters] |
| Face upload quality threshold (`System > Settings`) — which uploaded target images the server accepts | `Low` | `Low` / `Medium` / `High` (same meanings as above) | Only high-quality face targets accepted | Any visible face accepted as a target image | [TT3:face-upload-quality-threshold] |

Purpose of the similarity threshold: balance false positives against false negatives. [TT3:summary]

### Quality detection modes [TT3:fr-parameters]
| Mode | Accepts | Use-case guidance |
|---|---|---|
| `High` | Face front-facing, not blurry, eyes and nose clearly defined | Access control → `High` or `Medium` |
| `Medium` | Full-detail faces plus faces not directly facing the camera (side profiles, people looking down may be detected) | Access control or forensic search |
| `Low` | Any visible face regardless of image quality or facing direction | Forensic search (identify as many faces as possible) → `Medium` or `Low` |

Fault-tolerance trade-off: higher quality setting = greater chance of losing a true positive on a face target; lower = more false matches. [TT3:fr-parameters]

## Dashboard, history and search
### Dashboard [TT3:dashboard]
- Prerequisites for events: FR running on at least one camera, plus face targets in the system.
- Every detected face is logged as a real-time event notification on the FR Dashboard.
- Matched detection → notification shows the target plus the matching event face. Unmatched → blank-face placeholder.
- Turn a detection into a target (reference comes from the real camera environment → better accuracy):
  1. Select a detected face on the Dashboard and run a face search.
  2. The `Face Search` window compares the selected face against other faces detected within the chosen time window.
  3. Click the `person +` icon to create a new target from that face, **or**
  4. Add the face to an existing target (adds a variant → better detection accuracy).

### History [TT3:history]
- `History` tab = forensic face searching and filtering; does not update in real time (unlike the Dashboard).
- Searchable look-back up to `30 days`.
- Filters: camera, time period, lists, face similarity.

### Privacy Protection [TT3:privacy-protection]
- Path: `System` page → `Settings` tab → toggle `Privacy Protection` → `apply` (bottom of page). Server updates; setting becomes active.
- Blurs faces and people in video shown to users — no discernible face/person details.
- Analytics such as FR still run on the unblurred stream.
- Users with the right permission can toggle the blur on/off per scene to see the original; users without it only ever see the blurred scene.

## Alerts [TT3:alerts]
- FR actions are driven by Alert Rules. Example outputs: email to notify authorities of a person of interest; push data into a third-party VMS; signal a door to open or lock.
- A new Alert Rule for Face Recognition selects (a) the cameras and (b) the lists it applies to.
- List conditions: pick the white list to send an unlock signal when authorized personnel are detected; pick `not in list` to be notified only when an unrecognized person appears at a point of entry.

## Troubleshooting
Review the scene in `Object Search` after the camera has processed faces. [TT3:troubleshooting]

| Symptom | Cause | Fix | Src |
|---|---|---|---|
| Faces tiny in Object Search, features not legible | Not enough pixels on the face; AI cannot invent detail absent from the footage | Better-suited camera/view (closer, zoomed, or higher resolution) so faces meet `64 × 64` minimum / `≥ 100 × 100` recommended | [TT3:troubleshooting] |
| Faces large but still lack detail (eyes/mouth not distinct) — motion blur | Camera shutter speed too slow | Increase camera shutter speed → better feature recognition, less blur | [TT3:troubleshooting] |
| Faces lack detail — low resolution | Camera below 2 MP, or imported into Vaidio below 2 MP | At least `2 megapixels (1920×1080)`; confirm the camera is 2 MP-capable **and** imported into Vaidio at 2 MP minimum | [TT3:troubleshooting] |
| Faces too dark or too bright | Lighting / dynamic range | On cameras with `Wide Dynamic Range (WDR)`, enable WDR when appropriate | [TT3:troubleshooting] |
| Faces corrupted / intermittently not visible | Network dropping packets, corrupting frames | Ensure constant network uptime; fix packet loss | [TT3:troubleshooting] |
| Inconsistent detection and recognition | Poor lighting; `Quality detection` = `High` at an angle where people will not face the camera; faces below `Minimum face size` | Fix lighting; lower the quality mode or re-aim the camera; get more pixels on each face | [TT3:fr-parameters] |

## Knowledge checks (facts the course tests)
- Not configuring the camera per the FR recommendations risks inaccurate face recognition results (not increased system speed, not higher maintenance costs). [TT3:camera-setup]
- Inconsistent face detection and recognition is caused by poor lighting, `Quality detection` set to `High` where people will not face the camera, and faces below the minimum face size threshold — all three contribute. [TT3:fr-parameters]
- Lower similarity thresholds can increase false positives (they do not reduce processing time or increase false negatives). [TT3:face-lists-and-face-matching]
- The similarity threshold is adjusted to balance false positives against false negatives — not for speed, database size, or detecting all faces regardless of quality. [TT3:summary]
- Higher-resolution images do not always guarantee better FR results; angle and lighting also play critical roles. [TT3:summary]
- When unsure about camera settings for FR, consult the face recognition guide for recommended camera specifications (not defaults blindly, not any camera). [TT3:summary]
- Enabling Privacy Protection does not stop analytics; they still function with Privacy Protection enabled. [TT3:summary]
- Face-target best practices: clear name, high-quality image, categorize into relevant lists. Using a generic name to save time is not a best practice. [TT3:summary]

## Lesson index
| # | Lesson (slug) | Min | Video | Topic |
|---|---|---|---|---|
| 1 | introduction | 1 | HubSpot 187171149617 | Module goals, FR use cases |
| 2 | considerations | 1 | HubSpot 187171236177 | 2 MP, frontal view, 6–8 ft mounting |
| 3 | camera-setup | 1 | HubSpot 187170371202 | `pencil icon` → `AI Engine` → `Face Recognition` → `FR` tab, ROI |
| 4 | fr-parameters | 2 | HubSpot 187171063434 | `Minimum face size`, `Similarity threshold`, `Quality detection` |
| 5 | save-settings--save-profile | 1 | HubSpot 187171308684 | Save profile, reuse on other cameras |
| 6 | face-lists-and-face-matching | 1 | HubSpot 187171236180 | Facial Recognition tab, lists, list color |
| 7 | face-target | 1 | HubSpot 187171069196 | Targets, five variants, required/optional fields |
| 8 | face-upload-quality-threshold | 1 | HubSpot 187171149614 | `System > Settings` upload threshold, default `Low` |
| 9 | dashboard | 1 | HubSpot 187171308681 | Real-time events, matched/unmatched, face search → target |
| 10 | history | 1 | HubSpot 187171236174 | 30-day forensic search, filters |
| 11 | privacy-protection | 1 | HubSpot 187171063437 | `Privacy Protection` toggle, per-scene unblur permission |
| 12 | alerts | 1 | HubSpot 187170331287 | Alert Rules by camera + list, `not in list` |
| 13 | troubleshooting | 1 | HubSpot 187170371205 | Object Search review, pixel/shutter/resolution/WDR/network |
| 14 | summary | 1 | HubSpot 187171149620 | Recap, 5-question check-in |

## Source notes
- Defaults not stated in the course: `Similarity threshold` value, `Quality detection` mode.
- The exact `Alert Type` dropdown value for FR is not named; the lesson describes "a new Alert Rule for Face Recognition" scoped by cameras and lists. [TT3:alerts]
- The summary quiz points to a "face recognition guide" for recommended camera specifications; that guide is outside the course and was not captured. [TT3:summary]
- The face-target lesson defers the "pull from detections" method to a later lesson; it is the Dashboard face-search → `person +` workflow. [TT3:face-target] [TT3:dashboard]
- The upload quality threshold is described only as the `Settings` tab under `System`; its exact field label is not given. [TT3:face-upload-quality-threshold]
- Course is complete (all 14 lessons captured); videos not transcribed.
