#!/bin/bash

# Check if we received an argument (i.e., toggle request)
if [ "$1" == "toggle" ]; then
  # Toggle the microphone mute state
  amixer set Capture toggle
fi

# Check if microphone is muted using amixer
mic_status=$(amixer get Capture | grep -o "\[off\]")

# If the microphone is muted
if [ "$mic_status" == "[off]" ]; then
  echo " Mic Muted" # Muted icon or text
else
  echo " Mic On" # Unmuted icon or text
fi
