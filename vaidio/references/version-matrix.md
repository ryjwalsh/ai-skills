# Vaidio - Version Matrix, Sizing and Lifecycle

## 1. Release timeline

| Version | Date | Notable content | Source |
|---|---|---|---|
| 9.0 (9th generation, rebrand IronYun -> Vaidio) | 2025-03-25 | Camera auto-configuration agent using VLMs (recommends analytics, auto-configures ROI and default parameters); CLIP-based Natural Language Enhancement for search and alerts; dynamic re-tasking of analytics per camera (intrusion by day, LPR by night) | S20 |
| 9.1 | 2025-08-21 | Enhanced Natural Language Video Search on next-generation language models; real-time camera capacity estimation and preview in auto-configuration; Cross-Camera Car Tracking; redesigned UI with full-page analytics views; VMS integrations for AMAG Symmetry CompleteView and IDIS; dwell-time analytics table in Vaidio Data | S17 |
| 9.2 | 2025-12-17 | Kubernetes Ready Architecture with Golden Images; Pod and Component management (clone pods, manage licenses, adjust storage); Vaidio Intelligent Custom Engine using VLMs; Zero Trust items - system-level email MFA, granular list privacy and Hidden Mode; Custom Map Server replacing public OpenStreetMap for offline networks | S18 |
| 9.3 | announced 2026-04-08 (ISC West) | GPU utilisation and distributed inference improvements across worker and dedicated inference nodes; Critical Alerts that bypass silent mode and Do Not Disturb; resource calibration to optimise AI engine resource usage; Edge LPR enhancements; expanded mobile functionality | S19 |
| 10.0 | GA 2026-07-08 | NVIDIA Blackwell and Grace Hopper support; Unified Scalable Architecture (single-container to modular multi-container); up to 3x video processing efficiency and higher channel density per GPU; Recorded Video Analysis for stored VMS footage; Vaidio Vista VLM-powered alert verification (leveraging NVIDIA Cosmos); expanded VMS support with native March Networks and VDG Sense; Command Center global cross-camera search, live view, playback and camera status; expanded object support for crowd detection | S16 |

Older releases referenced in guides but not retrieved as announcements: 4.2.0, 5.0, 5.1, 5.4, 6.2, 7.0, 7.1. [S23]

## 2. Feature-to-version map (from admin guides)

| Feature / behaviour | Introduced or changed in | Source |
|---|---|---|
| Jumbo (multi-version) upgrades supported | 5.0.0 and later | S2 |
| Internal video recording on the Vaidio server | 5.2.0 | S4 |
| Video Search removed from Edge Platform Software | EPS 5.4.0 and higher | S15 |
| Ubuntu 16.04 support dropped | 6.2.0 | S2 |
| Step upgrade required for systems older than 6.2.0-1 | 6.2.0-1 | S2 |
| Command Center supports 100+ nodes | 6.2.0 | S12 |
| Federation nodes must be 6.1.0+ to connect to CC 6.1.0+ | 6.1.0 | S12 |
| SSO with Microsoft Entra ID (formerly Azure AD) | 7.1.0 | S7 S4 |
| API calls required exposing database passwords | 7.2.0 and earlier | S4 |
| API keys replace password sharing | 8.0.0 | S4 |
| Camera batch import from VMSs with open network bridges | 8.0 | S4 |
| Internal recorder supports H.264 and H.265 | 8.0.0+ | S4 |
| Admin User Group supports an External Identifier (Entra ID Co-Admin) | 8.1.0 | S7 |
| CC centralised license management for Core nodes (License Server) | 8.1.0+ | S12 |
| CC daily backup of connected Core node configurations | 8.1.0+ | S12 |
| NVIDIA driver 535.183.06 becomes the baseline | 9.0 | S1 S2 |
| Alert scheduling unaffected by daylight saving transitions | 9.1.0+ | S13 |
| Vaidio Data reporting APIs | 9.1+ | S10 |
| CC remote system upgrade of nodes (Core only) | 9.1.0 | S12 |
| LDAP Group Mapping via External Identifier (breaking - see below) | 9.2.0+ | S4 |
| MFA (email OTP), Custom Map Server, Kubernetes-ready architecture | 9.2 | S18 S4 |
| Per-engine None/View/Manage permissions and FR/LPR List Permissions | 9.3 | S4 |
| Critical Alerts in the mobile app; enhanced LPR alert detail view | 9.3.0 | S19 S14 |
| Modular multi-container architecture; Recorded Video Analysis; Vaidio Vista | 10.0 | S16 |

