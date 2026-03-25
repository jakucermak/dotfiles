-- items/cpuload.lua — CPU load notification triggered from Hammerspoon
--
-- Trigger from Hammerspoon:
--   hs.execute("islandbar --trigger island_cpuload percent=85 app=Chrome")
--
-- Parameters:
--   app       string  application name
--   percent   0–100   CPU load percentage, decimals accepted (e.g. 16.05)
--
-- Layout (two lines, centred):
--   line 1:  [        AppName  ·  85.3%        ]   centred, no split
--   line 2:  [   subtitle message, centred     ]
--
-- Dismissed by clicking the pill (no auto-dismiss).
--
-- Color thresholds (applied to percentage and subtitle):
--   < 50 %  → white
--   50–79 % → amber
--   ≥ 80 %  → red

local island = require("island")

-- ── Config ────────────────────────────────────────────────────────────────────

local config = {
    width    = 560,
    height   = island.EXPAND_H,
    duration = 0, -- no auto-dismiss; click the pill to close
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
}

-- ── Helpers ───────────────────────────────────────────────────────────────────

local function load_color(pct)
    if pct >= 80 then
        return 0xffff4c4c -- red
    elseif pct >= 50 then
        return 0xffffaa00 -- amber
    else
        return 0xffffffff -- white
    end
end

-- ── Listener ──────────────────────────────────────────────────────────────────

local listener = sbar.add("item", "listener.cpuload", {
    drawing     = false,
    updates     = true,
    update_freq = 0,
    icon        = { drawing = false },
    label       = { drawing = false },
    background  = { drawing = false },
})

listener:subscribe("island_cpuload", function(env)
    local pct   = math.max(0, math.min(100, tonumber(env.percent) or 0))
    local app   = env.app or "Unknown"
    local color = load_color(pct)
    local short = #app > 22 and (app:sub(1, 20) .. "…") or app

    island.expand({
        width    = config.width,
        height   = config.height,
        duration = config.duration,
        right    = {
            text          = short .. "  ·  " .. string.format("%.1f%%", pct),
            font          = config.main.font,
            align         = config.main.align,
            color         = color,
            padding_left  = config.main.padding_left,
            padding_right = config.main.padding_right,
        },
        subtitle = {
            text  = "Significant power usage · may drain battery quickly.",
            color = color,
            font  = config.subtitle.font,
            align = config.subtitle.align,
        },
    })
end)
