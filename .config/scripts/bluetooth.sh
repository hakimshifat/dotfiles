#!/bin/bash

# Here we set the Bluetooth device address
# 5F:A5:DB:3B:1A:55
device_address="28:52:E0:03:6A:CB"
# device_address="5F:A5:DB:3B:1A:55"

# Get the connection status of the device
connection_status=$(bluetoothctl info $device_address | grep "Connected:" | awk '{print $2}')

# Here we determine status based on connection status
if [ "$connection_status" == "yes" ]; then
  status="connected"
else
  status="disconnected"
fi

# Let's print initial status
echo "Device $device_address is currently $status"

# If the device is connected, disconnect it
if [ "$connection_status" == "yes" ]; then
  echo "Disconnecting from $device_address..."
  status="disconnected"
  bluetoothctl <<EOF
  disconnect $device_address
EOF
else
  # If the device is disconnected, connect to it
  echo "Connecting to $device_address..."
  status="connected"
  bluetoothctl <<EOF
  connect $device_address
EOF
fi

# Print final status
echo "Device $device_address is now $status"
