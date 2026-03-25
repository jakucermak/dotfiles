-- items/battery.lua — Low battery notification triggered from Hammerspoon
--
-- Trigger from Hammerspoon:
--   hs.execute("islandbar --trigger island_battery percent=28")
--
-- Parameters:
--   percent   0–100   Battery level (integer or decimal)
--
-- Two severity levels:
--   15–29 % (warning):  small pill, amber, icon + text, auto-dismiss 8 s
--   0–14 %  (critical): large pill, red, centred + subtitle, click to dismiss
--   ≥ 30 %: no notification

local island   = require("island")

-- ── Constants ─────────────────────────────────────────────────────────────────

local AMBER    = 0xffffaa00
local RED      = 0xffff4c4c

-- ── Config ────────────────────────────────────────────────────────────────────

local config   = {
    warning = {
        width    = 480,
        height   = island.IDLE_H,
        duration = 8,
        left     = {
            font          = { size = 20, style = "Regular" },
            padding_left  = 16,
            padding_right = 8,
        },
        right    = {
            font          = { size = 14, style = "Semibold" },
            align         = "left",
            padding_left  = 8,
            padding_right = 16,
        },
    },
    critical = {
        width    = 560,
        height   = island.EXPAND_H,
        duration = 0, -- click to dismiss
        main     = {
            font          = { size = 18, style = "Semibold" },
            align         = "center",
            padding_left  = 16,
            padding_right = 16,
        },
        subtitle = {
            font  = { size = 12, style = "Regular" },
            align = "center",
        },
    },
    die = {
        width    = 560,
        height   = island.EXPAND_H,
        duration = 0, -- click to dismiss
        main     = {
            font          = { size = 18, style = "Semibold" },
            align         = "center",
            padding_left  = 16,
            padding_right = 16,
        },
        subtitle = {
            font  = { size = 18, style = "Regular" },
            align = "center",
        },
    },
}

-- ── Listener ──────────────────────────────────────────────────────────────────

local listener = sbar.add("item", "listener.battery", {
    drawing     = false,
    updates     = true,
    update_freq = 0,
    icon        = { drawing = false },
    label       = { drawing = false },
    background  = { drawing = false },
})

listener:subscribe("island_battery", function(env)
    local pct = math.max(0, math.min(100, tonumber(env.percent) or 100))

    if pct < 2 then
        -- Critical — large pill, red, centred text + subtitle
        island.expand({
            width    = config.die.width,
            height   = config.die.height,
            duration = config.die.duration,
            right    = {
                text          = string.format("%.0f%%", pct),
                font          = config.die.main.font,
                align         = config.die.main.align,
                color         = RED,
                padding_left  = config.die.main.padding_left,
                padding_right = config.die.main.padding_right,
            },
            subtitle = {
                text  = "☠️ ONE PERCENT TO ETERNAL BLACKNESS ☠️🥳",
                color = RED,
                font  = config.die.subtitle.font,
                align = config.die.subtitle.align,
            },
        })
    elseif pct < 15 then
        -- Critical — large pill, red, centred text + subtitle
        island.expand({
            width    = config.critical.width,
            height   = config.critical.height,
            duration = config.critical.duration,
            right    = {
                text          = string.format("󰂃  %.0f%%", pct),
                font          = config.critical.main.font,
                align         = config.critical.main.align,
                color         = RED,
                padding_left  = config.critical.main.padding_left,
                padding_right = config.critical.main.padding_right,
            },
            subtitle = {
                text  = "Battery Critical — Connect your charger now.",
                color = RED,
                font  = config.critical.subtitle.font,
                align = config.critical.subtitle.align,
            },
        })
    elseif pct < 30 then
        -- Warning — small horizontal pill, amber, battery icon + text
        island.expand({
            width    = config.critical.width,
            height   = config.critical.height,
            duration = config.warning.duration,
            left     = {
                text          = "󰁻",
                font          = config.warning.left.font,
                color         = AMBER,
                padding_left  = config.warning.left.padding_left,
                padding_right = config.warning.left.padding_right,
            },
            right    = {
                text          = string.format("%.0f%%", pct),
                font          = config.warning.right.font,
                align         = config.warning.right.align,
                color         = AMBER,
                padding_left  = config.warning.right.padding_left,
                padding_right = config.warning.right.padding_right,
            },
        })
    end
    -- pct ≥ 30: silent, no notification
end)
