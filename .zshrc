nerdfetch
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

export ZSH="$HOME/.oh-my-zsh"

#ZSH_THEME="robbyrussell"
ZSH_THEME="powerlevel10k/powerlevel10k"

plugins=(
	zsh-syntax-highlighting
	zsh-autosuggestions
	git)

source $ZSH/oh-my-zsh.sh

# export LANG=en_US.UTF-8

 if [[ -n $SSH_CONNECTION ]]; then
   export EDITOR='vim'
 else
   export EDITOR='nvim'
 fi

# export ARCHFLAGS="-arch $(uname -m)"

alias le="ls -la"
alias e="exit"
alias gpt="tgpt"
alias cppp="cpb clone"

# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh

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
setopt extended_history       # record timestamp of command in HISTFILE
setopt hist_expire_dups_first # delete duplicates first when HISTFILE size exceeds HISTSIZE
setopt hist_ignore_dups       # ignore duplicated commands history list
setopt hist_ignore_space      # ignore commands that start with space
setopt hist_verify            # show command with history expansion to user before running it
setopt inc_append_history     # add commands to HISTFILE in order of execution
setopt share_history          # share command history data
#History Settings=======================================

# Created by `pipx` on 2024-11-03 18:04:02
export PATH="$PATH:/home/sifat/.local/bin"
