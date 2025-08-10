#!/bin/bash

if [ "$1" == "--toggle-mic" ]; then
  pactl set-source-mute @DEFAULT_SOURCE@ toggle
  exit 0
fi

if pactl get-source-mute @DEFAULT_SOURCE@ | grep -q "yes"; then
  echo '{"text": "", "class": "muted"}'
else
  echo '{"text": "", "class": "active"}'
fi