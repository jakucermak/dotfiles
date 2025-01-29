local colors = require("colors")

-- Equivalent to the --bar domain
sbar.bar({
    topmost = "window",
    height = 40,
    color = colors.with_alpha(colors.bar.bg, 0.85),
    blur_radius = 50,
    padding_right = 0,
    padding_left = 0,
    margin = 5,
    corner_radius = 15,
    y_offset = 02
})
