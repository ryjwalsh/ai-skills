# System automation, schedules, threat levels and maps

Sources: Setup Guide System automation section [S7] and Map design section [S8].

**Almost everything here lives in Genetec Configuration desktop, not the web client.** Automations and threat levels are defined in the **System** and **Automation** tasks; maps are built in the **Map designer** task.

## Events

An event is a record of something that happened. Operators watch them live, investigate them later, and automations trigger from them.

Four attributes:

| Attribute | Meaning |
|---|---|
| Event source | The entity the event came from - a camera that started recording, a cardholder who presented a stolen credential |
| Event type | The description, e.g. *Recording started*, *Access denied: Stolen credential*. **Not all Security Center event types exist in Security Center SaaS** |
| Event timestamp | When it happened |
| Event data | Contextual information describing it further |

One event type can attach to several entity types - *Access denied* can be associated with a cardholder, a credential, and a door or elevator, depending on where it occurred.

### Custom events

**System task > General settings > Events > Add an item.** Give it a name, choose the **Entity type** that triggers it, and a unique numeric **Value** to distinguish it from other custom events (unrelated to entity logical IDs). Save, Apply.

Custom events give descriptive names to standard events raised by input signals from zones, intrusion panels and so on, and are then used in automations.

### Event colours

**System task > General settings > Events > Event colors tab**, pick a colour per event, Apply. Colours appear in the event list and in the canvas tile in Genetec Operation desktop - the documented example uses red for a stolen-credential attempt and blue for an access-granted event.

### Event data in automations

Common data available to most event types is the **source entity**, which can be referenced as variables in response actions:

- Source ID (the GUID)
- Source name
- Source description

Event **location** is only available for certain event types - for example events from a Patroller unit, or record-type events such as *Record updated* and record fusion events. Some event types carry additional type-specific data that can be used to add conditions to triggers and to contextualise responses.

## Schedules

A schedule combines a **date coverage** with a **time coverage**.

| Date coverage | Meaning |
|---|---|
| Daily | Every day |
| Weekly | Every week, with a different time coverage possible per weekday. **Not available for twilight schedules** |
| Ordinal | Monthly or yearly patterns, each pattern with its own time coverage |
| Specific | Named dates, each with its own time coverage |

| Time coverage | Meaning |
|---|---|
| All day | 24 hours |
| Range | A fixed window |
| Daytime / Nighttime | Sunrise/sunset-derived (twilight schedules only) |

The built-in **Always** schedule gives 24/7 coverage. It cannot be renamed, modified or deleted, and it has the **lowest priority** in schedule-conflict resolution. Schedules must exist before you can apply them anywhere, so create them first.

**Time zones:** by default a schedule's time of day follows the local time zone of wherever it is applied - a 09:00-17:00 recording schedule records 09:00-17:00 local time whether the unit is in Tokyo or London, because each video unit carries its own time-zone setting. Note the contrast with **user logon schedules**, which follow the hosting server's time and are therefore **UTC**. [S6]

### Building them

**System task > Schedules view > Schedule button**, name it, Enter. Fill in the Identity tab, Apply, then the Properties tab.

- **Daily**: choose All day or Range, then paint the time grid. Left-click to select blocks, right-click to remove, click and drag for runs, click-and-hold to zoom in and select individual minutes. Each block on the zoomed grid is **one minute**. Hovering a block shows its start time.
- **Weekly**: the grid is in **15-minute** blocks. Click a day name to select or clear that whole day; click the timeline at the top to select or clear that block across all days.
- **Ordinal**: Add an item, pick a day and a month, then a time coverage. Add as many dated patterns as you need in one schedule entity. You can reproduce a weekly pattern with ordinal entries - for example the daytime of every Monday of the year.
- **Specific**: Add an item, pick dates on the calendar, Close, then per entry choose All day, Range (with separate grids for *Day before*, *Current day* and *Day after*), Daytime or Nighttime. The documented example covers 1 February 2026 from 21:00 the day before to 03:00 the day after.
- **Twilight**: date coverage Daily, Specific or Ordinal (never Weekly), time coverage Daytime or Nighttime, then choose **Sunrise** or **Sunset** with an offset of up to **2 hours** before or after.

### Twilight schedule limits

