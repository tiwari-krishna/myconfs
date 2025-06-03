#Vi stuff
set -o vi
export MANPAGER='nvim +Man!'

# Set up fzf key bindings and fuzzy completion
eval "$(fzf --bash)"

#Archiver
ex ()
{
  if [ -f "$1" ] ; then
      case $1 in
         *.tar.bz2)   tar xjf $1   ;;
         *.tar.gz)    tar xzf $1   ;;
         *.bz2)       bunzip2 $1   ;;
         *.rar)       unrar x $1   ;;
         *.gz)        gunzip $1    ;;
         *.tar)       tar xf $1    ;;
         *.tbz2)      tar xjf $1   ;;
         *.tgz)       tar xzf $1   ;;
         *.zip)       unzip $1     ;;
         *.Z)         uncompress $1;;
         *.7z)        7z x $1      ;;
         *.deb)       ar x $1      ;;
         *.tar.xz)    tar xf $1    ;;
         *.tar.zst)   unzstd $1    ;;
         *)           echo "'$1' cannot be extracted via ex()" ;;
      esac
        else
      echo "'$1' is not a valid file"
   fi
}

#Aliases
alias ls='ls --color=always --group-directories-first'
alias grep='grep --color=auto'
alias ..='cd ..'
alias you-m4a="yt-dlp --extract-audio --audio-format m4a "
alias you-mp3="yt-dlp --extract-audio --audio-format mp3 "
alias you-best="yt-dlp -f bestvideo+bestaudio "
alias you-best-aud="yt-dlp --extract-audio --audio-format best "
alias lynx="lynx -vikeys"
alias mkins="sudo make clean install"
alias v="nvim "
alias vim="nvim "
alias svim="sudo nvim "
alias ka='killall '
alias pac='sudo pacman '
alias rm='rm -i'
alias q='exit'
alias pc='pandoc $1 -t beamer -o $($1 | sed 's/\.[^.]*$//').pdf'
alias sphone='ssh -p 8022 u0_a169@192.168.1.33'
alias mphone='sshfs u0_a169@192.168.1.33:storage /home/krishna/mnt/ -o follow_symlinks -p 8022'
alias cphis='cliphist list | wofi --dmenu | cliphist decode | wl-copy'

#export PS1="\[\e[01;31m\][\[\e[m\]\[\e[01;38;5;172m\]\u\[\e[m\]@\[\e[01;38;5;153m\]\h\[\e[m\] 󰥳 \[\e[01;38;5;214m\]\W\[\e[m\]\[\e[01;31m\]]\[\e[m\]\\$ "

function parse_git_dirty {
  STATUS="$(git status 2> /dev/null)"
  if [[ $? -ne 0 ]]; then printf ""; return; else printf " ["; fi
  if echo "${STATUS}" | grep -c "renamed:"         &> /dev/null; then printf " >"; else printf ""; fi
  if echo "${STATUS}" | grep -c "branch is ahead:" &> /dev/null; then printf " !"; else printf ""; fi
  if echo "${STATUS}" | grep -c "new file::"       &> /dev/null; then printf " +"; else printf ""; fi
  if echo "${STATUS}" | grep -c "Untracked files:" &> /dev/null; then printf " ?"; else printf ""; fi
  if echo "${STATUS}" | grep -c "modified:"        &> /dev/null; then printf " *"; else printf ""; fi
  if echo "${STATUS}" | grep -c "deleted:"         &> /dev/null; then printf " -"; else printf ""; fi
  printf " ]"
}

parse_git_branch() {
  git rev-parse --abbrev-ref HEAD 2> /dev/null
}

prompt_comment() {
    DIR="$HOME/.local/share/promptcomments/"
    MESSAGE="$(find "$DIR"/*.txt | shuf -n1)"
    cat "$MESSAGE"
}

export PS1="\[\e[1;31m\]\$(parse_git_branch)\[\033[34m\]\$(parse_git_dirty) \[\033[1;33m\] 󰥳 \[\e[1;37m\] \w \[\e[1;36m\]\[\e[0;37m\] "
