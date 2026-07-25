# SAFR Configuration (on-premises)

Most server-side configuration lives on the **Web Console Status page**, not in text files. [S14]

## 1. Default service ports

These are the only default port numbers published anywhere in the retrieved documentation. They appear as field defaults in the Status page's remote-control and sync dialogues. [S14]

| Service | Documented default port | Where it appears |
|---|---|---|
| CoVi (COVI) | `8081` | "Host COVI port ... defaults to CoVi's default port number, 8081" |
| VIRGA | `8085` | "Host VIRGA port ... defaults to VIRGA's default port number, 8085" |
| CVOS | `8087` | "Host CVOS port ... defaults to CVOS's default port number, 8087" |
| CoVi, licensing fallback | `8080` | `get-license-request.py` uses port `8080` when `safrports.conf` cannot be found [S9] |

**Two conflicts to flag, both logged as gaps:**

| Conflict | Detail |
|---|---|
| CoVi port | The Status page says CoVi defaults to `8081` [S14], but the licensing script falls back to `8080` [S9]. Do not assume they agree - confirm with `portcheck` |
| CVOS vs CVEV | In the "control by central server" dialogue the doc says the **Host CVOS port** "defaults to **CVEV's** default port number, 8087", while the identity-sync dialogue says it defaults to **CVOS's** default port number, 8087. Same number, inconsistent service name [S14] |

Always verify with `portcheck` before writing firewall rules. See `network-ports.md`.

## 2. Status page: General

| Field | Meaning |
|---|---|
| Environment | `SAFR Cloud` = server in the cloud maintained by RealNetworks. `SAFR Local` = locally installed server you maintain. **On-premise deployments use `SAFR Local`** |
| Version | The SAFR version. This is the field to read when asked "what version are we on" |
| Tenant ID | The name of the person currently logged in |
| User Directory | User directory where the user's data is stored. Default value is `main` |
| People in Directory | Number of people enrolled in your Person Directory |
| Display Language | Language used by SAFR |
| Theme | Light Theme or Dark Theme |

## 3. Status page: usage and health counters

Account Usage Summary covers the current SAFR Account. Platform Usage Summary shows the same counters across **all** user accounts and **is only available for on-premises deployments**. [S14]

| Counter | Definition |
|---|---|
| Number of Directories | Directories in your SAFR Account |
| Number of People | People currently registered |
| Number of Faces | Faces currently stored in SAFR's Identity Database |
| Sites with active recognitions | Number of defined sites; a site can consist of one or more cameras, usually multiple |
| Sources with active recognitions | Number of defined sources; a source can consist of one or more cameras, usually a single camera |
| Feeds with active recognitions | Feeds currently running across the SAFR system |
| Load | Recognition attempts every second across all currently active video feeds |
| Latency | Milliseconds for the server to generate a response after receiving a recognition request from a client |

**Use Load and Latency as the two primary performance indicators.** They are the only numeric performance metrics SAFR exposes in the UI, and there is no documented API for them - see `known-gaps.md`.

## 4. Remote control by a central server

Enables a central SAFR server to control this server. [S14]

| Field | Notes |
|---|---|
| Local server name | Name of the local SAFR Server |
| Video viewing allowed | Lets the central server view video feeds connected to the local server |
| Configuration allowed | Lets the central server configure the local server |
| Host VIRGA address / port | IP of the central server's VIRGA service; port defaults to `8085` |
| Host CVOS address / port | IP of the central server's CVOS service; port defaults to `8087` |
| Host User Id / Host password | Credentials to log into the central server |

## 5. Identity synchronization

Syncs your Person Directory with another Person Directory, which may belong to another SAFR system or to a different user directory within your own system. [S14]

