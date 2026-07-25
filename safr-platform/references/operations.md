# SAFR Server Operations (on-premises)

All commands are verbatim from the vendor docs. Source IDs refer to `sources.md`.

## Contents

| Section | Topic |
|---|---|
| 1 | Script location |
| 2 | Start, stop, status |
| 3 | Port inventory |
| 4 | Support bundle (syscollect) |
| 5 | Logging: levels, domains, paths, defaults |
| 6 | Hostname and certificates |
| 7 | Port reconfiguration |
| 8 | Licensing helpers |
| 9 | Cluster join |
| 10 | Backup entry points |
| 11 | Destructive commands |
| 12 | Internal-use-only scripts |
| 13 | Monitoring hooks |

## 1. Script location

The SAFR Platform installation includes several scripts to manage and monitor your server, located in the `bin` folder under the SAFR Platform installation location. [S4]

| OS | `bin` path |
|---|---|
| macOS | `/Library/RealNetworks/SAFR/bin` |
| Linux | `/opt/RealNetworks/SAFR/bin` |
| Windows | `C:\Program Files\RealNetworks\SAFR\bin` |

Documented caveat: some of these scripts may not work if you are accessing the SAFR Platform through the NVIDIA Metropolis Application Framework (MAF). [S4]

## 2. Start, stop, and status

The `check` script checks the status of SAFR Server services. `start` and `stop` act on all SAFR Server services **on the current machine** - in a cluster you must repeat per node. [S4]

| Action | macOS | Linux | Windows |
|---|---|---|---|
| Status | `/Library/RealNetworks/SAFR/bin/check` | `/opt/RealNetworks/SAFR/bin/check` | `"C:\Program Files\RealNetworks\SAFR\bin\check.bat"` |
| Start | `/Library/RealNetworks/SAFR/bin/start` | `/opt/RealNetworks/SAFR/bin/start` | `"C:\Program Files\RealNetworks\SAFR\bin\start.bat"` |
| Stop | `/Library/RealNetworks/SAFR/bin/stop` | `/opt/RealNetworks/SAFR/bin/stop` | `"C:\Program Files\RealNetworks\SAFR\bin\stop.bat"` |

The Linux paths are documented as "On Linux or Jetson". [S4]

There is no documented way to restart a **single** sub-system from these scripts, and Windows service display names are not published, so per-service restarts are **Not documented**. The only documented single-service manipulation is stopping the CoVi service on secondaries during a cluster upgrade. [S7]

## 3. Port inventory on a live server

`portcheck` lists all the ports that SAFR services are using. [S4]

| OS | Command |
|---|---|
| macOS | `python /Library/RealNetworks/SAFR/bin/portcheck.py` |
| Linux | `sudo python /opt/RealNetworks/SAFR/bin/portcheck.py` |
| Windows | `python "C:\Program Files\RealNetworks\SAFR\bin\portcheck.py"` |

See `network-ports.md`.

## 4. Support bundle for a vendor ticket

`syscollect` collects all the necessary logs, stats, and configuration files into a single archive file that can be easily emailed to SAFR sales support engineers. **Run this before opening a ticket.** [S4]

