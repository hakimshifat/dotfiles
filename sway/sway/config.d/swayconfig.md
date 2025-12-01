# Custom windowing rules
for_window [class="Yad" instance="yad"] floating enable
for_window [app_id="yad"] floating enable
for_window [app_id="blueman-manager"] floating enable,  resize set width 40 ppt height 30 ppt
for_window [app_id="pavucontrol" ] floating enable, resize set width 40 ppt height 30 ppt
for_window [window_role="pop-up"] floating enable
for_window [window_role="bubble"] floating enable
for_window [window_role="task_dialog"] floating enable
for_window [window_role="Preferences"] floating enable
for_window [window_type="dialog"] floating enable
for_window [window_type="menu"] floating enable
for_window [window_role="About"] floating enable
for_window [title="File Operation Progress"] floating enable, border pixel 1, sticky enable, resize set width 40 ppt height 30 ppt
for_window [app_id="floating_shell_portrait"] floating enable, border pixel 1, sticky enable, resize set width 30 ppt height 40 ppt
for_window [title="Picture in picture"] floating enable, sticky enable
for_window [title="waybar_htop"] floating enable, resize set width 70 ppt height 70 ppt
for_window [title="waybar_nmtui"] floating enable
for_window [title="Save File"] floating enable
for_window [app_id="firefox" title="Firefox — Sharing Indicator"] kill

# Inhibit idle
for_window [app_id="firefox"] inhibit_idle fullscreen
for_window [app_id="Chromium"] inhibit_idle fullscreen
for_window [title=".*Picture-in-Picture.*"] sticky enable, floating enable
for_window [app_id=".*"] inhibit_idle fullscreen
for_window [class="emu8086.exe"] floating enable
for_window [app_id="com.usebottles.bottles"] floating enable
for_window [title="^emu8086"] floating enable
for_window [title="blueberry.py"] floating enable
for_window [class="zoom"] floating enable



# Auth with polkit-gnome:
exec /usr/lib/polkit-gnome/polkit-gnome-authentication-agent-1

# Import environment variables for user systemd service manager
exec systemctl --user import-environment DISPLAY WAYLAND_DISPLAY SWAYSOCK

# Update dbus environments with display variables
exec hash dbus-update-activation-environment 2>/dev/null && \
     dbus-update-activation-environment --systemd DISPLAY WAYLAND_DISPLAY SWAYSOCK

# Idle configuration
exec swayidle idlehint 1
exec_always swayidle -w before-sleep "gtklock -d"

# Desktop notifications
exec mako

# Start foot server
exec_always --no-startup-id foot --server

# Autotiling
exec autotiling

# cliphist
exec wl-paste --type text --watch cliphist store
exec wl-paste --type image --watch cliphist store
     
# Network Applet
# exec nm-applet --indicator

# Firewall Applet
exec sleep 2 && firewall-applet

# Welcome App
# exec eos-welcome --startdelay=3

# Sway Fader
# exec python3 ~/.config/sway/scripts/swayfader.py

# nwg-drawer
exec_always nwg-drawer -r -c 7 -is 90 -mb 10 -ml 50 -mr 50 -mt 10

exec swww-daemon
exec swww img ~/Pictures/wall/858077.jpg --transition-fps 60 --transition-type outer --transition-duration 0.8

# Logo key. Use Mod1 for Alt.
set $mod Mod1

# Add Vim key support
set $left h
set $down j
set $up k
set $right l

# Set default terminal emulator
set $term footclient

# Application launcher
set $launcher fuzzel

# Application menu
# set $menu nwg-drawer

# Power Menu
focus_follows_mouse yes


### Key bindings
#
# Basics:
#
    # Launch the terminal
    bindsym $mod+Return exec $term

    # Open the power menu
    bindsym $mod+Shift+e exec $powermenu

    # Kill focused window
    bindsym $mod+q kill

    # Start your launcher
    bindsym $mod+space exec $launcher

    # Lock screen
    bindsym SUPER+L exec pamixer --toggle-mute && gtklock -d

    # Move windows by holding down $mod and left mouse button.
    # Resize them with right mouse button + $mod.
    # Change "normal" to "inverse" to switch left and right
    floating_modifier $mod normal

    # Reload the configuration file
    bindsym $mod+Shift+r reload
    bindsym $mod+w exec '$HOME/.config/sway/scripts/WallpaperSelect.sh'

