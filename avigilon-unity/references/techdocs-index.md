# Official documentation index - Avigilon Unity (docs.avigilon.com)

Captured 2026-09-14 from the Documentation Center bundle list (704 Unity-portfolio entries; ~520 HTML guides, the rest datasheets and quick-start PDFs). Build a link as `https://docs.avigilon.com/bundle/<bundle>/page/<topic>.htm`; the landing page of a bundle is `https://docs.avigilon.com/bundle/<bundle>`. Datasheets and quick starts are PDF "ResourceBundles" reachable at the bundle URL.

**Version suffix pattern:** `-8-8`, `-8-7` … for Unity Video; `-7-22`, `-7-20` … for Unity Access; `-7-14` for ACC 7; `-2-18` … for CCT; `-4-5` for mobile. Unversioned names (e.g. `unity-video-client`) are index pages that point at the versions - always open the versioned bundle. Older versions back to 8.0 / 7.2 exist with the same topic paths.

Backend (useful for automation): `https://docs-be.avigilon.com/api/bundlelist?labelkey=avigilon_unity&rpp=100&page=N`, `/api/bundle/<bundle>/toc?language=enus`, `/api/bundle/<bundle>/page/<topic>` (JSON with `topic_html`).

## Unity Video 8.8 core guides (read in full unless noted)
| Bundle | Title | Use it for |
|---|---|---|
| unity-video-client-8-8 | Unity Video Client User Guide 8.8 | every Client menu, Site Setup, users/groups, licensing, rules/alarms, analytics, ACM link |
| unity-video-server-8-8 | Unity Video Server User Guide 8.8 | Admin Tool, storage, ports, certificates, admin password reset |
| unity-video-system-setup-8-8 | System Setup User Guide 8.8 | deployment checklist, ports, install, antivirus |
| unity-video-system-upgrade-8-8 | System Upgrade Guide 8.8 | ACC 5/6/7 → Unity paths, appliance upgrade, rollback |
| unity-video-software-manager-8-8 | Software Manager User Guide 8.8 | installs, custom bundles, Site Update, firmware |
| unity-video-multi-server-site-8-8 | Multi-Server Site Setup Guide 8.8 | merge/remove, ports, failover, custom certs, site families |
| unity-video-ipv6-migration-8-8 | IPv6 Migration Setup Guide 8.8 | IPv6 enablement and troubleshooting |
| unity-video-privilege-management-8-8 | Privilege Management (Unity Cloud users/roles/policies) | cloud org users, groups, roles, policies |
| unity-video-federated-authentication-8-8 | Federated Authentication Setup (Azure/Okta) | IdP setup |
| unity-video-media-gateway-8-8 | Media Gateway Setup | RTSP proxy config.json |
| unity-video-license-plate-recognition-8-8 | LPR Setup Guide | lanes, watch lists, performance mode |
| unity-video-face-recognition-8-8 | Face Recognition Setup | watch lists, privacy |
| unity-video-visual-alerts-8-8 | Visual Alerts (GenAI, AIA2X) | prompts, appliance config |
| unity-video-halo-iot-sensors-8-8 / unity-video-z-wave-iot-sensors-8-8 | Halo 4 / Z-Wave sensors | sensor linking, rules |
| unity-video-occupancy-counting-8-8 / unity-video-crowd-detection-8-8 / unity-video-audio-analytics-8-8 / unity-video-thermal-analytics-8-8 | analytics setup guides | events + rules |
| unity-video-removable-privacy-masks-8-8 / unity-video-privacy-8-8 | privacy masks / privacy user guide | masks, lift privilege, audit |
| unity-video-analytics-service-8-8 | Analytics Service | install/monitor/restart |
| unity-video-virtual-matrix-8-8 / unity-video-player-8-8 / unity-video-maps-8-8 | Virtual Matrix / Player / Maps | display wall, evidence review, maps |
| unity-video-investigators-8-8 / unity-video-security-operator-8-8 | Investigator / Security Operator user guides | search, export, monitoring (not read in full) |
| unity-video-mobile-ios-4-5 / unity-video-mobile-android-4-5 | Unity Video Mobile 4.5 | mobile app connect/troubleshoot |
| unity-video-release-notes | Release notes 8.0.4 → 8.8.1.6 (Jul 2026) | version facts, NVIDIA driver update, OS support |
| unity-video-main-features / unity-video-attribution-report | overview / third-party attributions | - |
| unity-cloud | Unity Cloud User Guide | cloud connect, ports/safelist, site update, health, privilege mgmt, troubleshooting |
| web-endpoint-api | Web Endpoint API | install, port, CORS, logs, webhooks/Socket.IO (topics not all read) |
| licensing-portal | Licensing Portal User Guide | licensing.avigilon.com |
| avigilon-unity-architecture | Reference Architecture | segmentation, clustering, bandwidth |
| networking-best-practices | Networking Best Practices Guide | NIC teaming, VLAN, Docker, troubleshooting |
| system-hardening | System Hardening Guide | BitLocker, FIPS, certs, firewall, STIG |
| windows-upgrade-recovery | Windows Upgrade and Recovery Guide | OS recovery/upgrade on Avigilon hardware |
| troubleshooting-avigilon-servers | Troubleshooting ACC on Avigilon Servers | Dell hardware faults, RAID, logs |
| analytics-sizing-guide / designing-site-for-analytics | Analytics sizing / site design | capacity tables, camera placement |

## ACC 7.14 (legacy) equivalents
acc-client-7-14, acc-server-7-14, acc-system-setup-7-14, acc-analytics-service-7-14, acc-player-7-14, acc-virtual-matrix-7-14, acc-mobile-ios-3-24 / acc-mobile-android-3-24, acc-mobile-migration-3-24, acc-acm-unification (ACC7 + ACM6), acc-acm-integration (Alarm Gateway + VidProxy).

