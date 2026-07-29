# Access control

Sources: Setup Guide access-control topics [S6], User Guide Access control task [S9], Synergis Softwire Configuration Guide for Genetec Cloudlink [S5], Synergis Softwire release notes [S27], security updates [S28].

## Hardware options

| Hardware | Added where | Managed where |
|---|---|---|
| **Axis Powered by Genetec** door controllers | Web client, Add device wizard, serial number + OAK | Web client, plus the Axis device web interface |
| **Synergis Cloud Link** appliances | Web client, QR code or serial + activation code | Web client + Genetec Configuration desktop |
| **Mercury LP / MP controllers** behind a Genetec Cloudlink | **Genetec Configuration desktop only** | Configuration desktop + the Synergis Softwire portal on the appliance |

**The Configuration task cannot add Mercury controllers.** After a Mercury controller is added it can only be viewed and managed in Genetec Configuration desktop. Mercury controllers must connect to a Cloudlink appliance that supports the Access control application.

## Operator-side entities (Access control task in the web client) [S9]

The Access control task manages **cardholders and visitors**, **credentials**, **groups** and **access rules**. List view and Card view are available for cardholders and visitors. Column selections and filters are **not persisted** when you leave the page. Filters (name, status, group, activation date, expiration date, mobile phone number) apply immediately.

### Cardholders

**Access control > Cardholders and visitors > Add cardholder.** Your administrator must have created partitions first.

Assign: **Groups** (access rules can be inherited from the group), **Credentials** (new or existing), and **Access rules**.

Advanced settings:

| Setting | Effect |
|---|---|
| Use extended grant time | More time to pass through the door, for reduced mobility |
| Can escort visitors | Lets the cardholder act as a visitor host |
| Bypass antipassback rules | Inherited, or Yes to exempt |
| Security clearance | Inherited, or Custom. **Level 0 is the highest clearance**; used when a threat level is set |
| Partitions | A cardholder must belong to at least one partition |

### Visitors

**Add visitor**, same shape as cardholders (groups, credentials, advanced settings). Visitors do not get *Can escort visitors*. To remove a visitor you **Check out** rather than Delete; cardholders are deleted via **Show more > Delete**.

### Credentials

**Credentials tab > Add credential.** Name it, pick the cardholder or visitor, set **Status** (Active / Inactive) and an **Expiration** type. Credential type is **Manual entry** (card format + facility code + card number) or **PIN** (numeric value). Advanced holds a description and partitions.

### Cardholder groups

**Groups tab > Add group.** Name and email address. **Available for visitors** allows visitors into the group. Access rights section takes members and access rules. Advanced holds description, bypass antipassback, security clearance and partitions.

### Access rules

**Access rules tab > Add access rules.** Requires schedules to already exist.

- Give it a descriptive name - the docs suggest patterns such as *Lab technicians only* or *Regular employee hours*.
- Pick a **Schedule**, then whether the rule **grants** or **denies** access while active.
- Permanent, or temporary with activation and expiration dates.
- **Access rights**: Members (cardholders or cardholder groups) and the Doors, elevators and areas the rule applies to.
- Documented best practice: schedules normally **grant**; access is denied when the schedule is inactive. Use explicit deny schedules only for exceptions.

## Axis Powered by Genetec

Adding a device does two things automatically: it **upgrades firmware to the latest version**, and it **generates a username and password and deletes all previous credentials** so Genetec manages the password.

After the wizard, the device appears with Device type *Unknown* and Status *Action required*. Press the **control button** on the device; activation can take up to **15 minutes** and the device is ready when Status shows *Online*. Without physical access, enable the remote-activation option.

To administer the controller: **Devices > device > Overview > View credentials**, copy them, click **Open web interface**, and paste them into the Axis sign-in dialog.

Known issue: newly assigned **PINs may not work** on A1210 and A1610 units running Synergis Softwire app 11.5.1539.0 or later, producing *Access denied: No access rules assigned*. Workaround: on the device, **Powered by Genetec > Unit-wide parameters > Credential configuration**, set **Card only** and Apply, then **Card or PIN** and Apply, then restart the device. **Repeat every time new PINs are added.** Restricted to SaaS systems. [S29]

