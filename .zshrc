# Path to your Oh My Zsh installation.
export ZSH="$HOME/.oh-my-zsh"

ZSH_THEME="robbyrussell"

# Which plugins would you like to load?
plugins=(git)

source $ZSH/oh-my-zsh.sh


eval "$(zoxide init zsh)"

# nvim aliases
alias nvim='NVIM_APPNAME="nvim-lazy" nvim'
alias nvimai='NVIM_APPNAME="nvim-ai" nvim'

export PATH=$PATH:$(go env GOPATH)/bin
export PATH="/Users/paultal/.config/herd-lite/bin:$PATH"
export PHP_INI_SCAN_DIR="/Users/paultal/.config/herd-lite/bin:$PHP_INI_SCAN_DIR"
