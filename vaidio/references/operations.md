# Vaidio - Operations, Logging and Diagnostics

## 1. Service lifecycle (Vaidio Core) [S1]

All lifecycle control goes through container_tool as root/sudo. There are no separate systemd units for the analytics stack.

| Action | Command |
|---|---|
| Start a stopped container | sudo container_tool start |
| Stop a running container | sudo container_tool stop |
| Create and run a new container | sudo container_tool run |
| Show status | sudo container_tool status |
| Show tool version | sudo container_tool -V |
| Show .conf version | sudo container_tool -v |
| Check disk space | sudo container_tool check_disk_space |
| Upgrade | sudo container_tool -u <vaidio_admin> -p <vaidio_admin_pwd> upgrade |
| Remove container (prompts) | sudo container_tool remove |
| Remove old images | sudo container_tool prune |

Destructive notes: **remove** asks 'Do you want to remove vaidio? [y/N]' then 'Do you want to purge data? [y/N]' - answer N to keep data. **prune** deletes old images; back up first and make sure the container_tool version matches the running container. **Factory Reset** in the Admin Portal wipes the server to defaults. [S1][S3]

Application-level restart without touching Docker: **System > General (or any System tab) > Restart** suspends all running jobs and restarts System settings after a warning prompt. Enabling or disabling Privacy Protection also restarts the system. [S4]

Hardware change procedure: changing the GPU card or other hardware can prevent the container from resuming and risks invalidating the FR license. **Remove the container (keeping the data) before powering off** to change hardware. [S1]

## 2. Health checks [S1][S4][S3]

| Check | How |
|---|---|
| Container state | sudo container_tool status |
| Disk headroom | sudo container_tool check_disk_space |
| GPU and driver | nvidia-smi (expect 535.183.06 or higher) |
| GPU card presence | lshw -C display |
| Secure Boot state | mokutil --sb-state |
| Time sync service | sudo systemctl status systemd-timesyncd.service |
| Ubuntu version | uname -v  or  lsb_release -a |
| Block devices and mounts | lsblk |
| Upgrade progress | sudo cat /opt/data/sys/vaidio/log/app/start_service.log |
| Vendor repo reachability | curl https://ironyun.github.io/Vaidio-APT/KEY.gpg |
| Network reachability from the product | System > Utility > Ping / Traceroute / NS Lookup with a Target and optional Parameters, then Diagnose |
| Camera connectivity | Camera > Add/Edit Camera > Preview (not available for Camera APP) |
| LDAP connectivity | System > Authentication > Check Connection |
| SSO connectivity | System > Authentication > OpenID > Check Connection |
| SMTP | System > Mail > Send Test Email |
| NVR/VMS | NVR > Add NVR > Check Connection |
| Custom map server | System > Setting > Map Server > Check Connection (URL reachability only) |
| HTTP alert trigger endpoint | Alert trigger panel > Check Connection (parameters are NOT substituted in the test request) |
| Cluster member | Main > Cluster > Add > Check Connection |
| CC node registration | Core System > Setting > Node > Check Registration Status |
| Storage usage | System > Storage (Used/Total space GB, Total Usage %) |
| Analytic capacity | Camera > Analytic Capacity (engine licenses per server and resources used) |

There is **no documented HTTP health-check endpoint** for Vaidio Core. Vaidio Data exposes API documentation at http://<IP>/docs, which is a documentation endpoint, not a health probe. [S10]

## 3. Licensing operations [S1][S4]

| Step | Where |
|---|---|
| View license (Model Name, Serial Number, Expiration Date) | System > License > License Management |
| View licensed AI engines and Internal Video Recorder channels | System > License > AI Engines |
| Export system information file (.info) | System > License > Export |
| Request a key | Support Portal > Submit a Ticket > Licensing > New License (or Renew License), attach the .info file |
| Apply a key | System > License > Renew, upload the .key |
| Add engines/modules already uploaded | System > License > Add AI Engines > select or Upload > OK |

Timing and warnings: applying a license can take **30-40 minutes** depending on how many analytics are enabled, and the page auto-refreshes when done. Expiry warnings appear in License Settings, on the Login screen, and by email. After expiry the system stops receiving updates and maintenance. Both a License Expiration Date and a Warranty & Maintenance Expiration Date are tracked; an expired warranty blocks upgrades. [S4][S2]

