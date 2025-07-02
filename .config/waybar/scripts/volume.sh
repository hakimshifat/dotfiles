#!/bin/bash
exec 2>/dev/null # hide errors

if [ "$1" == "--toggle-mute" ]; then
  pactl set-sink-mute @DEFAULT_SINK@ toggle
  exit 0
fi

if [ "$1" == "--increase" ]; then
  pactl set-sink-volume @DEFAULT_SINK@ +5%
  exit 0
fi

if [ "$1" == "--decrease" ]; then
  pactl set-sink-volume @DEFAULT_SINK@ -5%
  exit 0
fi

if pactl get-sink-mute @DEFAULT_SINK@ | grep -q "yes"; then
  echo '{"text": "  Muted", "class": "muted"}'
  exit 0
fi

volume=$(pactl get-sink-volume @DEFAULT_SINK@ | awk '{print $5}' | head -n1 | tr -d '%')

if [ "$volume" -ge 60 ]; then
  cls="high"
elif [ "$volume" -ge 30 ]; then
  cls="medium"
else
  cls="low"
fi

echo "{\"text\": \"  ${volume}%\", \"class\": \"$cls\"}"
