# dotfiles

Personal Wayland desktop configuration for Umbriel and Niri with Noctalia, Konsole, Kitty, Zsh, tmux, mpv, and Yazi. Packages are managed individually with GNU Stow.

## Packages

| Package | Contents | Stow target |
|---|---|---|
| `umbriel` | Compositor configuration and keybinding reference | `~/.config` |
| `niri` | Modular compositor config, Noctalia integration, cursor and window rules | `~/.config` |
| `fontconfig` | Bengali font fallback preferences | `~/.config` |
| `env` | Cursor theme and size in `environment.d` | `~/.config` |
| `konsole` | Terminal preferences and default profile selection | `~/.config` |
| `konsole-profiles` | Comfortable profile and terminal color schemes | `~/.local/share` |
| `kitty` | Wayland terminal, Nerd Font, padding and transparency settings | `~/.config` |
| `mpv` | Player config, keybindings, Lua scripts, shaders and fonts | `~/.config` |
| `yazi` | File manager config, keybindings and compression plugin | `~/.config` |
| `tmux` | Multiplexer configuration | `~/.config` |
| `zshrc` | `.zshrc`, `.zshenv`, and Powerlevel10k configuration | `~` |

Additional opt-in packages: `aria2`, `paru`, `scripts`, `sway`, and `zellij`, all targeting `~/.config`. Sway is retained as an alternative compositor. The old standalone shell packages—Waybar, Rofi, Tofi, Mako, swaylock, and wlogout—have been removed.

## Installation

Install GNU Stow and the applications you intend to use, then clone this repository and enter its directory. Noctalia and its own settings are managed separately; this repository contains the compositor integration.

Preview the links first:

```sh
stow -n -v -t "$HOME/.config" umbriel fontconfig env konsole kitty niri mpv yazi tmux
stow -n -v -t "$HOME/.local/share" konsole-profiles
stow -n -v -t "$HOME" zshrc
```

Once the preview succeeds:

```sh
mkdir -p "$HOME/.config" "$HOME/.local/share"
stow -v -t "$HOME/.config" umbriel fontconfig env konsole kitty niri mpv yazi tmux
stow -v -t "$HOME/.local/share" konsole-profiles
stow -v -t "$HOME" zshrc
```

Run these commands from the repository root. Always specify the target: packages use `package/app/files` for XDG configs, while `zshrc` contains home-directory dotfiles. Both compositor configs can be installed; choose the compositor when starting your desktop session.

If a destination already contains real files, back them up outside this repository, compare them with the package, and move them aside before running Stow. Avoid blindly adopting existing files, which can overwrite the version in the repository.

To remove a package's links, use the same target:

```sh
stow -D -t "$HOME/.config" kitty
```

Stow manages links; Git manages synchronization. After reviewing edits, commit and push them yourself. On another machine, pull the changes and restow any packages whose file layout changed.

## Desktop notes

Umbriel settings live in `umbriel/umbriel/config.toml`; its keybinding reference is alongside it. Niri loads the modules under `niri/niri/noctalia/` and uses Noctalia commands for the launcher, notifications, wallpaper, clipboard, lock screen, and session controls.

Both compositor configurations open Konsole with `Mod+Return` and Nautilus with `Super+E`. Refer to each config for the full bindings; browser shortcuts differ between compositors.

Konsole selects `Comfortable.profile`, supplied by `konsole-profiles`. That profile currently starts Zsh through a machine-specific zsh4humans cache path; install zsh4humans or adjust the profile command on another machine. Kitty uses JetBrainsMono Nerd Font Mono. Fontconfig expects Noto Sans, Noto Serif, Hind Siliguri, and Noto Serif Bengali. Cursor settings expect Bibata-Modern-Ice.

Review hardware-specific settings before using these configs elsewhere, particularly Niri's Intel render-device path and display settings, and Umbriel's `eDP-1` output section. Optional scripts and older application configs may also contain local paths or distro-specific commands.

Yazi includes a three-pane layout and opens media with mpv. Its editor command expects Neovim, whose configuration is not included. The mpv package includes bundled scripts such as thumbfast and an audio visualizer. Zsh uses zsh4humans and Powerlevel10k; tmux plugins are installed separately and ignored by Git.

## Other files

- `scripts/scripts/`: wallpaper, screenshot, scratchpad, Ghidra and note-publishing helpers. Review paths and dependencies before running them.
- `cpbooster-config.json` and `subl.md`: competitive programming configuration and build notes.
- `crontab.md`: cron reference.
- `battery-threshold.service` and `nvidia-sleep.service`: optional, hardware-specific system units. These require separate installation under `/etc/systemd/system`; they are not user Stow packages.
- `docs.zip`: existing documentation archive.

Track deliberate configuration rather than caches, credentials, histories, or generated state. Keep backups outside the repository and review `git diff` before publishing changes.

## License

[GNU General Public License v3.0](LICENSE).