Enterprise licensing: two license types - the **Vaidio Manager License** on the master node (authorises Manager and defines the total analytics pool) and the **Vaidio Core Analytics License** per Core instance. Use License Manager to Export Hardware Info (.info from the master node) and Import License Key. Legend: Imported (added to the pool), Allocated (in use by Cores), Revoked (returned to the pool, shown with a minus sign). Usage bars: high >75%, partial 1-75%, none 0%. To revoke engine licenses from a Core pod the **entire instance must first be deleted**. After the Manager license expires, existing Cores keep running but new Cores cannot be created. [S11]

Command Center licensing: License Management > Command Center tab for CC's own license (Export .info, Renew). From 8.1.0 the License Server tab centrally allocates, revokes and updates **Core node** license keys - enter per-engine channel counts, Expiration Date and authorised Users, then Finish. Cores that already hold their own license keys cannot be remotely managed. **If a Core node disconnects from CC for more than 10 minutes its license temporarily reverts to a trial license**, and the assigned license is restored automatically on reconnect. In 9.1.0 the CC user limit is 10. [S12]

## 4. Logging and diagnostics [S4][S9]

Two log types plus an audit trail:

| Log | Contents | Access and export |
|---|---|---|
| System log | Data-based events and actions of the Vaidio system environment/network. Severities **Info, Warn, Error, Critical** | System > Log; filter by date/time range, Type or Message keyword; Search; Export to .xlsx |
| Diagnostic log | **Encrypted** log of hardware errors, processing consumption, analytic/alert/connection errors, and failed login attempts including the source IP | System > Log; Export to .xlsx; send to Vaidio Support through the Support Portal |
| Audit Trail | Successful login/logout plus time and actions performed system-wide (for example camera activation or modification) | System > Audit Trail; filter by Date/Time, User, Source IP, Action Keyword; Export to .xlsx |

Retention for System Logs and Audit Trail data is set at System > Setting > Advanced > Log and Audit Trail Retention Time, **3-365 days**. [S4]

File-system logs:

| Path | Contents | Source |
|---|---|---|
| /opt/data/sys/vaidio/log/app/start_service.log | Upgrade / service start status. Read with sudo cat | S1 |
| /var/log/ | All host logs; the offline installer guide asks for everything here after a failed install | S5 |

No other in-container log paths, verbosity switches or debug-mode toggles are documented. Verbosity is controlled only by filtering in the UI (Info/Warn/Error/Critical), not by a configurable log level. Log this as a gap when asked. [S4]

Support bundle equivalent: Vaidio has no single 'support bundle' command. The documented equivalent is the combination of the exported .info file, the exported Diagnostic and System logs, the Audit Trail export, and start_service.log or /var/log/ as appropriate. Command Center and Vaidio Enterprise each have an **Export Diagnostic Log** button in the UI, and Vaidio Data has System > Export Log. [S1][S3][S11][S12][S10]

Diagnostic utilities shipped with the product: **container_tool** (status, check_disk_space, versions), **preinstall** (driver install), and the in-UI **System > Utility** network diagnosis tool (Ping, Traceroute, NS Lookup). [S1][S4]

Third-party tool the vendor documents for testing: **Happytime RTSP Server** to replay a video file as an RTSP stream for analytics testing. Upload a video under 1 GB, place it in the happytime-rtsp-server folder, set loop_nums to 1 in the config file to play once, run the server, then add rtsp://ipaddress:554/videoname as a camera. [S3]

## 5. Monitoring hooks [S8][S4]

| Hook | Available? | Detail |
|---|---|---|
| HTTP / HTTPS webhook | Yes | Alert triggers with GET, POST, PUT, DELETE, PATCH, No Auth / Basic / Digest auth, custom headers, form-data or raw JSON body. See api-integration.md |
| Email notification | Yes | Alert trigger action using the same parameter set; requires SMTP |
| VMS / NVR notification | Yes | Alert trigger to third-party VMS using the same parameter set |
| Mobile push | Yes | Vaidio mobile app notifications, including Critical Alerts that bypass silent mode and Do Not Disturb |
| Admin email notifications | Yes | System > Security > Email Notification for account deactivation, account lock or critical logs |
| SNMP | **Not documented** | No SNMP support appears in any retrieved guide |
| Syslog forwarding | **Not documented** | Logs are exported as .xlsx from the UI; no syslog target is documented |
| Prometheus / metrics endpoint | **Not documented** | - |

Vaidio Enterprise adds a usage report: Pod Manager > Download Usage Report, choose a time range, Download, and submit the report to the Support Portal for review. [S11]

## 6. Scheduled and automatic maintenance jobs

| Job | Default | Configurable at | Source |
|---|---|---|---|
| Metadata / system storage cleanup | Retention off: purge oldest once usage exceeds 80%. Retention on: purge older than N days, default 30 (minimum 1) | System > Storage > Storage Configuration | S4 |
| Recorder data cleanup | Purge at retention, or purge until usage falls below 80% if the threshold is hit first | System > Storage > Storage Configuration | S4 |
| Log and Audit Trail purge | 3-365 days | System > Setting > Advanced | S4 |
| Camera health check schedule | User-defined, whole hours only (45-minute blocks not allowed); history kept up to 30 days | Camera > Abnormal Check > Schedule icon | S4 |
| Object counting reset | User-defined reset time | System > Setting > Additional Settings > Counting | S4 |
| Alert schedule | All day by default in Command Center; optional in Core | Alert > Alert Rule > Schedule | S12 S13 |
| Command Center daily node backup | Off by default; enable Node Configuration and set a backup time. Disconnected nodes resume automatically | CC System > Setting | S12 |
| Vaidio Data automatic cleanup | Threshold default 85%, plus optional retention period | Vaidio Data System > Storage Configuration | S10 |
| Edge storage cleanup | Toggle off: purge oldest above 80%. Toggle on: purge older than retention, or purge until usage is below 50% if 80% is hit first | Edge Settings > Storage | S15 |
| Idle user deactivation | 30-365 days when enabled | System > Security | S4 |

Rolling overwrite behaviour, as the vendor describes it: for data stored for 7 days, day-8 data overwrites day-1 data. Files uploaded directly to the appliance are deleted with the delete button. [S22]

## 7. Data export operations [S9]

| Export | Format | Where |
|---|---|---|
| System configuration (Application, Network, System) | .bin | System > General > Export Configuration |
| Camera Abnormal events | Excel | Camera health dashboard |
| System log / Diagnostic log | .xlsx | System > Log > Export |
| Audit Trail | .xlsx | System > Audit Trail > Export |
| Search and Heatmap results | Excel | Search / Heatmap dashboards |
| Analytics History for FR, LPR, Intrusion Detection, Object Counting, Abnormal Events Detection and Alert | Excel | each engine History tab |
| Event image | image download | Detail page |
| Event video clip | MP4 (audio included if the source stream has audio) | Detail page |
| Vaidio Data audit log | .csv | Vaidio Data System > Audit Trail > Export Log |
| Vaidio Data dashboard | .png | Dashboard options > Download as Image |
| Vaidio Data backup | .tar | System > Backup Now |

With Privacy Protection enabled, downloaded and exported images are blurred; images processed before it was enabled cannot be blurred retroactively. [S9]

## 8. Operational limits and gotchas worth quoting to operators

| Limit / behaviour | Value | Source |
|---|---|---|
| Live View browser tabs | Open no more than two Vaidio tabs at once when using Live View (Chrome limitation). No limit without Live View | S3 |
| Camera group size | 100 cameras per group; a camera can be in 10 groups | S4 |
| Cluster size | 1 Main + up to 15 Remote | S4 S12 |
| Federation size | 1 CC + 100+ nodes (6.2.0+) | S12 |
| Local CC alert rules | 128 by default | S12 |
| Uploaded video file size | 10GB max | S4 |
| Detail Extraction cost | Plus = 3x resources, Ultra = 7x resources | S4 |
| Privacy Protection cost | Doubles storage | S4 |
| License apply time | 30-40 minutes | S1 |
| VE Core initialisation | up to 10 minutes | S11 |
| Failed login lockout | 3 attempts, 5 minutes | S4 |
| MFA OTP validity | 10 minutes | S4 |
| CC password reset code validity | 10 minutes | S12 |
| Core node license fallback | reverts to trial after 10 minutes disconnected from CC | S12 |
| CC batch upgrade | recommended maximum 3 nodes at a time; cannot be paused or stopped | S12 |
| Software release cadence | quarterly | S22 |
| Maintenance fees | 15% annual software, 5% annual hardware, mandatory since 2022-01-01 | S22 |
