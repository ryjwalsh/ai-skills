# Troubleshooting, KB articles, known issues

## Start here

Before you troubleshoot anything, check **https://status.genetec.com**. It shows the live operational status of every Genetec cloud product with a **90-day log** of incidents, partial outages and scheduled maintenance, so you can rule out a platform problem before digging into a customer environment. You can subscribe to automated notifications by email, SMS, Teams and other channels. [S21]

Also confirm which product you are dealing with. Several articles below apply **only** to *Security Center SaaS Edition (Classic)*.

## Axis device will not connect [S23]

Applies to Axis direct-to-cloud and Axis Powered by Genetec devices that cannot be added.

**Gather first:** the list of Security Center SaaS endpoints to validate (from `requirements-and-ports.md`), and the device IP address and credentials.

> **Rescue credentials:** if the device credentials fail, use user **DMrescue** (case sensitive) with the device's **Owner Authentication Key (OAK)** as the password.

### Cause: endpoint ports closed or unreachable

The endpoint TCP ports are closed, or the device cannot reach the endpoints - commonly firewall rules, or a zero-trust cloud solution performing deep packet inspection on headers and other elements.

**Solution 1 - ping test from the Axis web page.** A low-level check that the endpoint DNS name resolves and is reachable.

1. Browse to the device IP address and sign in.
2. Replace the URL with: `https://<ip-address>/axis-cgi/pingtest.cgi?ip=<endpoint>`

   where `<ip-address>` is the device and `<endpoint>` is the FQDN or public IP to test. Worked example from the docs: `https://<ip_address>/axis-cgi/pingtest.cgi?ip=onboardme.prod.oneclick.connect.axis.com`
3. Fix what you find - check physical connections, update firewall settings, consider resetting the network stack.

**Solution 2 - TCP test from the Axis web page.** Verifies the endpoint **and port** are up.

`https://<ip-address>/axis-cgi/tcptest.cgi?address=<endpoint>&port=<port>`

Work through the endpoints and ports listed for your region.

## Okta user synchronisation failures [S23]

Symptom: a user reports they cannot access Security Center SaaS, or a user did not synchronise from Okta.

**Solution 1 - check application assignments.** Okta Admin Console > **Applications > Applications**, open the app, **Assignments** tab, search for the user, press Enter. An exclamation icon in the **Person** column expands into failure detail.

**Solution 2 - check the system log.** Okta Admin Console > **Applications > Applications > View logs**. In **System Log** click **Advanced Filters > Add Filter**, choose the field **outcome**, then **outcome.result**, set the value to **FAILURE**, and **Apply Filter**. Review the Events list.

**Solution 3 - retry the provisioning task.** Okta Admin Console > **Dashboard > Tasks**. Expand the task, click the application name for detail, tick the checkboxes next to the application and the user rows, then **Retry Selected**.

Related: role assignment. Provisioned users and groups with no role have **no access**. See `users-and-authentication.md`.

## Security Center SaaS Edition (Classic) - cipher suite change [S12]

As part of ongoing maintenance and security hardening, support for some older cipher suites is being removed from **SaaS Edition (Classic)**. The effective date depends on the specific system configuration and Genetec notifies each customer of their date.

**Required action:** verify your infrastructure supports **at least one** of the following:

- TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256
- TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
- TLS_DHE_RSA_WITH_AES_128_GCM_SHA256
- TLS_DHE_RSA_WITH_AES_256_GCM_SHA384
- TLS_ECDHE_ECDSA_WITH_AES_128_GCM_SHA256
- TLS_ECDHE_ECDSA_WITH_AES_256_GCM_SHA384
- TLS_ECDHE_RSA_WITH_CHACHA20_POLY1305_SHA256
- TLS_ECDHE_ECDSA_WITH_CHACHA20_POLY1305_SHA256
- TLS_ECDHE_ECDSA_WITH_AES_128_CCM
- TLS_ECDHE_ECDSA_WITH_AES_256_CCM

Contact the Genetec Technical Assistance Center for help with unsupported suites.

