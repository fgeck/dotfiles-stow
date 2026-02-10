# Oh-My-Zsh Configuration
# Managed with GNU Stow: https://github.com/fgeck/dotfiles

# Load environment and PATH first (needed for oh-my-zsh plugins to detect tools)
[ -f ~/.config/zsh/10-env.zsh ] && source ~/.config/zsh/10-env.zsh

# Path to oh-my-zsh installation
export ZSH="$HOME/.oh-my-zsh"

# Oh-my-zsh performance settings
ZSH_COMPDUMP="$ZSH/cache/.zcompdump-$HOST"  # Cache completions
DISABLE_AUTO_UPDATE=true                     # Don't check for updates on every shell start
ZSH_DISABLE_COMPFIX=true                     # Skip insecure directory checks (faster startup)

# Plugins to load (order matters for some plugins)
plugins=(
  # === Version Control ===
  git                          # Git aliases and functions
  gh                           # GitHub CLI completions and aliases

  # === History ===
  history                      # History aliases (h, hsi, hs)
  history-substring-search     # Search history with up/down arrows

  # === Development Tools ===
  tmux                         # tmux aliases and session management
  docker-compose               # Docker-compose completions
  kubectx                      # kubectx/kubens completions
  fluxcd                       # FluxCD completions
  task                         # go-task completions (Taskfile.yml)
  nvm                          # NVM with lazy loading
  npm                          # NPM aliases (npmg, npmS, etc.)
  # === Prompt & Navigation ===
  starship                     # Starship prompt init
  fzf                          # FZF keybindings (Ctrl-R, Ctrl-T, Alt-C)
  zoxide                       # Zoxide integration (z command)

  # === macOS Integration ===
  brew                         # Homebrew aliases and completion
  macos                        # macOS utilities (ofd, showfiles, hidefiles)

  # === Productivity ===
  sudo                         # Press ESC twice to prepend sudo
  extract                      # Smart extraction: extract file.tar.gz

  # === Quality of Life ===
  colored-man-pages            # Colored man pages
  command-not-found            # Suggests packages for missing commands
)

# Load Oh My Zsh
source $ZSH/oh-my-zsh.sh

# Load remaining modular configs from ~/.config/zsh/
for config in ~/.config/zsh/{20-plugins,30-aliases}.zsh(N); do
  source "$config"
done
