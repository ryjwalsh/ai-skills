# Operator tasks

Source: Security Center SaaS User Guide. [S9]

## The task list

| Task | What operators do there |
|---|---|
| **Tiles** | Live and playback video, intelligent search, video and access-control actions |
| **Maps** | Monitor entities, their video and events, and issue commands from a map |
| **Access control** | Cardholders, visitors, credentials, cardholder groups, access rules |
| **Investigation** | Natural-language and filtered search for events of interest |
| **Front desk** | Set work location, view the visit schedule, review the visitor list and statuses, check in planned and walk-in visitors, run security screening |
| **Reports** | Alarms, Bookmarks, Camera events, Door activity, Forensic, and **Anything** (all categories at once, with exceptions) |

Additional operator features - dashboards, people counting, activity trails, full PTZ configuration and several report tasks - exist only in **Genetec Operation desktop**.

## Tiles

- **Change tile pattern** picks the layout.
- Browse for an entity or layout and **double-click or drag it into a tile**. **Only cameras, doors and federated virtual zones are supported** - anything else leaves the tile empty.
- Hover a tile for camera controls; right-click for entity controls.
- Clear a tile by right-clicking > **Clear**, or select it and press **Backspace**. **Ctrl+Backspace** empties every tile.
- Tile overlay content is set at **Options > Tiles > Tile overlay**.
- **Bookmarks**: click the bookmark button while watching. Bookmarks are only visible via a report.
- **Playback loop**: hover the timeline, then right-click and drag to define a loop. Right-click the timeline again to remove it.
- **Export from a tile**: **Show more > Download**. The export range is the configured playback loop, or **the last five minutes** if no loop is set. Formats: G64x, **MP4 (default)**, ASF.

### Reusable tile layouts

Right-click any tile > **Save layout**, then set **Name**, **Association** (the area it belongs to) and **Partitions**. The layout appears nested under its area or under Directory. Double-click to open it. Layouts are available to users who have access to the partitions holding them, and can hold only camera, door and federated virtual zone entities.

Modify: right-click the entity > **Edit layout** to change properties; or open the layout, rearrange, then right-click the layout entity > **Save as** and confirm to overwrite, or right-click a tile > **Save layout** to save it as a new one.

### Video timeline navigation

- Hover the timeline and drag the cursor to a time.
- Hover and use the **scroll wheel** to zoom the visible range in or out, then drag.
- With **Video thumbnails on timeline** enabled on the camera, hovering shows a preview above the timeline; **Shift + scroll** adjusts the range between **30 seconds and 24 hours**; dragging scrubs with a full-frame preview and a white cursor, and releasing jumps playback there.
- Green marks on the timeline are motion events.

**Go to a specific time**: in a tile, use the drop-down in the middle of the tile toolbar > **Go to specific time**. Pick a date (**Today** jumps back to today), use the arrows to step whole days, then click a time in the **24-hour timeline view** - the rows show detected activity types per time segment. Turning off the 24-hour timeline view gives a simple date-and-time picker without the activity rows.

### PTZ

**PTZ configuration controls exist only in Genetec Operation desktop.** The web client offers **zoom (+ / -) and preset selection only**.

| Not supported in Operation desktop | Not supported in the web client |
|---|---|
| PTZ lock, direction buttons | PTZ lock, direction buttons, **creating presets** |

In Operation desktop, point-and-click replaces directional buttons - operators click in the video to reposition the camera. A dome-camera icon indicates PTZ support. Per-device PTZ support is in the SDL Feature Matrix.

Zooming: the **+ / -** controls in the PTZ widget (with a speed slider), the blue zoom slider over the video tile, the mouse wheel, or a drawn zoom box if the camera supports area zoom.

**Presets**: created in Operation desktop only (Monitoring task > drag the PTZ camera into a tile > position and zoom > save). Up to **100** presets. In Security Center SaaS, **Axis cameras use preset 0 as their home position** and return to it after a restart or update. Selecting a preset: use the quick-access presets in the PTZ widget, or **Toggle to advanced mode**, pick from the **Presets** list and click **Go to PTZ preset**. Preset functions including home position only work if presets have been configured.

## Maps

| Action | How |
|---|---|
| Choose a map | **Select map** list at the top |
| Choose a preset view | **Presets** button, lower-right |
| Choose layers | **Select layers** button |
| Search | The in-task search bar finds entities, and street addresses on geographic maps |
| Doors and readers | Click a door or reader marker to open the side panel: manually unlock a door, override an unlock schedule, shunt a reader, share the entity, add it to the watchlist, forgive antipassback violations, view access-control events, see related video. Hovering shows lock status and commands |
| Cameras | Hover a camera marker for video; click it for video, entity controls and events. **Maximize video** enlarges the side-panel view. Side panel offers download video, share entity, add to watchlist, save a snapshot, add a bookmark, and right-click-drag on the timeline to create a playback loop |
| Door state visible | Health (offline, online, warning, maintenance mode), status (closed or opened), lock status (locked or unlocked) |
| Camera state visible | Offline, online, warning, maintenance mode |
| Navigate | Click a map object holding a **map link**, or a **floor control**. An administrator configures both |

