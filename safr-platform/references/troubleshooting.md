# SAFR Troubleshooting - symptom first

Organised by what the user reports, because that is how questions arrive. Each entry gives
probable causes ordered by likelihood, the exact checks, and the resolution.

SAFR SCAN reader symptoms are in `scan-diagnostics.md`. Genetec symptoms are in
`genetec-integration.md`.

## Contents

| # | Symptom |
|---|---|
| 1 | Always do this first |
| 2 | SAFR services are down or the system is unresponsive |
| 3 | "There is nothing in the logs" |
| 4 | Unauthorized access error after moving or reinstalling the server |
| 5 | Server suddenly stopped working / discontinued operation |
| 6 | New video feeds refuse to connect |
| 7 | Cannot add people - error on enrolment |
| 8 | All feeds die with "Unexpected termination" (Linux) |
| 9 | Feed stuck prerolling with "Codec parameters not found" |
| 10 | virgod crashes constantly after editing config |
| 11 | VIRGO crashes on macOS |
| 12 | Feed reports "No Recogniser Available" |
| 13 | Recognition is slow, or detections are being missed |
| 14 | Certificate or trust warnings after a hostname change |
| 15 | Port conflict on install |
| 16 | Failover did not happen when the primary died |
| 17 | Images or events missing after a server outage |
| 18 | Events not appearing in the other system |
| 19 | Search by image returns nothing |
| 20 | What to collect before opening a vendor ticket |

## 1. Always do this first

| Step | Command | Why |
|---|---|---|
| Confirm services | `check` / `check.bat` [S4] | Everything else is meaningless if a sub-system is down |
| Confirm version and environment | Web Console Status page, **Version** and **Environment** fields [S14] | On-prem must read `SAFR Local`. Version pins which docs apply |
| Confirm licence health | Status page **License Information** [S9] [S14] | Licence expiry and report failures silently stop the product |
| Confirm ports | `portcheck` [S4] | Ports are site-specific |
| Check load and latency | Status page **Load** and **Latency** [S14] | The only numeric performance indicators SAFR exposes |

## 2. SAFR services are down or the system is unresponsive

SAFR Server runs as several background services that automatically start on system reboot and
are kept active by the operating system. They must be running at all times for the SAFR system
to be operational. [S2]

| Likelihood | Cause | Check | Resolution |
|---|---|---|---|
| 1 | A sub-system stopped | `check` [S4] | `stop` then `start`. Both act only on the current machine, so repeat per node in a cluster [S4] |
| 2 | Post-upgrade partial state | Was an upgrade run? Cluster upgrades must be done primary-first, then secondaries [S7] | Complete the documented order, then restart CoVi on secondaries [S7] |
| 3 | Port conflict with other software | `portcheck` [S4], inspect `safrports.conf` | Run `configure-ports` after correcting `safrports.conf` [S4] |
| 4 | Licence lapse stopping the product | Status page licence fields [S9] | See sections 4 and 5 |
| 5 | Accessed via NVIDIA MAF | The docs warn some scripts may not work under the NVIDIA Metropolis Application Framework [S4] | Do not rely on script output in MAF deployments |

There is **no documented way to restart an individual sub-system** and Windows service display
names are not published, so per-service restart is **Not documented**. The one documented
single-service action is stopping and restarting the CoVi service on secondaries during a
cluster upgrade. [S7]

## 3. "There is nothing in the logs"

This is usually true and usually expected.

| Cause | Detail |
|---|---|
| Defaults are `WARN` | COVI, Event Server, VIRGA and CVOS all default their Application log to `WARN`. Performance logging defaults to `OFF` [S3] |
| 14-day retention | All rotated logs are kept 14 days [S3] |
| VIRGO keeps no history at all | The VIRGO daemon does not keep a log history. Log information is only generated and retained while you are actively running a `virgo service log` command [S21] |

Resolution: raise the level in `logback-spring.xml` for the relevant service, reproduce, then
lower it again. See `operations.md` 5.3. For VIRGO, start logging **before** reproducing:

```
virgo service log D/capture D/cop-http
virgo service log D/tracking[foo]
```

VIRGO log levels, least to most verbose: `O` Off, `E` Error, `W` Warn, `I` Info, `D` Debug,
`V` Verbose. [S21]

VIRGO log packages [S21]:

