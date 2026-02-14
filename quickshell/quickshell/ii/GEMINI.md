# Illogical Impulse (ii) - Gemini Context

Illogical Impulse (ii) is a comprehensive, highly customizable shell and UI suite for Linux desktop environments, primarily optimized for **Niri** and **Hyprland**. It is built on the **Quickshell** framework, utilizing QML/Qt6 for its interface and a variety of backend scripts (Python, Fish, Bash) for system integration.

## Project Overview

- **Core Framework:** [Quickshell](https://outfoxxed.github.io/quickshell/) (QML/Qt6).
- **Design Philosophy:** Offers two distinct visual "families":
    - **ii (Material):** Modern, Google Material Design-inspired aesthetic with rich animations and transitions.
    - **Waffle:** Windows 11-inspired aesthetic with a centered taskbar, start menu, and action center.
- **Key Features:**
    - **Modular Panels:** Bar, Dock, Overview, Control Panel, Alt-Switcher, Lockscreen, and Session Screen.
    - **Integrated AI:** Sidebar assistant supporting Gemini, Mistral, and Ollama.
    - **Dynamic Theming:** Automated color scheme generation via `matugen` based on wallpaper.
    - **System Utilities:** Weather, Media Controls, Clipboard (cliphist), System Monitor, and Notifications.
    - **Multi-Compositor Support:** Deep integration with Niri and Hyprland.

## Architecture

- `shell.qml`: The primary entry point for the Quickshell process.
- `modules/`: Contains UI components and panel implementations (e.g., `bar/`, `dock/`, `waffle/`).
- `services/`: Backend logic and data providers (e.g., `Ai.qml`, `Audio.qml`, `Network.qml`).
- `scripts/`: System-level integration scripts for colors, hardware sensors, window capturing, etc.
- `defaults/`: Default configuration files and component presets.
- `sdata/`: Internal project data, including installation logic (`subcmd-install/`) and diagnostic tools (`lib/doctor.sh`).

## Building and Running

### Prerequisites
The project requires `quickshell`, `Qt6`, and several system-level dependencies.
A comprehensive check can be performed using the "Doctor" tool:
```bash
# This is usually invoked via the project's setup script
bash sdata/lib/doctor.sh
```

### Key Dependencies
- **Runtime:** `quickshell`, `niri` or `hyprland`, `qt6-svg`, `qt6-declarative`, `qt6-graphicaleffects`.
- **System Tools:** `nmcli`, `wpctl`, `jq`, `rsync`, `curl`, `git`, `python3`, `matugen`, `wlsunset`, `dunst`, `fish`, `magick`, `swaylock`, `grim`, `cliphist`, `fuzzel`.
- **Python:** Managed via `uv`. Requirements are in `sdata/uv/requirements.txt`.

### Execution
Run the shell using `quickshell`:
```bash
qs -c ii # Uses the 'ii' folder as the config root
# OR directly
qs -p shell.qml
```

## Development Conventions

- **QML Styling:** Mimics Material Design (ii) or Fluent Design (Waffle). Use `qs.modules.common` for shared components.
- **Configuration:** Centrally managed in `modules/common/Config.qml` and stored in `~/.config/illogical-impulse/config.json`.
- **State Management:** Uses `GlobalStates.qml` for cross-component reactive state.
- **Services:** Heavy lifting should be moved to singleton QML services in `services/`.
- **Scripts:** Prefer Python for complex logic and Bash/Fish for simple system commands. Ensure scripts are executable.

## Key Files
- `shell.qml`: Entry point, manages panel loading and IPC.
- `GlobalStates.qml`: Global reactive state variables.
- `defaults/config.json`: The default configuration schema.
- `sdata/lib/doctor.sh`: Diagnostic script for environment verification.
- `VERSION`: Current semantic version (e.g., 2.9.2).
