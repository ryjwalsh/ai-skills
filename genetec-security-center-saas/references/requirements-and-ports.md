# Requirements, network and firewall ports

All of this comes from the Pre-Deployment Guide unless another source is cited. [S2]

> **Endpoints move.** Genetec publishes both a *recommended* wildcard set and a *current service endpoints* list for most rows. Prefer the wildcards (`*.genetec.cloud`, `*.genetec.com`, `*.gsc-cloud.com`, `*.geneteccloud.com`) so the allowlist survives change. Re-check the live page before finalising a firewall change.

## Presale checklist

Collect, before quoting:

- The customer's internet SLA with their ISP, and any unresolved IT or security objections.
- Confirmation that the features needed are actually supported. **Plugin integrations are not supported.**
- Estimated concurrent users of: the web client, Genetec Configuration desktop, Genetec Operation desktop, and SC SaaS Operation mobile.
- Access control counts: Synergis Cloud Link units, Axis Powered by Genetec units, readers/inputs/outputs, and expected cardholders and credentials.
- Video counts: cameras and models, number of Genetec Cloudlink appliances, and the FPS / resolution / retention targets that determine the subscription package.
- Federation details: video compression (**H.264 only**), static vs dynamic ISP addressing, firewall changes needed, number of remote systems and federated camera connections, upload bandwidth per site, and on-site expansion hardware such as IP door controllers.

To view **H.265 (HEVC) or AV1** streams federated into Security Center SaaS, workstations need an NVIDIA GPU or Intel Quick Sync (11th-generation CPU or newer) plus a current Chrome or Edge.

## Network requirements

- **Latency of 150 ms or less to the closest Azure data centre is mandatory.** High latency degrades remote-site availability. The Azure Storage Latency Test is the suggested way to pick the right region.
- A **99.9%** ISP service level is strongly recommended.
- Bandwidth depends on how many cameras record or play back and whether recording is local or pushed to the cloud. Playback does not reduce the number of cameras that can be viewed at once. None of this applies when the client workstation is on the same network as the camera.

Federation adds:

- Simultaneous federated camera count depends on outbound bandwidth from the remote site, inbound bandwidth to the client, and requested stream quality.
- Remote-site cameras should support **multiple streams** so the outbound stream can be a lower-bandwidth one. Managed (non-federated) devices support only a single stream.

## Client workstation profiles

| | Minimum | Recommended | High-performance |
|---|---|---|---|
| OS | Windows 10 or later, 32-bit | Windows 10 or later, 64-bit | Windows 10 or later, 64-bit |
| CPU | Intel Core 2 X6800 @ 2.93 GHz | Intel Core i7 14700 or better | Intel Xeon W5-2465X or better |
| RAM | 4 GB or better | 32 GB DDR5 or better | 32 GB DDR5 or better |
| Storage | 80 GB HDD for OS + apps | SSD for OS + apps | SSD for OS + apps |
| Free space for clients | 6 GB | 6 GB | 6 GB |
| GPU | 256 MB PCIe x16 | NVIDIA GeForce RTX 4070 (12 GB) or newer equivalent | Dual NVIDIA GeForce RTX 4070 (12 GB) or newer equivalent |
| NIC | 100 Mbps | GbE | GbE |
| Display | 1280x1024 or higher at 96 dpi | - | - |

All profiles require an internet connection; the Minimum profile also calls for Edge updates to be enabled. Administrator rights are not needed to install the clients.

## Reading the port tables

Every table is per data centre. The pattern is identical across regions - only the regional prefix changes. Use this substitution table with the rows below:

