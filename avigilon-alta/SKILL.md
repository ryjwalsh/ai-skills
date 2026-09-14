---
name: avigilon-alta
description: Tier 1/2/3 technician knowledge of Avigilon Alta - the cloud platform formerly Openpath (Alta Access) and Ava Aware (Alta Video): Alta Access web app (alta.avigilon.com) sites/entries/entry states/lockdown/credentials/rules/alarms, Access Control Core, Single Door Controller, Smart Hubs, expansion boards, Smart Readers, Video (Intercom) Reader Pro, Intercom Touch, Mercury boards under Alta, provisioning with the Alta Access mobile app, Static Cloud IP, firmware/OS updates and LED codes; Alta Video cloud VMS, cloud-native cameras, Cloud Connectors, SD cards, logs, ports/domains, licenses; Alta DMP, Alta Protect, Alta Open / Alta Access mobile apps. Use whenever someone mentions Alta, Openpath, Ava, ACU, SDC, Smart Hub, Alta Open app, DMP, Cloud Connector, or asks where a setting is in alta.avigilon.com - even if they just say "Avigilon cloud access control".
---

# Avigilon Alta (Alta Access, Alta Video, Alta Protect, DMP)

Avigilon Alta is Motorola Solutions' cloud-native security platform. **Alta Access** (formerly Openpath) is cloud access control: controllers (Access Control Core "ACU" in Smart Hub enclosures, Single Door Controller "SDC"), readers and video intercom readers managed in the Alta Access web app and provisioned with the Alta Access mobile app; end users unlock with the Alta Open app, cards, PINs or Apple Wallet. **Alta Video** (formerly Ava Aware) is the cloud VMS for Avigilon Alta cloud-native cameras and third-party cameras via Cloud Connectors. **Alta Protect** adds intrusion/monitoring, **Alta DMP** is the partner deployment-management portal. [S1]

## Scope and freshness

Built from the Avigilon Documentation Center (docs.avigilon.com) captured **2026-09-14**: the Alta Access admin guide, advanced configurations, Alta Video documentation, the Access Control Core / Single Door Controller / 8-Door Large Smart Hub install guides, plus TOCs of the mobile-app, integration, reader, hub and visitor/mailroom guides (137 Alta bundles indexed). Alta is continuously delivered - labels can shift; say so when a path may have moved. [S1]-[S12]

## Quick facts

| Item | Value | Src |
|---|---|---|
| Web apps | Alta Access / Alta Video / Alta Protect: `alta.avigilon.com/signin` (pick org + region); legacy URL form `access.alta.avigilon.com/o/<orgId>/…` (orgId after `/o/`); DMP: `dmp.alta.avigilon.com` (partners) | S2, S4 |
| Support | support.avigilon.com (New Support Ticket, Check Ticket Status); Alta Access support (844) 673-6728 ext 2, altaaccesssupport@motorolasolutions.com | S4, S2 |
| Password rules | Alta Access ≥15 chars w/ upper, lower, number; MFA prompted on first sign-in; SSO "namespace" prompt = more than one IdP, e.g. `org:company` | S2 |
| Controller network | DHCP Ethernet; outbound TCP 443 (dynamic cloud IPs), UDP 123 pool.ntp.org, UDP 53 if external DNS; video readers/Intercom Touch add UDP 3478 + 50000-60000; no inbound forwarding, no TLS inspection; Static Cloud IP needs Enterprise license | S2 |
| Controller LED | solid green OK · cyan booting · solid yellow restoring · blinking yellow updating (>3.5 h = stuck) · solid blue unprovisioned · blinking/solid purple mobile-app pairing · blinking red no internet · solid red error; SDC uses solid **white** for OK | S5, S6 |
| Hard reset (installers only) | power off > hold Admin button > power on > hold 15 s until yellow > release > wait for blue > reprovision | S5, S6 |
| Mercury default | 192.168.0.251 admin/password (S1 DIP switch ON, 5-min window), host port 3001, TLS Required, Communication Address 2 | S5 |
| Camera cloud domains | TCP/UDP 443 to *.aware.avasecurity.com, *.alta.avigilon.com, *.dmp.alta.avigilon.com, *.motorolasolutions.com, *.calipsa.io, *.geo-turn.aware.avasecurity.com, upgrades.video.alta.avigilon.com, *.storage.aware.avasecurity.com; Smart Path UDP 32768-65535 | S4 |
| Camera local ports | 443 HTTPS UI, 22 SSH (closable), 554 RTSP / 322 RTSPS (enable in Alta Video first), 5353 mDNS | S4 |
| Camera factory reset | hold hardware reset ~10 s until LEDs light (Support-directed; wipes config) | S4 |

