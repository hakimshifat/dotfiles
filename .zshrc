#only for p10k
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

export ZSH="$HOME/.oh-my-zsh"

#============================================================================
#for firefox acceleartion

export MOZ_X11_EGL=1
export MOZ_WEBRENDER=1

#============================================================================

#THEMES=("bira" "darkblood" "fox" "rkj-repos")

# ZSH_THEME="bira"
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
alias timer="termdown"
alias le="ls -la"
alias e="exit"
alias gpt="tgpt -m"
alias cc="cpb clone"
alias op="xdg-open"
alias cgbg="feh ~/Pictures/Wall --randomize --bg-fill"
alias ydl="yt-dlp -S 'res:720,fps:60' --merge-output-format mkv"
alias ydl7="yt-dlp -S 'res:720,fps:60' --merge-output-format mkv"
alias ydl1="yt-dlp -S 'res:1080,fps:60' --merge-output-format mkv"
alias mpa="mpv --no-video"
alias autopsy="autopsy --nosplash"
alias asml="/usr/include/asm"
alias stariac="aria2c --conf-path=/home/sifat/.config/aria2/aria2.conf --daemon"
alias ypl="yt-dlp -S 'res:720,fps:60' --merge-output-format mkv --yes-playlist --no-part --output '%(playlist_index)s - %(title)s.%(ext)s'"
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
# History Settings

## History file and size
[ -z "$HISTFILE" ] && HISTFILE="${XDG_CACHE_HOME:-$HOME/.cache}/zsh_history"
HISTSIZE=50000
SAVEHIST=50000

# Ignore specific commands in history
export HISTIGNORE="ls:cd:exit:pwd:bg:fg:clear:e"
# History behavior options
setopt extended_history       # Record timestamps of commands
setopt hist_expire_dups_first # Delete duplicates first when history exceeds HISTSIZE
setopt hist_ignore_dups       # Ignore duplicate commands in the same session
setopt hist_ignore_space      # Ignore commands that start with a space
setopt hist_reduce_blanks     # Remove superfluous blanks before saving commands
setopt hist_verify            # Show expanded history commands before execution
setopt inc_append_history     # Append commands to history immediately
setopt share_history          # Share history between all sessions
# History formatting
export HISTTIMEFORMAT="%F %T "

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

if command -v zoxide > /dev/null; then
  eval "$(zoxide init zsh)"
fi

export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion
# Source the Lazyman shell initialization for aliases and nvims selector
# shellcheck source=.config/nvim-Lazyman/.lazymanrc
[ -f ~/.config/nvim-Lazyman/.lazymanrc ] && source ~/.config/nvim-Lazyman/.lazymanrc
# Source the Lazyman .nvimsbind for nvims key binding
# shellcheck source=.config/nvim-Lazyman/.nvimsbind
[ -f ~/.config/nvim-Lazyman/.nvimsbind ] && source ~/.config/nvim-Lazyman/.nvimsbind
export PATH="$HOME/.cargo/bin:$PATH"

