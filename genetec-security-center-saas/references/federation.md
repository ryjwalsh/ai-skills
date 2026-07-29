# Federation and reverse tunneling

Source: Federation in Security Center SaaS. [S10] Ports: [S2]

## What Federation does

Security Center Federation joins multiple independent Security Center or Security Center SaaS systems into one virtual system. Users on the central system - the **Federation host** - can view and control entities belonging to the remote systems. On the host you create a **Security Center Federation role** per remote system; that role is the connection.

Stated benefits: centralised global oversight with local autonomy preserved, automated real-time synchronisation so you stop manually checking each system, and cheaper cross-site collaboration.

## Two directions, two very different setups

| | Federating **Security Center SaaS into Security Center** | Federating **Security Center into Security Center SaaS** |
|---|---|---|
| Federation host | On-premises Security Center | Security Center SaaS (cloud) |
| Result | SaaS systems are visible in Security Center, managing on-prem and cloud in one interface | On-premises systems are visible to SaaS operators, monitored from the cloud |
| Reverse tunneling | **Not used** | **Required** |
| Credential mechanism | Generated Federation-user connection credentials in Security Center SaaS | Standard Security Center user credentials on the remote system, plus a tunnel keyfile |

**Licensing:** Federation is **not automatically included** in Security Center SaaS licensing. Check the subscription before designing around it.

**Video format:** only **H.264** is supported for federated video. To view H.265 (HEVC) or AV1 federated streams, workstations need an NVIDIA GPU or Intel Quick Sync (11th-generation CPU or newer) plus a current Chrome or Edge. [S2]

## Reverse tunneling

### The idea

Reverse tunneling secures communication between clients and servers behind a firewall by making the **server initiate the connection to the client**. The tunnel is authenticated by a previously shared **keyfile** containing an identity certificate. Once up, the tunnel carries **bidirectional** traffic **without opening any inbound firewall ports**.

In Security Center SaaS it connects one or more remote on-premises Security Center systems to the cloud Federation host. By default the tunnel uses **outbound TCP 5500** from the remote site to the host.

Normally, a Federation host is the client connecting to the federated site acting as server. Reverse tunneling **inverts** that flow.

### Roles involved

| Role | Where | Function |
|---|---|---|
| **Reverse Tunnel Server** | Federation host (Security Center SaaS) | Generates a keyfile per remote site containing an identity certificate, network connectivity information and a **one-time-use token** |
| **Reverse Tunnel** | Remote site (on-premises) | Accepts the keyfile to open the tunnel |
| **Security Center Federation** | Federation host | Connects to the federated site **through** the tunnel |

### Limitations and requirements

- **TCP only.** The network segment used for tunneling between the remote site and the host must support **unicast TCP**. Once video reaches the cloud, the *Best available* transport protocol can be used.
- The server hosting the **Reverse Tunnel Server** role must be reachable from remote sites that can resolve its hostname via DNS.
- **Keyfiles are single-use.** They are only needed to establish the first connection from the remote site to the host.
- **Fusion-stream-encrypted video cannot be played back in Security Center SaaS or in the SC SaaS Operation mobile application.**

## Procedure: Security Center into Security Center SaaS

### Before you begin

Gather:

- The names of the remote sites to federate and the Security Center version each runs.
- Credentials for each remote system, for **both** the Federation user and an administrator.
- An external storage device to hold the tunnel keyfiles.
- Confirmation that the Reverse Tunnel Server host is DNS-resolvable from the remote sites.

Use a workstation that can reach both the Federation host and the remote sites if you can - it saves shuttling keyfiles around.

### Step 1 - create the reverse tunnel on the host

Genetec Configuration desktop, signed in to the Security Center SaaS system:

1. **System > Roles > Reverse Tunnel Server > Properties**.
2. **Add an item** at the bottom of the page.
3. Enter a unique **Name** identifying the remote site, click **Add**. The tunnel appears with status **Not registered**.
4. **Apply.** All reverse tunnels have **encryption enabled by default**, so video is encrypted in transit from the remote site to the host.
5. Get the keyfile: **Copy keyfile to clipboard** if your workstation can reach the remote site, or **Save keyfile to disk** which writes `<SiteName>.keyfile` to the folder you choose.
6. **Apply.**

### Step 2 - open the tunnel from the remote site

In Config Tool on the remote system:

1. **System > Roles > Add an entity > Reverse Tunnel**.
2. On the *Specific info* page, provide the keyfile - paste it into **Tunnel keyfile** if it is on the clipboard, or **Select file** and browse to it. The tunnel site name and its creation time are displayed. If you used the wrong keyfile, click **Clear** and try again.
3. Confirm the name and click **Next**.
4. Optionally set a role name and description. The default is *Reverse Tunnel*; **if multiple hosts federate this site, give each a different name**.
5. **Next > Create > Close.** The role takes a few seconds to connect to the Reverse Tunnel Server on the host.
6. Optionally on **Properties**, pick an **Encryption** option (see below).
7. Optionally turn on **Create agents on role servers**. By default, servers hosting the Directory, Media Router and Redirector roles **all** need internet access for reverse tunneling; with this option on, only the servers listed on **Resources** need outbound internet.
8. Optionally configure failover for the Reverse Tunnel role on the **Resources** tab.

