local colors = require("colors")
local icons = require("icons")
local settings = require("settings")

-- Padding item required because of bracket
sbar.add("item", {
    width = 15
})

local apple = sbar.add("item", {
    icon = {
        font = {
            size = 14.0
        },
        string = icons.pill_lines,
        padding_right = 10,
        padding_left = 8,
        color = 0xffC0D84C,
    },
    label = {
        drawing = false
    },
    background = {
        color = colors.transparent,
        border_color = colors.transparent,
        border_width = 0,
        height = 20

    },
    padding_left = 5,
    padding_right = 5,
    click_script = "$CONFIG_DIR/helpers/menus/bin/menus -s 0"
})

apple:subscribe("mouse.entered", function()
    sbar.animate("tanh", 30, function()
    apple:set({
        icon = {
            string = icons.pill,
        }

    })
    end)
end)

apple:subscribe("mouse.exited", function()
    sbar.animate("tanh", 30, function()
    apple:set({
        icon = {
            string = icons.pill_lines,
        }
    })
    end)
end)

-- Double border for apple using a single item bracket
sbar.add("bracket", {apple.name}, {
    background = {
        color = colors.transparent,
        height = 18,
        border_color = colors.transparent,
        border_width = 0
    }
})
