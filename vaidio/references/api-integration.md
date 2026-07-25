# Vaidio - API and Integration

## 1. What kinds of API exist

| Interface | Type | Auth | Documented at | Source |
|---|---|---|---|---|
| HTTP Alert Trigger (outbound webhook) | Vaidio calls a customer endpoint when an alert rule fires | Vaidio sends No Auth, Basic, or Digest to the receiver | S8 | S8 |
| Vaidio Core API | Inbound REST-style API used by integrators | **API key** (from 8.0.0). Optional API Basic Authentication toggle at System > Setting > Advanced | Base paths and method list are **not documented** in the public guides | S4 |
| Vaidio Data API | Raw-data reporting API (hourly, daily and so on), also used by the frontend | Not documented | Self-hosted OpenAPI docs at http://<IP>/docs (examples: http://172.1.1.1/docs, https://vaidiodata.vaidio.ai:1901/docs) | S10 |
| Vaidio Enterprise Manager API | Adds image versions and version tags for Core images | Not documented | Referenced but not specified | S11 |
| Alert image resource URLs | Partial URLs returned in trigger parameters, prefixed by the caller | Same session/credentials as Core | S8 | S8 |
| ONVIF | Camera discovery and control | Camera credentials | Port 18888 for auto-discovery | S1 S4 |
| RTSP | Video ingest | Camera credentials | Default port 554 | S3 |
| VMS / NVR bridges | Alerts out, video retrieval, embedded search | Per-brand | S21 | S21 |

### API keys [S4]
Before 8.0.0, API calls required exposing database passwords, so password changes broke integrations. From **8.0.0** you create named API keys instead:
1. Select **API Keys** in the sidebar.
2. Click **Create API Key**.
3. Enter a Name, click Create, then view/hide and copy the key.
Related toggle: System > Setting > Advanced > **API Basic Authentication** on/off.

No base URL, endpoint list, request/response schema, pagination or **rate limits** are published for the Core API. Treat all of those as gaps.

## 2. HTTP Alert Trigger - configuration [S8]

Set Trigger Action to **HTTP** on an alert rule. Options exposed by the trigger panel:

| Option | Values / behaviour |
|---|---|
| HTTP Method | GET, POST, PUT, DELETE, PATCH. Image and binary parameters require POST |
| URL | Destination URL; parameters in curly braces are substituted when the alert fires, and may sit in the path, query string, headers or body |
| Params tab | Key/value pairs appended as query string; either key or value (or both) may reference parameters; + adds rows |
| Authorization tab | No Auth; Basic (HTTP Basic header from Account and Password); Digest (HTTP Digest response from Account and Password) |
| Headers tab | Custom request headers as key/value pairs; parameters allowed in key or value. Typical uses are API tokens, content negotiation, routing hints |
| Body tab | Available for POST, PUT, PATCH. Modes: **form-data** (multipart/form-data key/value pairs) and **raw** with Content Type text/plain or application/json |
| Check Connection | Sends a test request without waiting for an alert. **Parameters are not substituted** - brackets are sent literally |

Example URL with substitution:

    https://example.com/alert?camera={cameraName}&time={eventTimeStamp}

The same parameter set is used by email notification templates and NVR/VMS trigger payloads. A parameter that does not apply to the firing alert type is replaced with an empty value.

## 3. Trigger parameters usable with any method, email and NVR/VMS [S8]

