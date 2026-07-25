# Vaidio - Troubleshooting (symptom first)

## Symptom index

Installation and platform: S-01 package not found / gpg error; S-02 preinstall driver failure; S-03 container will not run or start; S-04 Admin Portal 'No such file or directory'; S-05 offline USB install fails or halts; S-06 Admin Portal online upgrade fails; S-07 Admin Portal will not load after offline upgrade; S-08 upgrade appears stuck; S-09 Docker bridge subnet conflict; S-10 container will not resume after hardware change.

Access and UI: S-11 'Whoops, looks like something went wrong.'; S-12 cannot reach the UI at the expected IP; S-13 account locked; S-14 password reset email never arrives; S-15 MFA cannot be enabled; S-16 LDAP users cannot log in after 9.2 upgrade; S-17 SSO user denied; S-18 Live View broken with many tabs; S-19 map is blank or grey.

Cameras and analytics: S-20 camera will not connect; S-21 Axis or Hikvision ONVIF failure; S-22 camera not time-synced; S-23 no detections although the camera is connected; S-24 'Invalid Parameter' when drawing an ROI; S-25 camera marked Abnormal; S-26 cameras disabled after upgrade or model change; S-27 crowd detection poor at distance; S-28 custom model stops working after upgrade.

Licensing and modules: S-29 license will not apply or takes very long; S-30 license shows Expired or Inactive; S-31 Core node license reverted to trial; S-32 AI model missing from the dropdown; S-33 cannot revoke Enterprise engine licenses.

Integration: S-34 HTTP trigger test succeeds but payload has literal placeholders; S-35 GPS map image parameters empty; S-36 batch camera import unavailable; S-37 cannot access the Support Portal.

---

## S-01 apt install fails: 'E: Unable to locate package ...' [S1]
Probable causes, most likely first: repository setup step failed or had a typo; sudo omitted from the curl commands; the gpg key was never added; DNS not configured; egress blocked by firewall or a required proxy.
Checks: re-run the repository commands and watch for errors; look for 'gpg: no valid OpenPGP data found'; confirm curl is installed; confirm a DNS server is set in the netplan file; run **curl https://ironyun.github.io/Vaidio-APT/KEY.gpg** - it must return a public key block.
Resolution: fix DNS/proxy/firewall, install curl (**sudo apt install curl**), re-add the key and repo list, **sudo apt update**, then retry the install.

## S-02 'preinstall' ends with '[ERROR] Fail to install nv driver' [S1]
Probable causes: unsupported Ubuntu release; driver/kernel mismatch; Secure Boot blocking module load.
Checks: **uname -v** (or lsb_release -a) to confirm Ubuntu 22.04; **nvidia-smi**; **mokutil --sb-state**.
Resolution: move to a supported Ubuntu release, then follow the driver purge and reinstall sequence in S-03 step 3. Disable Secure Boot in BIOS/UEFI if enabled.

## S-03 'Failed to run docker container' / container will not run or start [S1]
Probable causes, most likely first: NVIDIA driver missing or below 535.183.06; GPU card loose, unseated or failed; Secure Boot preventing driver load; hardware changed since the container was created; unsupported GPU family.
Checks:
    nvidia-smi
    lshw -C display
    mokutil --sb-state
    sudo container_tool status
Resolution:
    # purge drivers
    sudo apt-get remove --purge '^nvidia-.*'
    sudo apt-get remove --purge '^libnvidia-.*'
    sudo apt-get remove --purge '^cuda-.*'
    sudo apt autoremove -y
    sudo reboot
    sudo apt install nvidia-driver-535
    sudo reboot
    sudo preinstall
If that fails, disable Secure Boot and repeat. If nvidia-smi still cannot talk to the driver and the card is not listed by lshw, treat it as hardware. Escalate to Support with the diagnostic log if it persists.

## S-04 Admin Portal: 'No such file or directory' / config /etc/vaidio/vaidio.conf does not exist [S1]
Probable causes: Vaidio Core is not installed yet (expected); systemd-timesyncd was never installed.
Checks: confirm the container exists (**sudo container_tool status**) and the file exists (/etc/vaidio/vaidio.conf); **sudo systemctl status systemd-timesyncd.service**.
Resolution: finish the Core install; or install and enable the time service:
    sudo apt install systemd-timesyncd
    sudo systemctl enable systemd-timesyncd.service

