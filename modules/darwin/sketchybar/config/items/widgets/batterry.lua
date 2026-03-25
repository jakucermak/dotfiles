local colors = require("colors")
local settings = require("settings")

local handle = io.popen("defaults read -g AppleInterfaceStyle 2>/dev/null || echo 'Light'")
local output = handle and handle:read("*a"):match("^%s*(.-)%s*$"):lower() or "light"
local appearance = output

local function notify_island(pct)
    if pct == 30 then
        sbar.exec("/opt/homebrew/bin/islandbar --trigger island_battery percent=" .. pct)
    elseif pct < 10 then
        sbar.exec("/opt/homebrew/bin/islandbar --trigger island_battery percent=" .. pct)
    end
end


local function colored_label(charging, label, found, charge, apperance, color, color_bg)
    if charging then
        label = label .. " ⚡"
    end
    if found and charge < 35 then
        color = colors[apperance].orange
        color_bg = colors.with_alpha(colors[apperance].orange_bg, 0.4)
    elseif found and charge < 10 then
        color = colors[apperance].red
        color_bg = colors[apperance].red_bg
    else
        color = colors[apperance].green
        color_bg = colors[apperance].green_bg
    end

    return label, color, color_bg
end

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
    background = {
        border_width = 0,
    },
    shadow = true,
})


local function battery_status()
    sbar.exec("defaults read -g AppleInterfaceStyle 2>/dev/null || echo 'Light'", function(theme)
        sbar.exec("pmset -g batt", function(batt_info)
            local icon = "!"
            local label = "?"
            local color = colors[appearance].green
            local color_bg = colors[appearance].green_bg

            local found, _, charge = batt_info:find("(%d+)%%")
            if found then
                charge = tonumber(charge)
                label = charge .. "%"
            end

            local charging, _, _ = batt_info:find("AC Power")
            appearance = theme:match("^%s*(.-)%s*$"):lower()
            label, color, color_bg = colored_label(charging, label, found, charge, appearance, color, color_bg)
            notify_island(charge)


            local lead = ""
            if found and charge < 10 then
                lead = "0"
            end


            sbar.animate("tanh", 10, function()
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
    end)
end

battery_bracket:subscribe("apperace_change", function(env)
    battery_status()
end)


battery:subscribe({ "routine", "power_source_change", "system_woke" }, function()
    battery_status()
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
