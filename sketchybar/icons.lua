local settings = require("settings")

local icons = {
    sf_symbols = {
        Tornado = "􁛴",
        active_space = "􀯺",
        apple = "􀣺",
        aqi = "􀴿",
        arrow_circle_down = "􀁱",
        arrow_down = "􀆈",
        bookmark = "􀉟",
        circle = "􀀁",
        clipboard = "􀉄",
        clock = "􀐫",
        cpu = "􀫥",
        direct_current = "􀯝",
        gear = "􀍟",
        inactive_space = "􀯺",
        line = "􀝷",
        loading = "􀖇",
        menu = "􁏯",
        menu_bar = "􀾩",
        menu_bar2 = "􀾚",
        pill = "􀝷",
        pill_lines = "􀝶",
        plus = "􀅼",
        rotate_circle = "􁱀",
        spaces = "􁏮",
        stack = "􀐋",
        stack_right = "􀧏",

        switch = {
            on = "􀠩",
            off = "􁂷"
        },
        volume = {
            _100 = "􀊩",
            _66 = "􀊧",
            _33 = "􀊥",
            _10 = "􀊡",
            _0 = "􀊣"
        },
        battery = {
            _100 = "􀛨",
            _75 = "􀺸",
            _50 = "􀺶",
            _25 = "􀛩",
            _0 = "􀛪",
            charging = "􀢋"
        },
        wifi = {
            upload = "􀄨",
            download = "􀄩",
            connected = "􀙇",
            disconnected = "􀙈",
            router = "􁓤"
        },
        media = {
            back = "􀊊",
            forward = "􀊌",
            play_pause = "􀊈"
        }
    },

    -- Alternative NerdFont icons
    nerdfont = {
        plus = "",
        loading = "",
        apple = "",
        gear = "",
        cpu = "",
        clipboard = "Missing Icon",

        switch = {
            on = "􁏮",
            off = "􁏯"
        },
        volume = {
            _100 = "",
            _66 = "",
            _33 = "",
            _10 = "",
            _0 = ""
        },
        battery = {
            _100 = "",
            _75 = "",
            _50 = "",
            _25 = "",
            _0 = "",
            charging = ""
        },
        wifi = {
            upload = "",
            download = "",
            connected = "󰖩",
            disconnected = "󰖪",
            router = "Missing Icon"
        },
        media = {
            back = "",
            forward = "",
            play_pause = ""
        }
    }
}

if not (settings.icons == "NerdFont") then
    return icons.sf_symbols
else
    return icons.nerdfont
end