| Package | Per-feed? | Covers |
|---|---|---|
| `detection` | yes | Object detector messages |
| `recognition` | yes | Face recognizer messages |
| `tracking` | yes | Object tracker messages |
| `capture` | yes | Image capture messages |
| `events` | yes | Event reporting messages |
| `pose-liveness` | yes | Pose Liveness Action Recognizer messages |
| `feed` | yes | Feed life cycle messages |
| `cop-http` | no | COP over HTTP messages |
| `config` | no | Virgod configuration management messages |
| `updates` | no | Virgod update initiation messages |

Predicate syntax is `level/tag` or `level/tag[feedName]`. If both a global and a feed-specific
level are set for a tag, the level with higher priority is applied. [S21]

## 4. Unauthorized access error after moving or reinstalling the server

**This is the single most commonly mishandled SAFR failure.** [S9]

| Cause | Check | Resolution |
|---|---|---|
| The primary server was uninstalled and reinstalled on a different IP within 24 hours | Was the server uninstalled, and did the IP change? | Wait the full 24 hours, or contact your SAFR Account Manager to manually reset the IP address |

Critical distinction: this applies only when the server was **uninstalled**. If the IP address or
hostname changes while the server remains installed, there is no problem - the server simply
informs the SAFR License Server of its new address at its next check-in. [S9]

## 5. Server suddenly stopped working / discontinued operation

| Likelihood | Cause | Check | Resolution |
|---|---|---|---|
| 1 | Licence expired | Status page licence info: **Expiration date** [S9] | Renew. After the expiry date SAFR software discontinues operation |
| 2 | Could not reach the licence server within **Max Days Between Reports** | Can the server reach `cv-instam.real` on port `443`? [S9] | Restore outbound access, or obtain a special offline licence via your account manager |

Both are hard stops, not degradations. Check them before investigating anything else.

## 6. New video feeds refuse to connect

| Likelihood | Cause | Check | Resolution |
|---|---|---|---|
| 1 | **Max Feeds per Hour** reached | Status page **Feeds with active recognitions** vs licensed maximum [S9] [S14] | Excess feed connection attempts all fail by design. Existing feeds must be disconnected for **1 hour** before the licence slot can be reused |
| 2 | Double counting | Is one camera feeding two Desktop Client instances? | That counts as **2 video feeds** for licensing [S9] |
| 3 | Feed error at VIRGO level | `virgo service monitor` Status column [S19] | See sections 8 to 12 |

The 1-hour cooldown is the part that surprises people: a crashed client can appear to hold a
feed licence for up to an hour.

## 7. Cannot add people - error on enrolment

Max Faces is the maximum number of people that can be registered in the Person Directory, and
attempting to add people above this limit results in an error. [S9] Check **Number of People**
and **Number of Faces** on the Status page against the licensed limit. [S14]

## 8. All feeds die with "Unexpected termination" (Linux)

Documented cause: the Linux installation is most likely missing a required APT package or
library. [S20]

Diagnostic - invoke the feed daemon directly:

```
virgo/versions/current/virgofeedd
```

Interpretation [S20]:

| Output | Meaning |
|---|---|
| `Fatal error: 'try!' expression unexpectedly raised an error: virgofeedd.DTPError.io(message: "Bad file descriptor (9)")` | **All dependencies are satisfied.** This complaint about a missing or broken pipe is expected |
| `error while loading shared libraries: libcuda.so.1: cannot open shared object file: No such file or directory` | A library **is** missing. Install the missing dependency |

Supported Linux distributions for VIRGO [S20]:

| Distribution | Status |
|---|---|
| Ubuntu 16.04(.5+) | Known to work, extensively tested |
| Ubuntu 18.04(.2+) | Appears to work, not extensively tested |
| All others | May or may not work; untested |

Note this conflicts with the SAFR Server Linux support list, which names Ubuntu 18.04(.2+),
Ubuntu 20.04, Redhat 7.x, CentOS 7.x and Amazon Linux 2018.03. [S16] VIRGO and Server do not
have the same support matrix - logged as a gap.

## 9. Feed stuck prerolling with "Codec parameters not found"

Documented cause: some cameras have buggy firmware which fails to generate a correct H264 PPS
packet when the RTSP transport protocol is UDP. VIRGO connects to RTSP cameras via **UDP by
default** because UDP requires less networking resources and has lower latency than TCP. [S20]

Resolution - add this property to the feed dictionary for the camera [S20]:

```
"input.stream.rtsp.transport":"tcp"
```

This is the first thing to try for any camera that never leaves prerolling.

