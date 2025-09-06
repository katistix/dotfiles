# Path to your Oh My Zsh installation.
export ZSH="$HOME/.oh-my-zsh"

ZSH_THEME="robbyrussell"

# Which plugins would you like to load?
plugins=(git)

source $ZSH/oh-my-zsh.sh


# Auto-start zellij if not already in a session
if [[ -z "$ZELLIJ" ]]; then
    if [[ "$TERM_PROGRAM" != "vscode" ]]; then
        zellij attach --create
    fi
fi

eval "$(zoxide init zsh)"

# nvim aliases
alias nvim='NVIM_APPNAME="nvim-lazy" /opt/homebrew/bin/nvim'
alias nvimm='NVIM_APPNAME="nvim-minimal" /opt/homebrew/bin/nvim'
alias npm='pnpm'

export PATH=$PATH:$(go env GOPATH)/bin
export PATH="/Users/paultal/.config/herd-lite/bin:$PATH"
export PHP_INI_SCAN_DIR="/Users/paultal/.config/herd-lite/bin:$PHP_INI_SCAN_DIR"

# Added by LM Studio CLI (lms)
export PATH="$PATH:/Users/paultal/.lmstudio/bin"
# End of LM Studio CLI section

# opencode
export PATH=/Users/paultal/.opencode/bin:$PATH

# bun completions
[ -s "/Users/paultal/.bun/_bun" ] && source "/Users/paultal/.bun/_bun"

# bun
export BUN_INSTALL="$HOME/.bun"
export PATH="$BUN_INSTALL/bin:$PATH"

export ANDROID_HOME=$HOME/Library/Android/sdk
export PATH=$PATH:$ANDROID_HOME/emulator
export PATH=$PATH:$ANDROID_HOME/platform-tools
