#!/bin/bash

# https://wiki.archlinux.org/title/CPU_frequency_scaling#power-profiles-daemon
# used in i3-blocks: ~/.config/i3/i3blocks.conf together with: ~/.config/i3/scripts/ppd-status


#######################################################################
#                             BEGIN CONFIG                              #
#######################################################################

# Use a custom lock script
#LOCKSCRIPT="i3lock-extra -m pixelize"

# Colors: FG (foreground), BG (background), HL (highlighted)
# These colors are generally handled by Wofi's CSS theme,
# so they are mostly for reference or if you manually configure Wofi's style.
FG_COLOR="#bbbbbb"
BG_COLOR="#111111"
HLFG_COLOR="#111111"
HLBG_COLOR="#bbbbbb"
BORDER_COLOR="#222222"

# Wofi options
# Wofi uses CSS for theming, so a Rofi .rasi theme cannot be directly used.
# If you have a specific Wofi CSS theme, it's typically set up in ~/.config/wofi/style.css
# or ~/.config/wofi/config.
WOFI_OPTIONS=() # Basic Wofi call, rely on Wofi's default or CSS theme
# Example if you want to override some Wofi options directly:
# WOFI_OPTIONS=(-W 500 -H 300 --prompt "Power Profile:") # -W for width, -H for height

# Zenity options
ZENITY_TITLE="Power Profiles"
ZENITY_TEXT="Set Profiles:"
ZENITY_OPTIONS=(--column= --hide-header)

#######################################################################
#                              END CONFIG                               #
#######################################################################

# Whether to ask for user's confirmation
enable_confirmation=false

# Preferred launcher if both are available
preferred_launcher="rofi" # <--- CHANGED: Set Rofi as preferred

usage="$(basename "$0") [-h] [-c] [-p name] -- display a menu for shutdown, reboot, lock etc.

where:
    -h  show this help text
    -c  ask for user confirmation
    -p  preferred launcher (wofi or zenity)

This script depends on:
  - systemd,
  - sway,
  - wofi or zenity." # <--- CHANGED: Mention wofi

# Check whether the user-defined launcher is valid
launcher_list=(rofi zenity) # <--- CHANGED: Added rofi to the list, removed wofi
function check_launcher() {
  if [[ ! "${launcher_list[@]}" =~ (^|[[:space:]])"$1"($|[[:space:]]) ]]; then
    echo "Supported launchers: ${launcher_list[*]}"
    exit 1
  else
    # Get array with unique elements and preferred launcher first
    # Note: uniq expects a sorted list, so we cannot use it
    i=1
    launcher_list=($(for l in "$1" "${launcher_list[@]}"; do printf "%i %s\n" "$i" "$l"; let i+=1; done \
      | sort -uk2 | sort -nk1 | cut -d' ' -f2- | tr '\n' ' '))
  fi
}

# Parse CLI arguments
while getopts "hcp:" option; do
  case "${option}" in
    h) echo "${usage}"
       exit 0
       ;;
    c) enable_confirmation=true
       ;;
    p) preferred_launcher="${OPTARG}"
       check_launcher "${preferred_launcher}"
       ;;
    *) exit 1
       ;;
  esac
done

# Check whether a command exists
function command_exists() {
  command -v "$1" &> /dev/null 2>&1
}

# systemctl required
if ! command_exists systemctl ; then
  exit 1
fi

# default_menu_options defined as an associative array
typeset -A default_menu_options

# The default options with keys/commands

default_menu_options=(
  [ Performance]="powerprofilesctl set performance"
  [ Balanced]="powerprofilesctl set balanced"
  [ Power Saver]="powerprofilesctl set power-saver"
  [ Cancel]=""
)

# The menu that will be displayed
typeset -A menu
menu=()

# Only add power profiles that are available to menu
for key in "${!default_menu_options[@]}"; do
  grep_arg=${default_menu_options[${key}]##* }
  if powerprofilesctl list | grep -q "$grep_arg"; then
    menu[${key}]=${default_menu_options[${key}]}
  fi
done
unset grep_arg
unset default_menu_options

menu_nrows=${#menu[@]}

# Menu entries that may trigger a confirmation message (not relevant for power profiles, but kept for script's original context)
menu_confirm="Shutdown Reboot Hibernate Suspend Halt Logout"

launcher_exe=""
launcher_options=""
# rofi_colors="" # Removed as Wofi handles colors via CSS

function prepare_launcher() {
  if [[ "$1" == "rofi" ]]; then # <--- CHANGED: Added rofi case
    launcher_exe="rofi"
    launcher_options=(-dmenu -p "Power Profile:" -lines "${menu_nrows}" -theme "$HOME/.config/rofi/power-menu.rasi")
  elif [[ "$1" == "zenity" ]]; then
    launcher_exe="zenity"
    launcher_options=(--list --title="${ZENITY_TITLE}" --text="${ZENITY_TEXT}" \
        "${ZENITY_OPTIONS[@]}")
  fi
}

for l in "${launcher_list[@]}"; do
  if command_exists "${l}" ; then
    prepare_launcher "${l}"
    break
  fi
done

# No launcher available
if [[ -z "${launcher_exe}" ]]; then
  exit 1
fi

launcher=(${launcher_exe} "${launcher_options[@]}")
selection="$(printf '%s\n' "${!menu[@]}" | sort | "${launcher[@]}")"

function ask_confirmation() {
  if [ "${launcher_exe}" == "rofi" ]; then # <--- CHANGED: Added rofi case for confirmation
    confirmed=$(echo -e "Yes\nNo" | rofi -dmenu -p "${selection}?")
    [ "${confirmed}" == "Yes" ] && confirmed=0
  elif [ "${launcher_exe}" == "zenity" ]; then
    zenity --question --text "Are you sure you want to ${selection,,}?"
    confirmed=$?
  fi

  if [ "${confirmed}" == 0 ]; then
    swaymsg exec "${menu[${selection}]}"
  fi
}

if [[ $? -eq 0 && ! -z ${selection} ]]; then
  if [[ "${enable_confirmation}" = true && \
        ${menu_confirm} =~ (^|[[:space:]])"${selection}"($|[[:space:]]) ]]; then
    ask_confirmation
  else
    swaymsg exec "${menu[${selection}]}"
  fi
fi
