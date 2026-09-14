---
name: pelco
description: Technician knowledge of Pelco (Motorola Solutions) products - VideoXpert Professional and Enterprise VMS (VxToolbox admin app, VxOpsCenter operator client, VxPortal, VxStorage recorders, Core/Media Gateway clusters, licensing.pelco.com), Sarix / Spectra / Optera cameras and their web interface, the Pelco Camera Configuration Tool, Pelco software & firmware downloads, the Pelco Document Center, Pelco Support Community and Calipsa / Videotec support. Use whenever anyone mentions Pelco, VideoXpert, VxPro, VxE, VxToolbox, VxOpsCenter, VxStorage, Sarix, Spectra, Optera, Esprit, Endura, NSM, Calipsa, Videotec, support.pelco.com or pelco.com/updates, or asks where a VideoXpert / Pelco camera setting lives.
---

# Pelco (VideoXpert, Sarix cameras, Pelco portals)

Pelco is Motorola Solutions' video brand alongside Avigilon. Its VMS is **VideoXpert**: *Professional* (VxPro, single server) and *Enterprise* (VxE, clustered Core + Media Gateway + VxStorage recorders), administered with **VxToolbox** and operated in **VxOpsCenter** (Windows) or **VxPortal** (browser). Cameras are the **Sarix** (fixed), **Spectra** (PTZ), **Optera** (panoramic) and **Esprit** families; newer Sarix models share the Motorola/Avigilon-style web UI and are configured in bulk with the **Camera Configuration Tool**. Support runs through the Pelco Support Community (support.pelco.com), the Document Center (pelco.com/docs) and pelco.com/updates. Videotec (rugged housings/PTZ) support is routed through the Pelco community. [S1]-[S6]

## Scope and freshness

Portals verified from the Motorola Tool Hub on **2026-09-14**. Product navigation comes from Pelco's own PDFs on pelco.com (VxToolbox 3.20 Operations Manual, VxOpsCenter 3.25 Operations Manual, VideoXpert Enterprise 3.21 System Design Guide, Sarix Value 2 Operations Manual). Newer VideoXpert releases keep the same tab structure; confirm on screen when a label differs. Calipsa (cloud alarm verification) and legacy Endura/NSM are portal-only in this skill.

## Quick facts

| Item | Value | Src |
|---|---|---|
| Support Community | https://support.pelco.com/s/ (tiles: Trust & Status, Ideas, Discussions, Groups, Learning Center, Videos, Returns, Software & Firmware; articles `/s/article/<slug>`); phone article "Which-Is-the-Pelco-Technical-Support-Number"; Pelco product support 1-800-289-9100 (US/CA), +1-559-292-1981 | S1, S3 |
| Downloads | https://www.pelco.com/updates/ (filter Software Type: Firmware / Software / Plugins, language) | S1 |
| Documentation | https://www.pelco.com/docs (Document Center; filters: document type, language, product family); PDFs live under pelco.com/fs/documents/ and media.pelco.com | S1, S2 |
| Camera tool | https://www.pelco.com/camera-configuration-tool/ (Motorola CCT - same tool as Avigilon's; Pelco requires a non-empty admin password and Country in CSRs) | S1 |
| Licensing | licensing.pelco.com (activation IDs, Manage Devices > Generate License for offline .bin) | S3 |
| VideoXpert admin user | `admin`; password set at initial setup (no default); 60-day unlimited trial license on first start | S3 |
| Core ports | 443 HTTPS (clients/API), 80 HTTP, 554 RTSP, 5544 VxStorage RTSP, 9091/9443 VxStorage API, UDP 41950-65535 media, 1900/3702 discovery, Hazelcast 6001-6003/16002-16012, Postgres 15432 | S4 |
| Logs | C:\ProgramData\Pelco\Core\logs, \Gateway\logs, \Storage\logs, \OpsCenter\Logs | S4 |
| Sarix camera first login | no default user - browser to http://<ip>/ opens New User page; firmware .ppm from pelco.com/updates; Software Factory Default keeps network config | S5 |

## Answer contract

Give a full breadcrumb starting with the application, then tab/panel/icon/field:

> To assign cameras to a recorder open **VxToolbox > Recording tab > Recorders (left panel) > [recorder]**, then tick the cameras in the **All Data Sources** panel on the right - changes apply immediately.

Rules: name the app (VxToolbox / VxOpsCenter / VxPortal / camera web UI / CCT / licensing.pelco.com); say whether a feature is VxPro-only (e.g. Pixel Search) or VxE-only (aggregation, clusters, Enhanced Decoders); include ports and file paths for network/IT questions; cite the source document; if the path is not in the references, say so and point to the Document Center rather than guessing.

## Product map at a glance

