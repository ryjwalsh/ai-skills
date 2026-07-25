# Sources

All sources retrieved **2026-07-24** by browsing the vendor documentation site. Entry point was `safr.real.com/guides`, which is a shell page whose iframe loads `docs.real.com/safr/index.html`; all substantive content lives on `docs.real.com`.

Two distinct documentation vintages exist in this set and the difference matters:

| Vintage | Which pages | Stamp |
|---|---|---|
| Older | SAFR Server, VIRGO, and REST API reference pages under `/safr/common/server/safrdocs/` and `/safr/api/` | Documentation Version 3.048, Publish Date August 19 2022 |
| Current | Genetec integration guides and SAFR SCAN guides | Current to 2025 |

Where the two disagree, prefer the newer guide and flag the conflict. See `known-gaps.md`.

Path prefix `SD` = `https://docs.real.com/safr/common/server/safrdocs/`.

## Server, operations and licensing

| ID | Title | URL | Doc version | Applies to | Type | Retrieved |
|---|---|---|---|---|---|---|
| S1 | SAFR Guides index | `docs.real.com/safr/index.html` | n/a | all | Doc index | 2026-07-24 |
| S2 | SAFR Server | `SD/SAFR_Server.html` | 3.048 | SAFR Server | Admin guide | 2026-07-24 |
| S3 | SAFR Server Logging | `SD/SAFR_Server_Logging.html` | 3.048 | SAFR Server | Admin guide | 2026-07-24 |
| S4 | SAFR Support Scripts | `SD/SAFR_Support_Scripts.html` | 3.048 | SAFR Server | Admin guide | 2026-07-24 |
| S5 | SAFR Platform Command Line Install Options | `SD/SAFR_Platform_Command_Line_Install_Options.html` | 3.048 | Platform installer | Install guide | 2026-07-24 |
| S6 | Database and Object Storage Redundancy | `SD/Database_and_Object_Storage_Redundancy.html` | 3.048 | Clusters | Admin guide | 2026-07-24 |
| S7 | Upgrade SAFR Server | `SD/Upgrade_SAFR_Server.html` | 3.048 | SAFR Server | Upgrade guide | 2026-07-24 |
| S8 | SAFR Server Backup and Restore | `SD/Server_Backup_and_Restore.html` | 3.048 | SAFR Server | Admin guide | 2026-07-24 |
| S9 | On-Premises Licensing | `SD/On-Premises_Licensing.html` | 3.048 | On-prem | Licensing guide | 2026-07-24 |
| S10 | Database Memory Configuration | `SD/Database_Memory_Configuration.html` | 3.048 | SAFR Server | Admin guide | 2026-07-24 |
| S11 | SSL Certificates | `SD/SSL_Certificates.html` | 3.048 | SAFR Server | Security guide | 2026-07-24 |
| S12 | SAFR Server Clusters | `SD/SAFR_Server_Clusters.html` | 3.048 | Clusters | Admin guide | 2026-07-24 |
| S13 | Add Secondary Servers | `SD/Add_Secondary_Servers.html` | 3.048 | Clusters | Admin guide | 2026-07-24 |
| S14 | Status Page (Web Console) | `SD/Status_Page.html` | 3.048 | Web Console | Admin guide | 2026-07-24 |
| S15 | View Video Feeds Status | `SD/View_Video_Feeds_Status.html` | 3.048 | Web Console | Admin guide | 2026-07-24 |
| S16 | SAFR System Requirements | `SD/SAFR_System_Requirements.html` | 3.048 | all | Sizing guide | 2026-07-24 |
| S17 | Operator Modes | `SD/Operator_Modes.html` | 3.048 | Desktop Client | Reference | 2026-07-24 |
| S18 | Identity Synchronization Configuration | `SD/Identity_Synchronization_Configuration.html` | 3.048 | SAFR Server | Admin guide | 2026-07-24 |
| S53 | Map Command Line Tool | `SD/Map_Command_Line_Tool.html` | 3.048 | SAFR Server | CLI reference | Listed, not fetched |
| S55 | SAFR Documentation (doc set TOC) | `SD/SAFR_Documentation.html` | 3.048 | all | Doc index | 2026-07-24 |

