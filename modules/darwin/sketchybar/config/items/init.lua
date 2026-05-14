local function command_succeeds(command)
    local ok = os.execute(command .. " >/dev/null 2>&1")
    return ok == true or ok == 0
end

local wm = os.getenv("SKETCHYBAR_WM")

if wm == "omniwm" or (wm ~= "rift" and command_succeeds("/opt/homebrew/bin/omniwmctl ping")) then
    require("items.omniwm")
else
    require("items.rift")
end

require("items.widgets")
