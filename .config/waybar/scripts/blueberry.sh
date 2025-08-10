#!/bin/bash

# Function to get Bluetooth status
get_status() {
  if bluetoothctl show | grep -q "Powered: yes"; then
    if bluetoothctl info | grep -q "Connected: yes"; then
      echo '{"text": "", "class": "connected", "tooltip": "Bluetooth Connected"}'
    else
      echo '{"text": "󰂯", "class": "disconnected", "tooltip": "Bluetooth Disconnected"}'
    fi
  else
    echo '{"text": "󰂲", "class": "disabled", "tooltip": "Bluetooth Off"}'
  fi
}

# Function to toggle Bluetooth connection
toggle_connection() {
  if bluetoothctl show | grep -q "Powered: yes"; then
    if bluetoothctl info | grep -q "Connected: yes"; then
      bluetoothctl disconnect
    else
      bluetoothctl connect
    fi
  fi
}

# Function to launch Blueberry
launch_blueberry() {
  blueberry &
}

# Main script logic
case "$1" in
  --get-status)
    get_status
    ;;
  --toggle-connection)
    toggle_connection
    ;;
  --launch-blueberry)
    launch_blueberry
    ;;
  *)
    get_status
    ;;
esac
