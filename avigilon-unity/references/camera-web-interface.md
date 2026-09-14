# IP Camera Web Interface User Guide (bundle ip-fixed-camera-web-interface) — H6A/H6X/H6SL/H6M/H5A/H5SL/H5M/H5A Corner/H5A Explosion Protected
Base: https://docs.avigilon.com/bundle/ip-fixed-camera-web-interface/page/<path>
Companion guides: ptz-camera-web-interface, fisheye-camera-web-interface, multisensor-camera-web-interface, pro-camera-web-interface, thermal-camera-web-interface, video-intercom-camera-web-interface, zwave-camera-web-interface.

## Access
- Browser: Edge/Firefox/Chrome, cookies on. http://<camera IP>/ (also https). Find IP with CCT, Unity or ACC. [initial-setup/logging-into-cameras.htm]
- Factory-default cameras have NO default credentials — first visit redirects to Add user page: username (default administrator), password ≥16 chars, 1 upper, 1 symbol, 1 number; Security group Administrator > Apply. Can also initialize from Unity/ACC/CCT. [initial-setup/initalizing-cameras.htm]
- SSO: "Single Sign-On" on login page (only if configured under Network > Single Sign-On (SSO)). [network-and-security/login-sso.htm]

## Live Preview page
- Zoom in/out, pan, home, auto focus, analytics overlays toggle (needs Analytics XML Metadata on Extended Settings page), switch streams, Download Still from Camera (SD card), SD card status. Zoom/Focus sliders + Auto Focus save automatically. [live-view/live-view.htm]

## General page
- Name, Location > Apply. Device Power State: Force PoE (camera prefers Aux when both connected). Mode: Full feature (default) / High Frame Rate / No Video Analytics / Dynamic Privacy Masks — camera REBOOTS on mode change. Time settings: Time Zone, Automatically adjust for DST. GPS: Latitude/Longitude/Elevation. [general/change-camera-mode.htm]

## Network page (and sub-pages)
- Hostname; DHCP toggle (on by default); IPv6 (Enable, Accept Router Advertisements, DHCPv6 State Auto/Stateless/Stateful/Off, Static IPv6 Addresses, Default Gateway); Enable WS Discovery Protocol (uncheck after commissioning to hide camera); DNS: Use the following DNS server address (Preferred, Alternative 1, 2); Control Ports: Enable HTTP connections; HTTP 80, HTTPS 443, RTSP 554, RTSP replay 555, WebRTC 9090; External NTP Server Configuration: Manual + NTP Server address; MTU size 576-1500 (default 1500); Ethernet Speed/Duplex (Auto negotiation preferred; 100M full duplex), Link tolerance %; Security: Minimum TLS version (1.3 recommended, 1.2 compat), Login session timeout (minutes); Enable WiFi toggle (USB WiFi adapter config hotspot — turn OFF to harden). [network-and-security/network-settings.htm]
- Network > SNMP: Enable SNMP; v2c (Read community, Write community, Trap destination IP, Available traps: Temperature alert, tampering, SD storage) or v3 (username/password; SHA-1 auth, AES). MIB at avigilon.com/support-and-downloads. [network-and-security/snmp.htm]
- Network > DSCP: Activate feature (default on); ONVIF CS2(16), Web AF21(18), SNMP CS2(16), Primary/Secondary stream AF41(34), Tertiary CS3(24), Replay CS3(24); TCP stream uses primary's value for all. Restore Defaults. [network-and-security/dscp.htm]
- Network > Firewall: OFF default; Allow / Deny + IP list; immediate. [network-and-security/firewall.htm]
- Network > MQTT Brokers (H6XP/IoT): Add new broker: Address mqtt://host:port or mqtts:// (no ws/wss), Topic prefix, Username/Password, Certificate ID (from Identity and Trust), QoS 0/1/2, Publish Filter (event sources), Certificate Path Validation Policy. [network-and-security/mqtt-brokers.htm]
- Network > SMTP: Server URL smtps://host:465, Username/Password, Sender Email Address. [network-and-security/smtp.htm]
- Network > IP Filter: Enable IP filter; Allow access (careful — lockout risk) / Deny access; up to 256 entries (+/−); Restore Defaults. [network-and-security/ip-filter.htm]
- Network > WebRTC: STUN servers (stun[s]:host[:port]) or TURN servers (turn[s]:host[:port][?transport=proto]; requires HTTP connections OFF). [network-and-security/web-rtc.htm]
- Network > 802.1x: Protocol PEAP (Configuration name, Identity, Password, Authenticate Server cert) or EAP-TLS (name, Identity, certTLS PEM, Private key PEM, key password > Upload File); first profile auto-enabled; Saved 802.1X configurations > Enable / Remove. [network-and-security/802.1x.htm]
- Network > Encryption Engine: Network (OpenSSL, default) / FIPS 140-2 / FIPS 140-3 (level 1) / NXP TPM (140-2 L3, or 140-3 L3 on newer TPM). Reboots camera (video lost briefly). FIPS camera license required (140-2 L1, TPM L3 modes). TPM tamper error message "Trusted Platform Module tamper error. This camera is untrusted. Power cycle is required." → reboot. [network-and-security/security.htm]
- Network > Identity and Trust (Certificates): list Name/Type/Expiry; Add new certificate: self-signed (Name, Common Name, Valid through years, Country, State, City, Org, OU, Key Type; "create a new validation path upon Save"), client-server via signing request, PKCS#12 (.p12/.pfx + password), PKCS8 (.pem/.crt/.cer/.der + .key/.pem/.rsa), CA certificate. Activating a cert deactivates others for the same service. Download CSR (Common Name, SAN DNS, OU, Org, Locality, State, Country) → .csr. Certificate Validation Paths: Add New Path, order Root CA → Intermediate → End-Entity; can't delete path in use. Certificate Validation Policies: Add New Policy. [network-and-security/certificates.htm]
- Network > TLS: choose certificate validation path per service. [network-and-security/tls.htm]
- Network > Single Sign-On: OpenID Connect provider with JWT access tokens + ONVIF roles claim (onvif:Administrator/Operator/User); verified with Keycloak, Ping One, Entra ID, Okta. Must use HTTPS (Redirect to HTTPS). Fields: Authorization Server address; Client ID, Client secret, Scope; Certificate path validation policy; JWT validation: Supported audiences, Custom claims, Supported Values; JWT signature verification method. [network-and-security/set-up-sso.htm]

