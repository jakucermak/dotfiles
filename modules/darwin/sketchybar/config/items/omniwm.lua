local colors = require("colors")
local settings = require("settings")
local app_icons = require("helpers.app_icons")

local omniwm_path = "/opt/homebrew/bin/omniwmctl"
local jq_path = "/opt/homebrew/bin/jq"

local space_icons = { "WEB", "EDIT", "TERM", "COMM", "", "", "" }
local spaces_idx = { "¹", "²", "³", "⁴", "⁵", "⁶", "⁷", "⁸", "⁹", "⁰" }
local layout_icons = {
    niri = "",
    dwindle = "",
}
local max_spaces = #space_icons
local spaces = {}
local last_workspaces = {}
local workspace_layouts = {}

local handle = io.popen("defaults read -g AppleInterfaceStyle 2>/dev/null || echo 'Light'")
local output = handle and handle:read("*a"):match("^%s*(.-)%s*$"):lower() or "light"
local appearance = output

local function workspace_icon(index, workspace, include_index)
    local configured_icon = space_icons[index] or ""
    local display_name = workspace and workspace.display_name or ""
    local base = configured_icon
    local layout = workspace and workspace.layout or workspace_layouts[index]
    local layout_icon = layout_icons[tostring(layout or ""):lower()]

    if base == "" and display_name ~= "" and not display_name:match("^%d+$") then
        base = display_name
    end

    if include_index then
        local index_icon = spaces_idx[index] or tostring(index)
        local icon = base == "" and index_icon or index_icon .. base
        return layout_icon and (icon .. " " .. layout_icon) or icon
    end

    local icon = base == "" and (spaces_idx[index] or tostring(index)) or base
    return layout_icon and (icon .. " " .. layout_icon) or icon
end