**Encryption options:**

| Option | Behaviour |
|---|---|
| Encrypt | Encrypt video in transit from the remote site to the host |
| Prefer encryption | Encrypt if both ends support TLS. Use when you are unsure of the host's capabilities |
| Do not encrypt | No encryption in transit. Only if video is encrypted by other means |

**Connections to a Security Center SaaS Federation host require encryption by default.**

### Step 3 - point the Federation role at the tunnel

In Genetec Configuration desktop on the Security Center SaaS system:

1. **System > Roles.** The Security Center Federation roles you need are **created for you** - you configure them.
2. If needed, select an **UnconfiguredFederation** role in the entity tree and **activate** it, then rename it on the **Identity** tab.
3. Select the Security Center Federation role, open **Properties**, and set the **Directory** field to the reverse tunnel name in this exact form:

`directory.<sitename>.tunnel.genetec.com`

where `<sitename>` is the name you gave the site in the Reverse Tunnel Server role. For a remote site named VM31614 you enter `directory.VM31614.tunnel.genetec.com`. **The string is not case-sensitive.**

4. Configure the remaining Federation role settings:

| Setting | Meaning |
|---|---|
| Username and password | Credentials the Federation role uses to sign in to the remote Security Center. **The rights and privileges of that user determine what your local users can see and do on the federated system** |
| Resilient connection | Automatically retry after an interruption. If the role cannot reconnect within the reconnection timeout the connection is considered lost and the role enters a warning state. **Strongly recommended for remote systems with an unstable cloud connection** |
| Reconnection timeout | Seconds the role keeps retrying before declaring the connection lost |
| Forward Directory reports | Surfaces user activities and configuration changes made at the federated site - viewing cameras, activating PTZ and so on - supplied by the remote Activity Trails |

## Resetting a reverse tunnel

Needed when the identity certificate of the Federation host or the remote site changes **while the tunnel is disconnected**. A reset is **not** required if the host certificate is replaced while the tunnel is connected - the new certificate propagates automatically.

1. On the host: **System > Roles > Reverse Tunnel Server > Properties**, select the site with the broken tunnel, click **Force re-enrollment of this site**, OK, **Apply**. The site reverts to **Not registered**.
2. Obtain the new keyfile with **Copy keyfile to clipboard** or **Save keyfile to disk**.
3. On the remote site in Config Tool: **System > Roles > Reverse Tunnel > Properties**, optionally set the **Encryption** option and **Create agents on role servers**, then supply the new keyfile by pasting it or selecting the file.

Remember the single-use rule - a keyfile that has already opened a tunnel cannot be reused.

## Procedure: Security Center SaaS into Security Center

No tunnel. You generate connection credentials for a **Federation user** in Security Center SaaS, and that user controls what the on-premises host can reach.

### Before you begin

**Enable the *Secure communication* option in your Security Center system.** Without it you cannot stream live or playback video from the federated Security Center SaaS system.

### Steps

1. Sign in to Security Center SaaS.
2. **Configuration > Global settings > Integrations > Federation**.
3. Click **Add**.
4. In **New connection credentials**, supply a username for the Federation user and **Save**. The credentials are created, and the Federation user is **automatically granted the required privileges, including the Federation privilege**.
5. Optionally **Generate new password**, adjusting the length, then **Generate**.
6. To remove a Federation user, select it, **More > Delete**.

**You can generate connection credentials for up to five Federation users.**

### After you finish

Record the **Directory host**, **username** and **password** for the Federation user - they are what Security Center needs. Then in Security Center, create and configure a **Security Center Federation** role to complete the connection.

## Port summary

| Computer | Direction | Port | Destination | Purpose |
|---|---|---|---|---|
| On-premises Directory | Outbound | TCP 5500 | `*.gsc-cloud.com` | Reverse-tunnel communication |

That is the only default documented. Administrators may choose different ports, and the current Federation port diagrams come from your Genetec channel partner. [S2]

## Things that surprise people

- **ALPR in Security Center SaaS is only available through Federation.** [S7]
- Federated cameras are **excluded from intelligent search**. [S9]
- Dewarping of federated fisheye cameras works only for cameras federated from **Security Center 5.13 or later**. [S6]
- In the **Tiles** task, federated **virtual zones** are one of only three entity types that populate a tile, alongside cameras and doors. [S9]
- Remote-site cameras should support **multiple streams** so the outbound stream can be a lower-bandwidth one; managed devices support only a single stream. [S2]