## MFA code arrived by email when SMS was selected [S26]

**Not a fault.** Genetec periodically emails a code to the address used when the account was enrolled, to confirm you still control it - for example to catch accounts whose original owner has left the company. After that verification, future authentications go back to SMS.

This applies to Genetec-managed sign-ins across Clearance, ClearID, Cloudrunner, the Developer Hub, the Genetec Portal, Operations Center and Security Center SaaS. MFA options are managed at the Genetec Login profile. The documented alternative is a **corporate SSO integration** (Microsoft Entra ID or OpenID Connect) so IT owns the identity life cycle, MFA requirements and password complexity - arranged through GTAC.

## KB articles

### KBA-79217 - PIN synchronisation on Axis Powered by Genetec [S29]

**Applies to:** Axis Powered by Genetec **A1210** and **A1610** (firmware 11.5.1539.0 and 11.9.71.15) and later, on **Security Center SaaS** and **SaaS Edition (Classic)**.

**Symptom:** newly assigned PINs do not work, producing the event *Access denied: No access rules assigned*.

**Cause:** a bug in the Axis Powered by Genetec credential configuration in Synergis Softwire app 11.5.1539.0 and later - PINs are not processed correctly during synchronisation.

**Workaround:** sign in to the device, go to the **Powered by Genetec** page, **Unit-wide parameters** tab, and under **Credential configuration** click **Card only** and Apply, then **Card or PIN** and Apply, then restart the device. **The workaround must be repeated every time new PINs are added.**

**Status:** under investigation, permanent fix in development. The issue is restricted to SaaS systems and does not occur on premises.

### KBA-79210 - Mercury devices offline in Config Tool, online in the Synergis Appliance Portal [S17]

**Applies to:** Security Center SaaS Edition (Classic) **and** Security Center SaaS.

**Symptom:** when adding or removing Mercury devices from a Synergis Cloud Link unit, Config Tool shows them offline, pending addition or pending deletion while the Synergis Appliance Portal shows them online. Already-added Mercury devices may also show an incorrect status.

**Cause:** a bug introduced in Security Center 5.12.2.0.

**Workaround:** restart the **Access Manager** role so device status is reported correctly. A hotfix was expected; contact GTAC if you need it immediately.

**Status:** to be fixed in Security Center 5.13.0.0.

### KBA-79003 - Import tool credentials invisible in hosted systems [S13]

**Applies to:** Security Center SaaS Edition (Classic) **only**.

**Symptom:** credentials imported into a hosted deployment with access control do not appear, and re-creating them manually with the same information returns *Insufficient privileges*.

**Cause:** if you neither select a partition in the Import tool nor specify one in the source CSV, the credentials go to the **root partition**, and users of a hosted system have no access rights to root - so they cannot see or modify them.

**Workaround:** add a partition value to the source CSV, and in the Import tool's **Bindings** tab map that value to the partition element.

**Status:** resolved in Security Center 5.12.1.0.

### KBA-79126 - Synergis Cloud Link / Cloud Link Roadrunner offline after 10 days [S14]

**Applies to:** next-generation Synergis Cloud Link and Cloud Link Roadrunner units enrolled in hosted **SaaS Edition (Classic)** systems.

**Symptom:** the unit suddenly goes offline after 10 days of enrollment.

**Cause:** a code defect.

**Workaround:** sign in to the Synergis unit and either perform a **software restart** then sign back in and restart the **Cloud Agent** under **Configuration > Cloud connectivity**, or perform a **system restart**.

**Status:** resolved in Synergis Cloud Link 2.0.4 and Cloud Link Roadrunner 2.0.4.

### KBA-79183 - Synergis Cloud Link / Cloud Link Roadrunner remain offline [S15]

**Applies to:** Synergis Cloud Link 2.1.0 and earlier, Cloud Link Roadrunner 2.1.0 and earlier, Cloud Agent 2.4 and earlier, on **SaaS Edition (Classic)**. The article explicitly warns this is not to be confused with Security Center SaaS.

