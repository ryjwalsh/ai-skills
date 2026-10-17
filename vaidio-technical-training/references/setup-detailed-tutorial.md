# Vaidio Setup Detailed Tutorial — Vaidio University TT2 "Vaidio Setup Detailed Tutorial"

> Source: Vaidio University (university.vaidio.ai) course TT2, 33 video-only lessons in 6 sections (Network Setup, License Management, Camera Setup, Intrusion Setup, Video Search, Alert Setup), captured 2026-10-17 from burned-in captions sampled every 2–3 s plus UI frame zooms (lessons 1–13 in a second pass the same day). Recorded on **Vaidio 7.2.0-1**; verify names against the deployed version. Full source table: ../sources.md.

## At a glance
The instructor-led version of TT1: put a workstation on the appliance's default subnet, set the server's network in the Admin Portal, export the `.info` file and apply the `.key` licence, add a camera by IP/ONVIF and by RTSP, trim the General ROI, add Intrusion Detection as the first analytic, use Video Search, and understand where alerts surface.

| Item | Value | Src |
|---|---|---|
| Factory default appliance IP | `192.168.100.100`; put the workstation on `192.168.100.2`–`255` (gateway `192.168.100.1`) to reach it | [TT2:network-setup-overview] [TT2:accessing-vaidio-through-windows] |
| Admin Portal | `http://<ip>:8000` — separate credentials (defaults in the user guide shipped with the server); `Network` → pick the interface that shows `192.168.100.100`, `Static Configuration` or DHCP → `Apply` | [TT2:admin-portal] |
| Licence flow | `System > License` → `Step 1` `Export` → `<serial>.info` → Support Portal ticket `Licensing/Warranty` → `.key` returned in the ticket → `Step 2` `Renew` → upload `.key` | [TT2:license-page-part-1] [TT2:support-portal] [TT2:license-page-part-2] |
| Licence facts | counts are per **channel** (one analytic on one camera stream); analytic licences float between cameras; the file is tied to one server; demo/trial licences expire (`License Expiration Date`) | [TT2:license-management-overview] [TT2:license-page-part-1] |
| Core web ports | `System > General`: `* HTTP Port` `80`, `* HTTPS Port` `443`, `Force Secure Connection (HTTPS)` | [TT2:license-page-part-1] |
| Post-login landing page | `Search` (`VAIDIO > Search`, magnifier at top of the icon rail) | [TT2:search-page] |
| Video Search coverage | automatically on for every object class of the camera's model (`PowerModel` default) — no engine needed | [TT2:video-search-overview] |
| Add camera by IP (ONVIF) | `Type` `Camera IP Address/Domain Name` → IP + web-UI port (typically `80`) + credentials → `Get RTSP` → first (max-resolution) stream → `Preview` → `OK` | [TT2:camera-page--ip-address-set-up] |
| Add camera by RTSP | `Type` `RTSP` → `rtsp://<ip>:<port, usually 554>/<vendor path>` + credentials → `Preview` → `OK`; test the URL in VLC first | [TT2:rtsp-set-up] |
| General ROI | blue quadrilateral on the still; drag corners to exclude areas; outside it every analytic ignores objects | [TT2:general-roi] |
| Intrusion rule defaults | `Sensitivity` `5` scenes `(1~20)` every `10` s `(1~30)`, `Dedupe Events` ON, `Cooldown Interval` `9` s `(1 ~ 3,600)` | [TT2:camera-popup-window] |
| Profile defaults | `Confidence[0.01 ~ 1.00]` `0.50` (`Suggested Value` `0.50`), `Minimum ~ Maximum pxl` `30` / `--` | [TT2:camera-popup-window] |
| Engine column codes seen | `ID`, `DD`, `MMR`, `OC`, `OWD`, `CD` | [TT2:video-search-overview] |

