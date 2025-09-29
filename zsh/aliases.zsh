# Aliases
alias vim="nvim"
alias reload='source ~/.zshrc'

# cd to folder return by fzf
alias fcd='cd $(find . -type d -print | fzf)'
alias pcd='cd $(find ~/projects -type d -name ".git" -prune -exec dirname {} \; | fzf)'

# Git aliases
alias glog='git log --graph --oneline --decorate --all'

# List aliases
alias lsl='ls -l'