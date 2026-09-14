# VideoXpert Enterprise architecture, ports and sizing
Source: VideoXpert Enterprise 3.21 System Design Guide C5673M-Q (pelco.com/fs/documents/C5673M-Q_VxEnterprise_v3.21_SystemDesignGuide.pdf), extracted 2026-09-14.

## Components
- **VideoXpert Core** - database of cameras, recorders, users, permissions; primary handles writes, secondaries replicate asynchronously; clusterable. **VideoXpert Media Gateway** - routes/transcodes video to clients (multicast routing, unicast, low-bandwidth transcoding, load balancing). Combined "CMG" servers. **VxDatabase** nodes in larger clusters.
- **VxStorage** (E-Series 288 TB, T-Series 144 TB, VXS5300 48 TB; RAID 6, hot-swap, iDRAC) - recorders; motion/alarm/bump-on-alarm; failover recorder monitors up to 8 recorders (gap up to 30 s); volumes / volume groups / Archive Volume Group to NAS (one archive group per recorder; never share one NAS path between recorders).
- **VxOpsCenter** (operator client, up to 8 monitors with Enhanced Decoders), **VxToolbox** (admin), **VxPortal** (HTML5, no H.265 - MJPEG), **VxPlayer** (exports), Enhanced Decoder (VX-A3-DEC+), Shared Display Decoder / VxWorkstation. Legacy VSM / NSM5200 / NSM5300 recorders (Endura migration).
- VideoXpert **Professional** (VxPro) = single-server bundle (Core + Media Gateway + Storage) managed by the same VxToolbox/VxOpsCenter.

## Ports
| Component | Ports |
|---|---|
| Core | TCP 80 HTTP (camera config), TCP 443 HTTPS (REST API, clients), UDP 1900 SSDP (239.255.255.250), UDP 3702 WS-Discovery, TCP 6001/6002 Hazelcast pre-cluster, TCP 15432 Postgres, TCP 16011/16012 Hazelcast post-cluster TLS |
| Media Gateway | TCP 554 RTSP, TCP 5443 internal API (MJPEG), TCP 6002 Hazelcast, TCP 8090 internal HTTP, TCP 16002 Hazelcast SSL, UDP 41950-65535 RTP/RTSP unicast reception |
| VxStorage | UDP 1900 SSDP, TCP 5544 RTSP command/control, TCP 6003 Hazelcast, TCP 9091 HTTP API (VxStorage portal), TCP 9443 HTTPS API/discovery, UDP 41950-65535 RTP/RTCP |
| VxOpsCenter client | TCP 21 FTP (decoder firmware/logs), TCP 443, TCP 554, TCP 5544, UDP 4502-49001 unicast streaming |
| Enhanced Decoder | TCP 21, UDP 4500-4900, TCP 43241 control |
| Shared Display / VxWorkstation | TCP 5900-5906 VNC |
| Legacy VSM/NSM | 22, 68, 80, 161/162, 199, 1605, 1781, 2900-2901, 4343, 10000-10008, 25556, 32768-61000, 49152 |
| General outbound | 21, 80, 123 NTP, 443, 554, 1900, 3702, 3389 RDP, 9443 VxStorage discovery, 49152 UPnP |

## Design rules
- All servers must use an NTP source; Cores/Media Gateways in a cluster on the same VLAN with static IPs; ≥2 servers for a cluster; cluster goes read-only when 2 of 3 servers are down; >3 servers → engage Pelco sales engineering. External load balancer needs HTTP/HTTPS/WebSocket/RTSP + health checks; internal VIP load balancing for ≤3 CMGs.
- Capacity: single CMG 2,500 cameras/100 users; dual CMG active-active 2,500/100; dual CMG NSVR hot-standby 7,500/400; triple CMG 10,000/500; separate Core+Gateway 3,000/200; multi-Core >10,000 with load balancer. Build with ≥10 % headroom.
- Storage bandwidth in: T-Series 700 Mbps (1 GbE) / 1000 Mbps (10 GbE); E-Series 700 / 2500 Mbps; VXS5300 450 Mbps; out 175 Mbps. Secondary streams 640×352 @ ≤5 ips recommended; 6×6/8×8 layouts need secondary ≤640×480@30; hard limit 128 streams per decoder instance, recommended ≤64.
- OpsCenter stream logic: cell ≥25 % of layout = primary, else secondary; CPU >75 % steps primary→secondary, >50 % secondary→I-frame; <5 Mbps links forced to MJPEG (<10 Mbps for aggregation); MJPEG PTZ = click-to-center only.
- Multicast: PIM-DM (flood/prune every 3 min - avoid on wireless), PIM-SM (RP near source), sparse-dense, DVMRP; check IGMP table limits; Pelco tested-switch list.
- Backups: system backup = database only; VxStorage daily recovery points kept 10 days; multi-Core backup must go to a UNC path on independent hardware. Failover recording keeps recording but not historical access - redundant recording needed for that.
- Auth: LDAP simple bind / two-stage bind / SSO (certificates; SSO unavailable when OpsCenter runs on the VxPro/Core server itself) / sync users & roles; MSA mode - sync LDAP users to each system.
- Aggregation (VxE): member settings changed only on the member; aggregation server does not inherit roles/users; connection speed governs streams; avoid cross-aggregation.
- Events: default retention 30 days (max 90), 10,000 events; notifications on-screen, SMS (Twilio), email (SMTP). SNMP monitor Core, Exports, Media Gateway, OpsCenter Communications, Storage, Storage Database services.
- Logs: C:\ProgramData\Pelco\Core\logs, \Gateway\logs, \Storage\logs, \OpsCenter\Logs (or About menu); 30-day rollover.
- OS: Windows Server 2016+ recommended (Server 2012 unsupported for major updates since Oct 2022).
- Camera support: VxStorage - Optera, Pelco Smart Analytics, legacy Pelco, ONVIF Profile S, native Axis/Hikvision/Panasonic/Vivotek; VSM/NSM - Optera tile mode + legacy Pelco only. 4K supported (ONVIF) but decoders output 1080p max.
