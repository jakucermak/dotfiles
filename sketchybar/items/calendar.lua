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
        padding_left = 8,
        font = {
            style = settings.font.style_map["Black"],
            size = 12.0,
        },
    },
    label = {
        color = colors.orange,
        padding_right = 8,
        width = 49,
        align = "right",
        font = { family = settings.font.numbers },
    },
    position = "right",
    update_freq = 30,
    padding_left = 1,
    padding_right = 1,
    background = {
        -- color = colors.orange_bg,
        border_color = colors.transparent,
    },
    click_script = "open -a 'Calendar'"
})

sbar.add("bracket", "widgets.calendar.bracket", { cal.name }, {
    background = { color = colors.orange_bg, border_width = 0 }
})

-- Padding item required because of bracket
sbar.add("item", "widgets.calendar.padding", { position = "right", width = settings.group_paddings })

cal:subscribe({ "forced", "routine", "system_woke" }, function(env)
    cal:set({ icon = os.date("%A, %d %B"), label = os.date("%H⋮%M ") })
end)
