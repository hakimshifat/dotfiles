#!/bin/bash

# Create directory if not exists
DIR="$HOME/Pictures/"
mkdir -p "$DIR"

# Timestamped filename
FILENAME="$DIR/screenshot_$(date +'%Y-%m-%d_%H-%M-%S').png"

# Let user select region
GEOM=$(slurp)

# Take screenshot of selected region
grim -g "$GEOM" "$FILENAME"

# Copy screenshot to clipboard
wl-copy < "$FILENAME"

# Optional: Notify
# notify-send "Screenshot saved and copied!" "$FILENAME"