### Mobile users on maps

Only on **georeferenced** maps, and only if the user has enabled **Share location** in the SC SaaS Operation app. Markers show the cardholder picture, falling back to initials. Search by first and family names or initials. Hover for the last timestamp. Clicking a marker shows first and last name, picture, email address, last recorded location and a **live video feed from the user's phone**, and lets you **Send a message** that arrives in their app.

## Investigation and intelligent search

### Standard capabilities (all plans)

- **Natural language search** across camera metadata.
- **Filtered search** narrowing by clothing colour, vehicle type, time, camera source and more.

Natural-language examples that the docs give: "person wearing a red top near the loading bay around 3 pm", "person wearing a red top and blue pants yesterday afternoon", "white truck entering the car park yesterday afternoon", "blue sedan parked outside HQ entrance last night", "vehicle outside two days ago". You can also give specific descriptors - vehicle make/model/colour ("Black Volkswagen Tiguan"), text or logos on a vehicle ("FedEx", "UPS", "Taxi"), people holding objects ("Woman holding a black bag", "anyone carrying a backpack near the restricted area last weekend"), and extra vehicle attributes.

**Location matching caveat:** location results only appear when the phrase fully or partly matches one or more **camera names**.

### Premium capabilities

**Intelligent search requires a Premium Plan.** It bundles:

- **Entry and exit detection** using scene-based detection - draw a box around an object such as an unattended item to find when it entered or left.
- **Similar people** and **nearby activity** thumbnails.
- **Visual trajectory**.

Hard constraints:

- **Intelligent search only works on non-federated cameras.**
- Similar-people and nearby-activity results are generated from **forensic-capable cameras with *Activate camera metadata* enabled**. You can *start* a search from a non-forensic-capable camera in a monitoring tile, but you will not get the derived results.
- **Stationary cameras only.** Moving cameras do not produce consistent metadata, so intelligent search is unsupported on them.

**Starting from a tile:** seek to the point of interest, then click **Intelligent search** in the video player toolbar. A window opens with a larger tile and nearby-activity thumbnails. Choosing a person shows similar people and nearby activity; choosing a vehicle shows entry/exit detections and nearby activity. Drawing the box on an empty part of the scene means object detection has nothing to work with.

**Starting from the Investigation task:** enter the natural-language query, press Enter, optionally refine with the filter icon, choose a thumbnail size, then select a result to open the side pane with a video tile and related intelligent-search results.

### Visual trajectory

Premium only. Shows movement inside a camera's field of view, travel directions and exit points from the scene. Two ways to use it: in the Investigation task, display the path taken by the people or vehicles in the tile; or in Tiles and Investigation, define an area of interest and view the trajectories of everything that passed through it.

Procedure: go to a point of interest in the timeline, click **Intelligent search**, draw a box around the area, click **Show trajectories**. Refine with object and time filters, hover results to see objects and their trajectories in the tile, click a result to view the video. Also review the **Similar people** and **Nearby activity** sections for the filtered time frame.

## Front desk

Requires the **Front desk** role. Security screening is available for planned and walk-in visitors **in the US market only** and screens **US people only**; screening is supported for **walk-in visitors only**.

**Set your location first.** The first time Front desk opens you must choose a **Site** (hidden if there is only one) and an **Area**. The browser stores this, so you do not repeat it on refresh - but you will need to set it again if the stored data is unavailable, if you switch devices, or on a fixed-location machine. The chosen location determines what you can see and do, and where a security guard is dispatched when a screening match occurs.

| Capability | Detail |
|---|---|
| Visitor list | Overview of who checked in and who is expected later; confirm check-outs at end of day or after an event; search by name or company; filter by hosts, sites or dates |
| Visit events schedule | **View schedule** shows planned visit events, who is expected today and in the coming week; click an event for an overview and its visitor list. Use it to prepare access cards and special requirements ahead of time |
| Walk-in check-in | **Walk-in visitor check-in**, follow the prompts, allow camera access when asked, have the visitor stand for a front-facing photo, review and **Confirm check-in**. **The check-in photo is stored only in Genetec's Azure cloud storage and is not sent to third parties** |
| Screening | Activated by configuring **visit profile settings at site level**. During check-in, potential matches are surfaced for side-by-side photo comparison and access is denied when a match is confirmed |

## Reports

| Report type | Contents |
|---|---|
| Alarms | Alarm events |
| Bookmarks | Bookmarked video clips |
| Camera events | Camera-related events |
| Door activities | Access-control events such as access denied, and door status |
| Anything | Multiple event types combined |

Workflow: choose a view (**List view** for columns, **Card view** for thumbnails), pick a report type from the **What** list, set the **When** filter (a time frame or a specific date) and the **Where** filter (specific areas or entities), then **Generate**.

- **Reports display up to 500 results.**
- Adjust columns via **... > Edit columns**; available columns depend on the report type.
- Selecting a result opens a side pane with details and response actions such as alarm acknowledgment options and incident user procedures.
- Reports can be exported.

