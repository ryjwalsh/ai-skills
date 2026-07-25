# Vaidio - Error and Message Catalogue

**Important:** Vaidio does not publish a numbered error-code catalogue in any retrieved source. The product exposes log **severities** (Info, Warn, Error, Critical) rather than error codes, and the guides quote error text verbatim. Everything below is a literal message string transcribed from vendor documentation. If a user quotes a numeric code, treat it as undocumented and log it in known-gaps.md rather than guessing.

## 1. Log severities (System log) [S4][S9]

| Severity | Meaning |
|---|---|
| Info | General system activity |
| Warn | Non-critical issues |
| Error | Operational errors |
| Critical | Severe system issues |

The Diagnostic log is a separate, **encrypted** log holding hardware errors, processing consumption, analytic/alert/connection errors and failed login attempts with the source IP. It is exported for Support and is not human-readable locally. [S4]

## 2. Installation and OS-level messages

| Message (verbatim) | Where it appears | Meaning / first action | Symptom | Source |
|---|---|---|---|---|
| E: Unable to locate package ... | apt install admin-portal / ainvr-docker-utilities | Vendor repository was not added correctly. Re-run the repo steps, check for missing sudo on curl | S-01 | S1 |
| gpg: no valid OpenPGP data found. | apt-key add step | curl missing, DNS not set, or firewall/proxy blocking the key URL. Test with curl https://ironyun.github.io/Vaidio-APT/KEY.gpg | S-01 | S1 |
| [ERROR] Fail to install nv driver | end of sudo preinstall | Unsupported Ubuntu release, or driver/kernel/Secure Boot problem | S-02 | S1 |
| Failed to run docker container | container_tool run | Check the NVIDIA card and drivers with nvidia-smi | S-03 | S1 |
| NVIDIA-SMI has failed because it couldn't communicate with the NVIDIA driver... | nvidia-smi | GPU card or driver problem. Confirm the card with lshw -C display, then purge and reinstall drivers | S-03 | S1 |
| No such file or directory | Admin Portal | Vaidio not installed yet, or systemd-timesyncd missing | S-04 | S1 |
| config /etc/vaidio/vaidio.conf does not exist | Admin Portal | Same as above; the config is only created by container_tool init | S-04 | S1 |
| 2No such file or directory | Admin Portal (as printed in the guide) | Same condition seen after install; install and enable systemd-timesyncd.service | S-04 | S1 |

## 3. Interactive prompts that destroy data [S1]

| Prompt (verbatim) | Context | Safe answer |
|---|---|---|
| Do you want to remove vaidio? [y/N] | sudo container_tool remove | y removes the container |
| Do you want to purge data? [y/N] | sudo container_tool remove | **N keeps the data**; y purges all data |

## 4. Application UI messages

| Message (verbatim) | Where | Meaning / first action | Symptom | Source |
|---|---|---|---|---|
| Whoops, looks like something went wrong. | Web UI, after redirect to <ip>/system/license | Documented cause is a GPU issue - loose, unplugged or broken card. Shut down from the Admin Portal, reseat the GPU and cables, clear cookies | S-11 | S3 |
| Invalid Parameter | ROI editor | An ROI point was dragged outside the camera window. Move all points back inside the frame | S-24 | S3 |
| Request Permission to the Portal | Customer Support Portal login | Registration is incomplete - return to the registration step at vaidio.ai/support | S-37 | S1 |
| Upgrade Successful | Admin Portal upgrade | Success state; both progress bars must also read 100% before rebooting | S-08 | S2 |
| Upgrading... | Command Center Node Management | In-progress state next to a node version; brief CC disconnection is expected | - | S12 |
| Initializing | Vaidio Manager Pod Manager | Container starting; may take several minutes to become Ready | - | S11 |
| Error | Vaidio Manager Core status | Admin can recreate the Core via the Action menu > Recreate, supplying the original Account and Password | S-33 | S11 |
| Expired | License Detail / License Used | License past its expiration date; contact Support. Shown with a red exclamation icon over the License Used ellipses in CC | S-30 | S11 S12 |
| Inactive | Command Center node License Status | Contact Vaidio Support to verify activation or license expiration | S-30 | S12 |
| Not in list | FR / LPR results and {faceTargetCategory} / {licensePlateTargetCategory} | Detection did not match any configured list - a normal value, not an error | - | S8 |
| Undefined (role) | User account role | Result of deleting a User Group that carried an External Identifier; affected SSO users lose permissions | S-17 | S7 |
| Not in use | Camera Status column | Camera is deactivated, not faulty | - | S4 |
| Disconnected | Camera or node status | Verify network connectivity, system time and license status | S-25 S-31 | S4 S12 |
| Abnormal | Camera Abnormal Check column | Camera disconnected, blurred/blocked/repositioned, or resolution changed | S-25 | S4 |

