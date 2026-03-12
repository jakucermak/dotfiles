return {
    light = {
        black = 0xff181880,
        white = 0xffFCFCFC,
        red = 0xffE65050,
        red_bg = 0xFFF07171,
        green = 0xff86B300,
        green_bg = 0xFF86B300,
        blue = 0xFF55B4D4,
        blue_bg = 0x26035BD6,
        yellow = 0xffF2AE49,
        magenta = 0xff9F40FF,
        magenta_bg = 0xFFA37ACC,
        grey = 0xff5C6166,
        grey_bg = 0xFF8A9199,
        orange = 0xFFFA8D3E,
        orange_bg = 0xFFE6BA7E,
        fg = 0xFF5C6166,
        fg_bg = 0x305C6166,

        spaces = {
            bg = 0xFF8A9199,
            fg = 0xffFCFCFC,
        },

        bar = {
            bg = 0xcc1F2531,
            border = 0xff2c2e34,
        },
        popup = {
            bg = 0x302c2e34,
            border = 0xff7f8490
        },
        bg1 = 0xff363944,
        bg2 = 0xff414550,

    },
    dark = {
        black = 0xff181880,
        white = 0xffe2e2e3,
        red = 0xffF07178,
        red_bg = 0xFFF07178,
        green = 0xffAAD94C,
        green_bg = 0xFFAAD94C,
        blue = 0xFF59C2FF,
        blue_bg = 0xFF131721,
        yellow = 0xffFFB454,
        magenta = 0xffD2A6FF,
        magenta_bg = 0xFFD2A6FF,
        grey = 0xffBFBDB6,
        grey_bg = 0xFFBFBDB6,
        orange = 0xFFFFB454,
        orange_bg = 0xFFE6B673,
        fg = 0xFFBFBDB6,
        fg_bg = 0x30BFBDB6,

        spaces = {
            bg = 0xFF131721,
            fg = 0xFF59C2FF,
        },

        bar = {
            bg = 0xcc1F2531,
            border = 0xff2c2e34,
        },
        popup = {
            bg = 0x302c2e34,
            border = 0xff7f8490
        },
        bg1 = 0xff363944,
        bg2 = 0xff414550,
    },

    transparent = 0x00000000,
    with_alpha = function(color, alpha)
        if alpha > 1.0 or alpha < 0.0 then return color end
        return (color & 0x00ffffff) | (math.floor(alpha * 255.0) << 24)
    end,
}
