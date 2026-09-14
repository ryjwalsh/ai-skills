# Where is it - keyword to breadcrumb index (Avigilon Alta)

**AA** = Alta Access web app (alta.avigilon.com), **AAM** = Alta Access mobile app (admin), **Open** = Alta Open mobile app, **AV** = Alta Video web app, **Cam UI** = cloud camera local web UI (https://<camera IP>). Captured 2026-09-14. Detail and topic citations are in `alta-access-video-navigation.md`.

| Term the user says | Go to |
|---|---|
| Access groups | AA > Users > Access groups > create; assign in Users > [user] > Access |
| ACU add (single) | AA > Devices > ACUs > + ; recommended AAM > + > Create and provision |
| ACU add (bulk with site) | AA > Admin > Quick start |
| ACU register / provision from laptop | AA > Devices > ACUs > Register > Yes > Provision (same VLAN; Bonjour on Windows; http://<ip>:8080 fallback) |
| ACU offline | soft reset (30 s power + router) → IP/firewall (443, 123, 53)/cable/relay draw → hard reset (installer, Support-directed) |
| ACU hard reset | power off > hold Admin > power on > 15 s until yellow > blue > reprovision |
| ACU LED meanings | see hardware section (green OK, blue unprovisioned, purple app pairing, blinking yellow updating, red error) |
| ACU network settings (static IP / DNS) | AAM > Admin button > Network settings > Configure network manually |
| ACU ports / input types | AA > Devices > ACUs > [ACU] > Ports tab > Port > Input type |
| ADA button | advanced configs bundle ddp/ada-setup.htm |
| Alarms (configure) | AA > Config > Alarms > + |
| Alarms dashboard | AA > Home > Alarms |
| Alerts by email/SMS | AA > Config > Alerts |
| Anti-passback / occupancy limit | AA > Sites > Anti-passback and occupancy (setup, reset on zones/users) |
| Apple Wallet credential | AA > Users > [user] > Credentials > Mobile Wallet > Send |
| Audit / portal audit report | AA > Reports > configure report delivery |
| Badge design | AA > Config > Badge design (keycards / mobile) |
| Buildings / floors / units | AA > Sites > Buildings |
| Camera add (Alta Video) | AV mobile app > Devices > Add cameras > QR / Alta Key; or scan QR with phone camera |
| Camera factory reset | hardware reset button ~10 s (model-specific cover removal) |
| Camera firmware Alta ↔ Unity | delete camera → Cam UI > System > Replace with another version → upload .bin |
| Camera logs | AV > Devices > Cameras > [camera] > Settings > Edit settings > Settings > Maintenance > Download camera logs |
| Camera ONVIF mode | Cam UI / AV camera settings; delete & re-add camera after switching |
| Camera snapshots in Alta Access | AA > Home > Activity > View camera snapshots (unified orgs) |
| Camera status LEDs | Alta Video connection LED, Ethernet LED, power LED, dome alignment LEDs |
| Cloud Connector add / logs | AV > System > Cloud Connectors (claim); logs: System > [CC] > Edit settings > Cloud connector > Maintenance > Download logs |
| Cloud Key / Guest Pass link | AA > Users > [user] > Credentials > Cloud Key; Open app Guest Pass; AAM Guest Pass |
| Contact sensor settings | AA > Sites > Entries > [entry] > CONTACT SENSOR |
| Credentials (all types) | AA > Users > [user] > Credentials tab |
| Custom dashboards / widgets | AA > Home > custom dashboards |
| Custom fields | AA > Users > Custom fields |
| Data residency (EU/CA) | advanced configs bundle ddp/data-residency-*.htm |
| Device dashboard / firmware versions / Restart device communicator | AA > Home > Device (REMOTE DIAGNOSTICS column) |
| Device updates (firmware/OS) | AA > Devices > Device update management |
| DMP login | dmp.alta.avigilon.com (password or SSO; partners) |
| Domains / ports (cameras, Cloud Connectors) | AV docs MoreInfo/ports-cloudcam.htm, ports-cloudconn.htm; AA network requirements page |
| Elevator programming | AA > Sites > Programming elevators; Elevator Smart Hub / 16-Port Elevator board |
| End-of-line supervision | AA > Devices > ACUs > [ACU] > Ports > Cable > EOL setting |
| Entry add | AA > Sites > Entries > + |
| Entry default state / schedule | AA > Sites > Entries > [entry] > ENTRY BEHAVIOR |
| Entry states (custom) | AA > Sites > Entry states > add custom; Geofence toggle |
| Entry schedules / holidays | AA > Sites > Entry schedules |
| Event forwarder / webhook rules | AA > Config > Rules > event forwarder |
| Expansion board add | AA > Devices > ACUs > [ACU] > Add expansion board |
| Executive First-In, two-person rule, mantrap, double-tap | advanced configs bundle (ddp/*) |
| Fire alarm input wiring | advanced configs ddp/fire-alarm-interface.htm |
| Guest access links / webhook URLs | AA > Users > [user] > Generate guest access links |
| Import users CSV | AA > Users > Import users by CSV |
| Intercom call routing / directory | AA > Devices > Video intercom readers > [reader] > Configure call routing; Config > Intercom user directory |
| Intercom Touch | AA > Devices > Intercom Touch (provisioning, ports, audio/video, routing profiles, touchscreen) |
| Keypad PIN | AA > Users > [user] > Credentials > PIN (4-16 digits; masking setting in security settings) |
| License plate credential | AA > Users > [user] > Credentials > License Plate (needs Alta Video LPR integration) |
| Licenses (Alta Access) | AA > Admin > Licenses |
| Licenses (Alta Video) | AV > System > Deployment settings > Licenses tab |
| Lockdown plans | AA > Sites > Lockdown plans; trigger via Home, AAM, credential, rule, alarm |
| Logs (Alta Video deployment) | AV > System > Deployment > Settings > Logs > Download |
| Maps | AA > Home > Maps; AV > Map view |
| Mercury controller under Alta | Configuration Manager 192.168.0.251 → AA > Devices > ACUs > + > Mercury board |
| MFA for readers | AA > Sites > Multi-factor authentication for Avigilon readers |
| Mobile credential activation | AA > Users > [user] > Credentials > Mobile > Send / Resend (7 days) |
| Mobile Gateway (legacy panels) | advanced configs ddp/mobile-gateway-overview.htm |
| Muster reports | AA > Reports > Muster; entry "Use as muster point" |
| Namespace (SSO) / child orgs | advanced configs ddp/using-namespace.htm |
| Occupancy reports | AA > Reports > Occupancy |
| Offline Timeout setting | advanced configs ddp/what-is-the-offline-timeout-setting.htm |
| Openpath reader settings (Wave, ranges) | AA > Sites > Entries > [entry] > OPENPATH READER |
| Quick start | AA > Admin > Quick start |
| Reader add | AA > Devices > Readers > + |
| Reader faulty / port test | measure 12 V, swap terminal blocks with a known-good reader |
| Reader wiring | RS-485 shielded CAT6A preferred, 300 ft (500 ft doubled power pairs), shield to ACU GND one end |
| Remote unlock permission | AA > Users > [user] > Enable Remote unlock |
| Reports (alarms, activity logs, scheduled) | AA > Reports |
| REX settings | AA > Sites > Entries > [entry] > REQUEST TO EXIT DEVICES |
| Roles / permissions | AA > Users > Roles |
| Rules engine | AA > Config > Rules |
| Schlage wireless locks / gateways | AA > Devices > Wireless locks / Wireless lock gateway; entries Cloud gateway device type Schlage |
| SD card errors / format | AV camera settings; Cam UI; SD card errors table |
| Sign in / SSO / password | alta.avigilon.com/signin; ≥15-char password; MFA |
| Site add / zones | AA > Sites > Sites > add; Sites > Zones |
| Site partitioning / landlord-tenant | advanced configs ddp/user-site-partitioning.htm, landlord-and-tenant-configuration.htm |
| SDC relay voltage / wet-dry | SDC voltage switches 12V/24V/DRY |
| Static Cloud IP | AA > Apps (install) → Devices > ACUs > [ACU] > Enable Static Cloud IP → AAM "Provision with Static Cloud IP" |
| Static IP from a computer (controller) | advanced configs ddp/static-ip-from-computer.htm |
| Support ticket | support.avigilon.com > New Support Ticket |
| Third-party QR, keypads, intercoms, Nedap uPASS, AD-400 locks, alarm systems | advanced configs bundle (ddp/*) |
| Unify Alta Access + Alta Video sites/users | AA > Sites > Unify sites; DMP unified users |
| User add / deactivate / delete | AA > Users > Users > + / [user] > Deactivate or delete |
| User schedules | AA > Users > Schedules |
| Video Reader Pro / Video Intercom Reader Pro | AA > Devices > Video readers / Video intercom readers (add, register, recording/ONVIF, storage plan, two-way audio) |
| Wiegand credential / gateway | AA > Users > [user] > Credentials > Wiegand ID (Prox 26-bit or Raw 64-bit; Use for Gateway) |
| Wiegand device wiring on hubs | advanced configs hardware/wiring-to-wiegand-devices.htm |
