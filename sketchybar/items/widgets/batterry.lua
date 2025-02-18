local icons = require("icons")
local colors = require("colors")
local settings = require("settings")


local battery = sbar.add("item", "widgets.battery", {
    position = "right",
    icon = {
        font = {
            style = settings.font.style_map["Regular"],
            size = 19.0,
        }
    },
    label = { font = { family = settings.font.numbers } },
    update_freq = 180,
    popup = { align = "center" },
    background = {
        color = colors.transparent,
        border_width = 0,
        padding_right = 13
    }
})

local battery_bracket = sbar.add("bracket", "widgets.battery.bracket", { battery.name }, {
    background = { color = colors.green_bg, border_width = 0 }
})


battery:subscribe({ "routine", "power_source_change", "system_woke" }, function()
    sbar.exec("pmset -g batt", function(batt_info)
        local icon = "!"
        local label = "?"
        local color = colors.green
        local color_bg = colors.green_bg

        local found, _, charge = batt_info:find("(%d+)%%")
        if found then
            charge = tonumber(charge)
            label = charge .. "%"
        end

        local charging, _, _ = batt_info:find("AC Power")

        if charging then
            label = label .. " ⚡"
        else
            if found and charge < 35 then
                color = colors.orange
                color_bg = colors.orange_bg
            elseif found and charge < 10 then
                color = colors.red
                color_bg = colors.red_bg
            else
                color = colors.green
                color_bg = colors.green_bg
            end
        end

        local lead = ""
        if found and charge < 10 then
            lead = "0"
        end

        battery:set({
            label = { string = "B ⋮ " .. lead .. label, color = color },
        })

        battery_bracket:set({
            background = {
                color = color_bg
            }
        })
    end)
end)
local function battery_click(env)
    if env.BUTTON == "right" then
        sbar.exec("open '/System/Applications/Utilities/Activity Monitor.app'")
        return
    end
    sbar.exec("open /System/Library/PreferencePanes/Battery.prefPane")
end

battery:subscribe("mouse.clicked", battery_click)


sbar.add("item", "widgets.battery.padding", {
    position = "right",
    width = settings.group_paddings
})
