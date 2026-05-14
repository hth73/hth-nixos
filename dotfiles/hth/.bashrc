# Commands that should be applied only for interactive shells.
[[ $- == *i* ]] || return

# Color manpages
[[ -f ~/.LESS_TERMCAP ]] && source ~/.LESS_TERMCAP

# Start ssh-agent
if [ -z "$SSH_AUTH_SOCK" ]; then
  eval "$(ssh-agent -s)"
fi

alias sshl='grep -slR "PRIVATE" "$HOME/.ssh/" 2>/dev/null | xargs -r ssh-add'

# command-line fuzzy finder
eval "$(fzf --bash)"

# enable starship
eval "$(starship init bash)"

# Debug Promt
export PS4=$'|(${BASH_SOURCE##*/}:${LINENO}):\t${FUNCNAME[0]:+${FUNCNAME[0]}(): }'

# Verzeichnis erstellen und hinein wechseln
mkcd() {
  mkdir -pv "$1" && cd "$1"
}

HISTFILESIZE=100000
HISTSIZE=10000
HISTTIMEFORMAT="%d %B %H:%M:%S> "
HISTORY_IGNORE="(ls|la|ll|cd*|pwd|exit|h|history*|x|clear*|up|ver|app*|cfg|disk|update|sc|av|pull)"
SAVEHIST=$HISTSIZE

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
alias cfg='vi ~/.bashrc'
alias cmount='mount | column -t'
alias disk='sudo ncdu'
alias h=history
alias ipcalc='ipcalc --nocolor'
alias ls=eza
alias la='ls -lagoh --git --git-repos --group-directories-first'
alias ll='ls -lagoh --total-size --git --group-directories-first'
alias reboot='sudo reboot'
alias services='sudo systemctl list-units --type=service --state=running'
alias shutdown='sudo shutdown -h now'
alias up=uptime
alias ver=fastfetch
alias vi=nvim

alias ff='fd --type f | fzf'
alias vf='nvim "$(fd -tf | fzf --preview "bat --color=always --style=plain {}")"'

# ohne flake
# alias nrs='sudo nixos-rebuild switch'

# mit flake
nrs() {
  sudo nixos-rebuild switch --flake .#"$(hostname -s)"
}

nrb() {
  sudo nixos-rebuild dry-build --flake .#"$(hostname -s)"
}

nru() {
  nix flake update
  sudo nixos-rebuild switch --flake .#"$(hostname -s)"
}

