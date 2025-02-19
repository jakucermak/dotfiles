local icons = require("icons")
local colors = require("colors")
local settings = require("settings")

-- Execute the event provider binary which provides the event "network_update"
-- for the network interface "en0", which is fired every 2.0 seconds.
sbar.exec(
    "killall network_load >/dev/null; $CONFIG_DIR/helpers/event_providers/network_load/bin/network_load en0 network_update 2.0")

local ovpn_osa_script = [[tell application "System Events"
    tell process "OpenVPN Connect"
        tell menu bar item 1 of menu bar 2
            click
        end tell
    end tell
end tell]]

local wg_vpn_osa_script = [[tell application "System Events"
    tell process "WireGuard"
            tell menu bar item 1 of menu bar 2
                click
            end tell
    end tell
end tell]]


local wifi_up = sbar.add("item", "widgets.wifi1", {
    position = "right",
    padding_left = -5,
    width = 0,
    icon = {
        padding_right = 0,
        font = {
            style = settings.font.style_map["Bold"],
            size = 9.0,
        },
        string = icons.wifi.upload,
    },
    label = {
        font = {
            family = settings.font.numbers,
            style = settings.font.style_map["Bold"],
            size = 9.0,
        },
        color = colors.red,
        string = "??? Bps",
        width = 50,
    },
    y_offset = 4,
})

local wifi_down = sbar.add("item", "widgets.wifi2", {
    position = "right",
    padding_left = -5,
    -- padding_right = 13,
    icon = {
        padding_right = 0,
        font = {
            style = settings.font.style_map["Bold"],
            size = 9.0,
        },
        string = icons.wifi.download,
    },
    label = {
        font = {
            family = settings.font.numbers,
            style = settings.font.style_map["Bold"],
            size = 9.0,
        },
        color = colors.blue,
        string = "??? Bps",
        width = 50
    },
    y_offset = -4,
})

local wifi = sbar.add("item", "widgets.wifi.padding", {
    position = "right",
    label = { drawing = true },
})

-- Background around the item
local wifi_bracket = sbar.add("bracket", "widgets.wifi.bracket", {
    wifi.name,
    wifi_up.name,
    wifi_down.name
}, {
    background = {
        color = colors.magenta_bg,
        border_width = 0,
    },
    popup = {
        align = "center",
        height = 40,
        background = {
            color = colors.with_alpha(colors.magenta_bg, 0.19),
            border_color = colors.transparent,
            border_width = 0,
            height = 40,
        }
    },
})

sbar.add("alias", "WireGuard", {
    position = "popup." .. wifi_bracket.name,
    alias = {
        color = colors.magenta,
    },
    label = {
        string = "wg0 - 10.9.x.x"
    },
    background = {
        color = colors.transparent,
        border_color = colors.transparent,
        border_width = 0,
        height = 26,

    },
    padding_left = -10,
    padding_right = 0,
    click_script = "osascript -e '" .. wg_vpn_osa_script .. "'",
    width = 200,
})

sbar.add("alias", "OpenVPN Connect", {
    position = "popup." .. wifi_bracket.name,
    alias = {
        color = colors.magenta,
    },
    label = {
        string = "ovpn - 10.8.x.x"
    },
    background = {
        color = colors.transparent,
        border_color = colors.transparent,
        border_width = 0,
        height = 26,
    },
    padding_left = 0,
    padding_right = 0,
    click_script = "osascript -e '" .. ovpn_osa_script .. "'",
    width = 180,
})

sbar.add("item", { position = "right", width = settings.group_paddings })

wifi_up:subscribe("network_update", function(env)
    local up_color = (env.upload == "000 Bps") and colors.grey or colors.red
    local down_color = (env.download == "000 Bps") and colors.grey or colors.blue
    wifi_up:set({
        icon = { color = up_color },
        label = {
            string = env.upload,
            color = up_color
        }
    })
    wifi_down:set({
        icon = { color = down_color },
        label = {
            string = env.download,
            color = down_color
        }
    })
end)

wifi:subscribe({ "wifi_change", "system_woke" }, function(env)
    sbar.exec("ipconfig getsummary en0 | awk -F ' SSID : '  '/ SSID : / {print $2}'", function(result)
        wifi:set({ label = { string = "W ⋮ " .. result, color = colors.magenta } })
    end)
end)

local function hide_details()
    wifi_bracket:set({ popup = { drawing = false } })
end

local function toggle_details(env)
    if env.BUTTON == "right" then
        sbar.exec("open /System/Library/PreferencePanes/Network.prefPane")
        return
    end
    local should_draw = wifi_bracket:query().popup.drawing == "off"
    if should_draw then
        wifi_bracket:set({ popup = { drawing = true } })
    else
        hide_details()
    end
end

wifi_up:subscribe("mouse.clicked", toggle_details)
wifi_down:subscribe("mouse.clicked", toggle_details)
wifi:subscribe("mouse.clicked", toggle_details)
wifi:subscribe("mouse.exited.global", hide_details)

local function copy_label_to_clipboard(env)
    local label = sbar.query(env.NAME).label.value
    sbar.exec("echo \"" .. label .. "\" | pbcopy")
    sbar.set(env.NAME, { label = { string = icons.clipboard, align = "center" } })
    sbar.delay(1, function()
        sbar.set(env.NAME, { label = { string = label, align = "right" } })
    end)
end
