-- display.lua — queried once at startup; shared by bar.lua and island.lua
--
-- Uses NSScreen auxiliary areas to get the *actual* notch width for this
-- specific Mac, so the islandbar pill exactly covers the physical notch
-- regardless of model (MBP 14", 16", MBA 13" M3, etc.).
--
--   screen_width  – logical points (e.g. 1728 on MBP 16")
--   notch_width   – logical points (e.g. 162 on MBP 16", ~220 on MBP 14")

local handle = io.popen(
    "osascript -l JavaScript -e '"                                       ..
    "ObjC.import(\"AppKit\");"                                           ..
    "var s=$.NSScreen.mainScreen;"                                       ..
    "var sw=s.frame.size.width;"                                         ..
    "var nw=sw-s.auxiliaryTopLeftArea.size.width"                        ..
    "        -s.auxiliaryTopRightArea.size.width;"                       ..
    "sw+\",\"+nw"                                                        ..
    "' 2>/dev/null"
)
local out = handle and handle:read("*l") or ""
if handle then handle:close() end

local sw, nw = out:match("([%d.]+),([%d.]+)")

return {
    screen_width = math.floor(tonumber(sw) or 1728),
    notch_width  = math.floor(tonumber(nw) or 162),
}
