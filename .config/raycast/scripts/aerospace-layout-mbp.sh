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
# @raycast.argument1 { "type": "text", "placeholder": "dev|browse|comms|chat|browse2", "percentEncoded": true }

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

if [ "$view" == "browse" ]; then
    # Restore Workspace 2
    # ---------------------
    # |                   |
    # |      Helium       |
    # |                   |
    # ---------------------
    ws=2
    open -a helium
    sleep 1
fi

if [ "$view" == "comms" ]; then
    ws=3
    open -a outlook
    open -a slack
    open -a teams2
    sleep 2
fi

if [ "$view" == "comms" ]; then
    open -a outlook
    open -a teams2
    sleep 2
    outlookWindowId=$(aerospace list-windows --app-bundle-id com.microsoft.Outlook --format '%{window-id}' --workspace 4)
    aerospace move left --window-id $outlookWindowId
fi



if [ "$view" == "chat" ]; then
    # Restore Workspace 5
    # ---------------------
    # |        |          |
    # | Signal |   Mail   |
    # |        |          |
    # ---------------------
    ws=5
    open -a signal
    open -a mail
    sleep 2
    signalWindowId=$(aerospace list-windows --app-bundle-id org.whispersystems.signal-desktop --format '%{window-id}' --workspace 2)
    aerospace move left --window-id $signalWindowId
fi


if [ "$view" == "browse2" ]; then
    # Restore Workspace 6
    # ---------------------
    # |                   |
    # |    Librewolf      |
    # |                   |
    # ---------------------
    ws=6
    open -a Librewolf
    sleep 1
fi
