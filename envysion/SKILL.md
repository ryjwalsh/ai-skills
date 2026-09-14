---
name: envysion
description: Technician knowledge of Envysion (Motorola Solutions retail/QSR video intelligence) - the Envysion web app (video.envysion.com) and mobile app, EnVR recording appliances, camera provisioning via Device Manager, POS register mapping and loss-prevention reports, Smart Site Protection alarms, panic buttons, cloud archive, System Health, and the Envysion Learning Center (learning.envysion.com) troubleshooting articles (appliance offline, offline IP/analog cameras, EnVR error codes, DHCP). Use whenever Envysion, EnVR, Envysion Insight, video.envysion.com, learning.envysion.com, Smart Site Protection or retail POS-video reports come up.
---

# Envysion (retail video intelligence)

Envysion is Motorola Solutions' cloud video + POS-analytics platform for restaurants and retail. Stores run an **EnVR** appliance (or legacy NUC/Hikvision DVR) with IP/analog cameras; managers use the **Envysion web app** (video.envysion.com) and **mobile app** for live/recorded video, clips, POS-linked reports (discounts, voids, refunds, risk-scored transactions), incidents and audits; **Smart Site Protection** adds alarm monitoring and panic buttons; **Cloud Archive** extends retention. Training and support live in the **Envysion Learning Center** (learning.envysion.com), reached from the Tool Hub "Envysion Training & Support" tile. [S1]-[S3]

## Scope and freshness
Portal verified 2026-09-14; the Learning Center sitemap (≈150 articles) was indexed and four troubleshooting/provisioning articles were read. Article bodies beyond those are not captured - hand over the article URL.

## Quick facts
| Item | Value | Src |
|---|---|---|
| Learning Center | https://learning.envysion.com (Browse Articles, Troubleshooting, Installation Support = /report-problem/, Contact Us = /contact/) | S1 |
| App | https://video.envysion.com/ ; Envysion mobile app (iOS/Android) | S2 |
| Support | 1-877-258-9441 option 1; in-app Report A Problem / chat | S3 |
| EnVR reboot | hold power 5 s → wait 30 s → press power → up to 10 min to reconnect | S3 |
| Cloud Archive health | green current · yellow 24-40 h behind or 1-3 errors · red >40 h or >3 errors | S1 |
| Camera provisioning | Envysion app > site page > Recording Device (EnVR dropdown; light text = not selectable) > Next > select cameras (creds for existing) > clipboard icon keeps IP, profile "Record Only" keeps password > Save | S2 |

## Answer contract
Name the surface (Envysion web app, mobile app, EnVR hardware, PoE switch, Learning Center) and give the steps in order; for hardware issues start with the least invasive check (internet, cables, PoE port LEDs, single-port reseat, switch reboot, EnVR reboot) before escalating to support. Cite the Learning Center article slug from `references/learning-center-index.md`.

## Where to look
| Question | Open |
|---|---|
| Any topic → article URL (admin/user setup, video, clips, cloud storage, device management, installation, equipment FAQ, system health, Smart Site Protection, panic buttons, reports, incidents, mobile) | `references/learning-center-index.md` |

## High-frequency answers
| Question | Answer |
|---|---|
| EnVR / appliance offline | confirm store internet → reseat power/network at EnVR, switch, outlets → reboot EnVR (5 s hold, 30 s, power on, ≤10 min) → flowcharts for boots-but-no-network / power-but-no-boot / no-power → support 1-877-258-9441 opt 1 (article equipment-faq/appliance-offline) |
| IP camera offline | find PoE switch behind EnVR → check port LED (solid/no light = problem) → unplug camera cable 2-3 s and reseat → if whole switch dark, power-cycle switch → support (equipment-faq/offline-ip-cameras) |
| Analog camera offline / identify camera type | equipment-faq/offline-analog-cameras ; how-to-identify-if-your-site-has-analog-or-ip-cameras |
| EnVR error codes / won't power on / keeps restarting / frozen | equipment-faq/envr-error-codes, envr-will-not-power-on, frequently-restarting-appliances, frozen-envr-or-camera |
| Set appliance to DHCP | equipment-faq/update-the-appliance-to-dhcp-address |
| Add / provision cameras | device-management/camera-discovery, camera-discovery-2/manually-add-a-camera, physical-installation-procedures/device-manager-dm-camera-provisioning-multiple-envrs |
| Replace an appliance | device-management/appliance-replacement |
| Map POS registers to cameras | device-management/register-mapping |
| Users, roles, access lists, SSO | administrative-user-setup/* |
| Cloud Archive behind / errors | cloud-storage/troubleshooting (check EnVR online + bandwidth indicator) |
| Alarm/monitoring setup (Smart Site Protection) | smart-site-protection/configuration-navigation, setting-the-store-schedule, alarm-event-notification-rules |
| Panic buttons | panic-buttons/* |
| Report a problem / installer support | learning.envysion.com/report-problem/ |

## Working rules
- Facts trace to `sources.md`; article bodies not read are cited by slug only - do not invent menu paths inside the Envysion app.
- Read-only knowledge; never instruct changing store configuration without the site admin.