| Surface | Structure |
|---|---|
| VxToolbox | ≡ menu (Manage VX System Connections, VxToolbox password) · tabs Devices · Recording · Rules · Users · System · Licensing · Events · Maps · Monitor Walls · Reports |
| VxOpsCenter | Mission Control panel (Views: New Tabs / Saved Tabs / Workspaces; Systems (MSA); Content: Sources / Maps / Plugins; Bookmarks; User Menu: Preferences, Configure Workstation, View Launcher, Export Archive, Log Out) · tab bar with File / View / Mode menus · cells with right-click menus (Presets, Pattern, Rotate, Analytic Overlays, Relays & Aux, Diagnostics, Send To, Quick Export) · Event Counter bottom-right |
| Sarix camera web UI | Live View · Playback · General · Network & Security · Image & Display · Compression & Image Rate · Analytics · Storage · System |
| Portals | support.pelco.com (community/KB/cases) · pelco.com/docs · pelco.com/updates · pelco.com/camera-configuration-tool · licensing.pelco.com |

## Where to look

| Question | Open |
|---|---|
| Adding/commissioning cameras, credentials, firmware, recorders & schedules, rules, users/roles, system settings, licensing, events/maps/reports in VxToolbox | `references/vxtoolbox-navigation.md` |
| Operator tasks: login/MSA, workspaces/tabs, playback/export/bookmarks, PTZ, alarms, maps, monitor walls/shared displays/decoders, plugins (Access Control, ALPR), kiosk mode | `references/vxopscenter-navigation.md` |
| Components, every port, cluster/failover rules, capacity, storage/bandwidth sizing, multicast, backups, LDAP/SSO, aggregation, log paths | `references/videoxpert-architecture-ports.md` |
| Sarix camera web pages (network, TLS, users, image, streams, analytics, SD, firmware, factory reset) | `references/sarix-camera-web-interface.md` |
| Sources / gaps | `sources.md`, `known-gaps.md` |

## High-frequency answers

| Question | Breadcrumb |
|---|---|
| Discover cameras | VxToolbox > Devices > Quick Discovery (magnifier) or ⋯ > Advanced Discovery (IP/hostname or IP range, driver, credentials) |
| Camera shows locked / needs credentials | Devices > select camera (lock + warning icon) > enter Username/Password (> Driver) > Submit |
| Commission a camera / assign to recorder | Devices > right-click > Commission (or ✓ Commission and Assign Cameras) ; Recording > Recorders > [recorder] > tick in All Data Sources |
| Replace a failed camera | Devices > right-click old camera > Replace Camera > pick new > Replace |
| Camera firmware | Devices > [camera] > System > FIRMWARE > Update Firmware (Smart Analytics cameras: use CCT) |
| Retention / reduce frame rate after N days | Recording > Recorders > [recorder] > ⚙ > Maximum Retention Limit / Reduce framerate |
| Bump-on-alarm recording | Recording > Schedules > [group] > When to Record > schedule > Recording Behaviors + > Event-Triggered Recording (Full Frame Rate) |
| Rule: event → email/SMS/relay | Rules > + > Triggers + > Schedules ⚙ > Responses pencil > Response Category > Save |
| Add user / role | Users > Users panel + ; Roles panel + |
| LDAP / SSO | System > Authentication |
| Backup / restore database | System > Backup (UNC path for multi-Core) / Restore Databases |
| Activate license offline | Licensing > + > Activation ID > untick auto > save .bin > licensing.pelco.com > Manage Devices > Generate License > response.bin > Import License File |
| Add a second system to OpsCenter | VxOpsCenter > User Menu > Configure Workstation > VX System Connections > + |
| Export video | right-click source/timeline > Quick Export ; User Menu > Export Archive |
| Send a camera to a video wall monitor | active cell > Insert > `6m3c222` > Enter ; or User Menu > View Launcher |
| Shared display / decoder monitor | Configure Workstation > Workstation Settings > Shared Display > Configure Monitors > Decoder IP > Connect > monitor number |
| Camera IP / password / factory reset (Sarix) | web UI Network & Security > Network Settings (IPv4) ; > User Accounts ; System > Default & Reboot > Software or Hardware Factory Default |
| Where to download firmware / VideoXpert installers | pelco.com/updates (Software Type filter) |
| Where to open a case | support.pelco.com > New Case (Trust & Status for outages) |

## Working rules

- Facts trace to `sources.md`; **[INFERRED - verify]** marks anything not read in a Pelco document.
- Pelco documents are versioned PDFs; quote the version you are relying on (VxToolbox 3.20, OpsCenter 3.25, VxE 3.21 design guide) and tell the technician to check the Document Center for the release they run.
- Never invent VideoXpert sub-panel names; say the tab and refer to the manual when a sub-panel was not captured.
- Read-only knowledge; destructive actions (Remove device, Hardware Factory Default, database restore) are flagged.
