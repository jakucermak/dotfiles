require("items.widgets.wifi")
require("items.widgets.batterry")
require("items.widgets.volume")
require("items.widgets.calendar")
require("items.widgets.ccu")

local colors = require("colors")

local spacer2 = sbar.add("item", {
    background =
    {
        color = colors.transparent,
        border_width = 0

    },
    drawing = true,
    updates = true,
    width = 15,
})

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
    "widgets.ccu.bracket",
    "widgets.calendar.bracket",
    "widgets.wifi.bracket",
    "widgets.battery.bracket",
    "widgets.volume.bracket",
    spacer.name,
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
