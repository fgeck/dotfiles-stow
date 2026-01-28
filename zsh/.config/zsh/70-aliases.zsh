# Aliases

# ---- File listing (eza/bat) ----
alias l='eza --icons --group-directories-first -l'
alias ll='eza --icons --group-directories-first -l'
alias ls='eza --icons --group-directories-first'
alias la='ls -lah'
alias lh=la
alias cat='bat'

# ---- Docker ----
alias d='docker'
alias dsa='docker stop $(docker ps -q -a)'
alias drma='docker rm -f $(docker ps -q -a)'

# ---- Kubernetes ----
alias k='kubectl'
alias kg='kubectl get'
alias kgpo='kubectl get pods -o yaml'
alias kgdplo='kubectl get deployments -o yaml'
alias kgpvo='kubectl get pv -o yaml'
alias kgpvco='kubectl get pvc -o yaml'
alias kgo='kubectl get -o yaml'
alias kd='kubectl describe'
alias kl='kubectl logs -f'
alias kgp='kubectl get pods'
alias kdp='kubectl describe pod'
alias kdj='kubectl describe jobs.batch'
alias kgj='kubectl get jobs.batch'
alias kdcj='kubectl describe cronjobs.batch'
alias kgcj='kubectl get cronjobs.batch'
alias ktx='kubectx'

# ---- Git ----
alias g=git
alias gs='git status'
alias gf='git fetch'
alias gpl='git pull'
alias ga='git add'
alias gaa='git add --all'
alias gau='git add --updated'
alias gl="git log --graph --abbrev-commit --decorate --format=format:'%C(bold blue)%h%C(reset) - %C(bold cyan)%aD%C(reset) %C(bold green)(%ar)%C(reset)%C(bold yellow)%d%C(reset)%n'' %C(white)%s%C(reset) %C(dim white)- %an%C(reset)' --all"
alias glg="git log --graph --abbrev-commit --decorate --format=format:'%C(bold blue)%h%C(reset) - %C(bold cyan)%aD%C(reset) %C(bold green)(%ar)%C(reset)%C(bold yellow)%d%C(reset)%n'' %C(white)%s%C(reset) %C(dim white)- %an%C(reset)' --all"
alias lg1="git log --graph --abbrev-commit --decorate --format=format:'%C(bold blue)%h%C(reset) - %C(bold green)(%ar)%C(reset) %C(white)%s%C(reset) %C(dim white)- %an%C(reset)%C(bold yellow)%d%C(reset)' --all"
alias gfu='git fetch upstream; git checkout -B master origin/master'
alias gd='git diff'
alias gra='git remote add'
alias gc='git commit'
alias gca='git commit --amend'
alias gb='git branch'
alias gco='git checkout'
alias gcl='git clone'
alias gcms="git commit -m"
alias gp="git push"

pushit() {
    ga .
    gcms "$1"
    gp
    echo ""
    echo -e "\e[31mStatus after git push: \e[0m"
    echo ""
    gs
}

# ---- Go ----
goclean() {
    go mod tidy
    go fmt $(go list -find ./...)
    go vet $(go list -find ./...)
}

# ---- Apps ----
alias o='open'
alias c='code .'
alias ij='idea .'

# ---- Pipe shortcuts ----
alias -g G='| grep'
alias -g M='| less'
alias -g L='| wc -l'

# ---- Homebrew ----
# Wrapper to auto-update Brewfile on install/tap
brew() {
  local brewfile="$HOME/.config/homebrew/Brewfile"
  case "$1" in
    install)
      command brew "$@" && {
        if [[ "$2" == "--cask" ]]; then
          echo "cask \"$3\"" >> "$brewfile"
        else
          echo "brew \"$2\"" >> "$brewfile"
        fi
      }
      ;;
    tap)
      command brew "$@" && echo "tap \"$2\"" >> "$brewfile"
      ;;
    *)
      command brew "$@"
      ;;
  esac
}

# ---- Navigation ----
cddev() {
    cd $HOME/Develop/github.com/
}
