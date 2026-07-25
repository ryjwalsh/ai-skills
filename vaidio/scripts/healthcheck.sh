#!/usr/bin/env bash
# vaidio-healthcheck.sh - READ-ONLY health check for a Vaidio Core server.
#
# Every command below is transcribed from official Vaidio documentation:
#   S1  Vaidio Core Installation Guide (Docker & Admin Portal), v9.3.0
#         container_tool status / check_disk_space / -V / -v, nvidia-smi, lshw -C display,
#         mokutil --sb-state, systemctl status systemd-timesyncd.service, lsblk,
#         cat /opt/data/sys/vaidio/log/app/start_service.log,
#         curl https://ironyun.github.io/Vaidio-APT/KEY.gpg, ufw port list (22/80/443/8000/18888)
#   S2  Vaidio Core Upgrade Instructions - nvidia-smi, lsb_release -a
#   S3  Vaidio Core 9.3.0 Technical Support Guide - default admin ports
#   S5  Vaidio Core 9.1.0 Offline Installation User Guide - /var/log/, uname
#   S6  Ubuntu 22.04 Installation Guide - apt utility list
#
# SAFETY: this script only reads state. It never starts, stops, removes, prunes,
# upgrades, installs, resets or writes anything. Do not add container_tool
# run/stop/start/remove/prune/upgrade, preinstall, apt install, or Factory Reset here.
#
# Usage:  sudo ./vaidio-healthcheck.sh
# Note:   root/sudo is required because only root can run Docker commands on the
#         offline-image installs (S5) and container_tool is invoked with sudo (S1).

set -u

SYS_VOL_LOG="/opt/data/sys/vaidio/log/app/start_service.log"
VAIDIO_CONF="/etc/vaidio/vaidio.conf"
MIN_DRIVER="535.183.06"
VENDOR_KEY_URL="https://ironyun.github.io/Vaidio-APT/KEY.gpg"
PORTS="22 80 443 8000 18888"

hr()      { printf '\n=== %s ===\n' "$1"; }
have()    { command -v "$1" >/dev/null 2>&1; }
skip()    { printf '  [skip] %s not found on this host\n' "$1"; }

hr "Host and OS"
date
hostname
if have lsb_release; then lsb_release -a 2>/dev/null; else skip lsb_release; fi
uname -v
printf 'Documented supported OS for Vaidio Core: Ubuntu 22.04 (S1)\n'

hr "CPU instruction set (avx, avx2, sse4 are required - S1)"
if [ -r /proc/cpuinfo ]; then
  for f in avx avx2 sse4_1 sse4_2; do
    if grep -qm1 "\\b${f}\\b" /proc/cpuinfo; then
      printf '  present : %s\n' "$f"
    else
      printf '  MISSING : %s\n' "$f"
    fi
  done
else
  skip /proc/cpuinfo
fi

hr "GPU driver (minimum ${MIN_DRIVER} - S1, S2)"
if have nvidia-smi; then
  nvidia-smi
else
  printf '  nvidia-smi not found. If the container will not start, see troubleshooting S-03.\n'
fi

hr "GPU hardware presence (S1)"
if have lshw; then lshw -C display; else skip lshw; fi

hr "Secure Boot state (S1)"
if have mokutil; then mokutil --sb-state; else skip mokutil; fi

hr "Time synchronisation service (S1)"
if have systemctl; then
  systemctl status systemd-timesyncd.service --no-pager 2>&1 | head -n 12
else
  skip systemctl
fi

hr "Block devices and mount points (S1)"
if have lsblk; then lsblk; else skip lsblk; fi
printf '\nDocumented volumes: /opt/data/sys (system), /mnt/data (metadata), /mnt/data-rec (recorder) - S1\n'
for m in /opt/data/sys /mnt/data /mnt/data-rec; do
  if [ -d "$m" ]; then df -h "$m" 2>/dev/null | tail -n 1 | sed "s|^|  |"; fi
done

hr "Vaidio container status (S1)"
if have container_tool; then
  container_tool status 2>&1
else
  skip container_tool
fi

hr "Vaidio disk space check (S1)"
if have container_tool; then container_tool check_disk_space 2>&1; else skip container_tool; fi

hr "Versions (S1)"
if have container_tool; then
  printf 'container_tool -V : '; container_tool -V 2>&1
  printf 'container_tool -v : '; container_tool -v 2>&1
else
  skip container_tool
fi

hr "Configuration file (read-only view - S1)"
if [ -r "$VAIDIO_CONF" ]; then
  cat "$VAIDIO_CONF"
else
  printf '  %s not present or not readable.\n' "$VAIDIO_CONF"
  printf '  If the Admin Portal reports "config %s does not exist", see troubleshooting S-04.\n' "$VAIDIO_CONF"
fi

hr "Upgrade / service start log tail (S1)"
if [ -r "$SYS_VOL_LOG" ]; then
  tail -n 40 "$SYS_VOL_LOG"
else
  printf '  %s not present or not readable.\n' "$SYS_VOL_LOG"
fi

hr "Firewall state and documented Vaidio ports (S1)"
if have ufw; then ufw status verbose 2>&1; else skip ufw; fi
printf 'Documented ufw allowances: %s\n' "$PORTS"
printf '  22=SSH  80=Core HTTP  443=Core HTTPS  8000=Admin Portal  18888=ONVIF auto discovery\n'

hr "Local listeners on documented Vaidio ports"
if have ss; then
  for p in $PORTS; do
    printf '  port %-6s: ' "$p"
    ss -ltn 2>/dev/null | awk -v P=":$p\$" '$4 ~ P {found=1} END {print (found ? "listening" : "not listening")}'
  done
elif have netstat; then
  netstat -ltn 2>/dev/null
else
  skip "ss/netstat"
fi

hr "Vendor repository reachability (S1)"
if have curl; then
  if curl -fsS --max-time 15 "$VENDOR_KEY_URL" | head -n 2; then
    printf '  Reachable. A public key block above means DNS, egress and proxy are healthy.\n'
  else
    printf '  NOT reachable. Per S1 this indicates DNS, firewall or proxy trouble (troubleshooting S-01).\n'
  fi
else
  skip curl
fi

hr "Recent host log activity (S5)"
if [ -d /var/log ]; then
  printf 'Newest files in /var/log (collect this whole directory for install failures - S5):\n'
  ls -lt /var/log 2>/dev/null | head -n 12
else
  skip /var/log
fi

hr "Reminders"
cat <<'EOF'
  - Full diagnostics for a vendor ticket also require, from the web UI:
      System > License > Export        (.info system information file)
      System > Log > Export            (Diagnostic log and System log, .xlsx)
      System > Audit Trail > Export    (.xlsx)
    Command Center / Vaidio Enterprise: use Export Diagnostic Log.
    Vaidio Data: System > Export Log.
  - Admin URLs: Core http://<vaidioip> , Admin Portal http://<vaidioip>:8000
  - This script made no changes. Anything that changes state (container_tool
    run/stop/start/remove/prune/upgrade, preinstall, Factory Reset) must be run
    deliberately by an operator, not by a health check.
EOF

printf '\nDone.\n'
