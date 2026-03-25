local colors = require("colors")

-- Equivalent to the --bar domain
sbar.bar({
    height = 45,
    color = colors.transparent,
    padding_right = 10,
    padding_left = 10,
    blur_radius = 10,
    shadow = true,
    notch_width = 220,
    notch_offset = 0
})
