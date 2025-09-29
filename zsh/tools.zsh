# Tool configurations

# fzf - fuzzy finder
[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh
export FZF_DEFAULT_COMMAND='ag -g ""'
export FZF_DEFAULT_OPTS='--height 40% --reverse --border'

# tmux sessionizer
bindkey -s ^f "tmux-sessionizer\n"

# zoxide - smart cd
eval "$(zoxide init zsh)"

# nvm - Node Version Manager
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion