# Known Gaps

Everything the retrieved documentation did not answer, plus contradictions needing vendor confirmation. Organised so it can be handed to a vendor SE as an agenda.

## 1. Highest-risk items to verify before production use

| Rank | Item | Why it is risky | How to close |
|---|---|---|---|
| 1 | `cv-instam.real` on port `443` is the only documented licence endpoint, and the hostname looks truncated or internal | If this FQDN is wrong, a firewall rule built from it silently fails and the server stops operating once Max Days Between Reports elapses [S9] | Ask the vendor for the canonical licence-server FQDN and IP ranges |
| 2 | Genetec plugin mapping: which of the five integration scenarios needs `/Genetec` versus `/GenetecFR`, given only one VMS plugin can be active [S5] | Choosing wrong means a reinstall, and a cluster cannot mix plugins | Ask the vendor to map each Genetec guide to its installer flag |
| 3 | Image and face-size limits contradict across five places: 200KB, 128k, 80 px, 150 px, 220 px | Enrolment pipelines built to the wrong figure silently reject images or under-perform | Get one authoritative table per integration path |

## 2. Contradictions across the documentation set

| Topic | Conflict | Sources |
|---|---|---|
| NVIDIA driver floor | Install gates the GPU face service on drivers greater than 418.67; the requirements doc says 418.96+ | [S5] vs [S16] |
| CoVi port | Licence script falls back to `8080`; Status doc says CoVi defaults to `8081`. Reconciled by the API overview, where `8080` is HTTPS and `8081` is HTTP, but no single doc states this | [S9], [S14], [S26] |
| CVOS vs CVEV naming | Status doc says the Host CVOS port defaults to the CVEV default port number `8087` in one dialogue, and the CVOS default in another | [S14] |
| Windows install root | Logging doc gives the default install location as `C:\ProgramData\RealNetworks\SAFR\`; scripts doc gives `C:\Program Files\RealNetworks\SAFR` | [S3] vs [S4] |
| CVOS service name | Computer Object Service in the logging doc, Object Storage Service in the redundancy doc | [S3] vs [S6] |
| Linux support matrix | VIRGO supports Ubuntu 16.04(.5+) and 18.04(.2+); SAFR Server supports Ubuntu 18.04(.2+), 20.04, Redhat 7.x, CentOS 7.x, Amazon Linux 2018.03 | [S20] vs [S16] |
| External identity host options | Status doc lists only AMAG and Software House; Genetec guides describe Genetec and Genetec SaaS | [S14] vs [S39] [S40] |
| SAFR version floor for Genetec | 3.28+ in the identity guides, 3.6+ in the camera and API guides | [S39] [S40] [S41] vs [S42] [S43] |
| Genetec SDK part number | Four casings: `GSC-1SDK-RealN-FR1`, `GSC-1SDK-REALN-FR`, `GSC-1SDk-RealN-FR`, `GSC-1SDK-RealN-FaceRec` | [S39] to [S43] |
| Back-channel property | `input.back-channel.type` is documented as Mobotix-specific in the VIRGO reference but reused to carry the Genetec camera GUID | [S23] vs [S42] |
| REST auth header | `X-RPCAUTHORIZATION` on one doc, `X-RPC-AUTHORIZATION` everywhere else | [S27] vs [S28] [S33] |
| REST person-name header | `XRPC-PERSON-NAME` and `X-RPC-PERSON-NAME` in two examples on the same doc | [S28] |
| REST example scheme and port | Examples use `http://localhost:8080` and `http://localhost:8082`, both of which the overview lists as HTTPS ports | [S26] vs [S28] [S34] |

## 3. Typographical and rendering defects

Not conflicts, just broken text that must not be copied literally.

| Defect | Correct reading |
|---|---|
| `INF0` with a zero as the Event Server Feature default log level [S3] | `INFO` |
| `C:Files` as the default install location [S11] | `C:\Program Files\RealNetworks\SAFR` [INFERRED - verify] |
| Truncated sentence ending "are located at as", describing where a generated certificate and key are written [S11] | Output path is Not documented |
| `telnet 10.124.14.20 telnet` [S39] | Second argument should be a port number |
| macOS shipped the Swift 5 runtime beginning with version 14.4.4 [S20] | Almost certainly 10.14.4 [INFERRED - verify] |
| Sample person id printed with a stray space inside the UUID [S28] | A UUID with no space |
| "Error! Reference source not found." plus a dangling reference to section 1.2.2.1 [S39] | Broken cross-references in the Cardholder guide |
| Garbled headings in RIO guide section 2.8 [S41] | Unreadable as published |
| Cardholder guide 1.6.1 step 3 names the Supervisor template; intro text says Provisioning or Administrator [S39] | Unresolved |
| Long CLI options rendered with en dashes throughout [S4] [S8] [S11] | Type two ASCII hyphens |

## 4. Not documented, by category

### C. Network

| Missing | Notes |
|---|---|
| A port table | No port / protocol / direction / purpose table exists anywhere. Only `cv-instam.real:443` and the service defaults `8080` to `8087` are stated. `portcheck` is the only authoritative source |
| `safrports.conf` syntax and default contents | Never shown |
| Firewall rule specifics | Windows firewall is handled internally by `configure-firewall.py`, marked internal use only |
| Forward proxy support | No HTTP or HTTPS proxy configuration documented |
| Certificate output path from `configure-ssl.py -g` | Sentence truncated in the source |
| TLS versions and cipher suites | Not documented |

### B. Architecture