## VIRGO

| ID | Title | URL | Doc version | Type | Retrieved |
|---|---|---|---|---|---|
| S19 | Service Monitoring | `SD/Service_Monitoring.html` | 3.048 | Diagnostics | 2026-07-24 |
| S20 | Troubleshooting (VIRGO) | `SD/Troubleshooting.html` | 3.048 | Troubleshooting | 2026-07-24 |
| S21 | Service Logging | `SD/Service_Logging.html` | 3.048 | Diagnostics | 2026-07-24 |
| S22 | VIRGO Tools | `SD/VIRGO_Tools.html` | 3.048 | CLI reference | 2026-07-24 |
| S23 | Video Feeds Properties | `SD/Video_Feeds_Properties.html` | 3.048 | Reference | 2026-07-24 |
| S24 | SAFR Video Gateway guide | `docs.real.com/safr/video/software/guides/safr_video_gateway/` | current | Guide | 2026-07-24 |

## REST API

Path prefix `AP` = `https://docs.real.com/safr/api/`.

| ID | Title | URL | Type | Retrieved |
|---|---|---|---|---|
| S25 | SAFR Web API (landing) | `AP/Web_API.html` | API reference | 2026-07-24 |
| S26 | REST API Overview | `AP/REST_API_Overview.html` | API reference | 2026-07-24 |
| S27 | Computer Vision (COVI) REST API | `AP/Computer_Vision_(COVI)_REST_API.html` | API reference | 2026-07-24 |
| S28 | Import a Face from an Image as a New Identity | `AP/Import_a_Face_from_an_Image_as_a_New_Identity.html` | API reference | 2026-07-24 |
| S29 | Retrieve Stored Identities | `AP/Retrieve_Stored_Identities.html` | API reference | 2026-07-24 |
| S30 | Delete Stored Identities | `AP/Delete_Stored_Identities.html` | API reference | 2026-07-24 |
| S31 | Retrieve Images of Stored Identities | `AP/Retrieve_Images_of_Stored_Identities.html` | API reference | 2026-07-24 |
| S32 | Match Images Against Stored Identities | `AP/Match_Images_Against_Stored_Identities.html` | API reference | 2026-07-24 |
| S33 | Computer Vision Events (CVEV) Server API | `AP/Computer_Vision_Events_(CVEV)_Server_API.html` | API reference | 2026-07-24 |
| S34 | Retrieve Events Stored in the Directory | `AP/Retrieve_Events_Stored_in_the_Directory.html` | API reference | 2026-07-24 |
| S35 | Retrieve Images Associated with Events | `AP/Retrieve_Images_Associated_with_Events.html` | API reference | 2026-07-24 |
| S36 | Listen for New Events and Retrieve Them As They Occur | `AP/Listen_for_New_Events_and_Retrieve_Them_As_They_Occur.html` | API reference | 2026-07-24 |
| S37 | SDKs index | `docs.real.com/safr/sdks.html` | SDK index | 2026-07-24 |
| S38 | SAFR Developers | `safr.real.com/developers` | Portal page | 2026-07-24 |

## Genetec integration