| Parameter | Description |
|---|---|
| {alertId} | ID number for each alert triggered |
| {alertImage} | The image file for the alert |
| {alertImageMetadataUrl} | Partial URL for the alert image metadata |
| {alertImageUrl} | Partial URL for the detected alert image |
| {alertRuleName} | Name of the alert rule that triggered |
| {cameraDescription} | Description text configured on the camera |
| {cameraId} | Camera ID that triggered the alert |
| {cameraName} | Camera name that triggered the alert |
| {crowdNumber} | Number of people detected in the scene (Crowd) |
| {detectTime} | How long the object has been present (Dwell) |
| {eventTimeStamp} | Unix datetime of the alert; supports a format string, e.g. {eventTimeStamp%yyyy-MM-dd HH:mm:ss} |
| {faceDetectedAge} | Detected age of the recognised person (e.g. 20-29) |
| {faceDetectedAgeGroup} | Age group category (e.g. adult) |
| {faceDetectedGender} | Gender of the detected face |
| {faceFile} | File path or URL to the detected face image |
| {faceKeyId} | Unique identifier for the detected face |
| {faceSimilarity} | Similarity score against a stored face |
| {faceTarget} | Matched person name, if in a face list |
| {faceTargetBirthYear} | Birth year from the face list |
| {faceTargetCategory} | Face list (category) the target belongs to |
| {faceTargetDescription} | Description from the face list |
| {faceTargetExpiredDate} | Expiration date on the face target record |
| {faceTargetGender} | Gender from the face list |
| {faceTargetId} | Internal UUID of the face target |
| {faceTargetIdentityNumber} | Identity/ID number on the record (employee ID, badge) |
| {gpsLatitude} | GPS latitude of the alert location |
| {gpsLongitude} | GPS longitude of the alert location |
| {hashtag} | Hashtag associated with the alert |
| {hostHttpPort} | HTTP port of the host system; for a remote-server camera, the remote server port |
| {hostHttpsPort} | HTTPS port of the host system; remote server port where applicable |
| {hostIP} | IP address of the host system; remote server IP where applicable |
| {hostSerialNumber} | Serial number of the host system; remote server where applicable |
| {licensePlate} | Detected license plate number |
| {licensePlateAddress} | Address of the plate target from the LPR list |
| {licensePlateCountry} | Country associated with the plate |
| {licensePlateDescription} | Description from the LPR list |
| {licensePlateExpiredDate} | Expiration date on the plate record |
| {licensePlateId} | Unique identifier for the plate record |
| {licensePlateImage} | Path to the detected plate image |
| {licensePlateImageUrl} | Partial URL for the detected plate image |
| {licensePlateRegistrationDate} | Registration date from the LPR list |
| {licensePlateState} | US state associated with the plate |
| {licensePlateTarget} | Target associated with the matched plate |
| {licensePlateTargetCategory} | LPR list the target belongs to, or 'Not in list' |
| {licensePlateType} | Plate classification or type (e.g. disabled plate) |
| {licensePlateVehicleOwner} | Owner from the LPR list |
| {licensePlateVehicleType} | Vehicle type (car, truck, motorcycle) |
| {lineSet} | Name of the line set that triggered (Object Counting, Object Wrong Direction) |
| {lineSetId} | Line set ID |
| {nvrAccount} | NVR account username |
| {nvrChannelId} | Channel ID on the NVR |
| {nvrIP} | NVR IP address |
| {nvrId} | Unique identifier for the NVR |
| {nvrName} | NVR name |
| {nvrPassword} | NVR password |
| {nvrPort} | NVR port number |
| {objectCountIn} | Cumulative count crossing the In line set |
| {objectCountOccupancy} | Occupancy for the line set (in minus out) |
| {objectCountOut} | Cumulative count crossing the Out line set |
| {roiId} | ID of the region of interest that triggered |
| {roiName} | Name of the ROI that triggered |
| {roiUuid} | UUID of the ROI that triggered |
| {sceneId} | Unique identifier for the scene |
| {sceneImageUrl} | Partial URL for the scene image |

**Security note:** {nvrAccount} and {nvrPassword} will place NVR credentials into an outbound request. Only use them against a trusted endpoint over TLS, and prefer omitting them.

## 4. POST-only trigger parameters [S8]

| Parameter | Description |
|---|---|
| {alertImageBase64} | Alert image as a Base64 string |
| {alertImageJpg} | Alert image attached as a JPG |
| {alertImageMetadata} | Metadata related to the alert image |
| {alertImageMetadataBase64} | Alert image with metadata markup, Base64 |
| {alertImageMetadataJpg} | Alert image with metadata markup, JPG |
| {alertObjects} | List of scene objects that triggered the alert |
| {faceFileBase64} | Detected face image, Base64 |
| {faceFileJpg} | Detected face image, JPG |
| {faceTargetFile} | Face target image file |
| {faceTargetFileBase64} | Face target image file, Base64 |
| {faceTargetFileJpg} | Face target image file, JPG |
| {gpsMapImageBase64} | GPS map image with the alert plotted, Base64. **Requires a custom map server** |
| {gpsMapImageJpg} | GPS map image with the alert plotted, JPG. **Requires a custom map server** |
| {licensePlateImageBase64} | License plate image, Base64 |
| {licensePlateImageJpg} | License plate image, JPG |
| {roiRegion} | The ROI within the image where the alert triggered |
| {sceneDetail} | Detailed information about the scene |
| {sceneImageBase64} | Scene image, Base64 |
| {sceneImageJpg} | Scene image, JPG |
| {sceneObjects} | List of objects detected in the scene |

