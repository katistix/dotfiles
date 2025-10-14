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

# OpenCode CLI path
export PATH=/Users/paultal/.opencode/bin:$PATH

# Dotfiles scripts
export PATH="$HOME/dotfiles/scripts:$PATH"

# Neovim aliases
alias vim="nvim"
alias vi="nvim"


# Kitty images
alias icat="kitten icat"

# Dotfiles navigation
alias df="cd ~/dotfiles"


