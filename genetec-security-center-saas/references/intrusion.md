# Intrusion detection

Source: Setup Guide, Device management > Intrusion. [S6] Ports: [S2] Reports: [S9]

## How it fits together

Security Center SaaS reaches third-party intrusion panels through the **Intrusion application** running on a Genetec Cloudlink appliance. The chain is:

| Component | Role |
|---|---|
| Security Center SaaS | Panels are added on the **Devices** page in the Configuration task. Users monitor intrusion areas, inputs and outputs, generate event reports and review video of intrusion events in monitoring tiles |
| Genetec Configuration desktop | Where panels are actually configured and managed - the **Intrusion detection** task |
| Genetec Intrusion Protocol extension | Part of the **Intrusion role** in the cloud. Securely connects Security Center SaaS to the Intrusion app on the appliance |
| Genetec Cloudlink | Connects to panels over Ethernet and hosts the Intrusion app |
| Intrusion app | Contains a **Genetec Intrusion Bridge** that relays events and commands between panels and the cloud |
| Intrusion panels | Monitor zones, detect unauthorised access, raise alarms and events per their own rules |

The panel must be on the **same network as the Cloudlink appliance**. Appliance maxima are in `appliances-cloudlink.md` - 4 panels on a Cloudlink 110, 10 on a 210, 310 or 2210, less when sharing the appliance with video or access control. [S3]

## Network best practice - isolate the panels

The documentation is emphatic about this. [S6]

- Intrusion panels are not built to absorb heavy network throughput, especially frequent broadcast traffic. The panel must inspect every incoming packet to decide whether it is the recipient, which burns processing capacity. Under load the panel may repeatedly drop offline and reconnect.
- The recommended pattern is to put panels on an **isolated network** behind the Cloudlink so they never see traffic addressed to anyone else. Multiple panels can share that isolated network as long as it carries nothing unrelated to panels.
- If your panel manufacturer's protocol has **no encryption**, hosting the panels on an isolated private network is presented as a requirement, not an option, to stop attackers intercepting panel traffic.
- Build the isolated network with a dedicated switch or router, or use the appliance's second Ethernet port in isolated-network mode. Remember ports 1 and 2 must be on **different subnets**.

## Required ports on the appliance

| Direction | Port | Purpose |
|---|---|---|
| Outbound | TCP 2624 | Intrusion app (Genetec Intrusion Bridge) to the Genetec Intrusion Protocol extension in Security Center SaaS, at {GenetecReference}.gsc-cloud.com |
| Outbound | TCP 7700 | Bosch intrusion panels |
| Inbound | TCP 10002-10005 | Honeywell Galaxy event transmission. **These open automatically when you add a panel to a Cloudlink** |
| Outbound | TCP 10005 | Honeywell Galaxy commands. **Not configurable** |

Unblock these on every router, switch and network device between the panel and the appliance. [S2]

## Bosch panels

### Preparation (Bosch RPS)

1. Choose one of the supported Ethernet modules (see the table below).
2. Enable communication between Bosch **Remote Programming Software (RPS)** and the panel - USB cable, the onboard Ethernet communicator, or a B420/B426 module.
3. Configure panel settings in RPS: intrusion areas, inputs (**RPS calls inputs "points"**), outputs (relays) and other behaviour.
4. Enable panel-to-Security-Center-SaaS communication: in RPS, right-click the panel > **Open Panel View** > Connect. Under **Panel Wide Parameters > On Board Ethernet Communicator** set *IPv4 DHCP/AutoIP Enable* to **No**, enter an IPv4 address, and note the panel's IPv4 address and TCP/UDP port - you need both when adding the panel.

### Ethernet module compatibility

| Module | B Series | G Series |
|---|---|---|
| B420 | Yes | Yes |
| B426 | Yes | Yes |

Using an external Ethernet module is **optional** - B-series panels have an onboard module. Important caveats for the **B426**: it requires **TLS 1.2**; Bosch B-series panels support Bosch **Mode 2** arming; and connecting through an external B426 on Bosch B or B/G series panels **might break the integration**, because the panel sometimes causes data-overflow errors on the B426. The documented best practice is to connect through the **onboard Ethernet module**, which uses asynchronous communication.

### Adding the panel

**Configuration > Devices > Add device > Intrusion panel**, choose the Cloudlink appliance it connects to on the Method page, then enter the panel's name, IP address, port and passcode. Also enable Bosch intrusion areas to be triggered in Security Center SaaS beforehand.

### Panel settings in Security Center SaaS

**Devices > Bosch panel > Settings**:

| Field | Notes |
|---|---|
| Passcode | Pulled from the panel. **Must match the panel's configured passcode** |
| Default input EOL resistor scheme | The resistor type the panel uses |
| Contact type | The contact type the panel uses |

