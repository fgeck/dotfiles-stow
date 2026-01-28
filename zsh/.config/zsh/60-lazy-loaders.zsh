# Lazy-load heavy tools for faster shell startup

# ---- NVM ----
nvm() {
  unset -f nvm node npm npx
  [ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"
  nvm "$@"
}
node() {
  unset -f nvm node npm npx
  [ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"
  node "$@"
}
npm() {
  unset -f nvm node npm npx
  [ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"
  npm "$@"
}
npx() {
  unset -f nvm node npm npx
  [ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"
  npx "$@"
}

# ---- SDKMAN ----
sdk() {
  unset -f sdk java javac gradle mvn
  [[ -s "${SDKMAN_DIR}/bin/sdkman-init.sh" ]] && source "${SDKMAN_DIR}/bin/sdkman-init.sh"
  sdk "$@"
}
java() {
  unset -f sdk java javac gradle mvn
  [[ -s "${SDKMAN_DIR}/bin/sdkman-init.sh" ]] && source "${SDKMAN_DIR}/bin/sdkman-init.sh"
  java "$@"
}
javac() {
  unset -f sdk java javac gradle mvn
  [[ -s "${SDKMAN_DIR}/bin/sdkman-init.sh" ]] && source "${SDKMAN_DIR}/bin/sdkman-init.sh"
  javac "$@"
}
gradle() {
  unset -f sdk java javac gradle mvn
  [[ -s "${SDKMAN_DIR}/bin/sdkman-init.sh" ]] && source "${SDKMAN_DIR}/bin/sdkman-init.sh"
  gradle "$@"
}
mvn() {
  unset -f sdk java javac gradle mvn
  [[ -s "${SDKMAN_DIR}/bin/sdkman-init.sh" ]] && source "${SDKMAN_DIR}/bin/sdkman-init.sh"
  mvn "$@"
}

# ---- kubectl ----
kubectl() {
  unset -f kubectl
  source <(command kubectl completion zsh)
  kubectl "$@"
}

# ---- docker ----
docker() {
  unset -f docker
  FPATH="$HOME/.docker/completions:$FPATH"
  autoload -Uz compinit
  compinit -C
  command docker "$@"
}
