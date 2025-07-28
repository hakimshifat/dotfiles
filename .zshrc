# -------------------- Powerlevel10k Instant Prompt --------------------
# Should stay close to the top of ~/.zshrc.
# Any initialization requiring console input must go above this.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

# -------------------- Antidote Plugin Manager -------------------------
ZSH_ANTIDOTE="/usr/share/zsh-antidote"
source "$ZSH_ANTIDOTE/antidote.zsh"

# Initialize Zsh completion system (required before plugins using compdef)
autoload -Uz compinit
compinit

# Load plugins
# Either precompiled .zsh or dynamic load
# source ~/.zsh_plugins.zsh
antidote load < ~/.zsh_plugins.txt

# -------------------- Function: Yazi Directory Return -----------------
function yy() {
  local tmp="$(mktemp "${TMPDIR:-/tmp}/yazi-cwd.XXXXXX")" cwd
  yazi "$@" --cwd-file="$tmp"
  if cwd="$(< "$tmp")" && [[ -n "$cwd" && "$cwd" != "$PWD" ]]; then
    builtin cd -- "$cwd"
  fi
  rm -f -- "$tmp"
}

# -------------------- Shell History Settings --------------------------
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

# -------------------- Environment Variables ---------------------------
# For IDA and Ghidra to work properly under Wayland
if [[ $XDG_SESSION_TYPE == "wayland" ]]; then
  export QT_QPA_PLATFORM=xcb
  export _JAVA_AWT_WM_NONREPARENTING=1
  export GDK_BACKEND=x11
fi

# -------------------- Aliases -----------------------------------------
alias ..="cd .."
alias e="exit"
alias history="history 1"
alias timer="termdown"
alias b="$HOME/.config/scripts/bluetooth.sh"
alias pp="source ~/ctf/bin/activate"
alias ga="$HOME/.config/scripts/ghidra.py"

# yt-dlp shortcuts
alias ydl7='yt-dlp -f "bv[height=720]+ba/b[height=720]" -o "%(title)s.%(ext)s" --ignore-errors'
alias ydl10='yt-dlp -f "bv[height=1080]+ba/b[height=1080]" -o "%(title)s.%(ext)s" --ignore-errors'

# Start aria2c in RPC daemon mode
alias ar='aria2c --conf-path="$HOME/.config/aria2/aria2.conf" --enable-rpc --daemon=true &'

# -------------------- Powerlevel10k Theme -----------------------------
[[ -f ~/.p10k.zsh ]] && source ~/.p10k.zsh
# MOZ_ENABLE_WAYLAND=1

#------------------------ android
# source /etc/profile

# -------------------- Notes / Reminders -------------------------------
# Run on Android (Shizuku):
# ./adb shell sh /storage/emulated/0/Android/data/moe.shizuku.privileged.api/start.sh

# Decompile APK:
# jadx -d hacker_app_java hacker_app.apk


