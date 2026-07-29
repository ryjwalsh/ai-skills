# Devices, video and firmware

Source: Setup Guide, Device management section, unless noted. [S6]

## Two ways a device reaches the cloud

| Path | Meaning |
|---|---|
| **Direct-to-cloud (D2C)** | The device itself connects to Genetec cloud services. Requires a corresponding product subscription. Currently documented for Axis, Bosch, Hanwha Vision and i-PRO cameras, and Axis intercoms and speakers |
| **Via appliance** | Cameras, intrusion panels and access-control hardware attach to a Genetec Cloudlink appliance, which brokers to the cloud. Cameras **must be on the same subnet as the appliance** |

Local devices are only discoverable when the appliance sits on the same local network as the device.

## Add device wizard

**Configuration > Devices > Add device**, then choose a Type (Appliance, Camera, Intrusion panel, ...), a Method (Genetec Cloudlink, Direct-to-cloud + manufacturer), and an Activation step that accepts either a scanned QR code or manually typed identifiers.

| Device family | Identifiers required |
|---|---|
| Genetec Cloudlink appliance | Serial number + activation code (QR code on the insert card) |
| Synergis Cloud Link appliance | QR code, or serial number + activation code from the *Add this appliance to Security Center SaaS* insert card |
| Axis Powered by Genetec, Axis D2C | Serial number + **Owner Authentication Key (OAK)** from the *Axis Communications: Owner Authentication Key* document, or the device web interface. **QR-code activation is not supported for Axis devices** |
| Bosch D2C camera | QR code, or serial number + secret key |
| Cameras behind a Cloudlink | IP address, username, password (manual) or automatic discovery |

## Direct-to-cloud onboarding by manufacturer

Common prerequisites for all: confirm the model and firmware against the SDL, make sure the device can reach the required endpoint domains, and **factory reset any device previously activated on another system**.

### Axis

