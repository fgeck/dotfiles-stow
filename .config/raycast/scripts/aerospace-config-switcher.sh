#!/bin/bash

# Required parameters:
# @raycast.schemaVersion 1
# @raycast.title aerospace config switcher
# @raycast.mode compact

# Optional parameters:
# @raycast.icon 🤖

# Documentation:
# @raycast.description open apps and move them to respective aerospace workspaces
# @raycast.author fgeck
# @raycast.authorURL https://raycast.com/fgeck
# @raycast.argument1 { "type": "text", "placeholder": "mbp-1|mbp-2|mba", "percentEncoded": true }

# argument1 is the target config where mbp/mba is the macbook model and the number is the amount of external monitors

selected_config=$1
config_dir="$HOME/.config/aerospace"
source_config="$config_dir/aerospace-$selected_config.toml"
target_link="$config_dir/aerospace.toml"

# Validate input
case $selected_config in
mbp-1|mbp-2|mba)
    ;;
*)
    echo "❌ Unknown configuration: $selected_config"
    echo "Valid options: mbp-1, mbp-2, mba"
    exit 1
    ;;
esac

# Check if config file exists
if [[ ! -f "$source_config" ]]; then
    echo "❌ Config file not found: $source_config"
    exit 1
fi

# Create symlink
ln -sf "$source_config" "$target_link"

# Reload aerospace
if command -v aerospace &> /dev/null; then
    aerospace reload-config
    echo "✅ Switched to $selected_config and reloaded aerospace"
else
    echo "✅ Switched to $selected_config (aerospace command not found, manual reload needed)"
fi
