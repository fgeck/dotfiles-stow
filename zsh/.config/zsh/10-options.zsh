# Zsh Options
setopt AUTO_CD  # Type directory name to cd into it

# Word style: treat these characters as word separators for Opt+Backspace/Delete
# This makes Opt+Backspace delete one path segment instead of the whole path
WORDCHARS='*?_-.[]~=&;!#$%^(){}<>'  # removed '/' from default
