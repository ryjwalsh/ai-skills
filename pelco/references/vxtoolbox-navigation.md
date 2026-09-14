# VideoXpert Toolbox (VxToolbox) 3.20 - navigation map
Source: VideoXpert Toolbox v3.20 Operations Manual C6602M-U (pelco.com/fs/documents/C6602M-U_VxToolbox_v3.20_OperationsManual.pdf), extracted 2026-09-14. VxToolbox is the admin/configuration app for VideoXpert Professional (VxPro) and Enterprise (VxE). Tabs across the top: **Devices · Recording · Rules · Users · System · Licensing · Events · Maps · Monitor Walls · Reports**; menu icon (≡) top-left.

## Connection / login
- Install: run VxToolbox EXE > accept EULA > Begin Installation. VxPro first launch shows "VideoXpert Basic System Setup" dialog.
- Add a system: ≡ > Manage VX System Connections > + > Server Address, Port (default 443 HTTPS / 80 HTTP), Admin Username/Password (system admin user is `admin`; password set at initial setup - no default). Edit: pencil (credentials, SSL). Remove: X.
- Protect the local toolbox: ≡ > Set VxToolbox Password / Change VxToolbox Password (workstation-level, not the system login).

## Devices tab
- Quick Discovery: magnifier icon or ⋯ > Quick Discovery (SSDP + WS-Discovery checkboxes); banner shows Devices Discovered / Initialized / Could Not Initialize; filter icon on column headers.
- Advanced Discovery: ⋯ > Advanced Discovery > Discovery Method (IP/Hostname: Host, HTTP Port, Username, Password, Driver; or Discover by IP Range start/end). Devices are added but NOT commissioned.
- Add RTSP Device: ⋯ > Add RTSP Device > Device Name, Set Credentials, URI (+ Add Another URI).
- Credentials: select device with lock/warning icon > enter Username/Password (> Driver) > Submit. Factory-default camera: same dialog creates the camera's default user. Storage device password reset: select locked storage > Reset Password (≥8 chars).
- Commission: select > right-click > Commission (or "Commission and Assign Cameras" ✓ icon > Authentication Notice / Recorder Assignment). Decommission: right-click > Decommission.
- Replace Camera: right-click camera > Replace Camera > pick replacement > Replace (moves name, tags, recording schedules).
- Remove: right-click > Remove (recordings become unreachable).
- Device details: select > right panel > Device Information > pencil > Settings Editor (Name, Hostname, IP Address, Port, Apply name to Data Sources) > Save Changes. View dropdown top centre: Devices / Data Sources / Alarms & Relays / Access Points. Columns: right-click header or left panel > Show Data Columns.
- Firmware: select device > right panel > System > FIRMWARE > Update Firmware > pick file. Pelco Smart Analytics (MSI-based) cameras: use the Camera Configuration Tool (CCT) instead.
- Advanced Analytics (Pelco Advanced Analytics Suite cameras): select commissioned device > ADVANCED ANALYTICS > pencil > Configure Advanced Analytics: PTZ preset, Confidence Threshold, Analytic Rules + (Person/Vehicle in Zone, Counterflow, Counter uni/bi/omni-directional), zone drawing, Zone Name / Enabled / Counterflow Angle / Override Default Severity > Apply Changes > Save & Close.
- Smart Analytics (MSI/Avigilon-style cameras): configure in CCT > Analytics tab; event names map (No Object in Zone → Object Not Present In Area, Object Count Limit Exceeded → Objects Crossing Beam, Objects In Zone → Objects In Area).
- Audio: right-click device with audio > Add Video Associations > tick video data sources > Save. Disable/Enable Data Sources: right-click > Disable/Enable Data Sources.

