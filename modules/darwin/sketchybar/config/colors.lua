return {
    black = 0xff181880,
    white = 0xffe2e2e3,
    red = 0xffF07178,
    red_bg = 0x30F07178,
    green = 0xffAAD94C,
    green_bg = 0x30AAD94C,
    blue = 0xFF39BAE6,
    blue_bg = 0x3039BAE6,
    yellow = 0xff,
    magenta = 0xffD2A6FF,
    magenta_bg = 0x30D2A6FF,
    grey = 0xffBFBDB6,
    grey_bg = 0x30BFBDB6,
    transparent = 0x00000000,
    orange = 0xFFFF8F40,
    orange_bg = 0x30E6B673,
    fg = 0xFFBFBDB6,
    fg_bg = 0x30BFBDB6,

    bar = {
        bg = 0xcc0B0E14,
        border = 0xff2c2e34,
    },
    popup = {
        bg = 0x302c2e34,
        border = 0xff7f8490
    },
    bg1 = 0xff363944,
    bg2 = 0xff414550,

    with_alpha = function(color, alpha)
        if alpha > 1.0 or alpha < 0.0 then return color end
        return (color & 0x00ffffff) | (math.floor(alpha * 255.0) << 24)
    end,
}
