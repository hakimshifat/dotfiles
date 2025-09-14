#!/bin/bash

# Icons: Lock, Suspend, Logout, Reboot, Reboot to UEFI, Shutdown
OPTIONS="󰌾\n󰤄\n󰍃\n\n\n󰐥"

# Run fuzzel with powermenu config
SELECTION="$(echo -e "$OPTIONS" | fuzzel --dmenu -c ~/.config/fuzzel/powermenu.conf)"

# Confirmation prompt (cross = cancel, check = yes)
confirm_action() {
    local action="$1"
    CONFIRM="$(printf "󰅖\n󰄬" | fuzzel --dmenu -c ~/.config/fuzzel/powermenu.conf)"
    [[ "$CONFIRM" == "󰄬" ]]
}

# Match icons to actions
case "$SELECTION" in
    "󰌾")
        gtklock
        ;;
    "󰤄")
        if confirm_action "Suspend"; then
            systemctl suspend
        fi
        ;;
    "󰍃")
        if confirm_action "Log out"; then
            swaymsg exit
        fi
        ;;
    "")
        if confirm_action "Reboot"; then
            systemctl reboot
        fi
        ;;
    "")
        if confirm_action "Reboot to UEFI"; then
            systemctl reboot --firmware-setup
        fi
        ;;
    "󰐥")
        if confirm_action "Shutdown"; then
            systemctl poweroff
        fi
        ;;
    *)
        exit 0
        ;;
esac