#
# Moving around:
#
    bindsym {
        # Change window focus
        $mod+Left focus left
        $mod+Down focus down
        $mod+Up focus up
        $mod+Right focus right
        # Vim key support
        $mod+$left focus left
        $mod+$down focus down
        $mod+$up focus up
        $mod+$right focus right

        # Move the focused window
        $mod+Shift+Left move left
        $mod+Shift+Down move down
        $mod+Shift+Up move up
        $mod+Shift+Right move right
        # Vim key support
        $mod+Shift+$left move left
        $mod+Shift+$down move down
        $mod+Shift+$up move up
        $mod+Shift+$right move right
    }

#
# Workspaces:
#
    # Workspace bindings are using bindcode instead of bindsym for better Azerty compatibility.
    # https://github.com/EndeavourOS-Community-Editions/sway/pull/81
    # Use wev to find keycodes for setting up other bindings this way.

    bindsym $mod+Tab workspace next
    bindsym $mod+Shift+Tab workspace prev

    bindcode {
        # Switch to workspace
        $mod+10 workspace number 1
        $mod+11 workspace number 2
        $mod+12 workspace number 3
        $mod+13 workspace number 4
        $mod+14 workspace number 5
        $mod+15 workspace number 6
        $mod+16 workspace number 7
        $mod+17 workspace number 8
        $mod+18 workspace number 9
        $mod+19 workspace number 10

        # Move focused container to workspace
        $mod+Shift+10 move container to workspace number 1
        $mod+Shift+11 move container to workspace number 2
        $mod+Shift+12 move container to workspace number 3
        $mod+Shift+13 move container to workspace number 4
        $mod+Shift+14 move container to workspace number 5
        $mod+Shift+15 move container to workspace number 6
        $mod+Shift+16 move container to workspace number 7
        $mod+Shift+17 move container to workspace number 8
        $mod+Shift+18 move container to workspace number 9
        $mod+Shift+19 move container to workspace number 10
    }
    # Note: workspaces can have any name you want, not just numbers.
    # We just use 1-10 as the default.

#
# Layout stuff:
#
    # Set how the current window will be split
    # Split the window vertically
    # bindsym $mod+v splitv
    # # Split the window horizontally
    # bindsym $mod+b splith

    # Switch the current container between different layout styles
    # bindsym $mod+s layout stacking
    # bindsym $mod+w layout tabbed
    # bindsym $mod+e layout toggle split

    # Make the current focus fullscreen
    bindsym $mod+f fullscreen

    # Toggle between tiling and floating mode
    bindsym $mod+Shift+space floating toggle

    # Swap focus between the tiling area and the floating area
    # bindsym $mod+space focus mode_toggle

    # Move focus to the parent container
    # bindsym $mod+a focus parent

#
# Scratchpad:
#
    # Sway has a "scratchpad", which is a bag of holding for windows.
    # You can send windows there and get them back later.

    # Move the currently focused window to the scratchpad
    bindsym $mod+Shift+minus move scratchpad

    # Show the next scratchpad window or hide the focused scratchpad window.
    # If there are multiple scratchpad windows, this command cycles through them.
    bindsym $mod+minus scratchpad show

#
# Resizing containers:
#
    bindsym {
        # Resize with arrow keys
        $mod+ctrl+Right resize shrink width 10 px
        $mod+ctrl+Up resize grow height 10 px
        $mod+ctrl+Down resize shrink height 10 px
        $mod+ctrl+Left resize grow width 10 px
        # Resize with Vim keys
        $mod+ctrl+$right resize shrink width 10 px
        $mod+ctrl+$up resize grow height 10 px
        $mod+ctrl+$down resize shrink height 10 px
        $mod+ctrl+$left resize grow width 10 px
    }

    # Resize floating windows with mouse scroll:
    bindsym --whole-window --border {
        # Resize vertically
        $mod+button4 resize shrink height 5 px or 5 ppt
        $mod+button5 resize grow height 5 px or 5 ppt
        # Resize horizontally
        $mod+Shift+button4 resize shrink width 5 px or 5 ppt
        $mod+Shift+button5 resize grow width 5 px or 5 ppt
    }

#
# Media Keys
#
    bindsym {
        # Volume
        XF86AudioRaiseVolume exec pamixer -ui 2
        XF86AudioLowerVolume exec pamixer -ud 2
        XF86AudioMute exec pamixer --toggle-mute

        # Player
        XF86AudioPlay exec playerctl play-pause
        XF86AudioNext exec playerctl next
        XF86AudioPrev exec playerctl previous

        # Backlight
        XF86MonBrightnessUp exec brightnessctl -c backlight set +1%
        XF86MonBrightnessDown exec brightnessctl -c backlight set 1%-
    }

