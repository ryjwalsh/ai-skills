# Vaidio - Configuration

## Contents
1. Config files and keys
2. Admin Portal settings
3. Core System menu map
4. Storage and retention
5. Mail (SMTP)
6. Authentication: LDAP
7. Authentication: OpenID / SSO with Microsoft Entra ID
8. Security policy and MFA
9. Server role and cluster setup
10. Video, sound, LPR and advanced settings
11. Privacy protection
12. Additional settings, SSL and map server
13. AI models
14. Camera configuration
15. NVR configuration and batch import
16. Alerts
17. Users, groups and permissions
18. Command Center, Vaidio Data and Edge settings

---

## 1. Config files and keys [S1]

Only one product config file is documented. Edit it only to change mount directories or GPU selection; after editing you must remove the container (keeping data) and run it again for changes to take effect.

    sudo nano /etc/vaidio/vaidio.conf

| Key | Documented value / default | Meaning |
|---|---|---|
| NAME | "vaidio" | Docker container name |
| VERSION | "X.Y.Z" | Application version |
| DATA_VOLUME | "/mnt/data/vaidio" | Metadata volume path |
| SYSTEM_VOLUME | "/opt/data/sys/vaidio" | System/database volume path |
| GPU_ID | 0,1 (commented alternative 0,1,2,3) | Which GPUs Vaidio uses |
| APP_CONFIG_BIN | "/etc/vaidio/profile.bin" | Application configuration (profile) file path |
| DATA_VOLUME_FOR_RECORDER | "/mnt/data-rec/recorder" | Internal Video Recorder volume |

Other files and paths that matter:

| Path | Purpose | Source |
|---|---|---|
| /etc/vaidio/ | Holds vaidio.conf and profile_x86.bin | S1 |
| /etc/docker/daemon.json | Docker default bridge subnet override via bip | S1 |
| /etc/netplan/*.yaml or /etc/netplan/01-netcfg.yaml | Host networking | S1 |
| /etc/fstab | Persistent data/recorder mounts | S1 |
| /etc/apt/sources.list.d/ironyun-release.list | Vendor APT repository | S1 |
| /etc/apt/apt.conf.d/10periodic and 20auto-upgrades | Disable Ubuntu kernel auto-upgrades | S6 |
| /etc/ufw/after6.rules | chmod 644 before enabling ufw | S1 |
| /opt/data/sys/vaidio/log/app/start_service.log | Upgrade status | S1 |

No environment variables or registry keys are documented (the product is Linux/Docker only). Windows registry keys do not apply. [S1]

## 2. Admin Portal settings (http://<vaidioip>:8000) [S1][S4][S12]

| Section | What it does |
|---|---|
| User & System | Change admin password (recommended), set timezone, sync with an NTP server, adjust system behaviour |
| Port configuration | Modify service ports |
| Network | Select interface, DHCP or Static configuration (IP, netmask, gateway), DNS server, then Apply |
| Time | Timezone and NTP |
| Upgrade | Online or Offline upgrade of Admin Portal (step 1) then Main System (step 2) |
| Factory Reset | Reset the server to default settings - destructive, use with caution |
| AI Type (Edge only) | Choose CLIP (default) or GenAI for Tunable Edge prompts |

## 3. Core System menu map [S4]

| Breadcrumb | Contents |
|---|---|
| System > General | HTTP port (default 80), HTTPS port (default 443), Force Secure Connection checkbox, Web Location URL, Export Configuration, Restore, Restart System |
| System > Time | Time Zone dropdown; DST handled automatically |
| System > Storage | System storage view, S3 cloud storage, Storage Configuration (retention) |
| System > Mail | SMTP configuration, Send Test Email |
| System > Authentication | LDAP or OpenID protocol, Check Connection, Apply |
| System > Log | System log and Diagnostic log, filters, Export (.xlsx) |
| System > Audit Trail | Login/logout and action history, filters, Export (.xlsx) |
| System > License | License Management and AI Engines tabs, Add AI Engines, Export, Renew |
| System > Setting | Select Role, Cluster, Video, Sound, LPR, Advanced, Privacy Protection, Additional Settings, Map Server |
| System > AI Model | Upload / Apply / Replace AI models |
| System > Utility | Network diagnosis: Ping, Traceroute, NS Lookup |
| System > Security | Password policy, idle-account deactivation, email notification, MFA |
| Camera / NVR / File / API Keys / Alert / User | Camera, recorder, video-file, API key, alert and user administration |

## 4. Storage and retention [S4]

System > Storage > Storage Configuration:

| Setting | Behaviour | Default / range |
|---|---|---|
| System Storage and Metadata retention | Unchecked: data kept until storage exceeds 80%, then oldest data deleted. Checked: data deleted after the retention period, or earlier if storage exceeds 80% | Default 30 days, minimum 1 day |
| Recorder Data retention | Deleted when the retention period is reached; if storage exceeds 80% first, data is deleted until usage drops below 80% | Default 30 days |

Notes: Recorder Data settings are always visible but inert without an Internal Video Recorder license (Retention Date shows as a tilde). Most deployments use an external VMS/NVR for video and rely on Vaidio for metadata. Metadata view shows Total Number of Objects, retention date range, Used/Total space in GB and Total Usage %. [S4]

Cloud storage: System > Storage supports **Amazon S3 and Qumulo S3** - select the S3 service as Protocol, enter Access Key and Secret Key, choose the AWS Region, then select or create a bucket. [S4]

Edge storage retention differs: toggle off keeps data until 80%, then oldest first; toggle on deletes older than retention, and if 80% is hit first it deletes until usage is **below 50%**. [S15]

Vaidio Data storage: Automatic Cleanup Threshold percentage (**default 85%**), System Storage and Metadata Retention Period in days (checkbox to enable), and a Save Image to Storage toggle for alert images from Core nodes. If Vaidio Data shares a drive with another Vaidio product, configure retention on both to avoid conflicts. [S10]

Command Center storage: System > Storage - retention period in days; if retention is reached first, older data is removed; if storage reaches 80% first, oldest data is removed until below the threshold. [S12]

## 5. Mail (SMTP) [S4]

System > Mail: enter SMTP details; Secure Connection is one of **NO Secure Connection, Secure Sockets Layer (SSL), Transport Layer Security (TLS)**. Use Send Test Email, then Apply.

- SMTP must be configured before password recovery works, and before MFA can be enabled.
- In a cluster, SMTP must be configured on **both the Main server and all Remote servers**.
- Vaidio publishes separate Gmail SMTP guidance.

## 6. Authentication: LDAP [S4]

System > Authentication > LDAP. Fields:

| Field | Notes |
|---|---|
| IP/Domain Name | LDAP server address |
| Port | LDAP server port (no default published) |
| Base DN | e.g. CN=Users, DC=companyname, DC=com |
| Login Name Attribute | Username or account name |
| Search Filter (optional) | Attribute description, classification or value |
| Authentication Method (optional) | Simple (DN plus clear-text password) or Anonymous (no bind) |
| User DN | e.g. CN=account name, CN=users, DC=companyname, DC=com |
| Password | Bind account password |
| Secure Connection | No or SSL |
| Certificate Upload (optional) | Upload a certificate |

Use **Check Connection** then Apply.

LDAP Group Mapping (9.2.0+): a one-to-one mapping between an LDAP group and a Vaidio User Group via an **External Identifier**. This determines which Vaidio group, and therefore which permissions, an LDAP user gets at login.

- After upgrading to 9.2.0+, existing LDAP users (including LDAP admins) may be unable to log in until a local Vaidio Admin does: log in locally > User menu > User Group > Edit Groups > add the External Identifier from LDAP to each Vaidio User Group. Once saved, users regain access with correct permissions, audit history intact, and no accounts need recreating.
- The authenticating LDAP account must have matching **memberOf** entries. Example: if the LDAP Admin role is mapped to CN=A000,OU=Groups,DC=example,DC=com, the account must include that CN=A000 in memberOf. Accounts that can query LDAP but are not members are rejected.
- Pre-9.2 flow: User > User Account > Import LDAP > select accounts > if no matching group is found, supply Email, Role (User or Admin) and User Group > Import.

## 7. Authentication: OpenID / SSO with Microsoft Entra ID [S7][S4]

Available from Vaidio 7.1.0. Entra ID side:
1. Azure Portal > Entra ID > App registrations > New registration.
2. Enter a Name, select **Single tenant**, select **Web** as Redirect URI and enter the Vaidio login page URL, then Register.
3. Certificates & secrets > New client secret > Description and Expiration > Add.
4. Token configuration > Add groups claim > select group types > ID type **Group ID** > Save.
5. Overview > Endpoints: note the Application (client) ID, Object ID and the OpenID Connect metadata document endpoint.

Vaidio side - System > Authentication > OpenID:

| Field | Value |
|---|---|
| Issuer | the OpenID Connect metadata document URL |
| Domain Name | the Vaidio login page URI, must match the Entra ID Redirect URI |
| Client ID | Application (client) ID from Entra ID |
| Client Secret | the secret generated in Entra ID |
| Client Credential Scope | .default |
| Group Claim | groups |

Click **Check Connection**, then Apply. A 'Login with Entra ID' button then appears on the Vaidio login screen. Vaidio syncs with Entra ID in real time.

Group behaviour: create a Vaidio User Group and set its External Identifier to the Entra ID group Object ID. If a user belongs to multiple Entra ID groups, Vaidio assigns a single group in alphanumeric order (A before B). Deleting a User Group with an External Identifier moves its Entra ID users to the **Undefined** role. From 8.1.0 the Admin User Group supports an External Identifier, so Entra ID users can hold the Co-Admin role. Access is denied if the user group is not predefined in Vaidio. Any valid Entra ID user, including Admin, can access Core without a pre-created Vaidio account. [S7]

Edge SSO (Tunable Edge 9.0.0+): Settings > Authentication > Enable OpenID. The user must already exist in an Entra ID group, can belong to only one group at a time, cannot change groups in Edge 9.0.0 or below, and the same username cannot exist in both Entra ID and Vaidio. [S15]

SAML is **not documented** anywhere in the retrieved guides - only LDAP and OpenID Connect.

## 8. Security policy and MFA [S4]

System > Security (only the primary Admin, not Co-Admins, can access):

| Setting | Behaviour |
|---|---|
| Force User to Change Password | User must change the admin-issued password at first login |
| Strong Password | Password must satisfy strong-password requirements |
| Automatically Deactivate idle User Accounts | Deactivates accounts after a set inactivity period, **30-365 days** |
| Email Notification | Emails the admin on account deactivation, account lock or critical logs (requires SMTP) |
| Multi-Factor Authentication | Requires all non-SSO users to complete Email OTP at login |
| User Managed MFA | Lets users change their own MFA setting from account settings |

MFA detail (Vaidio 9.3): Email-based **6-digit** one-time password, sent to the registered email, valid **10 minutes**, applies to all non-SSO users, requires SMTP configured and Core able to reach the mail server. Enabling MFA before SMTP is configured produces an error and the change is rejected. Per-user setting at User > User Account > (…) > Edit > Multi-Factor Authentication = OFF or Email OTP; self-service at User icon > Manage Account. The user list shows an MFM column. [S4]

Login hardening already in the product: three failed attempts lock the account for five minutes; password recovery requires SMTP and uses the Web Location URL set in System > General. Command Center enforces a strong password of 8-128 characters including upper- and lowercase letters and a number, and its reset codes expire in 10 minutes. [S4][S12]

## 9. Server role and cluster setup [S4]

System > Setting > Select Role: Standalone (default), Main, Remote, Node.

Node registration: select Node, enter the **Command Center IP/Domain and Access Key** (from the CC UI), then Check Registration Status to confirm.

Cluster setup (Main server): the Cluster tab appears after the Main role is selected.
1. Main server > Cluster > Add.
2. In the Add Cluster pop-up enter the remote server Name, IP/Domain Name, Account user name and Password.
3. Check Connection, then OK to register the Remote server.

Prerequisites: Main role on the hub, Remote role on each member, stable network. Max 1 Main and 15 Remote. When a Remote joins, its settings and camera configuration migrate to the Main server. Add cameras to the right server via the Cluster dropdown on Add Camera; a camera added to the wrong server must be deleted and re-added. Use the Cluster filter on the Camera screen to view cameras per server. [S4]

## 10. Video, sound, LPR and advanced settings [S4]

System > Setting > Video:
- Video clip playback duration in seconds for analytic events.
- Drop Corrupted Frame toggle (exclude corrupted frames).
- Object Tracking Mode toggle (object tracks in Live View).
- Enable live streaming analytics toggle. Disabling makes analytics more efficient but **deactivates ALL cameras**.

System > Setting > Sound: Alert Sound from five default sounds, Loop duration in seconds, Upload Sound for custom audio.

System > Setting > LPR: LPR Pattern definitions per region (example format 'AAA?999' = 3 letters, any character, 3 digits) and the list of vehicle types allowed in LPR.

System > Setting > Advanced:

| Setting | Values / range |
|---|---|
| Theme | Mystic, Light, Rustic, Black (default) |
| Face Upload Quality Threshold | Low, Medium, High |
| Privacy Protection | On/Off |
| Report False Detection | On/Off (requires internet) |
| Camera Connection Retry Interval | seconds, suggested 3-60 |
| Log and Audit Trail Retention Time | 3-365 days |
| Search results displayed | 1,000-10,000, suggested 1,000 |
| Cross Camera Tracking results | 100-1,000, suggested 100 |
| GPS Map | On/Off (requires internet) |
| Alert acknowledgement | On/Off |
| Show Model in MMR | On/Off |
| API Basic Authentication | On/Off |
| Enable Camera Auto Configuration | On/Off |

Higher search/tracking result limits may slow search performance. [S4]

## 11. Privacy protection [S4][S9]

When on, detected persons are blurred in Search and Alert results across all cameras, including detail pages, thumbnails and exported images.

- Restrictions while enabled: **no video playback, no live view**.
- Admins and users with the Privacy Protection - Unblur permission can unblur from the Detail Page; after clicking Unblur, select one or more detected persons.
- Images processed before enabling cannot be blurred retroactively.
- Requires **double the storage**.
- Enabling or disabling **restarts the system**.
- Head blurring requires contacting a Vaidio representative.

## 12. Additional settings, SSL and map server [S4]

System > Setting > Additional Settings:
- Counting: Object Counting Reset Time, Object Counting Occupancy toggle.
- SSL Certificate: upload Private Key (.key), Public Certification Key (.crt/.cer/.pem), optional Certification Chain (.crt/.cer/.pem), optional password protection.
- Module: Google Maps API Key, required for Vaidio City (Traffic Management AI Module).

System > Setting > Map Server (custom self-hosted tiles):
- Only **OpenStreetMap XYZ tile format** is supported; the tile server must be reachable from Vaidio; commercial providers such as ArcGIS are not supported.
- URL format: http://<your_server>/osm_tiles/{z}/{x}/{y}.png
- Toggle Apply Custom Map on, enter the base tile URL in {z}/{x}/{y} form, Check Connection, Apply. Turning it off hides the field, reverts to the default map and clears the URL. Only admin users can change it.
- Check Connection confirms only that the URL is reachable. It does **not** validate tile downloads, tile format, directory structure or map responsiveness. An incompatible tile server produces a blank, grey or error map while the rest of the system keeps working; no crash occurs.
- Command Center has the same feature at System > Setting, format http://{ServerIP}/osm_tiles/{z}/{x}/{y}.png, used for Camera > GPS view and Detail Page Map View. Default behaviour uses public OpenStreetMap and needs internet. [S12]

## 13. AI models [S4]

System > AI Model - Upload, Apply or Replace.
- The AI model defines which Object Types Vaidio can detect.
- Applying a new AI model **deactivates all cameras**.
- Uploading and activating a model instead of using Replace **erases all camera settings**.
- To Replace an existing model, the new model must include **all** Object Types from the model it replaces.
- Only installed, activated models appear in the per-camera AI Model dropdown. File a Support ticket if a model is missing.
- Edge: Settings > AI Model > Change AI Model; only the Super Admin can change it; changing requires an engine restart of a few minutes; Reset to Default AI Model restores the original. [S15]

## 14. Camera configuration [S4]

Camera > Add Camera. Five supported camera source types: **Camera IP Address, RTSP, Camera APP, External, Video File**.

| Field | Notes |
|---|---|
| Camera Name | Only these special characters are allowed: . _ - , |
| Group | Optional; each group holds up to 100 cameras and each camera can belong to 10 groups |
| IP/Domain Name + Port | ONVIF default port 80; then Get RTSP to pick the stream |
| User Name / Password | Camera credentials |
| FPS | Camera, Estimated, or Manual (enter a value) |
| TCP/UDP | TCP (reliability), UDP (speed), or Both |
| Detail Extraction | Standard (default), Plus (3x resources), Ultra (7x resources) - for 4K/8K cameras |
| Internal Video Recorder | Toggle to record on the Vaidio server (IP or RTSP cameras only) |
| VMS/NVR + Channel ID | Link an added NVR to enable playback |
| Location Type | None, GPS Map, or Indoor Map |

Use **Preview** to verify connectivity (not supported for Camera APP). Camera APP requires mapping IDs identical to the Vaidio Cam ID and supports FR and LPR analytics only. External connects a camera from Network Optix, Digital Watchdog or Hanwha Wave VMS.

Auto Discovery finds ONVIF-compliant cameras on the same network; supply credentials to add.

Camera Auto Configuration uses AI to recognise scenes and optimise engines and settings. It applies only to: Age & Gender, Cross Camera Tracking, Face Recognition, Intrusion, License Plate Recognition, Make & Model Recognition, Person Fall. Flow: Camera > Camera Auto Configuration > select cameras > AI Engine dropdown > Recommend Analytics > Start Auto Configuration > Start.

Camera Profile (Camera > Edit Camera): Object Type selection (unselected types cannot be searched), Confidence **0.01 - 1.00**, and Min/Max Pixels (red box = minimum, yellow box = maximum for the camera resolution).

General ROI (Edit Camera > General ROI): draw with the pencil icon. General ROI applies to all analytics; other ROIs (Intrusion, FR and so on) must sit inside it; objects outside are not detected. Exclude irrelevant areas such as sky to cut false alarms.

Camera Health Management: Abnormal status covers disconnected, blurred/blocked/repositioned and resolution change. Compare Current View with Normal View, Recalibrate to clear all abnormal history or just the last hour, schedule status checks by whole hours only (45-minute blocks are not allowed), and view up to 30 days of status history.

## 15. NVR configuration and batch import [S4]

NVR > Add NVR: Name, Brand, IP/Domain Name, User Name and Password, then Check Connection and OK. Reasons to connect an NVR: playback for detected events, analysis of recorded footage, sending alerts to the VMS, and importing cameras.

Camera batch import: NVR > select NVR > (…) > Import Cameras, choose an RTSP Port and optional credentials, Check Connection, select cameras, then Import. Vaidio 8.0 and higher support batch import only from VMSs with open network bridges: **Network Optix, Digital Watchdog, Hanwha Wave VMS, Milestone, Mobotix, Genetec**.

Internal Video Recording (from 5.2.0): check licensed recorder channels at System > License > AI Engines; install an additional HDD before requesting recorder licenses; Vaidio 8.0.0+ supports **H.264 and H.265** (H.265 requires a pre-configured camera); enable per camera at Camera > Edit Camera or Add Camera > NVR > Internal Video Recorder; works only for cameras added by IP address or RTSP.

File management: File > Upload Video supports .avi, .mpeg, .mp4, .ogm, .ogv, webm, .wmv, .m4v, .mov, .asx with a **maximum file size of 10GB**; set a start date/time for timeline indexing, pick AI Models and Engines, configure Profile, optional GPS coordinates, description and Transcoding, then Upload. File > Retrieve Video pulls NVR footage for analysis using **Retrieve Time in UTC +00:00**; Object Detection / Search is enabled by default. [S4]

## 16. Alerts [S4][S13]

Flow: Camera > Edit (enable AI Engines, draw ROIs, Save) then Alert > Alert Rule > Add Alert.

| Field | Detail |
|---|---|
| Alert Name | free text |
| Alert Type | plus rule definitions: Camera Abnormal type, List for FR/LPR, ROIs for Intrusion / Object Left Behind, Line Sets for Object Counting / Object Tracking |
| Cameras and ROIs | selection |
| Schedule | weekly, per-day or Everyday, time range or All Day (optional) |
| Cooldown Interval | time between alerts. Setup guide states 10-3,600 seconds; Core Functions guide states 0-3,600 seconds |
| Triggers | optional: view in one place and/or push to an external device (VMS, HTTP gate trigger, mobile) |

Alert types available for rules: Camera Abnormal (disconnected, blurry/blocked/repositioned, resolution change), Crowd Detection (over 30 people), Dwell, Face Recognition, Intrusion Detection, License Plate Recognition, Object Counting, Object Detection, Object Left Behind (1-3,600 seconds), Object Wrong Direction, Person Fall (abnormal floor position for more than 10 seconds), Scene Change. [S13]

Reuse triggers with Add Alert > Trigger (Optional) > Open Existing Trigger, select by Last Modified date, Alert Name or Trigger Type, then Apply. Alert Acknowledgement (System > Setting > Advanced) adds Unclaimed / Claimed / Cleared states. Alert display modes: Grid View, Floor Plan, Live View, Map View (default Map View). Alert History exports to .xlsx. [S13]

## 17. Users, groups and permissions [S4]

User > User Account > Add User: User Name, Activate/Deactivate, Password and confirmation, Email, Role (User or Admin), User Group, optional Expiration Date. **Accounts in an undefined group have no access to any function and cannot log in.**

Account types:

| Capability | Admin | Co-Admin | General User |
|---|---|---|---|
| Add/delete users | Manage | Manage (except Admin) | None |
| User role and group | Manage | Manage | None |
| User password and email | Manage | Manage (except Admin) | Own only |
| Camera control | Manage | Manage | Per group permission |
| Video source control | Manage | Manage | Per group permission |
| AI engines control | Manage | Manage | Per group permission |
| Configuration control | Manage | Manage | Per group permission |

User Group > Add Group: select users, name the group, and enter the **External Identifier** if using LDAP Group Mapping or Entra ID SSO (otherwise leave blank).

Permission Control tab: Camera Control, Video Source Control, AI Engines Control, Configuration Control (add cameras, manage alerts, enable/disable Privacy Protection blur/unblur).

AI Engine permissions (9.3): per-engine **None / View / Manage** for each user group. None hides the engine, its pages, filters and results; View allows viewing detections and results but no configuration; Manage gives full access including metadata management. FR and LPR additionally support **List Permissions** (None / View / Manage per individual list) - with None, list entries do not trigger detections, matches or alerts.

## 18. Command Center, Vaidio Data and Edge settings

Command Center - System menu: [S12]
- General: HTTP/HTTPS ports, Force HTTPS Secure Connection, base Web URL for password-reset links.
- Storage: usage plus retention period.
- Audit Trail: login history, user activity, source IP, export .xlsx.
- Access Key: the key a device needs to register as a node. Click Show to reveal; Generate New Access Key only if none is listed - once activated by a node it cannot be regenerated (a warning appears).
- Mail: SMTP IP/Domain, optional user name and password, secure connection, Send test email, Apply.
- Setting: Alert Image Source from Node = **Original File** (image stored in both CC and node) or **Image URL** (URL only, image stays on the node); Show License Server toggle; Node Configuration toggle for daily backup plus backup time; Alert acknowledgement toggle; Custom Map server toggle.
- Local CC alert rules default limit is **128**; request an increase through a support ticket. Local CC alerts support HTTP and email notifications only.
- CC supports 4 languages (English, Traditional Chinese, Vietnamese, Spanish); Core supports 11.

Vaidio Data: [S10]
- Add nodes at Nodes > Add Node: Node Name, Core IP or domain, Core admin user name (default admin) and password, then Connect To The Node. Complete the Advanced (Database Setting) section only if Vaidio Data uses database credentials distinct from Core - contact Support.
- In clustered environments connect **each** Core node to Vaidio Data individually.
- System: storage usage, retention, backup and restore, HTTP/HTTPS port configuration, theme, Export Log.
- Users: Access Level is **Editor** (full access) or **Viewer** (view-only Dashboard and Camera Overview); user groups carry a name, colour and camera scope.

Edge (Tunable Edge 9.0.0): [S15]
- Settings tabs: Restore & Export Configuration, License, SMTP, Log, Audit Trail, Storage, Federation, User Management, Authentication (SSO), Additional Features, AI Model, TED (prompt setup).
- Federation: Settings > Federation, enter CC IP/Domain Name and Access Key, click Register, then Accept in CC.
- Additional Features toggles: Event Replay (video playback), Privacy Protection, Live View, Export Record Limit, SSL certificate, Light/Dark mode.
- Prompt setup: Settings > TED. CLIP (default) allows up to **10 prompt sets** and fires on the highest-probability prompt; GenAI allows up to 10 prompt sets and **1 open yes/no question** and fires on a Yes. Mechanism is **AI Model** mode (default: AI model detects first, then CLIP/GenAI analyses) or **ROI** mode (extracts the user-defined ROI and processes it at predefined intervals).
- Edge user limits: 10 users total, at most 1 Super Admin; the default admin is the Super Admin; non-admin users can only view Log in Settings.