## Integrations (ACC/Unity Video)
unity-video-ccure-3.1-video-integration, unity-video-ccure-3.1-alarm-gateway-integration, unity-video-lenels2-onguard-8.3-video-integration, unity-video-lenels2-onguard-8.3-gateway-integration-guide, unity-video-lenels2-netbox-integration-guide, acc-amag-9.x-integration, acc-gallagher-9.3-integration, acc-edesix-videomanager-integration, acc-halo-integration-guide, acc-ip-speakers-integration-guide, acc-radioalert-integration-guide / radio-alert, access-virdi-biometric-integration.

## Unity Access (ACM) 7.22
unity-access-admin-7-22 (Administrator Guide - read), unity-access-user-7-22 (User Guide, largest), unity-access-alarm-event-7-22, unity-access-enrollment-operator-7-22, unity-access-monitoring-operator-7-22, unity-access-monitoring-supervisor-7-22, unity-access-mobile-1-18, unity-access-release-notes, unity-access-hid-mercury-hardware-guide / hid-mercury-access (Mercury hardware), nvr-setting-up-vm (Unity Access 7 VM getting started), acm-admin-6-50 / acm-user-6-50 + operator guides (ACM 6.50 legacy), acm-release-notes.

## Cameras
Web interface guides: ip-fixed-camera-web-interface (H5/H6 fixed - read), ptz-camera-web-interface (read), fisheye-camera-web-interface, multisensor-camera-web-interface (modular/dual head/multisensor), pro-camera-web-interface, thermal-camera-web-interface, video-intercom-camera-web-interface (H4), zwave-camera-web-interface, presense-detector-web-interface (APD), usb-wifi-adapter, camera-configuration-tool-2-18 (read; older 2.8-2.16), camera-release-notes, unity-gunshot-audio-analytics, l6a-camera-guides.
Installation guides (mounting, reset button, connectors): h6-a-dome-camera / h6-a-bullet-camera (H6A/H6X/H6XP), h6-a-closed-dome-camera, h6-x-box-camera, h6-a-dualhead-camera, h6-a-fisheye-camera, h6-a-ptz-camera, h6-sl-dome-camera / h6-sl-bullet-camera, h6-minidome-camera / h6-minidome-outdoor-camera, h5-a-dome/bullet/box/fisheye/modular/dualhead/corner/thermal/multisensor-camera, h5-a-ptz-camera, h5-ir-ptz-camera, h5-pro-camera, h5-sl-dome/bullet-camera, h5-minidome-camera, h4-multisensor-camera, h4-thermal-camera, h4-video-intercom-surface/recessed-camera, zwave-sensors-installation, poe-switch (8/24-port managed PoE switch).

## Recorders and appliances
ai-nvr-2-premium-form-d (read), ai-nvr-2-premium-plus-form-h, ai-nvr-2-standard-form-d, ai-nvr-2-value, ai-nvr-2x-premium-form-d, ai-nvr-2x-value-form-d, ai-nvr, ai-appliance / ai-appliance-2 / ai-appliance-2x, envr2x (read), envr2-plus-appliance, envr1-appliance, acc-es-recorder / acc-es-analytics-appliance / acc-es-rugged-appliance, nvr6-premium-form-d / nvr6-premium-plus-form-h / nvr6-standard-form-d / nvr6-value-form-d / nvr6-premium-fips / nvr6-standard-fips, nvr5x-workstation, rm7x-workstation, hdva-series-3-3x (HD Video Appliance), hdva3-x-ipmi-kit, hdva-analytics-kit, video-archive-installation / -initialization / -connectivity-kit, nvr-storage-expansion, accessories-for-recorders, hard-drive-accessory-nvr6-form-d / hard-drive-accessory-ainvr-2-form-d, upgrade kits (ai-nvr-2-prm-analytics-kit, ai-nvr-2-prm-plus-analytics-kit, ai-nvr-2-std-performance-kit, ai-nvr-2-value-analytics-kit, ai-nvr-2x-premium-form-d-ank, nvr6-ai-nvr-2x-value-form-d-ank, nvr6-ai-nvr-2-*-10g-kit / -10gbe-kit / -ram-kit / -2nd-cpu-kit, nvr5-prm-10g-kit-*, nvr5-std-10gbe-kit, ai-nvr-std-10gbe-kit, nvr5-value-analytics-kit).

## Motorola Technical Notices (MTN)
global-mtn-0168-26, global-mtn-0128-26 (video management), global-mtn-0205-25, global-mtn-0055-26 (cameras), global-mtn-0219-25 (recorders) - open the bundle URL for the PDF.

## Other portals
- Support Community: https://support.avigilon.com/s/ (articles `/s/article/<slug>`, `/s/contactsupport`, `/s/trust-status`) - KB article numbers referenced in guides: 8555 (NIC best practices), 9804 (change server name/IP), 9988 (BIOS/firmware), 10085 (upgrade to ACC 7), 10202 (Mercury LP battery jumper J19).
- Downloads: https://www.avigilon.com/software-downloads ; OS recovery images: avigilon.com/support/technical/os-recovery ; CCT: avigilon.com/security-cameras/configuration-tool
- Licensing: https://licensing.avigilon.com ; offline activation https://activate.avigilon.com
- Unity Cloud: https://cloud.avigilon.com ; System Design Tool: https://sdt.motorolasolutions.com ; Learning Center: https://learningcenter-vsa.motorolasolutions.com
