local M = {}

local cfg = require("config")

local timer
local fired = false
local tapFlags, tapKeys   -- must be module-level to survive GC

local function trigger(event, args)
    local cmd = cfg.sketchybar.bin .. " --trigger " .. event
    if args then
        for k, v in pairs(args) do
            cmd = cmd .. " " .. k .. "=" .. v
        end
    end
    hs.execute(cmd)
end

local function startOrRestartTimer()
    if timer then timer:stop() end
    timer = hs.timer.doAfter(cfg.sketchybar.optHoldDelay, function()
        fired = true
        trigger("opt_hold", { ARMED = 1 })
    end)
end

function M.start()
    -- Opt+Cmd hold detection via flag changes
    tapFlags = hs.eventtap.new({ hs.eventtap.event.types.flagsChanged }, function(e)
        local flags = e:getFlags()

        if flags.alt and flags.cmd and not timer then
            fired = false
            startOrRestartTimer()
        elseif not flags.alt and timer then
            timer:stop()
            timer = nil

            if fired then
                trigger("opt_hold", { ARMED = 0 })
            end
        end

        return false
    end)
    tapFlags:start()

    -- Any key press while Opt is held resets the hold timer
    tapKeys = hs.eventtap.new({ hs.eventtap.event.types.keyDown }, function(e)
        if hs.eventtap.checkKeyboardModifiers().alt and timer then
            startOrRestartTimer()
        end
        return false
    end)
    tapKeys:start()
end

return M
