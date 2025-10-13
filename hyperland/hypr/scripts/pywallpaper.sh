#!/usr/bin/env bash
# pywallpaper.sh — images & GIFs only, rofi menu + pywal + swww + waybar integration
set -euo pipefail
IFS=$'\n\t'

# ------------------ User config ------------------
WALLDIR="${HOME}/Pictures/wall"
CACHE_DIR="${HOME}/.cache/pywallpaper"
CACHE_GIF="${CACHE_DIR}/gif_preview"
WAL_CACHE="${HOME}/.cache/wal"

ROFI_DEFAULT_THEME="${HOME}/.config/rofi/config-wallpaper.rasi"
KITTY_TARGET="${HOME}/.config/kitty/wal.conf"

# Waybar config: the style file Waybar uses.
# Option 1 (recommended): use a symlink from ~/.config/waybar/style.css -> ${WAL_CACHE}/colors.css
# Option 2: copy from ${WAL_CACHE}/colors.css to WAYBAR_STYLE_TARGET (this script uses copy by default)
WAYBAR_STYLE_TARGET="${HOME}/.config/waybar/style.css"

ICON_DIR="${HOME}/.local/share/icons"

# swww params
FPS=60
TYPE="any"
DURATION=1
BEZIER=".43,1.19,1,.4"
SWWW_PARAMS=( --transition-fps "$FPS" --transition-type "$TYPE" --transition-duration "$DURATION" --transition-bezier "$BEZIER" )

# ------------------ Setup ------------------
mkdir -p "$CACHE_GIF" "$CACHE_DIR" "$(dirname "$KITTY_TARGET")" "$(dirname "$WAYBAR_STYLE_TARGET")"

# ------------------ Dependencies (no ffmpeg) ------------------
deps=(rofi jq swww wal magick notify-send pkill)
missing=()
for d in "${deps[@]}"; do
  if ! command -v "$d" &>/dev/null; then
    missing+=("$d")
  fi
