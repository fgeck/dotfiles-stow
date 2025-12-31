local icons = require("icons")
local colors = require("colors")
local settings = require("settings")

-- Detect primary network interface
local function get_primary_interface()
    local handle = io.popen("route -n get default 2>/dev/null | grep interface | awk '{print $2}'")
    local interface = handle:read("*a"):gsub("%s+", "")
    handle:close()
    return interface ~= "" and interface or "en0"
end

local interface = get_primary_interface()

-- Execute network_load event provider
sbar.exec("killall network_load >/dev/null; $CONFIG_DIR/helpers/event_providers/network_load/bin/network_load " .. interface .. " network_update 2.0")

-- Download item (blue)
local network_down = sbar.add("item", "widgets.network.down", {
    position = "right",
    icon = {
        string = icons.wifi.download,
        color = colors.blue,
        font = {
            family = settings.font_icon.text,
            style = settings.font_icon.style_map["Bold"],
            size = settings.font_icon.size
        },
        padding_left = settings.padding.icon_label_item.icon.padding_left,
        padding_right = 0,
    },
    label = {
        string = "???",
        font = {
            family = settings.font.numbers,
            style = settings.font.style_map["Bold"],
            size = 9.0,
        },
        padding_right = 8,
    },
})

-- Upload item (red)
local network_up = sbar.add("item", "widgets.network.up", {
    position = "right",
    icon = {
        string = icons.wifi.upload,
        color = colors.red,
        font = {
            family = settings.font_icon.text,
            style = settings.font_icon.style_map["Bold"],
            size = settings.font_icon.size
        },
        padding_left = 0,
        padding_right = 0,
    },
    label = {
        string = "???",
        font = {
            family = settings.font.numbers,
            style = settings.font.style_map["Bold"],
            size = 9.0,
        },
        padding_right = settings.padding.icon_label_item.label.padding_right,
    },
})

network_down:subscribe("network_update", function(env)
    local down = env.download or "??"
    network_down:set({ label = { string = down } })
end)

network_up:subscribe("network_update", function(env)
    local up = env.upload or "??"
    network_up:set({ label = { string = up } })
end)

network_down:subscribe("mouse.clicked", function(env)
    sbar.exec("open -a 'Activity Monitor'")
end)

network_up:subscribe("mouse.clicked", function(env)
    sbar.exec("open -a 'Activity Monitor'")
end)

-- Background bracket around both network items
sbar.add("bracket", "widgets.network.bracket", { network_down.name, network_up.name }, {
    background = { color = colors.bg1 }
})

-- Padding after network items
sbar.add("item", "widgets.network.padding", {
    position = "right",
    width = settings.group_paddings
})
