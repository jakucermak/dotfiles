local colors = require("colors")
local settings = require("settings")
local app_icons = require("helpers.app_icons")

local superscript = { "¹", "²", "³", "⁴", "⁵", "⁶", "⁷", "⁸", "⁹", "⁰" }

sbar.add("item", { position = "left", width = settings.group_paddings, })

local spaces = {}

local function updateWindows(space_index)
    local space = spaces[space_index]

    sbar.exec("yabai -m query --windows --space " .. space_index, function(windows)
        local icon_line = ""
        local no_app = true

        for window in windows do
            no_app = false
            local app = window.app
            local lookup = app_icons[app]
            local icon = ((lookup == nil) and app_icons["default"] or lookup)
            icon_line = icon_line .. " " .. icon
        end

        if no_app then
            space:set({ drawing = false })
        else
            space:set({ drawing = true })
        end

        sbar.animate("tanh", 10, function()
            spaces[space_index]:set({
                label = { string = icon_line, font = "sketchybar-app-font:Regular:15.0", highlight_color = colors.blue, color = colors.grey_bg, y_offset = -2 },
                icon = { string = superscript[space_index], highlight_color = colors.blue, font = "JetBrainsMono Nerd Font:Regular:15.0" },
                padding_right = 2,
                padding_left = 0,
            })
        end)
    end)
end

for space_index = 1, 9 do
    local space = sbar.add("space", "space." .. space_index, {
        space = space_index,
        label = {
            padding_right = 10,
            color = colors.grey,
            highlight_color = colors.blue,
            y_offset = 1,
        },
        padding_right = 1,
        padding_left = 1,
        background = {
            color = colors.transparent,
            border_color = colors.transparent,
        },
        click_script = "yabai -m space --focus " .. space_index,
        updates = true,
    })

    spaces[space_index] = space

    space:subscribe("space_change", function(env)
        local is_focused = env.SELECTED == "true"
        updateWindows(space_index)

        sbar.animate("tanh", 10, function()
            space:set({
                icon = { highlight = is_focused },
                label = { highlight = is_focused },
            })
        end)
    end)

    space:subscribe("window_focus", function()
        updateWindows(space_index)
    end)

    space:subscribe("display_change", function()
        updateWindows(space_index)
    end)

    -- initial setup
    updateWindows(space_index)
end

local front_app = sbar.add("item", "front_app", {
    display = "active",
    icon = { drawing = false },
    label = {
        font = {
            style = settings.font.style_map["Thin"],
            size = 12.0,
        },
        color = colors.blue
    },
    updates = true,
})

front_app:subscribe("front_app_switched", function(env)
    front_app:set({ label = { string = env.INFO } })
end)

front_app:subscribe("mouse.clicked", function(env)
end)

-- Create space items bracket
local space_names = {}
for i = 1, 9 do
    table.insert(space_names, spaces[i].name)
end
table.insert(space_names, front_app.name)

sbar.add("bracket", "items.spaces.bracket", space_names, {
    background = {
        color = colors.blue_bg,
        border_width = 0
    }
})