## 5. Special syntax [S8]

Timestamp formatting - append a format pattern after a percent sign:

    http://127.0.0.1/action.cgi?index={cameraId}&timestamp={eventTimeStamp}
    http://127.0.0.1/action.cgi?index={cameraId}&timestamp={eventTimeStamp%yyyy-MM-dd HH:mm:ss a}
    http://127.0.0.1/action.cgi?index=123&timestamp=1605599118000
    http://127.0.0.1/action.cgi?index=123&timestamp=2020-11-17 03:45:18 PM

Nested JSON objects - prefix each nested object with a dollar sign:

    1-layer: ${"camName":"{cameraName}","alertName":"{alertRuleName}"}
    2-layer: ${"camName":"{cameraName}","event":${"alertName":"{alertRuleName}","occurred":"{eventTimeStamp}"}}

Resource URL prefixes (from the vendor examples):
- {alertImageUrl}, {alertImageMetadataUrl}, {licensePlateImageUrl}, {sceneImageUrl} return paths beginning api/trigger-resources/image/... and should be prefixed with **http://192.168.100.100/ainvr/** (substitute your host).
- {faceFile} and {licensePlateImage} return paths beginning image/... and should be prefixed with **http://192.168.100.100/ainvr/samba/**.
- Base64 parameters return values of the form data:image/jpeg;base64,...

Example {alertImageMetadata} payload for an FR alert:

    {"alertType":"FACE_RECOGNITION","faceTargetCategory":"Not in list","faceTarget":""}

{alertObjects} and {sceneObjects} return JSON arrays of scene objects carrying sceneObjectId, objectType, cameraId, datetime, bounding box x/y/w/h, confidence, a metadata object typed com.ironyun.ainvr.persistent.converter.vo.ObjectProperty (colors, face, mask, licensePlate sub-objects), reidConfidence and match. {roiRegion} returns a contour array of x/y points, and {sceneDetail} returns scene fields including sceneId, cameraId, source, datetime, file, latitude, longitude, floorPlanId, storeAt, ainvrId and blurred. [S8]

## 6. Other trigger actions [S13][S15][S12]

| Action | Availability |
|---|---|
| Email notification | Core, Command Center Local alerts, Edge. Requires SMTP |
| HTTP / HTTPS | Core, CC Local alerts, Edge |
| Vaidio mobile app notification | Core only. Critical Alerts bypass Silent Mode and Do Not Disturb; configured in Core when creating/editing an Alert Rule, not in the app. iOS plays sound and vibration even when muted; Android requires the user to grant Override Do Not Disturb |
| Third-party VMS/NVR notification | Core only |
| Open Existing Trigger | Reuse a configured trigger by Last Modified date, Alert Name or Trigger Type |

### Messaging-app webhooks documented for Edge [S15]
LINE - HTTP trigger with Body form-data parameters:
    imageFile = {eventimage}
    message   = ${string}

Telegram - create a bot with @BotFather (/newbot), get the token with /token, get the chat ID from https://api.telegram.org/betoken/getUpdates, then configure an Edge HTTP trigger:
    Method: POST
    URL:    https://api.telegram.org/bot${token}/sendMessage
    Body:   form-data
            chat_id = ${chat_id}
            text    = user-defined string
    To send a photo add: photo = {eventimage}

Note that Edge uses **{eventimage}** whereas Core 9.3.0 uses the {alertImage*} family. Do not mix the two parameter vocabularies. [S15][S8]

## 7. NVR / VMS integration levels [S21]

Vaidio publishes five integration levels with NVR/VMS partners:

