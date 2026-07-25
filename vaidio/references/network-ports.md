# Vaidio - Network and Ports

## 1. Port table

All port numbers below are defaults and are documented as configurable where noted. Direction is expressed from the initiator.

| Port | Protocol | Direction | Source -> Destination | Purpose | Required? | Source |
|---|---|---|---|---|---|---|
| 22 | TCP | inbound | Admin workstation -> Vaidio server | SSH administration (explicitly opened in the documented ufw ruleset) | Optional but documented | S1 |
| 80 | TCP | inbound | Browser / mobile app -> Vaidio Core | Core web UI (HTTP). Configurable in System > General | Required (unless HTTPS-only) | S1 S4 |
| 443 | TCP | inbound | Browser / mobile app -> Vaidio Core | Core web UI (HTTPS). Configurable; 'Force Secure Connection' available | Required if HTTPS enforced | S1 S4 |
| 8000 | TCP | inbound | Browser -> Admin Portal | Appliance admin: ports, time, network, upgrade, factory reset. Same port on Core, Command Center and Edge | Required for administration | S1 S4 S12 S15 |
| 18888 | TCP/UDP (not stated) | inbound | Camera network -> Vaidio Core | ONVIF auto-discovery function | Required only for Auto Discovery | S1 |
| 7000 | TCP | inbound | Core / Edge node -> Command Center | Node registration and federation traffic (documented as 'Default CC port is 7000') | Required for federation | S12 |
| 7000 | TCP | inbound | Browser -> Vaidio Data | Vaidio Data web UI (HTTP), configurable at install | Required for Vaidio Data | S10 |
| 7001 | TCP | inbound | Browser -> Vaidio Data | Vaidio Data web UI (HTTPS), configurable at install | Optional | S10 |
| 554 | TCP/UDP | outbound | Vaidio Core -> camera / NVR | RTSP video streams (default RTSP port) | Required | S3 |
| 80 | TCP | outbound | Vaidio Core -> camera | ONVIF device access (default camera port 80) | Required for ONVIF cameras | S3 S4 |
| 25 / 465 / 587 | TCP | outbound | Vaidio Core, CC, Edge -> SMTP server | Mail for password reset, MFA one-time codes, email alerts. Port is entered in System > Mail; specific numbers are **not documented** | Required for MFA and email alerts | S4 S12 |
| LDAP port (field) | TCP | outbound | Vaidio Core -> LDAP/AD server | Directory authentication; port is a configurable field, no default published | Required for LDAP | S4 |
| 443 | TCP | outbound | Vaidio Core -> internet | Vendor APT repo, model/upgrade downloads, GPS map tiles (OpenStreetMap), GenAI/false-detection reporting | Required for online install/upgrade and GPS map | S1 S4 S13 |
| Custom map tile port | TCP | outbound | Vaidio Core / CC -> tile server | Self-hosted OpenStreetMap XYZ tiles: http://<your_server>/osm_tiles/{z}/{x}/{y}.png | Optional | S4 S12 |
| Trigger endpoint port | TCP | outbound | Vaidio Core -> external system | HTTP/HTTPS alert triggers (GET, POST, PUT, DELETE, PATCH) to a customer-defined URL | Optional | S8 |
| NTP (123) | UDP | outbound | Vaidio server and cameras -> NTP server | Time sync; cameras must be within 5 s of the server. Port number itself is **not documented** | Strongly recommended | S3 S4 |

## 2. Documented ufw ruleset (Vaidio Core)

From the installation guide appendix, 'Make the service accessible'. Skip if the Ubuntu firewall is disabled. [S1]

    sudo apt install ufw
    sudo chmod 644 /etc/ufw/after6.rules
    sudo ufw allow 22      #SSH port
    sudo ufw allow 80      #Depend on Vaidio-Core http port number.
    sudo ufw allow 443     #Depend on Vaidio-Core https port number.
    sudo ufw allow 8000    #Depends on Admin portal access port.
    sudo ufw allow 18888   #Required by ONVIF auto discovery function.
    sudo ufw enable

## 3. NVR / VMS ports for Vaidio integration

Published 'Common NVR/VMS Ports' table. Integration setup varies by brand; contact Vaidio for brand-specific instructions. [S3]

| NVR/VMS brand | Port |
|---|---|
| Avigilon ACC | 8443 |
| Axis ACS | 55756 |
| Dahua | 37777 |
| Digifort | 8601 |
| Digital Watchdog Spectrum | 7001 |
| Exacq | 80 |
| Genetec Security Center | 8888 |
| Hanwha Wave VMS | 7001 |
| Milestone XProtect | 8081 |
| Network Optix Nx Witness | 7001 |
| Salient CompleteView | 4502 (HTTP), 4503 (HTTPS) |
| VideoInsight | 9000 |

## 4. Common camera / NVR RTSP URL formats

Replace the placeholder host and port; default RTSP port is 554. [S3]

