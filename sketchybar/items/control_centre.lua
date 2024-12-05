local colors = require("colors")
local icons = require("icons")

local osa_script = [[tell application "System Events"
    tell process "ControlCenter"
        tell menu bar item 2 of menu bar 1
            click
        end tell
    end tell
end tell]]

local control_centre = sbar.add("item", {
	position = "right",
	icon = {
		font = { size = 16.0 },
		string = icons.gear,
		color = colors.yellow,
		padding_right = 8,
		padding_left = 12,
	},
	label = {
		string = "Control Center",
		width = 0,
		padding_right = 12,
	},
	background = {
		color = colors.with_alpha(colors.yellow, 0.0),
		border_color = colors.black,
		border_width = 1,
		height = 26,
		corner_radius = 20,
	},
	padding_left = 1,
	padding_right = 8,
	click_script = "osascript -e '" .. osa_script .. "'",
})

-- Double border for apple using a single item bracket
sbar.add("bracket", { control_centre.name }, {
	background = {
		color = colors.transparent,
		height = 30,
		border_color = colors.grey,
	},
})

control_centre:subscribe("mouse.entered", function(env)
	sbar.animate("tanh", 30, function()
		control_centre:set({
			background = {
				color = { alpha = 1.0 },
				border_color = { alpha = 1.0 },
			},
			icon = { color = colors.bg2 },
			label = {
				width = "dynamic",
				color = colors.bg2,
			},
		})
	end)
end)

control_centre:subscribe("mouse.exited", function(env)
	sbar.animate("tanh", 30, function()
		control_centre:set({
			background = {
				color = { alpha = 0.0 },
				border_color = { alpha = 0.0 },
			},
			icon = { color = colors.yellow },
			label = { width = 0 },
		})
	end)
end)
