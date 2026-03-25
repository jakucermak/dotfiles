local colors = require("colors")
local settings = require("settings")
local app_icons = require("helpers.app_icons")

local yabai_path = "/opt/homebrew/bin/yabai"


-- sbar.add("item", { position = "left", width = settings.group_paddings, })
local superscript = { "¹", "²", "³", "⁴", "⁵", "⁶", "⁷", "⁸", "⁹", "⁰" }

local spaces = {}

local handle = io.popen("defaults read -g AppleInterfaceStyle 2>/dev/null || echo 'Light'")
local output = handle and handle:read("*a"):match("^%s*(.-)%s*$"):lower() or "light"
local appearance = output

for i = 1, 10, 1 do
    local space = sbar.add("space", "space." .. i, {
        space = i,
        label = { string = "", font = "sketchybar-app-font:Regular:15.0", highlight_color = colors[appearance].spaces.fg, color = colors.with_alpha(colors[appearance].spaces.fg, 0.4), y_offset = 0 },
        icon = { string = superscript[i], highlight_color = colors[appearance].spaces.fg, color = colors.with_alpha(colors[appearance].spaces.fg, 0.4), },
        background = {
            color = colors.transparent,
            border_color = colors.transparent,
        },
        click_script = yabai_path .. " -m space --focus " .. i,
        updates = true,
        padding_right = settings.group_paddings,
        padding_left = settings.group_paddings,
    })

    spaces[i] = space


    space:subscribe("space_change", function(env)
        local selected = env.SELECTED == "true"

        sbar.exec(yabai_path .. " -m query --windows --space " .. env.SID, function(windows)
            local window_cnt = #windows


            sbar.animate("tanh", 15, function()
                space:set({
                    icon = { highlight = selected, },
                    label = { highlight = selected },
                    drawing = selected or window_cnt > 0
                })
            end)
        end)
    end)
end


local front_app = sbar.add("item", "front_app", {
    display = "active",
    icon = { drawing = false },
    label = {
        font = {
            style = settings.font.style_map["Thin"],
            -- size = 15.0,
        },
        color = colors[appearance].spaces.fg
    },
    updates = true,
    padding_left = 0,
    width = 150
})


local space_window_observer = sbar.add("item", {
    drawing = false,
    updates = true,
})

space_window_observer:subscribe("space_windows_change", function(env)
    local icon_line = ""
    local no_app = true
    local space = spaces[env.INFO.space]
    for app, count in pairs(env.INFO.apps) do
        no_app = false
        local lookup = app_icons[app]
        local icon = ((lookup == nil) and app_icons["Default"] or lookup)
        icon_line = icon_line .. icon
    end

    sbar.animate("tanh", 15, function()
        space:set({ label = icon_line, drawing = not no_app
        })
    end)
end)

front_app:subscribe("front_app_switched", function(env)
    front_app:set({ label = { string = env.INFO } })
end)

local space_names = {}
for i = 1, 9 do
    table.insert(space_names, spaces[i].name)
end
table.insert(space_names, front_app.name)

local bracket = sbar.add("bracket", "items.spaces.bracket", space_names, {
    background = {
        color = colors[appearance].spaces.bg,
        border_width = 0,
    }
})

bracket:subscribe("apperace_change", function(env)
    sbar.exec("defaults read -g AppleInterfaceStyle 2>/dev/null || echo 'Light'", function(theme)
        local appearance = theme:match("^%s*(.-)%s*$"):lower()

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

local spacer = sbar.add("item", "spacer.left.panel.inner", {
    icon = {
        drawing = false
    },
    label = {
        drawing = false
    },
    background =
    {
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
