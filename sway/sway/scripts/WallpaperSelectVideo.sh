#!/usr/bin/env bash

# Folder containing your video wallpapers
WALL_DIR="$HOME/Videos/Hidamari"

# Pick a random video file
VIDEO="$(find "$WALL_DIR" -type f \( -iname "*.mp4" -o -iname "*.mkv" -o -iname "*.webm" \) | shuf -n 1)"

# Kill any running mpvpaper instances
pkill mpvpaper

# Start mpvpaper with optimized flags for Intel HD 620
mpvpaper -s -f \
  -o "no-audio --no-config --profile=fast \
      --hwdec=vaapi --gpu-api=vulkan --vo=gpu \
      --no-osc --osd-level=0 --loop-file=inf \
      --vd-lavc-software-fallback=no" \
  eDP-1 "$VIDEO"

