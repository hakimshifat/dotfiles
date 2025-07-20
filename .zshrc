# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block; everything else may go below.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

# ---- Antidote plugin manager ----
source '/usr/share/zsh-antidote/antidote.zsh'

# Initialize Zsh completion system (required before plugins that use `compdef`)
autoload -Uz compinit
compinit

# Load plugins
source ~/.zsh_plugins.zsh
# antidote load < ~/.zsh_plugins.txt

#=====================================================================
function yy() {
  local tmp="$(mktemp -t "yazi-cwd.XXXXXX")" cwd
  yazi "$@" --cwd-file="$tmp"
  if cwd="$(command cat -- "$tmp")" && [ -n "$cwd" ] && [ "$cwd" != "$PWD" ]; then
    builtin cd -- "$cwd"
  fi
  rm -f -- "$tmp"
}
#=====================================================================

#=====================================================================
HISTFILE="${XDG_CACHE_HOME:-$HOME/.cache}/zsh_history"
HISTSIZE=1000000
SAVEHIST=$HISTSIZE
HISTORY_IGNORE="(ls|cd|pwd|exit|clear|bg|fg)"
setopt APPEND_HISTORY
setopt EXTENDED_HISTORY
setopt INC_APPEND_HISTORY
setopt SHARE_HISTORY
setopt HIST_IGNORE_DUPS
setopt HIST_IGNORE_ALL_DUPS
setopt HIST_EXPIRE_DUPS_FIRST
setopt HIST_SAVE_NO_DUPS
setopt HIST_IGNORE_SPACE
setopt HIST_REDUCE_BLANKS
setopt HIST_VERIFY
export HISTTIMEFORMAT="%F %T "
#=====================================================================

#=====================================================================
alias timer="termdown"
alias ..="cd .."
alias b="~/.config/waybar/scripts/bluetooth.sh"
alias e="exit"
alias b="~/.config/waybar/scripts/bluetooth.sh"
#=====================================================================
 # source ctf/bin/activate
# ---- Powerlevel10k theme ----
[[ -f ~/.p10k.zsh ]] && source ~/.p10k.zsh

