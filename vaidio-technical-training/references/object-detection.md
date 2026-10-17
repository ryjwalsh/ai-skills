# Object Detection — Vaidio University TT13 "Object Detection"

> Source: Vaidio University (university.vaidio.ai) course TT13, 10 lessons, captured 2026-10-17. Written-lesson content plus check-in questions; embedded videos were not transcribed except where noted. UI names reflect the Vaidio 7.x–9.x web UI shown in the course — verify against the deployed version. Full source table: ../sources.md.

## At a glance
Object Detection is the core foundation of all Vaidio analytics — the baseline recognition that powers every other analytic and the search function. It is **always on**: enabled automatically when a camera is added, never selected from the `AI Engine` list, and running from the first time `OK` is pressed on the camera page. Tuning happens through the camera's General ROI and the `Profile` (object types, confidence, size, motion settings); results are consumed through the Search tab and the Heatmap. Course outcome: get Object Detection running on a camera and apply/adjust it to specific use cases. [TT13:introduction] [TT13:analytic-setup] [TT13:summary]

| Item | Value | Src |
|---|---|---|
| `AI Engine` selection | none — enabled automatically with the camera | [TT13:analytic-setup] |
| Tuning surfaces | General ROI (`pencil icon`); `Profile` button (`Gear icon`, top right of camera edit window) | [TT13:analytic-setup] [TT13:profile] |
| Default object types | `Power Model` types only on a default install | [TT13:profile] |
| `Confidence` | scale of roughly 0 to 1; default value not stated ("leaving the default is typically fine") | [TT13:profile] |
| `Minimum` object size | 30 (px, width and height); can be lowered to 10; `Maximum` not set by default | [TT13:profile] |
| Minimum target size on camera | 30x30 pixels, fully visible | [TT13:considerations] |
| Minimum camera resolution | 2 megapixels (1920x1080), imported at 2MP minimum | [TT13:troubleshooting] |
| Network | cameras on the same network as Vaidio; steady connection | [TT13:considerations] [TT13:troubleshooting] |
| Results | Search tab (scenes, object size/confidence, ROI search); `Heatmap` on the statistics tab | [TT13:search-tab-review] [TT13:heatmap] |
| Alerts | possible, but purpose-built analytics are recommended for alerting | [TT13:alerts] |

## Camera and scene requirements
[TT13:considerations] [TT13:troubleshooting]
- Cameras must be on the **same network as Vaidio**.
- Objects to detect must be fully visible to the camera and appear at `30x30 pixels` or larger.
- Camera capable of, and imported into Vaidio at, 2MP (1920x1080) minimum; lower import resolution gives poor detection.
- Steady network connection — an unsteady one causes intermittent detection and affects every other analytic.

## Setup procedure
**Enablement and General ROI** [TT13:analytic-setup]
1. Object Detection is enabled automatically when a camera is added; it is never selected from the `AI Engine` list. It runs from the first time `OK` is pressed on the camera page, because it underpins every analytic and search function.
2. Tune the **General Region of Interest** (General ROI): move or redraw it (via the `pencil icon`) to exclude areas where relevant objects never appear — sky, treeline, etc.
3. **All analytics use the General ROI**, so any redraw must work for every analytic and use case on that camera.

**Profile — tab 1 `Object Type`** [TT13:profile]
4. Open the `Profile` with the `Profile` button (`Gear icon`) at the top right of the camera edit window.
5. Check/uncheck the object types the camera should find. Default install: only the `Power Model` object types are offered. Example: tick `Cow` → after saving, the camera looks for cows.
6. Set `Confidence` and the `Minimum` / `Maximum` object size (table below).

**Profile — tab 2 (motion / still-object settings)** [TT13:profile]
7. The lesson heading calls this tab `Profile Settings - VS`; the body text calls it the `OD` tab (source inconsistency). Three options: `Include Still Object`, `Motion Detection Minimum Object Size`, `Motion Detection Sensitivity` (table below).