## S-05 Offline USB install fails or halts [S5]
Probable causes: Separate Data Disk option chosen on a single-disk machine (halts with an error); Secure Boot enabled; no UEFI boot; wrong boot order; pre-existing RAID/LVM that the installer will not create; hardware needing drivers outside the standard Ubuntu Server 22.04 support list, for example a parallel SCSI RAID card; corrupt image; USB 2.0 making the install look hung.
Checks: verify the image MD5 against the checksum file for that exact Vaidio version; confirm Secure Boot disabled and UEFI boot supported; confirm USB is first in the boot order; count physical disks.
Resolution: pick the matching boot option (Single Disk vs Separate Data Disk), pre-configure RAID/LVM before installing, re-flash to a USB 3.0 drive of at least 32GB, and allow 15-20 minutes with several automatic reboots before the machine powers off by itself. Collect everything in **/var/log/** on the installed system and contact vaidio.ai/support if it still fails.

## S-06 Admin Portal online upgrade fails [S2]
Probable causes: Admin Portal is 9.0.0-1 or older on Ubuntu 18.04; no internet access; warranty expired.
Checks: current Admin Portal version; **lsb_release -a**; warranty date at System > License.
Resolution: for Ubuntu 18.04, use the offline Admin Portal upgrade path first, then continue the Main System upgrade online. Renew the warranty if expired - an expired warranty blocks upgrades.

## S-07 Admin Portal will not load after an offline upgrade [S2]
Probable cause: the portal was 9.0.0-1 or older and Python 3.11 has not been upgraded yet (a required vulnerability fix).
Checks: **lsb_release -a** to pick the right tarball.
Resolution: upload and install the matching Python bundle:
    tar zxvf python3.11_jammy.tar.gz     # focal = 20.04, bionic = 18.04
    cd python3.11_jammy
    sudo bash install.sh
    cd ..
    rm -rf python3.11_jammy.tar.gz python3.11_jammy

## S-08 Upgrade appears stuck [S1][S2]
Probable causes: the upgrade is genuinely still running (both progress bars must reach 100%); a driver upgrade rebooted the server mid-flow; step upgrade required.
Checks: **sudo cat /opt/data/sys/vaidio/log/app/start_service.log**; watch the Done Upgrading and System Starting bars in the Admin Portal.
Resolution: do not reboot until the Vaidio user interface is back up. If the server rebooted to install drivers, log back into the Admin Portal, wait for Vaidio to come up, then click Main System Upgrade again. Systems older than 6.2.0-1 must step through 6.2.0-1 first. After success, re-enable all cameras.

## S-09 Docker default bridge conflicts with internal hosts [S1]
Checks: compare the docker0 subnet with the internal network.
Resolution: set bip in /etc/docker/daemon.json and restart Docker:
    { "bip":"172.26.0.1/16" }

## S-10 Container will not resume after a hardware change [S1]
Probable cause: GPU or other hardware changed while the container existed; this also risks invalidating the Face Recognition license.
Resolution (preventive and required): remove the container while keeping the data **before** powering off to change hardware, then re-init and run afterwards. If the license is already affected, contact Support.

## S-11 Login redirects to <ip>/system/license with 'Whoops, looks like something went wrong.' [S3]
Documented cause: a GPU issue - loose, unplugged or broken card. The device still pings normally.
Resolution: shut the device down from the Admin Portal, unplug it, inspect the GPU card and cables, then clear the site cookies and retry.

## S-12 Cannot reach the UI at the expected IP [S3][S5]
Probable causes: offline installs receive a random DHCP address; the address is already in use; the admin PC is on a different subnet; ports were changed.
Checks: read the IP from the Ubuntu console (shown under enp3s0); confirm the workstation is in the same subnet.
Resolution: set the workstation to the same subnet (server default 192.168.100.100, workstation for example 192.168.100.90) via Network Connections > Ethernet > Properties > Internet Protocol Version 4 (TCP/IPv4) > Use following IP address. Then change the server address in Admin Portal > Network (Core 4.2.0+). For Core 4.0.0 and earlier use System > Network > eth1; for 4.1.0 contact Support.

## S-13 Account locked out [S4]
Cause: three failed login attempts lock the account for five minutes. Wait it out, or have an Admin reset the password. Idle accounts may also have been auto-deactivated if that policy is on (30-365 days).

## S-14 Password reset email never arrives [S4][S12]
Probable causes: SMTP not configured; wrong Web Location URL so the link is unusable; secure-connection mismatch; in a cluster SMTP not configured on every server.
Checks: System > Mail > Send Test Email; System > General > Web Location.
Resolution: configure SMTP with the correct security option (No Secure Connection, SSL or TLS), set the Web Location/Web URL, and configure SMTP on the Main **and all Remote** servers. Command Center reset codes expire in 10 minutes.

## S-15 MFA cannot be enabled / MFA fields missing [S4]
Causes: SMTP is not configured - an error appears and the change is rejected; the user is an SSO user, for whom MFA fields do not appear; system-level MFA is off, so per-user fields are hidden; User Self-Management of MFA is disabled.
Resolution: configure SMTP first, confirm Vaidio Core can reach the mail server over the network, then enable MFA at System > Security, and enable User Managed MFA if self-service is wanted.

## S-16 LDAP users, including LDAP admins, cannot log in after upgrading to 9.2.0+ [S4]
Cause: LDAP Group Mapping now requires an External Identifier per group, a one-time post-upgrade configuration.
Resolution: log in with a **local** Vaidio Admin account, go to User menu > User Group > Edit Groups, and add the correct LDAP External Identifier to each Vaidio User Group. Users regain access with correct permissions and audit history intact; no accounts need recreating.
Also verify group membership: the authenticating account must carry a matching **memberOf** entry (for example CN=A000,OU=Groups,DC=example,DC=com). Accounts that can query LDAP but are not members are rejected.

## S-17 SSO (Entra ID) user is denied access [S7]
Probable causes: the user's group is not predefined in Vaidio; the Vaidio User Group External Identifier does not match the Entra ID group Object ID; the groups claim is not configured; the Redirect URI does not match the Vaidio Domain Name; Client Credential Scope or Group Claim wrong.
Checks: System > Authentication > OpenID > Check Connection; compare Application (client) ID, Object ID and the OpenID metadata endpoint with Entra ID; confirm Token configuration > Add groups claim with ID type Group ID.
Resolution: set Client Credential Scope to **.default** and Group Claim to **groups**; create the Vaidio User Group with the Entra ID Object ID as External Identifier. Note that a user in several Entra ID groups is placed in one Vaidio group in alphanumeric order, and deleting a mapped group moves its users to the Undefined role.

## S-18 Live View or the UI misbehaves with several tabs open [S3]
Cause: Chrome limitation. Open no more than two Vaidio tabs simultaneously when using Live View, for example the Alert dashboard. Without Live View there is no tab limit.

## S-19 Map is blank, grey, or shows an error [S4][S12]
Probable causes: custom tile server not in OpenStreetMap XYZ format; wrong {z}/{x}/{y} directory structure; commercial provider such as ArcGIS (unsupported); no internet when using the default public OpenStreetMap; GPS Map toggle off.
Checks: System > Setting > Map Server > Check Connection - note that this only proves the URL is reachable and does **not** validate tiles, format, directory structure or responsiveness.
Resolution: publish tiles as http://<your_server>/osm_tiles/{z}/{x}/{y}.png, or turn Apply Custom Map off to revert to the default map. Other system functions keep working and no crash occurs while the map is broken.

## S-20 Camera will not connect / Preview fails [S3][S4]
Probable causes, most likely first: wrong credentials; ONVIF disabled on the camera; wrong port; wrong RTSP path; camera not reachable; camera type set to Camera APP (Preview unsupported).
Checks: Preview button; System > Utility > Ping the camera; try the brand RTSP URL directly (see network-ports.md); default ONVIF port 80, default RTSP port 554.
Resolution: for ONVIF cameras enter IP/Domain, port, user and password then Get RTSP; for non-ONVIF cameras add the RTSP URL directly. Vendor suggestion for unknown brands: search 'RTSP stream for [camera brand]' and follow the documented URL format.

## S-21 Axis or Hikvision camera fails over ONVIF [S3]
Axis: create an ONVIF user with the same username and password as the regular camera user. If the connection still fails, temporarily disable Replay Attack Protection at System > Plain Config > Web Service and update the camera firmware.
Hikvision: ONVIF is disabled by default. Configuration > Advanced Settings > Integration Protocol > tick Enable ONVIF (or Enable Open Network Video Interface), then add an ONVIF user.

## S-22 Camera time is not synced with the server [S3]
Symptom: camera not synced within five seconds of the server.
Resolution: sync both the server and the cameras to an NTP server, or use the RTSP stream directly instead of ONVIF, since RTSP does not require time sync. This is the recommended approach for cameras streaming from other time zones.

## S-23 No detections although the camera shows Connected [S3][S4]
Probable causes in order: object too small in pixels; shutter speed too slow; high-contrast or backlit scene; object outside the General ROI; Confidence set too high; object type not selected in the Profile; Min/Max pixel limits wrong; camera time not synced; live streaming analytics disabled; camera angle too high or too oblique.
Checks and resolutions:
1. Vaidio requires roughly 10 px on target (about 14 ppf for a person); recommended camera resolution is 2MP / 1920x1080. Verify with the IPVM or JVSG calculator. Minimum guidance: about 160 ppf for Face Recognition, about 40 ppf for LPR.
2. Raise the camera shutter speed - defaults as slow as 1/5 s hurt FR, LPR and weapons detection.
3. Enable Wide Dynamic Range for garages, bright entrances and strong lighting contrast.
4. Camera > Edit > General ROI: objects outside are never detected, and engine ROIs must sit inside it.
5. Lower Confidence (0.01-1.00) in the camera Profile.
6. Select the object type in the Profile - unselected types cannot even be searched.
7. Check Min/Max Pixels (red box minimum, yellow box maximum).
8. Sync time or switch to RTSP.
9. Confirm System > Setting > Video > Enable live streaming analytics is on - disabling it deactivates all cameras.
10. Reduce the horizontal angle; feature distortion at wide angles causes mismatches, and high angles that hide the face wreck Face Recognition.

## S-24 'Invalid Parameter' error when saving an ROI [S3]
Cause: the ROI was dragged outside the camera window.
Resolution: move the ROI back inside the camera bounds and make sure all points are visible.

## S-25 Camera flagged Abnormal [S4]
Meaning: disconnected, blurred/blocked/repositioned, or resolution change.
Checks: click the Camera icon under Abnormal Check to compare Current View with Normal View; open the Clock icon for up to 30 days of status history.
Resolution: fix the physical or network cause, then Recalibrate to clear all abnormal history or just the last hour. Set a Camera Abnormal alert to be told next time (whole-hour configuration only).

## S-26 All cameras are disabled after an upgrade or model change [S2][S4]
Expected behaviour: after a version upgrade you must re-enable all cameras; applying a new AI model also deactivates all cameras. Uploading and activating a model instead of using **Replace** erases all camera settings.
Resolution: re-enable cameras from the Camera screen; always use Replace when swapping a model, and make sure the new model contains every Object Type of the model it replaces.

## S-27 Crowd detection unreliable at long range [S3]
Documented guidance for stadium-style 4K/8K deployments: set the camera bitrate to the highest level to preserve quality after transmission, and use Ultra detail mode. The vendor example contrasts 3840x2150 at about 2 Mbps against about 9 Mbps.

## S-28 Custom model stops working after an upgrade [S2]
Cause: any model whose name does not carry a version number of 7.2 or higher will not work after upgrading.
Resolution: before upgrading, obtain the updated model from Support if it is not the Power Model. The current documented Power Model is **PowerModel-Core-8.2g2-Pro-3.4**; models prior to 7.2 must be updated to 8.2 via System > AI Model > Replace.

## S-29 License will not apply, or takes a very long time [S1][S4]
Expected: applying a license can take **30-40 minutes** depending on how many analytics are enabled, and the page refreshes itself when finished.
Checks: confirm the .key matches the .info you exported from that exact server; System > License > License Management for status.
Resolution: re-export .info and request a matching key through the Support Portal (Licensing > New License or Renew License).

## S-30 License shows Expired or a node shows Inactive [S4][S12]
Checks: System > License > License Management for both License and Warranty & Maintenance expiration dates; in Command Center, Node Management > License Status column.
Resolution: Export the .info, file a Licensing > Renew License ticket, then Renew with the new key. After expiry the system stops receiving updates and maintenance, and an expired warranty also blocks upgrades. If a CC node shows Inactive, contact Support to verify activation or expiry.

## S-31 A Core node's license silently became a trial license [S12]
Cause: the node was disconnected from Command Center for more than 10 minutes, so its license temporarily reverted to trial.
Resolution: restore connectivity - the assigned license is restored automatically on reconnect. Check network path, node system time and license status in the node Admin Portal or UI if it stays Disconnected or shows missing timestamps.

## S-32 An AI model is missing from the camera dropdown [S4]
Cause: only installed and activated models appear (System > AI Model).
Resolution: upload and apply the model, or file a Support ticket if the model itself is missing.

## S-33 Cannot revoke AI Engine licenses from an Enterprise Core pod [S11]
Documented behaviour: to revoke AI Engine licenses from a Core pod the **entire instance must first be deleted**. Revoked licenses return to the cluster pool and are shown with a minus sign in License Manager. Note also that after the Vaidio Manager license expires existing Cores keep running but Create Core fails with a license expiration error.

## S-34 HTTP trigger test works but the payload contains literal {placeholders} [S8]
Documented behaviour: **Check Connection does not substitute parameters** - the test request contains the parameters in brackets. Substitution only happens when a real alert fires.
Resolution: validate substitution with a real alert, and remember that a parameter that does not apply to the firing alert type is replaced with an empty value.

## S-35 GPS map image trigger parameters come through empty [S8][S4]
Cause: {gpsMapImageBase64} and {gpsMapImageJpg} require a custom map server (tile server) configured under the system Custom Map Server field.
Resolution: configure System > Setting > Map Server with an OpenStreetMap XYZ tile URL. Also note these parameters are POST-only.

## S-36 Camera batch import from a VMS is not available [S4]
Cause: Vaidio 8.0 and higher only support batch import from VMSs with open network bridges - Network Optix, Digital Watchdog, Hanwha Wave VMS, Milestone, Mobotix, Genetec.
Resolution: add cameras individually by IP/ONVIF or RTSP for other VMS brands, and check the brand port list in network-ports.md.

## S-37 Cannot log in to the Customer Support Portal [S1]
Resolution path: register at vaidio.ai/support (skip if already in contact with Vaidio). If the business email is Google or Microsoft, sign in with that account; otherwise click Sign up with the same address, set a password, look for the activation email from **DoNotReply@connectwise.com**, follow the link, then sign in at **vaidio.myportallogin.com**. If you see 'Request Permission to the Portal', go back to the registration step. If none of this works, email **support@vaidio.ai** with the problem plus screenshots, and for a simultaneous license request include company, sales rep, analytics and channel counts, server hardware specs (GPU, CPU, RAM), the VM platform if any, and the attached .info file.

---

## Escalation checklist (what to gather before opening a ticket)
1. System > License > Export - the .info file. [S1]
2. System > Log - Diagnostic log export and System log export (.xlsx). [S4][S9]
3. System > Audit Trail export (.xlsx) if user actions are involved. [S4]
4. Upgrade issues: sudo cat /opt/data/sys/vaidio/log/app/start_service.log. [S1]
5. Offline install issues: everything under /var/log/. [S5]
6. Command Center or Vaidio Enterprise: the Export Diagnostic Log download; Vaidio Data: System > Export Log. [S11][S12][S10]
7. Server specs (GPU, CPU, RAM), Vaidio version, VM platform if virtualised. [S1]
8. For false or missed detections, also use the in-product False Detection Report (System > Setting > Advanced > Report False Detection must be on, and internet access is required). [S13]
