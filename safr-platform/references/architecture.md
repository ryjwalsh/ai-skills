# SAFR Architecture (on-premises)

Source IDs in brackets refer to `sources.md`. Exact strings are verbatim from the docs.

## 1. What SAFR Server is

SAFR Server consists of a recognition engine, an event server, an object server, a Video
Recognition Gateway Administrator (VIRGA) service, and several databases. It runs as several
background services that automatically start on system reboot and are kept active by the
operating system; they must be running at all times for the SAFR system to be operational. [S2]

On Windows, SAFR is installed as a SYSTEM user. Permissions are set so any administrator
account can administer the server, including changing configuration files, viewing log files,
and running scripts. [S2]

## 2. Core sub-systems and their on-disk names

The logging documentation enumerates the core systems and the directory each one owns. [S3]

| Sub-system | Documented long name | Directory |
|---|---|---|
| COVI | Computer Vision Service (COVI) | `covi\` |
| Event Server | Event Server | `cv-event\` |
| VIRGA | Video Recognition Gateway Admin Service (VIRGA) | `virga\` |
| Reports | Reports | `cv-reports\` |
| CVOS | Computer Object Service (CVOS) | `cv-object-storage\` |

Naming inconsistency: `cv-object-storage` is called **Computer Object Service (CVOS)** in the
logging doc [S3] and the **Object Storage Service** in the redundancy doc [S6]. Same component.

Windows service display names are **Not documented** on the pages retrieved. The `check`
script is the documented way to enumerate service status rather than the Services applet. [S4]

## 3. Filesystem roots

| Purpose | macOS | Linux | Windows |
|---|---|---|---|
| Program / scripts root | `/Library/RealNetworks/SAFR` | `/opt/RealNetworks/SAFR` | `C:\Program Files\RealNetworks\SAFR` |
| Scripts | `<root>/bin` | `<root>/bin` | `<root>\bin` |
| Port config | `/Library/RealNetworks/SAFR/safrports.conf` | `/opt/RealNetworks/SAFR/safrports.conf` | `C:\Program Files\RealNetworks\SAFR\safrports.conf` |
| Logs / config / databases | Not documented | Not documented | `C:\ProgramData\RealNetworks\SAFR\` |

Log paths in [S3] are relative to the install location, and that doc gives the default Windows
install location as `C:\ProgramData\RealNetworks\SAFR\`, while the scripts doc [S4] gives the
Windows program root as `C:\Program Files\RealNetworks\SAFR`. Both are real: binaries and
scripts under `Program Files`, logs and mutable data under `ProgramData`. [INFERRED - verify]

## 4. Installable components

From the Windows silent-install flag table, which doubles as the component list. [S5]

| Component | Flag | Default |
|---|---|---|
| SAFR Actions | `/Actions` | Enabled |
| Desktop Client | `/Application` | Enabled |
| Web Console | `/Console` | Enabled |
| SAFR Reports | `/Reports` | Enabled |
| SAFR Logs | `/Logs` | Enabled |
| VIRGA | `/VIRGA` | Enabled |
| VIRGO | `/VIRGO` | Enabled |
| GPU Accelerated Recognition (HTFS) | `/GPUFaceService` | Enabled only if NVIDIA drivers greater than 418.67 are detected |
| GPU Accelerated Detection (client) | `/CUDA` | Enabled; OK to install even if NVIDIA drivers aren't installed |

Face service models, all Enabled by default: `/Age`, `/Gender`, `/Mask`, `/MaskIdentity`,
`/Sentiment`, `/Occlusion`, plus `/OptimizeModels`. [S5]

## 5. VMS integration plugins

All **Disabled by default**. The docs state only one VMS plugin is allowed - the first
specified plugin will be used. [S5]

| Plugin | Flag |
|---|---|
| Avigilon | `/Avigilon` |
| Digifort | `/Digifort` |
| Genetec | `/Genetec` |
| GenetecFR | `/GenetecFR` |
| Geutebrueck | `/Geutebrueck` |
| Milestone | `/Milestone` |
| Video Insight | `/VideoInsight` |

**Genetec-relevant:** `/Genetec` and `/GenetecFR` are two distinct plugins, and because only
one VMS plugin may be active a single SAFR Server cannot run both. Which Genetec scenario maps
to which flag is **Not documented** - see `known-gaps.md`.

Camera extension: Ximea, `/Ximea`, Disabled by default. [S5]

## 6. Cluster topology

The first SAFR Server installed automatically becomes the primary server; all subsequent
servers are secondary servers. [S6]

| Type | Replicates database data | Counts toward failover |
|---|---|---|
| Simple | No | No |
| Redundant | Yes | Yes, first two only |

Rules that matter operationally [S6]:

- Only Windows and Linux SAFR Servers can become redundant secondary servers.
- Failover requires at least two redundant secondary servers (three servers total). If the
  primary goes offline and both of the first two installed redundant secondaries are online,
    one becomes the new primary and the cluster continues to function.
    - Redundant secondaries beyond the first two receive replicated data but do not count for
      failover.
      - With both secondary types, feed management, reports, and the Web Console are **not**
        load-balanced and are always served from the primary server.

        ## 7. Object storage

        Object Storage Redundancy is only available on Windows and Linux. The Object Storage Service
        stores objects such as profile and event images, plus ephemeral data such as event reply
        messages. All redundant secondary servers are load-balanced by the primary server for Object
        Storage Service requests it receives. [S6]

        | Mode | Behaviour | Backup implication |
        |---|---|---|
        | Shared (network storage, e.g. NAS) | Every server reads and writes the same location | Backup runs from the primary server only |
        | Local (**Not Recommended** per docs) | Each redundant server saves locally and asks other Object Storage Servers for objects it lacks | Backups must be run on every redundant server that has Object Storage enabled |

        Documented local-storage risk: while a server is offline you lose access to objects only stored
        on it, and if that server's objects are lost without backups they are unrecoverable. [S6]

        ## 8. External load balancer reference deployment

        Three servers - A primary, B and C redundant secondaries - plus a NAS. [S6]

        | State | Recognition requests | DB writes | DB reads | Notes |
        |---|---|---|---|---|
        | All healthy | Across all three | Server A | All three | No single point of failure |
        | Secondary B fails | A and C | Server A | A and C | B dropped from load balancer and from the database replica set; no outage, longer latency possible; no object storage impact |
        | Primary A fails | B and C | Server B | B and C | A dropped from load balancer and replica set; B's database takes over as primary; no outage, longer latency possible |

        ## 9. Databases

        The DBMS product is **not named** on any page retrieved. [S2] says "several databases"; [S6]
        uses the phrase "database replica set" and describes primary/secondary write and read
        splitting. Do not assert a specific database engine - log a gap instead. Cache tuning exists
        and is documented separately as an advanced option most users do not need. [S2]

        ## 10. GPU and driver dependency

        The only concrete driver threshold documented is NVIDIA drivers **greater than 418.67**, which
        gates whether `/GPUFaceService` (HTFS, GPU accelerated recognition) is enabled by default on
        Windows install. [S5] Client-side `/CUDA` may be installed regardless. [S5]

        ## 11. Adjacent components

        | Product | Relationship |
        |---|---|
        | VIRGO | Video ingestion agent managed by VIRGA; own logs and tooling, see `troubleshooting.md` |
        | SAFR SCAN | Reader appliance with its own web console, see `scan-diagnostics.md` |
        | SAFR Actions | Event-driven action engine installed by `/Actions` |
        | Genetec Security Center | External VMS/ACS, see `genetec-integration.md` |

        ## 12. Documentation vintage warning

        Server, VIRGO and REST API pages carry an older documentation stamp than the Genetec and SCAN
        guides, and install examples still reference SAFR Platform 1.8 / 2.0 filenames such as
        `SAFRPlatform_win_1_8_302_08_13_19.exe` and `SAFRPlatform_linux-ubuntu_2_0_022_03_03_20.sh`.
        [S5] Treat component lists as structurally correct but verify defaults against your installed
        build. See `version-matrix.md`.
        
