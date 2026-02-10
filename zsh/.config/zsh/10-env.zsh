# Environment Variables
export DOTFILES="$HOME/.dotfiles"
export TERM=xterm-256color
export GOPATH=$HOME/go
export GOARCH=arm64
export CGO_ENABLED=1
export CGO_LDFLAGS_ALLOW=.*
export ANDROID_NDK_HOME="/usr/local/share/android-ndk"
export KUBECONFIG="$HOME/.kube/config"
export SOPS_AGE_KEY_FILE=$HOME/.age/key.txt
export NVM_DIR="$HOME/.nvm"
export SDKMAN_DIR="/opt/homebrew/opt/sdkman-cli/libexec"
export FZF_BASE=/opt/homebrew/opt/fzf
export ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE='fg=8'

# PATH configuration
export PATH="/opt/homebrew/opt/curl/bin:/usr/local/kubebuilder/bin:${KREW_ROOT:-$HOME/.krew}/bin:/usr/local/bin/flutter/bin:$GOPATH/bin:/opt/homebrew/bin:/opt/homebrew/opt/libpq/bin:/opt/homebrew/opt/util-linux/bin:/opt/homebrew/opt/util-linux/sbin:$HOME/.local/bin:$HOME/.bin:$PATH"
