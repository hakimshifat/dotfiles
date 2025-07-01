#!/bin/bash

# Toggle mic mute and suppress *all* output (stdout + stderr + terminal fallback)
if [ "$1" == "--toggle-mic" ]; then
  (amixer set Capture toggle) >/dev/null 2>&1 </dev/null
  exit 0
fi

# Output only mute/unmute icon
if amixer get Capture | grep -q "\[off\]"; then
  echo "" # mic muted
else
  echo "" # mic active
fi