## Synergis Softwire on Genetec Cloudlink

Synergis Softwire runs as the **Access control application** on Genetec Edge OS, so the appliance talks to Security Center SaaS directly with no gateway device. It is configured through the **Synergis Softwire portal** on the appliance. [S5]

**Scope at time of capture:** supported on **Cloudlink 110 and 210** only, and the **Mercury controller integration** is the only supported integration. Softwire 12.1.0 (12.1.820) was the first release for Cloudlink (Cloudlink 210, Mercury only); 12.1.1 (12.1.849) added Cloudlink 110 support for the Access control application plus a security fix - CVE-2025-55315, severity High, resolved by updating the .NET runtime to 10.0.100. [S27] [S28]

### Reaching the portal

Sign in to the appliance and navigate to the Synergis Softwire portal from the appliance web UI.

**These tasks must be done in Genetec Configuration desktop, not the portal:**

- Assigning inputs, output contacts and readers to doors and zones.
- Creating and configuring areas, doors, elevators and zones.
- I/O linking.
- Configuring **Card and PIN** readers (both card and PIN required).

Conversely, **Card or PIN** and **Card only** reader modes are set **only** in the portal, under Unit-wide parameters.

### Portal configuration pages

| Page | Purpose |
|---|---|
| Configuration > Unit-wide parameters | Interface-module behaviours common to everything on the appliance, plus the automation engine mode |
| Configuration > Reader LED and beeper settings | LED and beeper behaviour per access-control state. **Mercury-controlled readers only.** States: Unlocked, Shunted, Card only, Card and PIN, and others. **Export** to a LedConfig<Hostname> file and **Import** on other appliances to save time |
| Configuration > Mercury controller settings | Door settings, database layout, long-credential formats, advanced settings |
| Configuration > Mercury triggers and procedures | Rules that run on the controller itself |
| Configuration > Synergis Softwire logging | Logging level and audit-log retention |
| Maintenance > System status | Download / upload the configuration file |
| Maintenance > Firmware upgrade | Interface-module firmware |
| Maintenance > Storage | Space usage and cleanup for the Access control application |
| Maintenance > Advanced URL console | HTTP requests to toggle advanced features. **Support use only** |
| Maintenance > Download diagnostic logs | Container-level and application-level logs, audit logs, long-term ping results |
| Capabilities report | Per-controller state, feature usage and event logs |

### Logging and audit retention

- Default logging level is **Info**. Lower it to save storage and improve readability; raise it to **Debug** or **Trace** only when Genetec Technical Support asks.
- **Critical errors are always logged** regardless of level.
- If free disk space for the Access control application drops below **500 MB**, the logging level is forced to **Critical**.
- **Audit logs are kept 90 days by default.** Changing audit-log retention also changes Synergis Softwire log retention. Audit logs record configuration changes made in the portal and are downloadable from the diagnostic-logs page.

### Automation engine (on-appliance rules)

The automation engine executes rules locally, comparable to event-to-actions in Security Center SaaS, and **keeps working while the Cloudlink is disconnected from its CloudAM role**.

- Intended for **non-intelligent controllers**. With intelligent controllers such as Mercury, results can be unpredictable because the controller makes its own access decisions, which may conflict with or override the rules. For Mercury, use the automation engine only when you need actions spanning multiple controllers on the same appliance.
- Behaviour to expect: a condition on an input in an unknown state can never be met; removing an interface leaves its conditions empty and invalidates the rule; an offline interface blocks its conditions until it returns.
- To reference a cardholder group in a rule you need the entity **GUID**: in Genetec Configuration desktop, **Access control > Cardholders and credentials**, select the group, then on its Identity page **Ctrl + double-click the entity icon** to copy the GUID to the clipboard.
- **Automation engine mode** (Unit-wide parameters) decides which rule wins when several rules use the *Door - Cardholder authorized* event on the same door with conditions. A rule with that event and **no** conditions behaves like one using *Door - Access granted*.

## Mercury controller integration

### Supported controllers

