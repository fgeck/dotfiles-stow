#!/bin/bash

# Required parameters:
# @raycast.schemaVersion 1
# @raycast.title aerospace layout mbp
# @raycast.mode compact

# Optional parameters:
# @raycast.icon 🤖

# Documentation:
# @raycast.description open apps and move them to respective aerospace workspaces
# @raycast.author fgeck
# @raycast.authorURL https://raycast.com/fgeck
# @raycast.argument1 { "type": "text", "placeholder": "browse|chat|dev|other", "percentEncoded": true }

#!/bin/bash

view=$1

if [ "$view" == "dev" ]; then
    ws=1
    open -a "IntelliJ IDEA.app"
    open -a "iTerm.app"
    sleep 1
    intellijWindowId=$(aerospace list-windows --app-bundle-id com.jetbrains.intellij --format '%{window-id}' --workspace 1)
    itermWindowId=$(aerospace list-windows --app-bundle-id com.googlecode.iterm2 --format '%{window-id}' --workspace 1 2 3 4)
    aerospace layout h_tiles --window-id $intellijWindowId
    aerospace move up --window-id $intellijWindowId
    aerospace resize smart +200 --window-id $intellijWindowId
fi

if [ "$view" == "chat" ]; then
    # Restore Workspace 2
    # ---------------------
    # |        |          |
    # | Signal | Telegram |
    # |        |          |
    # ---------------------
    ws=2
    open -a signal
    open -a telegram
    sleep 2
    signalWindowId=$(aerospace list-windows --app-bundle-id org.whispersystems.signal-desktop --format '%{window-id}' --workspace 2)
    aerospace move left --window-id $signalWindowId
fi

if [ "$view" == "dev" ]; then
    # Restore Workspace 3
    # ---------------------
    # |                   |
    # |       Zed         |
    # |                   |
    # |-------------------|
    # |       iTerm       |
    # ---------------------
    ws=3
    open -a iterm
    open -a zed
    sleep 1
    itermWindowId=$(aerospace list-windows --app-bundle-id com.googlecode.iterm2 --format '%{window-id}' --workspace 1 2 3 4)
    zedWindowId=$(aerospace list-windows --app-bundle-id dev.zed.Zed --format '%{window-id}' --workspace 3)
    aerospace layout h_tiles --window-id $zedWindowId
    aerospace focus --window-id $zedWindowId
    aerospace move up --window-id $zedWindowId
    sleep 1
    aerospace resize smart -200 --window-id $itermWindowId
fi

if [ "$view" == "other" ]; then
    # Restore Workspace 4
    # ---------------------
    # | Obsidian | Notes  |
    # |          |        |
    # |-------------------|
    # |       Mail        |
    # ---------------------
    ws=4
    open -a Obsidian
    open -a Notes
    open -a Mail
    sleep 1
    obsidianWindowId=$(aerospace list-windows --app-bundle-id md.obsidian --format '%{window-id}' --workspace 4)
    notesWindowId=$(aerospace list-windows --app-bundle-id com.apple.Notes --format '%{window-id}' --workspace 4)
    mailWindowId=$(aerospace list-windows --app-bundle-id com.apple.mail --format '%{window-id}' --workspace 4)
    aerospace layout h_tiles --window-id $obsidianWindowId
    aerospace focus --window-id $obsidianWindowId
    aerospace move up --window-id $obsidianWindowId
    sleep 1
    aerospace join-with down --window-id $obsidianWindowId
fi

if [ "$view" == "private" ]; then
    open -a librewolf
    open -a signal
    open -a ghostty
    sleep 1
    signalWindowId=$(aerospace list-windows --app-bundle-id org.whispersystems.signal-desktop --format '%{window-id}' --workspace 2)
    librewolfWindowId=$(aerospace list-windows --app-bundle-id org.mozilla.librewolf --format '%{window-id}' --workspace 1)
    ghosttyWindowId=$(aerospace list-windows --app-bundle-id com.mitchellh.ghostty --format '%{window-id}' --workspace 4)
fi

# view=$1
# if [ "$view" == "tutorial" ]; then
# 	ws=1
# 	open -a Firefox
# 	aerospace move-node-to-workspace $ws

# 	open -a IINA
# 	sleep 1
# 	aerospace layout tiling
# 	aerospace move-node-to-workspace $ws

# 	open -a WezTerm
# 	aerospace move-node-to-workspace $ws

# 	aerospace workspace $ws
# 	aerospace layout tiling
# 	for i in {1..3}; do
# 		aerospace move left
# 	done
# fi

# if [ "$view" == "thesis" ]; then
# 	ws=2
# 	open -a sioyek
# 	sleep 1
# 	aerospace move-node-to-workspace $ws

# 	open -a WezTerm
# 	aerospace move-node-to-workspace $ws

# 	open -a Firefox
# 	aerospace move-node-to-workspace $ws

# 	aerospace workspace $ws
# 	aerospace layout tiling
# 	for i in {1..3}; do
# 		aerospace move left
# 	done
# fi

# function open_move_fullscreen {
# 	open -a $1
# 	aerospace move-node-to-workspace $2
# 	aerospace fullscreen
# }

# if [ "$view" == "default" ]; then
# 	aerospace close-all-windows-but-current
# 	open_move_fullscreen "ChatAll" A
# 	open_move_fullscreen Firefox B
# 	open_move_fullscreen WezTerm T
# 	aerospace workspace B
# fi

# if [ "$view" == "work" ]; then
# 	ws=C
# 	open -a "Microsoft Teams"
# 	sleep 1
# 	aerospace move-node-to-workspace $ws

# 	open -a "Microsoft Outlook"
# 	sleep 1
# 	aerospace move-node-to-workspace $ws

# 	aerospace workspace $ws
# 	aerospace layout tiling
# fi
