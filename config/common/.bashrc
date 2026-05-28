# .bashrc - sourced for interactive non-login shells

# If not running interactively, don't do anything
case $- in
    *i*) ;;
      *) return;;
esac

# History settings
HISTSIZE=10000
HISTFILESIZE=20000
HISTCONTROL=ignoreboth
shopt -s histappend

# Update window size after each command
shopt -s checkwinsize

# Prompt - Powerline style (richiede JetBrains Mono Nerd Font)
__ps1_git() {
    local branch
    branch=$(git branch 2>/dev/null | grep '^\*' | colrm 1 2)
    [ -z "$branch" ] && return
    local icon_dirty=$'\uf06a'   # fa-exclamation-circle
    git diff --quiet 2>/dev/null && git diff --cached --quiet 2>/dev/null \
        && echo " $branch" || echo " $branch ${icon_dirty}"
}

__build_ps1() {
    local branch
    branch=$(__ps1_git)

    local c_dir='\[\e[38;2;53;185;171m\]'    # teal
    local c_git='\[\e[38;2;180;140;90m\]'    # ambra tenue
    local c_dim='\[\e[38;2;100;100;100m\]'   # grigio scuro
    local reset='\[\e[0m\]'

    if [ -n "$branch" ]; then
        PS1="${c_dir}\w${reset} ${c_dim}·${reset} ${c_git}${branch}${reset} ${c_dim}❯${reset} "
    else
        PS1="${c_dir}\w${reset} ${c_dim}❯${reset} "
    fi
}

PROMPT_COMMAND='__build_ps1'

# Podman rootless socket
export DOCKER_HOST="unix://${XDG_RUNTIME_DIR}/podman/podman.sock"

# Source aliases
[[ -f ~/.bash_aliases ]] && . ~/.bash_aliases

# Enable bash completion
if ! shopt -oq posix; then
  if [ -f /usr/share/bash-completion/bash_completion ]; then
    . /usr/share/bash-completion/bash_completion
  elif [ -f /etc/bash_completion ]; then
    . /etc/bash_completion
  fi
fi
