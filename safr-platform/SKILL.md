---
name: safr-platform
description: Comprehensive knowledge of SAFR (RealNetworks) on-premises face recognition, covering SAFR Server, COVI, CVEV, VIRGA, CVOS, VIRGO, SAFR SCAN readers, the Web Console, the SAFR REST API, and Genetec Security Center integration. Use whenever the user mentions SAFR, SAFR SCAN, VIRGO, VIRGA, COVI, CVEV, CVOS, safrports.conf, virgo-factory.conf, syscollect, or asks about installing, licensing, sizing, upgrading, configuring, integrating or diagnosing any of them.
---

# SAFR Platform (on-premises)

SAFR is RealNetworks' face-recognition platform: a server cluster that performs recognition and stores identities and events, video ingestion agents, edge reader hardware, and REST APIs for integration into VMS and access-control systems such as Genetec Security Center.

## Version coverage

Knowledge current as of documentation retrieved **2026-07-24**, covering the vendor doc set stamped **Documentation Version 3.048 (published August 19 2022)** for the Server, VIRGO and REST API material, and the **current 2025** Genetec and SAFR SCAN guides. Verify version-sensitive answers against current docs. The doc version is **not** the product version and the two are never correlated in the source material.

**Deployment lens: on-premises.** Where the docs branch between SAFR Cloud and SAFR Local, this package follows SAFR Local.

## Quick facts

| Item | Value |
|---|---|
| Core sub-systems | COVI (recognition), Event Server, VIRGA (feed admin), Reports, CVOS (object storage) |
| Sub-system directories | `covi\`, `cv-event\`, `virga\`, `cv-reports\`, `cv-object-storage\` |
| Program root | `C:\Program Files\RealNetworks\SAFR` / `/opt/RealNetworks/SAFR` / `/Library/RealNetworks/SAFR` |
| Data, logs, config root (Windows) | `C:\ProgramData\RealNetworks\SAFR\` |
| Backups (Windows / Linux) | `C:\Program Files\RealNetworks\SAFR-backups\` / `/opt/RealNetworks/SAFR-backups/` |
| Port config file | `safrports.conf` in the program root |
| Service status | `bin/check` or `bin\check.bat` |
| Start / stop, per node | `bin/start`, `bin/stop` |
| Port discovery | `python bin/portcheck.py` |
| Support bundle | `python bin/syscollect.py` |
| Default service ports | COVI `8080` HTTPS / `8081` HTTP, CVEV `8082`/`8083`, VIRGA `8084`/`8085`, CVOS `8086`/`8087` |
| Only external endpoint | `cv-instam.real` on port `443` for licensing |
| Admin UI | Web Console, Status page shows Version, Environment, Load, Latency, licence limits |
| Local API docs | `https://<server>:8080/docs/index.html` and per-service equivalents |
| API auth | Header `X-RPC-AUTHORIZATION: userid:pwd` plus `X-RPC-DIRECTORY: main` |
| Log defaults | Application logs default to `WARN` on four of five sub-systems; retention 14 days |
| Default credentials policy | None documented. **Default TLS certificates are shared across all installs and must be replaced** |

## Where to look

| Question is about | Read |
|---|---|
| Components, services, clusters, failover, object storage, GPU deps | `references/architecture.md` |
| Ports, firewalls, TLS, certificates, DNS, static IP, proxy | `references/network-ports.md` |
| Requirements, sizing, silent install, upgrades, licensing, backup, restore | `references/install-upgrade.md` |
| Web Console settings, identity sync, event archiving, indexing, cleanup | `references/configuration.md` |
| Scripts, service control, logging levels and paths, support bundles | `references/operations.md` |
| Something is broken on the server or a video feed | `references/troubleshooting.md` |
| Something is broken on a SAFR SCAN reader | `references/scan-diagnostics.md` |
| REST API, endpoints, headers, events, SDKs | `references/api-integration.md` |
| Genetec cardholders, RIO, camera integration, part numbers | `references/genetec-integration.md` |
| Where a fact came from | `sources.md` |
| Docs are silent or contradictory | `known-gaps.md` |
| Read-only health sweep | `scripts/healthcheck.ps1` |

## Rules for answering

1. **Never invent a port number.** Only `cv-instam.real:443` and the `8080` to `8087` service defaults are documented. Everything else comes from `portcheck` on the actual server.
2. **Never name the database engine.** The docs never do.
3. **Check licensing before deep diagnosis.** Expiry and failure to reach the licence server are hard stops that look like software faults.
4. **Expect empty logs.** Defaults are `WARN`, retention is 14 days, and VIRGO keeps no log history at all.
5. **Two doc vintages disagree.** Where a Genetec or SCAN guide conflicts with a Server or API page, prefer the newer guide and say so.
6. **Cite the reference file** you drew the answer from, and flag anything tagged `[INFERRED - verify]`.

## Five most common triage flows

### 1. Server unresponsive or a sub-system is down

Run `check`. If a sub-system is down, `stop` then `start` **on that node** - both scripts act only on the current machine. Confirm no port conflict with `portcheck`. Check the Status page licence fields before assuming a software fault. There is no documented way to restart one sub-system. Detail: `references/troubleshooting.md` section 2.

### 2. Unauthorized access error after moving or reinstalling the server

The licence is bound to the primary server. If the primary was **uninstalled** and reinstalled on a different IP inside 24 hours, licensing rejects it. Wait the full 24 hours or have the account manager reset the IP. If the IP or hostname changed while the server stayed installed, this is not the cause. Detail: `references/troubleshooting.md` section 4.

### 3. New video feeds refuse to connect

Almost always **Max Feeds per Hour**. Existing feeds must be disconnected for a full hour before the licence slot frees. One camera feeding two Desktop Clients counts as two feeds. Compare Status page *Feeds with active recognitions* against the licensed maximum. Detail: `references/troubleshooting.md` section 6.

### 4. Feed stuck prerolling, or dying with an unexpected termination

Prerolling with *Codec parameters not found* means the camera's H264 PPS packet is broken over UDP; add `"input.stream.rtsp.transport":"tcp"` to the feed. Feeds dying with *Unexpected termination* on Linux means a missing library; run `virgo/versions/current/virgofeedd` and read the missing `.so` name. Use `virgo service monitor` for per-feed telemetry, watching `#D-Skip` and `#R-Skip` for capacity exhaustion. Detail: `references/troubleshooting.md` sections 8, 9 and 13.

### 5. SAFR SCAN recognises the face but the door stays shut

Check Access Clearance is not None and is not schedule-restricted, then look at the event icon: **orange means anti-spoofing rejected it as a fake**, which is a liveness problem, not an access-rules problem. Confirm by temporarily setting Spoofing protection level to None, then restore it. For a reader that is simply unreachable, read the boot IP off the screen and append `&debug=1` to the web console URL for a logs tab. Detail: `references/scan-diagnostics.md` sections 5 and 12.

## Before opening a vendor ticket

Collect, in order: `syscollect` archive, `check` output, `portcheck` output, Status page Version and Environment, licence state, `virgo service monitor > my.csv`, and logs re-captured at `INFO` or `DEBUG`. Do it early - retention is 14 days. Detail: `references/troubleshooting.md` section 20.

## Known weak spots in the source documentation

There is **no port table**, **no error-code catalogue**, **no named database engine**, **no SSO documentation**, and **no rollback procedure** anywhere in the vendor docs. Image and face-size limits contradict across five separate figures. The REST pages misprint their own auth header names. Full list with source IDs: `known-gaps.md`.