## 3. Breaking changes and deprecations

| Change | Version | Impact and action | Source |
|---|---|---|---|
| LDAP users, including LDAP admins, may lose access until External Identifiers are mapped | 9.2.0+ | One-time post-upgrade configuration by a local Vaidio Admin: User menu > User Group > Edit Groups > add the LDAP External Identifier to each group. Group membership must match via memberOf | S4 |
| AI models without version 7.2 or higher in the name stop working | after upgrade | Obtain updated models from Support before upgrading; Power Model must be updated to 8.2 (current documented build PowerModel-Core-8.2g2-Pro-3.4) | S2 |
| Ubuntu 16.04 no longer supported | 6.2.0 | Contact Support if still on 16.04 | S2 |
| netplan gateway4 deprecated on Ubuntu 22.04 | OS-level | Use the routes syntax instead | S1 |
| Admin Portal requires Python 3.11 | 9.x | Offline upgrades from Admin Portal 9.0.0-1 or older need a manual Python upgrade or the portal will not load | S2 |
| Cameras must be re-enabled after every version upgrade | all | Plan a post-upgrade re-enable step | S2 |
| Single-container architecture replaced | 10.0 | Existing container-based runbooks (container_tool workflows) may not translate directly - verify against 10.0 docs | S16 |
| Licence import/export removed from the Core UI under Kubernetes | VE | License Type shows Kubernetes; use License Manager instead | S11 |

## 4. Compatibility matrix

| Layer | Supported | Source |
|---|---|---|
| Core host OS | Ubuntu 22.04 | S1 |
| Offline installer OS | Ubuntu Server 22.04 (bundled in the image) | S5 |
| Command Center OS | Ubuntu 22.04 | S12 |
| Vaidio Data OS | Ubuntu 20.04 or 22.04 | S10 |
| OS patching stance | Vaidio incorporates Ubuntu 20.04 / 22.04 patches as required and includes OS updates in Vaidio releases; security vulnerability tests run before each release | S22 |
| Browser (Core) | Chrome or Edge | S1 |
| Browser (Vaidio Data, Command Center, Vaidio Manager) | Google Chrome, latest version; 1920x1080; 100% display scaling | S10 S12 S11 |
| GPU families | Turing, Ampere, Ada Lovelace, Hopper (INT8); Blackwell and Grace Hopper from 10.0 | S1 S16 |
| GPU driver | 535.183.06 minimum | S1 |
| Edge GPU / JetPack | Jetson Xavier NX, Orin Nano, Orin NX, AGX Orin; JetPack 5.1.3 | S15 |
| Mobile app | Matching Core version best; backward compatible by one version; not forward compatible | S14 |
| Cluster versions | All nodes must run the same version | S12 |
| Federation versions | Keep all nodes and CC on the same version; 6.1.0+ minimum, 9.2.0+ recommended | S12 |
| VE image versions | Use the same image version across Core instances for product synchronisation compatibility | S11 |
| Cameras | Nearly every ONVIF-compliant IP camera; minimum resolution guidance 720p, typical 1080p; 2-4 CIF at 15 FPS is not recommended | S22 |
| Databases | DBMS not documented | S1 |

## 5. Edge engine version and channel matrix [S15]

Latest supported EPS versions at the time of the Tunable Edge 9.0.0 guide: Intrusion 9.0.0, LPR 9.3.0, Face Recognition 9.0.0, Container ID 9.0.0, Tunable Edge 9.0.0. JetPack 5.1.3. Video Search not included.

