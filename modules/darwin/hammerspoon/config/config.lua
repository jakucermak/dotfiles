local M = {}

-- ── Sketchybar ────────────────────────────────────────────────────────────────
M.sketchybar = {
    bin          = "/opt/homebrew/bin/sketchybar",
    optHoldDelay = 0.4, -- seconds before opt_hold fires
}

-- ── Hotkeys ───────────────────────────────────────────────────────────────────
-- Prefix modifier for app-launch / utility bindings.
-- Example:  { "cmd", "alt", "ctrl" }
M.hyper = { "cmd", "alt", "ctrl" }

-- ── Power Watch ───────────────────────────────────────────────────────────────
M.powerwatch = {
    -- Toggle between test and production settings
    islandbar = "/opt/homebrew/bin/islandbar",
    ei        = "/Users/jakubcermak/.local/bin/ei",
    testMode  = false,

    production = {
        pollSecs        = 300,  -- query ei every 5 min
        windowHours     = 12,   -- match Activity Monitor's 12 hr power window
        energyThreshold = 500,  -- avg energy impact to trigger on battery
        acThreshold     = 5000, -- avg energy impact to trigger on AC
        minActiveSecs   = 600,  -- ignore launches shorter than 10 min
        requiredPolls   = 2,    -- require consecutive high readings
    },

    test = {
        pollSecs        = 10,   -- query ei every 10 s
        windowHours     = 1,    -- ei averaging window
        energyThreshold = 100,  -- low threshold to fire easily
        acThreshold     = 500,  -- low AC threshold for testing
        minActiveSecs   = 20,   -- keep tests from firing on one sample
        requiredPolls   = 2,
    },

    -- Processes to ignore
    ignore = {
        kernel_task    = true,
        WindowServer   = true,
        loginwindow    = true,
        launchd        = true,
        opendirectoryd = true,
    },
}

-- ── Modules to load ───────────────────────────────────────────────────────────
-- Comment out any module you don't want active.
M.modules = {
    "modules.sketchybar",
    "modules.powerwatch",
}

return M
