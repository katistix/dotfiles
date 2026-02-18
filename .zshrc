# Path to your Oh My Zsh installation.
export ZSH="$HOME/.oh-my-zsh"

ZSH_THEME="robbyrussell"

# Which plugins would you like to load?
plugins=(git)

source $ZSH/oh-my-zsh.sh

# Initialize zoxide for smart cd
eval "$(zoxide init zsh)"

# Go binary path
export PATH=$PATH:$(go env GOPATH)/bin

export PATH="$PATH:$HOME/.pub-cache/bin"

# OpenCode CLI path
export PATH="$HOME/.opencode/bin:$PATH"

# Dotfiles scripts
export PATH="$HOME/dotfiles/scripts:$PATH"

# Kitty images
alias icat="kitten icat"

# Dotfiles navigation
alias df="cd ~/dotfiles"

alias pdf="zathura"

# Added by LM Studio CLI (lms)
export PATH="$PATH:/Users/paultal/.lmstudio/bin"
# End of LM Studio CLI section

# bun completions
[ -s "/Users/paultal/.bun/_bun" ] && source "/Users/paultal/.bun/_bun"

# bun
export BUN_INSTALL="$HOME/.bun"
export PATH="$BUN_INSTALL/bin:$PATH"

# nvm
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion
