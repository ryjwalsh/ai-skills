# Genetec Cloudlink appliances

Sources: appliance capabilities page [S3], hardware guides for the 2210 [S4], 210 [S18], 110 [S19] and 310 [S20], and the Setup Guide appliance topics [S6].

All four models run **Genetec Edge OS**, a Linux-based, cyber-hardened platform with Secure Boot, TLS 1.3 in transit and AES-256 at rest. Applications (video, Access control, Intrusion) run as containerised workloads on top of it.

## Model comparison

| | Cloudlink 110 | Cloudlink 210 | Cloudlink 310 | Cloudlink 2210 |
|---|---|---|---|---|
| Form factor | Compact, PoE-capable, wall or DIN-rail | Desktop / wall / rack | Tower | 1U-style rack server with optional smart bezel |
| CPU | Quad-core 64-bit | Quad-core 64-bit | Hexa-core 64-bit | 16-core 64-bit |
| RAM | 4 GB | 16 GB | 16 GB | 64 GB |
| Internal flash | 16 GB | 16 GB | 256 GB | 480 GB redundant |
| Network | 2 x 1 GbE | 2 x 1 GbE | WAN 10/100/1000/2500 Mbps + LAN 1 GbE | 2 x 10GbE RJ45 **or** 2 x 10/25GbE SFP28 (never mixed) |
| Power | PoE 802.3af / 802.3at Type 1 Class 2 (6.49 W) on port 1, or 12 Vdc nominal +/-15%, 300 mA avg / 600 mA peak. Avg 4.5 W PoE, 3.6 W DC | 90-264 VAC 50/60 Hz via included 24 VDC adapter. Avg 35 W | 300 W PSU, 90-264 VAC | Dual redundant (1+1) hot-plug 1100 W MHS, 100-240 VAC. Avg 310 W |
| Storage | MicroSD, ultra-endurance, 1 TB raw / 946 GB usable | GCL-210-M1HA 8 TB (7.4 usable); GCL-210-M3HA 22 TB (21.2 usable); GCL-210-M3JA dual drives, redundant 22 TB (21.2 usable) or extended 44 TB (42.9 usable) | Standard 8 TB (7.4 usable); Extended 20 TB (19.3 usable) | Not published in the captured guide |
| Other interfaces | 4 supervised inputs, 4 RS-485 ports (both reserved for future use) | 4 supervised inputs, 1 output relay (max 2.0 A @ 30 VDC), 2 RS-485, 2 video outputs, 2 USB - all reserved for future use except video output 1 | 1 USB-C, 5 USB 3.0, 2 video outputs | Ports present but reserved; two RJ45 + two SFP28 |
| Incoming throughput | up to 16 Mbps | up to 200 Mbps | up to 200 Mbps | up to 1600 Mbps |
| Dimensions | 18.4 x 11.4 x 3.5 cm | 19.4 x 8.4 x 24.0 cm (W x H x L) | 9.7 x 29.2 x 29.0 cm (W x D x H) | 48.2 x 8.4 x 80.2 cm (W x H x L) |
| Weight | 475 g | 2.5 kg (3.1 kg for M3JA) | 5.1 kg | Not published |
| Operating temp | 0-50 C | 10-45 C | 5-45 C | 10-35 C |
| Operating humidity | 5-95% non-condensing, indoor only | 10-90% non-condensing, indoor only | 20-80% operating | 10-90% non-condensing |
| Warranty | 2 years | 2 years | 3 years | Not published |
| Touchscreen | No | Yes (smart bezel) | No | Yes (smart bezel, subject to local regulatory approval) |
| Notable | Buzzer + status LED feedback | Spot monitor on video output 1 | NDAA compliant; spot monitor on video output 1 | Dell chassis (Regulatory Model E1145, type E114S001); iDRAC MAC on pull tab |

Retention examples published for the 110: 15 days local for 2 Full HD streams at average activity (H.264, 15 fps); 10 days local for 4 Full HD at low activity; 30 days cloud for 8 Full HD at low activity. For the 310: standard model 30 days local for 8 Full HD at average activity; extended model 30 days local for 32 Full HD at low activity. Model more precisely with https://svcalculator.genetec.com/.

## Device maxima per model [S3]

Cameras, intrusion panels and access-control devices can be mixed. **For multisensor cameras every sensor counts as one camera.**