## Image and Display
- Live preview readouts: Current Exposure (ms), Current Iris (f/#), Current Gain (dB), Last Known Light Level (EV). Auto focus ROI (blue box; Show Auto Focus Zone toggle; drag/resize). Zoom/Focus sliders, Auto Focus, Image Rotation, Enable Temperature Refocus. [image-and-display/adjust-general-image-settings.htm]
- Image and Display > Day/Night: mode Automatic (Day/Night Threshold EV slider −8..8; blue bar = last light level) / Color / Monochrome / External (via digital input circuit state); IR Enable; Adaptive IR; Night Visibility Check (periodic test; disabling can leave camera in night mode ~30 min longer). [image-and-display/day-night-settings.htm]
- Image and Display > Exposure Settings: Flicker Control 50/60 Hz; Exposure (Automatic or ms); Maximum Exposure (only when Automatic); Maximum Gain; Priority Image Rate/Exposure; Iris Mode Auto/Open/Closed; Exposure Sensitivity High/Medium/Low; WDR toggle; Backlight Compensation Mode; Iris Priority (fixed F-stop; disables WDR/BLC). [image-and-display/exposure-settings.htm]
- Image and Display > Advanced Filters: Enable Digital Defog + Defog Level Low/Medium/High; Image Stabilization (EIS). [image-and-display/advanced-filters.htm]
- Image and Display > Adjustment: Image Rotation 90/180/270; Sharpness (refocus after), Saturation, Contrast, Brightness; Zoom & Focus; White Balance Automatic/Manual (Red/Blue) + Dominant Color Compensation; Temporal Filter Strength (noise averaging). [image-and-display/image-adjustments.htm]
- Image and Display > Overlays: Add overlay: Location, Overlay Type Custom Text (≤64 chars)/Date/Time/Camera Name/Location, formats, Font size 12-80 (default 24), Text/Background color. Burned into downloaded stills. Analytics overlays only via Unity/ACC. [image-and-display/overlays.htm]

## Compression and Image Rate
- WARNING: if camera is connected to Unity/ACC with HDSM, configure streams in the VMS, not the web UI (missing recordings). Changing image rate/compression can reset Self Learning. [compression-and-image-rate/compression-image-rate.htm]
- Per stream (primary/secondary/tertiary/quaternary): Compression standard (H.264 required for onboard storage), Rate control CVBR/CBR, Resolution, Frame rate 1-30 (default 30), Quality (1 best), Max Bitrate 200-12000 kbps, Keyframe Interval 2-64; Multicast Address/Port (even, 1024-65534)/TTL; Enable Maximum Secondary Stream Resolution (reboot); Enable Cropped Quaternary Stream (reboot; ROI stream). RTSP Stream URI / Still Image URI shown read-only. [compression-and-image-rate/general-compression-image-rate-settings.htm]
- Advanced: HDSM SmartCodec toggle (off default; turns on Idle Scene Mode); Idle Scene: Min Image Rate, Keyframe Interval 1-254, Post Motion Delay 5-60 s, Quality 6-20, Max Bitrate. [compression-and-image-rate/advanced-compression-image-rate.htm]
- RTSP: Generate RTSP Stream URI; unicast/multicast; rtsp://<user>:<pass>@<ip>/defaultPrimary?streamType=u (secondary: defaultSecondary). [compression-and-image-rate/RTSP-stream-URI.htm]
- Streaming Settings: ONVIF Media Profile; Video source, Audio source, Metadata (metadata0 / None), Video encoder. [streaming/streaming-settings.htm]

## Motion / Tamper / Analytics
- Analytics > Motion Detection (pixel): Select Zone drag green squares / Select Full / Clear Zone / Clear All Zones; Sensitivity 0-100 (default 50); Threshold 0-100 (default 20); Show Motion in Video; ► Test sends "Test" event to VMS; ONVIF Motion Alarm Enable toggle for 3rd-party VMS. [motion-detection/motion-detection.htm]
- Tamper Detection page: enable/edit tamper events (camera shake). [tamper-detection/tamper-detection.htm]
- Analytics Events: Classified Object Motion Detection ("Smart Motion Rule", created in Unity/ACC, editable here): Object types Person (Hard Hat, High-visibility Vest presence/absence) / Vehicle (Bicycle, Car, Motorcycle, Bus, Large Truck, Pickup Truck, Van); Sensitivity; No. of objects; Threshold Time. [analytics/classified-object-motion-detection.htm]
- Add Event: name; Object Activity types: Objects crossing beam, Objects enter area, Objects leave area, Object loitering, Objects not present in area, Object appears or enters area, Objects in area, Object stops in area, Direction violated, Objects too close (Distance); Behavior Anomaly: Unusual Crowd Growth, Unusual Crowd Size, Crowd size; Sensitivity, No. of objects, Threshold Time, Timeout; ► Test. [analytics/create-new-event.htm]
- Audio Analytics (H6A only; physical mic switch must be ON): Analytics Events > Audio Analytics > Enable > pick sound > Enabled, Sensitivity Low/Medium/High, Timeout 1-300 s (reduce for Gun shot). Gunshot diagnostic logs: https://<ip>/web/setup-debug-audio-analytics.shtml. [analytics/audio-analytics.htm]
- Analytics overlays: Display Object Confidence / Display Object ID (needs Analytics XML Metadata in Extended Settings). [analytics/analytics-overlays.htm]
- Self Learning: Enable Self Learning / Suspend Self Learning / Reset Self Learning (irreversible); stage activity in sparse scenes. [analytics/self-learning.htm]
- Scene Mode: Analytics > Scene Mode: Large Indoor Area / Outdoors. [analytics/scene-mode.htm]
- Inclusion area (green box: blue nodes reshape, green nodes add nodes) + "+ Add Exclusion Area"; Reset Areas (Inclusion/Exclusion/All). [analytics/modify-inclusion-area.htm]
- Audio event types: Scream, Glass Break, Car Alarm, Fire Alarm, Dog Bark, Tire Screech, Metal Crash, Loud Noise, Ultrasound, Gunshot (premium license). [analytics/analytic-event-types.htm]

## Camera Automation (on-camera rules engine)
- Camera Automation > Add New: Rule Name; Trigger: Analytics (Smart Motion Rule / Camera Tampering Rule / Motion Detector / custom events), DigitalInput, Schedules (Started/Ended Schedule), SystemStatus (SystemBooted); Simulate Trigger; Condition Always / Never (disable) / Schedule [name]; Evaluate; Action Digital output / Email / FTP / Sequence; Invoke to test. [camera-automation/rules.htm]
- User-Defined Actions: Sequence (Add sequence: steps with Delay minutes, Category e.g. PTZ, Name e.g. GoHome; Test); Email (Configure SMTP: Server URL, Username, password/app password, sender; Add Email: name, To, Cc, Subject, Body); FTP/SFTP (Configure FTP: Server URL, Username, password or SSH key for SFTP; Add FTP action: Subdirectory, Filename Pattern, File Type Snapshot / hiResSnapshot); Schedules (Add new schedule, drag time ranges; camera local time zone). [camera-automation/sequences.htm]

## Extended Settings (ONVIF)
- Enable Multi-Packet XML Documents; Enable Analytics Options Requests (GetAnalyticsModuleOptions/GetRuleOptions); Enable Analytics XML Metadata (REQUIRED for bounding boxes/overlays); Enable Run-Length Encoding of Motion Mask; Enable Supplemental Events; Enable Singleton Analytics Events. [extended/extended-settings.htm]

## Privacy Zones
- Up to 64 rectangular zones; Add > blue box drag/resize; Blur checkbox (blurred instead of opaque) — removable zones apply only to secondary/tertiary streams; ACC "View high-resolution images" privilege sees unmasked primary (HDSM may switch streams on zoom/full screen; Emergency Privilege Override also unmasks). [privacy-zones/privacy-zones.htm]

## Storage (SD)
- Onboard Storage: Status, Total Capacity, Current Usage, Remaining Capacity; Format Card (reboots); SD card info (Model, Serial, Capacity, Free Space, Measured Write Speed); Card Encryption (formats cards). Records highest-res non-tiled stream (primary); use H.264/H.265. Two-slot cameras record to both. [storage/storage.htm]
- Recording mode: Enable Onboard Storage; "Recording when server connection is lost" (default only records when disconnected from VMS; toggle to record to both); Continuous / On Motion (files ≤5 min or 100 MB); Enable Recording Retention 5 min–2 years. [storage/configure-recording-mode.htm]
- Download recordings: Storage > Recording List (select card, Filter by date) > Download (one by one; keep browser open). Or remove card: disable Onboard Storage > Apply > card reader > "Camera Footage" app on card > Download / Download Selected > reinsert > re-enable. ONVIF Profile G enabled on firmware ≥4.4.0.X (VMS gap fill). [storage/download-recordings-webui.htm]
- SD card failures: persistent failures auto-disable card (prevents reboot loop); overlay "SD card has failed. Format or replace the card" (hide via "Enable SD disabled Overlay" checkbox); replace card (speed test on insert) or "Force Enabled SD disabled" (not recommended). [storage/sd-card-failures.htm]

## Digital I/O
- Digital Inputs and Outputs page: DI Name, Type (Force IRCF — pair with Day/Night mode External / General), Circuit state Open/Closed (some cameras auto-detect), Current State. DO: Name, Circuit state, "IRCF to out" toggle, Duration 100-86400000 ms, Trigger button to test. [digital-inputs-and-outputs/digital-inputs-and-outputs.htm]

## Audio
- Audio page: encoder Opus (default; ACC 6.10+/Opus-capable VMS) or G.711; Device speaker volume 0-31 dB; Gain for microphone 0-31 dB; audio multicast Address/Port(even)/TTL. [audio/audio-settings.htm]

## Users
- Users page: Add new user (Username, Password with strength indicator, Security group user/operator/administrator, Use PTZ controls toggle); edit/delete; "Do not clear usernames or passwords on firmware revert" checkbox (set BEFORE revert); Password complexity: Minimum Length, Uppercase, Number, Symbols (0-128), Lock Password Complexity configuration. Security groups: User = live + PTZ (if granted); Operator = + Image/Display, Compression, Motion, Tamper, Analytics, Privacy Zones, DI/O, Audio, Storage (no format/delete); Administrator = everything incl. General, Network, Camera Automation, Licensing, Users, System, Device Logs. [users/users.htm]

## System
- System page: Firmware Version, Model Number, Hardware Version, Serial Number. Updating Firmware: download .bin from avigilon.com/software-downloads > Browse > Firmware Update (reboot 1-2 min). Reboot button. Clear All Settings (factory reset) with "Preserve Network Configurations" checkbox. [system/system.htm]
- License Management (System > License Management; newer models): Active Licenses (SKU, features e.g. VFD, Gunshot). Add: Activation ID > Activate Now (online) or Add License > Mode Manual > Generate an activation request file > upload at licensing.avigilon.com/activate > download license file > Upload File > Activate Now. Remove License to transfer to another camera. [licensing/add-license.htm]
- Device Logs (System > Device Logs): type Access Logs / System Logs / Kernel Logs (Debug); Minimum Log Level Error/WARNING/Info/Debug; Maximum Number of Logs 100 (default)/250/500/1000 > Update; Download Log (.txt); Download Bug Report (tar.gz). [device-logs/device-logs.htm]
- About: Name, Location, Part number, Orderable part number, Serial, Device UUID, Firmware Version, Vasys version, Build hash, MAC, Licenses, ONVIF conformance, Power source, Operation mode. [web-interface/about.htm]
- Account (bottom-left icon): change password (Old/New/Re-type), Logout; auto logout after 15 min inactivity; SSO logout logs out of IdP too. [user-account/user-account.htm]
- Recovery Mode: after repeated failed boots camera opens simplified UI: upgrade firmware, download logs, reset settings, reboot to CameraApp. [web-interface/recovery-mode.htm]