| Brand | RTSP stream |
|---|---|
| Axis | rtsp://<cameraip>:<port>/axis-media/media.amp  (multisensor: rtsp://<username>:<password>@<camera_ip>/axis-media/media.amp?sensor=1) |
| Cisco | rtsp://<cameraip>/StreamingSetting?version=1.0&action=getRTSPStream&ChannelID=1&ChannelName=Channel1 |
| Dahua NVR | rtsp:/<nvr_ip>:<port>/cam/realmonitor?channel=camerach&subtype=stream |
| Digital Watchdog / Network Optix / Hanwha Wave VMS | rtsp:/<nvr_ip>:7001/{camera_id}?stream=0 |
| Hanwha | rtsp://<cameraip>:<port>/profile1/media.smp |
| Hikvision camera (ONVIF disabled by default) | rtsp://<cameraip>:<port>/Streaming/Channels/101 |
| Hikvision NVR | rtsp://<nvr_ip>:<port>/Streaming/Channels/{channel_id}1 |
| i-PRO | rtsp://<cameraip>/mediainput/stream_  (multisensor: rtsp://<cameraip>/mediainput/stream_1/ch_1) |
| Panasonic | rtsp://<cameraip>/MediaInput/h264 |
| Samsung | rtsp://<cameraip>/profile<#>/media.smp |

Notes: most cameras are ONVIF-enabled, but Axis and Hikvision need manual setup. Axis requires creating an ONVIF user (same credentials as the camera user) and, if the connection fails, temporarily disabling Replay Attack Protection at System > Plain Config > Web Service and updating firmware. Hikvision requires Configuration > Advanced Settings > Integration Protocol > Enable ONVIF plus an ONVIF user. [S3]

## 5. Host network configuration (netplan)

Ubuntu 22.04 reference from the install guide (gateway4 is deprecated; use routes). Two-space YAML indentation. [S1]

    network:
      version: 2
      renderer: NetworkManager
      ethernets:
        enp3s0:
          dhcp4: false
          addresses:
            - 192.168.100.100/24
          routes:
            - to: default
              via: 192.168.100.1
          nameservers:
            addresses: [8.8.4.4, 8.8.8.8]

Apply with **sudo netplan apply**. Files live in /etc/netplan (edit /etc/netplan/*.yaml or create /etc/netplan/01-netcfg.yaml). Interface names come from **ifconfig**. If the network was configured through the Ubuntu UI instead, the Admin Portal cannot later change the server network settings. [S1]

Post-install network changes are made in the Admin Portal (port 8000) > Network: choose the interface, then DHCP or Static configuration (IP, netmask, gateway), plus optional DNS server, then Apply. Vaidio Core 4.2.0 and later use the Admin Portal for this; 4.0.0 and earlier used System > Network > eth1; 4.1.0 required Support assistance. [S4][S12][S3]

## 6. Docker bridge subnet conflicts

If the Docker default bridge (docker0) collides with internal host access, set the bip option in /etc/docker/daemon.json (default location) and restart Docker: [S1]

    {
      "bip":"172.26.0.1/16"
    }

## 7. TLS and certificates

| Item | Detail | Source |
|---|---|---|
| Core HTTPS | System > General: set HTTP and HTTPS port numbers; tick Force Secure Connection (HTTPS) | S4 |
| Certificate upload | System > Setting > Additional Settings > SSL Certificate: upload Private Key, Public Key Certificate, optional Certificate chain, optional password protection | S4 |
| Accepted file types | Private Key .key; Public Certification Key .crt, .cer, .pem; Certification Chain .crt, .cer, .pem | S4 |
| LDAP over SSL | System > Authentication > Secure Connection: No or SSL, with optional certificate upload | S4 |
| SMTP security | No Secure Connection, SSL, or TLS | S4 |
| Command Center | System > General: HTTP/HTTPS ports plus Force HTTPS Secure Connection, and a base Web URL used for password-reset links | S12 |
| Edge | Settings: install an SSL certificate to secure the site | S15 |

## 8. Proxy support

Proxy support is only referenced indirectly: if the vendor APT key cannot be fetched, the guide states it is most likely a network firewall issue or a proxy needs to be set up. No proxy configuration keys, environment variables or UI fields are documented. Log this as a gap when asked. [S1]

## 9. Bandwidth planning

- Vaidio needs only about 20 pixels on target, so 1080p is sufficient for most cases; using the camera second (lower-resolution) stream avoids touching the VMS recording stream at the cost of slightly higher total bandwidth. [S3]
- Vaidio needs 8 fps or less depending on the analytic; lowering camera frame rate reduces bandwidth and can improve accuracy. [S3]
- Published example, 3MP H.264 at 15 fps: VMS alone 3.2 Mb/s; adding Vaidio 6.4 Mb/s; dropping 3MP to 1080p cuts Vaidio bandwidth 34% (total 5.3 Mb/s); dropping 15 fps to 4 fps gives 1.6 Mb/s total; both changes give 1.4 Mb/s. [S3]
- Vendor-referenced third-party calculators: cctvcalculator.net bandwidth calculator, digiever.com/support/calculator.php for bandwidth and storage, calculator.ipvm.com and jvsg.com CCTV lens calculator for optics. Vaidio also publishes its own Appliance Calculator and Storage Calculator on the Partner Portal. [S3][S4][S24]
- Published storage example: 20 x 1080p streams on a VSB-550 recording 24 h/day for 30 days is about 18.10 TB. [S3]