| Token | US | Canada | Australia | Europe | UK |
|---|---|---|---|---|---|
| {video} | eastus2 | centralca | eastau | westeu | southuk |
| {tds} | eastus2 | cancentral | australiaeast | westeurope | southuk |
| {blob} | eus2scsaas | cacscsaas | auescsaas | weuscsaas | sukscsaas |
| {iothub} | iothub1914824792 | iothub1887217071 | iothub844650092 | iothub645286700 | iothub3196371746 |
| {dmhub} | genetec-dm-hub-prod-eus2-0 | genetec-dm-hub-prod-cca-0 | genetec-dm-hub-prod-eau-0 | genetec-dm-hub-prod-weu-0 | genetec-dm-hub-prod-suk-0 |
| {appstore} | edgeosprodeus2appstore | edgeosprodccaappstore | edgeosprodeauappstore | edgeosprodweuappstore | edgeosprodsukappstore |
| {fwimg} | prod0eus2 | prod0cca | prod0eau | prod0weu | prod0suk |
| {signalr} | sgnlr-uni-prodglobal-eastus2 | sgnlr-uni-prodglobal-canadacentral | sgnlr-uni-prodglobal-australiaeast | sgnlr-uni-prodglobal-westeurope | sgnlr-uni-prodglobal-uksouth |
| {acbus} | brbjvsf44a7rk | bm4qutho3syfc | d5ikjp5levj7i | mese6xxndjusg | sjrfguy7ssisi |
| Static IPs | 208.88.71.3, 208.88.71.4, 20.157.76.128/28 | 208.88.71.3, 208.88.71.4, 20.157.121.64/28 | 208.88.71.3, 208.88.71.4, 20.47.123.48/28 | 208.88.71.3, 208.88.71.4, 20.157.123.144/28 | 208.88.71.3, 208.88.71.4, 20.47.68.192/28 |

208.88.71.3 and 208.88.71.4 are common to all regions. `{GenetecReference}` is the customer's SCC-nnnnnn-nnnnnn reference from the channel partner. `{TenantID}` comes from the web-client URL.

Blob accounts are numbered 01-16 in every region (Australia lists 01-15) and exist for load balancing and resiliency - allowlist the whole range, not one.

## Direct-to-cloud cameras - outbound

| Port | Destination | Manufacturer | Purpose |
|---|---|---|---|
| UDP 53 | any | all | DNS |
| TCP 443 | `*.genetec.cloud`, `*.genetec.com` (login.genetec.com, {video}.video.genetec.cloud, {tds}.tds.genetec.cloud) | all | Authentication and camera management |
| TCP 554, TCP 1935 | `*.genetec.cloud` (rtsp.{video}.video.genetec.cloud) | video | RTSP over TLS and ICE TCP for WebRTC live |
| TCP 443 | {blob}01-16.blob.core.windows.net | all | Video recording and playback (load-balanced) |
| TCP 1935 | `*.gsc-cloud.com` ({GenetecReference}.gsc-cloud.com) | all | ICE TCP in WebRTC for live streaming |
| UDP/TCP 3478, UDP/TCP 443, UDP/TCP 80, UDP 20000-60000 | turn.video.geneteccloud.com, stun.relay.metered.ca, global.relay.metered.ca | all | TURN and STUN for WebRTC |
| UDP 123 | pool.ntp.org | Axis | NTP |
| TCP 443 | `*.connect.axis.com`, `*-st.axis.com`, s3-ats-migration-test.s3.eu-west-3.amazonaws.com | Axis | Axis camera management (cep.otelcol, eu.prod.otelcol, appinsights, signaling.prod.webrtc, onboardme.prod.oneclick, dispatch{us1,se1,se2,jp1}-st, dispatcher-st) |
| TCP 42000 | dmNNN.cbs.boschsecurity.com (region-specific set) | Bosch | Cloud connection |
| TCP 443 | api.remote.boschsecurity.com | Bosch | Remote portal |
| TCP 80 | http://36.mcg.escrypt.com/crl | Bosch | Certificate revocation list |

## Direct-to-cloud intercoms and speakers - outbound

Open the D2C camera ports **as well as** these:

| Port | Destination | Purpose |
|---|---|---|
| TCP 5061 | `*.{video}.sip.sipelia.genetec.cloud` ({TenantID}.{video}.sip.sipelia.genetec.cloud) | SIP call signalling |
| UDP 20000-60000 | global.relay.metered.ca | Audio and video media |
| UDP 80 | stun.relay.metered.ca | STUN public-address resolution |

## Genetec Cloudlink appliances - outbound