Before adding, verify device compatibility, connectivity to Axis services, that the licence covers the extra device connection (count is on the system's General page in the Subscriptions Portal), and reset if previously enrolled. After adding, the device is created **inactive**; activation starts when you press the device's **control button**, and it installs firmware, downloads updates and brings the device online. Allow up to **15 minutes** for an Axis Powered by Genetec first activation. If you have no physical access, a remote-activation option can be enabled. Adding an Axis Powered by Genetec device also **upgrades its firmware to the latest version** and **generates a new username and password, deleting all previous credentials** - Genetec manages the password from then on. Sign in to the device later via **Devices > select the device > Overview > View credentials**, copy them, then **Open web interface**.

### Bosch

On the camera web page: **Configuration > General > Date/Time** - set the device time zone and time-server address. For Investigation metadata, check **Service > Licenses** for *IVA Pro Appearance* (people) and *IVA Pro Perimeter* (vehicles), restart the camera, then **Alarm > VCA > Configure** in Bosch Configuration Manager, right-click the camera, *Set session authentication...*, re-enter credentials, and select the analysis type. Then add the camera with a QR code or serial number + secret key.

### Hanwha Vision

Download the **Genetec Security Center SaaS Connector** application first. On the camera: **Basic > IP & Port** - either enable *DNS setting by DHCP* or set DNS servers manually, Apply. **Basic > Date & Time** - confirm time zone and DST, then under *System time setup* choose *Synchronize with NTP server* and enter the NTP addresses. Then **Open platform > Open platform**, click (...) and select the Genetec connector.

### i-PRO

Download the **D2C for Genetec Security Center SaaS** extension package and matching firmware from i-pro.com (the D2C for Genetec Security Center SaaS product page). Update firmware, set the time (**Setup > Detailed setting > Camera detailed setting > Basic > Time & date**, either *Set PC time to the camera* or NTP), then **Ext. software > Software mng.** and uninstall any pre-installed packages before installing the D2C extension. If the camera was enrolled elsewhere, factory reset **and** uninstall/reinstall the extension.

## Recording profiles

A recording profile bundles resolution, frame rate, maximum bit rate, recording location and retention so it can be applied to many cameras.

| Profile type | Records to | Notes |
|---|---|---|
| Cloud | Genetec cloud | Optional SD-card failover if the cloud connection is lost; video is uploaded and cleared from the card afterwards. **Video is not playable until it has been uploaded** |
| Appliance | A Genetec Cloudlink appliance | |
| Edge | A local SD card | If a device has two SD cards and both are inserted, only one stores recordings - check the camera web page to see which. **Motion-activated recording is not supported.** No failover if the card fails |

Key rules:

- Up to **37** custom profiles in addition to the three defaults.
- **Recording location cannot be changed after a profile is created** - move cameras to a different profile instead.
- Maximum retention is **1,096 days (3 years)**; use *Custom* to set a value.
- Shortening a profile's retention **immediately deletes** recordings older than the new period, for every associated camera. The same warning applies when re-associating a camera to a shorter-retention profile.
- Video may be deleted if local storage fills or the cloud connection is disrupted or slowed for a prolonged period.
- Using **Custom** settings on a camera disassociates it from its profile; such cameras do not appear in the Recording profiles list.
- Multisensor cameras can be associated **per sensor** (Devices > camera > Sensors tab > sensor > Settings). Sensor-specific custom settings disassociate those sensors from the profile.

Create: **Configuration > Video settings > Add profile**. Associate: **Video settings > select profile > Cameras tab > Associate cameras** (only cameras supporting the profile's recording location are listed). Modify: **Settings > select profile > Properties**.

### Edge recording on Axis D2C cameras

Requires a supported SD card and camera firmware **11.11 or later**. Configure it **only** through the edge recording profiles in the Configuration task - configuring edge recording directly on the camera's web interface causes errors and playback problems. With an edge profile selected, the customer owns the recordings on the card and there is no fallback if the card fails. Review edge storage utilisation periodically.

## Video concepts

| Concept | Behaviour |
|---|---|
| **Read-only camera** | A camera already managed by another VMS, added manually to a Cloudlink appliance. You can record and monitor **H.264** live and playback, and still set the recording profile and camera analytics events, but camera settings show as *Not supported*. Only available when adding cameras manually to a Cloudlink |
| **Dewarping** | Fisheye lenses are auto-detected on enrollment; the only setting is camera position on the camera Settings page. Restart the client to see configuration changes. Dewarp by zooming into a video tile in the **Tiles** task - the Configuration task can display fisheye cameras but cannot dewarp. After dewarping, overlays appear warped. **G64x** exports carry the fisheye configuration so Genetec Portable Video Player, Operation desktop and Security Desk can dewarp; **MP4** exports cannot be dewarped. Supported for cameras federated from Security Center **5.13 or later** |
| **Timeline thumbnails** | Enable *Video thumbnails on timeline* in the camera's recording profile. Hovering the timeline shows a preview; Shift + scroll changes the visible range between **30 seconds and 24 hours**. Dragging scrubs with a full-frame preview. **Only available in the Investigation task and intelligent-search views** |
| **Camera analytics events** | Interpreted outcomes from the camera's analytics engine - loitering, person in zone, intrusion alarm. Includes motion events and object analytics. Enable in *Events and metadata* on the camera Settings tab. Disabling unsubscribes Security Center SaaS; the camera keeps generating them. **Individual event types cannot be turned on or off** |
| **Camera metadata** | Raw or semi-processed observations (object classes such as person, car, truck) that feed **intelligent search**. Enable in *Events and metadata*. The checkbox only appears if the camera and its configuration support it. Individual metadata types cannot be toggled |

Think of metadata as observations and analytics events as decisions based on them. In Security Center SaaS they are used separately.

**Keeping camera features up to date:** Security Center SaaS reads camera capabilities **only at enrollment**. If you later enable a feature on the camera, it stays invisible until you manually synchronise: **Devices > camera > Overview > Access more settings on Camera > Synchronize**. Synchronise is disabled while a camera is offline. No restart of the camera or appliance is needed, but recording pauses briefly for cameras behind a Cloudlink.

## Managing the device list

- Filter by type, status, manufacturer and model. Filter options reflect only what is enrolled. Filters persist while navigating the Configuration task and reset at sign-out. In list view, click column headers to sort.
- **Deleting** a device removes it and all of its data, including recordings, plus associated entities such as doors and cameras. For a camera, deleting one sensor of a multisensor camera deletes all sensors. Deleting an appliance requires typing its name to confirm.
- If you delete a Cloudlink that had intrusion panels, also delete the orphaned **Genetec Intrusion Bridge**: Genetec Configuration desktop > **Intrusion detection** task > Intrusion Manager > *Genetec Intrusion Bridge* tab > select > delete.

## Intercoms

Axis direct-to-cloud intercoms expose a camera sensor and an intercom sensor. **Configuration > Devices > intercom > Sensors**:

- Camera sensor > **Settings** to change video defaults.
- Intercom sensor > **Recipient of calls triggered by call button** - if no user is selected, pressing the button makes a sound but places no call.
- **Device automatically answers incoming calls** lets operators start a conversation with whoever is near the intercom without it ringing.

## Firmware and software updates

The **Updates** page appears in the Configuration task and on the **Maintenance** page of the system in the Subscriptions Portal. It lists devices with pending updates and allows manual installation. Anything not applied manually installs automatically during the maintenance window shown on the page. At time of capture the Updates page supports firmware updates for **Synergis Cloud Link** appliances.

| Device | Downtime during update | Manual update |
|---|---|---|
| Axis Powered by Genetec | First update about **15-20 minutes**, later updates about **7-10 minutes**. Readers do not work and doors do not open during the update | Yes |
| Synergis Cloud Link | About **30-60 seconds**, during which readers and doors are affected | Yes |

### Maintenance windows

| Region / time zone | Window |
|---|---|
| Axis Powered by Genetec - US and Canada, EST (UTC-5) | 02:00-05:00 on the date given in the email notification |
| Axis Powered by Genetec - US and Canada, EDT (UTC-4) | 03:00-06:00 |
| Axis Powered by Genetec - Europe, GMT (UTC+0) | 22:00-01:00 |
| Axis Powered by Genetec - Australia, AEST (UTC+10) | 23:00-02:00 |
| Axis Powered by Genetec - Australia, AEDT (UTC+11) | 00:00-03:00 |
| Synergis Cloud Link - all regions | Consult the maintenance schedule on the **Updates** page of the Configuration task |

## Spot monitor

An external display can be attached directly to a Cloudlink appliance to show one live camera or sensor. Connect the monitor to **video output 1** (an active adapter is needed if the monitor is not natively DisplayPort). Then **Configuration > Devices > appliance > Spot monitor tab**, pick an **Input** camera or sensor, pick a resolution (the recommended native resolution is listed), Save.

Constraints: one external display at a time; one camera or sensor at a time; **live streams only, no playback**; fisheye and 360-degree streams are **not dewarped** on the monitor. After setup the stream shows without signing in to Security Center SaaS.
