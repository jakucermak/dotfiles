local colors     = require("colors")
local display    = require("display")

local CORNER_R   = 9
-- margin shrinks bar from both sides so bar width == notch_width, centred on screen
local bar_margin = math.max(0, math.floor((display.screen_width - display.notch_width) / 2))

-- The bar IS the visual pill (solid black).
-- y_offset pushes the bar up so its top rounded corners (CORNER_R = 9 px) sit
-- entirely above the screen edge and are hidden by the notch bezel.
-- Only the bottom rounded corners remain visible → flat-top, rounded-bottom pill.
--
-- ⚠  CONTENT_SHIFT: to move text/icon content inside the pill, change y_offset
-- here (more negative = pill higher = content appears lower in the visible area).
-- Rule: |y_offset| must be ≥ CORNER_R so the rounded top stays hidden.
-- Default safe value = -(CORNER_R + 4) = -13 → content ~12 px below centre.
-- If you want content centred at pill mid-point use -25 (original value).
sbar.bar({
    position      = "top",
    height        = 45,
    color         = 0xff000000, -- solid black; bar is the pill, not transparent
    padding_right = 0,
    padding_left  = 0,
    blur_radius   = 0,
    shadow        = false,
    topmost       = true,
    y_offset      = -9, -- hides corners (≥9 px) AND shifts content ~12 px down
    margin        = bar_margin,
    corner_radius = CORNER_R,
    notch_width   = 0,
    display       = "main",
})