**Cause:** a known, already-fixed code defect affecting only units on old Synergis Softwire or Cloud Agent versions.

**Workaround:** sign in to the unit and use the **Restart** menu - **Software restart** or **System restart**.

**Status:** resolved in Synergis Cloud Link 2.1.1 and later, Cloud Link Roadrunner 3.0.0 and later, Cloud Agent 2.5 and later.

### KBA-79192 - NTP configuration lost after a Synergis Softwire upgrade [S16]

**Applies to:** legacy Synergis Cloud Link units in hosted **SaaS Edition (Classic)** systems, upgrading from a Synergis Softwire version earlier than 11.4.0 to 11.4.0 or later.

**Symptom:** the NTP server configuration on the unit is lost. The upgrade looks successful in the Synergis Appliance Portal but Security Center raises a *Firmware upgrade failed* event.

**Cause:** a code defect.

**Workaround:** manually reconfigure the NTP settings after the upgrade.

**Status:** to be fixed in Synergis Softwire 11.5.2.

## Security updates - Synergis Softwire on Cloudlink [S28]

| Release | Highest severity | Issue | CVE | Detail |
|---|---|---|---|---|
| Synergis Softwire **12.1.1** (12.1.849) for Cloudlink 110 and 210 | High | 5013491 | **CVE-2025-55315** | .NET runtime updated to 10.0.100 |

## Known issues - Synergis Softwire on Cloudlink [S27]

As of Synergis Softwire 12.1.0 (12.1.820), for Cloudlink 110 and 210:

| Integration | Issue ID | Description |
|---|---|---|
| All | 4805822 | On networks with no DNS server, downstream controllers cannot be enrolled by hostname |
| All | 4772148 | **IPv6 is not supported** on Genetec Cloudlink appliances |
| Mercury | 4824169 | **Magstripe readers are not supported** |
| Mercury | 4823132 | If the Mercury driver becomes overloaded the controller goes offline then returns |
| Mercury | 4773583 | Non-FQDN hostnames cannot be resolved if the Cloudlink was powered up with the network cable disconnected, preventing Mercury controllers from coming online |
| Mercury | 4771815 | Activating a reader tamper while using two OSDP readers per port puts **all doors on that controller** into a warning state with *Interface module tamper state active* |

## Limitations - Synergis Softwire on Cloudlink [S27]

| Integration | Issue ID | Description |
|---|---|---|
| Mercury | 4083031 | With **Card or PIN** in the appliance unit-wide parameters, antipassback is **not** applied to PIN credentials. **Workaround:** use *Card and PIN*, or use Mercury native area control with host decision handoff disabled |
| Mercury | 3765594 | When the controller loses its link to Synergis Softwire but stays connected to the SIO boards, it validates the **facility code before the credential** - so if the facility code was never given to Synergis Softwire, access is denied without the credential being considered |
| Mercury | 3337558 | With relock-after-X-seconds configured, the *Door locked* event timestamp reflects when the door **opened**, not when it physically relocked |

## Diagnostics you can run yourself

| Target | Tool |
|---|---|
| Axis device reachability | `/axis-cgi/pingtest.cgi` and `/axis-cgi/tcptest.cgi` from the device web page [S23] |
| Cloudlink to interface modules | **Short ping** (under 10 seconds, inline results) and **Long-term ping** (once per second for a chosen duration across multiple modules, downloadable tar.gz) in the Synergis Softwire portal. Firewall rules may block ping [S5] |
| Cloudlink support bundle | Container-level logs for Softwire crashing on startup; application-level logs when Softwire is running; an encrypted engineering archive **.gen** file readable only by Genetec Technical Support [S5] |
| Cloudlink capacity | **Capabilities report** page in the Synergis Softwire portal - per-controller state, feature usage and event logs, viewable as *Over capacity*, *Offline* or *All units* [S5] |
| Cloudlink information | Touchscreen **Information** menu (serial number, firmware version, disk usage) and **Errors and warnings** menu [S4] [S18] |
| Cloudlink storage | **Maintenance > Storage** in the Synergis Softwire portal. Figures cover only the Access control application [S5] |
| Softwire logging depth | Default **Info**. Raise to Debug or Trace only when Support asks. Critical errors always logged. Forced to **Critical** if free space for the Access control application drops below **500 MB** [S5] |
| Audit trail | Softwire audit logs retained **90 days** by default, downloadable from the diagnostic-logs page. Changing audit retention also changes Softwire log retention [S5] |
| Proactive alerts | Subscribe to email notification of system events per signed-in user: **Configuration > user account icon > Settings** [S25] |