| Jetson platform | Intrusion | LPR | Face Recognition | Container ID | Tunable Edge |
|---|---|---|---|---|---|
| Xavier NX (8GB) | 4 ch | 4 ch Parking Lot / 2 ch City Road / 1 ch Highway | 4 ch | 4 ch | - |
| Orin Nano (4GB) | 2 ch | - | - | - | - |
| Orin Nano (8GB) | 4 ch | 4 ch Parking Lot / 2 ch City Road / 1 ch Highway | - | - | - |
| Orin NX (16GB) | 8 ch | 8 ch Parking Lot / 4 ch City Road / 2 ch Highway | 8 ch | - | - |
| AGX Orin (32GB) | 8 ch | 8 ch Parking Lot / 4 ch City Road / 2 ch Highway | 8 ch | - | 3 ch (CLIP) / 2 ch (GenAI) |

## 6. Appliance hardware recommendations [S1]

Published as 'Vaidio v9.1.0 Hardware Specifications Recommendation (10/30/2025)'. Guidance: populate as many memory slots as possible; system storage should use Mixed Use SSDs; AI storage can be SATA 7.2k, SAS 10k or high-IOPS HDD/SSD; prefer hardware RAID over software RAID.

| Model | FF | CPU (or above) | RAM | NVIDIA GPU | H/W model reference | SYS storage | AI storage |
|---|---|---|---|---|---|---|---|
| VSB-110 | PC | i5-9600 / i5-10400 / i5-12500 (>=6C/6T) | 16GB (8GBx2) | RTX 3050-6G/8G or RTX A2000-6GB | Dell 3650 / 3660, PSU >= 460W | 240GB SSD | 1TB |
| VSB-130 | PC | i7-9700 / i7-11700 / i7-12700 (>=8C/8T) | 32GB (16GBx2) | RTX 3060 / 3060Ti / A2000-12GB / RTX 4060 / 4060 Ti | Dell 3650 / 3660, PSU >= 550W | 480GB SSD | 2TB |
| VSB-150 | PC | i7-12700 (>=12C/20T) | 32GB (16GBx2) | RTX A4000 or RTX 4070 Ti Super | Dell 3660, PSU >= 550W | 960GB SSD | 3TB |
| VSB-550-25 | 2U | Dual Xeon Silver 4216 / 4314 (>=16C/32T) | 128GB (16GBx8) | Dual RTX A4000 or Dual RTX 4000 ada | Dell R740 / R750 / 7920R, RPSU >= 1100W | 960GB SSD (2x960GB, RAID1) | 6TB (4x2TB, RAID5) |
| VSB-610 | 1U | Intel Xeon-Gold 5416S (16C/32T) | 64GB (16GBx4) | NVIDIA L4 | HPE DL320 Gen11 4LFF | 960GB SSD (2x960GB, RAID1) | 3TB (4x1TB, RAID5) |
| VSB-620 | 2U | Dual Intel Xeon-Gold 5416S (16C/32T) | 128GB (16GBx8) | Dual NVIDIA L4 | HPE DL380 Gen11 8LFF | 1.92TB SSD (2x1.92TB, RAID1) | 6TB (4x2TB, RAID5) |
| VSB-630 | 2U | Dual Intel Xeon-Gold 6430 (32C/64T) | 256GB (32GBx8) | 4 x NVIDIA L4 | HPE DL380 Gen11 8LFF | 3.84TB SSD (2x3.84TB, RAID1) | 12TB (4x4TB, RAID5) |

Other published minimum specs: Command Center - Ubuntu 22.04, i7-9700 / i7-11700 / i7-12700, 32GB (16GBx2), 480GB SATA SSD system, 2TB SATA HDD AI storage, **no GPU required**. Offline-image minimum - the VSB-110 spec plus 1GbE BASE-T x1. Edge form factors - 126 x 96 x 74 mm (Jetson NX class) and 183 x 135 x 88 mm (AGX Orin class). [S12][S5][S15]

## 7. Sizing rules of thumb documented by the vendor

