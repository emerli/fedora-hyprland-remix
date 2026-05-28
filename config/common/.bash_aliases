# Navigation
alias ll='ls -lah --color=auto'
alias la='ls -A --color=auto'
alias l='ls -CF --color=auto'
alias ..='cd ..'
alias ...='cd ../..'

# Git
alias gs='git status'
alias ga='git add'
alias gc='git commit'
alias gp='git push'
alias gl='git log --oneline --graph --decorate'
alias gd='git diff'

# Podman (docker-compatible aliases)
alias docker='podman'
alias docker-compose='podman-compose'

# System
alias update='rpm-ostree upgrade'
alias ports='ss -tulanp'
alias myip='curl -s ifconfig.me'

# Safety nets
alias rm='rm -i'
alias cp='cp -i'
alias mv='mv -i'
