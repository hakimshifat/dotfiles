#!/bin/bash

# Check WARP status
STATUS=$(warp-cli status | grep "Status update" | awk '{print $3}')

if [[ "$1" == "click-left" ]]; then
    # Left click => Connect
    warp-cli connect >/dev/null 2>&1
    exit 0
elif [[ "$1" == "click-right" ]]; then
    # Right click => Disconnect
    warp-cli disconnect >/dev/null 2>&1
    exit 0
fi

# Show current status
if [[ "$STATUS" == "Connected" ]]; then
    echo "{\"text\":\"󰖂 Connected\",\"class\":\"connected\"}"
else
    echo "{\"text\":\"󰖂 Disconnected\",\"class\":\"disconnected\"}"
fi

