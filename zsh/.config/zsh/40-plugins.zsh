# Plugins and tools initialization

# Starship prompt
eval "$(starship init zsh)"

# Zsh plugins (installed via homebrew)
source /opt/homebrew/share/zsh-autosuggestions/zsh-autosuggestions.zsh
source /opt/homebrew/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
source /opt/homebrew/opt/fzf-tab/share/fzf-tab/fzf-tab.zsh

# Autosuggestion strategy
ZSH_AUTOSUGGEST_STRATEGY=(history completion)

# Zoxide (fast cd)
eval "$(zoxide init zsh)"

# FZF
[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh
