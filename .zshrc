nerdfetch
#neofetch

#only for p10k
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

export ZSH="$HOME/.oh-my-zsh"

#THEMES=("bira" "darkblood" "fox" "rkj-repos")

#ZSH_THEME="bira"
ZSH_THEME="powerlevel10k/powerlevel10k"


plugins=(
	zsh-syntax-highlighting
	zsh-autosuggestions
	git)

source $ZSH/oh-my-zsh.sh

# export LANG=en_US.UTF-8

 if [[ -n $SSH_CONNECTION ]]; then
   export EDITOR='nvim'
 else
   export EDITOR='vim'
 fi

# export ARCHFLAGS="-arch $(uname -m)"

alias le="ls -la"
alias e="exit"
alias gpt="tgpt"
alias cppp="cpb clone"
alias op="xdg-open"
alias cgbg="feh ~/Pictures/Wall --randomize --bg-fill"
alias ydl="yt-dlp -S 'res:720,fps:60' --merge-output-format mkv"
alias ydl7="yt-dlp -S 'res:720,fps:60' --merge-output-format mkv"
alias ydl1="yt-dlp -S 'res:1080,fps:60' --merge-output-format mkv"
alias mpa="mpv --no-video"
alias autopsy="autopsy --nosplash"

#fzf setting===============================
source <(fzf --zsh)
#fzf setting===============================

#Yazi Settings============================
function yy() {
	local tmp="$(mktemp -t "yazi-cwd.XXXXXX")" cwd
	yazi "$@" --cwd-file="$tmp"
	if cwd="$(command cat -- "$tmp")" && [ -n "$cwd" ] && [ "$cwd" != "$PWD" ]; then
		builtin cd -- "$cwd"
	fi
	rm -f -- "$tmp"
}
#Yazi Settings============================


#History Settings=======================================

## History file configuration
[ -z "$HISTFILE" ] && HISTFILE="$HOME/.zsh_history"
HISTSIZE=50000
SAVEHIST=10000

## History command configuration

# History file and size
[ -z "$HISTFILE" ] && HISTFILE="${XDG_CACHE_HOME:-$HOME/.cache}/zsh_history"
HISTSIZE=50000
SAVEHIST=10000

# History behavior options
setopt extended_history       # Record timestamps of commands
setopt hist_expire_dups_first # Delete duplicates first when history exceeds HISTSIZE
setopt hist_ignore_dups       # Ignore duplicate commands in the same session
setopt hist_ignore_space      # Ignore commands that start with a space
setopt hist_reduce_blanks     # Remove superfluous blanks before saving commands
setopt hist_verify            # Show expanded history commands before execution
setopt inc_append_history     # Append commands to history immediately
setopt append_history         # Append rather than overwrite history
setopt share_history          # Share history between all sessions

# History formatting
export HISTTIMEFORMAT="%F %T "

# Ignore specific commands in history
export HISTIGNORE="ls:cd:exit:pwd:bg:fg:clear:e"


#History Settings=======================================

# Created by `pipx` on 2024-11-03 18:04:02
export PATH="$PATH:&HOME/.local/bin"
export PATH=$HOME/.local/bin:$PATH

# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh

#================== sothat conda is available for every session
[ -f /opt/miniconda3/etc/profile.d/conda.sh ] && source /opt/miniconda3/etc/profile.d/conda.sh

export CRYPTOGRAPHY_OPENSSL_NO_LEGACY=1

#===========================================================================
#if ! pgrep -u "$USER" ssh-agent > /dev/null 2>&1; then
#  eval "$(ssh-agent -s)" > /dev/null
#fi
#ssh-add -l > /dev/null 2>&1 || ssh-add ~/.ssh/id_ed25519 > /dev/null 2>&1

#============================================================================
