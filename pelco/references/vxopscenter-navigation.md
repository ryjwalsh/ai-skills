# VideoXpert OpsCenter (VxOpsCenter) 3.25 - navigation map
Source: VideoXpert OpsCenter v3.25 Operations Manual (pelco.com/fs/documents/pelco-vxopscenter-v3.25-operations-manual-en.pdf), extracted 2026-09-14. VxOpsCenter is the operator client (Windows). UI = **Mission Control** panel (dockable left/right) + tab/workspace area with cells, per-cell and tab timelines.

## Login / workstation
- Log in with server address (IP or FQDN for SSO), HTTPS port, optional "Validate SSL/TLS Certificate", VX user or Workstation Configuration account; Multi-System Access (MSA) mode for several standalone systems.
- Mission Control > User Menu icon > **Configure Workstation** > Workstation Settings: Workstation Name, Vx Workstation Account (username/password - change password here), Workstation Mode Normal / Shared Display, Configure Monitors (Direct or Decoder + IP > Connect; VxSystem Monitor Number; auto-accept shared views), NTP Server, Hardware acceleration, "MSA opens without credentials", **VX System Connections** button.
- Add a system: Configure Workstation > VX System Connections > + > Server Address, HTTPS Port, System Streaming Performance (RTSP/RTP, UDP, Multicast, buffer, connection speed 512k-10 Gbps), Validate SSL/TLS, Custom Fields, Username/Password (optional in MSA) > Test Connection > Save. Edit pencil / Delete trash. MSA: Mission Control > Systems panel (tick systems, filter, open standalone, ≡ > Export/Import System List).
- Preferences: User Menu > Preferences > tabs General (time display, snapshot JPG/PNG + overlays + auto-save folder), Mission Control (double-click behaviour, docking, thumbnails), Cells (camera info, PTZ mode auto-entry, timestamp, audio auto-play from selected/all cells, analytics zones, aspect ratio, Optera defaults), Streaming (PTZ buffer, low-bandwidth playback), Popups and Dialogs (alert sorting), Shortcut Keys (Personal vs Global profiles).
- Log out: User Menu > Log Out (workspace saved server-side). Language follows Windows language.

## Tabs and workspaces
- New tab: tab bar + (or Mission Control > New Tabs / Views > New Tabs) > pick grid layout; drag sources / double-click; File > Save As (name, shortcut, public / collaborative) ; File > Save to update; Views > Saved Tabs (double-click to open; right-click Edit Tab / Delete Tab).
- Layout: Select Grid Layout icon (6×6 / 8×8 need secondary streams ≤640×480@30 fps). View menu: Full Screen, Max Video Quality (Highest Available / Secondary / Tertiary / D1 / SIF / JPEG / Thumbnails), aspect Stretch/Maintain, cell spacing. Mode menu: Normal / Collaborative / Live Sequence / Alarm Sequence.
- Workspaces: Views > Workspaces > open (Keep or Close open windows), Save Workspace As (name, shortcut, public), right-click Edit/Delete.
- Cell borders: white = active; white inner = live; yellow = playback; blue = PTZ; purple = digital PTZ; flashing red = active alarm; green = controlled by another OpsCenter (monitor wall).

