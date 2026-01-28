-- Keyboard layer and modifier indicator
-- Displays current keyboard layer (Nav/Num/Sym) and active modifiers (⌘⌥⌃⇧)
--
-- Events:
--   kbd_layer: LAYER=base|nav|num|sym
--   kbd_mod:   MOD=cmd|alt|ctrl|shift STATE=on|off
--
-- Test manually:
--   sketchybar --trigger kbd_layer LAYER=nav
--   sketchybar --trigger kbd_mod MOD=cmd STATE=on
--   sketchybar --trigger kbd_mod MOD=cmd STATE=off

local colors = require("colors")
local settings = require("settings")

-- Layer colors
local layer_colors = {
    base = colors.white,
    nav = colors.red,
    num = colors.green,
    sym = colors.blue,
}

-- Layer symbols (SF Symbols without circles)
local layer_symbols = {
    base = "􀅏",            -- a (U+10014F)
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
local current_layer = "base"

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

-- Modifier indicator (separate, only shows when mods are active)
local mod_indicator = sbar.add("item", "keyboard.mods", {
    position = "left",
    drawing = false,  -- Hidden by default, shown when mods active
    icon = {
        string = "",
        font = {
            family = settings.font.text,
            style = settings.font.style_map["Regular"],
            size = 12.0,
        },
        color = colors.white,
        padding_left = 0,
        padding_right = 8,
    },
    label = { drawing = false },
    background = {
        color = colors.bg1,
        drawing = true,
    },
})

-- Update modifier display
local function update_mods()
    local mod_string = ""
    -- Order: cmd, alt, ctrl, shift (⌘⌥⌃⇧)
    if active_mods.cmd then mod_string = mod_string .. "⌘" end
    if active_mods.alt then mod_string = mod_string .. "⌥" end
    if active_mods.ctrl then mod_string = mod_string .. "⌃" end
    if active_mods.shift then mod_string = mod_string .. "⇧" end

    -- Only show when mods are active
    local has_mods = mod_string ~= ""
    mod_indicator:set({
        drawing = has_mods,
        icon = {
            string = mod_string,
        },
    })
end

-- Update layer display
local function update_layer()
    local symbol = layer_symbols[current_layer] or "A"
    local color = layer_colors[current_layer] or colors.white

    keyboard:set({
        icon = { color = color },
        label = {
            string = symbol,
            color = color,
        },
    })
end

-- Subscribe to layer change events
keyboard:subscribe("kbd_layer", function(env)
    local layer = env.LAYER or "base"
    current_layer = layer
    update_layer()
end)

-- Subscribe to modifier change events
mod_indicator:subscribe("kbd_mod", function(env)
    local mod = env.MOD
    local state = env.STATE

    if mod and active_mods[mod] ~= nil then
        active_mods[mod] = (state == "on")
        update_mods()
    end
end)

-- Initialize display
update_layer()
update_mods()