| OS | Command | Archive output |
|---|---|---|
| Linux | `python /opt/RealNetworks/SAFR/bin/syscollect.py` | `/opt/RealNetworks/SAFR/syscollect/` |
| Windows | `python "C:\Program Files\RealNetworks\SAFR\bin\syscollect.py"` | `C:\Program Files\RealNetworks\SAFR\syscollect\` |

macOS is **Not documented** for `syscollect`. [S4]

| Argument | Effect |
|---|---|
| `-h`, `--help` | Lists all the optional arguments available for this script |
| `-p <PATH>`, `--path <PATH>` | Changes where the archive file is generated |
| `-q`, `--quiet` | Quiet mode; command line output is suppressed |
| `-v`, `--verbose` | Verbose command line output for debugging purposes |

Note: the docs render long options with an en dash. Type them as two ASCII hyphens. [INFERRED - verify]

## 5. Logging

SAFR Server offers customizable logging at each level for each of the core systems: Computer Vision Service (COVI), Event Server, Video Recognition Gateway Admin Service (VIRGA), Reports, and Computer Object Service (CVOS). [S3]

### 5.1 Levels

| Level | Documented meaning |
|---|---|
| `ERROR` | Exceptions in the code, access issues, incorrect requests, error conditions the system cannot recover from |
| `WARN` | A recoverable condition was encountered |
| `INFO` | Normal execution flow, e.g. a person added or removed, a face added or removed, a recognition made |
| `DEBUG` | Lower level debug info such as REST calls to external services; can also log database access in some cases |
| `TRACE` | Detailed, debug only; in some cases contains the actual data for requests. Normally not turned on because it can potentially affect performance |

### 5.2 Domains

| Domain | Contents |
|---|---|
| Application | General logging, including handled REST requests and other operations |
| Performance | Measures performance of specific areas such as database access |
| Access | Which REST calls were made, what HTTP response codes were received |
| Container | Tomcat or Jetty container logging; helps find configuration issues such as missing Jars |
| Metrics | Metrics such as how much memory was used |
| STDERR | Redirected stderr |
| Localhost | Platform-specific, starting service |
| Feature | Feature-specific logs such as `sync.log` or `reaper.log` |
| Audit | Auditing of changes to storage of people and faces |

### 5.3 Changing log levels

Logging configurations are stored in `logback-spring.xml` files, located in the `config` directories of the services they pertain to (COVI, Events, CVOS, and so on). [S3]

Application log level - edit the root logger:

```xml
<root level="INFO">
<appender-ref ref="APP" />
</root>
```

A named domain, for example Performance:

```xml
<logger name="Performance" level="INFO" additivity="false">
<appender-ref ref="PERF"/>
</logger>
```

A single code module, useful to zero in on an issue or to suppress noise:

```xml
<logger name="com.real.cv.event.filter.RequestLoggingFilter" level="DEBUG"/>
```

### 5.4 Default levels, paths, retention, rotation

Paths are relative to the install location. The doc states the default install location on Windows is `C:\ProgramData\RealNetworks\SAFR\`. [S3]

| Sub-system | Domain | Default level | Log file | Retention | Rotation |
|---|---|---|---|---|---|
| COVI | Application | `WARN` | `covi\logs\covi-ws.log` | 14 days | Daily and/or 100MB size |
| COVI | Performance | `OFF` | `covi\logs\performance.log` | 14 days | Daily and/or 100MB size |
| COVI | Container | N/A | `covi\logs\catalina.log` | 14 days | Daily |
| COVI | Localhost | N/A | `covi\logs\localhost.log` | 14 days | Daily |
| COVI | STDERR | N/A | `covi\logs\safrcovi-stderr.log` | 14 days | Daily |
| COVI | Service | N/A | `covi\logs\commons-daemon.log` | 14 days | Daily |
| COVI | Audit | N/A | `covi\logs\audit.log` | 14 days | Daily |
| Event Server | Application | `WARN` | `cv-event\logs\app.log` | 14 days | Daily and/or 512MB size |
| Event Server | Performance | `OFF` | `cv-event\logs\performance.log` | 14 days | Daily |
| Event Server | Access | N/A | `cv-event\logs\access.log` | 14 days | Daily |
| Event Server | Metrics | N/A | `cv-event\logs\metrics.log` | 14 days | Daily |
| Event Server | Feature | `INFO`, `DEBUG` | `cv-event\logs\sync.log`, `cv-event\logs\bioindex.log`, `cv-event\logs\reaper.log` | 14 days | Daily |
| VIRGA | Application | `WARN` | `virga\logs\app.log` | 14 days | Daily |
| VIRGA | Performance | `OFF` | `virga\logs\performance.log` | 14 days | Daily |
| VIRGA | Access | N/A | `virga\logs\access.log` | 14 days | Daily |
| VIRGA | Container | `INFO` | `virga\logs\virga.out` | N/A | N/A |
| VIRGA | Feature | `WARN` | `virga\logs\configs.log` | 14 days | Daily |
| Reports | Application | `INFO` | `cv-reports\logs\app.log` | 14 days | Daily |
| Reports | Performance | N/A | `cv-reports\logs\performance.log` | 14 days | Daily |
| Reports | Access | N/A | `cv-reports\logs\access.log` | 14 days | Daily |
| Reports | Metrics | N/A | `cv-reports\logs\metrics.log` | 14 days | Daily |
| Reports | Container | `INFO` | `cv-reports\logs\cv-reports.out` | N/A | N/A |
| CVOS | Application | `WARN` | `cv-object-storage\logs\app.log` | 14 days | Daily |
| CVOS | Performance | `OFF` | `cv-object-storage\logs\performance.log` | 14 days | Daily |
| CVOS | Access | N/A | `cv-object-storage\logs\access.log` | 14 days | Daily |
| CVOS | Metrics | N/A | `cv-object-storage\logs\metrics.log` | 14 days | Daily |
| CVOS | Container | `WARN` | `cv-object-storage\logs\cv-object-storage.out` | N/A | N/A |
| CVOS | STDERR | N/A | `cv-object-storage\logs\cv-object-storage.err` | N/A | N/A |

Two consequences worth stating unprompted:

| Consequence | Why it matters |
|---|---|
| Application logs default to `WARN` on COVI, Event Server, VIRGA and CVOS | An INFO-level trace of a recognition or identity change does not exist unless someone raised the level first. Reproduce at `INFO` or `DEBUG` before concluding "nothing in the logs" |
| Retention is 14 days | An intermittent fault reported weeks later may already have aged out. Run `syscollect` early |

The source table contains a typographical error, printing the Event Server Feature default as `INF0` with a zero. Read as `INFO`. [S3]

## 6. Hostname and certificate operations

`reconfigure` configures the hostname used by the SAFR Server. Run it when configuring the server to use a DNS hostname with an SSL certificate. It requires administrator privileges - it automatically asks for admin privileges on Windows and requires `sudo` on macOS and Linux. If no arguments are passed you will be prompted. [S4]

```
sudo /Library/RealNetworks/SAFR/bin/reconfigure <HOSTNAME> <SSL CERTIFICATE CHAIN?>
sudo /opt/RealNetworks/SAFR/bin/reconfigure <HOSTNAME> <SSL CERTIFICATE CHAIN?>
"C:\Program Files\RealNetworks\SAFR\bin\reconfigure.bat" <HOSTNAME> <SSL CERTIFICATE CHAIN?>
```

Documented examples [S4]:

```
/Library/RealNetworks/SAFR/bin/reconfigure 192.168.123.124 y
/opt/RealNetworks/SAFR/bin/reconfigure 192.168.123.124 n
"C:\Program Files\RealNetworks\SAFR\bin\reconfigure.bat" 192.168.123.124 y
```

`configure-ssl` manages the self-signed SSL certificate; see `network-ports.md` section 5.1 for its full argument table. Only `-p` / `--public-key` is read-only; the rest change state and must not be run as a diagnostic step. [S4] [S11]

## 7. Port reconfiguration

`configure-ports` customizes the ports SAFR services listen on, typically done only if there is a conflict with existing software on the same server. It takes no arguments and relies on `safrports.conf`. [S4]

| OS | `safrports.conf` |
|---|---|
| macOS | `/Library/RealNetworks/SAFR/safrports.conf` |
| Linux | `/opt/RealNetworks/SAFR/safrports.conf` |
| Windows | `C:\Program Files\RealNetworks\SAFR\safrports.conf` |

Documented installer behaviour on conflict: the ports in conflict are reported, Notepad is launched to edit `safrports.conf`, and the SAFR Platform installer is automatically relaunched after new non-conflicting ports are chosen. [S4]

## 8. Licensing helper scripts

`get-license`, `get-license-request`, and `insert-license` are used as part of getting an on-premises license when the SAFR system doesn't have Internet connectivity. Full procedure in `install-upgrade.md` sections 7 and 8. [S4] [S9]

## 9. Cluster join

`safr-worker` joins secondary SAFR Servers to the SAFR server cluster. [S4]

## 10. Backup entry points

```
python backup.py
sudo python backup.py
python "C:\Program Files\RealNetworks\SAFR\bin\backup.py" -o
python restore.py BACKUPFILENAME
```

Full argument table, output paths, and the Windows Task Scheduler recipe are in `install-upgrade.md` sections 9 to 11. [S6] [S8]

## 11. Destructive - do not run as diagnostics

`uninstaller` removes the SAFR Platform entirely: it closes all SAFR applications, stops all SAFR services, then removes all SAFR services and data. On Windows you must select the optional ProgramData component to remove config files, logs, and database files. [S4]

| OS | Path |
|---|---|
| macOS | `/Library/RealNetworks/SAFR/uninstaller` |
| Linux | `/opt/RealNetworks/SAFR/uninstaller` |
| Windows | `"C:\Program Files\RealNetworks\SAFR\uninstaller.exe"` |

## 12. Internal use only - never run these

The docs explicitly mark these as internal to the `SAFR\bin` folder. [S4]

| Script | Documented role |
|---|---|
| `cleanup.py` | Part of the SAFR uninstallation process |
| `configure-faceservice.py` | Part of the creation and configuration of VIRGO video feeds |
| `configure-firewall.py` | Windows only. Part of the port reconfiguration process |
| `configure-ip.py` | Part of the SAFR Platform installation process |
| `proxy-discover.py` | Used during auto-discovery of the primary SAFR Server |
| `server-status.py` | Used during creation of SAFR Server's logs |
| `update-password.py` | Used to propagate a newly changed account password across the SAFR system |
| `upgrade.py` | Used by the `reconfigure` script to help set the hostname of the SAFR Server |

## 13. Monitoring hooks

SNMP, syslog forwarding, and a machine-readable health endpoint are **Not documented** on the pages retrieved. The documented health surfaces are the `check` script [S4] and the Web Console Status page [S14]. Logged to `known-gaps.md`.
