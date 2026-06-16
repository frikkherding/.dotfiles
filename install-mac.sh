#!/bin/bash

echo "Installing packages..."

# Homebrew
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

# Terminal Tools
brew install bat eza fzf git htop zoxide zsh the_silver_searcher tree wget ripgrep stow z
brew install lazygit lazydocker 
brew install neovim mdcat starship stow zellij git-delta tmux
brew install 1password-cli

# GUI Applications
brew install --cask nikitabobko/tap/aerospace ghostty
brew install caffeine alt-tab linearmouse raycast hiddenbar

brew install spotify vlc

# Fonts
brew install font-fira-mono-nerd-font font-hack-nerd-font font-jetbrains-mono-nerd-font font-jetbrains-mono

# Zap Package manager for zsh
zsh <(curl -s https://raw.githubusercontent.com/zap-zsh/zap/master/install.zsh) --branch release-v1

# Install rust
curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh

# Set up bat cache
bat cache --build

# Info
echo "Remember to run fzf install script. See their installation instructions"
echo ""
echo "Applications to install manually: Docker Desktop, IntelliJ, OpenVpn, Ableton, Jottacloud, VsCode"
echo "Applications to install with npm -g: aws-cdk, aws-cdk-local, vercel"
echo ""
echo "Done!"

