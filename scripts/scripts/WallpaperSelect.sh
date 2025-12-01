#!/bin/bash

export WAYLAND_DISPLAY=wayland-1
export XDG_RUNTIME_DIR=/run/user/1000
export PATH="${PATH}:${HOME}/.local/bin/"

# swww init

# if [ -e "${HOME}/.cache/wal/colors" ]; then
#     wal -R --cols16

    # echo "Cached colors exist. Using existing colors."
# else
    DIR=$HOME/Pictures/wall/
    RANDOMPICS=$(find "${DIR}" -type f | shuf -n 1)

    swww img "${RANDOMPICS}" --transition-type grow --transition-fps 60 --transition-duration 1.0 --transition-pos 0.810,0.972 --transition-bezier 0.65,0,0.35,1 --transition-step 255
    # wal -i "${RANDOMPICS}" #--cols16
    # killall -SIGUSR2 waybar

    # echo "Successfully set a new wallpaper and generated colors from it."
# fi

# pywalfox update
# pywal-discord -t default
# wal-telegram --wal

# . $HOME/.config/mako/update-colors.sh
# . $HOME/.config/spicetify/Themes/Pywal/update-colors.sh
# . $HOME/.config/cava/scripts/update-colors.sh