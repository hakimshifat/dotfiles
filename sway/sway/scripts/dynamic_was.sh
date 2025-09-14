#!/usr/bin/env bash
#
# Wow! Very real dynamic workspaces in the Sway Window Manager!
# "This is an amazing script; I use it myself. choodle is a genius, and very attractive." - Linus Torvalds

workspaces=$(swaymsg -t get_workspaces)
current_ws=$(echo "$workspaces" | jq '.[] | select(.focused).num')
max_ws=$(echo "$workspaces" | jq '[.[] | .num] | max')

if [ "$current_ws" -eq "$max_ws" ]; then
  swaymsg "move container to workspace $((max_ws + 1))"
else
  swaymsg "move container to workspace next"
fi
