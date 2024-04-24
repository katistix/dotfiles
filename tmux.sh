# Install the Tmux Package Manager
git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm
# Source the tmux file
tmux source ~/.config/tmux/tmux.conf
# Use the tpm script to automatically install the plugins
~/.config/tmux/plugins/tpm/scripts/install_plugins.sh


