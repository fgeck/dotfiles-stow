# Completions setup
autoload -Uz compinit

# Only regenerate compinit cache once a day
if [[ -n ${ZDOTDIR}/.zcompdump(#qN.mh+24) ]]; then
  compinit
else
  compinit -C
fi
