package.cpath = package.cpath .. ";/Users/" .. os.getenv("USER") .. "/.local/share/sketchybar_lua/?.so"
-- Require the sketchybar module
sbar = require("sketchybar")

-- Set the bar name, if you are using another bar instance than sketchybar
sbar.set_bar_name("islandbar")

-- Bundle the entire initial configuration into a single message to sketchybar
sbar.begin_config()
sbar.add("event", "apperace_change", "AppleInterfaceThemeChangedNotification")
sbar.add("event", "island_tap")
require("bar")
require("default")
require("island")
require("items")
sbar.end_config()

-- Run the event loop of the sketchybar module (without this there will be no
-- callback functions executed in the lua module)
sbar.event_loop()