### How Bosch input states map

Normally closed contact type:

| Bosch panel state | Single EOL resistor | Dual EOL resistor |
|---|---|---|
| Normal | Normal | Normal |
| Open | Active | Trouble (Open) |
| Short | Trouble (Short) | Trouble (Short) |
| RX2 | - | Active |

Normally open contact type (single EOL only): Normal maps to Normal, Open maps to Trouble (Open), Short maps to Active. **Bosch 5.1.0 panels do not support the *Normally open* contact type with a Dual EOL resistor** - such a panel returns the same states as a *Normally closed* configuration.

### Manual output triggers via virtual outputs

Virtual outputs let operators activate a Bosch output without the panel raising an alarm - used to test workflows, validate configuration and start response procedures manually. Three steps:

1. **Create the virtual output on the panel.** In Bosch RPS: **POINTS > Point Assignments**, pick a point with an unassigned source, set its **Source** to *Output*, then assign a point profile and an area profile. Save, then click **Synchronization**. RPS pushes the point and Security Center SaaS gains a matching input and output.
2. **Map it in Security Center SaaS.** Genetec Configuration desktop > **Area view** > select the intrusion detection area > **Properties**: pick the **Output** physically connected to the input, and the **Input** physically connected to the output. Apply. The input becomes a *virtual input*.
3. **Assign the virtual output to the area.** **Intrusion detection** task > select the panel > **Intrusion detection areas** tab > Edit > choose the output in **Output to trigger alarm** > Save > Apply.

Operators can then trigger the output from the Monitoring and Maps tasks. Note: if an alarm is silenced on the panel, the associated area shows **Normal** in Security Center SaaS rather than *Silent*.

## Honeywell Galaxy panels

### Preparation (Galaxy RSS)

Confirm the panel is on the SDL, read the Honeywell documentation for your hardware, review the network-isolation best practice, and unblock the required ports. Panels must be functioning and have an **Ethernet module installed**. You need the panel's IP address. Configuration is done with the **Galaxy RSS** Windows application, locally or remotely.

**Dimension panels:** sign in to RSS, select the panel, then replace the default remote user code - **Users > System Users > General tab > Remote section > change the PIN**. By default that user is named **REMOTE** with PIN **543210** at user level **3.8**. Then continue with the Ethernet access configuration.

**Flex panels:** same first step; the new PIN must be a unique four-, five- or six-digit number. Then **Global Systems Options > System Parameters** and onward.

The docs carry an explicit caveat that third-party website references were accurate at publication and may change without notice.

### Adding the panel

Prerequisites: the panel's **IP address, port and passcode**, plus the panel configuration exported from Galaxy RSS via **File > Export XML**.

1. **Configuration > Devices > Add device**, follow the wizard.
2. **Devices > select the panel > Configuration**.
3. Enter the **Remote PIN**.
4. Choose the **DIP switch 8** setting the panel uses.
5. Import the configuration file: **Select a file**, choose the exported XML, Open.
6. Save.

**If you change panel settings later you must re-import the XML into Security Center SaaS.** The panel's intrusion areas, inputs, outputs and users are imported and become visible in the **Intrusion** task in Genetec Configuration desktop.

### Galaxy-specific restrictions

