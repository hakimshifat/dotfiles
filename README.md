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
| Terminal | Konsole and [Kitty](https://sw.kovidgoyal.net/kitty/) |
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
├── env/                 # environment.d cursor settings
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
├── nvidia-sleep.service       # Optional GPU power management unit
└── LICENSE                   # GPLv3
```

---

## Highlights

### Window Manager — Umbriel

Umbriel's config lives in `umbriel/umbriel/config.toml`, with a `KEYBINDINGS.md` reference alongside it. It includes scrolling layouts, scratchpad bindings, window rules, and Noctalia integration. `Mod + Return` opens Konsole; `Super + E` opens Nautilus.

### Window Manager — Niri

Niri’s config is modularized under `niri/niri/noctalia/` and pulled together by `niri/niri/config.kdl`:

- `keybinds.kdl` — all keybindings
- `layout.kdl`, `animation.kdl`, `misc.kdl` — behavior & feel
- `input.kdl`, `display.kdl` — hardware config
- `rules.kdl`, `autostart.kdl` — window rules & startup apps

Notable bindings:

| Keybind | Action |
|---|---|
| `Mod + Return` | Open terminal (`konsole`) |
| `Super + B` | Firefox |
| `Alt + B` | Brave |
| `Super + E` | Nautilus (file manager) |
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

## System Services

Two `systemd` units for laptop power management:

- **`battery-threshold.service`** — caps charging at 80% (`charge_control_end_threshold`) on suspend/hibernate transitions, to preserve battery health.
- **`nvidia-sleep.service`** — forces the NVIDIA GPU into runtime power-saving mode a few seconds after the graphical session loads, working around a driver init race.

For matching hardware, install separately from the Stow packages:

```bash
sudo cp battery-threshold.service nvidia-sleep.service /etc/systemd/system/
sudo systemctl enable --now battery-threshold.service nvidia-sleep.service
```

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