| ID | Title | URL | Applies to | Type | Retrieved |
|---|---|---|---|---|---|
| S39 | Genetec Cardholder Integration Guide, plus Synergis Operation, Federated Systems and Troubleshooting sub-pages | `docs.real.com/safr/access/integrations/genetec/genetec_cardholder_integration_guide/` | SAFR 3.28+ | Integration guide | 2026-07-24 |
| S40 | Genetec SaaS Cardholder Integration Guide, 3 pages | `.../genetec_saas_cardholder_integration_guide/` | SAFR 3.28+ | Integration guide | 2026-07-24 |
| S41 | Genetec RIO Integration Guide, 3 pages | `.../genetec_rio_integration_guide/` | SAFR 3.28+ | Integration guide | 2026-07-24 |
| S42 | Genetec Security Center Camera Integration Guide, 2 pages | `docs.real.com/safr/video/software/integrations/genetec/genetec_security_center_camera_integration_guide/` | SAFR 3.6+ | Integration guide | 2026-07-24 |
| S43 | Genetec Security Center SAFR Camera Integration Guide, 6 pages | `.../genetec_security_center_safr_camera_integration_guide/` | SAFR 3.6+ | Integration guide | 2026-07-24 |
| S54 | Integration index pages, access and video | `docs.real.com/safr/access/integrations/`, `docs.real.com/safr/video/software/integrations/` | all | Doc index | 2026-07-24 |

## SAFR SCAN

| ID | Title | URL | Type | Retrieved |
|---|---|---|---|---|
| S44 | SAFR SCAN Admin Guide, section 5, Web Console | `docs.real.com/safr/access/guides/safr_scan_admin_guide_5.html` | Admin guide | 2026-07-24 |
| S45 | SAFR SCAN Admin Guide, section 6, Troubleshooting | `docs.real.com/safr/access/guides/safr_scan_admin_guide_6.html` | Troubleshooting | 2026-07-24 |
| S46 | SAFR SCAN Troubleshooting Guide, 20 symptom sections | `docs.real.com/safr/access/guides/articles/safr_scan_troubleshooting_guide/` | Troubleshooting | 2026-07-24 |
| S47 | Checking Calibration | `docs.real.com/safr/access/guides/articles/checking_calibration/` | Procedure | 2026-07-24 |
| S48 | Calibrating the Structured Light Sensor, 3 pages | `docs.real.com/safr/access/guides/articles/calibrating_structured_light_sensor/` | Procedure | 2026-07-24 |
| S49 | SAFR SCAN Grounding Procedure | `docs.real.com/safr/access/guides/articles/safr_scan_grounding_proceedure` | Procedure | 2026-07-24 |
| S50 | Feedback from Panel, 2 pages | `docs.real.com/safr/access/guides/features/feedback_from_panel/` | Feature guide | 2026-07-24 |

## Cross-product

| ID | Title | URL | Type | Retrieved |
|---|---|---|---|---|
| S51 | SAFR Actions, plus escape sequences page | `docs.real.com/safr/common/actions/manual/safr_actions/` | Feature guide | 2026-07-24 |
| S52 | SAFR Release History | `docs.real.com/safr/common/releases/safr_release_history/` | Release notes | 2026-07-24 |

## Source count by type

| Type | Count |
|---|---|
| Admin / install / upgrade guides | 14 |
| Diagnostics and troubleshooting | 8 |
| API reference | 12 |
| Integration guides | 6 |
| SCAN procedures and feature guides | 5 |
| Sizing / requirements | 1 |
| Release notes | 1 |
| Doc indexes | 4 |
| Portal pages | 1 |
| **Total distinct sources** | **52** |

Counts are of distinct source IDs. Several IDs cover multi-page guides, so the number of individual pages actually fetched is higher, roughly 95.

## Retrieval notes

| Note | Detail |
|---|---|
| Iframe shell | `safr.real.com/guides` returns almost no text; content is in an iframe pointing at `docs.real.com/safr/index.html`. Fetch `docs.real.com` directly |
| Invalid paths redirect to sign-in | A wrong URL under `docs.real.com` does not return 404; it redirects to `safr.real.com/signin`. A sign-in page therefore means *bad path*, not necessarily *gated content* |
| Export-control wall | One page returned an Access Denied wall citing U.S. and applicable Export laws. See `known-gaps.md` |
| Support coverage banner | `safr.real.com` displayed: Your current Support and Updates Coverage is expired. Some downloads may be unavailable to this account |
| Session state | The browsing session was signed in to the SAFR portal |
