local colors = require("colors")
local settings = require("settings")
local app_icons = require("helpers.app_icons")

local yabai_path = "/etc/profiles/per-user/jakubcermak/bin/yabai"

-- local function dump_table(t, indent)
--     indent = indent or 0
--     local padding = string.rep("  ", indent)

--     for k, v in pairs(t) do
--         if type(v) == "table" then
--             print(padding .. tostring(k) .. " = {")
--             dump_table(v, indent + 1)
--             print(padding .. "}")
--         else
--             print(padding .. tostring(k) .. " = " .. tostring(v))
--         end
--     end
-- end

sbar.add("item", { position = "left", width = settings.group_paddings, })
local superscript = { "¹", "²", "³", "⁴", "⁵", "⁶", "⁷", "⁸", "⁹", "⁰" }

local spaces = {}

for i = 1, 10, 1 do
    local space = sbar.add("space", "space." .. i, {
        space = i,
        label = { string = "", font = "sketchybar-app-font:Regular:15.0", highlight_color = colors.blue, color = colors.grey_bg, y_offset = -2 },
        icon = { string = superscript[i], highlight_color = colors.blue, font = "JetBrainsMono Nerd Font:Regular:15.0" },
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
            size = 12.0,
        },
        color = colors.blue
    },
    updates = true,
    padding_left = 0
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

sbar.add("bracket", "items.spaces.bracket", space_names, {
    background = {
        color = colors.blue_bg,
        border_width = 0
    }
})
