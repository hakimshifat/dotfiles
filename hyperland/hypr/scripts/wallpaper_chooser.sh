#!/bin/bash
WALLPAPER_DIR="$HOME/Pictures/wall/"

choice=$(ls "$WALLPAPER_DIR" | wofi --show dmenu --prompt "Choose wallpaper:")

[ -n "$choice" ] && swww img "$WALLPAPER_DIR/$choice"
