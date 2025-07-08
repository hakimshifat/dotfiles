#!/bin/bash

device_address="28:52:E0:03:6A:CB"

info=$(bluetoothctl info "$device_address")
status=$(echo "$info" | grep "Connected:" | awk '{print $2}')

# Try to detect if it's trying to connect
if echo "$info" | grep -q "Connected: yes"; then
  icon="🎧"
  tooltip="Headphone Connected"
  class="connected"
elif pgrep -fx "bluetoothctl connect $device_address" >/dev/null; then
  icon="⏳"
  tooltip="Connecting..."
  class="connecting"
else
  icon="❌"
  tooltip="Click to Connect"
  class="disconnected"
fi

echo "{\"text\": \"$icon\", \"tooltip\": \"$tooltip\", \"class\": \"$class\"}"