**Save and reuse the profile** [TT13:profile]
8. Click `save` at the bottom of the popup → a dialog asks for a **profile name** → save → press save one final time to assign the profile to the current camera.
9. Reuse: on another camera open the profile window, pick the profile from the `profile dropdown list`, press save. The same process can apply the analytic profile to **multiple cameras at the same time**.

## Parameters
| Parameter | Default | Range / options | Effect of raising | Effect of lowering | Src |
|---|---|---|---|---|---|
| Object types (`Object Type` tab) | `Power Model` types available; wanted types must be ticked | check / uncheck per type | — | Unticked types are never found (bags, backpacks, dogs, etc.) | [TT13:profile] [TT13:troubleshooting] |
| `Confidence` — how sure the AI must be before recording a found object | not stated; leaving the default is typically fine | roughly 0 to 1 | More certainty required; may ignore true detections (fewer true positives); fixes AI mistaking one object for another | More objects found but more false positives; fixes AI failing to recognize an object. Does not affect speed | [TT13:profile] [TT13:troubleshooting] |
| `Minimum` object size | 30 = minimum width and height in pixels | lowerable to 10 — objects whose width and height exceed 10 px become searchable | Smaller objects excluded | Smaller objects searched for (10 px floor) | [TT13:profile] |
| `Maximum` object size | not set by default | px | Useful when only certain object sizes matter | — | [TT13:profile] |
| `Include Still Object` | not stated; lesson advises leaving it disabled | enabled / disabled | Enabled: stationary objects such as parked cars constantly generate new events | Disabled: trims duplicate results | [TT13:profile] |
| `Motion Detection Minimum Object Size` | not stated | px | Motion smaller than this in both width and height is not reported in a search | — | [TT13:profile] |
| `Motion Detection Sensitivity` | not stated; normally leave alone | — | Sensitivity to small motion changes; adjust only for edge cases such as a person hundreds of feet away or a small fire in a large field | — | [TT13:profile] |

## Dashboard, history and search
**Search tab** [TT13:search-tab-review]
- Object Detection powers the Vaidio **search engine** (Search tab).
- Basic inputs: choose **cameras**, choose which **files** to include, set **time and date down to the minute**, pick **object types**.
- After selecting a scene: detail options show scene details; each detected object can be examined for **size** and **confidence**; an **ROI search** can be run inside the scene to narrow to specific elements.
- Advanced features such as color and quantity allow more complex queries that refine results.

**Object-type icon groups and other search features** [TT13:other-search-features]

| Icon / feature | Contents |
|---|---|
| Car icon | car, truck, motorcycle, or the generic `vehicle` which selects all of them |
| Person icon | head and person types |
| Paw icon | common animals |
| "Teardrop" icon | simple object types such as backpack and bag |
| Warning icon | "dangerous" objects, e.g. handguns or fire |
| Hashtag search | alphanumeric tags — applied by the user to a scene for later retrieval, or sent by third-party devices/applications for enhanced detections such as **vaping** or **gunshots** |
| Quantity / color | searches can specify a number of objects and object colors |

- Scene-level icons: **hashtag** adds searchable phrases to a scene; the **arrow icon** saves the scene as a `.jpg` to your computer; the next icon belongs to **Cross Camera Tracking** (covered in that module).

**Heatmap** [TT13:heatmap]
- `Heatmap` function lives on the **statistics tab**.
- Visualizes Object Detection data for **all objects or specific objects**, aggregated **hourly or daily**.

## Alerts
[TT13:alerts]
- Object Detection can be used as an alert condition, but Vaidio generally recommends the other, purpose-built analytics for alerting; their modules cover alert setup in depth.

