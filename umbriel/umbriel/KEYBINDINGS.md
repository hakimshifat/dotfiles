# Umbriel trial setup

Log out, select Umbriel in SDDM's session selector, and log in. Select Niri to return.
Umbriel is a Terra nightly build; Niri and Plasma are still installed.

The modifier is Alt, matching your native Niri session. Noctalia starts automatically.
Intel HD 620 rendering was confirmed in a nested test. Native login, portals,
lock/unlock, and suspend still need testing in the full session.

## Differences from Niri

- Alt+Ctrl+C centers the focused column; Umbriel has no center-visible-columns action.
- Alt+Ctrl+F toggles full column width, the nearest equivalent of expand-to-available-width.
- Shift+Print opens Noctalia's screenshot annotator instead of Niri's built-in picker.
- Super+B launches Brave because Firefox is absent. Alt+B also launches Brave as before.
- At least nine dynamic workspaces are retained on eDP-1 so Alt+1–9 works immediately.
- Alt+Shift+Escape opens Umbriel's shortcut cheatsheet.
- Ctrl+Alt+Delete requests logout with confirmation.

GNOME Keyring remains the Secret portal backend for consistent browser secure storage.
The repository /etc/yum.repos.d/umbriel-terra.repo is restricted to Umbriel and its portal.

## Shortcuts

| Shortcut | Umbriel action |
| --- | --- |
| Mod+Shift+Escape | `cheatsheet-toggle` |
| Mod+Return | `spawn konsole` |
| Mod+Space | `spawn noctalia msg panel-toggle launcher` |
| Super+B | `spawn brave-origin` |
| Alt+B | `spawn brave-origin` |
| Super+L | `spawn noctalia msg session lock` |
| Alt+w | `spawn noctalia msg wallpaper-random` |
| Alt+n | `spawn noctalia msg panel-toggle noctalia/notes:panel` |
| Super+Escape | `spawn noctalia msg panel-toggle session` |
| Super+E | `spawn nautilus --new-window` |
| XF86AudioRaiseVolume | `spawn noctalia msg volume-up` |
| XF86AudioLowerVolume | `spawn noctalia msg volume-down` |
| XF86AudioMute | `spawn noctalia msg volume-mute` |
| XF86AudioNext | `spawn noctalia msg media next` |
| XF86AudioPrev | `spawn noctalia msg media previous` |
| XF86AudioPlay | `spawn noctalia msg media toggle` |
| XF86AudioPause | `spawn noctalia msg media toggle` |
| Alt+m | `spawn noctalia msg mic-mute` |
| Super+m | `spawn noctalia msg volume-mute` |
| Super+v | `spawn noctalia msg panel-toggle clipboard` |
| XF86MonBrightnessUp | `spawn noctalia msg brightness-up` |
| XF86MonBrightnessDown | `spawn noctalia msg brightness-down` |
| Mod+Q | `window-close` |
| Mod+Left | `window-focus-left` |
| Mod+H | `window-focus-left` |
| Mod+Right | `window-focus-right` |
| Mod+L | `window-focus-right` |
| Mod+Up | `window-focus-up` |
| Mod+K | `window-focus-up` |
| Mod+Down | `window-focus-down` |
| Mod+J | `window-focus-down` |
| Mod+Shift+Left | `column-move-left` |
| Mod+Shift+Right | `column-move-right` |
| Mod+Shift+Up | `window-move-up` |
| Mod+Shift+H | `column-move-left` |
| Mod+Shift+J | `window-move-down` |
| Mod+Shift+K | `window-move-up` |
| Mod+Shift+L | `column-move-right` |
| Alt+Ctrl+Left | `window-modify-primary-extent -0.1` |
| Alt+Ctrl+Right | `window-modify-primary-extent 0.1` |
| Alt+Ctrl+Down | `window-modify-secondary-extent 0.1` |
| Alt+Ctrl+Up | `window-modify-secondary-extent -0.1` |
| Mod+WheelDown | `workspace-next` |
| Mod+WheelUp | `workspace-previous` |
| Mod+Ctrl+WheelDown | `column-move-to-workspace-next` |
| Mod+Ctrl+WheelUp | `column-move-to-workspace-previous` |
| Mod+WheelRight | `window-focus-right` |
| Mod+WheelLeft | `window-focus-left` |
| Mod+Ctrl+WheelRight | `column-move-right` |
| Mod+Ctrl+WheelLeft | `column-move-left` |
| Mod+Shift+WheelDown | `window-focus-right` |
| Mod+Shift+WheelUp | `window-focus-left` |
| Mod+Ctrl+Shift+WheelDown | `column-move-right` |
| Mod+Ctrl+Shift+WheelUp | `column-move-left` |
| Mod+1 | `workspace-switch 1` |
| Mod+2 | `workspace-switch 2` |
| Mod+3 | `workspace-switch 3` |
| Mod+4 | `workspace-switch 4` |
| Mod+5 | `workspace-switch 5` |
| Mod+6 | `workspace-switch 6` |
| Mod+7 | `workspace-switch 7` |
| Mod+8 | `workspace-switch 8` |
| Mod+9 | `workspace-switch 9` |
| Mod+Ctrl+1 | `column-move-to-workspace 1` |
| Mod+Ctrl+2 | `column-move-to-workspace 2` |
| Mod+Ctrl+3 | `column-move-to-workspace 3` |
| Mod+Ctrl+4 | `column-move-to-workspace 4` |
| Mod+Ctrl+5 | `column-move-to-workspace 5` |
| Mod+Ctrl+6 | `column-move-to-workspace 6` |
| Mod+Ctrl+7 | `column-move-to-workspace 7` |
| Mod+Ctrl+8 | `column-move-to-workspace 8` |
| Mod+Ctrl+9 | `column-move-to-workspace 9` |
| Mod+Tab | `workspace-focus-last` |
| Mod+Ctrl+F | `window-toggle-maximize` |
| Mod+C | `column-center` |
| Mod+Ctrl+C | `column-center` |
| Mod+Minus | `window-modify-primary-extent -0.1` |
| Mod+Equal | `window-modify-primary-extent 0.1` |
| Mod+Shift+Minus | `window-modify-secondary-extent -0.1` |
| Mod+Shift+Equal | `window-modify-secondary-extent 0.1` |
| Mod+T | `window-toggle-floating` |
| Mod+F | `window-toggle-fullscreen` |
| Mod+Shift+W | `column-toggle-tabbed` |
| Print | `spawn noctalia msg screenshot-annotate --copy-to-clipboard --close-on-copy` |
| Shift+Print | `spawn noctalia msg screenshot-annotate` |
| Super+Space | `spawn noctalia msg panel-toggle aabidk20/yt-music:panel` |
| Ctrl+Alt+Delete | `session-quit` |
| Mod+Shift+P | `dpms-off` |
| Super+Tab | `overview-toggle` |