## Answer contract

Give a full breadcrumb starting with the app, then the top-nav item, page, tab/card and field:

> To change an entry's default state, sign in to **Alta Access**, go to **Sites > Entries > [entry] > ENTRY BEHAVIOR > Default state**, pick e.g. *Standard Security*, optionally assign a schedule, and **Save**.

Rules:

- Name the app (**Alta Access web**, **Alta Access mobile app**, **Alta Open app**, **Alta Video web**, **Alta Video mobile**, **DMP**, **camera local UI**, **Mercury Configuration Manager**).
- Use `[site]`, `[entry]`, `[ACU]`, `[user]`, `[camera]`, `[deployment]` placeholders.
- Say which license tier a feature needs (Basic / Premium / Enterprise; Static Cloud IP and some readers are Enterprise-only) and which hardware generation (Core Series vs first-gen Red Board OP-AS-01).
- For hardware, give the LED meaning and the least destructive step first (soft reset 30 s power + router reboot) before any hard reset.
- Cite the bundle topic in brackets; if it is not in the references, point to the bundle in `references/techdocs-index.md` and say the page was not captured.

## Product map at a glance

| App | Top navigation |
|---|---|
| Alta Access web | Home (Activity / Alarms / Entry / Device dashboards, custom widgets, Maps, Cameras) · Users (users, access groups, roles, schedules, custom fields) · Sites (sites, buildings, zones, entries, entry states, entry schedules, lockdown plans, anti-passback) · Devices (ACUs, Readers, Wireless locks, Video readers, Video intercom readers, Intercom Touch, Device update management) · Reports · Apps (marketplace incl. Static Cloud IP) · Config (Alerts, Alarms, Badge design, Intercom user directory, Rules, Event definitions) · Admin (Account, Quick start, Licenses) |
| Alta Access mobile app (admins) | Users · Provisioning (Create and provision, Test Internet Connection, Network settings) · Remote/timed unlocks · Lockdown · Guest Pass |
| Alta Open app (end users) | unlock (Wave to unlock, Touch Entry, Remote unlock), Guest Pass, accounts, Apple Watch |
| Alta Video web | toolbar: Video view · Map view · Devices (Cameras / Access / Sensors) · System (Deployment > Settings incl. Licenses & Logs; Cloud Connectors) · Rules · Alarms · Reports; app switcher to Protect/Access |
| Alta DMP | Deployments · Notifications · Users and user groups · Audit logs · Unified users |

## Where to look

| If the question is about... | Open |
|---|---|
| Any Alta Access web path: sign-in/SSO, Quick start, network requirements, ACU/SDC add & register, Static Cloud IP, expansion boards, ports/EOL, readers, entries & entry states, lockdown, credentials (card/PIN/mobile/Wallet/LPR), device update behaviour, alarms/alerts/rules; advanced-config topics list | `references/alta-access-video-navigation.md` (Alta Access section) |
| Hardware: ACU/SDC/8-Port board LED tables, provisioning with the mobile app, offline troubleshooting, hard reset, faulty reader/port test, reader wiring, SDC relay voltage switches, EOL supervision, Mercury boards under Alta | same file (Alta Access hardware section) |
| Alta Video: sign-in, adding cameras (QR/Alta Key), camera LEDs, factory reset, recovery/ONVIF mode, SD card errors, Cloud Connectors, logs/HAR, "failed to communicate" checklist, support case, switching firmware Alta↔Unity, ports/domains, licenses, Alta Access integration, DMP, Protect | same file (Alta Video section) |
| Fast keyword → breadcrumb | `references/where-is-it-index.md` |
| Which of the 137 Alta bundles to hand over (install guides, datasheets, quick starts, integrations) | `references/techdocs-index.md` |
| Sources / capture dates | `sources.md` |
| Not captured | `known-gaps.md` |

## High-frequency answers