## Section 1 — Network Setup (lessons 1–7)
[TT2:network-setup-overview] [TT2:accessing-vaidio-through-windows] [TT2:accessing-vaidio-through-mac] [TT2:accessing-vaidio] [TT2:admin-portal] [TT2:network-setup-conclusion]
- The appliance must sit on the same network as the cameras: plug it into a switch from which every camera, NVR and VMS is reachable. Out of the box it answers at `192.168.100.100`.
- **Windows workstation on the default subnet:** connect to the same network or cable the PC directly to the server → `Control Panel > Network and Internet > Network Connections` → wired adapter → `Properties` → `Internet Protocol Version 4 (TCP/IPv4)` → `Properties` → `Use the following IP address:` any `192.168.100.2`–`255` (demo `192.168.100.10`, `Subnet mask` `255.255.255.0`), `Default gateway:` `192.168.100.1` (demo DNS `8.8.8.8`) → `OK`.
- **Mac:** `System Settings > Network` → the wired service (demo `Thunderbolt Bridge`) → `Details...` → `TCP/IP` → `Configure IPv4` `Manually` → `IP address` `192.168.100.10` (any unused `192.168.100.x`) → `Router` `192.168.100.1` → `OK`.
- Browsers named: Google Chrome, Microsoft Edge, Safari. Enter `192.168.100.100` → Vaidio login page (`User Account`, `Password`, `Login`, `Version: 7.2.0-1`, `Forgot password?`).
- **Admin Portal** (`http://192.168.100.100:8000`, heading `Admin Portal`, fields `Account` / `Password`): credentials are separate from the main UI — defaults are in the user guide that ships with the server. Landing page `/system/` has `admin` + `Logout`, a lock icon, `Shutdown`, `Restart`, then sections `Change Password` (changes only the Admin Portal password; strong password strongly encouraged), `Port Configuration` (`Port Number:` default `8000`), `Time` (`Time Zone:`, `System Time:`, `Sync with NTP Server`, NTP host list with `pool.ntp.org`, `Synchronize the system time regularly`, `Check Connection`), `Network`, `Upgrade` (see setup-overview-demo.md).
- `Network`: select the `Interface:` — try interfaces one at a time; only the one wired to the port in use shows the `192.168.100.100` address (demo `enp3s0`, shows `MAC Address:`). `Mode:` `Static Configuration` (set `* IPv4 Address`, `* Netmask`, `Gateway`, `DNS Server`; demo `192.168.100.105` / `255.255.255.0` / `192.168.100.1` / `8.8.8.8`) or DHCP (address assigned dynamically — you then need a tool to locate the server). Click the green `Apply`.
- Afterwards put the workstation back on its original IP configuration.

