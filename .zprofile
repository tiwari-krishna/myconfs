export BROWSER="librewolf"
export EDITOR="nvim"
export TERMINAL="footclient"
export TERM="xterm-256color"
export LANG=en_US.UTF-8
export LC_ALL=en_US.UTF-8

# Exit if not an interactive shell
[[ $- != *i* ]] && return

export GOPATH=$HOME/.local/share/go/
export MOZ_USE_XINPUT2="1"
# export _JAVA_AWT_WM_NONREPARENTING=1

export GTK_IM_MODULE=ibus
export QT_IM_MODULE=ibus
export XMODIFIERS=@im=ibus

export GTK_THEME=Breeze-Dark
export MOZ_ENABLE_WAYLAND=1
export XCURSOR_SIZE=24
export XCURSOR_THEME="Breeze Light"
export QT_QPA_PLATFORM="wayland"
export QT_QPA_PLATFORMTHEME=gtk3

# export XDG_CURRENT_DESKTOP=sway
# export XDG_SESSION_TYPE=wayland
# export XDG_SESSION_DESKTOP=sway

source /etc/profile

# Add all directories under ~/.local/bin to PATH
export PATH=$PATH$(find $HOME/.local/bin/ -type d -printf ":%p")

export XDG_CONFIG_HOME=$HOME/.config
export XDG_DATA_HOME=$HOME/.local/share
export XDG_CACHE_HOME=$HOME/.cache
export XINITRC=${XDG_CONFIG_HOME:-$HOME/.config}/x11/xinitrc

export ZDOTDIR=$HOME/.config/zsh

if [[ -f $ZDOTDIR/.zshrc ]]; then
    source $ZDOTDIR/.zshrc
fi

# Start Hyprland on tty1 if no Xorg is running
if [[ "$(tty)" == "/dev/tty1" ]]; then
    exec dbus-launch sway
fi
