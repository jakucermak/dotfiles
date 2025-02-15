-- items/aerospace.lua
local colors = require("colors")
local settings = require("settings")
local app_icons = require("helpers.app_icons")
local icons = require("icons")

local max_workspaces = 9
local query_workspaces = "aerospace list-workspaces --all --format '%{workspace}%{monitor-id}' --json"
local query_monitor = "aerospace list-monitors --count"
local workspace_monitor = {}

local superscript = { "¹", "²", "³", "⁴", "⁵", "⁶", "⁷", "⁸", "⁹", "⁰" }

function dump(o)
    if type(o) == 'table' then
        local s = '{ '
        for k, v in pairs(o) do
            if type(k) ~= 'number' then k = '"' .. k .. '"' end
            s = s .. '[' .. k .. '] = ' .. dump(v) .. ','
        end
        return s .. '} '
    else
        return tostring(o)
    end
end

local workspaces = {}

local function updateWindows(workspace_index, is_focused)
    local get_windows =
        string.format("aerospace list-windows --workspace %s --format '%%{app-name}' --json", workspace_index)
    sbar.exec(get_windows, function(open_windows)
        local icon_line = ""
        local no_app = true
        for _, open_window in ipairs(open_windows) do
            no_app = false
            local app = open_window["app-name"]
            local lookup = app_icons[app]
            local icon = ((lookup == nil) and app_icons["default"] or lookup)
            icon_line = icon_line .. " " .. icon
        end

        local workspace = workspaces[workspace_index]

        if no_app and not is_focused then
            workspace:set({ drawing = false })
        else
            workspace:set({
                drawing = true,
            })
        end


        sbar.animate("tanh", 10, function()
            workspaces[workspace_index]:set({
                icon = { string = icon_line, font = "sketchybar-app-font:Regular:17.0", highlight_color = colors.green, color = colors.grey_bg },
                label = { string = superscript[workspace_index] },
                padding_right = 1,
                padding_left = 1,
            })
        end)
    end)
end

local function updateWorkspaceMonitor(workspace_index)
    sbar.exec(query_workspaces, function(workspaces_and_monitors)
        sbar.exec(query_monitor, function(monitor_number)
            local monitor_id_map = {}
            if tonumber(monitor_number) ~= 1 then
                monitor_id_map = { [1] = 2, [2] = 1 } -- sketchybar monitor id is different from aerospace monitor id which is need to map monitor id
            else
                monitor_id_map = { [1] = 1, [2] = 2 }
            end
            for _, entry in ipairs(workspaces_and_monitors) do
                local space_index = tonumber(entry.workspace)
                local monitor_id = math.floor(entry["monitor-id"])
                workspace_monitor[space_index] = monitor_id_map[monitor_id]
            end
            workspaces[workspace_index]:set({
                display = workspace_monitor[workspace_index],
            })
        end)
    end)
end

for workspace_index = 1, max_workspaces do
    local workspace = sbar.add("item", {
        label = {
            padding_right = 10,
            color = colors.grey,
            highlight_color = colors.green,
            y_offset = 1,
        },
        padding_right = 1,
        padding_left = 1,
        background = {
            color = colors.transparent,
            border_color = colors.transparent,
        },
        click_script = "aerospace workspace " .. workspace_index,
        updates = true,
    })

    workspaces[workspace_index] = workspace

    workspace:subscribe("aerospace_workspace_change", function(env)
        local focused_workspace = tonumber(env.FOCUSED_WORKSPACE)
        local is_focused = focused_workspace == workspace_index
        updateWindows(workspace_index, is_focused)

        sbar.animate("tanh", 10, function()
            workspace:set({
                icon = { highlight = is_focused },
                label = { highlight = is_focused },

            })
        end)
    end)

    workspace:subscribe("aerospace_focus_change", function()
        updateWindows(workspace_index)
    end)

    workspace:subscribe("display_change", function()
        updateWindows(workspace_index)
        updateWorkspaceMonitor(workspace_index)
    end)

    -- initial setup
    updateWindows(workspace_index)
    updateWorkspaceMonitor(workspace_index)
    sbar.exec("aerospace list-workspaces --focused", function(focused_workspace)
        workspaces[tonumber(focused_workspace)]:set({
            icon = { highlight = true },
            label = { highlight = true },
        })
    end)
end
