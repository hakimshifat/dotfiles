#!/usr/bin/env bash
#
# collect-debug.sh — gather detailed system & Sway debug info
# Outputs to: system-debug-YYYYMMDD_HHMMSS.txt
# Run as your user (it will invoke sudo where needed).
#

set -euo pipefail

# Timestamp and output file
TS=$(date '+%Y%m%d_%H%M%S')
OUTFILE="system-debug-${TS}.txt"

# Start logging
exec > >(tee -a "$OUTFILE") 2>&1

echo "===== SYSTEM DEBUG DUMP ($TS) ====="
echo ""

# 1. Masked hostname
echo "## Hostname"
echo "HOSTNAME: <your-hostname-masked>"
echo ""

# 2. Kernel & OS
echo "## Kernel & OS"
echo "Kernel: $(uname -srmo)"
echo "OS Release:"
grep -E '^(NAME|PRETTY_NAME|VERSION)=' /etc/os-release || true
echo ""

# 3. Package List
echo "## Installed Packages (explicitly installed)"
sudo pacman -Qqe || echo "(failed to list packages)"
echo ""

# 4. Hardware Inventory
echo "## Hardware"
echo "- CPU:"
lscpu | sed '/^Model name:/!d;s/Model name:/  •/'

echo "- PCI devices:"
lspci -k

echo "- USB devices:"
lsusb

echo "- Block devices & filesystems:"
lsblk -f

echo "- Memory:"
free -h

echo "- Disks & partitions usage:"
df -h

echo ""

# 5. Network
echo "## Network"
echo "- Interfaces & addresses:"
ip addr show
echo "- Routing table:"
ip route show
echo ""

# 6. Systemd & Services
echo "## systemd"
echo "- Failed units:"
systemctl --failed --no-pager
echo ""
echo "- Sway service (if any):"
systemctl status sway --no-pager || echo "(no systemd sway service detected)"
echo ""
echo "- Timers:"
systemctl list-timers --all --no-pager
echo ""

# 7. Logs
echo "## Journal Logs (current boot)"
echo "--- Full journalctl -b ---"
journalctl -b --no-pager || echo "(journalctl failed)"
echo ""
echo "--- Sway-specific logs ---"
journalctl _COMM=sway --no-pager || echo "(no sway logs)"
echo ""

# 8. Kernel ring buffer
echo "## dmesg"
dmesg --level=err,warn,info --color=never || echo "(dmesg failed)"
echo ""

# 9. Sway Configuration
echo "## Sway Configuration (~/.config/sway/config)"
if [ -f "$HOME/.config/sway/config" ]; then
  sed '/^\s*#/d' "$HOME/.config/sway/config"  # drop comments for brevity
else
  echo "(no sway config found)"
fi
echo ""

# 10. Xorg logs (if you ever fall back)
if [ -f /var/log/Xorg.0.log ]; then
  echo "## Xorg Log (/var/log/Xorg.0.log)"
  grep -E '(EE|WW)' /var/log/Xorg.0.log || echo "(no errors/warnings)"
  echo ""
fi

echo "===== END OF DEBUG DUMP ====="
echo ""
echo "All output saved in: $OUTFILE"

