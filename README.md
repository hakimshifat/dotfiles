<div align="center">

# 🐧 dotfiles

**A minimal, keyboard-driven Linux desktop for a wlroots-based Wayland setup — built around [Niri](https://github.com/YaLTeR/niri), tuned for reverse engineering, CTFs, and competitive programming.**

![WM](https://img.shields.io/badge/WM-Niri-9cccf3?style=for-the-badge)
![Distro](https://img.shields.io/badge/Distro-Arch%20%2F%20EndeavourOS-1793d1?style=for-the-badge&logo=archlinux)
![Shell](https://img.shields.io/badge/Shell-Zsh%20(zsh4humans)-yellow?style=for-the-badge&logo=gnubash)
![License](https://img.shields.io/badge/License-GPLv3-blue?style=for-the-badge)

</div>

---

## Table of Contents

- [About](#about)
- [Stack](#stack)
- [Repo Structure](#repo-structure)
- [Highlights](#highlights)
  - [Window Manager — Niri](#window-manager--niri)
  - [Status Bar — Waybar](#status-bar--waybar)
  - [Launchers — Rofi & Tofi](#launchers--rofi--tofi)
  - [Terminal & Shell](#terminal--shell)
  - [File Manager — Yazi](#file-manager--yazi)
  - [Media — mpv](#media--mpv)
  - [Utility Scripts](#utility-scripts)
- [System Services](#system-services)
- [Scheduled Tasks](#scheduled-tasks)
- [Installation](#installation)
- [Git Setup](#git-setup)
- [Competitive Programming Environment](#competitive-programming-environment)
- [Legacy Configs](#legacy-configs)
- [License](#license)

---

## About

This repository is my personal Linux configuration — the result of continuously refining a Wayland desktop that stays fast, keyboard-first, and distraction-free. It's the config I actually use every day for coursework, cybersecurity research (CTFs, binary analysis), and daily driving.

It's not a "framework" meant for others to install blindly — it's a living config. Feel free to fork it, steal pieces, or use it as a reference for building your own Niri setup.

> 🪟 **Currently active:** [`niri`](#window-manager--niri) — a scrollable-tiling Wayland compositor.
> Older Hyprland and Sway setups are kept in the repo for reference/rollback — see [Legacy Configs](#legacy-configs).

---

## Stack

| Layer | Tool |
|---|---|
| Compositor / WM | [Niri](https://github.com/YaLTeR/niri) *(scrollable tiling)* — with [Hyprland](https://hyprland.org/) & [Sway](https://swaywm.org/) kept as legacy alternatives |
| Shell UI / Panel | [Noctalia](https://github.com/noctalia-dev/noctalia-shell) *(bar, launcher, notifications, session, lock)* |
| Status Bar | [Waybar](https://github.com/Alexays/Waybar) |
| App Launcher | [Rofi](https://github.com/davatorium/rofi) / [Tofi](https://github.com/philj56/tofi) |
| Notifications | [Mako](https://github.com/emersion/mako) |
| Terminal | [foot](https://codeberg.org/dnkl/foot) |
| Shell | Zsh + [zsh4humans](https://github.com/romkatv/zsh4humans) + Powerlevel10k |
| File Manager (TUI) | [Yazi](https://github.com/sxyazi/yazi) |
| File Manager (GUI) | Nemo |
| Multiplexer | [tmux](https://github.com/tmux/tmux) |
| Media Player | [mpv](https://mpv.io/) *(w/ thumbfast, custom audio visualizer, GIF/seek scripts)* |
| Screen Lock | [swaylock](https://github.com/swaywm/swaylock) |
| Session Menu | [wlogout](https://github.com/ArtsyMacaw/wlogout) |
| Downloader | [aria2](https://aria2.github.io/) *(RPC daemon mode)* |
| AUR Helper | [paru](https://github.com/Morganamilo/paru) |
| Browsers | Firefox, Brave |
| Reverse Engineering | Ghidra (with a custom `ghidra.py` launcher), jadx, IDA |

---

## Repo Structure

```
.
├── niri/            # Active WM config (config.kdl + noctalia/*.kdl modules)
├── hyperland/        # Legacy Hyprland config (hyprland, hyprlock, hypridle)
├── sway/             # Legacy Sway config
├── waybar/           # Status bar config, styles, and helper scripts
├── mako/             # Notification daemon config
├── rofi/              # Launcher themes (multiple KooL-style variants)
├── tofi/              # Lightweight launcher config
├── wlogout/           # Power/session menu layout
├── swaylock/           # Lock screen config + wallpaper
├── tmux/               # tmux.conf
├── yazi/               # TUI file manager config
├── mpv/                # Media player config + Lua scripts
├── aria2/              # Download manager RPC config
├── paru/                # AUR helper config
├── scripts/             # Standalone utility scripts (screenshots, scratchpad, wallpaper, Ghidra launcher, Obsidian → GitHub publisher)
├── .zshrc                # Zsh config (zsh4humans + personal aliases/functions)
├── cpbooster-config.json # Competitive programming CLI config
├── crontab.md             # Cron job reference
├── subl.md                 # Sublime Text C++ competitive programming build system
├── battery-threshold.service  # systemd unit — caps battery charging at 80%
├── nvidia-sleep.service        # systemd unit — forces NVIDIA GPU to sleep on suspend
└── LICENSE                      # GPLv3
```

---

## Highlights

### Window Manager — Niri

The active compositor. Config is modularized under `niri/niri/noctalia/` and pulled together by `config.kdl`:

- `keybinds.kdl` — all keybindings
- `layout.kdl`, `animation.kdl`, `misc.kdl` — behavior & feel
- `input.kdl`, `display.kdl` — hardware config
- `rules.kdl`, `autostart.kdl` — window rules & startup apps

Notable bindings:

| Keybind | Action |
|---|---|
| `Mod + Return` | Open terminal (`foot`) |
| `Super + B` | Firefox |
| `Alt + B` | Brave |
| `Super + E` | Nemo (file manager) |
| `Alt + W` | Random wallpaper |
| `Alt + N` | Notes panel |

Panel, launcher, session/lock screen, and volume/brightness/media controls are all routed through **Noctalia** (`noctalia msg ...`), which acts as the shell layer on top of Niri.

### Status Bar — Waybar

A slim top bar (`waybar/waybar/config` + `style.css`) showing tray, idle inhibitor, audio (with a dedicated mic module), network, and battery — plus a custom power-profile switcher backed by `scripts/powerprofile.sh`.

### Launchers — Rofi & Tofi

A full set of Rofi themes lives under `rofi/rofi/themes/` (KooL-style variants — fullscreen, vertical, Win11-style, dark/light) for different launcher moods, alongside dedicated configs for app search, emoji picker, and Waybar-matched styling. Tofi is kept as a lighter-weight alternative launcher.

### Terminal & Shell

`.zshrc` runs on [zsh4humans](https://github.com/romkatv/zsh4humans) with Powerlevel10k, sane history settings (deduped, shared across sessions, timestamped), and a handful of personal touches:

- `yy` — wraps `yazi` so exiting the file manager `cd`s your shell into the last visited directory
- `md` — `mkdir -p` + `cd` in one shot
- Aliases for Bluetooth, aria2, yt-dlp (`ydl7`/`ydl10` for quick quality-capped downloads), Ghidra, and CTF virtualenv activation
- Wayland → X11 compatibility shims for tools that don't play nice with Wayland natively (IDA, Ghidra)

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

## System Services

Two `systemd` units for laptop power management:

- **`battery-threshold.service`** — caps charging at 80% (`charge_control_end_threshold`) on suspend/hibernate transitions, to preserve battery health.
- **`nvidia-sleep.service`** — forces the NVIDIA GPU into runtime power-saving mode a few seconds after the graphical session loads, working around a driver init race.

Install with:

```bash
sudo cp battery-threshold.service nvidia-sleep.service /etc/systemd/system/
sudo systemctl enable --now battery-threshold.service nvidia-sleep.service
```

---

## Installation

> ⚠️ These configs assume an Arch-based distro (originally set up on EndeavourOS) with Wayland + Niri. Review each config before symlinking — some scripts contain hardcoded paths from my machine.

```bash
git clone https://github.com/<username>/dotfiles.git
cd dotfiles

# Symlink individual configs into ~/.config as needed, e.g.:

> i use 'stow' for symlinking dotfiles of my config.

```bash
yay -S stow
```

```bash
stow -t ~/.config/ tmux
```

replace tmux with whatever config you need to put on the config folder


# Zsh config
ln -s "$(pwd)/.zshrc" ~/.zshrc
```

Repeat for any other component folder you want. There's no `stow`/bootstrap script yet — everything is linked module-by-module on purpose, since not every machine needs every piece (e.g. legacy Hyprland/Sway configs are opt-in).

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

Two previous window manager setups are kept around for reference or in case of rollback:

- **`hyperland/`** — Hyprland + Hyprlock + Hypridle configs
- **`sway/`** — Sway config, split into `config.d/` fragments (theme, input, output, autostart, app defaults)

These aren't actively maintained but are functional snapshots from before the switch to Niri.

---

## License

Licensed under the **[GNU General Public License v3.0](LICENSE)**. Use, fork, and modify freely — just keep it open.

---

<div align="center">

*Built for a fast, minimal, and hacker-friendly desktop. PRs and issues welcome.*

</div>
