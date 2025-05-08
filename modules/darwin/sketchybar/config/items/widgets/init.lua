require("items.widgets.wifi")
require("items.widgets.batterry")
require("items.widgets.volume")

local colors = require("colors")

local spacer = sbar.add("item", "spacer.right", {
    position = "right",
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
        padding_right = 0,
        padding_left = 0
    },
    drawing = true,
    width = 10,
})



local panel = sbar.add("bracket", "items.right.panel", {
    "widgets.calendar.bracket",
    "widgets.wifi.bracket",
    "widgets.battery.bracket",
    "widgets.volume.bracket",
    spacer.name,
}, {
    background = {
        color = colors.bar.bg,
        border_width = 0,
        height = 28,
        padding_left = 0,
        padding_right = 0,
        corner_radius = 5,
    },
})
