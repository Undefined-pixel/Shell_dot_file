#!/bin/zsh
# ~~~~~~~~~~~~~~~os~~~~~~~~~~~~~~~~~~~~~~~~
OS=$(uname)
if [[ "$OS" == "Darwin" ]]; then
  result="macOS"
elif [[ "$OS" == "Linux" ]]; then
  result="Linux"
else
  result="Windoof"
fi
# === Zsh History Configuration ===
HISTFILE=~/.zsh_history     # Where to store your command history
HISTSIZE=10000000           # Number of commands to keep in memory
SAVEHIST=10000000           # Number of commands to save to the history file

# === Recommended Options ===
setopt APPEND_HISTORY        # Append new commands to the history file instead of overwriting it
setopt INC_APPEND_HISTORY    # Write commands to the history file immediately, not only when exiting
setopt SHARE_HISTORY         # Share command history across all running Zsh sessions in real-time
setopt HIST_IGNORE_DUPS      # Don’t record a command if it’s the same as the previous one
setopt HIST_IGNORE_ALL_DUPS  # Remove older duplicate entries, keeping only the most recent
setopt HIST_IGNORE_SPACE     # Don’t store commands that start with a space
setopt HIST_REDUCE_BLANKS    # Remove extra spaces from commands before saving
setopt HIST_SAVE_NO_DUPS     # Don’t save duplicate entries to the history file
# ~~~~~~~~~~~~~~~ zsh mini config  ~~~~~~~~~~~~~~~~~~~~~~~~
zsh_basic_config(){
    autoload -U colors && colors
    autoload -Uz vcs_info
    precmd() { vcs_info }
    zstyle ':vcs_info:git:*' formats '%b '
    setopt PROMPT_SUBST
    PROMPT='%F{green}%*%f %F{blue}%~%f %F{red}${vcs_info_msg_0_}%f$ '
}

# ~~~~~~~~~~~~~~~colors for simple shell ~~~~~~~~~~~~~~~~~~~~~~~~
if [ -n "$SSH_CONNECTION" ]; then
    echo "You are connected via SSH."
    zsh_basic_config
else
    if [[ ! -f ~/.p10k.zsh ]]; then 
    zsh_basic_config
    fi
    echo "You are not connected via SSH."
fi
# ~~~~~~~~~~~~~~~vim zsh stuff ~~~~~~~~~~~~~~~~~~~~~~~~
setVimForShell(){
bindkey -v
export KEYTIMEOUT=1

# Edit line in vim with ctrl-e:
autoload edit-command-line; zle -N edit-command-line
bindkey '^e' edit-command-line

# Change cursor shape for different vi modes.
function zle-keymap-select {
  if [[ ${KEYMAP} == vicmd ]] ||
     [[ $1 = 'block' ]]; then
    echo -ne '\e[1 q'
  elif [[ ${KEYMAP} == main ]] ||
       [[ ${KEYMAP} == viins ]] ||
       [[ ${KEYMAP} = '' ]] ||
       [[ $1 = 'beam' ]]; then
    echo -ne '\e[5 q'
  fi
}
}

isVIMSet() {
  bool_value=$1
  if [ "$bool_value" = "true" ]; then
    echo "set Vim Config"
    setVimForShell
  else
    echo "Dont set Vim Config"
  fi
}

isVIMSet false 
# ~~~~~~~~~~~~~~~key input speed~~~~~~~~~~~~~~~~~~~~~~~~
if [[ "$OSTYPE" == "linux-gnu"* ]]; then
    if command -v gsettings &> /dev/null; then
        gsettings set org.gnome.desktop.peripherals.keyboard repeat-interval 30
        gsettings set org.gnome.desktop.peripherals.keyboard delay 500
    else
        echo "is not gnome"
    fi
        # setting for sound in terminal 
        setterm -blength 0
elif [[ "$OSTYPE" == "darwin"* ]]; then
    echo "macOS"
   	#doesnt work at the moment
    defaults write NSGlobalDomain KeyRepeat -int 2
    defaults write NSGlobalDomain InitialKeyRepeat -int 15
    killall Finder
else
	echo "no os maybe windows ?"
fi

# ~~~~~~~~~~~~~helper function~~~~~~~~~~~~~~~~~~~~~~~~~~
myip(){
    # Internal IP Lookup.
    if command -v ip &> /dev/null; then
        active_interface=$(ifconfig | grep -B1 "inet " | grep -E "^[a-zA-Z]" | awk '{print $1}')
        echo -n "Internal IP: "
        ip addr show $active_interface | grep "inet " | awk '{print $2}' | cut -d/ -f1
    else
        active_interface=$(ifconfig | grep -B1 "inet " | grep -E "^[a-zA-Z]" | awk '{print $1}')
        echo -n "Internal IP: "
        ifconfig $active_interface | grep "inet " | awk '{print $2}'
    fi

    # External IP Lookup
    echo -n "External IP: "
    curl -s ifconfig.me
}

extract() {
	for archive in "$@"; do
		if [ -f "$archive" ]; then
			case $archive in
			*.tar.bz2) tar xvjf $archive ;;
			*.tar.gz) tar xvzf $archive ;;
			*.bz2) bunzip2 $archive ;;
			*.rar) rar x $archive ;;
			*.gz) gunzip $archive ;;
			*.tar) tar xvf $archive ;;
			*.tbz2) tar xvjf $archive ;;
			*.tgz) tar xvzf $archive ;;
			*.zip) unzip $archive ;;
			*.Z) uncompress $archive ;;
			*.7z) 7z x $archive ;;
			*) echo "don't know how to extract '$archive'..." ;;
			esac
		else
			echo "'$archive' is not a valid file!"
		fi
	done
}

