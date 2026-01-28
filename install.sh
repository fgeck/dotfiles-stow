#!/usr/bin/env bash
set -euo pipefail

DOTFILES_DIR="$(cd "$(dirname "$0")" && pwd)"

# Check for stow
if ! command -v stow &> /dev/null; then
  echo "GNU Stow not found. Install with: brew install stow"
  exit 1
fi

# Create directories that need to hold files from multiple stow packages
# This allows work dotfiles to add files alongside public dotfiles
mkdir -p ~/.config/zsh ~/.config/gh ~/.config/tmux

# Stow all packages
packages=(zsh git starship bin aerospace borders ghostty tmux nvim sketchybar gh)

for pkg in "${packages[@]}"; do
  echo "Stowing $pkg..."
  stow -v "$pkg"
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