done
if ((${#missing[@]})); then
  notify-send -i "${ICON_DIR}/error.png" "pywallpaper: missing deps" "Install: ${missing[*]}"
  echo "Missing dependencies: ${missing[*]}" >&2
  exit 1
fi

# ------------------ Helpers ------------------
log() { printf '%s\n' "$*"; }
err() { printf 'ERR: %s\n' "$*" >&2; }

# focused monitor
focused_monitor=$(hyprctl monitors -j | jq -r '.[] | select(.focused) | .name' || true)
if [[ -z "$focused_monitor" ]]; then
  notify-send -i "${ICON_DIR}/error.png" "pywallpaper" "Could not detect focused monitor (hyprctl)"; exit 1
fi

# gather only images + gifs
mapfile -d '' ALLFILES < <(find -L "$WALLDIR" -type f \( \
  -iname '*.jpg' -o -iname '*.jpeg' -o -iname '*.png' -o -iname '*.gif' -o \
  -iname '*.bmp' -o -iname '*.tiff' -o -iname '*.webp' \) -print0)

if (( ${#ALLFILES[@]} == 0 )); then
  notify-send -i "${ICON_DIR}/error.png" "pywallpaper" "No image/gif files found in: $WALLDIR"
  exit 1
fi

# create thumbnail/preview for rofi
create_preview() {
  local src="$1"
  local dst="$2"
  [[ -f "$dst" ]] && return 0

  case "${src##*.}" in
    gif|GIF)
      magick "$src[0]" -strip -resize 600x400\> "$dst" 2>/dev/null || cp "$src" "$dst"
      ;;
    *)
      magick "$src" -strip -resize 600x400\> "$dst" 2>/dev/null || cp "$src" "$dst"
      ;;
  esac
}

# extract frame for wal (large, 1920 width)
extract_frame_for_wal() {
  local src="$1"
  local dst="$2"
  [[ -f "$dst" ]] && return 0

  case "${src##*.}" in
    gif|GIF)
      magick "$src[0]" -strip -resize 1920x1080\> "$dst" 2>/dev/null || cp "$src" "$dst"
      ;;
    *)
      cp -f "$src" "$dst"
      ;;
  esac
}

apply_wallpaper() {
  local img="$1"
  if ! pgrep -x "swww-daemon" >/dev/null 2>&1; then
    swww-daemon --format xrgb &>/dev/null || true
    sleep 0.10
  fi
  swww img -o "$focused_monitor" "$img" "${SWWW_PARAMS[@]}"
}

apply_wal_and_reload() {
  local wal_input="$1"
  wal -q -i "$wal_input"

  # kitty
  local kitty_gen="${WAL_CACHE}/colors-kitty.conf"
  if [[ -f "$kitty_gen" ]]; then
    cp -f "$kitty_gen" "$KITTY_TARGET"
    if pgrep -x kitty >/dev/null 2>&1; then
      pkill -USR1 kitty || true
    fi
  fi

  # waybar: copy wal css and send SIGUSR2 to reload (graceful)
  local wal_css="${WAL_CACHE}/colors.css"
  if [[ -f "$wal_css" ]]; then
    cp -f "$wal_css" "$WAYBAR_STYLE_TARGET" || err "Failed to copy wal css -> $WAYBAR_STYLE_TARGET"
    if pgrep -x waybar >/dev/null 2>&1; then
      pkill -SIGUSR2 waybar || true
      # small delay for visual update
      sleep 0.12
    fi
  fi
}

# ------------------ Build rofi input ------------------
ROFI_TMP="$(mktemp)"
{
  printf "%s\x00icon\x1f%s\n" "Random" ""
  for f in $(printf "%s\n" "${ALLFILES[@]}" | sort -u); do
    name="$(basename "$f")"
    preview="${CACHE_DIR}/${name}.png"
    create_preview "$f" "$preview" &
    printf "%s\x00icon\x1f%s\n" "${name%.*}" "$preview"
  done
  wait
} > "$ROFI_TMP"

# icon size heuristic
monitor_height=$(hyprctl monitors -j | jq -r --arg mon "$focused_monitor" '.[] | select(.name == $mon) | .height')
scale_factor=$(hyprctl monitors -j | jq -r --arg mon "$focused_monitor" '.[] | select(.name == $mon) | .scale')
icon_size_calc=$(echo "scale=2; ($monitor_height * 3) / ($scale_factor * 150)" | bc)
icon_size=$(awk "BEGIN{ if($icon_size_calc < 15) print 20; else if($icon_size_calc > 28) print 28; else print $icon_size_calc }")
rofi_override="element-icon{size:${icon_size}%;}"

ROFI_THEME_USE="${ROFI_DEFAULT_THEME}"
[[ -f "${WAL_CACHE}/colors-rofi.rasi" ]] && ROFI_THEME_USE="${WAL_CACHE}/colors-rofi.rasi"

chosen="$(cat "$ROFI_TMP" | rofi -i -show -dmenu -config "$ROFI_THEME_USE" -theme-str "$rofi_override" -no-custom -selected-row 0 -p "Wallpaper:")" || true
rm -f "$ROFI_TMP"
if [[ -z "${chosen:-}" ]]; then exit 0; fi

# resolve selection
if [[ "$chosen" == "Random" ]]; then
  selected="${ALLFILES[RANDOM % ${#ALLFILES[@]}]}"
else
  selected="$(printf "%s\n" "${ALLFILES[@]}" | awk -F/ -v name="$chosen" 'BEGIN{IGNORECASE=1} { if(tolower($NF) ~ tolower(name) ) print $0 }' | head -n1 || true)"
fi

# if [[ -z "${selected:-}" ]]; then
#   notify-send -i "${ICON_DIR}/error.png" "pywallpaper" "Could not find file for: $chosen"
#   exit 1
# fi

# prepare wal input
frame_for_wal="${CACHE_DIR}/$(basename "$selected").wal-frame.png"
extract_frame_for_wal "$selected" "$frame_for_wal"

# apply
apply_wallpaper "$selected"
apply_wal_and_reload "$frame_for_wal"

# notify-send -i "${ICON_DIR}/icon.png" "pywallpaper" "Applied: $(basename "$selected")"
# exit 0

