# SAFR SCAN Reader Diagnostics

SAFR SCAN is a reader appliance with its own web console, separate from SAFR Server. Symptom names below are the vendor's own checklist categories. [S46]

## 1. Symptom index

| Category | Symptom | Description |
|---|---|---|
| Power | Device does not power on | Does not power on via PoE and/or DC power input |
| Power | Device rebooting | Reboots repeatedly or randomly |
| Network | Web console unreachable | Unable to reach the device web console |
| Web Console | Error logging into device | Errors when attempting to log in |
| Web Console | Errors in Web Console | Errors preventing operation through the web console |
| Outputs | Wiegand Signal Issue | Issues with the Wiegand signal to the panel |
| Outputs | OSDP Signal issue | Issues with the OSDP signal to the panel |
| Outputs | Door Relay Error | Unable to trigger door relay |
| Inputs | Internal Card Reader Error | Internal card reader is defective |
| Inputs | External Card Reader Error | Unable to receive signal from external card reader |
| Inputs | Card Format Issue | Credential format mismatch on read or transmit |
| Display | Display Error | Black screen or other defect in the screen |
| Display | Touch Screen not working | Keypad or intercom call button unresponsive to touch |
| Display | LED Ring not working | LED Ring does not function as designed |
| Functional | No face matching | No face matched |
| Functional | Face matching but no access | Face matches but no Access Granted |
| Components | BLE unresponsive | Unable to connect to the device via BLE |
| Components | Speaker not working | No audio |
| Components | Microphone not working | No sound from device during intercom session |
| Components | White lights not working | White lights are not enabling by design |
| Damage | Physical Damage | Chips, cracks or water damage |

## 2. Power specifications - memorise these

| Figure | Value |
|---|---|
| SAFR SCAN minimum supply | **12 watts** |
| Mullion reader minimum supply | **9 watts** |
| Must tolerate spikes up to | **15 W**, typically 13.1 W, may reach 15 W if display brightness is increased or many features enabled |
| Largest power draws | Intercom, Wiegand, Display, Sound |
| DC input pins | T2 PIN 7 and 8 |

All figures [S46].

**Underpowering is the most common root cause of the random-reboot complaint.** A supply sized to the 12 W nominal figure rather than the 15 W peak will appear to work and then reboot when the display brightens or the intercom activates.

## 3. Device does not power on

Checks in documented order [S46]:

| Check | Healthy indication |
|---|---|
| Ethernet port LEDs | Solid green and orange flashing light |
| Auxiliary port LED | Green flashing light |
| Screen just after power-up | Wait **30 seconds** and watch for the IP address on the device screen. If it appears, the problem is elsewhere |
| Display disabled in software? | A disabled display mimics a dead device |
| Supply capacity | 12 W for SAFR SCAN, 9 W for mullion; verify at the device too, for wire shorts or power attenuation |
| Supply itself | Verify with a voltage meter or similar |
| Alternate power path | Try both PoE and DC input on T2 PIN 7 and 8 |

## 4. Device rebooting

| Order | Action |
|---|---|
| 1 | Perform a factory reset and **keep the device powered until fully rebooted**. Upgrade firmware upon restoring the device - some older firmware may corrupt a file causing reboot if unplugged very shortly after factory reset |
| 2 | Confirm the PoE or DC source can supply spikes up to 15 W |
| 3 | Ensure the device is sufficiently grounded to earth ground. See the Grounding Procedure article for older units [S49] |
| 4 | Swap the device with another location to determine whether the issue follows the device or the location |

Step 1's warning is the important one: pulling power immediately after a factory reset can corrupt firmware and create the very fault you are trying to fix.

## 5. Web console unreachable or cannot ping the device