| Scenario | Cloudlink 110 | Cloudlink 210 | Cloudlink 2210 | Cloudlink 310 |
|---|---|---|---|---|
| Video only | 8 cameras | 64 cameras | 800 cameras | 32 cameras |
| Intrusion only | 4 panels | 10 panels | 10 panels | 10 panels |
| Access control only | 64 doors or 128 readers, 8 Mercury panels, 100K cardholders | 128 doors or 256 readers, 32 Mercury panels, 100K cardholders | 128 doors or 256 readers, 32 Mercury panels, 250K cardholders | Not applicable |
| Video + intrusion | 4 cameras, 1 panel | 32 cameras, 4 panels | 800 cameras, 10 panels | 16 cameras, 4 panels |
| Video + access control | 4 cameras, 32 doors or 64 readers, 4 Mercury panels, 100K cardholders | 32 cameras, 64 doors or 128 readers, 16 Mercury panels, 100K cardholders | 800 cameras, 128 doors or 256 readers, 32 Mercury panels, 250K cardholders | Not applicable |
| Video + intrusion + access control | 4 cameras, 1 panel, 32 doors or 64 readers, 4 Mercury panels, 100K cardholders | 32 cameras, 4 panels, 64 doors or 128 readers, 16 Mercury panels, 100K cardholders | 800 cameras, 10 panels, 128 doors or 256 readers, 32 Mercury panels, 250K cardholders | Not applicable |

### Throughput ceilings

| Model | Video only | Video plus another workload |
|---|---|---|
| Cloudlink 110 | 16 Mbps | 8 Mbps |
| Cloudlink 210 | 200 Mbps | 100 Mbps |
| Cloudlink 310 | 200 Mbps | 100 Mbps |
| Cloudlink 2210 | 1600 Mbps | 1600 Mbps |

**Hitting the throughput ceiling blocks new devices even if the device count is still under the limit.** Factor camera settings in accordingly.

## Appliance portal

Reach it from a computer on the same subnet: **https://<hostname-or-IP>**. The default hostname is printed on the pull tab next to *Nom/Name*. Cloudlink uses a **self-signed certificate**, so the browser warning is expected and can be dismissed. Sign in with user **admin** and the password printed on the pull tab beside *PWD* - you are forced to change it on first sign-in.

### Networking behaviour

- By default Cloudlink appliances use **DHCP** and are discoverable by **UPnP**. With no DHCP lease they fall back to a link-local address in **169.254.0.0/16**.
- Best practice: stage the appliance on a pre-deployment network with DHCP and UPnP enabled.
- Cloudlink uses an **internal network** for inter-application traffic. If that range overlaps your external address space, application traffic may misroute. Internal IPs are auto-assigned to avoid conflicts, and can be adjusted on the **Advanced** tab in Security Center SaaS or in the appliance portal.
- On a **single network**, internet connectivity and discovery happen on **Ethernet port 1** and port 2 is disabled.
- On an **isolated network**, port 1 goes to the internet and **port 2** goes to the devices, with the appliance bridging between them. **Ports 1 and 2 must use different subnets.** On the 2210 you may use either the SFP28 pair or the RJ45 pair, never a mix.
- **HTTP proxy** (Settings in the appliance portal) routes all outbound appliance traffic through the proxy; traffic between the appliance and its devices is unaffected. You need the proxy hostname or IP, port, and credentials if required.
- **Date and time**: Settings > Date and time. Note that **time zone is owned by Security Center SaaS** once the appliance is enrolled, which makes the portal field read-only.

## Enrolling an appliance in Security Center SaaS [S6]

1. Have the serial number and activation code from the insert card ready.
2. **Configuration > Devices > Add device > Appliance**.
3. On the Activation page either scan the QR code with the webcam (allow browser camera access; centre the code) or type the serial number and activation code.
4. Name the appliance on the Configuration page. Cloudlink 210 units with dual hard drives (GCL-210-M3JA) offer a redundant vs extended storage choice at this point.

### Adding cameras behind the appliance

Automatic discovery: appliance online, camera on the SDL, **WS-Discovery enabled** on the camera and discovery permitted on the LAN, camera credentials to hand, cameras factory reset unless being added read-only. Then **Add device > Camera > Genetec Cloudlink**; the system searches automatically and lists cameras not yet in the system. Discovery may surface cameras that are **not officially supported**.

Manual: **Add device > Camera > Genetec Cloudlink > Add a local camera manually**, then IP address, credentials, optional **Read-only mode**, and a recording profile. For appliance-connected cameras configured for cloud recording, video is written locally first and then uploaded.

