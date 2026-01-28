#!/usr/bin/env bash
set -euo pipefail

DOTFILES_DIR="$(cd "$(dirname "$0")" && pwd)"

# Ask about brew packages
read -p "Install brew packages from Brewfile? [y/N] " -n 1 -r
echo
if [[ $REPLY =~ ^[Yy]$ ]]; then
  echo "Installing brew packages..."
  brew bundle --global  # uses ~/.config/homebrew/Brewfile
fi

# Check for stow
if ! command -v stow &> /dev/null; then
  echo "GNU Stow not found. Install with: brew install stow"
  exit 1
fi

# Create directories that need to hold files from multiple stow packages
# This allows work dotfiles to add files alongside public dotfiles
mkdir -p ~/.config/zsh ~/.config/gh ~/.config/tmux

# Stow all packages
packages=(brew zsh git starship bin aerospace borders ghostty tmux nvim sketchybar skhd kanata gh scripts)

for pkg in "${packages[@]}"; do
  echo "Stowing $pkg..."
  stow -v --no-folding -t "$HOME" "$pkg"
done

# Install tmux plugin manager if not present
if [[ ! -d "$HOME/.tmux/plugins/tpm" ]]; then
  echo "Installing tmux plugin manager..."
  git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm
  echo "Run 'prefix + I' in tmux to install plugins"
fi

# Symlink aerospace config (choose your setup)
if [[ ! -L "$HOME/.config/aerospace/aerospace.toml" ]]; then
  echo ""
  echo "Aerospace: symlink one of the configs to aerospace.toml:"
  echo "  ln -sf aerospace-mba.toml ~/.config/aerospace/aerospace.toml   # MacBook Air"
  echo "  ln -sf aerospace-mbp-1.toml ~/.config/aerospace/aerospace.toml # MBP 1 monitor"
  echo "  ln -sf aerospace-mbp-2.toml ~/.config/aerospace/aerospace.toml # MBP 2 monitors"
fi

echo ""
echo "Done! Restart your shell or run: source ~/.zshrc"
