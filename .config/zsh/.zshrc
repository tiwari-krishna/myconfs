# Enable vi mode in Zsh
bindkey -v

# Use nvim for man pages
export MANPAGER='nvim +Man!'

# USE LF TO SWITCH DIRECTORIES AND BIND IT TO CTRL-O
lfcd () {
    tmp="$(mktemp)"
    lf -last-dir-path="$tmp" "$@"
    if [ -f "$tmp" ]; then
        dir="$(cat "$tmp")"
        rm -f "$tmp"
        [ -d "$dir" ] && [ "$dir" != "$(pwd)" ] && cd "$dir"
    fi
}
bindkey -s '^o' 'lfcd\n'

# Set up fzf key bindings and fuzzy completion (Zsh version)
[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh

# fzf fuzzy finder keybindings (Ctrl-R for history search)
if [[ -f /usr/share/fzf/key-bindings.zsh ]]; then
  source /usr/share/fzf/key-bindings.zsh
fi

precmd() { print -Pn "\e]0;%n@%m: %~\a" }

# Completion
autoload -Uz compinit
compinit

# Cache completion results for faster response
zstyle ':completion::complete:*' use-cache on
zstyle ':completion::complete:*' cache-path ~/.cache/zsh/cache

# ---- Archiver Function ----
ex() {
  if [[ -f "$1" ]]; then
    case "$1" in
      *.tar.bz2)   tar xjf "$1"   ;;
      *.tar.gz)    tar xzf "$1"   ;;
      *.bz2)       bunzip2 "$1"   ;;
      *.rar)       unrar x "$1"   ;;
      *.gz)        gunzip "$1"    ;;
      *.tar)       tar xf "$1"    ;;
      *.tbz2)      tar xjf "$1"   ;;
      *.tgz)       tar xzf "$1"   ;;
      *.zip)       unzip "$1"     ;;
      *.Z)         uncompress "$1";;
      *.7z)        7z x "$1"      ;;
      *.deb)       ar x "$1"      ;;
      *.tar.xz)    tar xf "$1"    ;;
      *.tar.zst)   unzstd "$1"    ;;
      *)           echo "'$1' cannot be extracted via ex()" ;;
    esac
  else
    echo "'$1' is not a valid file"
  fi
}

# ---- Aliases ----
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
alias pc='pandoc $1 -t beamer -o $(${1%.*}).pdf'
alias sphone='ssh -p 8022 u0_a169@192.168.1.33'
alias mphone='sshfs u0_a169@192.168.1.33:storage /home/krishna/mnt/ -o follow_symlinks -p 8022'
alias cphis='cliphist list | wofi --dmenu | cliphist decode | wl-copy'

# ---- Git Prompt Helpers ----
parse_git_dirty() {
  STATUS="$(git status 2>/dev/null)"
  if [[ $? -ne 0 ]]; then
    printf ""
    return
  else
    printf " ["
  fi
  [[ "$STATUS" =~ "renamed:"         ]] && printf " >"
  [[ "$STATUS" =~ "branch is ahead:" ]] && printf " !"
  [[ "$STATUS" =~ "new file:"        ]] && printf " +"
  [[ "$STATUS" =~ "Untracked files:" ]] && printf " ?"
  [[ "$STATUS" =~ "modified:"        ]] && printf " *"
  [[ "$STATUS" =~ "deleted:"         ]] && printf " -"
  printf " ]"
}

parse_git_branch() {
  git rev-parse --abbrev-ref HEAD 2>/dev/null
}

prompt_comment() {
  DIR="$HOME/.local/share/promptcomments/"
  MESSAGE="$(find "$DIR"/*.txt | shuf -n1)"
  cat "$MESSAGE"
}

# ---- Prompt ----
setopt PROMPT_SUBST
PROMPT='%B%F{red}$(parse_git_branch) %F{blue}$(parse_git_dirty)%F{yellow} 󰥳  %F{white}%~ %F{cyan}$%f%b '

# History Stuff
export HISTFILE=$HOME/.cache/zshHist
HISTSIZE=10000
SAVEHIST=10000
setopt INC_APPEND_HISTORY
setopt SHARE_HISTORY
setopt HIST_IGNORE_DUPS
setopt HIST_IGNORE_ALL_DUPS
setopt HIST_FIND_NO_DUPS
setopt HIST_IGNORE_SPACE
setopt CORRECT

# ---- Autosuggestions ----
# source /usr/share/zsh/plugins/zsh-autosuggestions/zsh-autosuggestions.zsh

# ---- Syntax Highlighting ----
# source /usr/share/zsh/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