| Field | Notes |
|---|---|
| User directory name | The directory to sync identities with |
| Only sync identities with the following attributes | Restricts sync to identities with the specified attributes |
| Person type | Person types an identity must have to be synced |
| Id-Classes | Id Classes an identity must have to be synced |
| Only sync from host but not back to host | Makes synchronization **uni-directional**. When not enabled, any identity in either directory that is not in the other is copied, so both directories end up identical |
| Merge matching anonymous identities | Anonymous imported identities whose faces match faces already in the local Identity Database are merged |
| Host COVI address / port | Target machine's CoVi service; port defaults to `8081` |
| Host CVOS address / port | Target machine's CVOS service; port defaults to `8087` |
| Host User Id / Host Password | Credentials for the host machine |

The bidirectional default is the trap here: leaving "Only sync from host but not back to host" unchecked will push local identities up to the host as well. Confirm intent before enabling sync.

Sync activity is logged to `cv-event\logs\sync.log`. [S3]

## 6. Event archiving

Syncs your event archive with another SAFR account's event archive, on the same or a different SAFR Server. [S14]

| Property | Documented value |
|---|---|
| Sync interval | Once every **10 minutes** |
| Delivery guarantee | Events are guaranteed to be synced; on error the sync is repeatedly retried until successful |
| Deletions | **Deletions are not synced.** Deleting an event in the target archive does not delete it locally |

## 7. External identity synchronization

Syncs with a third-party access control platform. [S14]

| Field | Notes |
|---|---|
| User directory name | Name of the user directory |
| External identity host | Name of the third party access control platform. The Status page documents **two** possible values: `AMAG` and `Software House` |
| Host Address | IP address or hostname of the target host |
| Host Port | Port the target machine is listening on. No default documented |
| Host User Id / Host Password | Credentials for the host machine |

**Important conflict.** The Status page lists only AMAG and Software House, but the Genetec integration guides describe Genetec and Genetec SaaS appearing as external identity hosts. The Status page is almost certainly stale relative to the Genetec guides. Treat the Genetec guides as authoritative for Genetec and see `genetec-integration.md`. Logged as a gap.

## 8. Notification services

SMTP email and SMS can be configured from the Status page. SAFR requires an SMTP server account that you can use to send emails before configuration. [S14] Exact field lists and defaults are only partially documented; specifics are **Not documented** here beyond the requirement itself.

## 9. Data indexing and cleanup

| Setting | Documented behaviour |
|---|---|
| Event biometric indexing | Required to allow event searching by image on the Web Console Events page or the Desktop Client's Search by Image window. Visible only to users with `CONFIG_PRIVILEGE` or `SUPER_CONFIG_PRIVILEGE` |
| Indexing speed | The speed at which an event can be located when search by image runs. **Faster indexing speeds can lower system performance** |
| Immediately index new events | Indexes events as soon as they are created. **Can affect system performance when events are created** |
| Only index events occurred after specific date | Limits indexing to events after a chosen date |
| Event removal | Scheduled removal of events. Defaults **Not documented** |
| Identity removal | Scheduled removal of identities. Defaults **Not documented** |

The two privilege constants `CONFIG_PRIVILEGE` and `SUPER_CONFIG_PRIVILEGE` are the only privilege identifiers captured; the full privilege model is in Desktop Client Manage Users documentation which was not retrieved. Logged as a gap.

## 10. Log level configuration

Server log levels are file-based, not UI-based: `logback-spring.xml` in each service's `config` directory. Full detail in `operations.md` section 5.3. [S3]

## 11. Directory services and SSO

LDAP, SAML, and OIDC integration for SAFR Server administrator sign-in is **Not documented** on any page retrieved. The only directory concept documented is SAFR's own "user directory", which defaults to `main` and is an internal partition of the Person Directory rather than an enterprise directory integration. [S14] Logged as a gap.

## 12. Environment variables and registry keys

**Not documented.** No page retrieved lists environment variables or Windows registry keys used by SAFR Server. Configuration is by `safrports.conf`, `logback-spring.xml`, the Web Console, and installer flags. Logged as a gap.

## 13. Database cache

Database Memory Configuration exists as a separate advanced topic; the docs state most users do not need to configure their database caches, and that it exists to avoid errors that occur under certain circumstances. [S2] Specific keys and value ranges were not retrieved - logged as a gap.
