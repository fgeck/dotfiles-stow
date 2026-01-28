# Minimal .zshrc - loads modular configs from ~/.config/zsh/
# Managed with GNU Stow: https://github.com/fgeck/dotfiles

for config in ~/.config/zsh/*.zsh(N); do
  source "$config"
done