| Port | Destination | Used by | Purpose |
|---|---|---|---|
| UDP 123 | NTP, chosen in this priority: manual entry in the appliance portal, then DHCP, then defaults time1-4.google.com and pool.ntp.org | Edge OS | Time |
| ICMP ping | 8.8.8.8 | Edge OS | Reachability diagnostic |
| UDP 53 | DNS, same priority order; defaults 1.1.1.1, 8.8.8.8, 1.0.0.1, 8.8.4.4 | Edge OS | DNS |
| TCP 443 | `*.genetec.cloud`, `*.genetec.com` ({video}.firmwarerepository.edge.genetec.cloud, login.genetec.com) | Edge OS | Appliance-to-cloud |
| TCP 443 | global.azure-devices-provisioning.net, {dmhub}.azure-devices.net, {appstore}.azurecr.io and its regional data endpoints, {fwimg}fwimages / {fwimg}devicesmgmt / {fwimg}devicesdiags .blob.core.windows.net, eastus2-3.in.applicationinsights.azure.com, eastus2.livediagnostics.monitor.azure.com | Edge OS | Device provisioning, app store, firmware, diagnostics |
| TCP 443 | {video}.video.genetec.cloud, {tds}.tds.genetec.cloud | video | Live, recording, playback |
| TCP 554, 1935 | rtsp.{video}.video.genetec.cloud | video | RTSP over TLS, ICE TCP |
| TCP 443 | tds1-8{tdsHost}.blob.core.windows.net plus {blob}01-16.blob.core.windows.net | video | Recording and playback storage |
| TCP 1935 | {GenetecReference}.gsc-cloud.com | video | ICE TCP WebRTC |
| UDP/TCP 3478, 443, 80, UDP 20000-60000 | turn.video.geneteccloud.com, stun/global.relay.metered.ca | video | TURN/STUN |
| TCP 2624 | {GenetecReference}.gsc-cloud.com | intrusion | Intrusion connection |
| TCP 443 | `*.geneteccloud.com`, google.com, serbus/evhub/evhubback/storsync/storheal/storgatw **nwskuumgkdlgi** endpoints | access control | Cloudlink to Security Center SaaS |
| TCP 443 | serbus/evhub/evhubback/storsync/storheal/storgatw **{acbus}** endpoints | access control | Connection to Synergis |

Note the access-control control-plane host suffix `nwskuumgkdlgi` is the same in US, Canada, Australia and Europe; the UK row lists only google.com and `*.geneteccloud.com`. The per-region Synergis suffix is `{acbus}`.

### Cloudlink to local cameras

| Direction | Port | Purpose |
|---|---|---|
| Outbound | TCP 443, TCP 80 | Camera connections. HTTPS/443 preferred; falls back to HTTP/80 only if secure communication is unavailable |
| Outbound | TCP 554, TCP 1935 | RTSP over TLS and ICE TCP WebRTC |
| Outbound | UDP 3702 | Camera discovery to 239.255.255.250 (multicast) |
| Inbound | UDP 10000-10599 | RTP/RTCP from cameras to the appliance |
| Both | UDP 5353 | Camera discovery |
| Inbound | UDP 20000 | Camera discovery responses |

### Cloudlink to intrusion panels

| Direction | Port | Purpose |
|---|---|---|
| Outbound | TCP 2624 | Intrusion app (Genetec Intrusion Bridge) to the Genetec Intrusion Protocol extension in the cloud |
| Outbound | TCP 7700 | Bosch intrusion panels |
| Inbound | TCP 10002-10005 | Honeywell Galaxy events; opened automatically when a panel is added |
| Outbound | TCP 10005 | Honeywell Galaxy commands. **Not configurable** |

## Synergis Cloud Link appliances - outbound

| Port | Destination | Purpose |
|---|---|---|
| TCP 443 | `*.geneteccloud.com`, google.com, serbus/evhub/evhubback/storsync/storheal/storgatw **nwskuumgkdlgi** endpoints, global.azure-devices-provisioning.net | Cloud connection |
| UDP 123 | pool.ntp.org | NTP |
| TCP 443 | `*.geneteccloud.com`, {iothub}.azure-devices.net, and the **{acbus}** serbus/evhub/... endpoints | Connection to Synergis |

## Axis Powered by Genetec appliances - outbound