| Missing | Notes |
|---|---|
| The database product | Never named. Docs say several databases and database replica set only |
| Windows service display names | Not published, so per-service start and stop is undocumented |
| macOS and Linux data roots | Only the Windows ProgramData path is given |
| Restarting a single sub-system | Only `start` and `stop` for all services on a node, plus stopping CoVi on secondaries during upgrade |

### E. Install and upgrade

| Missing | Notes |
|---|---|
| Supported version-to-version upgrade paths | Whether releases can be skipped is unstated |
| Rollback or downgrade procedure | None. Only reinstall plus restore from backup |
| `-o` or `--objects-only` full semantics for `backup.py` | Only partially described |
| macOS `syscollect` | Only Linux and Windows documented |
| macOS Auto Daily Backup | Section absent |

### F. Configuration

| Missing | Notes |
|---|---|
| Environment variables and registry keys | None documented anywhere |
| LDAP, SAML, OIDC, SSO | Not documented. The SAFR user directory is an internal partition, not directory integration |
| Database cache keys and valid ranges | Topic exists but specifics not retrieved |
| Event removal and Identity removal defaults | Settings exist; default values not given |
| Full privilege model | Only `CONFIG_PRIVILEGE` and `SUPER_CONFIG_PRIVILEGE` captured; the model lives in Desktop Client Manage Users docs, not retrieved |
| SMTP and SMS field lists | Only the requirement for an SMTP account is documented |

### G. Operations and monitoring

| Missing | Notes |
|---|---|
| SNMP and syslog forwarding | Not documented |
| Machine-readable health endpoint | Not documented. Health surfaces are the `check` script and the Web Console Status page |
| Scheduled maintenance job defaults | Reaper and cleanup behaviour implied by `reaper.log` but not specified |
| Performance metrics API | Load and Latency are UI-only |

### I. Errors and troubleshooting

| Missing | Notes |
|---|---|
| An error code catalogue | No numbered error codes exist anywhere in the retrieved set. Errors are prose symptoms and literal messages. This is why the package ships no `error-codes.md`; documented error strings live inline in `troubleshooting.md` and `scan-diagnostics.md` |
| REST API error codes | Only `200` and `204` semantics on `/event/status` |
| SCAN sections 1.2.8 to 1.2.14 and 1.2.18 to 1.2.20 | Symptom names captured, remediation steps not retrieved in full |

### J. Integration

| Missing | Notes |
|---|---|
| Rate limits | Not documented for any endpoint |
| Webhooks or push events | None. Long-polling `/event/status` is the only pattern |
| API versioning scheme | Not documented |
| Pagination on `/events` and `/people` | Not documented |
| VIRGA and CVOS resource paths | Not in prose; use the local OpenAPI spec |
| Admin Tenant API and Admin System API | Mentioned only in passing. `eventArchiveTimeLimit` is the sole named key |
| Exact verbs and parameters for four of the five COVI operations | Only the import call was captured in full |

### K. Version history

| Missing | Notes |
|---|---|
| Per-release breaking changes and deprecations | The Release History page was retrieved but not mined per release, so this package ships no `version-matrix.md`. The one durable fact is that RealNetworks states it releases new versions almost every month [S7] |
| EOL and lifecycle policy | Not documented |
| Which SAFR product version the 3.048-stamped docs describe | Doc version and product version are different numbers and are never correlated |

### A. Licensing

| Missing | Notes |
|---|---|
| Editions and SKU feature deltas | Not documented beyond Desktop Client editions in the requirements doc |
| Numeric licence tier values | Max Feeds per Hour and Max Faces are described but no tier values are published |

## 5. Gated sources

| Source | Behaviour | How to retrieve |
|---|---|---|
| A Web Console status URL variant | Returned an Access Denied wall citing U.S. and applicable Export laws, then redirected to `safr.real.com/signin` | Vendor portal with an entitled account. The correct pages are `Status_Page.html`, `Web_Console.html` and `View_Video_Feeds_Status.html` |
| PDF library | The doc index lists PDF counterparts for most guides, for example SAFR SCAN Admin Guide.pdf | Download from the portal; PDFs may carry newer content than the HTML |
| Downloads area | The portal warned that Support and Updates Coverage is expired | Renew coverage, then retrieve the SAFR Finder App and installers |
| Desktop Client Manage Users Preferences | Referenced by [S14] for the privilege model, not retrieved | Desktop Client documentation set |
| `Map_Command_Line_Tool.html` | Listed in the doc set, not fetched | Direct fetch, no gate expected |

## 6. Suggested retrieval paths

| Need | Where to go |
|---|---|
| Authoritative REST signatures | The local OpenAPI spec on your own server: `https://<server>:8080/docs/index.html` plus the CVEV, VIRGA and CVOS equivalents [S26]. Highest-value gap closer, needs no vendor contact |
| Real port list for firewall change requests | `portcheck` on each node [S4] |
| Genetec plugin mapping, part numbers, image limits | Vendor SE or partner portal |
| Release-by-release breaking changes | SAFR Release History, mined per release [S52] |
| PDF versions of guides | The SAFR portal, Support then Downloads |
| SCAN remediation steps not captured | The SCAN Troubleshooting Guide, sections 1.2.8 to 1.2.14 and 1.2.18 to 1.2.20 |

## 7. Files intentionally absent

| File in the original spec | Why absent |
|---|---|
| `error-codes.md` | No error code catalogue exists in the vendor documentation. Creating the file would mean inventing codes. Documented error strings are recorded inline in `troubleshooting.md` and `scan-diagnostics.md` |
| `version-matrix.md` | Release History was not mined per release, so any matrix would be speculative. See category K above |