## Section 2 — License Management (lessons 8–13)
[TT2:license-management-instructor-introduction] [TT2:license-management-overview] [TT2:license-page-part-1] [TT2:support-portal] [TT2:license-page-part-2] [TT2:license-management-conclusion]
- Optional section for self-sourced hardware or instances: the server must be licensed by IronYun before analytics run. Three steps: export the `.info` file → send it to IronYun through the Support Portal → apply the returned `.key` file.
- Licensing dictates which analytics the server can run and how many of each; one instance of one analytic on one camera stream = one **channel**. Analytic licences are floating (move between cameras); the licence file is tied to one Vaidio server; trial/demo licences expire; each server's serial number prefixes its `.info` filename.
- Expanded main menu (7.2): **AI Analytics** — `Search`, `Face Recognition`, `License Plate Recognition`, `Identity Verification`, `People Counting`, `Vehicle Counting`, `Object Counting`, `Intrusion`, `Abnormal`, `Alert`, `Live View`, `Statistics`; **Management** — `File`, `Camera`, `NVR`, `User`, `System`.
- `System` tabs: `General` | `Time` | `Storage` | `Mail` | `Authentication` | `Log` | `Audit Trail` | `License` | `Setting` | `AI Model` | `Utility`; `Restart` top-right. `General` holds `Web Service Port Configuration` (`* HTTP Port` `80`, `* HTTPS Port` `443`, `Force Secure Connection (HTTPS)`, `Apply`) and `Restore` (`Restore`, `Export Configuration`).
- `System > License` layout: left `License Management` — `Model Name` (demo `VSB-560`), `Build Number`, `Serial Number`, `Analytic Resource` (demo `128`), `Footage`, `User`, `Status` (`Active`), `License Expiration Date` (`-` when perpetual), `Warranty & Maintenance Expiration Date`; `Step 1:` `Export` (download the system-information file and send it to customer support) and `Step 2:` `Renew` (upload and activate the new key). Right `AI Engines` block lists licensed channels per analytic (demo: `Age & Gender`, `Cross Camera Tracking`, `Crowd`, `Face Recognition` with `FR Type: AI FR`, `Fire & Smoke`, `Identity Verification`, `Intrusion`, `License Plate Recognition` with `Country: USA` / `LPR Type: LPR PRO`, `Make Model Recognition`, `Object Tracking`, `Object Left Behind`, `People Tracking`, `Person Fall`, `Personal Protective Equipment`, `Scene Change`, `Specialized Object`, `Vehicle Tracking`, `Video Search`, `Weapon`) plus a `Recorder` block (`Internal Video Recorder`).
- Export: `Export` → the browser downloads `<serial number>….info` (Downloads folder by default).
- **Support Portal** (IronYun; URL not shown in the video — login page points to `iyu.thinkific.com > Support` for login questions; `Sign in with Microsoft` / `Google` / `Sign in` / `Sign up`): home tiles `Submit a ticket`, `Look up a ticket`, `View a project`; categories `Internal Questions/Issues`, `Troubleshooting`, `Analytic Setup`, `Feature Requests`, `Licensing/Warranty`, `Quote / Project`, `Miscellaneous`, `Request Access`. `Licensing/Warranty` tickets: `Demo License Request (New/Renew)`, `Permanent License Request or Warranty Extension`, `Licensing Question`, `Salient License Generator Access Request`.
- Demo licence request form (`Demo License`): `New or Renewing Demo License *`; `Core or Edge Software *` (e.g. `Core (x86)`); for non-IronYun hardware `Hardware CPU(s) *`, `Hardware GPU(s) *`, `Hardware RAM *` (examples `i5-10400 with 6 cores`, `Nvidia RTX A4000`, `16GB`) — accuracy matters because it sizes what the machine can run; `License .info file *` (`+ Attach`); `Analytics *` checkboxes (`Video Search`, `Intrusion`, `Face Search & Recognition`, `License Plate Recognition`, `Object Left Behind`, `PPE`, `Make & Model Recognition`, `Cross Camera Tracking`, `Fire Detection (Includes Intrusion)`, `Age & Gender`, `Crowd Detection`, `Object Counting`, `Person Fall`, `Specialized Object Detection/ Weapons Detection (Includes Intrusion)`); `End User / Project Name`; `Sales Rep *`; free-text questions → `Submit`. The `.key` (same serial, extension `.key`) comes back inside the ticket.
- Apply: `System > License` → `Step 2:` `Renew` → upload the `.key`; the page then shows the licensed counts and, for trials, the expiry date.

## Section 3 — Camera Setup (lessons 14–19)
### Camera page layout
[TT2:camera-page--ip-address-set-up]
- Reach it from the camera icon in the left icon rail, or expand the rail (hamburger ≡) for labelled entries; the bottom of the expanded menu shows `NVR`, `User`, `System`.
- Filter bar `Cluster: All`, `AI Engines: All`, `Actions: All`, `Group: All`, `Camera Name`, `Search` (+ export icon), lightning-bolt button; buttons `Add Camera`, `Auto Discovery`, `Group`; `Columns` picker; pager.
- Columns: checkbox, `No.`, `Camera Name` (thumbnail), `Resolution`, `Group`, `AI Engines`, `Status`, `Abnormal Check` (calendar + history icons per row), `Actions` (on/off toggle, `...` menu); header has bulk delete and export/move icons. Empty table reads `No matching records found`.

### Add a camera by IP address / ONVIF
[TT2:camera-page--ip-address-set-up]
1. `Add Camera` → dialog sections `Camera Info` (`* Camera Name`, `Cluster` default `localhost`, `Group`, `Location Type` default `None`, `Description`, `Activate` \| `Deactivate`), `Camera URL`, `NVR` (`Internal Video Recorder`, `NVR`, `Channel ID`), right pane `Advanced` (`AI Model` `1 selected`, `AI Engines` `Select AI Engines`, gear → `Profile : Default`, tab `General ROI` with pencil/refresh, `Resolution: 0x0 pixel`, `Preview`).
2. `Camera URL > Type` = `Camera IP Address/Domain Name` (default). Enter `* IP/ Domain Name` and the port — the camera's **web-UI port, typically `80`**. Works when the camera (or its user profile) is ONVIF-compliant.
3. Enter `User Name` / `Password`.
4. `Get RTSP` → Vaidio queries the camera over ONVIF and fills the dropdown with its RTSP streams: first entry = main stream at maximum resolution, others = sub-streams. Demo result (Dahua-style): `rtsp://admin:<password>@192.168.100.233:554/cam/realmonitor?channel=1&subtype=0&unicast=true&proto=Onvif` (second entry `subtype=1` [inferred]).
5. Pick the main stream → `Preview` → still image + `Resolution: 1920x1080 pixel`; `FPS` auto-fills (`Estimated` / `30`). The still is what ROIs are drawn on.
6. `OK` → toasts `Activate Success`, `Update successful.`; row shows `Connected`. These are the minimum steps for basic object detection.