## 5. Documented validation errors and blocked operations

| Condition | Behaviour | Source |
|---|---|---|
| Enabling MFA before SMTP is configured | An error message appears and the change cannot be applied | S4 |
| Assigned AI Engine channels exceed the licensed limit (Vaidio Enterprise) | An error message appears | S11 |
| Object Detection channels fewer than another engine's channels (Vaidio Enterprise) | An error message appears, for example 16 Object Detection with 20 Face Recognition is rejected | S11 |
| Create Core after the Vaidio Manager license expires | Clicking Create Core displays a license expiration error message | S11 |
| Generating a new Access Key when one is already activated by a node | The system blocks it and shows a Warning pop-up | S12 |
| Deleting a node whose Registration Status is Accepted | Warning pop-up; only Canceled or Rejected nodes can be deleted | S12 |
| Selecting nodes not eligible for CC upgrade | A warning appears; eligible nodes must be Core, 9.1+, Connected, in warranty, with a Local or Command Center license | S12 |
| Offline installer: Separate Data Disk chosen on a single-disk machine | Installation error, process halts | S5 |
| Replacing an AI model that lacks Object Types of the old model | Replace is not permitted - the new model must include all Object Types | S4 |
| Disabling live streaming analytics | Deactivates ALL cameras | S4 |
| Applying a new AI model | Deactivates all cameras | S4 |
| Uploading and activating a model instead of using Replace | Erases ALL camera settings | S4 |
| Enabling or disabling Privacy Protection | Restarts the system | S4 |
| Three failed login attempts | Account locked for five minutes | S4 |
| Camera name containing unsupported characters | Only . _ - , are allowed | S4 |
| Camera health schedule set to a partial hour | Not allowed; whole-hour increments only (a 45-minute block is rejected) | S4 |
| HTTP trigger Check Connection | Parameters are NOT substituted; brackets are sent literally | S8 |
| HTTP trigger parameter not applicable to the firing alert type | Replaced with an empty value | S8 |
| POST-only trigger parameters used with GET/PUT/DELETE/PATCH | Image and binary parameters are only available with POST | S8 |
| {gpsMapImageBase64} / {gpsMapImageJpg} without a custom map server | Cannot be populated | S8 |
| Custom map server Check Connection | Proves reachability only; does not validate tiles, format, directory structure or responsiveness | S4 |
| Incompatible custom tile server | Map appears blank, grey or errored; other functions keep working and no crash occurs | S4 |
| Vaidio Data backup with insufficient local disk space | The backup file cannot be downloaded | S10 |
| Vaidio app version newer than the server | Not forward-compatible; app is backward compatible by one version only. Disable automatic app updates | S14 |
| Camera type Camera APP | Preview is not supported; only FR and LPR analytics run on VaidioCam streams | S4 |
| User account with no defined group | No access to any function and cannot log into Vaidio | S4 |
| Warranty expired | Upgrade is blocked | S2 |
| Custom model without version 7.2 or higher in the name | Will not work after upgrading | S2 |

## 6. Known issues captured from release material

| Item | Detail | Source |
|---|---|---|
| LDAP login regression on 9.2.0+ | Existing LDAP users, including administrators, may temporarily be unable to log in and may appear missing until an Admin completes External Identifier mapping | S4 |
| Admin Portal 9.0.0-1 or older, Ubuntu 18.04 | Online Admin Portal upgrade fails; the offline path is required | S2 |
| Admin Portal 9.0.0-1 or older, offline upgrade | Portal will not load until Python 3.11 is upgraded manually | S2 |
| Driver version inconsistency in vendor docs | The upgrade guide states 535.138.06 on one page and 535.183.06 elsewhere; the install guide and offline driver procedure both use 535.183.06 | S1 S2 |
| Edge 9.0.0 and below | SSO users cannot change groups (for example Admin to User) | S15 |
| Vaidio 10.0 architecture change | Move from single-container to modular multi-container Unified Scalable Architecture; no 10.0 admin guide was published at the docs root at retrieval time | S16 S23 |

Formal per-release 'fixed defects' and 'known issues' lists are **not published publicly** - they are only available through the gated Support Portal. See known-gaps.md.
