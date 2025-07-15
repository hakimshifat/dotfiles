# Track zsh startup time (optional)
# zsh_start_time=$EPOCHREALTIME

# Load zcomet
source ~/.zcomet/zcomet.zsh

# Enable zcomet cache for faster startup (optional)
# zcomet enable_cache

# Load your plugins via zcomet
zcomet load zsh-users/zsh-autosuggestions
zcomet load zsh-users/zsh-syntax-highlighting
zcomet load romkatv/powerlevel10k

# Source powerlevel10k config if exists
[[ -f ~/.p10k.zsh ]] && source ~/.p10k.zsh

# Editor based on SSH connection
if [[ -n $SSH_CONNECTION ]]; then
  export EDITOR='nvim'
else
  export EDITOR='vim'
fi

# Environment variables for Firefox acceleration
# export MOZ_X11_EGL=1
# export MOZ_WEBRENDER=1

# Aliases (from your old config)
alias timer="termdown"
alias ls="lsd"
alias le="ls -la"
alias e="exit"
alias gpt="tgpt -m"
alias cc="cpb clone"
alias op="xdg-open"
# alias cgbg="feh ~/Pictures/Wall --randomize --bg-fill"
alias ydl="yt-dlp -S 'res:720,fps:60' --merge-output-format mkv"
alias ydl7="yt-dlp -S 'res:720,fps:60' --merge-output-format mkv"
alias ydl1="yt-dlp -S 'res:1080,fps:60' --merge-output-format mkv"
alias mpa="mpv --no-video"
alias autopsy="autopsy --nosplash"
alias asml="/usr/include/asm"
alias stariac="aria2c --conf-path=/home/sifat/.config/aria2/aria2.conf --daemon"
alias ypl="yt-dlp -S 'res:720,fps:60' --merge-output-format mkv --yes-playlist --no-part --output '%(playlist_index)s - %(title)s.%(ext)s'"
alias ga='python /home/sifat/workstation/ghidra_auto.py'
alias ..="cd .."

# fzf integration
source <(fzf --zsh)

# Yazi function (your custom)
function yy() {
  local tmp="$(mktemp -t "yazi-cwd.XXXXXX")" cwd
  yazi "$@" --cwd-file="$tmp"
  if cwd="$(command cat -- "$tmp")" && [ -n "$cwd" ] && [ "$cwd" != "$PWD" ]; then
    builtin cd -- "$cwd"
  fi
  rm -f -- "$tmp"
}

# History settings
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

# Activate your python virtualenv automatically if present
# [[ -f ~/.venvs/base/bin/activate ]] && source ~/.venvs/base/bin/activate

# Track zsh startup time and show it (optional)
# zsh_end_time=$EPOCHREALTIME
# zsh_elapsed_time=$(awk "BEGIN {print $zsh_end_time - $zsh_start_time}")
# echo "⏱️ Zsh startup time: ${zsh_elapsed_time}s"

# pyenv init
export PATH="$HOME/.pyenv/bin:$PATH"
eval "$(pyenv init -)"
eval "$(pyenv virtualenv-init -)"



