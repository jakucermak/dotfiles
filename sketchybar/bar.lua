local colors = require("colors")

-- Equivalent to the --bar domain
sbar.bar({
    topmost = "window",
    height = 40,
    color = colors.with_alpha(colors.bar.bg, 0.65),
    blur_radius = 50,
    padding_right = 0,
    padding_left = 0,
    margin = 25,
    corner_radius = 20,
    y_offset = 05
})
