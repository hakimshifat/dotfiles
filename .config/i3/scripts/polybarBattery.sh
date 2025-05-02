#!/bin/sh

TOGGLE_FILE="/tmp/polybar-battery-show-percent"
PID_FILE="/tmp/polybar-battery-combined-udev.pid"

battery_print() {
  AC_PATH="/sys/class/power_supply/AC0"
  BAT0="/sys/class/power_supply/BAT0"
  BAT1="/sys/class/power_supply/BAT1"

  ac=0
  lvl0=0
  lvl1=0
  max0=0
  max1=0

  [ -f "$AC_PATH/online" ] && ac=$(cat "$AC_PATH/online")
  [ -f "$BAT0/energy_now" ] && lvl0=$(cat "$BAT0/energy_now")
  [ -f "$BAT0/energy_full" ] && max0=$(cat "$BAT0/energy_full")
  [ -f "$BAT1/energy_now" ] && lvl1=$(cat "$BAT1/energy_now")
  [ -f "$BAT1/energy_full" ] && max1=$(cat "$BAT1/energy_full")

  lvl=$((lvl0 + lvl1))
  max=$((max0 + max1))
  percent=$((max > 0 ? lvl * 100 / max : 0))

  # Icons
  icon_charging=""
  icon_full=""
  icon_high=""
  icon_medium=""
  icon_low=""
  icon_critical=""

  # Colors
  color_charging="#8ABEB7"
  color_full="#F0C674"
  color_high="#B5BD68"
  color_medium="#F0C674"
  color_low="#DE935F"
  color_critical="#A54242"

  if [ "$ac" -eq 1 ]; then
    icon=$icon_charging
    color=$color_charging
  elif [ "$percent" -gt 85 ]; then
    icon=$icon_full
    color=$color_full
  elif [ "$percent" -gt 60 ]; then
    icon=$icon_high
    color=$color_high
  elif [ "$percent" -gt 35 ]; then
    icon=$icon_medium
    color=$color_medium
  elif [ "$percent" -gt 10 ]; then
    icon=$icon_low
    color=$color_low
  else
    icon=$icon_critical
    color=$color_critical
  fi

  # Toggle logic
  show_percent="true"
  [ -f "$TOGGLE_FILE" ] && show_percent=$(cat "$TOGGLE_FILE")

  if [ "$show_percent" = "true" ]; then
    echo "%{F$color}$icon $percent%%{F-}"
  else
    echo "%{F$color}$icon%{F-}"
  fi
}

case "$1" in
--update)
  [ -f "$PID_FILE" ] && pid=$(cat "$PID_FILE")
  [ -n "$pid" ] && kill -10 "$pid"
  ;;
--toggle)
  if [ -f "$TOGGLE_FILE" ]; then
    if grep -q true "$TOGGLE_FILE"; then
      echo false >"$TOGGLE_FILE"
    else
      echo true >"$TOGGLE_FILE"
    fi
  else
    echo true >"$TOGGLE_FILE"
  fi
  [ -f "$PID_FILE" ] && pid=$(cat "$PID_FILE") && kill -10 "$pid"
  ;;
*)
  echo $$ >"$PID_FILE"
  trap exit INT
  trap "battery_print" USR1

  while true; do
    battery_print
    sleep 30 &
    wait
  done
  ;;
esac
