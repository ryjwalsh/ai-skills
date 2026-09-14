# Networking Best Practices (bundle networking-best-practices) + Avigilon Unity Architecture (bundle avigilon-unity-architecture)
Base: https://docs.avigilon.com/bundle/networking-best-practices/page/<path> and https://docs.avigilon.com/bundle/avigilon-unity-architecture/page/<path>

## Networking best practices
- NIC teaming on Windows NVR: Server Manager > Local Server > NIC Teaming > Tasks > New Team; Teaming mode Switch Independent, Standby adapter = Active-Standby (or Address Hash load balancing). Recommended: two teams — 10-GbE team for camera network, 1-GbE team for client/corporate network. [nic-teaming]
- AI NVR (Linux hardened OS): bonding modes Active Backup / LACP (802.3ad, switch must support) / ALB (adaptive load balancing); create teams in Management Interface > Network panel (select adapters > Create Team > mode). [ai-nvr-nic-teaming]
- Hardened OS Enterprise: Management Interface > Network > interface tabs General / IP (DHCP or static, multiple addresses) / DNS / Advanced (routing tables, MTU); VLAN: add VLAN interface on a physical port with VLAN ID. [hardened-os-networking]
- Docker IP Address Pools (Unity 8.6+ on AI NVR / hardened OS): Management Interface > Network > Docker pane; must be a private CIDR that does not collide with camera/corporate subnets; pool must supply >=32 subnets each >=256 addresses (e.g. /19 with /24 subnets). Default Docker ranges 172.17.0.0/16 and 172.18.0.0/16 must not be used for cameras/clients on Windows servers either. [docker-ip-pools]
- Troubleshooting: Unusual Motion Detection on non-analytic cameras — size the stream ~33% below max resolution/rate (not needed on 7.14.28+/8.2+). HDVA (HD Video Appliance) internal PoE switch default 192.168.2.1, WebUI 192.168.2.99; three adapters: Corporate LAN / Internal Camera LAN / WebUI. AI Appliance interoperability: appliance must reach server NIC and cameras; keep on same VLAN as cameras or route. [troubleshooting]

## Unity architecture
- Segmentation: unique subnet per NIC; ONLY one default gateway, on the client/corporate NIC; camera NIC static, no gateway. [network-segmentation]
- Clustering / failover: N+1 clustering overhead 1/n; recommended failover ratio 4:1 (one standby server per four primaries); failover requires Enterprise, servers in same site, license priority 1-5 configured (Site Setup > Server > Failover), matching versions and storage sizing. [failover]
- Forbidden subnets: 172.17.0.0/16 and 172.18.0.0/16 (Docker internal). [docker]
- Protocols: camera discovery WS-Discovery 3702 UDP (multicast 239.255.255.250); RTSP 554; ONVIF 80/443; server 38880-38883 TCP; live UDP 51000-55000 (LAN) — WAN (Secured) uses TCP 38880 for video. [protocols]
- LAN vs WAN connection: Client > Site login > connection type LAN (UDP media) vs WAN (Secured) (TCP tunnelled through 38880); use WAN when UDP blocked/NAT/VPN or live video is black. [lan-wan]
- Migration: temporary link-local 169.254.x.x addresses appear during server migration/replacement — do not statically assign that range. [migration]
- Latency targets: 4-6 ms LAN, jitter <=30 ms; WAN tolerates ~1 s latency and ~1% loss for Client, but Client connect timeouts increase. [latency]
- Bandwidth planning caps (CVBR default max bitrate): 1MP 4 Mbps, 2MP 6 Mbps, 2MP PTZ 8 Mbps, 15 fps default; H.265 saves ~30-50% bandwidth at cost of server/client CPU (no HDSM-based decode savings for non-Avigilon H.265). [bandwidth]
