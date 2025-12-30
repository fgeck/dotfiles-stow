#!/bin/bash

# SketchyBar Dependencies Installation Script
# Run this once on a new machine after copying your sketchybar config

set -e

echo "🔧 Installing SketchyBar dependencies..."
echo ""

# Check if Homebrew is installed
if ! command -v brew &> /dev/null; then
    echo "❌ Homebrew not found. Please install it first:"
    echo "   /bin/bash -c \"\$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)\""
    exit 1
fi

# Install Lua
if ! command -v lua &> /dev/null; then
    echo "📦 Installing lua..."
    brew install lua
else
    echo "✅ lua already installed"
fi

# Install luarocks
if ! command -v luarocks &> /dev/null; then
    echo "📦 Installing luarocks..."
    brew install luarocks
else
    echo "✅ luarocks already installed"
fi

# Install switchaudio-osx (for volume control)
if ! command -v SwitchAudioSource &> /dev/null; then
    echo "📦 Installing switchaudio-osx..."
    brew install switchaudio-osx
else
    echo "✅ switchaudio-osx already installed"
fi

# Install nowplaying-cli (for media controls)
if ! command -v nowplaying-cli &> /dev/null; then
    echo "📦 Installing nowplaying-cli..."
    brew install nowplaying-cli
else
    echo "✅ nowplaying-cli already installed"
fi

# Install SketchyBar
echo "📦 Checking SketchyBar..."
if ! command -v sketchybar &> /dev/null; then
    brew tap FelixKratz/formulae
    brew install sketchybar
    echo "✅ SketchyBar installed"
else
    echo "✅ SketchyBar already installed"
fi

# Install Fonts
echo ""
echo "📦 Installing fonts..."

# SF Symbols
if brew list --cask sf-symbols &> /dev/null; then
    echo "✅ SF Symbols already installed"
else
    brew install --cask sf-symbols
fi

# SF Mono
if brew list --cask font-sf-mono &> /dev/null; then
    echo "✅ SF Mono already installed"
else
    brew install --cask font-sf-mono
fi

# SF Pro
if brew list --cask font-sf-pro &> /dev/null; then
    echo "✅ SF Pro already installed"
else
    brew install --cask font-sf-pro
fi

# Hack Nerd Font (for icons)
if brew list --cask font-hack-nerd-font &> /dev/null; then
    echo "✅ Hack Nerd Font already installed"
else
    echo "📦 Installing Hack Nerd Font..."
    brew install --cask font-hack-nerd-font
fi

# SketchyBar App Font
echo "📦 Installing sketchybar-app-font..."
if [ -f "$HOME/Library/Fonts/sketchybar-app-font.ttf" ]; then
    echo "✅ sketchybar-app-font already installed"
else
    curl -L https://github.com/kvndrsslr/sketchybar-app-font/releases/download/v2.0.28/sketchybar-app-font.ttf -o "$HOME/Library/Fonts/sketchybar-app-font.ttf"
    echo "✅ sketchybar-app-font installed"
fi

# Install SbarLua (Lua bindings for SketchyBar)
echo ""
echo "📦 Installing SbarLua..."
if [ -d "$HOME/.local/share/sketchybar_lua" ]; then
    echo "✅ SbarLua already installed"
else
    (git clone https://github.com/FelixKratz/SbarLua.git /tmp/SbarLua && cd /tmp/SbarLua/ && make install && rm -rf /tmp/SbarLua/)
    echo "✅ SbarLua installed to ~/.local/share/sketchybar_lua/"
fi

# Install Lua dependencies for AeroSpaceLua
echo ""
echo "📦 Installing Lua dependencies..."

# lua-cjson (JSON parsing)
if luarocks list --porcelain lua-cjson | grep -q "lua-cjson"; then
    echo "✅ lua-cjson already installed"
else
    luarocks install lua-cjson --local
fi

# luaposix (POSIX socket APIs)
if luarocks list --porcelain luaposix | grep -q "luaposix"; then
    echo "✅ luaposix already installed"
else
    luarocks install luaposix --local
fi

# Compile C helpers (menus, cpu_load, network_load)
echo ""
echo "📦 Compiling C helpers..."
HELPERS_DIR="$(cd "$(dirname "$0")/helpers" && pwd)"

if [ -d "$HELPERS_DIR/menus" ]; then
    echo "   - Compiling menu helper..."
    cd "$HELPERS_DIR/menus"
    make clean 2>/dev/null || true
    make
    echo "   ✅ Menu helper compiled"
fi

if [ -d "$HELPERS_DIR/event_providers/cpu_load" ]; then
    echo "   - Compiling cpu_load helper..."
    cd "$HELPERS_DIR/event_providers/cpu_load"
    make clean 2>/dev/null || true
    make
    echo "   ✅ CPU load helper compiled"
fi

if [ -d "$HELPERS_DIR/event_providers/network_load" ]; then
    echo "   - Compiling network_load helper..."
    cd "$HELPERS_DIR/event_providers/network_load"
    make clean 2>/dev/null || true
    make
    echo "   ✅ Network load helper compiled"
fi

# Check if AeroSpace is installed (optional but recommended for workspaces)
echo ""
if ! command -v aerospace &> /dev/null; then
    echo "⚠️  AeroSpace not found (required for workspace management)"
    echo "   Install with: brew install --cask nikitabobko/tap/aerospace"
else
    echo "✅ AeroSpace installed"
fi

# Check for jq (optional, but useful for debugging)
if ! command -v jq &> /dev/null; then
    echo ""
    echo "💡 Optional: Install jq for JSON debugging"
    echo "   brew install jq"
fi

echo ""
echo "✅ All dependencies installed successfully!"
echo ""
echo "📝 Next steps:"
echo "   1. Grant Accessibility permissions to the menu helper:"
echo "      System Settings → Privacy & Security → Accessibility"
echo "      Add Terminal/your terminal emulator to the list"
echo ""
echo "   2. Start SketchyBar:"
echo "      brew services start sketchybar"
echo "      Or run manually: sketchybar"
echo ""
echo "   3. If using AeroSpace, make sure it's running:"
echo "      brew services start aerospace"
echo ""
