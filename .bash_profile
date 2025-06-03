export BROWSER="librewolf"
export EDITOR="nvim"
#export TERMINAL="alacritty"
export TERMINAL="footclient"
export HISTCONTROL=ignoredups:erasedups
export HISTFILE=$HOME/.cache/bashHist
export TERM="xterm-256color"
[[ $- != *i* ]] && return

export QT_QPA_PLATFORMTHEME=gtk3
#export QT_QPA_PLATFORM="wayland"
export GTK_THEME=Breeze-Dark
export MOZ_USE_XINPUT2="1"
#export _JAVA_AWT_WM_NONREPARENTING=1

export GTK_IM_MODULE=ibus
export QT_IM_MODULE=ibus
export XMODIFIERS=@im=ibus

#export MOZ_ENABLE_WAYLAND=1
#export XDG_CURRENT_DESKTOP="qtile"

source /etc/profile
#export PATH=$HOME/.local/bin/:$PATH
export PATH=$PATH$( find $HOME/.local/bin/ -type d -printf ":%p" )
export XDG_CONFIG_HOME=$HOME/.config
export XDG_DATA_HOME=$HOME/.local/share
export XDG_CACHE_HOME=$HOME/.cache
export XINITRC=${XDG_CONFIG_HOME:-$HOME/.config}/x11/xinitrc

if [ -f ~/.bashrc ]; then
    source ~/.bashrc
fi

#[ "$(tty)" = "/dev/tty1" ] && ! pidof -s Xorg >/dev/null 2>&1 && exec dbus-launch Hyprland
#[ "$(tty)" = "/dev/tty1" ] && ! pidof -s Xorg >/dev/null 2>&1 && exec startx $XINITRC
#[ "$(tty)" = "/dev/tty1" ] && exec /usr/lib/plasma-dbus-run-session-if-needed /usr/bin/startplasma-wayland
[ "$(tty)" = "/dev/tty1" ] && exec dbus-launch Hyprland
#[ "$(tty)" = "/dev/tty1" ] && exec start-cosmic
