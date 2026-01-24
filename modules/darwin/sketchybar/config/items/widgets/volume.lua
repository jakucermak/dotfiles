local colors = require("colors")
local settings = require("settings")

local handle = io.popen("defaults read -g AppleInterfaceStyle 2>/dev/null || echo 'Light'")
local output = handle and handle:read("*a"):match("^%s*(.-)%s*$"):lower() or "light"
local appearance = output

local popup_width = 250

local volume_percent = sbar.add("item", "widgets.volume1", {
    position = "right",
    icon = { drawing = false },
    label = {
        string = " V ⋮ ??%",
        width = 80,
        padding_left = -1,
        font = { family = settings.font.numbers },
        color = colors[appearance].red
    },
})

local volume_bracket = sbar.add("bracket", "widgets.volume.bracket", {
    volume_percent.name
}, {
    background = {
        color = colors.with_alpha(colors[appearance].red_bg, 0.4),
        padding_left = 0,
        padding_right = 0,
        border_width = 0
    },
    popup = { align = "center" },
})

volume_bracket:subscribe("apperace_change", function(env)
    sbar.exec("defaults read -g AppleInterfaceStyle 2>/dev/null || echo 'Light'", function(theme)
        local appearance = theme:match("^%s*(.-)%s*$"):lower()

        volume_bracket:set({
            background = {
                color = colors.with_alpha(colors[appearance].red_bg, 0.4)
            }
        })

        volume_percent:set({
            label = { color = colors[appearance].red }
        })
    end)
end)


sbar.add("item", "widgets.volume.padding", {
    position = "right",
    width = settings.group_paddings
})

local volume_slider = sbar.add("slider", popup_width, {
    position = "popup." .. volume_bracket.name,
    slider = {
        highlight_color = colors[appearance].blue,
        background = {
            height = 6,
            corner_radius = 3,
            color = colors[appearance].bg2,
        },
        knob = {
            string = "􀀁",
            drawing = true,
        },
    },
    background = { color = colors[appearance].bg1, height = 2, y_offset = -20 },
    click_script = 'osascript -e "set volume output volume $PERCENTAGE"'
})

volume_percent:subscribe("volume_change", function(env)
    local volume = tonumber(env.INFO)

    local vol_str = volume .. "% "

    if volume < 99 then
        vol_str = "0" .. volume .. "%"
    end

    if volume < 10 then
        vol_str = "00" .. volume .. "% "
    end

    if volume == 0 then
        vol_str = "MUTED"
    end

    volume_percent:set({ label = " V ⋮ " .. vol_str })
    volume_slider:set({ slider = { percentage = volume } })
end)

local function volume_collapse_details()
    local drawing = volume_bracket:query().popup.drawing == "on"
    if not drawing then return end
    volume_bracket:set({ popup = { drawing = false } })
    sbar.remove('/volume.device\\.*/')
end

local current_audio_device = "None"
local function volume_toggle_details(env)
    if env.BUTTON == "right" then
        sbar.exec("open /System/Library/PreferencePanes/Sound.prefpane")
        return
    end

    local should_draw = volume_bracket:query().popup.drawing == "off"
    if should_draw then
        volume_bracket:set({ popup = { drawing = true } })
        sbar.exec("SwitchAudioSource -t output -c", function(result)
            current_audio_device = result:sub(1, -2)
            sbar.exec("SwitchAudioSource -a -t output", function(available)
                current = current_audio_device
                local color = colors[appearance].grey
                local counter = 0

                for device in string.gmatch(available, '[^\r\n]+') do
                    local color = colors[appearance].grey
                    if current == device then
                        color = colors[appearance].white
                    end
                    sbar.add("item", "volume.device." .. counter, {
                        position = "popup." .. volume_bracket.name,
                        width = popup_width,
                        align = "center",
                        label = { string = device, color = color },
                        click_script = 'SwitchAudioSource -s "' ..
                            device ..
                            '" && sketchybar --set /volume.device\\.*/ label.color=' ..
                            colors[appearance].grey .. ' --set $NAME label.color=' .. colors.dark.white

                    })
                    counter = counter + 1
                end
            end)
        end)
    else
        volume_collapse_details()
    end
end

local function volume_scroll(env)
    local delta = env.INFO.delta
    if not (env.INFO.modifier == "ctrl") then delta = delta * 10.0 end

    sbar.exec('osascript -e "set volume output volume (output volume of (get volume settings) + ' .. delta .. ')"')
end

volume_percent:subscribe("mouse.clicked", volume_toggle_details)
volume_percent:subscribe("mouse.exited.global", volume_collapse_details)
volume_percent:subscribe("mouse.scrolled", volume_scroll)