Twilight schedules exist to handle situations where sunlight matters - recording only in daylight, boosting encoder sensitivity after sunset, disabling motion detection during twilight. They **cannot** be used with access control entities, the entity they apply to must have a geographic location setting (video units, ALPR units), the **Weekly** date coverage is unavailable, and the **All day** and **Range** time coverages are unavailable. They are hidden in contexts where they do not apply.

## Audio files

**System task > General settings > Audio > Add an item.** Supported types: .mid, .rmi, .midi, .wav, .snd, .au, .aif, .aifc, .aiff, .mp3, .ogg. Best practice: keep files **under 100 KB**. Rename with *Edit the item*, preview with *Play*, then Apply. Used for alarm sounds and the *Play a sound* action.

## System automation

Three mechanisms, in descending order of capability:

1. **Automation entities** - the comprehensive mechanism.
2. **Threat levels** - predefined scenarios activated for an area or the whole system.
3. **Event-to-actions and scheduled tasks** - **legacy**, and convertible to automations.

### Automation entities

An automation has two halves: a **trigger** (what starts it) and a **response** (the actions that follow). Setup is five steps, the last two optional: create the entity, configure triggers, configure the response, advanced settings, add to a map.

Capabilities:

- Combine multiple events; evaluate them with **AND** or **OR**.
- Require an event a specific number of times inside a timeframe.
- Require events in a specific **sequence** inside a timeframe.
- Conditional triggers based on event data.
- Include or exclude specific entities as event sources.
- Multiple response actions, with or without delays between them.
- Actions that run only if a subsequent event occurs within a delay after the trigger.
- Use event data to tailor actions.
- Control when the automation may run: earliest and latest trigger dates, active and exception schedules, reactivation rules, ignoring obsolete events.
- Manual triggering from maps.
- Organisation by folders and partitions.

**Trigger types**

| Type | Behaviour |
|---|---|
| Manual | Triggered by a user from maps, hot actions or manual actions |
| Scheduled | One-time or recurring |
| Event | Raised by system events |

Requirements: the automation must be **activated** and inside its activation period, and **all servers and workstations must be time synchronised** for triggers to work correctly.

**Event-based trigger mechanics**

- Each trigger maps to one specific event; an event can be generic or scoped to specific entities.
- Conditions can be applied to certain event types. (ALPR-specific conditions exist, but **ALPR is only available through federation**.)
- Triggers group together. Within a group, **OR** (the default, *Any event*) fires on any event; **AND** (*All events*) requires all of them inside a stated timeframe. With AND the occurrence-count criterion cannot be used and the order of events does not matter.
- Add a second trigger with **Add trigger** under the first; set its source to **Same as first** to require the same source entity.
- For sequences, link trigger **groups** with the **Followed by** operator - and use only that operator for sequences. A second group is evaluated only after the first group's conditions are met. Each group can hold one trigger or a combination.

**Responses**

**Properties > Response > Add an item**, pick an action type and set its arguments. All response actions run **immediately** when the automation triggers - add explicit delays to stagger them. Use the **Run an automation** action to nest one automation's response inside another. Arguments can be contextualised from the triggering event's data.

**Contextualised actions** - these can reference the **source entity** of the triggering event:

| Applies to | Actions |
|---|---|
| All entities | Share entities |
| Areas | Unlock area perimeter doors explicitly |
| Cameras | Add a bookmark; Block and unblock video; Start recording; Stop recording; Email snapshots; Override with event recording quality; Override with manual recording quality; Recording quality as standard configuration |
| Cardholders | Forgive an antipassback violation |
| Doors | Silence a buzzer; Sound a buzzer; Unlock a door explicitly; Set the door maintenance mode |
| Doors and elevators | Shunt a reader |
| Units | Reboot a unit; Set the entity maintenance mode |

Some actions offer a choice between **Source** (the entity that raised the event) and an explicitly named target.

**Advanced settings** (optional)

| Setting | Meaning |
|---|---|
| Execute response as | Auto-set to the automation's creator. Does not affect trigger evaluation |
| Not before | Do not trigger before a date and time |
| Not after | Do not trigger after a date and time |
| Schedules | Periods when the automation may trigger |

**Adding an automation to a map**: Map designer > open a map > toolbar **Automation** > select the automation > drag it into place. Operators need the **Run automations** privilege to trigger it manually.

### Example scenarios the docs call out

