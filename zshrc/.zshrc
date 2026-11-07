# Personal Zsh configuration file. It is strongly recommended to keep all
# shell customization and configuration (including exported environment
# variables such as PATH) in this file or in files sourced from it.
#
# Documentation: https://github.com/romkatv/zsh4humans/blob/v5/README.md.

# Periodic auto-update on Zsh startup: 'ask' or 'no'.
# You can manually run `z4h update` to update everything.
zstyle ':z4h:' auto-update      'no'
# Ask whether to auto-update this often; has no effect if auto-update is 'no'.
zstyle ':z4h:' auto-update-days '28'

# Keyboard type: 'mac' or 'pc'.
zstyle ':z4h:bindkey' keyboard  'pc'

# Keep terminal and console shells independent. Start or attach to tmux
# explicitly with `tmux` when a persistent session is wanted.
# zstyle ':z4h:' start-tmux 'system'
zstyle ':z4h:' start-tmux 'no'

# Whether to move prompt to the bottom when zsh starts and on Ctrl+L.
zstyle ':z4h:' prompt-at-bottom 'no'

# Mark up shell's output with semantic information.
zstyle ':z4h:' term-shell-integration 'yes'

# Right-arrow key accepts one character ('partial-accept') from
# command autosuggestions or the whole thing ('accept')?
zstyle ':z4h:autosuggestions' forward-char 'accept'

# Recursively traverse directories when TAB-completing files.
zstyle ':z4h:fzf-complete' recurse-dirs 'no'

# Enable direnv to automatically source .envrc files.
zstyle ':z4h:direnv'         enable 'yes'
# Show "loading" and "unloading" notifications from direnv.
zstyle ':z4h:direnv:success' notify 'yes'

# Enable ('yes') or disable ('no') automatic teleportation of z4h over
# SSH when connecting to these hosts.
zstyle ':z4h:ssh:example-hostname1'   enable 'yes'
zstyle ':z4h:ssh:*.example-hostname2' enable 'no'
# The default value if none of the overrides above match the hostname.
zstyle ':z4h:ssh:*'                   enable 'no'

# Send these files over to the remote host when connecting over SSH to the
# enabled hosts.
zstyle ':z4h:ssh:*' send-extra-files '~/.nanorc' '~/.env.zsh'

# Clone additional Git repositories from GitHub.
#
# This doesn't do anything apart from cloning the repository and keeping it
# up-to-date. Cloned files can be used after `z4h init`. This is just an
# example. If you don't plan to use Oh My Zsh, delete this line.
z4h install ohmyzsh/ohmyzsh || return

# Install or update core components (fzf, zsh-autosuggestions, etc.) and
# initialize Zsh. After this point console I/O is unavailable until Zsh
# is fully initialized. Everything that requires user interaction or can
# perform network I/O must be done above. Everything else is best done below.
z4h init || return

# Extend PATH.
path=(~/.local/bin $path)
export PATH="$PATH":"$HOME/.pub-cache/bin"
export PATH="$PATH":"$HOME/go/bin"

# Export environment variables.
export GPG_TTY=$TTY

# Source additional local files if they exist.
z4h source ~/.env.zsh

# Use additional Git repositories pulled in with `z4h install`.
#
# This is just an example that you should delete. It does nothing useful.
z4h source ohmyzsh/ohmyzsh/lib/diagnostics.zsh  # source an individual file
z4h load   ohmyzsh/ohmyzsh/plugins/emoji-clock  # load a plugin

# Define key bindings.
z4h bindkey z4h-backward-kill-word  Ctrl+Backspace     Ctrl+H
z4h bindkey z4h-backward-kill-zword Ctrl+Alt+Backspace

z4h bindkey undo Ctrl+/ Shift+Tab  # undo the last command line change
z4h bindkey redo Alt+/             # redo the last undone command line change

z4h bindkey z4h-cd-back    Alt+Left   # cd into the previous directory
z4h bindkey z4h-cd-forward Alt+Right  # cd into the next directory
z4h bindkey z4h-cd-up      Alt+Up     # cd into the parent directory
z4h bindkey z4h-cd-down    Alt+Down   # cd into a child directory

# Autoload functions.
autoload -Uz zmv

# Define functions and completions.
function md() { [[ $# == 1 ]] && mkdir -p -- "$1" && cd -- "$1" }
compdef _directories md

# Define named directories: ~w <=> Windows home directory on WSL.
[[ -z $z4h_win_home ]] || hash -d w=$z4h_win_home

# Define aliases.
alias tree=' tree -a -I .git'

# Add flags to existing aliases.
alias ls=" ${aliases[ls]:-ls} -A"
alias e=" exit"

# Launch agent CLIs from their project directory.
# These must be functions, not aliases. An alias body that ends with the alias
# name is re-expanded at the `&&`, so `codex` recursed into itself forever.
# codex() { builtin cd -- /home/sifat/workstation/agent/codex/ && command codex "$@" }
# opencode() { builtin cd -- /home/sifat/workstation/agent/opencode/ && command opencode "$@" }

# No `alias cd=" z"` here on purpose. zoxide's `z` jumps to frecused
# directories, so routing `cd` through it breaks `cd -` and turns typos into
# silent jumps to some other directory. Type `z <dir>` when you want a jump.

function yy() {
  local tmp="$(mktemp "${TMPDIR:-/tmp}/yazi-cwd.XXXXXX")" cwd
  yazi "$@" --cwd-file="$tmp"
  if cwd="$(< "$tmp")" && [[ -n "$cwd" && "$cwd" != "$PWD" ]]; then
    builtin cd -- "$cwd"
  fi
  rm -f -- "$tmp"
}
# Set shell options: http://zsh.sourceforge.net/Doc/Release/Options.html.
setopt glob_dots     # no special treatment for file names with a leading dot
setopt no_auto_menu  # require an extra TAB press to open the completion menu
# eval "$(mise activate zsh)"
eval "$(zoxide init zsh --cmd cd)"


# ==============================================================================
# Auto-activate / Auto-deactivate Python Virtual Environments
# ==============================================================================
auto_python_venv() {
  local venv_dir
  local check_dir="$PWD"

  # Walk up the directory tree to find .venv or venv
  # (Keeps virtualenv active when navigating into subdirectories)
  while [[ "$check_dir" != "/" ]]; do
    if [[ -d "$check_dir/.venv" ]]; then
      venv_dir="$check_dir/.venv"
      break
    elif [[ -d "$check_dir/venv" ]]; then
      venv_dir="$check_dir/venv"
      break
    fi
    check_dir="$(dirname "$check_dir")"
  done

  # Process activation/deactivation logic
  if [[ -n "$venv_dir" ]]; then
    # If in a different virtualenv, deactivate it first
    if [[ -n "$VIRTUAL_ENV" && "$VIRTUAL_ENV" != "$venv_dir" ]]; then
      deactivate 2>/dev/null
    fi
    # Activate target environment if not active
    if [[ -z "$VIRTUAL_ENV" ]]; then
      source "$venv_dir/bin/activate"
    fi
  else
    # Left the project directory tree; deactivate
    if [[ -n "$VIRTUAL_ENV" ]]; then
      deactivate 2>/dev/null
    fi
  fi
}

# Attach function to Zsh directory change hook array safely
autoload -U add-zsh-hook

# ---------------------------------------------------------------------------
# Ghidra: fix blank/white window under non-parenting Wayland compositors
# (niri, Sway). Ghidra ships this fix commented out in support/launch.properties.
# See ~/.local/bin/ghidra-fixed for the full explanation.
# ---------------------------------------------------------------------------
alias op='xdg-open'