# Searches for text in all files in the current folder
ftext() {
	# -i case-insensitive
	# -I ignore binary files
	# -H causes filename to be printed
	# -r recursive search
	# -n causes line number to be printed
	# optional: -F treat search term as a literal, not a regular expression
	# optional: -l only print filenames and not the matching lines ex. grep -irl "$1" *
	grep -iIHrn --color=always "$1" . | less -r
}

# Copy file with a progress bar
cpp() {
    set -e
    strace -q -ewrite cp -- "${1}" "${2}" 2>&1 |
    awk '{
        count += $NF
        if (count % 10 == 0) {
            percent = count / total_size * 100
            printf "%3d%% [", percent
            for (i=0;i<=percent;i++)
                printf "="
            printf ">"
            for (i=percent;i<100;i++)
                printf " "
            printf "]\r"
        }
    }
    END { print "" }' total_size="$(stat -c '%s' "${1}")" count=0
}
# ~~~~~~~~~~~~~~ranger setup~~~~~~~~~~~~~~~~~~~~~~~~~
rangercd () {
    tmp="$(mktemp)"
    ranger --choosedir="$tmp" "$@"
    if [ -f "$tmp" ]; then
        dir="$(cat "$tmp")"
        rm -f "$tmp"
        if [ -d "$dir" ] && [ "$dir" != "$(pwd)" ]; then
            cd "$dir"
        fi
    fi
}
bindkey -s '^o' 'rangercd\n'
# ~~~~~~~~~~~~~~~standart editor~~~~~~~~~~~~~~~~~~~~~~~~
export EDITOR=vim;
# ~~~~~~~~~~~~~~~~bind history key again ~~~~~~~~~~~~~~~~~~~~~~~
bindkey '^R' history-incremental-search-backward
# ~~~~~~~~~~~~~~~~plugin with omy zsh ~~~~~~~~~~~~~~~~~~~~~~~
if [[ "$ZSH_THEME=" != "" ]]; then
         plugins=(aliases sudo history vscode git docker docker-compose zsh-syntax-highlighting)
    fi
# ~~~~~~~~~~~~~~~settings for tmux ~~~~~~~~~~~~~~~~~~~~~~~
chpwd() {
    if [[ -n "$TMUX" ]]; then
		tmux rename-window "$(basename "$PWD")"
		 fi
	}
tstart() {
    tmux new-session -A -s "$result"
}
# ~~~~~~~~~~~~~~~~alisa for shell~~~~~~~~~~~~~~~~~~~~~~~
alias home='cd ~'
alias t='tmux'
alias e='exit'
alias c='clear'
alias lastmod='find . -type f -not -path "*/\.*" -exec ls -lrt {} +'
alias grep='grep --color=auto'
alias fgrep='fgrep --color=auto'
alias egrep='egrep --color=auto'
alias ll='ls -alF'
alias la='ls -A'
alias l='ls -CF'
alias ls="ls -ph --color=auto"
alias cp='cp -i'
alias rm='rm -i'
alias mv='mv -i'
alias less='less -R'
alias g='git'
alias wetter="curl http://v3.wttr.in/Hessen.sxl; sleep 5; curl http://v1.wttr.in/Wolfsburg"
alias eZ="vim ~/.zshrc"
alias eV="vim ~/.vimrc"
alias eZc="vim ~/.config/.myshellconfig.sh"
alias vi='vim'
alias vim='vim'
alias v='vim'
alias p3='python3'
if command -v bat &> /dev/null; then 
    alias cat='bat --color=always'
elif command -v batcat &> /dev/null; then  
    alias cat='batcat --color=always'
fi
if [[ "$OSTYPE" == "linux-gnu"* ]]; then
  alias os='lsb_release -a'
  alias open="nautilus"
  alias eS="vim ~/.config/sway/config"
fi
# Add an "alert" alias for long running commands.  Use liVke so:
#   sleep 10; alert
alias alert='notify-send --urgency=low -i "$([ $? = 0 ] && echo terminal || echo error)" "$(history|tail -n1|sed -e '\''s/^\s*[0-9]\+\s*//;s/[;&|]\s*alert$//'\'')"'
# alias to show the date
alias da='date "+%Y-%m-%d %A %T %Z"'
# Search command line history
alias h="history | grep "
# Search running processes
alias p="ps aux | grep "
alias topcpu="/bin/ps -eo pcpu,pid,user,args | sort -k 1 -r | head -10"
# ~~~~~~~~~~~~~~fzf setup~~~~~~~~~~~~~~~~~~~~~~~~~
if command -v fzf &>/dev/null; then    
        ### SET FZF DEFAULTS
        export FZF_DEFAULT_OPTS="--layout=reverse --exact --border=bold --border=rounded --margin=3% --color=dark"
        ### FZF ###
        # Enables the following keybindings:
        # CTRL-t = fzf select
        # CTRL-r = fzf history doesnt work on mac
        # ALT-c  = fzf cd ->doesnt work on mac
        source <(fzf --zsh)
        alias fzvim='fzf --multi --preview="bat --color=always --style=full {}" --bind "space:toggle-preview,enter:execute(vim {} < /dev/tty)"'
fi
# ~~~~~~~~~~~~~~~info~~~~~~~~~~~~~~~~~~~~~~~~
if [[ -z "$TMUX" ]]; then
    if command -v fastfetch &>/dev/null; then    
        alias fetch=fastfetch
    elif command -v neofetch &>/dev/null; then
        alias fetch=neofetch
    else
    fi   
fi
# ~~~~~~~~~~~~~~~clear ~~~~~~~~~~~~~~~~~~~~~~~
clear 