## Recording tab
- Recorders (left, top): select recorder > ⚙ (edit configuration): Name, Reduce framerate for video after N days (I-frames only), Maximum Retention Limit (Discard video after N days), Transmission Method Multicast/Unicast, Stream to Record Primary/Secondary/Tertiary, Auto-backfill from on-camera storage (N cameras at a time, attempt interval, stop after N failures), Advanced Options > Maximum Bitrate > Save.
- Assign cameras: select recorder > All Data Sources panel > tick sources (immediate). No checkbox = no permission / failover recorder / VxPro internal recorder.
- Schedules: left top > Schedules > "What to Record" panel: + new Recording Group (Name; All Resources or Selected Resources > tick cameras) > Save; "When to Record" panel: ⚙ Edit the Recording Schedules > + new schedule (Display Name, time increments, 24-Hour Time, click/drag active boxes, "Within limited date range") > Add > tick > Save Changes. Recording Behaviors panel (right): + (Recording Mode e.g. Event-Triggered Recording (Full Frame Rate) = bump-on-alarm; Start recording N s before event; event; Stop after N s or next opposite event) > Add.
- Delete group/schedule/behavior with the trash icons in the respective panels (deleting a group deletes its schedules and behaviors).

## Rules tab
- + Create a new Rule > Name, Active/Inactive > Triggers panel + (Select an Event > Save > Select Event Sources > Save) > Schedules panel ⚙ (add/copy/edit schedule) > Responses panel pencil ("then this will happen") > + Response Category (Notification - External incl. Send SMS via Twilio, etc.; Convert to Custom Script) > Save > Save rule. Duplicate/edit/delete icons on the left panel; Search Rules field.
- SMS prerequisite: System tab > SMS > Enable SMS messaging via Twilio > phone number, Account SID, Auth Token > Send Test Message > Save Settings.

## Users tab
- Roles panel (left): + create (name, permissions), pencil edit, copy duplicate, trash delete. Users panel (centre): + Add (Username, New Password, Re-type, Assign Roles), pencil edit, key Reset Password, trash delete, Search for Users field. Permission groups (Appendix A): Surveillance, Investigation, Maps, Supervision and Reports, Event Management, User Management, Device Management, System Management.

## System tab
- General Settings (Company Name, system name, time) · Aggregation (VxE: aggregate member systems; settings must be changed on the member) · Cluster (VxE: node management, replace Core/VxDatabase nodes) · Authentication (VideoXpert authentication; LDAP Simple bind / Two-stage bind / Synchronize users and roles / Single Sign-On) · Backup (schedule, destination; multi-Core systems must back up to a UNC path) / Restore Databases (standard, Emergency, Manual) · SMTP (server, port, credentials, sender; Send Test Email) · SMS (Twilio) · Memory/performance controls · Monitor Walls · [labels above the top-level tab names are confirmed; some sub-panel names are paraphrased from the manual's task headings - verify on screen].

## Licensing tab
- License Summary table (Name, Total, In Use, Remaining, Expiration Date); click a license > Transaction History. Warning icon = expiring.
- Add license: Entitlements table > + > Activation ID > tick "Automatically activate online" (needs licensing.pelco.com reachable) > Enter; or untick > save activation request .bin > licensing.pelco.com > Manage Devices > Generate License > upload .bin > download response.bin > Licensing tab > Choose File > Import License File.
- Trial: one unlimited-channel 60-day trial at first start. Software Update Plan (SUP) is bought in channel-years; expired SUP blocks upgrades. After re-image contact Pelco support (1-800-289-9100 US/CA, +1-559-292-1981) to re-issue entitlements; keep the system backup + response file.

## Events / Maps / Monitor Walls / Reports tabs
- Events: filters (date, type, source, severity, keyword); select event > details; Settings > retention (default 30 days, up to 90; 10,000 events default max); notifications.
- Maps: + Create a New Map (name, image), position devices, permissions per role.
- Monitor Walls: + (name, layout, sources).
- Reports: templates (+, edit, delete) > Generate (date range/filters) > export CSV/PDF. Report types: Camera, Camera Role Access, Device, Event History, Counting Lines, Recording Gap, Role, Storage, System Status, User, User Action.