| Scenario | Automation |
|---|---|
| Devices fail or go offline | Email when a unit stays offline longer than X minutes |
| Potential security breach | Play a recorded audio message when a camera detects unexpected movement in a restricted area |
| Emergency with a predefined plan | Threat level - block a gunman's access and trigger alarms |
| Ad-hoc process | A button that unlocks a door for people without a credential card |
| Periodic reporting | Email a report annually to remind cardholders their safety certification is expiring |

### Converting legacy mechanisms

**Automation task > Actions tab** for event-to-actions, **Scheduled tasks tab** for scheduled tasks. Select up to **100** items, **Convert to automation**, Convert, Close.

- Converted originals are **kept as backups but deactivated** to prevent duplicate actions. An already-deactivated original produces a deactivated automation.
- New automations are named after the source event (event-to-actions) or the converted task (scheduled tasks).
- Converted automations trigger and execute with the privileges of the **user who performed the conversion**.
- A scheduled task with **On startup** recurrence becomes an automation that runs each time the **Automation Manager** role starts.
- If none of the selected event-to-actions can be converted, the Convert button is hidden.

**Event-to-actions that cannot be converted:**

- Those with **Use source time zone** enabled (used when the server managing the event's source entity is in a different time zone from the main server).
- Those needing synchronisation with the access control unit for **offline I/O linking** - specifically a **Trigger output** action paired with *Door closed*, *Door opened*, *Door forced open*, *Door open too long*, *Request to exit* or *Request to exit normal*.

Test converted automations before relying on them.

## Threat levels

A threat level is a predefined scenario you activate for a specific area or the whole system - a business event, an emergency evacuation, an active-shooter response. Activating runs one action list; clearing runs another. **The system never clears a threat level by itself** - you must explicitly define the deactivation actions.

**Security clearance** is the mechanism behind most of it. Areas carry a **minimum security clearance** from **0 (highest security) to 7 (lowest)**. A cardholder needs a clearance **equal to or higher than** the area's minimum to get in, on top of whatever access rules say.

Defining one: **System task > General settings > Threat levels tab > Add an item.** Fill in Name, Description, optional Logical ID and **Color** - pick a unique colour, because when the threat level is set at system level the whole Operation desktop background takes that colour. Configure **Activation actions** and **Deactivation actions**, OK, Apply. Both action lists execute **regardless of the acting user's privileges and permissions**.

Threat level actions can apply to **all entities within the hierarchy of the area** where the threat level is set, rather than to one entity. If you target a specific entity, the action hits that entity whether or not it sits in the affected area.

Actions available **only** in a threat-level action list or an automation response include **Set minimum security clearance** (target: an Area/Location; extra argument: the clearance level 0-7; requires the *Set minimum security clearance* privilege). A side effect: perimeter doors in the area that were unlocked by an unlock schedule move to **locked**.

### Worked scenarios from the docs

**Fire** (explicitly labelled illustrative - Security Center SaaS is not presented as a life-safety tool):

- *Trigger output* to sound the fire alarm via the relay the bell is wired to.
- *Set the door maintenance mode* on all doors in the area, which unlocks them indefinitely - better than *Unlock door explicitly*, which only unlocks for a few seconds.
- *Add bookmark* such as "Fire Alarm Evacuation Started" to a camera recording.
- Sound buzzers on all doors.

**Gunman:**

- **Set minimum security clearance** to reduce the gunman's mobility, assuming the credential he holds is below the chosen level. The worked example uses clearance 3, assuming only armed security personnel hold 0-3 and that operators continue watching doors so they can open them to let people hide in secured areas.
- Add a bookmark such as "Gunman Suspected Onsite".
- Trigger an alarm (the example names it *Gunman Alert*).
- Trigger a physical alarm on an intrusion detection area.

## Maps

### What maps give operators

Pan, zoom and navigate; span one map across multiple monitors; control how much information is shown; monitor and respond to alarms and events in real time; watch the live state of cameras, doors and zones; track moving objects such as patrol vehicles and Genetec Mobile users; control equipment directly from the map (pan a camera, unlock a door); locate entities and see what is nearby.

Operators use the **Maps** task in the web client or in Genetec Operation desktop. Map search behaves differently between clients: searches in **Operation desktop** list map objects and display them on any map they belong to; searches in **Configuration desktop** only list objects found on the selected map.

### Map designer

Genetec Configuration desktop > **Map designer**. A map entity is a two-dimensional diagram: a static background image plus layers of **map objects** on top. Operation desktop users can show or hide any layer.

**Every map must be attached to an area.** The area and its map form one entity, so define the area hierarchy first. Creating a map from the **Area view** task automatically attaches it to the selected area.

Selection tool behaviours worth knowing: click to select; click and hold the background to pan; **Ctrl + click-drag** to zoom into a region; **Alt + click-drag** for a rectangle selection; **Alt + click** a map object to select every object of that type in view.

Drawing tools: **Draw line** (click-drag for one segment), **Draw rectangle** (click-drag; a rectangle cannot later become another polygon type), **Draw polygon** (click per endpoint, click the first endpoint to close, **Shift+click** to add or remove a point between two points, double-click a point to finish without closing).

### Creating a map background

| Method | Notes |
|---|---|
| **Image file** | Image files, **PDF** and AutoCAD **DXF/DWG** are supported. Choose which layers or page to import, rotate and crop. Advanced settings expose **Resolution** and **Background** colour. The wizard does **not** create one map per layout - do that manually |
| **Geographic (GIS)** | Requires a configured map provider on Map Manager. **Combining data from multiple providers is not supported** - one provider per map |

Two ways to start: **Area view > select area > Identity > Create map**, or **Map designer > Create > pick or create an area**.

**Setting scale:** Map designer > **Map > Edit scale > Specific scale**, choose units, **Draw line**, drag across the map, align the endpoints to two points whose real distance you know. Saving auto-adjusts camera fields of view and the zoom level. You need a camera already on the map. **Scaling and georeferencing cannot both be configured** - pick one.

**Georeferencing** an image map needs **at least three markers** with geographic coordinates.

**Replacing a background:** **Map > Replace background**, drag in or select the image, optionally rotate/crop/adjust, **Apply background**. Existing map objects are preserved but some may need repositioning.

### AutoCAD import

AutoCAD **blocks** become map objects when associated with existing Security Center SaaS entities. In the wizard after *Choose your background*, associate block definitions with entity types: **Entity type**, **Block**, **Name attribute** (the block attribute holding the instance name that must match the entity name) and **Name comparison** (exact match or otherwise). Previously used mappings load by default when the same block definitions appear; you can import saved mappings from XML or define new ones.

For **geographic** maps the AutoCAD blocks must carry **latitude and longitude attributes**. Use **Map > Synchronize entities from AutoCAD**.

**Resynchronising** an updated AutoCAD file: **Map > Synchronize entities from AutoCAD**, select the file, Next. The listed entities are grouped by *modified*, *added* and *removed* - clear a group to exclude it. Confirm removals with Yes.

### Map objects, layers and presets

- **Map objects** represent entities as dynamic icons or coloured shapes. Areas, intrusion detection areas and zones default to polygons; areas that have a map attached default to **map thumbnails** meant to be used as map links. Any icon, image or geometric shape can stand in for these.
- A map object configured with a **quick action** gets an action overlay on its icon, and double-clicking runs the quick action instead of the object's default behaviour. **Quick actions cannot be attached to shapes, images or text, nor to federated entities.** The Map designer double-click action overrides Operation desktop's *Options > Map > On double-click*. Users lacking the privilege for an action see a normal icon in Operation desktop and cannot double-click it; in Configuration desktop the widget is read-only.
- **Layers**: **Map > Layers** lists everything available - Door, Camera, ALPR unit, Alarm, Custom entity, Entity name and more. Tick which show by default, use **Hide empty layers**, reorder with the up/down arrows. Per layer (cogwheel) set **Opacity**, a **Visible from zoom** threshold, or **Auto scale** so icons grow and shrink with zoom. **Operation desktop users cannot change opacity or auto-scaling** - those are Configuration-desktop-only.
- **Presets** are saved views. Every map has a **default view** shown when opened. **Select preset > Add preset** to save the current view; the menu also overrides, renames and deletes presets. Selecting a preset makes Operation desktop fit the view in the window by adjusting zoom where possible. **Map > Lock Display** prevents users repositioning the map by panning, zooming or using presets.
- **Floors**: designate two or more maps as floors of one building so operators navigate with overlaid floor controls. The areas behind connected floor maps must share the **same parent**. Organise the area view into buildings with mapped sub-areas per floor first. If the floor maps are georeferenced the view stays on the same part of the map between floors; **Ctrl** while changing floors restores the default view. An area in several buildings, such as a shared car park, lets the floor controls move between buildings.

### Specific object types

| Object | Notes |
|---|---|
| Access control unit | Icons for Online, Offline, Warning. Monitor status |
| Alarm | Inactive and active icons, or a semi-transparent polygon/ellipse in the alarm's colour that flashes when active. A map object linked to an active alarm is flagged |
| Camera | Drag from Area view. **Preview video** shows a live view while placing. Draw **walls** to block fields of view - only **lines, rectangles and polygons** can block; text, images and elliptical shapes cannot |
| Area as thumbnail | Drag an area that has a map; a large thumbnail of the target map appears, resize and position it. Used as a map link |
| Area for people counting | Drag a **secured area** configured for people counting; a tetragon appears - drag its corners to cover the physical space, Shift+click to add or remove points. **Color and border** widget controls appearance; tick **Block field of view** if the perimeter is real walls. Multiple links on one object mean the operator must click **three times** to reach a link |
| Text, images and shapes | Mark points of interest or replace standard icons. Can be assigned to entities normally drawn as polygons (areas, intrusion detection areas, zones) and to alarms. Can act as map links |
| KML objects | Imported into the **Map Manager** role: **System > Roles > Map Manager > Properties > Map layers > Add an item**, path to a .kml or .kmz file. **Georeferenced maps only.** Dynamic KML layers refresh at the interval defined inside the KML file |
| Mobile users | **Georeferenced maps only.** Grant the **View mobile users** privilege (User management > Advanced > user or group > Privileges > search "Mobile" > Allow), then have the user enable location sharing in the SC SaaS Operation app under Settings > Features. Accuracy suffers on manually georeferenced maps such as floor plans |
| Automations | See the automation section above |
| Input pins and output relays | See `intrusion.md` |

### Map Manager and map providers

Map Manager centrally manages imported map files, external map providers and KML objects, acts as the map server for client applications, and is the **record provider** for entities placed on georeferenced maps. It is created by default during provisioning - configure it only to add providers or import KML.

Ports: image maps are fetched by the desktop clients from Map Manager over **TCP 8012**; geographic maps are fetched directly from the provider over **TCP 443**.

**System task > Roles > Map Manager > Properties > Map providers > Add an item**, then:

| Provider | Setup |
|---|---|
| Azure Maps (Roads), Azure Maps (Satellite), Google map, Google satellite Map, Google terrain map | Requires a valid Azure Maps or Google Maps licence and key. Paste the key, **Validate** - status turns *Valid*. If the licence includes geocoding, turn **Geocoding** on so Map Manager can convert between coordinates and street addresses |
| WMS | Enter a name and the server base URL; enable **Use authentication** with credentials if required. Capabilities are discovered automatically; **Connect** shows a preview and the available layers, which you enable or disable. Supports WMS **1.3.0 and 1.1.1**, and **requires EPSG:4326** |
| TMS / custom | Provider **Custom**, a name, and the TMS server URL. **Show advanced options** exposes **Maximum zoom level** 1-25 (default **17**) and authentication. You can define the boundaries and scale of the tiled map |

**Web tile server URL format:** `http://<Server>/tile/<Version>/<Layer>/<Style>/{z}/{x}/{y}.<FileType>`

| Element | Description | Mandatory |
|---|---|---|
| Server | Root URL of the WMTS resource | Yes |
| Version | WMTS standard version, e.g. 1.0.0 | No |
| Layer | Map layer | No |
| Style | Layer style, usually `default` | No |
| {z}/{x}/{y} | Zoom, X and Y - calculated automatically when the map is viewed | Yes |
| FileType | Usually JPEG or PNG | Yes |

Consult the server's capabilities document for valid values. A worked ArcGIS example and an OpenStreetMap variant are given in the source topic.

### Exporting and printing maps

**Map designer > File > Export current view** or **Ctrl+E** for PNG; print for physical copies; use **Microsoft Print to PDF** to get a PDF. Only the **currently visible** portion at the current zoom is exported, and only the layers currently shown - so toggle layers first. Cluster bubbles render the same in exports and prints.