## Symptom index

| Symptom | Look at |
|---|---|
| New user cannot sign in at all | Terms of Service not accepted by the administrator; role not assigned; System Management portal Access page [S6] |
| SCIM-provisioned user has no access | Group has no role - yellow dot on the Groups tab [S24] |
| Okta user missing | Okta troubleshooting flow above [S23] |
| Axis device stuck at *Action required* | Control button not pressed, or remote activation not enabled. Allow up to 15 minutes [S6] |
| Axis device will not activate at all | Endpoint and port validation; DMrescue credentials; factory reset if previously enrolled [S23] |
| Axis PINs not working | KBA-79217 workaround [S29] |
| Cannot add more cameras to a Cloudlink although under the device limit | **Throughput ceiling** reached, not the device count [S3] |
| Camera feature missing in the UI after enabling it on the camera | Capabilities are read only at enrollment - use **Synchronize** on the camera Overview tab [S6] |
| Fisheye stream not dewarped | Dewarping works in the **Tiles** task, not the Configuration task; MP4 exports cannot be dewarped; federated cameras need Security Center 5.13+ [S6] |
| Video disappeared / retention shorter than expected | A profile's retention was shortened, or a camera was moved to a shorter-retention profile - older recordings are deleted immediately. Local storage full or prolonged cloud disruption also deletes data [S6] |
| Edge recordings unavailable | Video is not playable until uploaded to the cloud; no failover if an SD card fails; only one of two SD cards records [S6] |
| Intrusion panel repeatedly drops offline | Network load and broadcast traffic - move the panel to an isolated network behind the Cloudlink [S6] |
| Bosch integration behaving oddly with a B426 | Documented data-overflow problem - use the onboard Ethernet module instead [S6] |
| Galaxy panel changes not reflected | Re-import the XML exported from Galaxy RSS [S6] |
| Mercury unlock schedules not applying, appliance in warning | More than **twelve intervals** in an unlock-schedule time zone [S5] |
| Mercury door shows warning although it works | Only the secondary of a two-OSDP-readers-per-port pair was configured - configure the primary [S5] |
| Mercury controller offline in Config Tool only | KBA-79210 - restart the Access Manager role [S17] |
| Intelligent search returns nothing useful | Premium plan required; non-federated cameras only; stationary cameras only; camera metadata must be activated on forensic-capable cameras [S9] |
| Natural-language location filter ignored | Location results only appear when the phrase matches one or more **camera names** [S9] |
| Watchlist events vanished | Events live in the watchlist for a maximum of **15 minutes**; use a Reports task query instead [S9] |
| Report seems truncated | Reports display up to **500 results** [S9] |
| Event sounds not playing | The browser tab is muted, or the event types were not selected under Options > Sound [S9] |
| Video export does nothing | Browser pop-up blocker [S9] |
| Federated video will not play | Fusion-stream-encrypted video cannot be played in the SaaS web client or mobile app; only H.264 is supported; H.265/AV1 needs a suitable GPU and browser [S10] [S2] |
| Reverse tunnel will not reconnect after a certificate change | Force re-enrollment and issue a **new** keyfile - keyfiles are single-use [S10] |
| ClearID visitors get no email | The visit event request was never approved [S11] |
| Visitor hosts fields empty in Genetec Operation | **Cardholder groups can escort visitors** is off in Genetec Configuration desktop [S11] |
| Security Center SaaS data overwritten by ClearID | Custom-field name and entity-type collision with ClearID custom fields [S11] |