| Step | Detail |
|---|---|
| 1 | Read the IP address on screen as the device powers on and confirm you are connecting to that address |
| 2 | Confirm you have routing and access to that address |
| 3 | If unsure, put SAFR SCAN and your PC on a PoE switch and set the PC to the same subnet shown on the SCAN display at boot. Documented example: if SAFR SCAN reports `169.254.2.5`, set the PC to `169.254.2.6` |
| 4 | `ping` the device |
| 5 | If no IP appears at boot, check the ethernet cable and whether the ethernet port is corroded or physically damaged |
| 6 | Check SAFR Server health with `check.bat` in the SAFR software `bin` directory |
| 7 | Verify other servers or devices on the same subnet are reachable |
| 8 | Validate device network settings |
| 9 | Use the **SAFR Finder App**, from safr.com > Support > Downloads. SAFR Finder must be on the same subnet as SAFR SCAN |
| 10 | Review the SAFR SCAN Web Console log by adding `&debug=1` to the URL and opening the logs tab |
| 11 | Connect device and laptop alone to a switch, observe the boot IP, match the laptop to that range |
| 12 | Factory reset the device |

All steps [S46].

**Post-reset addressing:** after a factory reset the device defaults to DHCP, and if DHCP is unavailable it defaults to `10.10.10.10` or `169.254.x.x`. Observe the IP at boot time. [S46]

The `&debug=1` URL parameter is the highest-value trick in the SCAN guide - it exposes a logs tab in the web console.

### Timestamps that tell you when things broke [S46]

| Field | Meaning |
|---|---|
| Last Config | Last change to a device setting |
| Last Status | Last time the device sent status to the server, i.e. when the client lost connection to the server |
| Last successful identity sync | In Processor System Settings; when the device's person records last changed |

Use **Last Status** to date the outage precisely before digging through logs.

## 6. Error logging into device

This means an error **other than** invalid username or password. [S46]

| Order | Action |
|---|---|
| 1 | Verify credentials and read the error text carefully |
| 2 | Ensure the network is not congested; if needed move the device to a lab environment and retry |
| 3 | Perform a **hardware** factory reset and set a new system password afterwards. Try a couple of times if the first attempt fails |
| 4 | Contact SAFR Support |

## 7. Errors in Web Console

Characterised by successful sign-in but unexpected errors when navigating pages. [S46]

| Order | Action |
|---|---|
| 1 | Access the Reset page and perform a reboot |
| 2 | Physically reboot by disconnecting power, or have the network team cycle PoE from the switch |
| 3 | Factory reset from the web console Reset page |
| 4 | Hardware factory reset |
| 5 | Contact SAFR Support |

## 8. OSDP signal issues

| Check | Detail |
|---|---|
| Enablement | Ensure OSDP input or OSDP output is enabled in SAFR **Operations Settings** |
| Wiring | Ensure the **ground wire** is connected in addition to the 2 OSDP wires |
| Access Granted | Ensure Access Granted is being generated, or the Door Relay will not activate |
| Feedback from Panel | If in use, ensure SCAN is correctly interpreting the result and granting access |
| Card format | **If card format is invalid, no data will be sent over OSDP** |
| External reader | Check whether the external reader is sending data |
| Panel side | Many panels have debug options that show data read off the wire even when it does not match the expected structure |
| Electrical | Measure voltage between OSDP **A** and **B** wires; expect a differential of about **5 volts**. You will not see variation while data is transmitting because changes are too fast for a standard multimeter - only an oscilloscope gives meaningful insight |

All checks [S46].

## 9. Wiegand signal issues

The docs state the same issues exist for Wiegand as for OSDP, so work the OSDP list. Additional Wiegand-specific check: confirm **5V exists between ground and the green wire**. [S46]

## 10. Card format issues

Root cause is often not obvious; when in doubt also work the OSDP, Wiegand, and internal/external card reader sections. [S46]

**Documented failure signatures:**

| Situation | Observable |
|---|---|
| Invalid card format on a card read | **No beep** is heard and **no event** is generated |
| Invalid card format on an authentication mode that does not include a card read | **No data** is sent over the Wiegand or OSDP wires |
| Caveat | Lack of sound from the internal card reader does **not** always mean the card is not being read |

Checks [S46]:

| Check | Detail |
|---|---|
| Events | Confirm whether you are receiving a card at all |
| Beep | Listen for a beep when tapping a card; absence may mean invalid card format |
| Reader config | Confirm the correct card format is applied to the reader in Operations Settings |
| Person record | Ensure you are not setting card format on the person record |

