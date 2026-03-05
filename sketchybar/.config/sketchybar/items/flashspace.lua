local colors    = require("colors")
local settings  = require("settings")
local app_icons = require("helpers.app_icons")
local log       = require("helpers.log").new("flashspace")

log.info("flashspace.lua loading...")

-- Parse workspace definitions from the active flashspace profile.
-- Returns a list of { name, display, apps = {} } tables.
local function load_workspaces()
    local workspaces = {}

    local handle = io.popen("flashspace list-workspaces 2>/dev/null")
    if not handle then
        log.error("load_workspaces: flashspace list-workspaces failed")
        return workspaces
    end
    local output = handle:read("*a")
    handle:close()

    for raw in output:gmatch("[^\r\n]+") do
        local name = raw:match("^%s*(.-)%s*$")
        if name ~= "" then
            table.insert(workspaces, { name = name, apps = {} })
        end
    end

    -- Enrich with app assignments from profiles.yaml via yq + cjson
    local profiles_path = os.getenv("HOME") .. "/.config/flashspace/profiles.yaml"
    local jhandle = io.popen("yq -o=json '.' " .. profiles_path .. " 2>/dev/null")
    if jhandle then
        local json_str = jhandle:read("*a")
        jhandle:close()

        local ok, cjson = pcall(require, "cjson")
        if not ok then ok, cjson = pcall(require, "cjson.safe") end

        if ok and json_str and json_str ~= "" then
            local parsed_ok, data = pcall(cjson.decode, json_str)
            if parsed_ok and data and data.profiles then
                local ws_by_name = {}
                for _, ws in ipairs(data.profiles[1].workspaces or {}) do
                    ws_by_name[ws.name] = ws
                end
                for _, ws in ipairs(workspaces) do
                    local y = ws_by_name[ws.name]
                    if y then
                        ws.display = y.display
                        for _, app in ipairs(y.apps or {}) do
                            table.insert(ws.apps, app.name)
                        end
                    end
                end
            else
                log.warn("load_workspaces: failed to parse profiles YAML")
            end
        end
    end

    log.info("load_workspaces: loaded %d workspaces", #workspaces)
    return workspaces
end

-- Returns a set of currently running app names.
local function get_running_apps()
    local running = {}
    local handle = io.popen("flashspace list-running-apps 2>/dev/null")
    if handle then
        local out = handle:read("*a")
        handle:close()
        for raw in out:gmatch("[^\r\n]+") do
            local name = raw:match("^%s*(.-)%s*$")
            if name ~= "" then running[name] = true end
        end
    end
    return running
end

-- Build app-icon label string for assigned apps that are currently running.
local function build_app_label(ws_apps, running_apps)
    local label = ""
    for _, app in ipairs(ws_apps) do
        if running_apps[app] then
            local icon = app_icons[app] or app_icons["Default"]
            label = label .. " " .. icon
        end
    end
    return label
end

-- ---------------------------------------------------------------------------
-- State
-- ---------------------------------------------------------------------------

local workspace_defs  = load_workspaces()
local workspace_items = {}   -- keyed by workspace name
local focused_workspace = ""

-- Seed focused workspace at startup
local fw_handle = io.popen("flashspace get-workspace 2>/dev/null")
if fw_handle then
    local fw = fw_handle:read("*a")
    fw_handle:close()
    focused_workspace = fw:match("^%s*(.-)%s*$")
end
log.info("initial focused workspace: %s", focused_workspace)

-- Root item for event subscriptions only (never drawn)
local root = sbar.add("item", { drawing = false })

-- ---------------------------------------------------------------------------
-- Create one bar item per workspace.
-- Icon  = workspace name (SF Pro Bold, small) — dimmed when inactive, green when focused.
-- Label = app glyphs (sketchybar-app-font) for assigned apps that are running.
-- ---------------------------------------------------------------------------

for _, ws in ipairs(workspace_defs) do
    local item = sbar.add("item", {
        drawing      = false,
        position     = "left",
        click_script = "flashspace workspace --name '" .. ws.name .. "' 2>/dev/null",
        background = {
            color   = colors.bg1,
            drawing = true,
        },
        icon = {
            string          = ws.name,
            color           = colors.with_alpha(colors.white, 0.35),
            highlight_color = colors.green,
            drawing         = true,
            font = {
                family = settings.font.text,
                style  = settings.font.style_map["Bold"],
                size   = 11.0,
            },
            padding_left  = 8,
            padding_right = 3,
        },
        label = {
            string          = "",
            color           = colors.with_alpha(colors.white, 0.55),
            highlight_color = colors.white,
            drawing         = true,
            font            = "sketchybar-app-font:Regular:14.0",
            padding_left    = 2,
            padding_right   = 10,
            y_offset        = -1,
        },
    })

    workspace_items[ws.name] = item
end

-- ---------------------------------------------------------------------------
-- Update all items
-- ---------------------------------------------------------------------------

local function update_all()
    local running_apps = get_running_apps()

    for _, ws in ipairs(workspace_defs) do
        local item       = workspace_items[ws.name]
        local is_focused = (ws.name == focused_workspace)
        local app_label  = build_app_label(ws.apps, running_apps)
        local has_apps   = (app_label ~= "")

        sbar.animate("tanh", 10.0, function()
            if not has_apps and not is_focused then
                item:set({ drawing = false })
                return
            end

            item:set({
                drawing = true,
                icon    = { highlight = is_focused },
                label   = {
                    string    = has_apps and app_label or " —",
                    highlight = is_focused,
                },
            })
        end)
    end
end

update_all()

-- ---------------------------------------------------------------------------
-- Events
-- ---------------------------------------------------------------------------

root:subscribe("flashspace_workspace_change", function(env)
    local ws_name = (env.WORKSPACE or ""):match("^%s*(.-)%s*$")
    log.info("EVENT: flashspace_workspace_change -> %s", ws_name)
    focused_workspace = ws_name
    update_all()
end)

root:subscribe("front_app_switched", function(_)
    log.debug("EVENT: front_app_switched")
    update_all()
end)
