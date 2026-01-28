# Sketchybar Configuration

A customized sketchybar setup for macOS with AeroSpace window manager integration.

## Bar Layout

```
┌─────────────────────────────────────────────────────────────────────────────────────────────────────┐
│ 󰌌 A │ M │ 1  2  3 ...  │                              │ CPU │ RAM │ NET │ 󰂄 │ 󰕾 │  󰏖 1 │ VPN │ Date │
│     │   │              │                              │     │     │     │   │   │      │     │      │
│ KBD │MOD│  WORKSPACES  │                              │         WIDGETS         │ BREW │     │  CAL │
└─────────────────────────────────────────────────────────────────────────────────────────────────────┘
 LEFT                                                                                 RIGHT
```

## Components

### Left Side

#### Keyboard Indicator (`items/keyboard.lua`)
Displays current keyboard layer and active modifiers.

- **Icon**: Keyboard symbol (󰌌)
- **Label**: Current layer (A, ↑, #, @)
- **Colors**: White (base), Red (nav), Green (num), Blue (sym)
- **Modifiers**: Shows ⌘⌥⌃⇧ when held

**Requires skhd** to trigger events:
```bash
# skhd config for layer changes (F13-F16)
f13 : sketchybar --trigger kbd_layer LAYER=base
f14 : sketchybar --trigger kbd_layer LAYER=nav
f15 : sketchybar --trigger kbd_layer LAYER=num
f16 : sketchybar --trigger kbd_layer LAYER=sym

# skhd config for modifier changes (F17-F24)
f17 : sketchybar --trigger kbd_mod MOD=cmd STATE=on
f18 : sketchybar --trigger kbd_mod MOD=cmd STATE=off
f19 : sketchybar --trigger kbd_mod MOD=alt STATE=on
f20 : sketchybar --trigger kbd_mod MOD=alt STATE=off
f21 : sketchybar --trigger kbd_mod MOD=ctrl STATE=on
f22 : sketchybar --trigger kbd_mod MOD=ctrl STATE=off
f23 : sketchybar --trigger kbd_mod MOD=shift STATE=on
f24 : sketchybar --trigger kbd_mod MOD=shift STATE=off
```

**Test manually:**
```bash
sketchybar --trigger kbd_layer LAYER=nav
sketchybar --trigger kbd_mod MOD=cmd STATE=on
```

#### AeroSpace Mode Indicator (`items/workspaces.lua`)
Shows current AeroSpace mode.

- **M** (green): Main mode
- **S** (yellow): Service mode

Subscribes to `aerospace_mode_change` event.

#### Workspaces (`items/workspaces.lua`)
Displays AeroSpace workspaces with app icons.

- Shows workspace number + app icons for open windows
- Highlights focused workspace
- Click to switch workspace
- Multi-monitor support with automatic display mapping

### Right Side

#### VPN Indicator (`items/vpn.lua`)
Shows VPN connection status.

- **Green**: Connected (WireGuard or GlobalProtect)
- **Dimmed**: Disconnected

**Click**: Opens popup to select VPN:
- WireGuard
- GlobalProtect

#### System Widgets (`items/widgets/`)

| Widget | File | Description |
|--------|------|-------------|
| CPU | `cpu.lua` | CPU usage percentage |
| RAM | `ram.lua` | Memory usage percentage |
| Network | `network.lua` | Upload/download speed |
| Battery | `battery.lua` | Battery level with charging indicator |
| Volume | `volume.lua` | System volume level |

#### Brew Outdated (`items/widgets/brew.lua`)
Shows count of outdated Homebrew packages.

- **Green**: 0 outdated
- **Yellow**: 1-3 outdated
- **Red**: 4+ outdated

**Click**: Shows popup with list of outdated packages.

#### Calendar (`items/calendar.lua`)
Displays current date and time.

- Format: `Mon 28 Jan  15:30`
- Updates every 30 seconds

**Click**: Opens Itsycal calendar popup.

## Dependencies

- [sketchybar](https://github.com/FelixKratz/SketchyBar) - The bar itself
- [AeroSpace](https://github.com/nikitabobko/AeroSpace) - Window manager
- [skhd](https://github.com/koekeishiya/skhd) - Hotkey daemon (for keyboard indicator)
- [Itsycal](https://www.mowglii.com/itsycal/) - Menu bar calendar (optional)
- SF Pro font - For text rendering
- Hack Nerd Font - For icons

## Installation

```bash
# Install dependencies
brew tap FelixKratz/formulae
brew install sketchybar
brew install asmvik/formulae/skhd
brew install --cask itsycal

# Stow the configuration
cd dotfiles-stow
stow sketchybar

# Start services
brew services start sketchybar
brew services start skhd
```

## File Structure

```
sketchybar/.config/sketchybar/
├── init.lua              # Entry point
├── bar.lua               # Bar appearance settings
├── colors.lua            # Color definitions
├── icons.lua             # SF Symbols and Nerd Font icons
├── settings.lua          # Font and padding settings
├── default.lua           # Default item settings
├── items/
│   ├── init.lua          # Loads all items
│   ├── keyboard.lua      # Keyboard layer indicator
│   ├── workspaces.lua    # AeroSpace workspaces + mode
│   ├── calendar.lua      # Date/time display
│   ├── vpn.lua           # VPN status + popup
│   └── widgets/
│       ├── init.lua      # Loads all widgets
│       ├── cpu.lua       # CPU usage
│       ├── ram.lua       # Memory usage
│       ├── network.lua   # Network speed
│       ├── battery.lua   # Battery status
│       ├── volume.lua    # Volume level
│       └── brew.lua      # Homebrew outdated count
└── helpers/
    ├── aerospace.lua     # AeroSpace API wrapper
    ├── app_icons.lua     # App to icon mapping
    └── log.lua           # Logging utility
```

## Events

| Event | Source | Description |
|-------|--------|-------------|
| `kbd_layer` | skhd | Keyboard layer changed |
| `kbd_mod` | skhd | Modifier key pressed/released |
| `aerospace_mode_change` | AeroSpace | Mode switched (main/service) |
| `aerospace_workspace_change` | AeroSpace | Workspace focus changed |
| `front_app_switched` | System | Active app changed |
| `display_change` | System | Monitor connected/disconnected |
| `wifi_change` | System | WiFi status changed |
| `system_woke` | System | Mac woke from sleep |

## Customization

### Colors (`colors.lua`)
```lua
return {
    white = 0xffffffff,
    red = 0xfffc5d7c,
    green = 0xff9ed072,
    blue = 0xff76cce0,
    -- ... more colors
}
```

### Keyboard Layer Colors (`items/keyboard.lua`)
```lua
local layer_colors = {
    base = colors.white,
    nav = colors.red,
    num = colors.green,
    sym = colors.blue,
}
```
