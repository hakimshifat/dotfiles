#!/bin/bash

if [ "$1" == "--toggle-mic" ]; then
  amixer set Capture toggle >/dev/null 2>&1
  exit 0
fi

if amixer get Capture | grep -q "\[off\]"; then
  echo '{"text": "", "class": "muted"}'
else
  echo '{"text": "", "class": "active"}'
fi

