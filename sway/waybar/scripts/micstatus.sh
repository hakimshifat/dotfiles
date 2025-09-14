#!/bin/bash

toggle_mic() {
  # Toggle mute on the default source (global)
  pactl set-source-mute @DEFAULT_SOURCE@ toggle

  # Also toggle mute on all active recording streams
  for id in $(pactl list short source-outputs | awk '{print $1}'); do
    pactl set-source-output-mute "$id" toggle
  done
}

get_status() {
  # First check global source mute
  if pactl get-source-mute @DEFAULT_SOURCE@ | grep -q "yes"; then
    echo '{"text": "", "class": "muted"}'
  else
    echo '{"text": "", "class": "active"}'
  fi
}

if [ "$1" == "--toggle-mic" ]; then
  toggle_mic
  exit 0
fi

get_status