Intrusion reporting lives in Genetec Operation desktop - see `intrusion.md`.

## Voice and video calling

**Your system needs at least one intercom device before user-to-user voice and video calling is enabled.**

| Action | How |
|---|---|
| Configure peripherals | **... > Settings > Peripherals** - choose speaker, microphone and camera |
| Open the calling panel | The **call** icon in the notification tray |
| Call a user or intercom | **Address book** icon, then the **Call** icon next to the entry |
| Receive a call | Answering opens the side panel. For intercom calls, expand to a large tile, or close the side panel to move the call into a pop-up window |
| Send instructions or alerts to a speaker | Address book, then Call next to the speaker. **Calling multiple speakers simultaneously is not supported** |
| See an intercom's video | Tiles task - drag the camera from the intercom device into a tile |

## Alarms, hot actions and threat levels

### Alarms

The **Active alarms** icon in the notification tray turns from white to **red** when an alarm is active. Click it for the Alarms side panel.

**Trigger** an alarm manually: **Trigger alarm** button > select alarms > Trigger. Note you must be a **recipient** of an alarm to see it in the side panel.

**Acknowledge** commands:

| Command | Effect |
|---|---|
| Acknowledge (Default) | Alarm is no longer active and leaves the list |
| Acknowledge (Alternate) | Sets the *alternate* acknowledged state; your organisation defines the meaning, commonly a false alarm. Usable as a filter in alarm queries |
| Forcibly acknowledge | Forces acknowledgment - useful for clearing alarms under investigation whose acknowledgment condition has not cleared |
| Investigate | Signals to other users that you have seen it, without acknowledging, so it stays in the active list |

**Force acknowledge all alarms** is **administrator-only** and clears every alarm across the system, including alarms under investigation, alarms whose acknowledgment condition has not cleared, and **alarms not visible to admin users**. Reached via the Alarms side panel **...** menu, then confirmed with **Continue**.

### Hot actions

Mapped to function keys. An administrator must configure them before the menu appears. Trigger via the notification tray **Hot actions** menu, or **Shift + F<n>** where n is the item's position in the menu - Shift+F1 fires the first entry. Some function keys may already be bound by the browser, so check the menu.

### Setting a threat level

Notification tray > **Threat levels** > pick a level from the list > choose **System (All areas)** or **Specific areas** (then select them) > **Trigger** > confirm. Active levels are listed in the panel. Deactivate by selecting the areas under **Active threat levels** > **Deactivate** > confirm. Administrators define which threat levels exist; setting one can change map-object states depending on the associated event-to-actions.

## Event monitoring and the watchlist

1. **Choose event types first**: **Options > Events**, pick the general type for everything or expand and select specific events per category. (Also reachable from the watchlist via **... > Event options**.) Save.
2. **Add entities to the watchlist**: notification tray **Watchlist > Add items > select entities > Add**. Tick **Flag** next to an entity to float its events to the top of the list. Back-arrow, and the list starts filling.
3. Click an event for its details pane.
4. Clear entries by hovering and clicking **Dismiss**, or **... > Dismiss all**.

Watchlist behaviour:

- Accessible from any task via the notification tray.
- The icon shows the number of **missed events** since the pane was last closed; opening the pane resets it to zero.
- **Up to 250 events** are displayed.
- **Events remain in the watchlist for a maximum of 15 minutes.** For older events, generate a unified report in the Reports task.

**Sounds with events**: **Options > Sound** tab, select which events play a sound, Save. The browser tab must be **unmuted**. Alarm and incident sounds match the sound configured for the related entity in Genetec Configuration desktop. Sounds can play for all watchlist events or only flagged ones.

## Working with video files

### Exporting

Disable the browser's **pop-up blocker** first. Tiles task > Browse > drag the camera or layout into a tile > hover for controls > **Show more > Export**. Fill in File name, Description, Start time, End time, **Format** (G64x, MP4 default, ASF) and optionally **Export audio**. The count of in-flight exports appears next to the **Export status** icon; click it to watch progress, and download when the status reads **Ready to download**. The file lands wherever the browser is configured to save.

### Sharing clips (via Genetec Clearance)

Constraints: **maximum clip length 1 hour**; the sharer receives **Manage** permission on the file; recipients have **14 days** to access and download before deletion; recipients do **not** need a Security Center SaaS account.

Tiles task > drag a camera into a tile > right-click > **Camera > Share video clips** > complete the fields (add more cameras with the + control) > **Next** > add recipients by typing a name or email and selecting from the list. Unknown recipients can be added by typing the email address manually. Review and adjust permissions before sending.

### Managing shared clips

Click your account username > **Manage video clips**. **Show more > Column options** sets column order and visibility (drag the reorder handle, then Apply). Per clip: **View video clip** to review contents, recipients and permission levels; **Edit access** to add missing recipients or change each recipient's level among **View**, **View and download**, **Edit**, **Manage**. The person who shared the clip is responsible for managing it.
