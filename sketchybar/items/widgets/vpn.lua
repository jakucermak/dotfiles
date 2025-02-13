local icons = require("helpers.app_icons")
local colors = require("colors")

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

local wg_vpn = sbar.add("alias", "WireGuard,Item-0", {
    position = "right",
    alias = {
        color = colors.green,
    },
    background = {
        color = colors.transparent,
        border_color = colors.transparent,
        border_width = 0,
        height = 26,
    },
    padding_left = -10,
    padding_right = -10,
    click_script = "osascript -e '" .. wg_vpn_osa_script .. "'",
})

local ovpn = sbar.add("alias", "OpenVPN Connect,Item-1", {
    position = "right",
    alias = {
        color = colors.green,
    },
    background = {
        color = colors.with_alpha(colors.green, 0.0),
        border_color = colors.transparent,
        border_width = 0,
        height = 26,
    },
    padding_left = -10,
    padding_right = 0,
    click_script = "osascript -e '" .. ovpn_osa_script .. "'",
})
