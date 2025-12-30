local colors = require("colors")
local settings = require("settings")
local app_icons = require("helpers.app_icons")

-- Load AeroSpaceLua
local Aerospace = require("helpers.aerospace")
local aerospace = Aerospace.new()

-- Wait for AeroSpace connection
while not aerospace:is_initialized() do
    os.execute("sleep 0.1")
end

-- Root is used to handle event subscriptions
local root = sbar.add("item", { drawing = false })
local workspaces = {}

-- Helper function to get windows grouped by workspace with callbacks
local function withWindows(f)
    aerospace:list_all_windows(function(windows)
        -- Group windows by workspace
        local open_windows = {}
        for _, window in ipairs(windows) do
            local workspace = window.workspace
            local app = window["app-name"]
            if open_windows[workspace] == nil then
                open_windows[workspace] = {}
            end
            table.insert(open_windows[workspace], app)
        end

        -- Get focused workspace
        aerospace:list_current(function(focused_workspace)
            focused_workspace = focused_workspace:match("^%s*(.-)%s*$")

            -- Get workspace info (focused, visible, monitor)
            aerospace:query_workspaces(function(workspace_info)
                local visible_workspaces = {}
                local workspace_monitors = {}

                for _, ws in ipairs(workspace_info) do
                    if ws["workspace-is-visible"] then
                        table.insert(visible_workspaces, ws)
                    end
                    workspace_monitors[ws.workspace] = ws["monitor-appkit-nsscreen-screens-id"]
                end

                f({
                    open_windows = open_windows,
                    focused_workspace = focused_workspace,
                    visible_workspaces = visible_workspaces,
                    workspace_monitors = workspace_monitors
                })
            end)
        end)
    end)
end

local function updateWindow(workspace_index, args)
    local open_windows = args.open_windows[workspace_index]
    local focused_workspace = args.focused_workspace
    local visible_workspaces = args.visible_workspaces
    local workspace_monitors = args.workspace_monitors

    if open_windows == nil then
        open_windows = {}
    end

    local icon_line = ""
    local no_app = true
    for i, open_window in ipairs(open_windows) do
        no_app = false
        local app = open_window
        local lookup = app_icons[app]
        local icon = ((lookup == nil) and app_icons["Default"] or lookup)
        icon_line = icon_line .. " " .. icon
    end

    sbar.animate("tanh", 10.0, function()
        -- Check if this workspace is visible
        local is_visible = false
        for _, visible_ws in ipairs(visible_workspaces) do
            if workspace_index == visible_ws.workspace then
                is_visible = true
                break
            end
        end

        if no_app and is_visible then
            icon_line = " —"
            workspaces[workspace_index]:set({
                drawing = true,
                label = { string = icon_line },
                display = workspace_monitors[workspace_index],
            })
            return
        end

        if no_app and workspace_index ~= focused_workspace then
            workspaces[workspace_index]:set({
                drawing = false,
            })
            return
        end

        if no_app and workspace_index == focused_workspace then
            icon_line = " —"
            workspaces[workspace_index]:set({
                drawing = true,
                label = { string = icon_line },
                display = workspace_monitors[workspace_index],
            })
            return
        end

        workspaces[workspace_index]:set({
            drawing = true,
            label = { string = icon_line },
            display = workspace_monitors[workspace_index],
        })
    end)
end

local function updateWindows()
    withWindows(function(args)
        for workspace_index, _ in pairs(workspaces) do
            updateWindow(workspace_index, args)
        end
    end)
end

local function updateWorkspaceMonitor()
    aerospace:query_workspaces(function(workspace_info)
        for _, ws in ipairs(workspace_info) do
            local space_index = ws.workspace
            local monitor_id = math.floor(ws["monitor-appkit-nsscreen-screens-id"])
            if workspaces[space_index] then
                workspaces[space_index]:set({
                    display = monitor_id,
                })
            end
        end
    end)
end

-- Initialize workspaces
aerospace:query_workspaces(function(workspace_info)
    for _, entry in ipairs(workspace_info) do
        local workspace_index = entry.workspace

        local workspace = sbar.add("item", {
            background = {
                color = colors.bg1,
                drawing = true,
            },
            click_script = "aerospace workspace " .. workspace_index,
            drawing = false, -- Hide all items at first
            icon = {
                color = colors.with_alpha(colors.white, 0.3),
                drawing = true,
                font = { family = settings.font.numbers },
                highlight_color = colors.white,
                padding_left = 5,
                padding_right = 4,
                string = workspace_index
            },
            label = {
                color = colors.with_alpha(colors.white, 0.3),
                drawing = true,
                font = "sketchybar-app-font:Regular:16.0",
                highlight_color = colors.white,
                padding_left = 2,
                padding_right = 12,
                y_offset = -1,
            },
        })

        workspaces[workspace_index] = workspace

        workspace:subscribe("aerospace_workspace_change", function(env)
            local focused_workspace = env.FOCUSED_WORKSPACE
            local is_focused = focused_workspace == workspace_index

            sbar.animate("tanh", 10.0, function()
                workspace:set({
                    icon = { highlight = is_focused },
                    label = { highlight = is_focused },
                    blur_radius = 30,
                })
            end)
        end)
    end

    -- Initial setup
    updateWindows()
    updateWorkspaceMonitor()

    -- Subscribe to window creation/destruction events
    root:subscribe("aerospace_workspace_change", function()
        updateWindows()
    end)

    -- Subscribe to front app changes too
    root:subscribe("front_app_switched", function()
        updateWindows()
    end)

    root:subscribe("display_change", function()
        updateWorkspaceMonitor()
        updateWindows()
    end)

    aerospace:list_current(function(focused_workspace)
        focused_workspace = focused_workspace:match("^%s*(.-)%s*$")
        if workspaces[focused_workspace] then
            workspaces[focused_workspace]:set({
                icon = { highlight = true },
                label = { highlight = true },
            })
        end
    end)
end)
