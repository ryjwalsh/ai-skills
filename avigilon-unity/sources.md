# Sources

Everything in this skill traces to a bundle on the Avigilon Documentation Center (`https://docs.avigilon.com`, Zoomin platform) captured on **2026-09-14** by reading every topic of the bundle through the documentation site's own page API, then condensing into breadcrumb notes. Portal destinations (S2) were verified by opening the Motorola Solutions Tool Hub tiles the same day.

Base URL for every documentation row: `https://docs.avigilon.com/bundle/<bundle>/page/<topic>.htm`.

| ID | Bundle / origin | Title | Retrieved |
|---|---|---|---|
| S1 | (bundle list API, labelkey avigilon_unity) | Avigilon Documentation Center - 704 Unity-portfolio bundles, titles, labels, update dates | 2026-09-14 |
| S2 | loginvsa.motorolasolutions.com/s/ + support.avigilon.com/s/ | Tool Hub tile destinations; Support Community layout | 2026-09-14 |
| S3 | unity-video-client-8-8 | Unity Video Client User Guide 8.8 (full read; operator search/export chapters skimmed) | 2026-09-14 |
| S4 | unity-video-system-setup-8-8 | Unity Video System Setup User Guide 8.8 | 2026-09-14 |
| S5 | unity-video-system-upgrade-8-8 | Unity Video System Upgrade Guide 8.8 | 2026-09-14 |
| S6 | unity-video-server-8-8 | Unity Video Server User Guide 8.8 | 2026-09-14 |
| S7 | unity-video-software-manager-8-8 | Software Manager User Guide 8.8 | 2026-09-14 |
| S8 | troubleshooting-avigilon-servers | Troubleshooting ACC Software and Hardware Issues on Avigilon Servers | 2026-09-14 |
| S9 | licensing-portal | Licensing Portal User Guide | 2026-09-14 |
| S10 | ip-fixed-camera-web-interface | IP Camera Web Interface User Guide (H5/H6 fixed) | 2026-09-14 |
| S11 | ptz-camera-web-interface | PTZ Camera Web Interface User Guide | 2026-09-14 |
| S12 | camera-configuration-tool-2-18 | Camera Configuration Tool 2.18 User Guide | 2026-09-14 |
| S13 | unity-access-admin-7-22 | Unity Access Administrator Guide 7.22 | 2026-09-14 |
| S14 | unity-access-user-7-22 | Unity Access User Guide 7.22 (TOC + selected topics) | 2026-09-14 |
| S15 | unity-access-hid-mercury-hardware-guide | Unity Access Mercury Hardware Guide (connection, DIP, reset, LEDs) | 2026-09-14 |
| S16 | acc-acm-integration | ACC and ACM Integration Guide (Alarm Gateway, VidProxy) | 2026-09-14 |
| S17 | networking-best-practices | Deploying Avigilon Solutions: Networking Best Practices Guide | 2026-09-14 |
| S18 | avigilon-unity-architecture | Avigilon Unity Reference Architecture | 2026-09-14 |
| S19 | system-hardening | System Hardening Guide for Avigilon Control Center Systems | 2026-09-14 |
| S20 | unity-video-multi-server-site-8-8 | Multi-Server Site Setup Guide 8.8 | 2026-09-14 |
| S21 | unity-video-ipv6-migration-8-8 | IPv6 Migration Setup Guide 8.8 | 2026-09-14 |
| S22 | ai-nvr-2-premium-form-d | AI NVR 2 Premium Form D User Guide | 2026-09-14 |
| S23 | envr2x | ENVR2X User Guide | 2026-09-14 |
| S24 | windows-upgrade-recovery | Windows Upgrade and Recovery Guide for Avigilon Systems | 2026-09-14 |
| S25 | unity-cloud | Unity Cloud User Guide | 2026-09-14 |
| S26 | unity-video-privilege-management-8-8 | Privilege Management User Guide 8.8 (TOC) | 2026-09-14 |
| S27 | unity-video-media-gateway-8-8 | Media Gateway Setup Guide 8.8 | 2026-09-14 |
| S28 | unity-video-federated-authentication-8-8 | Federated Authentication Setup Guide 8.8 | 2026-09-14 |
| S29 | unity-video-license-plate-recognition-8-8 | LPR Setup Guide 8.8 | 2026-09-14 |
| S30 | unity-video-face-recognition-8-8 | Face Recognition Setup Guide 8.8 | 2026-09-14 |
| S31 | unity-video-halo-iot-sensors-8-8, unity-video-z-wave-iot-sensors-8-8, unity-video-visual-alerts-8-8, unity-video-occupancy-counting-8-8, unity-video-crowd-detection-8-8, unity-video-audio-analytics-8-8, unity-video-thermal-analytics-8-8, unity-video-removable-privacy-masks-8-8 | Feature setup guides 8.8 | 2026-09-14 |
| S32 | unity-video-analytics-service-8-8, unity-video-virtual-matrix-8-8, unity-video-player-8-8, unity-video-maps-8-8 | Component user guides 8.8 (TOC + key topics) | 2026-09-14 |
| S33 | unity-video-mobile-ios-4-5 | Unity Video Mobile 4.5 User Guide for iOS | 2026-09-14 |
| S34 | web-endpoint-api | Web Endpoint API (install, port, security, logs) | 2026-09-14 |
| S35 | analytics-sizing-guide, designing-site-for-analytics | Analytics Sizing Guide; Designing a Site with Self-Learning Video Analytics (TOC) | 2026-09-14 |
| S36 | unity-video-release-notes, camera-release-notes | Release notes (TOC, upgrade section) | 2026-09-14 |
| S37 | usb-wifi-adapter | USB Wi-Fi Adapter Web Interface User Guide | 2026-09-14 |
| S38 | system-design-tool-4, acc-acm-unification, unity-access-mobile-1-18 | TOC only | 2026-09-14 |
| S39 | acc-client-7-14 | ACC 7 Client User Guide 7.14 (TOC only, for legacy naming) | 2026-09-14 |
| S40 | unity-video-visible-firearm-detection | VFD guide (index stub; VFD facts come from S3) | 2026-09-14 |

## How to weigh them
- Menu paths come from the 8.8 / 7.22 / 2.18 guides (S3-S16). Older versions keep the same topic paths but labels can differ ("ACC Client", "ACS").
- Network/port facts appear in several guides (S4, S17-S20, S25); where they differ, the System Setup guide (S4) is treated as the master and the difference is noted.
- Hardware LED tables and reset procedures are model-specific (S22, S23); other appliance guides (AI NVR 2X, Premium Plus, Value, ENVR2 Plus, NVR6) were not read - point to their bundle.

## Scope boundary
Not treated as sources: Avigilon Support Community knowledge articles (only their numbers are cited), Pelco/IndigoVision/Alta documentation (separate skills), Avigilon marketing pages, third-party (Dell/HPE) documentation.
