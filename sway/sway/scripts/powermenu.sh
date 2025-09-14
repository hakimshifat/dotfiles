#!/usr/bin/env bash

## Author  : Aditya Shakya (Modified for Sway by Sifat and chatgpt)
## Adapted for Sway WM

dir="$HOME/.config/rofi"
uptime=$(uptime -p | sed -e 's/up //g')

rofi_command="rofi -no-config -theme $dir/config.rasi"

# Options
shutdown=" Shutdown"
reboot=" Restart"
lock=" Lock"
suspend=" Sleep"
logout=" Logout"

# Variable passed to rofi
options="$lock\n$suspend\n$logout\n$reboot\n$shutdown"

chosen="$(echo -e "$options" | $rofi_command -p "Uptime: $uptime" -dmenu -selected-row 0)"

# Exit cleanly if nothing is chosen (Escape or close)
[ -z "$chosen" ] && exit 0

case $chosen in
$shutdown)
  systemctl poweroff
  ;;
$reboot)
  systemctl reboot
  ;;
$lock)
  if command -v swaylock >/dev/null 2>&1; then
    swaylock --clock --indicator -C "$HOME/.config/swaylock/themes/mocha.conf" -i "$HOME/Pictures/wall/lockscreen.png"
  else
    echo "swaylock not found!"
  fi
  ;;
$suspend)
  if command -v mpc >/dev/null 2>&1; then
    mpc -q pause 2>/dev/null
  fi
  if command -v amixer >/dev/null 2>&1; then
    amixer set Master mute
  fi
  systemctl suspend
  ;;
$logout)
  swaymsg exit
  ;;
esac