Mercury **LP** and **MP** controllers talk directly to the Cloudlink appliance and are referred to as *interface modules* because they connect downstream panels (MR50, MR52, MR16IN, MR16OUT and so on). **Mercury firmware 2.4.0 or later is required.** Models include LP1501/MP1501 (2 readers, 1 opening natively), LP1502/MP1502, LP2500/MP2500 and LP4502/MP4502. Datasheets are on the Genetec Resource Center; supported firmware versions are in *Supported firmware in Synergis Softwire*.

### What is not supported

Notable "No" entries for the Mercury integration on Cloudlink:

- Manual enrollment via an Add-hardware dialog, automatic enrollment (Scan), property configuration, configuration cloning, I/O diagnostics, interface-module firmware display. Firmware upgrade is **manual**.
- Double-badge activation is **online only**.

### Adding controllers

1. **Prepare**: assign a **static IP** to the controller (your IT department provides it), give every interface panel on the same RS-485 port of the same controller a **unique physical address** on its DIP switch, and keep the Mercury Setup and Configuration Guide to hand. Best practice: if you have many controllers for one appliance, add them all at once.
2. In Genetec Configuration desktop: **Access control > Roles and units > Cloudlink appliance**, then add the controllers. Each Mercury controller on the appliance needs a **unique channel ID**.
3. Configure reader settings afterwards.

All hardware assigned to a door or elevator must be controlled by the **same Mercury controller under the same Cloudlink appliance** for the door to keep working while the appliance is offline.

### Host decision handoff

Configured at **Configuration > Mercury controller settings > Door settings > Disable host decision handoff (offline mode)**. By default the setting is **disabled**, meaning host decision handoff is **enabled** and the **Cloudlink appliance makes the access decisions**. Behaviour differs materially between the two states - consult the comparison table in the source guide before changing it.

### Database layouts

Selected at **Mercury controller settings > Database layout settings**.

**Feature rich layout (default)**

| Model | Max cardholders |
|---|---|
| LP1501, LP1502, MP1501, MP1502 | 200,000 |
| LP2500, MP2500 | 419,000 |
| LP4502, MP4502 | 500,000 |

Feature support in this layout: default PIN length 6, maximum PIN length 10, native area control (antipassback, interlock, maximum occupancy) yes, two-person rule and visitor escort yes, maximum credential length 64 bits, elevators yes.

A **Long credential** layout exists for credentials up to **240 bits**; credentials of 64 bits or longer are **not** synchronised automatically, so you must enable long-credential support explicitly (select the Long credentials database layout, then define formats on the **Long credential formats** tab). A **Long PINs** layout raises the maximum PIN length to 15.

### PIN behaviour on Mercury

- Mercury does **not** support PINs starting with zero by default; enable it in the Mercury controller settings.
- Using PIN credentials requires each cardholder to have a **card credential and exactly one PIN credential**. If a reader is set to *Card or PIN* but the cardholder has only a PIN, that credential is not synchronised and will not work - the documented workaround is to create and assign a dummy card credential.
- If a PIN is shorter than the configured maximum PIN length, the user must press **#** to submit. Reducing the maximum PIN length to the common length removes that. Before reducing it: PINs longer than the new maximum stop working, and **duress PINs must be at least four digits**.
- Antipassback caveat: with *Card or PIN* set in unit-wide parameters, antipassback is **not applied** to PIN credentials. Workaround - use *Card and PIN*, or use Mercury native area control with host decision handoff disabled. [S27]

### Unlock schedule limits

Mercury implements unlock schedules as **time zones**, and each unlock-schedule time zone allows a maximum of **twelve intervals**. Each door consumes one time zone. Exceeding twelve intervals puts the Cloudlink appliance into a **warning state** in Security Center SaaS and unlock schedules may not apply correctly.

### Native area control limitations

| Feature | Limitation |
|---|---|
| Soft antipassback | The *Antipassback violation* event fires when the **door opens**, not when access is granted. On a door with **no door sensor** the event never fires because the door never registers as opened. **No presence timeout support** |
| Hard antipassback | Hard antipassback that is **not** also Strict is unsupported |
| Antipassback timeout | Supported on hard and strict antipassback |

### Offline SIO boards and facility codes

