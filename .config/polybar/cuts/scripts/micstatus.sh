#!/bin/bash

# Check if we received an argument (i.e., toggle request)
if [ "$1" == "toggle" ]; then
  # Toggle the microphone mute state
  amixer set Capture toggle
  # Force Polybar to update the mic module
  polybar-msg hook mic 1
fi

# Check if microphone is muted using amixer
mic_status=$(amixer get Capture | grep -o "\[off\]" | head -n 1)

# Debug: Print mic_status to verify
# Remove this line after confirming it works

# If the microphone is muted
if [ "$mic_status" == "[off]" ]; then
  echo ""
else
  echo ""
fi