### Add a camera by RTSP
[TT2:rtsp-set-up]
- Use when the source is not ONVIF (streaming server, NVR/appliance re-stream). Uses the RTSP port, usually `554`.
1. `Camera URL > Type` = `RTSP` → the IP/port row becomes a single `* RTSP` field; `Get RTSP` disappears; `User Name`, `Password`, `FPS`, `TCP/UDP` (`Both`), `Detail Extraction` (`Standard`) remain.
2. URL format: `rtsp://` + IP + `:` + port (confirm with the stream's provider) + `/` + provider path; formats vary by brand/appliance — the "Technical Support User Guide" lists common brands' paths. Demo: `rtsp://192.168.100.232:8554/cam/realmonitor?channel=1&subtype=0&unicast=true&proto=Onvif` (non-default port 8554).
3. Put credentials in the `User Name` / `Password` fields rather than in the URL.
4. Verify first in VLC: `Media > Open Network Stream` → `Network` tab → `Please enter a network URL:` → `Play`. If VLC plays it from a PC that can reach the camera, the syntax is right.
5. `Preview` → `Resolution:` (demo `2048x1536 pixel`), `FPS` `Estimated` / `25` → `OK`.

### General ROI
[TT2:general-roi]
- Shown in `Edit Camera` (same layout as Add; `Cluster` read-only once the camera exists).
- After a successful preview a blue box spans the four corners of the image in `Advanced > General ROI`. It defines where Vaidio looks for objects; full frame is fine. Drag corners to exclude false-detection sources (example: a tree line); the ROI becomes an arbitrary quadrilateral. Everything outside it is ignored by all analytics on that camera.
- Tab tools: pencil (edit), circular arrow (reset), `Resolution` readout, `Preview`, flip horizontal/vertical.

## Section 4 — Intrusion Setup (lessons 20–24)
### Vocabulary
[TT2:intrusion-setup-overview]
- `AI Model` = the detector, selected per camera (`AI Model :` → `1 selected`), supports detection of many object classes.
- `AI Engines` = analytics applied to detected objects for a use case (`Intrusion`, `Counting`, …). "AI Engine" ≡ "AI Analytic" ≡ "analytic". Workflow: choose the Model, then one or more Engines.

### Add Intrusion to a camera (Edit Camera > Advanced)
[TT2:camera-popup-window]
1. `AI Model :` → open to confirm the default `PowerModel-…` is checked (contains the most-requested object types).
2. Gear icon → `Profile` window: `Profile List` button, selector `Default`; tabs `Object Type` \| `VS`; thumbnail with `Resolution : 1,920 X 1,080 pxl`; table `Object Type` (checkbox per class) · `Confidence[0.01 ~ 1.00]` (slider + box, default `0.50`) · `Suggested Value` (`0.50`) · `Minimum ~ Maximum pxl` (`30` / `--`) · copy icon; `Cancel` / `Save`. Classes seen: `Backpack`, `Bag`, `Bicycle` ✓, `Bird`, `Bus` ✓, `Car` ✓, `Cow`, `Head` ✓, `Tricycle`, `Wild_animal`. Checked rows = classes detected for this camera/profile.
3. `AI Engines :` dropdown lists every engine in the licence file with checkboxes (seen: `Age & Gender`, `Crowd`, `Dwell`, `Illegal Parking`, `Intrusion`, `Loitering`, `Make Model Recognition`, …). Tick `Intrusion` → `1 selected`; tab `ID` (with ×) appears beside `General ROI`.
4. `ID` tab → pencil → click to drop vertices (any polygon; demo 4-point corridor), drag to adjust; toolbar ⊘ / copy / green ✓ while editing → ✓ to confirm. Region appears in the table (`No.`, `Name`, trash).
5. Wrench on the region row → rule panel: `Name` (unique; demo `Intrusion Test`); `Object Type` ⓘ icons (vehicle, person, animal, fire/drop, warning) + `AND` \| `OR`; chips for chosen classes (`Person ×`); `Schedule` (calendar); `Sensitivity` `Detect 5 (1~20) scene(s) with defined object every 10 (1~30) second(s)`; `Dedupe Events` ⓘ ON; `Cooldown Interval` ⓘ `9 second(s)` `1 ~ 3,600 seconds`; `Save`.
6. `Save` (panel) → `OK` (dialog) → `Activate Success`. Camera row now shows `ID` under `AI Engines`; region row shows wrench, enable toggle, trash.
Meaning: a Person inside the region for the defined window generates an event notification.

### Intrusion results page
[TT2:intrusion-tab]
- `VAIDIO > Intrusion` (running-person icon, 4th analytic icon in the rail, or by name in the expanded rail). Tabs `Dashboard` \| `History`.
- `Dashboard`: intrusion icon, camera icon, `Select Camera`, refresh; live video of the selected camera; right column of real-time event cards (thumbnail with red ROI + green box, timestamp, camera, rule name).
- `Select Camera` → `Intrusion List` dialog: preview pane; filters `Cluster All`, `Camera Name`, `Search...`; `Clear Selection`; `0 of 1 selected`; table `Camera Name` (expandable row `IP Camera (1)` — count = ROIs) and `Group Name`; `OK`. Expand a row to pick specific ROIs.
- `History`: rule/ROI picker (tooltip shows rule name), date range with time spinners, `Search`, export icon, result count, trash + pager, cards with checkbox for bulk delete/export; toast `Search successful.`

## Section 5 — Video Search (lessons 25–29)
[TT2:video-search-overview] [TT2:search-page] [TT2:narrowing-searches]
- Forensic tool: sifts large volumes of video in seconds; runs on every connected camera; the Model recognises objects, Engines are use-case logic on top (Intrusion for people, Vehicle Counting, Dwell Time).
- Camera page on this server shows an extra column `AI Model Enabled` (`PowerModel-Core-7…`) and `Group` `EarthCam` public demo cameras.
- `Search` toolbar: camera picker, report/list icon, start date + time `~` end date + time, `Search`, snapshot icon; right: save (floppy), list view, share/export. Second row: `Advanced`, then category icons vehicle / person / animal (paw) / fire-liquid (drop) / warning / tag.
- No filters → every recognised object since midnight (demo `387,444 results in 1.8 second.`); header shows `Retention Time:<from> ~ <to>` = searchable window; pager and grid / map-pin / layout toggles; toast `Search successful.`
- Scene window `Original Snapshot | Scene ID : <id>`: timestamp, camera, `<` `>` scene stepping; toolbar: bounding-box toggle, object-detail/search-similar magnifier, tag, download, crop/zoom icons, map, more; right group: snapshot view, play clip, location pin, full frame. Bounding-box toggle opens a crop strip labelled by class; selecting a crop shows `Object Type:`, `Confidence:`, `Color:`, `Width:` / `Height:` (px) and attribute columns `Age:`, `Gender:`, `FR List:`, `Name:`, `Emotion:`, `Make:`, `Model:`, `LPR List:`, `License Plate:`, `Speed:`, `Mask:`, `PPE:` (`-` when the engine is off).
- Narrowing: `Select Camera` → `Camera List` dialog (`Camera Name` filter, `Search...`, list/preview toggles, `Select All`, `83 of 83 selected`, columns `Camera Name` / `Group Name`, `OK`); date/time calendar picker; object menus under each icon (person icon → `More` header with `Backpack`, `Bag`, `Cell_phone`, `Luggage`, `Major_scene_change`, `Minor_scene_change`, `person_in_blue_uniform`, `person_without_uniform`, `Stroller`, `Umbrella`, each with `>` attributes) producing chips (`Person ×`, `Backpack ×`); demo person-with-backpack over two days: `1,927,606 results in 2.3 second.` → `4,485 results in 4.2 second.` after camera/ROI narrowing.
- `Save Filter` (floppy icon) → dialog `* Name :` → `OK`; reload from the adjacent list icon [inferred].
- `Camera ROI` search: in `Camera List` pick one camera (radio), switch to preview view (refresh icon reloads the snapshot), click `Camera ROI`, draw a polygon, `OK` → only objects inside the region are returned (e.g. a sidewalk vs the road).

## Section 6 — Alert Setup (lessons 30–33)
[TT2:alert-setup-instructor-introduction] [TT2:alert-setup-overview] [TT2:alert-dashboard-tab]
- Alerts can be created from **any** analytic event configuration; they are real-time indicators sent to email, text (SMS), apps and third-party systems (examples: signal on a face detection; email on an intruder).
- `VAIDIO > Alert`, tabs `Dashboard` \| `History` \| `Alert Rule`. `Dashboard` default view = bell filter + world map (`+`/`−`, `1000 km / 500 mi` scale) with list / map-pin / layout toggles; empty state `No matching records found`; refresh top-right.
- If a camera has an indoor map or outdoor GPS coordinates, the Dashboard also places the alert on the map.
- Rule creation (`Alert Rule` tab, delivery channels) is explicitly deferred to other courses — not shown here; see setup-overview-demo.md (`Add Alert` dialog) and the per-analytic references.

## Knowledge checks (facts the course tests)
- The appliance's default IP address is `192.168.100.100`. [TT2:network-setup-conclusion]
- First-time server/camera connectivity is established by changing the network settings in the Admin Portal, reached through the Vaidio IP address. [TT2:network-setup-conclusion]
- Changing the default admin password adds security (True). [TT2:network-setup-conclusion]
- The two IP-assignment options are Static IP and DHCP. [TT2:network-setup-conclusion]
- Licensing dictates which analytics the server can run and how many. [TT2:license-management-conclusion]
- One instance of one analytic is a "channel". [TT2:license-management-conclusion]
- The licence file is tied to a specific Vaidio server (e.g. a VSB-130). [TT2:license-management-conclusion]
- After exporting the `.info` file, the licence is obtained by submitting a Support Ticket on IronYun's Support Portal. [TT2:license-management-conclusion]
- Purchased analytic licences and their expiry date are viewed under `System > License`. [TT2:license-management-conclusion]
- Lessons 14–33 have no check-in questions.

## Lesson index
| # | Lesson (slug) | Min | Video | Topic |
|---|---|---|---|---|
| 1 | network-setup-instructor-introduction | 1 | mp4 `Network Setup/Network setup - Instructor intro.mp4` (10 s) | Section 1 intro |
| 2 | network-setup-overview | 1 | mp4 `Network Setup/Network Setup - Overview.mp4` (31 s) | Same network as cameras; default IP |
| 3 | accessing-vaidio-through-windows | 1 | mp4 `Network Setup/Network Setup - Accessing Vaidio through Windows.mp4` (41 s) | Windows static IP |
| 4 | accessing-vaidio-through-mac | 1 | mp4 `Network Setup/Network setup - Accessing vaidio thru mac.mp4` (52 s) | macOS static IP |
| 5 | accessing-vaidio | 1 | mp4 `Network Setup/Network Setup - Accessing Vaidio.mp4` (22 s) | Browsers, login page |
| 6 | admin-portal | 2 | mp4 `Network Setup/Network Setup - Admin Portal.mp4` (92 s) | Admin Portal sections, interface/mode |
| 7 | network-setup-conclusion | 1 | mp4 `Network Setup/Network Setup - Conclusion.mp4` (10 s) | Recap; 4 check-ins |
| 8 | license-management-instructor-introduction | 1 | mp4 `License Management/License Management - Instructor Introduction.mp4` (51 s) | Three licence steps |
| 9 | license-management-overview | 1 | mp4 `License Management/License Management - Overview.mp4` (18 s) | Channels |
| 10 | license-page-part-1 | 2 | mp4 `License Management/License Management - License Page.mp4` (112 s) | `System > License`, `Export` `.info` |
| 11 | support-portal | 2 | mp4 `License Management/License Management - Support Portal.mp4` (96 s) | Support Portal ticket, demo licence form |
| 12 | license-page-part-2 | 1 | mp4 `License Management/License Management - License Page 2.mp4` (24 s) | `Renew` → upload `.key` |
| 13 | license-management-conclusion | 1 | mp4 `License Management/License Management - Conclusion.mp4` (9 s) | Recap; 5 check-ins |
| 14 | camera-setup-instructor-introduction | 1 | mp4 `Camera Setup/Camera Setup - Instructor Introduction.mp4` (17 s) | Section 3 intro; login page shows `Version: 7.2.0-1` |
| 15 | camera-setup-overview | 1 | mp4 `Camera Setup/Camera Setup - Overview.mp4` (20 s) | Framing; Object Counting dashboard shown |
| 16 | camera-page--ip-address-set-up | 2 | mp4 `Camera Setup/Camera Setup - Camera Page & IP Address Set Up.mp4` (123 s) | Camera page, ONVIF add |
| 17 | rtsp-set-up | 2 | mp4 `Camera Setup/Camera Setup - RTSP Set Up.mp4` (90 s) | RTSP add, VLC test |
| 18 | general-roi | 1 | mp4 `Camera Setup/Camera Setup - General ROI.mp4` (26 s) | General ROI |
| 19 | camera-setup-conclusion | 1 | mp4 `Camera Setup/Camera Setup - Conclusion.mp4` (11 s) | Recap |
| 20 | intrusion-setup-instructor-introduction | 1 | mp4 `Intrusion Setup/Intrusion Setup - Instructor Introduction.mp4` (13 s) | Section 4 intro |
| 21 | intrusion-setup-overview | 1 | mp4 `Intrusion Setup/Intrusion Setup - Overview.mp4` (38 s) | Model vs Engine |
| 22 | camera-popup-window | 2 | mp4 `Intrusion Setup/Intrusion Setup - Camera Popup Window.mp4` (98 s) | Profile dialog, `ID` tab, rule panel |
| 23 | intrusion-tab | 1 | mp4 `Intrusion Setup/Intrusion Setup - Intrusion Tab.mp4` (35 s) | Intrusion Dashboard / History |
| 24 | intrusion-setup-conclusion | 1 | mp4 `Intrusion Setup/Intrusion Setup - Conclusion.mp4` (15 s) | Recap |
| 25 | video-search-instructor-introduction | 1 | mp4 `Video Search/Video Search - Instructor Introduction.mp4` (11 s) | Section 5 intro |
| 26 | video-search-overview | 1 | mp4 `Video Search/Video Search - Overview.mp4` (37 s) | Search on for all model classes |
| 27 | search-page | 2 | mp4 `Video Search/Video Search - Search Page.mp4` (81 s) | Search toolbar, scene window |
| 28 | narrowing-searches | 2 | mp4 `Video Search/Video Search - Narrowing Searches.mp4` (74 s) | Camera, time, object, ROI, saved filters |
| 29 | video-search-conclusion | 1 | mp4 `Video Search/Video Search - Conclusion.mp4` (17 s) | Recap |
| 30 | alert-setup-instructor-introduction | 1 | mp4 `Alert Setup/Alert Setup - Instructor Introduction.mp4` (13 s) | Section 6 intro |
| 31 | alert-setup-overview | 1 | mp4 `Alert Setup/Alert Setup - Overview.mp4` (21 s) | What alerts are |
| 32 | alert-dashboard-tab | 1 | mp4 `Alert Setup/Alert Setup - Alert Dashboard Tab.mp4` (16 s) | Map dashboard |
| 33 | alert-setup-conclusion | 1 | mp4 `Alert Setup/Alert Setup - Conclusion.mp4` (18 s) | Recap |

## Source notes
- The Support Portal URL is never shown or spoken in lesson 11 (browser chrome cropped); the sibling `vaidio` skill records it as vaidio.myportallogin.com (register at vaidio.ai/support). The login page's reference to `iyu.thinkific.com` is the older IronYun University host.
- Three channel counts on the demo licence page were low-resolution reads (`Specialized Object`, `Video Search`, `Internal Video Recorder`) and are omitted above.
- Admin Portal default credentials are deferred to "the user guide that came with the server"; the sibling `vaidio` skill's quick facts list the documented defaults.
- Lesson 17 shows an alternate `Add Camera` layout without the `Cluster` row and with flip icons next to `Preview`; lesson 16 shows `Cluster` (default `localhost`). Both were recorded on 7.2.0-1 — the dialog varies by server build.
- "Technical Support User Guide" (RTSP paths per brand) is the vendor PDF indexed as S3 in `vaidio/sources.md`.
- Section 6 never shows the `Alert Rule` tab contents; the `Add Alert` dialog is documented from TT1 instead.
