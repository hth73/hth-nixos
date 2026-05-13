# Color manpages
[[ -f ~/.LESS_TERMCAP ]] && source ~/.LESS_TERMCAP

# SSH-Agent starten und alle privaten Schlüssel laden
if [ -z "$SSH_AUTH_SOCK" ]; then
  eval "$(ssh-agent -s)"
  grep -slR "PRIVATE" "$HOME/.ssh/" 2>/dev/null | xargs -r ssh-add
fi

# Debug Promt
export PS4=$'|(${BASH_SOURCE##*/}:${LINENO}):\t${FUNCNAME[0]:+${FUNCNAME[0]}(): }'

# Funktion: Verzeichnis erstellen und hinein wechseln
mkcd() {
  mkdir -pv "$1" && cd "$1"
}


# Commands that should be applied only for interactive shells.
[[ $- == *i* ]] || return

HISTFILESIZE=100000
HISTSIZE=10000

shopt -s histappend
shopt -s extglob
shopt -s globstar
shopt -s checkjobs

alias ..='cd ..'
alias ...='cd ../..'
alias ....='cd ../../..'
alias .....='cd ../../../..'
alias av='freshclam --version'
alias cat='bat --plain --paging=never'
alias cfg='vim ~/.bashrc'
alias cmount='mount | column -t'
alias d='dirs -v | head -10'
alias disk='sudo ncdu'
alias h=history
alias ipcalc='ipcalc --nocolor'
alias la='ls -lagoh --git --git-repos'
alias ll='ls -lagoh --total-size --git'
alias ls=eza
alias nrs='sudo nixos-rebuild switch'
alias reboot='sudo reboot'
alias services='sudo systemctl list-units --type=service --state=running'
alias shutdown='sudo shutdown -h now'
alias up=uptime
alias ver=fastfetch
alias vi=vim

if [[ ! -v BASH_COMPLETION_VERSINFO ]]; then
  . "/nix/store/czv02wicy8w7y11sx18zq9lnqxsbj3pc-bash-completion-2.17.0/etc/profile.d/bash_completion.sh"
fi

