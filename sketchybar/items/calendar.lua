local settings = require("settings")
local colors = require("colors")

-- Padding item required because of bracket

sbar.add("item", "spacer", {
    position = "right",
    width = 5,
    background = {
        color = colors.transparent,
        border_width = 0
    }
})

local cal = sbar.add("item", "widgets.calendar", {
    icon = {
        color = colors.orange,
        font = {
            style = settings.font.style_map["Black"],
            size = 12.0,
        },
    },
    label = {
        color = colors.orange,
        align = "left",
        font = { family = settings.font.numbers },
        width = 73,
    },
    position = "right",
    update_freq = 1,
    padding_left = 13,
    background = {
        border_color = colors.transparent,
    },
    click_script = "open -a 'Calendar'",
})

sbar.add("bracket", "widgets.calendar.bracket", { cal.name }, {
    background = { color = colors.orange_bg, border_width = 0 }
})

-- Padding item required because of bracket
sbar.add("item", "widgets.calendar.padding", { position = "right", width = settings.group_paddings })

cal:subscribe({ "forced", "routine", "system_woke" }, function(env)
    cal:set({ icon = os.date("%A, %d %B"), label = os.date("%H⋮%M⋮%S") })
end)
