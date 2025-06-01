# dotfiles

- those are my dotfiles
- the idea behind this setup is to keep things as simple as possible,
without fancy setups

## installation

### requirements - (in the future there will be an install script with zero dependencies)

```bash
# since MacOS comes with older bash version, we need to install some dependencies
# in order for the tmux setup to work properly
brew install bash bc coreutils gawk gh glab gsed jq nowplaying-cli
```

- brew
- git
- stow
- neovim
- aerospace

```bash
# Clone the repository
git clone https://github.com/katistix/dotfiles.git ~/dotfiles/
```

```bash
# Load the symlinks using stow
stow dotfiles
```