## Troubleshooting
| Symptom | Cause | Fix | Src |
|---|---|---|---|
| Wanted objects (bags, backpacks, dogs, etc.) never found | Object type not enabled | Verify the object types are turned on in the Camera Profile (`Object Type` tab) | [TT13:troubleshooting] |
| AI fails to recognize an object | `Confidence` too high | Lower the confidence | [TT13:troubleshooting] |
| AI mistakes one object for another | `Confidence` too low | Raise the confidence | [TT13:troubleshooting] |
| Poor detection overall (camera resolution) | Camera below 2 megapixels (1920x1080), or imported at a lower resolution | Camera must be capable of, and imported into Vaidio at, 2MP minimum | [TT13:troubleshooting] |
| Intermittent detection (network) | Unsteady network connection | Ensure a steady connection — affects object detection and every other analytic | [TT13:troubleshooting] |
| Parked cars etc. flood results with new events | `Include Still Object` enabled | Leave it disabled to trim duplicate results | [TT13:profile] |

## Knowledge checks (facts the course tests)
- Object Detection acts as the foundational layer for all other analytics and search functions (not standalone, not motion-only, not alerts-only). [TT13:introduction]
- Lowering the confidence value can increase the likelihood of false positives; the confidence value does not affect speed, and raising it does not guarantee more detections. [TT13:profile]
- Advanced search features such as color and quantity allow more complex queries that refine search results (not dangerous-object-only, not automatic alert generation). [TT13:search-tab-review]
- Minimum pixel size for Object Detection is 30x30 pixels (options: 5x5 / 10x10 / 30x30 / 50x50). [TT13:summary]
- In the `VS` tab of the Profile settings, enabling `Include Still Object` allows static objects to generate new events (the quiz names the tab `VS`, matching the lesson heading, not the body text's `OD`). [TT13:summary]
- Network connection, camera resolution and confidence value are all crucial for effective detection ("All of the above"). [TT13:summary]
- Confidence set too high means fewer true positives may be detected. [TT13:summary]
- All wanted objects are enabled in the Camera Profile to ensure the AI recognizes and tracks these objects. [TT13:summary]

## Lesson index
| # | Lesson (slug) | Min | Video | Topic |
|---|---|---|---|---|
| 1 | introduction | 1 | HubSpot 187431155592 | Foundation analytic; 1 check-in |
| 2 | considerations | 1 | HubSpot 187428306461 | Same network, 30x30 px |
| 3 | analytic-setup | 1 | HubSpot 187428540323 | Auto-enabled, General ROI |
| 4 | profile | 3 | HubSpot 187428306464 | `Object Type`, confidence, min/max size, VS/OD tab, save/reuse; 1 check-in |
| 5 | search-tab-review | 1 | HubSpot 187431169711 | Search inputs, scene details, ROI search; 1 check-in |
| 6 | other-search-features | 1 | HubSpot 187429107231 | Icon groups, hashtags, quantity/color, .jpg save |
| 7 | heatmap | 1 | HubSpot 187431155589 | Statistics tab, hourly/daily |
| 8 | alerts | 1 | HubSpot 187429107228 | Prefer purpose-built analytics |
| 9 | troubleshooting | 1 | HubSpot 187428540320 | Object types, confidence, resolution, network |
| 10 | summary | 1 | HubSpot 187429096231 | Recap; 5 check-ins |

## Source notes
- Profile tab 2 naming is inconsistent in the source: the lesson heading says `Profile Settings - VS`, the body text calls it the `OD` tab, and the summary quiz calls it the `VS` tab.
- The considerations lesson gives the 30x30 px minimum but no resolution; the 2 MP (1920x1080) minimum appears only in the troubleshooting lesson.
- Default values for `Confidence`, `Include Still Object`, `Motion Detection Minimum Object Size` and `Motion Detection Sensitivity` are not stated; `Minimum` size is the only stated default (30).
- The default model is written `Power Model` here and `PowerModel` in TT9 [TT9:analytics-setup].
- Cross Camera Tracking is deferred to its own module; alert setup is deferred to the purpose-built analytic modules.
- The final troubleshooting row is derived from the profile lesson's guidance, as cited.