## Synergis Cloud Link enrollment [S6]

Compatibility rules:

- Serial number must end in **"4A" or greater** (4A, 4B, 4C, 5A, 6A, ...).
- Must run **Synergis Cloud Link 3.1.0 or later**.

If the unit was previously enrolled in an on-premises Security Center or a SaaS Edition (Classic) system:

1. Upgrade to **Synergis Cloud Link 3.1.1 or later**.
2. Enable **Communicate with the cloud for enrollment** in the Synergis Appliance Portal:
   - Versions earlier than 3.3.0: **Configuration > Unit-wide parameters**.
   - 3.3.0 and later: **Configuration > Cloud connectivity > Security Center SaaS enrollment**.

Then add the appliance with its QR code, or serial number plus activation code.

## Maintenance tasks

| Task | Where / how |
|---|---|
| Verify installation | Apply static IP or advanced network settings in the portal, then enroll in Security Center SaaS with the serial number and activation code |
| Factory reset | First try deleting and re-adding the appliance. Then reset from the portal, or from the touchscreen on a 210/2210. **The appliance must be deleted from Security Center SaaS first if you reset from the touchscreen** - the touchscreen cannot reset an enrolled appliance. Reset restores the default password from the label, resets settings, and **deletes user and application data including video**. Network settings are deleted unless you choose *Preserve network settings* |
| Lost password | Use the touchscreen factory reset (210/2210) or the command-code DIP switches (110). Physical access required |
| Spot monitor | See `devices-and-video.md` |

### Cloudlink 110 LED and buzzer feedback [S19]

| Indicator | State | Meaning |
|---|---|---|
| Information LED | Orange solid | Software not started |
| | Green solid | Software started |
| | Green, 2 blinks/second | Connected to Security Center SaaS |
| | Green, 5 blinks/second | Software upgrade in progress. **Do not power cycle** |
| | Orange solid 3 seconds | DIP-switch code recognised |
| | Red, 3 slow blinks | DIP-switch code not recognised |
| Power LED | Blue solid | 12 V DC or PoE applied |
| Ethernet | Green | 1000BASE-T link, flashes on activity |
| | Yellow | 10/100 link, flashes on activity |
| PoE LED | Yellow solid | Powered by PoE on Ethernet port 1 |
| Buzzer | Low-middle-high | Firmware starting |
| | High-low | Warning state - check the microSD card is seated, then restart, then contact support |

110 wiring: 20 AWG minimum for both the 12 V input and ground. Wiring must be done by trained personnel, with anti-static precautions for third-party hardware and compliance with local or national electrical code.

### Cloudlink 2210 specifics [S4]

- Delivered **without** the front bezel. Install it after racking: insert the right-side prongs, hold the release button on the left, push until it clicks, lock with a supplied key.
- **Insert all drives before powering on** - powering up with drives missing can force a recovery procedure.
- The bezel connectivity LED is white when the bezel is properly connected and red when it is not.
- The pull tab carries serial number, model, hostname, password, Service Tag and MAC addresses for the Ethernet ports and iDRAC.
- Rails are supplied; detailed rack instructions ship in print with the unit.
- Keys are for maintenance - keep them accessible to authorised personnel.

### Touchscreen (smart bezel) menus - 210 and 2210 [S4] [S18]

| Menu | Use |
|---|---|
| Initial setup | Static IP or DHCP; can display a QR code to add or re-add the appliance to Security Center SaaS |
| Home | Cloud connection status and connected devices. After enrollment it lists online cameras, intrusion panels and doors managed in Security Center SaaS |
| Information | Serial number, firmware version, disk usage and other support details |
| Network | Network settings. After initial setup, do network configuration in the appliance portal instead |
| Errors and warnings | Details on system errors and warnings; can be snoozed but stay listed until resolved |
| Display | Brightness, including a dimmed mode after 60 seconds of inactivity |
| Reboot / Factory reset | Reboot, or Full reset vs Preserve network settings |

A cloud icon with a checkmark on the home screen indicates a successful cloud connection.

## Access control application on Cloudlink

Synergis Softwire runs as the **Access control application** on Edge OS. At time of capture it is supported on the **Cloudlink 110 and 210** only, and the **Mercury controller integration is the only supported integration**. Full detail in `access-control.md`. [S5] [S27]