## Video
- Sources: Mission Control > Content > Sources (filter by name; Advanced Filter: Tags, Online, Recording, On Screen, Storage) > drag/double-click. Tooltip on device icon: live thumbnail, Online/On Screen/Recording/PTZ Lock, Watched by, Tags, Technical Details (IP, ID, model, serial, version, target recorders - needs "View Full Camera Details").
- Playback: cell timeline; tab-level Synchronous Play for several cells. Investigation mode (per system config): Send To / context menu; push video from camera SD storage to recorder; playback after backfill.
- Quick Export: right-click source or cell timeline > Quick Export > Previous 5 minutes / Previous Minute / Custom range (timeline also Next minute/5 minutes), optional encryption. Export Archive: User Menu > Export Archive (preview, download, get encrypted-export password, rename, delete). Clips/playlists created in playback then exported (VxPlayer plays exports).
- Bookmarks: Mission Control > Bookmarks panel (filter, double-click to load; right-click Edit / Unlock / Delete); tooltip shows name, sources, time, event, thumbnail.
- Snapshot: cell toolbar/right-click > Snapshot (format/overlay/auto-save in Preferences > General).
- Rotate: right-click cell > Rotate (Default / 90 / 180 / -90). Analytic overlays: right-click cell > Analytic Overlays (Simple & Enhanced: motion + drawing data; Advanced (Sarix): Object Bounding Boxes, Object Detection Zones, Counting Lines + Display Counts; ONVIF Profile M zones/boxes).
- Audio: sources with a blue/grey dot; cell mute/unmute icon; Preferences > Cells > Automatically play audio.
- Diagnostics: right-click cell > Diagnostics > Statistics (bitrate, mode, source, call-up time) / Measure Latency. Relays & aux: right-click cell > Relays & Aux (relays, IR, washer/wiper).
- Camera admin shortcuts: right-click source > Edit Source (name/number) / Open Camera Configuration in Browser / Open in VxToolbox / Manage Tags / Search Recordings for Motion (Pixel Search, VxPro only). Folders panel: right-click Create/Rename/Delete Folder.

## PTZ
- Live cell > click-to-center; zoom-to-box; right-click cell > Presets (select / Create / Edit / Delete), Pattern (patterns are created on the camera), Home Preset, Refresh Presets and Patterns, Send Preset Number. PTZ Lock shown in source tooltip. MJPEG streams: click-to-center only.

## Alarms / events
- Event Counter bottom-right (red when active) > Event Notifications pop-up > Event Log (Event Notification dialog / Event Viewer cell). Red alarm symbol at left margin of cell; hover for type; respond to stop the flashing border. Event Viewer plugin: Mission Control > Content > Plugins.

## Maps
- Content > Maps > drag/double-click (DWG, JPEG, PNG). Pan/zoom, hover camera for thumbnail, click icon for side panel, double-click to open cell, linked-map icon; gear icon in map cell > preferences (Center on Alarm, Switch map on alarm, zoom, camera numbers, background colour, icon scale, thumbnail on hover). Needs "View Maps" + camera permissions.

## Monitor walls / shared display / decoders
- Open: Mission Control > New Tabs > monitor wall icon; tab dropdown picks the wall; drag sources into monitor cells; keyboard/KBD500/3D mouse call-ups (numeric keypad opens call-up dialog); Refresh icon.
- Shared Display workstation: Configure Workstation > Workstation Settings > Shared Display > Configure Monitors (Direct / Decoder IP, VxSystem Monitor Number, auto-accept) > display user account (needs Setup Edge Devices + Manage Display Devices) > options (name/timestamp, title bar, collapse spacing, aspect, NTP, hardware acceleration) ; auto-starts with Windows.
- Send views: User Menu > View Launcher (View: Saved Tabs/Investigations/Workspaces > System > Destination(s) > Force Acceptance > Launch) or right-click cell/source > Send To. Quick Launch: active cell > Insert key > `[monitor]m[cell]c[camera]` e.g. `6m3c222` > Enter.
- Enhanced Decoders (VxE only; VX-A3-DEC+ H.265 HW accel); no 4K output (steps to 1080p).

## Plugins
- Mission Control > Content > Plugins: Event Viewer, Image Viewer, Web Browser, BriefCam, Occupancy Counting, Access Control System Viewer (configure servers; filter on Access Points / Users), VideoXpert Plates ALPR (search plates, black/white lists, reads). MSA mode: Access Control and Plates plugins connect to one system at a time.

## Kiosk mode
- Windows 10 + VxOpsCenter 2.5+: white paper "Configure VxOpsCenter Kiosk mode", OpsCenterLauncher.zip into C:\Program Files\Pelco\VideoXpert\VxOpsCenter, kiosk_mode_script_v2.ps1, local "Operator" user, run script as admin.
