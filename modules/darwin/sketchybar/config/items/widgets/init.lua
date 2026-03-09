require("items.widgets.wifi")
require("items.widgets.batterry")
require("items.widgets.volume")
require("items.widgets.ccu")

local colors = require("colors")

local function dump_table(t, indent)
    indent = indent or 0
    local padding = string.rep("  ", indent)

    for k, v in pairs(t) do
        if type(v) == "table" then
            print(padding .. tostring(k) .. " = {")
            dump_table(v, indent + 1)
            print(padding .. "}")
        else
            print(padding .. tostring(k) .. " = " .. tostring(v))
        end
    end
end
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


-- apperance:subscribe("apperace_change", function(env)
--     sbar.exec("defaults read -g defaults read -g AppleInterfaceStyle 2>/dev/null || echo "Light"", function(theme)
--         local dark, _, _ = theme:find("Dark")
--         if dark then
--             print("dark")
--         else
--             print("light")
--         end
--     end)
-- end)

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
