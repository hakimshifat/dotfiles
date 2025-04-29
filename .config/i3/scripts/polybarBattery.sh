#!/bin/sh

battery_print() {
  PATH_AC="/sys/class/power_supply/AC0"
  PATH_BATTERY_0="/sys/class/power_supply/BAT0"
  PATH_BATTERY_1="/sys/class/power_supply/BAT1"

  ac=0
  battery_level_0=0
  battery_level_1=0
  battery_max_0=0
  battery_max_1=0

  [ -f "$PATH_AC/online" ] && ac=$(cat "$PATH_AC/online")

  [ -f "$PATH_BATTERY_0/energy_now" ] && battery_level_0=$(cat "$PATH_BATTERY_0/energy_now")
  [ -f "$PATH_BATTERY_0/energy_full" ] && battery_max_0=$(cat "$PATH_BATTERY_0/energy_full")

  [ -f "$PATH_BATTERY_1/energy_now" ] && battery_level_1=$(cat "$PATH_BATTERY_1/energy_now")
  [ -f "$PATH_BATTERY_1/energy_full" ] && battery_max_1=$(cat "$PATH_BATTERY_1/energy_full")

  battery_level=$((battery_level_0 + battery_level_1))
  battery_max=$((battery_max_0 + battery_max_1))

  if [ "$battery_max" -eq 0 ]; then
    battery_percent=0
  else
    battery_percent=$((battery_level * 100 / battery_max))
  fi

  # Icons for different battery levels
  icon_charging="" # Charging
  icon_full=""     # 86-100%
  icon_high=""     # 61-85%
  icon_medium=""   # 36-60%
  icon_low=""      # 11-35%
  icon_critical="" # 0-10%

  # Colors
  color_charging="#8ABEB7" # cyan
  color_full="#F0C674"     # yellow
  color_high="#B5BD68"     # green
  color_medium="#F0C674"   # yellow
  color_low="#DE935F"      # orange
  color_critical="#A54242" # red

  if [ "$ac" -eq 1 ]; then
    icon="$icon_charging"
    color="$color_charging"
  elif [ "$battery_percent" -gt 85 ]; then
    icon="$icon_full"
    color="$color_full"
  elif [ "$battery_percent" -gt 60 ]; then
    icon="$icon_high"
    color="$color_high"
  elif [ "$battery_percent" -gt 35 ]; then
    icon="$icon_medium"
    color="$color_medium"
  elif [ "$battery_percent" -gt 10 ]; then
    icon="$icon_low"
    color="$color_low"
  else
    icon="$icon_critical"
    color="$color_critical"
  fi

  echo "%{F$color}$icon $battery_percent%%{F-}"
}

path_pid="/tmp/polybar-battery-combined-udev.pid"

case "$1" in
--update)
  [ -f "$path_pid" ] && pid=$(cat "$path_pid")
  [ -n "$pid" ] && kill -10 "$pid"
  ;;
*)
  echo $$ >"$path_pid"
  trap exit INT
  trap "echo" USR1

  while true; do
    battery_print
    sleep 30 &
    wait
  done
  ;;
esac
