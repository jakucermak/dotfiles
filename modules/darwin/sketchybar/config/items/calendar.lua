local settings = require("settings")
local colors = require("colors")

local handle = io.popen("defaults read -g AppleInterfaceStyle 2>/dev/null || echo 'Light'")
local output = handle:read("*a"):match("^%s*(.-)%s*$"):lower()
handle:close()
local appearance = output

sbar.add("item", "spacer.calendar", {
    position = "right",
    width = 5,
    background = {
        color = colors.transparent,
        border_width = 0
    }
})

local cal = sbar.add("item", "widgets.calendar", {
    icon = {
        color = colors[appearance].orange,
        font = {
            style = settings.font.style_map["Black"],
            size = 12.0,
        },
    },
    label = {
        color = colors[appearance].orange,
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

local bracket = sbar.add("bracket", "widgets.calendar.bracket", { cal.name }, {
    background = { color = colors.with_alpha(colors[appearance].orange_bg, 0.4), border_width = 0 }
})

bracket:subscribe("apperace_change", function(env)
    sbar.exec("defaults read -g AppleInterfaceStyle 2>/dev/null || echo 'Light'", function(theme)
        local appearance = theme:match("^%s*(.-)%s*$"):lower()
        bracket:set({
            background = {
                color = colors.with_alpha(colors[appearance].orange_bg, 0.4)
            }
        })
        cal:set({
            icon = { color = colors[appearance].orange },
            label = { color = colors[appearance].orange }
        })
    end)
end)

-- Padding item required because of bracket
sbar.add("item", "widgets.calendar.padding", { position = "right", width = settings.group_paddings })

cal:subscribe({ "forced", "routine", "system_woke" }, function(env)
    cal:set({ icon = os.date("%A, %d %B"), label = os.date("%H⋮%M⋮%S") })
end)