| Level | Capability | Partners |
|---|---|---|
| 1 | Vaidio sends alerts | Immix, Synology |
| 2 | Vaidio retrieves video | ACTi, Digiever, Hanwha NVR, Intellicene Symphia, Iveda Sentir, Kedacom, Mobotix, NUUO (Linux), QNAP VioStor, Uniview, Vaidio Internal Recorder, VideoInsight |
| 3 | Vaidio sends alerts and retrieves video | Avigilon, Axis ACS, Bosch, Digifort, Exacq, Ganz CORTROL, Luxriot EVO, Pelco, Qognify Ocularis |
| 4 | Sends alerts, retrieves video, and Vaidio can be accessed as a tab in the VMS to conduct video search | AMAG Symmetry CompleteView, Salient CompleteView |
| 5 | Sends alerts, retrieves video, and enables object search in the VMS UI | Digital Watchdog Spectrum, Geutebruck G-Core & G-SIM, Genetec Security Center, IDIS, Hanwha Wisenet Wave, Mirasys, Milestone XProtect, Network Optix Nx Witness |

Added in later releases: AMAG Symmetry CompleteView and IDIS in 9.1; native March Networks and VDG Sense in 10.0. [S17][S16]

Batch camera import (Vaidio 8.0+) works only with VMSs that expose open network bridges: Network Optix, Digital Watchdog, Hanwha Wave VMS, Milestone, Mobotix, Genetec. Per-brand connection ports are listed in network-ports.md. Brand-specific setup varies; the vendor asks integrators to open a ticket for instructions. [S4][S3]

## 8. Vaidio Data API and node integration [S10]

- From **Vaidio Data 9.1+**, APIs expose raw report data (hourly, daily and so on) and are also consumed by the frontend.
- API documentation is served by the product itself: **http://<IP>/docs** (examples given: http://172.1.1.1/docs and https://vaidiodata.vaidio.ai:1901/docs).
- Node onboarding: Nodes > Add Node with Node Name, Core IP or domain, Core admin user name (default admin) and password, then Connect To The Node. Use the Advanced (Database Setting) section only when Vaidio Data uses different database credentials from Core - contact Vaidio Support.
- In clustered environments each Core node connects to Vaidio Data individually.
- Default ports: HTTP 7000, HTTPS 7001, configurable during installation.

## 9. Command Center node integration [S12][S4][S15]

Registering a device as a CC node:
- Vaidio Core: System > Setting > Select Role > **Node**, enter the CC IP/Domain Name and Access Key, then Register.
- Vaidio Edge: Settings > **Federation**, enter the CC IP/Domain Name and Access Key, then Register.
- Default CC port is **7000**.
- In CC an Accept Node pop-up appears; click OK to approve. Only nodes whose Registration Status is Canceled or Rejected can be deleted.
- The Access Key is found at CC System > Access Key (click Show). Once activated by a node it cannot be regenerated.
- Remote Core nodes must be added individually and cannot connect through the cluster Main node. Each device can belong to only one CC.

## 10. Mobile client integration [S14]

- Two apps: **Vaidio** and **VaidioCam**, both Android and iOS.
- Login requires the server IP address or domain name **plus port number**, then username and password, then the MFA one-time code if MFA is enabled.
- Compatibility: apps work best with the matching Core version, are backward compatible by one version (app 5.4.0 works with Vaidio 5.3.0) and are **not forward compatible** (app 5.0.0 will not work with Vaidio 5.2.0). Disable automatic app updates to avoid mismatches.
- VaidioCam turns a phone camera into a live stream; mapping IDs must match the Vaidio Cam ID, and only FR and LPR analytics run on those streams.
- Biometric login: Settings > Enable Touch ID (Android) or Face ID (iOS), with device biometrics enabled.

## 11. Things integrators ask about that are NOT documented

| Question | Status |
|---|---|
| Core REST API base path, endpoints, schemas | Not documented publicly |
| API rate limits or throttling | Not documented |
| SDK availability (any language) | Not documented; no SDK is referenced in any retrieved source |
| Inbound webhooks (Vaidio receiving events) | Not documented; triggers are outbound only |
| Message-queue or streaming metadata export (Kafka, MQTT, gRPC) | Not documented |
| SNMP or syslog | Not documented |
| API versioning policy | Not documented |

Route all of these to known-gaps.md and the Support Portal rather than inferring an answer.
