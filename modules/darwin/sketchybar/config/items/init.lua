if os.getenv("WM") == "yabai" then
    require("items.spaces")
else
    require("items.aerospace")
end

require("items.calendar")
require("items.widgets")