You can allow access based on specific card formats and facility codes when an SIO board loses its link to the Mercury controller.

- Synergis Softwire supports **8 card formats per Mercury controller** by default; **each facility code counts as one card format**, even multiple codes for the same format.
- Disabling **Magstripe support** under Advanced settings on the Mercury controller settings page raises the limit to **16**. Magstripe is not supported when the Facility code offline behaviour is selected, even with Magstripe support enabled.
- **Security warning from the docs:** this greatly reduces security. No activity trails exist, and no events that occur while the SIO board is disconnected are recorded.
- Related limitation: when a Mercury controller loses its link to Synergis Softwire but stays connected to the SIO boards, the controller validates the facility code before the credential - so if the facility code was never given to Synergis Softwire, access is denied without the credential being considered. [S27]

### Extended grant time REX mode per door

Requires creating a **door custom field** in Genetec Configuration desktop. When enabled, the door stays unlocked for as long as the REX input is active plus the normal grant time - useful for motion-sensor-controlled doors that would otherwise cycle. Limitations: a controller restart returns the door to its normal state until REX triggers again; with no door sensor, the door stays unlocked for the REX-active period or the normal grant time, whichever is longer.

### OSDP readers with Mercury

Pairing (key exchange) is required for OSDP Secure Channel: configure the reader on the controller in Genetec Configuration desktop, then pair it in the Synergis Softwire portal. To move an already-paired secure reader to a different port, **factory reset the reader** first. Connected OSDP readers do not respond to cards until paired.

Onboard OSDP capacity:

| Model | Onboard reader ports | Max onboard OSDP readers |
|---|---|---|
| MR50-S2 | 1 | 1 |
| MR50-S3 | 1 | 2 (both on one port) |
| MR52-S2 | 2 | 2 (one per port) |
| MR52-S3 | 2 | 4 (two per port) |
| MR51e | 2 | 2 (both on the first port) |

Two OSDP readers on **one** port:

- **LP1501, MP1501, MR51e** support two OSDP readers by putting **both on the first port** - terminal block **TB2** on LP1501/MP1501, **TB3** on MR51e. The second port then cannot be used. LP1501/MP1501 must be enrolled **without extension boards** for this.
- **LP1502, LP4502, MP1502, MP4502, MR50-S3, MR52-S3** support two OSDP readers on **each** onboard port. Enable **Two OSDP readers per reader port** in the Synergis Softwire portal *before* configuring the readers in Genetec Configuration desktop.
- All readers on the same RS-485 channel need **different addresses**.
- If you configure only one of a pair, make sure it is the **primary** reader, or the door shows a warning even though it works.
- Known limitation: the connection state of OSDP and OSDP 2 readers is not refreshed if the reader is not assigned to a door or elevator - including *Out* readers when using two OSDP readers per port.
- Known issue: activating a reader tamper while using two OSDP readers per port puts **all doors on that controller** into a warning state with *Interface module tamper state active*. [S27]

### Downstream panel addressing

**MR51e** - single-door PoE panel, must be controlled by a Mercury controller. Only two addressing modes are supported for the Cloudlink integration:

| Mode | DIP switch S1 (4-3-2-1) | Steps |
|---|---|---|
| Public DHCP (recommended) | OFF-OFF-OFF-ON (0001) | Set S1, press S2 (Reset) |
| Static IP | OFF-OFF-ON-ON (0011) | Set S1, open the **MSC MR51e Address Configuration Tool** (download from Mercury), press S2, select the panel by MAC address in *Devices in Programming Mode*, then program it. The panel must be on the same subnet as your computer |

**MR62e** - assign a static IP from the panel's own web page before adding it or its controller under the Cloudlink appliance. Reader addresses are **hard-coded by Mercury** and used in pairs:

| Reader address | Door setup | Turnstiles / elevators |
|---|---|---|
| 0 | Door 1, reader side IN | Yes |
| 1 | Door 2, reader side IN | Yes |
| 2 | Door 1, reader side OUT | No |
| 3 | Door 2, reader side OUT | No |

One card-in/card-out door uses addresses 0 and 2; two card-in/REX-out doors use 0 and 1.