## 10. virgod crashes constantly after editing config

Documented cause: a syntax error in `virgo-factory.conf`, for example a missing comma at the
end of a property. [S20]

Diagnostics:

```
virgo/versions/current/virgod -l
```

Expected error shape [S20]:

```
Factory config error: dataCorrupted(Swift.DecodingError.Context(codingPath: [], debugDescription: "The given data was not valid JSON.", underlyingError: Optional(Error Domain=NSCocoaErrorDomain Code=3840 "Badly formed object around character 54."
```

**Exit code check:** `virgod` exits with **78** (POSIX `EX_CONFIG`) if there is a syntax error in
the factory configuration file. [S20]

Important: this class of error **cannot** be captured by the VIRGO logging system, because it
happens at the very startup of `virgod` before the logging system has been initialised. Do not
waste time enabling logging for this symptom. [S20]

### Minimal factory config shape [S20]

```
{
"global":{
"environment": "PROD",
"machine-id-prefix": "vRGo-Rea18L-X-",
"user-id": "<Your SAFR cloud account ID here>",
"user-password": "<Your SAFR cloud account password here>",
"remote-control-enabled":false
},

"feeds":{
"Axis Q6128-E": {
"directory":"testy",
"input.type": "stream",
"input.stream.url":"rtsp://user:password@101.102.103.104/axis-media/media.amp",
"enabled":true
},
}
}
```

The docs explicitly warn this temporary mode is **not suitable for a production system**: VIRGO
stops running as soon as you log out, and the factory configuration file is not secured, so SAFR
account and camera passwords may be exposed to third parties. [S20] Never recommend it as a
fix - it is a test harness only.

## 11. VIRGO crashes on macOS

Documented cause: the system does not have the **Swift 5 runtime libraries** installed. VIRGO
depends on them. The docs state Apple began shipping them with macOS version 14.4.4. On older
systems that cannot be upgraded, download the Swift 5 runtime libraries from Apple. [S20]

The "14.4.4" figure is almost certainly a typo for 10.14.4 given the era of this document.
[INFERRED - verify] Logged as a gap.

## 12. Feed reports "No Recogniser Available"

Two documented causes, in order [S20]:

| Cause | Meaning |
|---|---|
| Face Service too busy | The Face Service is too busy to accept additional requests for recognition |
| VIRGO misconfiguration | Requests are not getting sent to CoVi and therefore time out |

So treat it as either capacity or wiring, and disambiguate with `virgo service monitor`: high
`#R-Skip` points to capacity, zero `#R` entirely points to wiring.

## 13. Recognition is slow, or detections are being missed

Use `virgo service monitor` for per-feed telemetry, updated every second. Quit with `q` or
Ctrl-C. Only as many columns as fit are shown - widen the terminal. Scroll with cursor up and
down. [S19]

```
virgo service monitor
virgo service monitor > my.csv
```

Feed **Status** is one of `ok`, `inactive`, `eos`, `error`, or `failure`. [S19]

The columns that actually diagnose performance [S19]:

| Column | Meaning | What it tells you |
|---|---|---|
| `dDt` | Latency of a single detection operation in ms | Detector cost |
| `dRt` | Latency of a single recognition operation in ms | Recognizer cost, compare with Status page Latency |
| `#D-Skip` | Detections skipped due to **detector overcommitment** - no detector was available because all were busy | Rising value means you are out of detection capacity |
| `#R-Skip` | Recognitions skipped due to **recognizer overcommitment** | Rising value means you are out of recognition capacity |
| `#R-Err` | Recognition or reconfirmation operations that failed | Errors rather than capacity |
| `%CPU` | CPU used by the feed, range 0% to `CPU_COUNT * 100%` | Per-feed CPU |
| `GPU` | Which modules use the GPU: `V` video decoder, `F` face detector, `B` badge detector, `O` object detector. Empty means the feed is not using the GPU at all | Confirms GPU acceleration is actually engaged |
| `FPS` / `DPS` | Input frames per second / detections per second | Feed rate versus work done |
| `#D`, `#D-Face`, `#D-Badge`, `#R`, `#R-Face`, `#Evt` | Counters for detections, faces, badges, recognitions and events reported | Volume |
| `PID` | PID of the feed daemon if running | Blank when not running |
| `Epoch`, `P-Time`, `Resolution` | First frame time, processing time in ms, frame width and height | Context |