#
# App shortcuts
#
    # Launch the file explorer
    bindsym $mod+n exec thunar
    bindsym SUPER+Escape exec wlogout

    bindsym $mod+m exec 'pamixer --default-source -t && if [ "$(pamixer --default-source --get-mute)" = true ]; then notify-send "Microphone: Muted" -i mic-off -h string:x-canonical-private-synchronous:mic; else notify-send "Microphone: On" -i mic-on -h string:x-canonical-private-synchronous:mic; fi'


    # Launch the browser
    # bindsym $mod+o exec firefox

    # Launch the clipboard manager
    bindsym $mod+Ctrl+v exec cliphist list | fuzzel -d -w 90 -l 30 -p "Select an entry to copy it to your clipboard buffer:"| cliphist decode | wl-copy
    # Delete an entry from the clipboard manager
    bindsym $mod+Ctrl+x exec cliphist list | fuzzel -d -w 90 -l 30 -t cc9393ff -S cc9393ff -p "Select an entry to delete it from cliphist:"| cliphist delete
    # Note: you can clear all cliphist entries by running `cliphist wipe`

#
# Screenshots
#
set $shot_dir /home/sifat/Pictures/
set $ts $(date +'%Y-%m-%d_%H-%M-%S')

# Print = full screen: save + copy + notify
bindsym --release Print exec grim "$shot_dir/screenshot_$ts.png" # && notify-send "Screenshot captured"
# Ctrl+Print = region select: save + copy + notify
bindsym --release Ctrl+Print exec grim -g "$(slurp)" "$shot_dir/screenshot_$ts.png" && wl-copy < "$shot_dir/screenshot_$ts.png" && notify-send "ScreenCUT captured"

bindsym Shift+Print exec '~/.config/sway/scripts/screenshot_window.sh'
### Input configuration
#
# Read `man 5 sway-input` for more information about this section.

# Touchpad configuration
input type:touchpad {
    drag_lock disabled
    dwt enabled
    tap enabled
    # natural_scroll enabled
}
bindgesture swipe:right workspace prev
bindgesture swipe:left workspace next


# Enable numlock by default
input type:keyboard xkb_numlock enabled

# Set keyboard layout and variant based on current system settings
exec_always {
    'swaymsg input type:keyboard xkb_layout "$(localectl status | grep "X11 Layout" | sed -e "s/^.*X11 Layout://")"'
    'swaymsg input type:keyboard xkb_variant "$(localectl status | grep "X11 Variant" | sed -e "s/^.*X11 Variant://")"'
}

# # Toggle between keyboard layouts. This example has the "us" and "gb"
# # keyboard layouts, and uses Alt+Shift to toggle between them.
# input "type:keyboard" {
#     xkb_layout "us,gb"
#     xkb_options "grp:alt_shift_toggle"
# }
# # Assign the same binding to "pkill -RTMIN+1 waybar" to send signal to
# # the Waybar keyboard module (so the module shows the updated layout).
# # This example uses Alt + left Shift.
# bindsym Alt+Shift_L exec "pkill -RTMIN+1 waybar"
### Output configuration
#
# Example configuration:
#
#   output HDMI-A-1 resolution 1920x1080 position 1920,0
#
# You can get the names of your outputs by running: swaymsg -t get_outputs
#
# You can also bind workspaces 1,2,3 to specific outputs
#
# workspace 1 output eDP-2
# workspace 2 output HDMI-A-1
# workspace 3 output DP-1
#
# Wacom Tablet - Example
#   input "1386:884:Wacom_Intuos_S_Pad" map_to_output HDMI-A-1
#   input "1386:884:Wacom_Intuos_S_Pen" map_to_output HDMI-A-1
# Apply gtk theming
exec_always ~/.config/sway/scripts/import-gsettings

# Set inner/outer gaps
gaps inner 4
gaps outer 4

# Hide titlebar on windows:
default_border pixel 1

# Default Font
font pango:Noto Sans Regular 10

# Thin borders:
smart_borders on

# Set wallpaper:
# exec ~/.azotebg

# Title format for windows
for_window [shell="xdg_shell"] title_format "%title (%app_id)"
for_window [shell="x_wayland"] title_format "%class - %title"

# class                 border  bground text    indicator child_border
client.focused          #6272A4 #6272A4 #F8F8F2 #6272A4   #6272A4
client.focused_inactive #44475A #44475A #F8F8F2 #44475A   #44475A
client.unfocused        #282A36 #282A36 #BFBFBF #282A36   #282A36
client.urgent           #44475A #FF5555 #F8F8F2 #FF5555   #FF5555
client.placeholder      #282A36 #282A36 #F8F8F2 #282A36   #282A36
client.background       #F8F8F2

#
# Status Bar:
#
# Read `man 5 sway-bar` for more information about this section.
bar {
    id mybar
    swaybar_command waybar
}
bindsym Ctrl+Escape exec pkill -USR1 waybar
