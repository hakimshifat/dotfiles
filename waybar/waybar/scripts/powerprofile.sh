#!/usr/bin/env bash
# Shows current power profile, or toggles/menu based on arg

# --- Icons (pick what you like) ---
ICON_PERF="⚡" # or  (Nerd Font)
ICON_BAL="⚙️" # or 
ICON_SAVE="🌿" # or 󰾆

get_current() {
	powerprofilesctl get 2>/dev/null
}

set_profile() {
	powerprofilesctl set "$1"
}

cycle() {
	case "$(get_current)" in
	performance) set_profile balanced ;;
	balanced) set_profile power-saver ;;
	power-saver) set_profile performance ;;
	*) set_profile balanced ;;
	esac
}

menu() {
	# Choose a launcher: wofi > rofi > dmenu
	if command -v tofi >/dev/null 2>&1; then
		CHOICE=$(printf "performance\nbalanced\npower-saver" | tofi -c ~/.config/tofi/configA --prompt-text "Power Profile")
	elif command -v wofi >/dev/null 2>&1; then
		CHOICE=$(printf "performance\nbalanced\npower-saver" | wofi --dmenu -p "Power Profile")
	elif command -v rofi >/dev/null 2>&1; then
		CHOICE=$(printf "performance\nbalanced\npower-saver" | rofi -dmenu -p "Power Profile")
	elif command -v dmenu >/dev/null 2>&1; then
		CHOICE=$(printf "performance\nbalanced\npower-saver" | dmenu -p "Power Profile")
	else
		notify-send "Waybar Power" "Install tofi/wofi/rofi/dmenu for menu" || true
		exit 0
	fi

	[[ -n "$CHOICE" ]] && set_profile "$CHOICE"
}

output_json() {
	current="$(get_current)"
	case "$current" in
	performance)
		icon="$ICON_PERF"
		klass="performance"
		;;
	balanced)
		icon="$ICON_BAL"
		klass="balanced"
		;;
	power-saver)
		icon="$ICON_SAVE"
		klass="power-saver"
		;;
	*)
		icon="$ICON_BAL"
		klass="unknown"
		;;
	esac

	# Waybar custom module expects JSON
	printf '{"text":"%s","alt":"%s","class":"%s","tooltip":"Power profile: %s"}\n' \
		"$icon" "$current" "$klass" "$current"
}

case "$1" in
toggle)
	cycle
	output_json
	;;
menu)
	menu
	output_json
	;;
*) output_json ;;
esac
