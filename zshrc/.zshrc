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

# SSH teleportation is disabled for every host (this is the default). To enable
# it for a host add `zstyle ':z4h:ssh:<host>' enable 'yes'`; extra files can be
# sent with `zstyle ':z4h:ssh:*' send-extra-files <files>...`.
zstyle ':z4h:ssh:*' enable 'no'

# Install or update core components (fzf, zsh-autosuggestions, etc.) and
# initialize Zsh. After this point console I/O is unavailable until Zsh
# is fully initialized. Everything that requires user interaction or can
# perform network I/O must be done above. Everything else is best done below.
z4h init || return

# Extend PATH. zsh4humans keeps the `path` array unique (`typeset -aUT`), so
# listing an entry twice is harmless.
path=(~/.kilo/bin ~/.opencode/bin ~/.local/bin $path)
path+=("$HOME/.pub-cache/bin" "$HOME/go/bin")

# Export environment variables. GPG needs the real terminal device, not $TTY
# (which is usually empty), or pinentry/commit signing fails.
[[ -t 0 ]] && export GPG_TTY=$(tty)

# Source additional local files if they exist.
z4h source ~/.env.zsh

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
md() {
  emulate -L zsh
  [[ $# -eq 1 ]] || { print -u2 -- 'usage: md <directory>'; return 1 }
  mkdir -p -- "$1" && cd -- "$1"
}
compdef _directories md

# Define named directories: ~w <=> Windows home directory on WSL.
[[ -z $z4h_win_home ]] || hash -d w="$z4h_win_home"

# Define aliases.
alias tree=' tree -a -I .git'
alias op='xdg-open'  # open a file, directory or URL with the default app

# Add flags to existing aliases. The guard keeps this idempotent when the file
# is sourced more than once (e.g. `source ~/.zshrc`).
[[ ${aliases[ls]} == *" -A"* ]] || alias ls=" ${aliases[ls]:-ls} -A"
alias e=" exit"

# Launch agent CLIs from their project directory.
# These must be functions, not aliases. An alias body that ends with the alias
# name is re-expanded at the `&&`, so `codex` recursed into itself forever.
# codex() { builtin cd -- /home/sifat/workstation/agent/codex/ && command codex "$@" }
# opencode() { builtin cd -- /home/sifat/workstation/agent/opencode/ && command opencode "$@" }

yy() {
  emulate -L zsh
  local tmp cwd
  tmp=$(mktemp "${TMPDIR:-/tmp}/yazi-cwd.XXXXXX") || return
  yazi "$@" --cwd-file="$tmp"
  if cwd=$(< "$tmp") && [[ -n $cwd && $cwd != $PWD ]]; then
    builtin cd -- "$cwd"
  fi
  rm -f -- "$tmp"
}

# Set shell options: http://zsh.sourceforge.net/Doc/Release/Options.html.
setopt glob_dots     # no special treatment for file names with a leading dot
setopt no_auto_menu  # require an extra TAB press to open the completion menu

# `zoxide init` defines `z` and `zi` only; `cd` stays the builtin. Do not use
# `--cmd cd`: fuzzy-jumping from `cd` turns typos into silent jumps and shadows
# `cd -`. Type `z <dir>` when you want to jump.
# eval "$(mise activate zsh)"
(( $+commands[zoxide] )) && eval "$(zoxide init zsh --cmd cd)"

# ==============================================================================
# Auto-activate / Auto-deactivate Python Virtual Environments
# ==============================================================================
# Set only when this hook performed the activation, so a virtualenv started by
# hand outside a project is never torn down behind your back.
typeset -g _auto_venv=

auto_python_venv() {
  emulate -L zsh
  local dir=$PWD venv=

  # Walk up the directory tree to find .venv or venv. Walking up keeps the
  # environment active while navigating inside the project.
  while [[ -n $dir ]]; do
    if [[ -d $dir/.venv ]]; then
      venv=$dir/.venv
      break
    elif [[ -d $dir/venv ]]; then
      venv=$dir/venv
      break
    fi
    [[ $dir == / ]] && break
    dir=${dir:h}  # parent directory, no fork
  done

  if [[ -n $venv ]]; then
    # A different environment is active: leave it before activating the target.
    if [[ -n $VIRTUAL_ENV && ${VIRTUAL_ENV:A} != ${venv:A} ]]; then
      deactivate 2>/dev/null
      _auto_venv=
    fi
    if [[ -z $VIRTUAL_ENV && -f $venv/bin/activate ]]; then
      source -- "$venv/bin/activate"
      _auto_venv=1
    fi
  elif [[ -n $VIRTUAL_ENV && -n $_auto_venv ]]; then
    # Left the project tree: only undo what this hook did.
    deactivate 2>/dev/null
    _auto_venv=
  fi
}

autoload -Uz add-zsh-hook
add-zsh-hook chpwd auto_python_venv
auto_python_venv  # the shell may start inside a project
export at="ctfd_46d3c05a41701709d5735dbfce2ff546269b777ce2d6b821fc40a5ee6abbe6bb"

