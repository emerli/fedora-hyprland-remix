# .bash_profile - sourced for login shells

# Source .bashrc if it exists
[[ -f ~/.bashrc ]] && . ~/.bashrc

# Assicura che il prompt custom sopravviva agli override di sistema
PROMPT_COMMAND='__build_ps1'