## 11. No face matching

| Check | Requirement |
|---|---|
| Enrolment | Ensure the face is present in the person database |
| Currency | Face image resembles current appearance - no 10 year old or modified photos |
| Pose | Looking directly at the camera or close to it |
| **Resolution** | Face image is at least **150 pixels wide** |
| Lighting | Face image is free of deep shadows |

All checks [S46].

**Face-pixel figures conflict across the SAFR documentation set.** 150 px wide here; other guides cite different targets for enrolment and camera placement. Use 150 px as the SCAN enrolment floor and see `known-gaps.md`.

## 12. Face matches but no Access Granted

The highest-frequency it-recognises-me-but-the-door-stays-shut case. [S46]

| Order | Check |
|---|---|
| 1 | Ensure **Access Clearance** is not set to None |
| 2 | Verify the Access Clearance assigned to the user is not restricting access by schedule or other means |
| 3 | Check the event icon to see whether the face passed anti-spoofing, i.e. liveness, checks. **If orange, a fake was detected and access will not be granted** |
| 4 | To test the spoofing hypothesis: Operation Settings > Access Control, set Spoofing protection level to None, and ensure Spoofing detection is set to Standard. If access is then granted, spoofing protection is the cause |

The orange event icon is the fastest discriminator - it separates an access-rules problem from a liveness problem in one glance. Restore the spoofing protection level after testing.

## 13. BLE unresponsive

BLE is used to connect to SAFR SCAN from mobile devices for Mobile Credential authentication and for remote management with Bluetooth-enabled iOS or Android phones. [S46]

| Check | Detail |
|---|---|
| Device setting | Confirm Access to SAFR SCAN over Bluetooth is enabled in SAFR SCAN **Processor System Settings** |
| Phone | Bluetooth enabled on the connecting device |
| App permissions | SAFR apps must have Location and Bluetooth permission |
| SCAN Bluetooth | Ensure SAFR SCAN Bluetooth is not disabled. The docs note SCAN BLE is always enabled if not connected to a server |
| Discovery | Use SCAN devices nearby in the SAFR Mobile App, listed as SAFR Recognition in the iOS App Store and Android Play Store, to confirm the device BLE is enabled |
| Escalation | Contact SAFR Support |

## 14. Remaining symptoms

These sections exist in the vendor guide and were not captured in full during retrieval. Do not improvise their steps - open the guide. [S46]

| Symptom | Guide section |
|---|---|
| Door Relay Error | 1.2.8 |
| Internal Card Reader Issue | 1.2.9 |
| External Card Reader Issue | 1.2.10 |
| Display Error | 1.2.12 |
| Touch Screen not working | 1.2.13 |
| LED Ring not working | 1.2.14 |
| Speaker not working | 1.2.18 |
| Microphone not working | 1.2.19 |
| White lights not working | 1.2.20 |

Source URL: `docs.real.com/safr/access/guides/articles/safr_scan_troubleshooting_guide/`

## 15. Related SCAN procedures

| Procedure | Purpose | Source |
|---|---|---|
| Grounding Procedure | Required remediation for reboot issues on **older units** | [S49] |
| Checking Calibration | Verify the structured light sensor is calibrated | [S47] |
| Calibrating the Structured Light Sensor | Recalibration procedure, three pages | [S48] |
| SAFR SCAN Admin Guide section 5 | Web Console reference | [S44] |
| SAFR SCAN Admin Guide section 6 | Vendor troubleshooting chapter | [S45] |
| Feedback from Panel | Panel response interpretation, referenced by the OSDP checks | [S50] |

Structured light sensor calibration matters for anti-spoofing: liveness depends on the depth sensor, so a mis-calibrated sensor can present as face-matches-but-no-access with an orange event icon. [INFERRED - verify]

## 16. Escalation

Every symptom in the guide ends with contact SAFR Support. Before escalating, collect: the boot IP shown on screen, the web console log via `&debug=1`, Last Config, Last Status, Last successful identity sync, firmware version, measured supply wattage, and whether a factory reset was attempted. [S46] For server-side context also attach `syscollect` output. [S4]
