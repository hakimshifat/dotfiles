#!/bin/bash

# Get bluetooth status
status=$(bluetoothctl show | grep "Powered" | awk '{print $2}')

if [ "$status" = "yes" ]; then
  echo "{\"text\":\" ON\"}" # Use a Bluetooth icon, e.g., FontAwesome 
else
  echo "{\"text\":\" OFF\"}"
fi
