-- Add the sketchybar module to the package cpath
package.cpath = package.cpath .. ";/Users/" .. os.getenv("USER") .. "/.local/share/sketchybar_lua/?.so"

-- Add luarocks paths for AeroSpaceLua dependencies
local USER = os.getenv("USER")
package.path = package.path .. ";/Users/" .. USER .. "/.luarocks/share/lua/5.4/?.lua;/Users/" .. USER .. "/.luarocks/share/lua/5.4/?/init.lua"
package.cpath = package.cpath .. ";/Users/" .. USER .. "/.luarocks/lib/lua/5.4/?.so"

os.execute("(cd helpers && make)")

-- Start kanata layer provider (connects to kanata TCP on port 5828)
local kanata_provider = os.getenv("HOME") .. "/.config/sketchybar/helpers/event_providers/kanata_layer/bin/kanata_layer"
sbar.exec("killall kanata_layer 2>/dev/null; " .. kanata_provider .. " localhost 5828 &")
