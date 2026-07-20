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
  - [Desktop Shell — Noctalia](#desktop-shell--noctalia)
  - [Terminal & Shell](#terminal--shell)
  - [File Manager — Yazi](#file-manager--yazi)
  - [Media — mpv](#media--mpv)
  - [Utility Scripts](#utility-scripts)
- [System Services](#system-services)
- [Installation](#installation)
- [Git Setup](#git-setup)
- [Competitive Programming Environment](#competitive-programming-environment)
- [Legacy Configs](#legacy-configs)
- [License](#license)

---

## About

This repository is my personal Linux configuration — the result of continuously refining a Wayland desktop that stays fast, keyboard-first, and distraction-free. It's the config I actually use every day for coursework, cybersecurity research (CTFs, binary analysis), and daily driving.

It's not a "framework" meant for others to install blindly — it's a living config. Feel free to fork it, steal pieces, or use it as a reference for building your own Niri setup.

> 🪟 **Currently active:** [`niri`](#window-manager--niri) as the compositor, with [**Noctalia**](https://noctalia.dev/) (v5) running the entire desktop shell on top — bar, launcher, notifications, wallpaper, lock screen, and session/control center, all in one. No manual Waybar/Rofi/Mako/wlogout setup is needed day-to-day; those configs are kept only as a legacy fallback — see [Legacy Configs](#legacy-configs).

---

## Stack

| Layer | Tool |
|---|---|
| Compositor / WM | [Niri](https://github.com/YaLTeR/niri) *(scrollable tiling)* — with [Hyprland](https://hyprland.org/) & [Sway](https://swaywm.org/) kept as legacy alternatives |
| Desktop Shell | [**Noctalia**](https://noctalia.dev/) v5 *(bar, launcher, notifications, wallpaper, control center, lock & session screens — the whole UI layer)* |
| Terminal | [foot](https://codeberg.org/dnkl/foot) |
| Shell | Zsh + [zsh4humans](https://github.com/romkatv/zsh4humans) + Powerlevel10k |
| File Manager (TUI) | [Yazi](https://github.com/sxyazi/yazi) |
| File Manager (GUI) | Nemo |
| Multiplexer | [tmux](https://github.com/tmux/tmux) |
| Media Player | [mpv](https://mpv.io/) *(w/ thumbfast, custom audio visualizer, GIF/seek scripts)* |
| Downloader | [aria2](https://aria2.github.io/) *(RPC daemon mode)* |
| AUR Helper | [paru](https://github.com/Morganamilo/paru) |
| Browsers | Firefox, Brave |
| Reverse Engineering | Ghidra (with a custom `ghidra.py` launcher), jadx, IDA |
| *Legacy shell components* | *Waybar, Rofi, Tofi, Mako, swaylock, wlogout — superseded by Noctalia, kept for fallback* |

---

## Repo Structure

```
.
├── niri/            # Active WM config (config.kdl + noctalia/*.kdl integration modules)
├── hyperland/        # Legacy Hyprland config (hyprland, hyprlock, hypridle)
├── sway/             # Legacy Sway config
├── waybar/           # [legacy] Status bar config, styles, and helper scripts — replaced by Noctalia's bar
├── mako/             # [legacy] Notification daemon config — replaced by Noctalia's notifications
├── rofi/              # [legacy] Launcher themes (multiple KooL-style variants) — replaced by Noctalia's launcher
├── tofi/              # [legacy] Lightweight launcher config — replaced by Noctalia's launcher
├── wlogout/           # [legacy] Power/session menu layout — replaced by Noctalia's session screen
├── swaylock/           # [legacy] Lock screen config + wallpaper — replaced by Noctalia's lock screen
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

### Desktop Shell — Noctalia

[Noctalia](https://noctalia.dev/) v5 is the actual desktop shell in daily use — it replaces the bar, launcher, notification daemon, wallpaper manager, lock screen, and session/power menu with one cohesive UI, so none of those pieces need to be configured by hand anymore.

Niri talks to it directly through `noctalia msg <command>` calls wired into `niri/niri/noctalia/keybinds.kdl`:

| Keybind | Action |
|---|---|
| *Alt + Space* | Toggle the app launcher panel |
| `Alt + W` | Random wallpaper |
| `Alt + N` | Toggle notes panel |
| *(SUPER + L)* | `noctalia msg session lock` |
| Volume / brightness / media keys | Routed through `noctalia msg volume-up/down`, `brightness-up/down`, `media next/previous/toggle`, etc. |
| *(SUPER + v)* | Toggle clipboard history panel |

Noctalia's own settings live outside this repo (in its own config location), so what you'll find here is just the Niri-side integration that wires keybinds and autostart into it — see `niri/niri/noctalia.kdl` and `niri/niri/noctalia/*.kdl`.

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

## Installation

> ⚠️ These configs assume an Arch-based distro (originally set up on EndeavourOS) with Wayland + Niri. Review each config before symlinking — some scripts contain hardcoded paths from my machine.

```bash
git clone https://github.com/<your-username>/dotfiles.git
cd dotfiles

# Symlink the active configs into ~/.config
stow -t ~/.config tmux

# Install Noctalia separately per https://noctalia.dev/ — it's not part of this repo
```

Repeat for any other component folder you want (e.g. legacy `waybar/`, `rofi/`, `hyperland/`, `sway/` — all opt-in, none needed for the current Niri + Noctalia setup). There's no `stow`/bootstrap script yet — everything is linked module-by-module on purpose.

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

**Previous window managers:**
- **`hyperland/`** — Hyprland + Hyprlock + Hypridle configs
- **`sway/`** — Sway config, split into `config.d/` fragments (theme, input, output, autostart, app defaults)

**Pre-Noctalia shell components** — manually configured before Noctalia took over the whole shell layer:
- **`waybar/`** — status bar config + `style.css`, plus helper scripts (power-profile switcher, mako bridge, keyhint overlay)
- **`rofi/`** — a full set of KooL-style launcher themes (fullscreen, vertical, Win11-style, dark/light) with dedicated configs for app search, emoji picker, and monitor selection
- **`tofi/`** — lightweight alternative launcher config
- **`mako/`** — notification daemon config
- **`wlogout/`** — power/session menu layout
- **`swaylock/`** — lock screen config + wallpaper

None of these are actively maintained — they're functional snapshots from before the switch to Niri + Noctalia.

---

## License

Licensed under the **[GNU General Public License v3.0](LICENSE)**. Use, fork, and modify freely — just keep it open.

---

<div align="center">

*Built for a fast, minimal, and hacker-friendly desktop. PRs and issues welcome.*

</div>
