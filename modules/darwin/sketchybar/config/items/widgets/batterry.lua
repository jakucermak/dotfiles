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
    background = { border_width = 0 }
})

battery_bracket:subscribe("apperace_change", function(env)
    battery_status()
end)

function battery_status(dark)
    sbar.exec("defaults read -g AppleInterfaceStyle 2>/dev/null || echo 'Light'", function(theme)
        sbar.exec("pmset -g batt", function(batt_info)
            local icon = "!"
            local label = "?"
            local color = colors["dark"].green
            local color_bg = colors.with_alpha(colors["dark"].green_bg, 0.4)

            local found, _, charge = batt_info:find("(%d+)%%")
            if found then
                charge = tonumber(charge)
                label = charge .. "%"
            end

            local charging, _, _ = batt_info:find("AC Power")
            local dark = theme:find("Dark")
            if dark then
                print("dark")
                label, color, color_bg = colored_label(charging, label, found, charge, "dark", color, color_bg)
            else
                print("light")
                label, color, color_bg = colored_label(charging, label, found, charge, "light", color, color_bg)
            end

            print(label, color, color_bg)

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
end

function colored_label(charging, label, found, charge, apperance, color, color_bg)
    if charging then
        label = label .. " ⚡"
    end
    if found and charge < 35 then
        color = colors[apperance].orange
        color_bg = colors.with_alpha(colors[apperance].orange_bg, 0.4)
    elseif found and charge < 10 then
        color = colors[apperance].red
        color_bg = colors.with_alpha(colors[apperance].red_bg, 0.4)
    else
        color = colors[apperance].green
        color_bg = colors.with_alpha(colors[apperance].green_bg, 0.4)
    end

    return label, color, color_bg
end

battery:subscribe({ "routine", "power_source_change", "system_woke" }, function()
    battery_status("dark")
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
