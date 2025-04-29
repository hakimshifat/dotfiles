#!/usr/bin/env bash
set -euo pipefail
IFS=$'\n\t'

print_usage() {
  cat <<EOF
Usage: $0 [options]
  -u, --update           Trigger an update signal (SIGUSR1)
  -i, --interval SEC     Polling interval in seconds (default: 30)
  -l, --low-threshold N  Low battery threshold (default: 15)
  -c, --crit-threshold N Critical battery threshold (default: 5)
EOF
}

# Default values
INTERVAL=30
LOW_THRESHOLD=15
CRIT_THRESHOLD=5
POLL=true
PIDFILE="/tmp/polybar-battery.pid"

# Icons and colors
declare -A ICONS=(
  [charging]=""
  [full]=""
  [high]=""
  [medium]=""
  [low]=""
  [critical]=""
)
declare -A COLORS=(
  [charging]="#8ABEB7"
  [full]="#F0C674"
  [high]="#B5BD68"
  [medium]="#F0C674"
  [low]="#DE935F"
  [critical]="#A54242"
)

# Parse options
SHORT=u,i:,l:,c:
LONG=update,interval:,low-threshold:,crit-threshold:
OPTS=$(getopt -o $SHORT --long $LONG -n "$0" -- "$@")
eval set -- "$OPTS"
while true; do
  case "$1" in
  -u | --update)
    POLL=false
    kill -USR1 "$(cat "$PIDFILE")"
    shift
    ;;
  -i | --interval)
    INTERVAL="$2"
    shift 2
    ;;
  -l | --low-threshold)
    LOW_THRESHOLD="$2"
    shift 2
    ;;
  -c | --crit-threshold)
    CRIT_THRESHOLD="$2"
    shift 2
    ;;
  --)
    shift
    break
    ;;
  esac
done

get_adapter_status() {
  for ADAPTER in /sys/class/power_supply/AC* /sys/class/power_supply/ADP*; do
    [ -f "$ADAPTER/online" ] && cat "$ADAPTER/online" && return
  done
  echo 0
}

get_battery_capacity() {
  local total=0 count=0
  for BAT in /sys/class/power_supply/BAT*; do
    if [ -f "$BAT/capacity" ]; then
      total=$((total + $(<"$BAT/capacity")))
      count=$((count + 1))
    else
      # fallback to energy or charge
      local now full
      now=$(cat "$BAT"/{energy_now,charge_now} 2>/dev/null | head -n1)
      full=$(cat "$BAT"/{energy_full,charge_full} 2>/dev/null | head -n1)
      ((total += now * 100 / full))
      ((count++))
    fi
  done
  echo $((total / (count > 0 ? count : 1)))
}

battery_print() {
  local ac pct icon color
  ac=$(get_adapter_status)
  pct=$(get_battery_capacity)

  if [ "$ac" -eq 1 ]; then
    icon=${ICONS[charging]}
    color=${COLORS[charging]}
  elif ((pct >= 86)); then
    icon=${ICONS[full]}
    color=${COLORS[full]}
  elif ((pct >= 61)); then
    icon=${ICONS[high]}
    color=${COLORS[high]}
  elif ((pct >= 36)); then
    icon=${ICONS[medium]}
    color=${COLORS[medium]}
  elif ((pct >= LOW_THRESHOLD)); then
    icon=${ICONS[low]}
    color=${COLORS[low]}
  else
    icon=${ICONS[critical]}
    color=${COLORS[critical]}
    # notifications
    if ((pct <= CRIT_THRESHOLD)); then
      notify-send -u critical "Battery critically low" "${pct}% remaining"
    elif ((pct <= LOW_THRESHOLD)); then
      notify-send -u normal "Battery low" "${pct}% remaining"
    fi
  fi

  printf "%%{F%s}%s %s%%{F-}\n" "$color" "$icon" "$pct"
}

case "${1:-}" in
--update)
  [ -f "$PIDFILE" ] && kill -USR1 "$(cat "$PIDFILE")"
  ;;
*)
  echo $$ >"$PIDFILE"
  trap exit INT
  trap battery_print USR1
  while $POLL; do
    battery_print
    sleep "$INTERVAL"
  done
  ;;
esac