If `GPU` is empty on a server that should be GPU accelerated, check the driver thresholds in
`install-upgrade.md` section 1 - the install only enables the GPU face service by default when
a sufficiently new NVIDIA driver is detected. [S5]

Capacity baseline for sizing conversations: documented camera counts assume an average of five
visible faces in a 4K view at 15 fps. [S16]

## 14. Certificate or trust warnings after a hostname change

All newly installed SAFR Platforms use the **same** default self-signed SSL certificates, which
the vendor says provide only moderate security at best. [S11]

| Step | Action |
|---|---|
| 1 | Confirm DNS A record exists for the name clients use [S11] |
| 2 | Confirm the server uses a static IP; with DHCP a changed address breaks the DNS entry [S11] |
| 3 | Re-run `reconfigure <HOSTNAME> <SSL CERTIFICATE CHAIN?>` [S4] |
| 4 | Inspect the active certificate with `configure-ssl.py -p` - the only read-only option [S11] |

## 15. Port conflict on install

Documented installer behaviour: the ports in conflict are reported, Notepad is launched to edit
`safrports.conf`, and the installer relaunches automatically once non-conflicting ports are
chosen. [S4] Afterwards, `configure-ports` applies changes made post-install. Verify with
`portcheck`. Default service ports are in `configuration.md` section 1.

## 16. Failover did not happen when the primary died

| Requirement | Detail |
|---|---|
| At least **two redundant** secondaries, three servers total | Failover is only enabled at this threshold [S6] |
| The first two installed redundant secondaries must be online | Only those two count. Extras receive replicated data but do not count toward failover [S6] |
| Secondary type must be **Redundant**, not **Simple** | Simple secondaries do not replicate database data [S6] |
| Platform | Only Windows and Linux servers can be redundant secondaries [S6] |

Also expected, not a fault: feed management, reports, and the Web Console are never
load-balanced and are always served from the primary. [S6] Losing the primary loses those
functions even when recognition continues.

## 17. Images or events missing after a server outage

If object storage is **Local** rather than Shared, you lose access to all objects that are only
stored by an offline Object Storage Server until that server becomes healthy again, and if that
server's objects are lost without backups they are unrecoverable. The docs mark local object
storage **Not Recommended**. [S6]

Check whether backups were being run on **every** redundant server with Object Storage enabled -
with local storage that is required, unlike shared storage where the primary alone suffices. [S6]

## 18. Events not appearing in the other system

| Fact | Implication |
|---|---|
| Event archive sync runs **once every 10 minutes** | Absence within 10 minutes is not a fault [S14] |
| Events are guaranteed to be synced, with repeated retry on error | Persistent absence means configuration, not transient failure [S14] |
| **Deletions are not synced** | An event deleted in the target archive is not deleted locally, and vice versa. This is by design [S14] |

For identity rather than event sync, check `cv-event\logs\sync.log` [S3] and the sync options in
`configuration.md` section 5, especially "Only sync from host but not back to host", which is
**off** by default and therefore bidirectional. [S14]

## 19. Search by image returns nothing

Biometric indexing is **required** to allow event searching by image on the Web Console Events
page or the Desktop Client's Search by Image window. [S14]

| Check | Detail |
|---|---|
| Is Event biometric indexing enabled? | Status page. Visible only to users with `CONFIG_PRIVILEGE` or `SUPER_CONFIG_PRIVILEGE` |
| Are older events in scope? | "Only index events occurred after specific date" excludes earlier events |
| Were new events indexed? | "Immediately index new events" must be on for new events to be searchable straight away |
| Indexing log | `cv-event\logs\bioindex.log` [S3] |

Trade-off to state up front: faster indexing speeds can lower system performance, and immediate
indexing can affect performance when events are created. [S14]

## 20. What to collect before opening a vendor ticket

| Order | Item | How |
|---|---|---|
| 1 | Support archive | `syscollect.py` - collects logs, stats and configuration into one archive for SAFR support engineers [S4] |
| 2 | Service status | `check` output [S4] |
| 3 | Port map | `portcheck` output [S4] |
| 4 | Version and environment | Status page **Version**, **Environment** [S14] |
| 5 | Licence state | Status page License Information [S9] |
| 6 | Feed telemetry | `virgo service monitor > my.csv` [S19] |
| 7 | Raised-level logs | Reproduce with `INFO`/`DEBUG` set in `logback-spring.xml`, since defaults are `WARN` [S3] |

Do this **early**: log retention is 14 days and VIRGO retains no log history at all. [S3] [S21]
