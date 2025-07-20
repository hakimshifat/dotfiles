#!/bin/sh

# Cron jobs run with a minimal environment, so we use absolute paths.
# Note: If your shell commands are in a different location (e.g. /bin), adjust accordingly.
SWAYMSG_CMD="/usr/bin/swaymsg"
PKILL_CMD="/usr/bin/pkill"
FIND_CMD="/usr/bin/find"
SHUF_CMD="/usr/bin/shuf"

# Manually find the sway socket path, which is more reliable in cron.
export SWAYSOCK=$(find /run/user/$(id -u) -name 'sway-ipc.*.sock' 2>/dev/null | head -n 1)

# If no socket is found, exit. This can happen if sway isn't running.
if [ -z "$SWAYSOCK" ]; then
    echo "Sway socket not found. Is sway running?" >&2
    exit 1
fi

# Kill any lingering swaybg processes.
# This prevents conflicts if you previously used swaybg in your sway config.
$PKILL_CMD swaybg >/dev/null 2>&1

# Define the directory where your wallpapers are stored.
# Using an absolute path is crucial for cron.
WALLPAPER_DIR="/home/sifat/Pictures/wall"

# Find all files in the directory, shuffle them, and pick one.
RANDOM_WALLPAPER=$($FIND_CMD "$WALLPAPER_DIR" -type f | $SHUF_CMD -n 1)

# Use swaymsg to command the running sway instance to set the wallpaper.
if [ -n "$RANDOM_WALLPAPER" ]; then
    $SWAYMSG_CMD output '*' bg "$RANDOM_WALLPAPER" fill
fi
