# dotfiles

My personal dotfiles, managed with [GNU Stow](https://www.gnu.org/software/stow/).

## Structure

```
dotfiles/
├── zsh/         # Zsh config (modular, loads from ~/.config/zsh/)
├── git/         # Git configuration
├── starship/    # Starship prompt theme
├── bin/         # Custom shell scripts
├── scripts/     # Setup scripts (macOS defaults)
├── aerospace/   # Aerospace tiling window manager
├── borders/     # Window borders for aerospace
├── ghostty/     # Ghostty terminal config
├── tmux/        # Tmux config
├── nvim/        # Neovim config
├── sketchybar/  # Sketchybar status bar
├── gh/          # GitHub CLI config
└── Brewfile     # Homebrew packages
```

## Install

```bash
# Clone
git clone https://github.com/fgeck/dotfiles-stow.git ~/dotfiles

# Install all brew packages + stow configs
cd ~/dotfiles
./install.sh --brew

# Or just stow configs (if brew packages already installed)
./install.sh
```

## Brewfile

Install all packages with:
```bash
brew bundle --file=Brewfile
```

## How it works

Stow creates symlinks from the repo to your home directory:
- `dotfiles/zsh/.zshrc` → `~/.zshrc`
- `dotfiles/nvim/.config/nvim/` → `~/.config/nvim/`

The `.zshrc` loads all `~/.config/zsh/*.zsh` files in order (10, 20, 30...).

## Aerospace setup

Symlink the config for your setup:
```bash
cd ~/.config/aerospace
ln -sf aerospace-mba.toml aerospace.toml    # MacBook Air
ln -sf aerospace-mbp-1.toml aerospace.toml  # MBP + 1 monitor
ln -sf aerospace-mbp-2.toml aerospace.toml  # MBP + 2 monitors
```
