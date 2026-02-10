# Additional plugins and tools initialization
# Note: Starship, FZF, and Zoxide are now handled by oh-my-zsh plugins

# Zsh plugins (installed via homebrew)
# These are kept from homebrew for easier updates (brew upgrade)
source /opt/homebrew/share/zsh-autosuggestions/zsh-autosuggestions.zsh
source /opt/homebrew/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh

# Autosuggestion strategy
ZSH_AUTOSUGGEST_STRATEGY=(history completion)