Open the direct-to-cloud camera ports too.

| Port | Destination | Purpose |
|---|---|---|
| TCP 443 | `*.genetec.cloud`, google.com, `*.connect.axis.com`, the **nwskuumgkdlgi** endpoints, global.azure-devices-provisioning.net | Cloud connection |
| UDP 123 | pool.ntp.org | NTP |
| TCP 443 | {iothub}.azure-devices.net plus the **{acbus}** endpoints | Connection to Synergis |

## Clients - outbound

**All clients, TCP 443:**

| Destination | Purpose |
|---|---|
| securitycentersaas.genetec.cloud, {region}.securitycentersaas.genetec.cloud (static IPs 208.88.71.3, 208.88.71.4) | Web services |
| login.genetec.com, id.login.genetec.com, assets.login.genetec.com, challenges.cloudflare.com | Genetec SSO |
| login.microsoftonline.com, aadcdn.msauth.net, login.live.com | Microsoft sign-in |
| events / app / clientstream .launchdarkly.com | Genetec feature management |
| {signalr}.service.signalr.net, canadacentral-1.in.applicationinsights.azure.com | Monitoring and eventing |
| api-js.mixpanel.com | Product analytics |
| app.productfruits.com, my.productfruits.com, wss://ws2.productfruits.com | Product-adoption platform |
| maps.googleapis.com, maps.gstatic.com, fonts.googleapis.com, fonts.gstatic.com | Google Maps |
| az416426.vo.msecnd.net, dc.services.visualstudio.com | Other dependencies |

**Operator tasks in the web client and mobile:** TCP 443 to a.tile.openstreetmap.org, b.tile.openstreetmap.org, {GenetecReference}.gsc-cloud.com; UDP 20000-60000 to global.relay.metered.ca for call media; UDP 80 to stun.relay.metered.ca.

**Configuration task in the web client:** TCP 443 to {video}.video.genetec.cloud.

**Configuration mobile (iOS and Android):** TCP 443 to mobile.launchdarkly.com, firebaselogging-pa.googleapis.com, app-measurement.com, device.login.microsoftonline.com, config.edge.skype.com, mobile.events.data.microsoft.com, authenticator-azureidentity-tas.msedge.net, fcmtoken.googleapis.com, {video}.video.genetec.cloud.

**Genetec Operation and Configuration desktop:**

| Port | Destination | Purpose |
|---|---|---|
| TCP 5500 | {GenetecReference}.gsc-cloud.com | Security Center TLS proxy |
| TCP 554, 560, 960 | {GenetecReference}.gsc-cloud.com | RTSP over TLS |
| TCP 554, 1935 | rtsp.{video}.video.genetec.cloud | RTSP over TLS, ICE TCP WebRTC |
| TCP 443 | downloadcenter1.genetec.com | HTTPS |
| TCP 8012 | {GenetecReference}.gsc-cloud.com | Map Manager role to desktop clients (default HTTP port) |

Map traffic detail: for **image** maps the desktop clients download backgrounds from Map Manager over **TCP 8012**; for **geographic** maps they talk to the map provider directly over **TCP 443**. [S8]

## Federation

| Computer | Direction | Port | Destination | Purpose |
|---|---|---|---|---|
| On-premises Directory | Outbound | TCP 5500 | `*.gsc-cloud.com` | Reverse-tunnel communication |

That is the only documented default; the administrator may choose different ports, and the current Federation port diagrams come from the channel partner. [S2] [S10]

## ClearID ports

Separate from Security Center SaaS - see `clearid.md`. Summary: TCP 443 outbound to `*.clearid.io`, plus `*.core.windows.net` and `*.launchdarkly.com` for the web portal; `*.clearid.io` for the One Identity Synchronization Tool; and a Self-Service Kiosk set. [S11]

## Supported devices and features

Device and firmware support is defined by the **Security Center SaaS Supported Device List**; install the recommended firmware for each device. Feature-level support (PTZ, timeline thumbnails, edge recording, metadata) is in the SDL **Feature Matrix**. Plan and on-premises differences are in the **Security Center SaaS Features Matrix**. [S2] [S22]
