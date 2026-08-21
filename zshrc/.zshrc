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

# Start tmux automatically.
zstyle ':z4h:' start-tmux  'system'

# Mark up shell's output with semantic information.
zstyle ':z4h:' term-shell-integration 'yes'

# Right-arrow key accepts one character ('partial-accept') from
# command autosuggestions or the whole thing ('accept')?
zstyle ':z4h:autosuggestions' forward-char 'accept'

# Recursively traverse directories when TAB-completing files.
zstyle ':z4h:fzf-complete' recurse-dirs 'no'

# Enable direnv to automatically source .envrc files.
zstyle ':z4h:direnv'         enable 'no'
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
path=(~/bin $path)

# Export environment variables.
export GPG_TTY=$TTY

# Source additional local files if they exist.
z4h source ~/.env.zsh

# Use additional Git repositories pulled in with `z4h install`.
#
# This is just an example that you should delete. It does nothing useful.
# z4h source ohmyzsh/ohmyzsh/lib/diagnostics.zsh  # source an individual file
# z4h load   ohmyzsh/ohmyzsh/plugins/emoji-clock  # load a plugin

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
alias tree='tree -a -I .git'

# Add flags to existing aliases.
alias ls="${aliases[ls]:-ls} -A"
alias cd="z"
alias e="exit"

# Set shell options: http://zsh.sourceforge.net/Doc/Release/Options.html.
setopt glob_dots     # no special treatment for file names with a leading dot
setopt no_auto_menu  # require an extra TAB press to open the completion menu

#================================================personal===============
function yy() {
  local tmp="$(mktemp "${TMPDIR:-/tmp}/yazi-cwd.XXXXXX")" cwd
  yazi "$@" --cwd-file="$tmp"
  if cwd="$(< "$tmp")" && [[ -n "$cwd" && "$cwd" != "$PWD" ]]; then
    builtin cd -- "$cwd"
  fi
  rm -f -- "$tmp"
}
# Start aria2c in RPC daemon mode
alias ar='aria2c --conf-path="$HOME/.config/aria2/aria2.conf" --enable-rpc --daemon=true &'
MOZ_ENABLE_WAYLAND=1
export HTB_TOKEN="eyJ0eXAiOiJKV1QiLCJhbGciOiJSUzI1NiJ9.eyJhdWQiOiI1IiwianRpIjoiOGM2YmVlMGEzYTMwNTRiMTdmOWUxYjdiYzI4NDA4MjcwYzE4N2VlYTU0YmM0Y2NiMWI4ZDllZjlmZDZlMDdhN2E3MTlkNDQ5Y2IzYmY2ZDQiLCJpYXQiOjE3Nzk2OTE2MDguNzg4Mzk3LCJuYmYiOjE3Nzk2OTE2MDguNzg4Mzk5LCJleHAiOjE4MTEyMjc2MDguNzgxNzAzLCJzdWIiOiIyMzkyNTIzIiwic2NvcGVzIjpbXX0.T_FL4UTlq-upYyOCC4rPW-_LkhZb9e1GD6iBQ9vci4G2KORixPGfsmMhKBtIGFsZbpfubjhTya2j_13_NGakSyZo2JVfdd_z8ii4yy6c-w1OX2y1CJcgyi_R6HZxAdMWt-ERoXjefaBBlh7ylEc-aF_i2jcgXG3V6_OXmkWIplC26MHDAZ9oc7AxBK_g8DbiLsOthW31MsDUhS_76oZ-jEDQlc6fwUf-AWL5BB-FBaHhysev4DLlTjUBX-LbIzt16ow7v43Bzyy-NB639VNthlK4eHJuSonAQF1IQSNPyyWVr4JKCL8u3RBdeKxVT8gcNEoydJ_3CbO52pOTBKBQZVkOjSzMng8fKFbUf6Rm1DkA5oqoA16NuO_rAKs-4odWWfzt-lyPlm5V1rbXr5XWp-sciI-T8t0YNpzjlKyLGjU0zBcv6CkyhI53dXVlu11gjlCJo8C7UU5RtTsoGIzlFvtiaRIDF4LIuqsdVBEXKSJrkHATHYlZUWHK2FJn2Da3fpKP4j6Ml_Ettt8QID30JTPDlVfFzdmLuiFty2PfhnL1ljGEZ6fcrwKCf_AgQPKNf7fZSeqm1kqP8CvEJ2VAUUMfn2nOc2aZanj3mK-6YsnY02gzoV9YqAre3mLORfoeQ47yAGGG04DwDwPVCvGfedHWO55vrQBoiSW4d4Vkp-8"

if [[ $XDG_SESSION_TYPE == "wayland" ]]; then
  export QT_QPA_PLATFORM=xcb
  export _JAVA_AWT_WM_NONREPARENTING=1
  export GDK_BACKEND=x11
fi
eval "$(zoxide init zsh)"
source ~/.env

# export CLAUDE_CODE_USE_OPENAI=1
# export OPENAI_API_KEY=sk-your-key-here
# export OPENAI_API_KEY="freellmapi-ea8055f035f5d92415ca6df58cf2e2105fd4fa50e4a1f504"
# Base URL
# http://localhost:3001/v1
# Chat
# /v1/chat/completions
# Responses
# /v1/responses
# Embeddings
# /v1/embeddings — model: "auto" or a family from the Embeddings tab
#

# For Wayland sessions ($XDG_SESSION_TYPE is "wayland")
# export GTK_IM_MODULE=wayland
# export XMODIFIERS=@im=ibus
# export QT_IM_MODULES=wayland;ibus
# export QT_IM_MODULE=ibus





# alias phonecam='scrcpy \
#   --video-source=camera \
#   --camera-id=1 \
#   --camera-size=1280x720 \
#   --camera-fps=30 \
#   --video-codec=h264 \
#   --video-encoder=c2.mtk.avc.encoder \
#   --video-bit-rate=3M \
#   --v4l2-sink=/dev/video10 \
#   --no-playback \
#   --no-audio'
# export PATH="/home/sifat/.local/bin:$PATH"
#

phonecam() {
    # Check if /dev/video10 exists. If not, load the module.
    if [ ! -e /dev/video10 ]; then
        echo "📷 Loading PhoneCam virtual device..."
        sudo modprobe v4l2loopback video_nr=10 card_label="PhoneCam" exclusive_caps=1
    fi
    
    # Run scrcpy (includes -s to prevent the "Multiple ADB devices" error)
        scrcpy \
      --video-source=camera \
      --camera-id=1 \
      --camera-size=1280x720 \
      --camera-fps=30 \
      --video-codec=h264 \
      --video-encoder=c2.mtk.avc.encoder \
      --video-bit-rate=3M \
      --v4l2-sink=/dev/video10 \
      --no-playback \
      --no-audio
}