**Disconnecting MR panels:** panels must be **offline** in Security Center SaaS before deletion. Disconnect any doors or zones they control, remove power, wait for the panel to go offline, then in Genetec Configuration desktop **Access control > Roles and units > Cloudlink appliance > Peripherals** select the panel, Edit and remove it.

### Mercury triggers and procedures

Rules that run **on the Mercury controller**, comparable to event-to-actions. A **trigger** supplies the event (the *when*); a **procedure** supplies one or more actions (the *what*). Each trigger links to one procedure; a procedure can serve many triggers.

Action types available to procedures include **Arm/disarm zone** (Disarm masks all zone inputs; Arm arms and unmasks if no inputs are active; Force arm arms but unmasks only inactive inputs; Override arm arms and unmasks everything) and **Control procedure** (Execute, Abort delayed, Resume delayed) among others.

Trigger events include *Access denied: Invalid card format* (format not synced to the controller), *Access denied: Request rejected by controller* (reader mode Locked, unknown credential, Softwire overriding the Mercury grant decision, or an interlock constraint) and *Access denied: Unauthorized cardholder* (access rule schedule mismatch, invalid PIN, native antipassback violation, and others).

Name colours signal configuration problems: **orange** means saved but something failed to resolve and it is not synced to the controller (linked triggers also turn orange; the controller must be online to see this), **red** means required information is missing or invalid. A **Reset to default** button on the triggers-and-procedures page restores entities left in unexpected states - and note it is documented with a caution.

Disabling a trigger un-syncs it from the controller without losing its configuration - useful for temporarily suppressing a rule, or for bisecting an unexpected behaviour by disabling all triggers and re-enabling them one at a time.

## Maintenance and troubleshooting on the appliance

| Task | How |
|---|---|
| Back up configuration | **Maintenance > System status > Download configuration file**, with a password of **at least 15 characters**. Contains hardware settings including supervised input values and automation engine rules. Does **not** contain the appliance admin password |
| Restore during a unit replacement | **Maintenance > System status > Upload configuration file** on the replacement appliance |
| Capabilities report | Per-controller state, feature usage and event logs. The Units list must be refreshed manually and can be viewed as *Over capacity*, *Offline* or *All units* |
| Support bundle | Container-level logs (Softwire crashes on startup or will not start) and application-level logs (Softwire still running), including an encrypted engineering archive **.gen** file that only Genetec Technical Support can read |
| Ping interface modules | **Short ping** completes in under 10 seconds and shows results inline. **Long-term ping** runs once per second for a chosen duration across multiple modules and produces a downloadable **tar.gz** from the diagnostic-logs page. Firewalls may block ping |
| Interface-module firmware | Download the **.sfw** from the GTAP Product Download page (Download Finder > Genetec Cloudlink), upload via **Maintenance > Firmware upgrade**. Modules newer than the recommended version are **downgraded**. Upgradeable: Mercury LP1501, LP1502, LP2500, LP4502, MP1501, MP1502, MP2500, MP4502 |
| Storage cleanup | **Maintenance > Storage**. The figures cover only the Access control application, not the whole appliance |
| Restart the application | Top-right menu > **Software restart** > OK |

## Known issues and limitations (Synergis Softwire on Cloudlink) [S27]

| Area | Issue |
|---|---|
| Networking | On networks with **no DNS server**, downstream controllers cannot be enrolled by hostname |
| Networking | **IPv6 is not supported** on Genetec Cloudlink appliances |
| Networking | Non-FQDN hostnames cannot be resolved if the Cloudlink was powered up with the network cable disconnected, preventing Mercury controllers from coming online |
| Mercury | **Magstripe readers are not supported** |
| Mercury | If the Mercury driver becomes overloaded the controller goes offline and then returns |
| Mercury | Reader tamper with two OSDP readers per port puts all doors on the controller into warning |
| Mercury | With *Card or PIN*, antipassback is not applied to PIN credentials |
| Mercury | Offline SIO facility-code validation precedes credential validation |
| Mercury | With relock-after-X-seconds, the *Door locked* event timestamp reflects when the door **opened**, not when it physically relocked |
