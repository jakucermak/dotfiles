local colors  = require("colors")
local display = require("display")

local CORNER_R   = 25
-- margin shrinks bar from both sides so bar width == notch_width, centred on screen
local bar_margin = math.max(0, math.floor((display.screen_width - display.notch_width) / 2))

-- The bar IS the visual pill (solid black).
-- y_offset = -CORNER_R pushes the bar up so its top rounded corners sit
-- entirely above the screen edge and are hidden by the notch bezel.
-- Only the bottom rounded corners remain visible → flat-top, rounded-bottom pill.
sbar.bar({
    position      = "top",
    height        = 45,
    color         = 0xff000000,   -- solid black; bar is the pill, not transparent
    padding_right = 0,
    padding_left  = 0,
    blur_radius   = 0,
    shadow        = false,
    topmost       = true,
    y_offset      = -CORNER_R,    -- hide top rounded corners above screen edge
    margin        = bar_margin,
    corner_radius = CORNER_R,
    notch_width   = 0,
})
