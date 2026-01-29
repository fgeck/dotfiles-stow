-- Keyboard layer and modifier indicator
-- Displays current keyboard layer (Nav/Num/Sym) and active modifiers (⌘⌥⌃⇧)
--
-- Events:
--   kbd_layer: LAYER=main|nav|num|sym
--   kbd_mod:   MOD=cmd|alt|ctrl|shift STATE=on|off
--
-- Test manually:
--   sketchybar --trigger kbd_layer LAYER=nav
--   sketchybar --trigger kbd_mod MOD=cmd STATE=on
--   sketchybar --trigger kbd_mod MOD=cmd STATE=off

local colors = require("colors")
local settings = require("settings")

-- Layer colors (main = default layer from kanata)
local layer_colors = {
    main = colors.white,
    nav = colors.red,
    num = colors.green,
    sym = colors.blue,
}

-- Layer symbols (SF Symbols without circles)
local layer_symbols = {
    main = "􀅏",            -- a (U+10014F)
    nav = "􀄨",             -- arrow.up
    num = "􀆃",             -- number (U+100183)
    sym = "􀅷",             -- at (U+100177)
}

-- Track active modifiers
local active_mods = {
    cmd = false,
    alt = false,
    ctrl = false,
    shift = false,
}

-- Track current layer
local current_layer = "main"

-- Single keyboard item: icon = keyboard symbol, label = layer indicator
local keyboard = sbar.add("item", "keyboard", {
    position = "left",
    icon = {
        string = "􀇳",        -- keyboard SF Symbol
        font = {
            family = settings.font.text,
            style = settings.font.style_map["Regular"],
            size = 12.0,
        },
        color = colors.white,
        padding_left = 8,
        padding_right = 2,
    },
    label = {
        string = "A",
        font = {
            family = settings.font.text,
            style = settings.font.style_map["Bold"],
            size = 14.0,
        },
        color = colors.white,
        padding_left = 2,
        padding_right = 8,
    },
    background = {
        color = colors.bg1,
        drawing = true,
    },
})


-- Update display (layer + modifiers combined)
local function update_display()
    local symbol = layer_symbols[current_layer] or "A"
    local color = layer_colors[current_layer] or colors.white

    -- Build modifier string
    local mod_string = ""
    if active_mods.cmd then mod_string = mod_string .. "⌘" end
    if active_mods.alt then mod_string = mod_string .. "⌥" end
    if active_mods.ctrl then mod_string = mod_string .. "⌃" end
    if active_mods.shift then mod_string = mod_string .. "⇧" end

    -- Combine: layer symbol + modifiers (e.g., "A ⌘" or "↑ ⌘⌥")
    local label = symbol
    if mod_string ~= "" then
        label = symbol .. " " .. mod_string
    end

    keyboard:set({
        icon = { color = color },
        label = {
            string = label,
            color = color,
        },
    })
end

-- Subscribe to layer change events
keyboard:subscribe("kbd_layer", function(env)
    local layer = env.LAYER or "main"
    current_layer = layer
    update_display()
end)

-- Subscribe to modifier change events
keyboard:subscribe("kbd_mod", function(env)
    local mod = env.MOD
    local state = env.STATE

    if mod and active_mods[mod] ~= nil then
        active_mods[mod] = (state == "on")
        update_display()
    end
end)

-- Initialize display
update_display()
