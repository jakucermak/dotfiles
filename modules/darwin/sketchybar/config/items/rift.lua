local colors = require("colors")
local settings = require("settings")
local app_icons = require("helpers.app_icons")

-- Chinese numerals for space icons (matching the bash script)
local space_icons = { "WEB⋮", "EDIT⋮", "TERM⋮", "Comm⋮" }
local max_spaces = #space_icons

local spaces = {}

local function print_table(t, indent)
    indent = indent or 0
    local spacing = string.rep("  ", indent)

    if type(t) ~= "table" then
        print(spacing .. tostring(t))
        return
    end

    for k, v in pairs(t) do
        if type(v) == "table" then
            print(spacing .. tostring(k) .. ":")
            print_table(v, indent + 1)
        else
            print(spacing .. tostring(k) .. ": " .. tostring(v))
        end
    end
end

local handle = io.popen("defaults read -g AppleInterfaceStyle 2>/dev/null || echo 'Light'")
local output = handle and handle:read("*a"):match("^%s*(.-)%s*$"):lower() or "light"
local appearance = output

local function updateWorkspaceWindows(workspace_index)
    sbar.exec("rift-cli query workspaces", function(rift_data)
        if not rift_data or #rift_data == 0 then
            return
        end

        local workspace = rift_data[workspace_index]
        local icon_line = ""
        local no_app = true

        if workspace and workspace.windows then
            for _, window in ipairs(workspace.windows) do
                no_app = false
                local app_name = window.title or window.bundle_id or "Unknown"
                local lookup = app_icons[window.bundle_id] or app_icons[app_name]
                local icon = ((lookup == nil) and app_icons["Default"] or lookup)
                icon_line = icon_line .. " " .. icon
            end
        end

        local space = spaces[workspace_index]
        if space then
            sbar.animate("tanh", 10, function()
                space:set({
                    label = {
                        string = icon_line,
                        font = "sketchybar-app-font:Regular:15.0",
                        highlight_color = colors[appearance].spaces.fg,
                        color = colors.with_alpha(colors[appearance].spaces.fg, 0.4),
                    },
                    drawing = not no_app or (workspace and workspace.is_active)
                })
            end)
        end
    end)
end

local function updateActiveWorkspace()
    sbar.exec("rift-cli query workspaces", function(rift_data)
        if not rift_data or #rift_data == 0 then
            -- Clear all borders if no data
            for i = 1, max_spaces do
                if spaces[i] then
                    spaces[i]:set({
                        background = { border_width = 0 },
                        icon = { highlight = false },
                        label = { highlight = false }
                    })
                end
            end
            return
        end

        -- Find active workspace
        local active_index = nil
        for i, workspace in ipairs(rift_data) do
            if workspace.is_active then
                active_index = i
                break
            end
        end

        -- Update all workspaces
        for i = 1, max_spaces do
            local space = spaces[i]
            if space then
                local is_active = (i == active_index)
                sbar.animate("tanh", 10, function()
                    space:set({
                        icon = { highlight = is_active },
                        label = { highlight = is_active }
                    })
                end)
            end
        end
    end)
end

-- Create workspace items
for i = 1, max_spaces do
    local space = sbar.add("item", "rift_space." .. i, {
        label = {
            string = "",
            font = "sketchybar-app-font:Regular:15.0",
            highlight_color = colors[appearance].spaces.fg,
            color = colors.with_alpha(colors[appearance].spaces.fg, 0.4),
            y_offset = -2
        },
        icon = {
            string = space_icons[i],
            highlight_color = colors[appearance].spaces.fg,
            color = colors.with_alpha(colors[appearance].spaces.fg, 0.4),
            font = "JetBrainsMono Nerd Font:Regular:15.0"
        },
        background = {
            color = colors.transparent,
            border_color = colors.transparent,
            border_width = 0
        },
        click_script = "rift-cli execute workspace switch " .. (i - 1), -- rift uses 0-based indexing
        updates = true,
        padding_right = settings.group_paddings,
        padding_left = settings.group_paddings,
    })

    spaces[i] = space
end

-- Event handling
local rift_observer = sbar.add("item", {
    drawing = false,
    updates = true,
})

rift_observer:subscribe("rift_workspace_changed", function(env)
    updateActiveWorkspace()
    for i = 1, max_spaces do
        updateWorkspaceWindows(i)
    end
end)

rift_observer:subscribe("rift_windows_changed", function(env)
    updateActiveWorkspace()
    for i = 1, max_spaces do
        updateWorkspaceWindows(i)
    end
end)

-- Front app display
local front_app = sbar.add("item", "front_app", {
    display = "active",
    icon = { drawing = false },
    label = {
        font = {
            style = settings.font.style_map["Thin"],
        },
        color = colors[appearance].spaces.fg
    },
    updates = true,
    padding_left = 0,
    width = 150
})

front_app:subscribe("front_app_switched", function(env)
    front_app:set({ label = { string = env.INFO } })
end)

-- Create bracket with all spaces
local space_names = {}
for i = 1, max_spaces do
    table.insert(space_names, spaces[i].name)
end
table.insert(space_names, front_app.name)

local bracket = sbar.add("bracket", "items.spaces.bracket", space_names, {
    background = {
        color = colors[appearance].spaces.bg,
        border_width = 0,
    }
})

-- Appearance change handling
bracket:subscribe("apperace_change", function(env)
    sbar.exec("defaults read -g AppleInterfaceStyle 2>/dev/null || echo 'Light'", function(theme)
        local new_appearance = theme:match("^%s*(.-)%s*$"):lower()
        appearance = new_appearance

        front_app:set({
            label = {
                color = colors[appearance].spaces.fg,
            },
        })

        bracket:set({
            background = {
                color = colors[appearance].spaces.bg
            }
        })

        for index, space in ipairs(spaces) do
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

-- Spacer
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

-- Main panel bracket
sbar.add("bracket", "items.left.panel", {
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

-- Initial setup
updateActiveWorkspace()
for i = 1, max_spaces do
    updateWorkspaceWindows(i)
end
