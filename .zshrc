# Path to your oh-my-zsh installation.
export ZSH="./.oh-my-zsh"

ZSH_THEME="robbyrussell"

plugins=(git)

source $ZSH/oh-my-zsh.sh

# For tkinter 
export PATH="/usr/local/opt/tcl-tk/bin:$PATH"

# pnpm
export PNPM_HOME="/Users/paultal/Library/pnpm"
case ":$PATH:" in
  *":$PNPM_HOME:"*) ;;
  *) export PATH="$PNPM_HOME:$PATH" ;;
esac
# pnpm end



# For laravel
export PATH=$PATH:/Users/paultal/.composer/vendor/bin


# Herd injected PHP binary.
export PATH="/Users/paultal/Library/Application Support/Herd/bin/":$PATH


# Herd injected PHP 8.2 configuration.
export HERD_PHP_82_INI_SCAN_DIR="/Users/paultal/Library/Application Support/Herd/config/php/82/"


# Herd injected NVM configuration
export NVM_DIR="/Users/paultal/Library/Application Support/Herd/config/nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm

[[ -f "/Applications/Herd.app/Contents/Resources/config/shell/zshrc.zsh" ]] && builtin source "/Applications/Herd.app/Contents/Resources/config/shell/zshrc.zsh"

[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh


export SDKROOT="$(xcrun --sdk macosx --show-sdk-path)"


eval "$(zoxide init zsh)"

