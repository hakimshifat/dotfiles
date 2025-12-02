#!/bin/bash

# File to store the ID of our scratchpad window
STATE_FILE="/tmp/niri_scratch_id"
# The workspace we send the window to "hide" it (use a high number)
HIDDEN_WORKSPACE=99

# 1. Get current context
CURRENT_WORKSPACE=$(niri msg -j workspaces | jq '.[] | select(.is_focused == true).id')
FOCUSED_WINDOW=$(niri msg -j windows | jq '.[] | select(.is_focused == true).id')

# 2. Read the stored ID (if it exists)
STORED_ID=""
if [ -f "$STATE_FILE" ]; then
	STORED_ID=$(cat "$STATE_FILE")
fi

# 3. Validation Function: Check if a specific ID actually exists in Niri
window_exists() {
	niri msg -j windows | jq -e ".[] | select(.id == $1)" >/dev/null
}

# --- LOGIC FLOW ---

# Case A: We have a valid Stored ID
if [ -n "$STORED_ID" ] && window_exists "$STORED_ID"; then

	# Check if the Stored ID is the one currently focused
	if [ "$FOCUSED_WINDOW" == "$STORED_ID" ]; then
		# HIDE IT: It is currently open, so send it to the shadow realm
		niri msg action move-window-to-workspace "$HIDDEN_WORKSPACE"
	else
		# SHOW IT: It is hidden (or somewhere else), bring it here
		niri msg action move-window-to-workspace "$CURRENT_WORKSPACE"
		niri msg action move-window-to-floating --id "$STORED_ID"
		niri msg action focus-window --id "$STORED_ID"

		# Optional: Force a nice size (remove if you prefer manual sizing)
		niri msg action set-window-width --id "$STORED_ID" 1000
		niri msg action set-window-height --id "$STORED_ID" 700
		niri msg action center-window --id "$STORED_ID"
	fi

# Case B: No valid Scratchpad exists (First run or previous app closed)
else
	# Check if we actually have a window focused right now to assign
	if [ -n "$FOCUSED_WINDOW" ] && [ "$FOCUSED_WINDOW" != "null" ]; then
		# ASSIGN NEW: Save this window's ID as the new scratchpad
		echo "$FOCUSED_WINDOW" >"$STATE_FILE"

		# Immediately hide it to confirm action
		niri msg action move-window-to-workspace "$HIDDEN_WORKSPACE"
		# Optional: Send a notification
		notify-send "Niri" "Window assigned to scratchpad"
	else
		notify-send "Niri" "No window focused to assign as scratchpad"
	fi
fi
