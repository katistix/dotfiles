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

# Neovim aliases
alias vim="nvim"
alias vi="nvim"


# Kitty images
alias icat="kitten icat"

# Dotfiles navigation
alias df="cd ~/dotfiles"

# University subject jumper using fzf
uni() {
    local subject_dir=$(find ~/data/school/uni -maxdepth 1 -type d -name "sem*" | sed 's|.*/||' | fzf --prompt="Select subject: " --height=40% --reverse)
    if [[ -n $subject_dir ]]; then
        cd ~/data/school/uni/$subject_dir
    fi
}
