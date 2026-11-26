<div align="center">

# 🐧 dotfiles

**A minimal, keyboard-driven Linux desktop for a Wayland setup — built around Umbriel and [Niri](https://github.com/YaLTeR/niri), tuned for reverse engineering, CTFs, and competitive programming.**

![WM](https://img.shields.io/badge/WM-Umbriel%20%2F%20Niri-9cccf3?style=for-the-badge)
![Distro](https://img.shields.io/badge/Distro-Fedora-51a2da?style=for-the-badge&logo=fedora)
![Shell](https://img.shields.io/badge/Shell-Zsh%20(zsh4humans)-yellow?style=for-the-badge&logo=gnubash)
![License](https://img.shields.io/badge/License-GPLv3-blue?style=for-the-badge)

</div>

---

## Table of Contents

- [About](#about)
- [Stack](#stack)
- [Repo Structure](#repo-structure)
- [Highlights](#highlights)
  - [Window Manager — Umbriel](#window-manager--umbriel)
  - [Window Manager — Niri](#window-manager--niri)
  - [Desktop Shell — Noctalia](#desktop-shell--noctalia)
  - [Terminal & Shell](#terminal--shell)
  - [Fonts & Environment](#fonts--environment)
  - [File Manager — Yazi](#file-manager--yazi)
  - [Media — mpv](#media--mpv)
  - [Utility Scripts](#utility-scripts)
- [Bangla typing with Avro](#bangla-typing-with-avro)
- [Niri and Umbriel troubleshooting](#niri-and-umbriel-troubleshooting)
- [System Services](#system-services)
- [Installation](#installation)
- [Git Setup](#git-setup)
- [Competitive Programming Environment](#competitive-programming-environment)
- [Legacy Configs](#legacy-configs)
- [License](#license)

---

## About

This repository is my personal Linux configuration — the result of continuously refining a Wayland desktop that stays fast, keyboard-first, and distraction-free. It's the config I actually use every day for coursework, cybersecurity research (CTFs, binary analysis), and daily driving.

It's not a "framework" meant for others to install blindly — it's a living config. Feel free to fork it, steal pieces, or use it as a reference for building your own Umbriel or Niri setup.

> 🪟 **Desktop setup:** [Umbriel](#window-manager--umbriel) and [Niri](#window-manager--niri) are the compositor options, with [**Noctalia**](https://noctalia.dev/) (v5) running the entire desktop shell on top — bar, launcher, notifications, wallpaper, lock screen, and session/control center, all in one. No manual Waybar/Rofi/Mako/wlogout setup is needed day-to-day; the old standalone shell configs have been removed. Sway remains as an optional alternative — see [Legacy Configs](#legacy-configs).

---

## Stack

| Layer | Tool |
|---|---|
| Compositor / WM | Umbriel and [Niri](https://github.com/YaLTeR/niri) *(scrollable tiling)* — with [Sway](https://swaywm.org/) kept as a legacy alternative |
| Desktop Shell | [**Noctalia**](https://noctalia.dev/) v5 *(bar, launcher, notifications, wallpaper, control center, lock & session screens — the whole UI layer)* |
| Terminal | Foot by default, with Konsole and [Kitty](https://sw.kovidgoyal.net/kitty/) configs available |
| Bangla input | IBus Avro Phonetic with a keyboard toggle on Umbriel |
| Shell | Zsh + [zsh4humans](https://github.com/romkatv/zsh4humans) + Powerlevel10k |
| File Manager (TUI) | [Yazi](https://github.com/sxyazi/yazi) |
| File Manager (GUI) | Nautilus |
| Multiplexer | [tmux](https://github.com/tmux/tmux) |
| Media Player | [mpv](https://mpv.io/) *(w/ thumbfast, custom audio visualizer, GIF/seek scripts)* |
| Downloader | [aria2](https://aria2.github.io/) *(RPC daemon mode)* |
| AUR Helper *(legacy Arch setup)* | [paru](https://github.com/Morganamilo/paru) — optional; not used on Fedora |
| Browsers | Firefox, Brave |
| Reverse Engineering | Ghidra (with a custom `ghidra.py` launcher), jadx, IDA |

---

## Repo Structure

```text
.
├── umbriel/             # Compositor config and keybinding reference
├── niri/                # Modular compositor config + Noctalia integration
├── fontconfig/          # Bengali font fallback preferences
├── env/                 # environment.d cursor and session settings
├── konsole/             # Konsole settings
├── konsole-profiles/    # Terminal profiles and color schemes
├── kitty/               # Wayland terminal config
├── tmux/                # tmux.conf
├── yazi/                # TUI file manager config and plugin
├── mpv/                 # Player config, Lua scripts, shaders and fonts
├── zshrc/               # .zshrc, .zshenv and .p10k.zsh
├── sway/                # Legacy alternative compositor
├── zellij/              # Optional terminal multiplexer
├── aria2/               # Download manager RPC config
├── paru/                # Optional AUR helper config from the Arch setup
├── scripts/             # Screenshot, scratchpad, wallpaper, Ghidra and publishing helpers
├── cpbooster-config.json # Competitive programming CLI config
├── crontab.md            # Cron job reference
├── subl.md               # Sublime Text C++ build notes
├── docs.zip              # Documentation archive
├── battery-threshold.service # Optional laptop charging unit
├── deep-sleep.conf           # ASUS X510UQ suspend workaround
├── nvidia-sleep.service       # Optional GPU power management unit
└── LICENSE                   # GPLv3
```

---

## Highlights

### Window Manager — Umbriel

The [Umbriel config](umbriel/umbriel/config.toml) uses Alt as Mod and starts Noctalia. **Alt+Enter** opens Foot, **Alt+Tab** opens the Noctalia window switcher in hold mode, and **Super+E** opens Nautilus. **Alt+Y** toggles the scratchpad. **Alt+Shift+Esc** opens the compositor's shortcut cheatsheet.

### Window Manager — Niri

Niri’s config is modularized under `niri/niri/noctalia/` and pulled together by `niri/niri/config.kdl`:

- `keybinds.kdl` — all keybindings
- `layout.kdl`, `animation.kdl`, `misc.kdl` — behavior & feel
- `input.kdl`, `display.kdl` — hardware config
- `rules.kdl`, `autostart.kdl` — window rules & startup apps

Notable bindings:

| Keybind | Action |
|---|---|
| `Mod + Return` | Open Foot |
| `Super + B` | Firefox |
| `Alt + B` | Brave |
| `Super + E` | Open Nautilus with `GSK_RENDERER=gl` |
| `Mod + Tab` | Noctalia window switcher in hold mode |
| `Alt + W` | Random wallpaper |
| `Alt + N` | Notes panel |

Panel, launcher, session/lock screen, and volume/brightness/media controls are all routed through **Noctalia** (`noctalia msg ...`), which acts as the shell layer on top of Niri.

### Desktop Shell — Noctalia

[Noctalia](https://noctalia.dev/) v5 is the actual desktop shell in daily use — it replaces the bar, launcher, notification daemon, wallpaper manager, lock screen, and session/power menu with one cohesive UI, so none of those pieces need to be configured by hand anymore.

Niri talks to it directly through `noctalia msg <command>` calls wired into `niri/niri/noctalia/keybinds.kdl`:

| Keybind | Action |
|---|---|
| `Mod + Space` | Toggle the app launcher panel |
| `Alt + W` | Random wallpaper |
| `Alt + N` | Toggle notes panel |
| `Super + L` | `noctalia msg session lock` |
| Volume / brightness / media keys | Routed through `noctalia msg volume-up/down`, `brightness-up/down`, `media next/previous/toggle`, etc. |
| `Super + V` | Toggle clipboard history panel |

Noctalia's own settings live outside this repo (in its own config location), this repo tracks the compositor-side integration for both Umbriel and Niri. See `umbriel/umbriel/config.toml`, `niri/niri/noctalia.kdl`, and `niri/niri/noctalia/*.kdl`.

### Terminal & Shell

Konsole settings are tracked in `konsole/konsolerc`; the `Comfortable` profile and its color schemes live in `konsole-profiles/konsole/`. Kitty uses JetBrainsMono Nerd Font Mono with padding, transparency, and native Wayland support.

`zshrc/.zshrc` runs on [zsh4humans](https://github.com/romkatv/zsh4humans) with Powerlevel10k, sane history settings (deduped, shared across sessions, timestamped), and a handful of personal touches:

- `yy` — wraps `yazi` so exiting the file manager `cd`s your shell into the last visited directory
- `md` — `mkdir -p` + `cd` in one shot
- Aliases for Bluetooth, aria2, yt-dlp (`ydl7`/`ydl10` for quick quality-capped downloads), Ghidra, and CTF virtualenv activation
- Wayland → X11 compatibility shims for tools that don't play nice with Wayland natively (IDA, Ghidra)

### Fonts & Environment

`fontconfig/fontconfig/conf.d/65-bangla-bd.conf` keeps Latin font families first and sets Bengali fallbacks to Hind Siliguri and Noto Serif Bengali. The font files are installed separately.

`env/environment.d/90-cursor.conf` sets Bibata-Modern-Ice at size 24 for the user environment. Install the cursor theme separately and start a new session after changing these settings.

### File Manager — Yazi

Configured for a wide 3-pane preview layout (`ratio = [1, 4, 3]`), natural sort, and full mouse support — see `yazi/yazi/yazi.toml`.

### Media — mpv

Beyond the base `mpv.conf`/`input.conf`, this includes several bundled Lua scripts:

- `thumbfast.lua` — fast scrubbing thumbnails
- `audio_visualizer.lua` — custom visualizer
- `copy-time.lua`, `seek-to.lua`, `cycle-commands.lua` — quality-of-life playback tools

### Utility Scripts

`scripts/scripts/` holds small, standalone tools that don't belong to any single app config:

| Script | Purpose |
|---|---|
| `WallpaperSelect.sh` | Wallpaper picker |
| `scratchpad.sh` | Toggleable scratchpad window (drop-down terminal/notes) |
| `screenshot_display.sh` / `screenshot_window.sh` | Region/window screenshots via `grim` + `slurp` + `swappy` |
| `ghidra.py` | CLI wrapper to spin up a headless-analyzed Ghidra project from any binary in one command |
| `publish.py` | Publishes a note (or folder of notes) from a private Obsidian vault to a public GitHub repo — rewrites image links, copies attachments, commits, and pushes automatically |

---

## Bangla typing with Avro

On Umbriel, press **Super+Shift+Space**, type `ami` in a text field, then press **Space** to commit `আমি`. Press **Super+Shift+Space** again for English. The binding is in the [Umbriel config](umbriel/umbriel/config.toml). **Ctrl+Space** is reserved for the [tmux prefix](tmux/tmux/tmux.conf).

Avro Phonetic is an IBus engine, so look for it under **Bengali** in IBus Preferences (`ibus-setup`). On the Umbriel setup below, open preferences with `IBUS_ADDRESS="$(env -u WAYLAND_DISPLAY ibus address)" ibus-setup` to reach the existing daemon. The floating English/Avro buttons we previously used came from a separate `avro-switcher.service`. The IBus candidate panel shows spelling suggestions while you type. [Avro Phonetic project](https://github.com/sarim/ibus-avro)

### Install Avro

On Debian or Ubuntu, install `ibus-avro` from the distro repository. On Arch, the upstream project points to `ibus-avro-git` in the AUR. On this Fedora workstation Avro is installed per user, with engine files in `~/.local/share/ibus-avro`, a component file in `~/.local/share/ibus/component/ibus-avro.xml`, and a GSettings schema in `~/.local/share/glib-2.0/schemas/`. For a fresh Fedora setup, build the upstream source into `~/.local`. [Upstream installation instructions](https://github.com/sarim/ibus-avro#installation)

```sh
sudo dnf install git gcc make automake autoconf pkgconf-pkg-config ibus-devel ibus ibus-panel ibus-gtk3 gjs
git clone https://github.com/sarim/ibus-avro.git
cd ibus-avro
# Optional if you want the tagged maintenance release
# git checkout 1.2
git rev-parse --short HEAD
autoreconf -fi
./configure --prefix="$HOME/.local"
make
make install
```

If the generated component's `<exec>` includes ` > /dev/null`, remove that suffix from the XML. IBus launches the command directly and the local configuration uses `gjs --include-path=… main-gjs.js --ibus` without shell redirection. The workstation also removes the debug `print` that logs every key event in `main-gjs.js`.

The installed runtime matched upstream `dd521a1` during the investigation, apart from generated paths and the removed key-event logging. That commit is newer than the tagged **1.2** release, but the upstream component XML still reports **1.1**. Use the Git commit to identify a source install. [Source snapshot](https://github.com/sarim/ibus-avro/tree/dd521a139af0b4bb64eaeeca44fef03f5fb770cf) · [1.2 release](https://github.com/sarim/ibus-avro/releases/tag/1.2)

### Connect IBus to Umbriel

The initial setup only ran the IBus panel under X11. Switching to Avro worked at the daemon, but native Wayland Brave did not receive the resulting text. Umbriel exposes Wayland text-input v3 and input-method v2. Enabling the IBus Wayland frontend let Brave receive Bengali composition text without replacing the browser or closing its tabs. The following two per-user units reproduce the setup on the Fedora workstation with IBus 1.5.35. [IBus Wayland desktop setup](https://github.com/ibus/ibus/wiki/WaylandDesktop)

Create `~/.config/systemd/user/ibus-avro.service` for the local component directory. This setup uses the daemon's X11-addressed IBus socket while the separate panel connects to Umbriel over Wayland.

```ini
[Unit]
Description=IBus input service with Avro Phonetic
PartOf=graphical-session.target

[Service]
Environment=IBUS_COMPONENT_PATH=%h/.local/share/ibus/component:/usr/share/ibus/component
UnsetEnvironment=WAYLAND_DISPLAY
ExecStart=/usr/bin/ibus-daemon --replace --xim --desktop=umbriel --cache=none --panel=disable
Restart=on-failure

[Install]
WantedBy=graphical-session.target
```

Create `~/.config/systemd/user/ibus-candidate-panel.service` for the native Wayland frontend. On this workstation the equivalent `[Service]` changes are installed as a drop-in at `ibus-candidate-panel.service.d/wayland.conf`. If you already have a candidate-panel unit, edit it or override it rather than starting a second frontend. In a drop-in, clear the old `ExecStart` with an empty `ExecStart=` line first.

```ini
[Unit]
Description=IBus Wayland input frontend and candidate panel
Requires=ibus-avro.service
After=ibus-avro.service umbriel.service
PartOf=ibus-avro.service graphical-session.target

[Service]
Environment=GDK_BACKEND=wayland
ExecStart=/bin/sh -c 'IBUS_ADDRESS=$$(/usr/bin/env -u WAYLAND_DISPLAY /usr/bin/ibus address); case "$$IBUS_ADDRESS" in unix:*) export IBUS_ADDRESS; exec /usr/libexec/ibus-ui-gtk3 --enable-wayland-im ;; *) exit 1 ;; esac'
Restart=on-failure
RestartSec=1s

[Install]
WantedBy=umbriel-session.target
```

From an Umbriel session, reload systemd and enable the services. On an existing setup use `systemctl --user restart ibus-avro.service ibus-candidate-panel.service` after changing an engine or unit. If you previously installed the floating switcher, disable it separately with `systemctl --user disable --now avro-switcher.service`.

```sh
systemctl --user daemon-reload
systemctl --user enable --now ibus-avro.service ibus-candidate-panel.service
umbriel config validate
umbriel msg config-reload
env -u WAYLAND_DISPLAY ibus list-engine --name-only | grep -Fx ibus-avro
env -u WAYLAND_DISPLAY ibus engine xkb:us::eng
```

For the keyboard-only setup, the configured IBus input list contains English (US), and the compositor shortcut explicitly selects Avro when needed. To use this convention, set both `preload-engines` and `engines-order` in `org.freedesktop.ibus.general` to `['xkb:us::eng']`. To keep **Ctrl+Space** for tmux, remove `<Control>space` from the `triggers` setting and `Control+space` from the legacy `trigger` setting in `org.freedesktop.ibus.general.hotkey`. Preserve any other IBus shortcuts you use. Setting English as the only preloaded engine replaces the list used by the IBus input menu.

### Test in Brave and Google Docs

1. Focus an ordinary text field in Brave. Press **Super+Shift+Space** and type `ami` followed by **Space**.
2. Repeat in the Google Docs editing area. Click into the document first and confirm you are in **Editing** mode.
3. If you still get Latin letters, run `env -u WAYLAND_DISPLAY ibus engine` after turning on Avro. Expect `ibus-avro` while Avro is active and `xkb:us::eng` in English mode.
4. If the engine toggles but a browser field still receives Latin text, check `systemctl --user status ibus-candidate-panel.service` and `journalctl --user -u ibus-candidate-panel.service -b`. Check that the frontend runs with `--enable-wayland-im` and can reach the same daemon. The plain `ibus` command in this particular setup looks up a different socket when `WAYLAND_DISPLAY` is set.
5. If Bengali is committed but displays as boxes, check the installed Bangla fonts with `fc-list ':lang=bn' family` and see the [font fallback config](fontconfig/fontconfig/conf.d/65-bangla-bd.conf).

The shortcut was tested in both directions and Brave received Bengali preedit text through Wayland. The Google Docs editor itself was outside that test.

### Niri setup

Use the [IBus instructions for Niri](https://github.com/ibus/ibus/wiki/WaylandDesktop#niri-desktop-environment) for that session. With IBus 1.5.32 or newer, upstream documents `ibus start --type wayland` and recommends XDG desktop autostart for Niri. For a source install under `~/.local`, pass `IBUS_COMPONENT_PATH="$HOME/.local/share/ibus/component:/usr/share/ibus/component"` to the launch command if the session cannot discover Avro. Add **Avro Phonetic** through IBus Preferences and choose a shortcut that does not overlap with the compositor or tmux. The [Niri bindings](niri/niri/noctalia/keybinds.kdl) currently have no Avro toggle. The Umbriel-specific keybinding and service wiring above were tested on Umbriel.

## Niri and Umbriel troubleshooting

### Screen sharing and audio

For a missing picker or black stream in Vesktop, first check the user portal and PipeWire services. The packaged Niri portal config uses the GNOME backend for screen capture with GTK fallbacks. Umbriel ships a compositor-specific backend. Keep the backend selection scoped to the desktop session you log in to.

```sh
systemctl --user status xdg-desktop-portal pipewire wireplumber
# Run the line for your active session.
systemctl --user status xdg-desktop-portal-gnome
systemctl --user status xdg-desktop-portal-umbriel
wpctl status
```

- **Niri and Vesktop.** An earlier workaround waited for the Mutter ScreenCast interface and killed the GNOME portal to make it restart. The Vesktop and audio cleanup removed that startup hook and the manual D-Bus environment export. Use the packaged Niri session and check the portal journal if capture fails. If Xwayland Video Bridge appears as a black tile, the current window rule floats its helper at 1×1, makes it transparent, and keeps it from taking focus. [Cleanup commit](../../commit/92f9526) · [Niri window rules](niri/niri/noctalia/rules.kdl)
- **Stream audio.** If video shares but audio is missing, use `wpctl status` while a stream is active to check the playback node and default sink. The historical cleanup does not ship a custom WirePlumber routing policy.
- **Brave credential prompts after changing sessions.** The Umbriel setup uses `--password-store=gnome-libsecret` in the launchers for consistent keyring storage. Check the launcher's arguments and whether your session has an unlocked keyring before changing Brave's password store. [Umbriel setup notes](umbriel/umbriel/KEYBINDINGS.md)

### Graphics, windows, and workspaces

| Symptom or goal | Current setup |
|---|---|
| Umbriel blur-buffer errors or slow effects on Intel HD 620 | Blur and shadows are disabled. Opening and closing use fades, while movement keeps the built-in spring animations. The overview disables its wallpaper and blur and uses transparent workspace backgrounds. See the [Umbriel appearance config](umbriel/umbriel/config.toml). |
| Fullscreen flicker or an external monitor with a different refresh rate | Run `umbriel outputs` or `niri msg outputs` for the advertised output names and modes. The checked-in `eDP-1` mode is `1920x1080@60.027` at scale 1. Umbriel has commented HDMI and VRR examples. Test `direct_scanout = false` on the affected Umbriel output if fullscreen flickers. |
| Niri renders on the wrong GPU on this laptop | The Niri config pins rendering to the Intel device using the stable `/dev/dri/by-path/pci-0000:00:02.0-render` link. Find the equivalent path under `/dev/dri/by-path/` or remove the override on other hardware. See the [Niri config](niri/niri/config.kdl). |
| JADX under Xwayland leaves white space when tiled | Both configs float `jadx-gui-JadxGUI`. Its Swing window could paint at its previous size after a compositor resize. See the [Niri rule](niri/niri/config.kdl) and [Umbriel rule](umbriel/umbriel/config.toml). |
| Video Picture-in-Picture takes up a tile in Niri | The [Niri rules](niri/niri/noctalia/rules.kdl) match the browser's PiP title and open it as a small floating window. Use `niri msg windows` to check the exact title and app ID if a browser changes them. |
| Switching between Niri and Umbriel feels different | Both use Noctalia's hold-mode window switcher on **Mod+Tab** and Foot on **Mod+Enter**. Umbriel holds four dynamic workspaces open on `eDP-1`, with workspace bindings through nine. **Alt+Ctrl+C** centers the focused column and **Alt+Ctrl+F** toggles its full width. See the [active Umbriel bindings](umbriel/umbriel/config.toml). |
| Per-workspace wallpaper does not change | The separate `paper-no-wall` helper listens to compositor events and changes Noctalia's wallpaper. Niri starts it from `config.kdl` with `--compositor niri` and an absolute local path. On this Umbriel machine a user unit starts it after `umbriel.service`. Install the helper and set the wallpaper directory using the [paper-no-wall setup instructions](https://github.com/hakimshifat/paper-no-wall). |
| ASUS X510UQ hangs at a black screen on sleep | See the tested [deep-sleep workaround](#deep-sleep-on-the-asus-x510uq) below. |

Run `niri validate` or `umbriel config validate` after changing compositor files. The active config takes precedence over older keybinding notes.

### Lock-state detection in Niri

On the tested Niri 26.04 session, the freedesktop ScreenSaver interface offered `Inhibit` and `UnInhibit`, and `GetActive` returned `UnknownMethod`. That matters for software that expects lock-state events through the ScreenSaver interface. To inspect the session independently, use `loginctl list-sessions` and then `loginctl show-session <id> -p Type -p LockedHint` with the graphical session ID. This investigation identified an interface gap. Application auto-lock behavior was outside the test, and there is no config fix recorded here. [Niri issue #4753](https://github.com/niri-wm/niri/issues/4753)

## System Services

Two `systemd` units for laptop power management:

- **`battery-threshold.service`** — caps charging at 80% (`charge_control_end_threshold`) on suspend/hibernate transitions, to preserve battery health.
- **`nvidia-sleep.service`** — forces the NVIDIA GPU into runtime power-saving mode a few seconds after the graphical session loads, working around a driver init race.

For matching hardware, install separately from the Stow packages:

```bash
sudo cp battery-threshold.service nvidia-sleep.service /etc/systemd/system/
sudo systemctl enable --now battery-threshold.service nvidia-sleep.service
```

### Deep sleep on the ASUS X510UQ

If the laptop intermittently hangs with a black screen during deep sleep, try
running device suspend and resume callbacks in sequence. This keeps the existing
sleep mode and may make sleep and wake a little slower. Two lid close tests
completed successfully with this setting on the ASUS X510UQ.

From this repository, install and apply the setting on Fedora or another
systemd-based system that exposes `/sys/power/pm_async`:

```sh
pkexec install -m 644 deep-sleep.conf /etc/tmpfiles.d/deep-sleep.conf
pkexec systemd-tmpfiles --create /etc/tmpfiles.d/deep-sleep.conf
cat /sys/power/mem_sleep /sys/power/pm_async
```

On the X510UQ, expect `s2idle [deep]` followed by `0`. The brackets show
the selected sleep mode. On other hardware, the available modes and default may differ.
Systemd reapplies the setting at boot. To undo it, remove
`/etc/tmpfiles.d/deep-sleep.conf` and reboot.

## Installation

> ⚠️ Currently used on Fedora; some older configs and scripts come from Arch/EndeavourOS. Review local paths and hardware settings before linking on another machine.

Install GNU Stow and the applications you want to use, then:

```bash
git clone git@github.com:hakimshifat/dotfiles.git
cd dotfiles
mkdir -p "$HOME/.config" "$HOME/.local/share"

# Preview links before changing anything.
stow -n -v -t "$HOME/.config" umbriel niri fontconfig env konsole kitty tmux mpv yazi
stow -n -v -t "$HOME/.local/share" konsole-profiles
stow -n -v -t "$HOME" zshrc
```

When the previews report no conflicts, apply the links:

```bash
stow -v -t "$HOME/.config" umbriel niri fontconfig env konsole kitty tmux mpv yazi
stow -v -t "$HOME/.local/share" konsole-profiles
stow -v -t "$HOME" zshrc
```

Run from the repository root and always specify the target. Most packages use `package/app/files` and target `~/.config`; Konsole profiles target `~/.local/share`, and Zsh targets `~`. You can link individual packages instead of the whole list. Choose Umbriel or Niri when starting your desktop session.

Back up existing real files outside the repository and compare them before moving them aside for Stow. To unlink a package, use `stow -D -t "$HOME/.config" kitty` with the appropriate target. Commit and push reviewed changes to sync through GitHub; on another machine, pull and restow if the package layout changes.

Install Noctalia separately per https://noctalia.dev/ — its own settings are not part of this repo. Install tmux plugins separately as well.

Font settings expect JetBrainsMono Nerd Font Mono, Noto Sans, Noto Serif, Hind Siliguri, and Noto Serif Bengali; cursor settings expect Bibata-Modern-Ice. Konsole's `Comfortable.profile` currently uses a machine-specific zsh4humans cache path. Review that command, Niri's Intel render-device path, and compositor output settings on another machine.

---

## Git Setup

Fresh machine checklist:

```bash
git config --global user.name "username"
git config --global user.email "email"

ssh-keygen -t ed25519 -C "email"
eval "$(ssh-agent -s)"
ssh-add ~/.ssh/theprivatekey

# Verify
ssh -T git@github.com
```

---

## Competitive Programming Environment

This repo doubles as my competitive-programming setup:

- **`cpbooster-config.json`** — config for [cpbooster](https://github.com/aaditya2200/cp-booster), a CLI companion tool that clones contest problems, runs tests, and submits — wired to `footclient` as the editor and configured for C++/Python/Java/JS across Codeforces, AtCoder, omegaUp, Szkopul, and Yandex.
- **`subl.md`** — Sublime Text setup used alongside cpbooster:
  - A `cpp.sublime-build` system: compiles with `g++ -std=c++17 -O2 -Wall -Wextra`, then runs against `input.txt`/`output.txt` with a 4s timeout — errors piped to `errors.txt`
  - Vintage mode `jj` → exit insert mode keybind
  - A precompiled `stdc++.h` header for faster build times

> **FastOlympicCode tip:** Competitive Companion listens on port `12345`. If test cases download but don't auto-run, make sure the filename in Sublime matches the filename the plugin is watching.

Quick alias from `.zshrc`:

```bash
alias cc="cpb clone"
```

---

## Legacy Configs

Kept around for reference or in case of rollback — not part of the active daily setup:

- **`sway/`** — Sway config, split into `config.d/` fragments (theme, input, output, autostart, app defaults).
- **`paru/`** — AUR helper configuration from the earlier Arch/EndeavourOS setup; optional and not needed on Fedora.

The old standalone shell components (`waybar/`, `rofi/`, `tofi/`, `mako/`, `wlogout/`, and `swaylock/`) have been removed. Noctalia provides those desktop functions.

---

## License

Licensed under the **[GNU General Public License v3.0](LICENSE)**. Use, fork, and modify freely — just keep it open.

---

<div align="center">

*Built for a fast, minimal, and hacker-friendly desktop. PRs and issues welcome.*

</div>