| Rule | Value | Source |
|---|---|---|
| Pixels on target for detection | about 10 px (roughly 14 ppf for a person); guidance elsewhere states about 20 px | S3 |
| Face Recognition | about 160 ppf minimum | S3 |
| License Plate Recognition | about 40 ppf minimum | S3 |
| Recommended camera resolution | 2MP / 1920x1080; minimum 720p, typical 1080p | S3 S22 |
| Frame rate needed by Vaidio | 8 fps or less depending on the analytic | S3 |
| Detail Extraction cost | Plus 3x resources, Ultra 7x resources | S4 |
| Privacy Protection cost | doubles storage | S4 |
| Storage example | 20 x 1080p streams on a VSB-550, 24 h/day for 30 days, about 18.10 TB | S3 |
| Bandwidth example | 3MP H.264 at 15 fps: 3.2 Mb/s VMS alone, 6.4 Mb/s with Vaidio; 1080p at 4 fps brings the total to about 1.4 Mb/s | S3 |
| VE Core defaults | Maximum Disk Size 20 GB, Storage Retention Period 30 days, Version 9.2.0-1 | S11 |
| Enterprise scale claim | tens of thousands of channels | S11 |
| Deployment time claim | installation and configuration typically about an hour | S22 |

Official calculators: Vaidio **Appliance Calculator** (server and storage needs from selected camera sets and analytics features) and a **Storage Calculator**, both on the Partner Portal, plus per-analytic calculators for Edge Object Tracking, Edge Face Recognition, Vehicle Tracking and Video Search. Third-party tools the vendor points at: calculator.ipvm.com, jvsg.com CCTV lens calculator, cctvcalculator.net, digiever.com/support/calculator.php. [S24][S4][S3]

## 8. Licensing and lifecycle policy [S22][S4][S2]

| Item | Policy |
|---|---|
| License model | Perpetual software license. Licensed analytic features continue to work in perpetuity; licensing is per analytic engine channel, and Internal Video Recorder channels are counted separately |
| Activation | Export a .info system information file, request a .key through the Support Portal, upload via System > License > Renew |
| Maintenance | 15% annual software upgrade and maintenance (hot-fixes and version upgrade protection) plus 5% annual hardware warranty and maintenance (DOA/RMA parts and 5x8 remote technical support). Both mandatory since 2022-01-01, calculated on the net total cost to the integrator |
| Fee stability | Expected to stay at 15% and 5%, but may change; the vendor recommends a 3-year warranty term to lock pricing |
| Warranty gate | An expired warranty blocks upgrades |
| Release cadence | Quarterly, including new analytic engines each release, with OS updates rolled into Vaidio releases |
| Enterprise licensing | Manager license on the master node defines the pool; per-Core analytics licenses are allocated and revoked from License Manager. After Manager license expiry existing Cores run but new Cores cannot be created |
| Command Center licensing | CC has its own license (model, serial, user count, expiration). From 8.1.0 CC can allocate Core node licenses; a node offline for more than 10 minutes temporarily reverts to a trial license |
| Formal EOL / end-of-support dates per version | **Not documented** - no EOL matrix or support-window policy is published. See known-gaps.md |
| Compliance | GDPR-oriented controls (person and face blurring gated by permission, configurable retention). SOC 2 Type I and Type II attestations announced on the vendor blog |

## 9. Analytic engines documented as available

From the user-guide index and license/alert lists: Container ID, Person Cross Camera Tracking, Crowd Detection, Face Recognition, Face Grouping, Intrusion Detection, License Plate Recognition, Natural Language Enhancement, Object Left Behind, Object Tracking (with Dwell, Object Counting and Object Wrong Direction sub-engines), Object Detection, Person Fall, PPE Detection, QR Code Detection, Scene Change Detection, Specialized Object (including weapons), Smoke/Fire Detection, Traffic Management (Vaidio City), Vehicle Cross Camera Tracking, Vehicle Make/Model Recognition, Age & Gender, People Counting, Vehicle Counting, Heatmap. Edge engines: Edge Container ID, Edge Intrusion Detection, Edge License Plate Recognition, Edge Face Recognition, Tunable Edge, PS Object Tracking. Applications: Parking Management, Multi-Site Command Center, Vaidio Data, DIY Labeling Tool, Mobile Apps. [S23][S4][S13][S15]

Only analytic engines included in the license appear in the AI Analytics menu. Age & Gender statistics are not available in Core - use Vaidio Data. [S4][S10]