| Question | Breadcrumb |
|---|---|
| Add a controller (recommended) | Alta Access mobile app > + > fill > Create and provision (ACU LED blinking purple → solid purple → green) |
| Add a controller in the web app | Devices > ACUs > + > name > Controller type (Core series ACU / SDC / First generation Red Board) > expansion boards > Save; Register > Provision (laptop on same VLAN; Windows needs Bonjour) |
| Bulk create site + ACUs + readers | Admin > Quick start |
| Add a reader | Devices > Readers > + > name > ACU > port > Save |
| Add / configure an entry (door) | Sites > Entries > + > name, zone, Controller > Save > edit: ENTRY BEHAVIOR (default state + schedule), OPENPATH READER (port, Card reading, Wave to unlock, ranges), CONTACT SENSOR, REQUEST TO EXIT (port, NC/NO), relays |
| Wave to unlock false triggers / beeping | Sites > Entries > [entry] > OPENPATH READER > Wave detection range → Far (not Extreme far) |
| Issue a card / PIN / mobile credential | Users > [user] > Credentials tab > add type (Openpath DESFire Encrypted / MIFARE CSN / Schlage / Wiegand ID / Cloud Key / License Plate / Mobile / Mobile Wallet / PIN) > Save > Send (mobile) |
| Find an unknown Wiegand card number | swipe at reader → Reports > Logs > CREDENTIAL DETAIL column |
| Create / trigger a lockdown | Sites > Lockdown plans > + ; trigger from Home quick action, mobile app, credential, rule or alarm; controllers need TCP 443 between them, no NAT |
| Alarms / email-SMS alerts / rules | Config > Alarms > + (severity P1-P5, triggers, filters, actions) ; Config > Alerts ; Config > Rules |
| Controller offline | soft reset (power 30 s + router reboot) → check DHCP/static IP, outbound 443/123/53, patch cable, relay power draw → hard reset only if Support says so |
| Change controller IP / DNS | Alta Access mobile app > press Admin button > Network settings > Configure network manually |
| Firewall allowlist with fixed IPs | Devices > ACUs > [ACU] > CLOUD CONNECTION METHOD > Enable Static Cloud IP (Enterprise + Static Cloud IP app) → provision with mobile app "Provision with Static Cloud IP"; status Home > Device dashboard > STATIC CLOUD STATUS |
| Firmware / OS update | Devices > Device update management > Important update - Action required (2-h window; 90-150 min; never power off; blinking yellow >3.5 h → power cycle then Support) |
| EOL supervision setting | Devices > ACUs > [ACU] > Ports tab > Cable > None / Cut Line Detect / Line Shorted Detect / Both |
| Change an input type (REX ↔ contact ↔ generic) | Devices > ACUs > [ACU] > Ports tab > Port > Input type |
| Add Mercury LP/MP controller to Alta | Configuration Manager 192.168.0.251 (S1 ON) > Network static IP > Host Comm addr 2, port 3001, TLS Required > Apply; then Devices > ACUs > + > expansion board Mercury LPxxxx (IP, port 3001, TLS) > ENABLE |
| Add a cloud camera to Alta Video | scan QR → Sign in to Alta Video → Devices tool; or mobile app Devices > Add cameras > scan QR / Alta Key |
| Camera unreachable ("Failed to communicate") | power/PoE, local UI by IP, switch, cloud vs Cloud Connector model, ONVIF-mode camera must be deleted/re-added, camera re-flashed with Unity firmware |
| Download logs for a support case | Alta Video: System > Deployment > Settings > Logs > Download; camera: Devices > Cameras > [camera] > Settings > Edit settings > Maintenance > Download camera logs; then support.avigilon.com > New Support Ticket |
| Switch a camera between Alta Video and Unity | delete from deployment → camera IP in browser → System > Replace with another version → upload .bin |
| Link Alta Access into Alta Video | Alta Video > Devices > Access > More options > Access systems > Add new server > Avigilon Alta Access > region + Super Admin creds (no 2FA) |
| Check licenses in Alta Video | System > Deployment settings > Licenses tab |

## Working rules

- Facts trace to a source in `sources.md`; anything marked **[INFERRED - verify]** was not read.
- Openpath / Ava names still appear in the UI ("Openpath reader", "OP-" part numbers, "Ava" cameras, "Aware rule"); use the user's term but map it.
- Never invent a route; if unsure, name the nav family and the bundle.
- Destructive steps (hard reset, factory reset, Reinitialize, deleting a camera which resets its credentials) are flagged and only recommended when Support-directed or the guide says so.
- Read-only knowledge: explain where a human changes settings; never instruct an agent to alter a live tenant.