local function normalize_omniwm(data)
    if type(data) ~= "table" or data.ok ~= true then
        return nil
    end

    local payload = data.result and data.result.payload
    local monitors = payload and payload.monitors
    if type(monitors) ~= "table" or #monitors == 0 then
        return nil
    end

    local monitor = monitors[1]
    for _, candidate in ipairs(monitors) do
        if candidate.id == payload.interactionMonitorId then
            monitor = candidate
            break
        end
    end

    local normalized = {}
    for _, workspace in ipairs(monitor.workspaces or {}) do
        local index = tonumber(workspace.number) or (#normalized + 1)
        if index <= max_spaces then
            local windows = {}
            for _, window in ipairs(workspace.windows or {}) do
                local count = tonumber(window.windowCount) or 1
                if count < 1 then
                    count = 1
                end

                for _ = 1, count do
                    table.insert(windows, {
                        app_name = window.appName or "Unknown",
                        bundle_id = window.bundleId,
                    })
                end
            end

            normalized[index] = {
                display_name = workspace.displayName or workspace.rawName or tostring(index),
                is_active = workspace.isFocused == true or workspace.isCurrent == true,
                layout = workspace_layouts[index],
                windows = windows,
            }
        end
    end

    return normalized
end

local function refresh_workspace_layouts()
    workspace_layouts = {}

    local command = omniwm_path ..
        " query workspaces 2>/dev/null | " ..
        jq_path ..
        " -r '.result.payload.workspaces[] | [.number, .layout] | @tsv' 2>/dev/null"
    local handle = io.popen(command)
    if not handle then
        return
    end

    for line in handle:lines() do
        local number, layout = line:match("^(%d+)%s+(.+)$")
        local index = tonumber(number)
        if index and index <= max_spaces then
            workspace_layouts[index] = layout
        end
    end
    handle:close()

    for index, workspace in pairs(last_workspaces) do
        workspace.layout = workspace_layouts[index]
    end
end

local function app_icon_for_window(window)
    local app_name = window.app_name or window.bundle_id or "Unknown"
    local lookup = app_icons[window.bundle_id] or app_icons[app_name]

    return ((lookup == nil) and app_icons["Default"] or lookup)
end

local function render_workspaces(workspaces_data)
    last_workspaces = workspaces_data or {}

    sbar.animate("tanh", 10, function()
        for i = 1, max_spaces do
            local workspace = last_workspaces[i]
            local space = spaces[i]

            if space then
                local icon_line = ""
                local has_windows = false

                if workspace and workspace.windows then
                    for _, window in ipairs(workspace.windows) do
                        has_windows = true
                        icon_line = icon_line .. app_icon_for_window(window) .. " "
                    end
                end

                local is_active = workspace and workspace.is_active == true
                space:set({
                    drawing = is_active or has_windows,
                    icon = {
                        string = workspace_icon(i, workspace, false),
                        highlight = is_active,
                        width = (is_active or has_windows) and "dynamic" or 0,
                    },
                    label = {
                        string = icon_line,
                        highlight = is_active,
                        font = "sketchybar-app-font:Regular:15.0",
                        highlight_color = colors[appearance].spaces.fg,
                        color = colors.with_alpha(colors[appearance].spaces.fg, 0.4),
                    },
                })
            end
        end
    end)
end

local function clear_workspaces()
    last_workspaces = {}

    sbar.animate("tanh", 10, function()
        for i = 1, max_spaces do
            local space = spaces[i]
            if space then
                space:set({
                    drawing = false,
                    icon = { highlight = false, width = 0 },
                    label = { string = "", highlight = false, width = 0 },
                })
            end
        end
    end)
end

local function update_workspaces()
    refresh_workspace_layouts()
    sbar.exec(omniwm_path .. " query workspace-bar 2>/dev/null || true", function(omniwm_data)
        local workspaces_data = normalize_omniwm(omniwm_data)
        if workspaces_data then
            render_workspaces(workspaces_data)
        else
            clear_workspaces()
        end
    end)
end

for i = 1, max_spaces do
    local space = sbar.add("item", "omniwm_space." .. i, {
        label = {
            string = "",
            font = "sketchybar-app-font:Regular:15.0",
            highlight_color = colors[appearance].spaces.fg,
            color = colors.with_alpha(colors[appearance].spaces.fg, 0.4),
            y_offset = -2,
            width = 0
        },
        icon = {
            string = space_icons[i],
            highlight_color = colors[appearance].spaces.fg,
            color = colors.with_alpha(colors[appearance].spaces.fg, 0.4),
            font = {
                style = settings.font.style_map["Regular"],
                size = 15.0
            },
            width = 0
        },
        background = {
            color = colors.transparent,
            border_color = colors.transparent,
            border_width = 0
        },
        click_script = omniwm_path .. " command switch-workspace " .. i,
        updates = true,
        padding_right = settings.group_paddings,
        padding_left = settings.group_paddings,
    })

    spaces[i] = space
end

local omniwm_observer = sbar.add("item", "omniwm_observer", {
    drawing = false,
    updates = true,
    update_freq = 2,
})

omniwm_observer:subscribe("routine", function(env)
    update_workspaces()
end)

omniwm_observer:subscribe("omniwm_update", function(env)
    update_workspaces()
end)

local hs_observer = sbar.add("item", {
    drawing = false,
    updates = true
})

local function hs_handle(space, armed)
    local space_id = tonumber(space:query().name:match("([^%.]+)$"))
    local label = space:query().label.value:match("^%s*(.-)%s*$") or ""
    local no_app = label == ""

    if armed == "0" then
        local is_active = last_workspaces[space_id] and last_workspaces[space_id].is_active == true
        space:set({
            icon = {
                string = workspace_icon(space_id, last_workspaces[space_id], false),
                width = (is_active or not no_app) and "dynamic" or 0
            },
            label = {
                string = label,
                width = 0
            },
        })
    else
        space:set({
            icon = {
                string = workspace_icon(space_id, last_workspaces[space_id], true) .. " ⋮ ",
                width = "dynamic"
            },
            label = {
                string = " " .. label,
                width = "dynamic"
            },
        })
    end
end

hs_observer:subscribe("opt_hold", function(env)
    local armed = env.ARMED
    sbar.animate("tanh", 10, function()
        for _, space in ipairs(spaces) do
            hs_handle(space, armed)
        end
    end)
end)

sbar.add("item", {
    position = "q",
    background =
    {
        color = colors.transparent,
        border_width = 0

    },
    drawing = true,
    updates = true,
    width = 15,
})

local front_app = sbar.add("item", "front_app", {
    position = "q",
    display = "active",
    icon = { drawing = false },
    label = {
        font = {
            style = settings.font.style_map["Black"],
        },
        color = colors[appearance].orange
    },
    updates = true,
    width = "dynamic",
    background = {
        color = colors.transparent,
        border_width = 0,
        padding_right = 13,
        padding_left = 13

    },
})

local front_app_bracket = sbar.add("bracket", "front_app.bracket", {
    front_app.name,
}, {
    background = {
        color = colors[appearance].orange_bg,
        padding_left = 0,
        padding_right = 0,
        border_width = 0
    },
    width = "dynamic",
    shadow = true
})

front_app:subscribe("front_app_switched", function(env)
    sbar.animate("tanh", 10, function()
        front_app:set({ label = { string = env.INFO } })
    end)
    update_workspaces()
end)

local space_names = {}
for i = 1, max_spaces do
    table.insert(space_names, spaces[i].name)
end

local bracket = sbar.add("bracket", "items.omniwm.spaces.bracket", space_names, {
    background = {
        color = colors[appearance].spaces.bg,
        border_width = 0,
    },
    shadow = true
})

bracket:subscribe("apperace_change", function(env)
    sbar.exec("defaults read -g AppleInterfaceStyle 2>/dev/null || echo 'Light'", function(theme)
        local new_appearance = theme:match("^%s*(.-)%s*$"):lower()
        appearance = new_appearance

        sbar.animate("tanh", 10, function()
            front_app:set({
                label = {
                    color = colors[appearance].orange,
                },
            })

            front_app_bracket:set({
                background = {
                    color = colors[appearance].orange_bg,
                },
            })

            bracket:set({
                background = {
                    color = colors[appearance].spaces.bg
                }
            })

            for _, space in ipairs(spaces) do
                space:set({
                    label = {
                        highlight_color = colors[appearance].spaces.fg,
                        color = colors.with_alpha(colors[appearance].spaces.fg, 0.4)
                    },
                    icon = {
                        highlight_color = colors[appearance].spaces.fg,
                        color = colors.with_alpha(colors[appearance].spaces.fg, 0.4),
                    },
                })
            end
        end)
    end)
end)

local spacer = sbar.add("item", "spacer.left.panel.inner", {
    icon = {
        drawing = false
    },
    label = {
        drawing = false
    },
    background = {
        color = colors.transparent,
        border_width = 0,
        padding_left = 0,
        padding_right = 0,
    },
    drawing = true,
    updates = true,
    width = 15,
})

sbar.add("bracket", "items.left.panel", {
    front_app_bracket.name,
    bracket.name,
    spacer.name
}, {
    background = {
        color = colors.dark.bar.transparent,
        border_width = 0,
        height = 28,
        padding_left = 0,
        padding_right = 0,
        corner_radius = 5,
    },
})

update_workspaces()