- Security Center SaaS **cannot create intrusion areas manually** for Honeywell Galaxy panels. Create the area in Galaxy RSS and re-import the configuration file.
- For Galaxy panels, only the **names** of intrusion areas, inputs and outputs can be edited in Security Center SaaS (on the entity's Properties page). Every other change goes through Galaxy RSS followed by a re-import.
- Galaxy panel **users can only be removed through the Honeywell software**.

## Intrusion areas, inputs and outputs

### Creating areas manually (non-Galaxy)

If areas were not auto-created at enrollment: Genetec Configuration desktop > **Intrusion detection** task > next to the *Intrusion detection unit* button click the arrow and choose **Intrusion detection area** > Basic information > select the controlling **Intrusion detection unit** > Summary > Create > Close.

### Modifying areas, inputs and outputs

**Intrusion detection** task > expand the Intrusion role > select the panel, then the **Intrusion detection areas**, **Intrusion inputs** or **Intrusion outputs** tab, edit the item, Save, then Apply.

### Associating cameras

- **To an area**: Genetec Configuration desktop > **Area view** > select the intrusion detection area > **Cameras** tab > Add an item > pick the camera > OK > Apply.
- **To an input**: **Intrusion detection** task > select the panel > **Peripherals** tab > select the input > *Assign cameras to the selected input device* > pick the camera > OK > Apply.

This is what makes video of an intrusion event viewable in Security Center SaaS.

### Input icons

**Intrusion detection** task > Intrusion role > **Input definitions** tab > drop-down beside an input type > **Browse** > choose an icon file > Open > Apply.

## Cardholders on panels

Panel users are called **cardholders** in Security Center SaaS.

| Task | Steps |
|---|---|
| Import existing panel users | **Intrusion detection** task > Intrusion role > *Genetec Intrusion Bridge cardholder selection* tab > select a bridge > **Import all cardholders** > OK. They are created as individual cardholders. **This overwrites the cardholders listed on that tab** |
| Push cardholders to a panel | Same tab, **Add an item** and select cardholders or cardholder groups (or *Import all cardholders* to push everything), OK, Apply. Then expand the **Intrusion Manager** role, select the panel, **Users** tab, **Add user**. With multiple panels on one bridge you can push to all of them simultaneously |
| Bosch user fields | **User** (user or user group), **User group**, **Authority levels**, **Supervised** (affects controller behaviour) |
| Temporarily remove access | Panel > **Users** tab > **Exclude** the cardholder; status becomes *Excluded*. **Re-instate** to restore. Adding a cardholder to an excluded cardholder **group** revokes their panel access; removing them from that group restores it automatically |
| Permanently remove | Panel > **Users** tab > **Delete** > Apply |

Honeywell Galaxy users can only be removed via Honeywell software.

## Genetec Intrusion Protocol parameters

Applied to **all** units connected to the Intrusion role. Genetec Configuration desktop > **Intrusion detection** > Intrusion role > **Extensions** tab > **Genetec Intrusion Protocol**. (Per-unit overrides live on the unit's Properties page.)

| Parameter | Default | Meaning |
|---|---|---|
| Grace period | 5 minutes | Window during which offline events from the panel are treated as live - logged and pushed to online users |
| Alarm grace period | 30 minutes | Same, for **alarm events**: input alarm activated, intrusion detection area alarm activated, intrusion detection area duress, intrusion detection unit tamper |
| Persistence grace period | 30 minutes | Window during which offline events are logged but **not** pushed to online users. Offline events older than this are **discarded** |
| Trigger input events | - | **Always**: every new event from a given input raises a new alarm event in Security Center SaaS. **When intrusion detection area is armed**: only while armed |

## Triggering alarms on panels that cannot accept external activation

Some panels cannot have an alarm activated from an external source. The workaround creates a **virtual alarm**:

1. On the panel, associate an input pin with an alarm (may need proprietary software), then **physically wire that input pin to an output relay on the same panel**.
2. Genetec Configuration desktop > **Area view** > select the intrusion detection area > **Properties**: choose the **Output** relay that is wired to the input pin, and the matching **Input**.

The input that you wired becomes a *virtual input*. From then on, the **Trigger intrusion alarm** action activates the output, which drives the physical alarm input on the panel and raises the alarm.

## Putting panels in front of operators

To let operators monitor and control intrusion, add the entities to maps (all in Genetec Configuration desktop > **Map designer**):

1. Create the intrusion areas.
2. **Add intrusion detection areas to maps** - Entities > Area view, drag the area onto the map, then configure *Show states* colours per panel state, size and rotation under Position, and a double-click action.
3. **Add them as shapes** - draw a shape from the Shapes section (click once per endpoint, click the first point to close a polygon, Shift+click to add or remove a point between two points, double-click a point to finish without closing), then use the **Identity** list to link the shape to the intrusion area. A shape with no entity is just a point of interest. The **Links** list turns the shape into a map link.
4. **Add input pins and output relays** - Entities > **I/Os**, drag an input or output onto the map. For inputs, set a double-click action. For outputs, add one or more **Output behaviours** under Output behaviors; when an operator clicks the output on the map, the available behaviours appear in a menu bubble.
5. Save the map.

## Reporting on intrusion (Genetec Operation desktop) [S9]

| Task | Filters |
|---|---|
| **Intrusion detection area activities** | Intrusion detection areas, Event timestamp (absolute or relative such as previous week or month), Events, Initiator |
| **Intrusion detection unit events** | Intrusion detection units, Event timestamp, Events. Covers AC fail, Unit lost, Intrusion detection unit input trouble, and similar |

Generate the report, then double-click or drag a row to the canvas to see the corresponding video. With no camera associated to the area, the area icon is shown instead. Use the intrusion detection area widget to control the tile.

## Deleting panels

**Configuration > Devices > select the intrusion panel > ... > Delete**, then type the panel name to confirm. If you have deleted **all** panels connected to a Cloudlink, also delete the now-empty **Genetec Intrusion Bridge**: Genetec Configuration desktop > **Intrusion detection** > select the Intrusion Manager > *Genetec Intrusion Bridge* tab > select the bridge with no enrolled units > Delete > Apply. The same cleanup applies when you delete a Cloudlink that had panels attached.
