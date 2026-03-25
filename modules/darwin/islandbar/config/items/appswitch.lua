local island    = require("island")
local icons     = require("icons")
local app_icons = require("helpers.app_icons")

-- ── Config ────────────────────────────────────────────────────────────────────
local config    = {
    width    = 560,
    height   = island.IDLE_H, -- horizontal only, no vertical growth
    duration = 2,
    left     = {              -- application name
        font          = { size = 13, style = "Semibold" },
        padding_left  = 16,
        padding_right = 4,
    },
    right    = {              -- application icon glyph
        font          = "sketchybar-app-font:Regular:25.0",
        align         = "center",
        width         = 36,   -- fixed slot; icon.width fills the rest
        padding_left  = 4,
        padding_right = 16,
    },
}

-- ── State ─────────────────────────────────────────────────────────────────────

local last_app = nil   -- debounce: skip re-expand if same app fires twice

-- ── Listener ──────────────────────────────────────────────────────────────────

local listener  = sbar.add("item", "listener.appswitch", {
    drawing     = false,
    updates     = true,
    update_freq = 0,
    icon        = { drawing = false },
    label       = { drawing = false },
    background  = { drawing = false },
})

listener:subscribe("front_app_switched", function(env)
    local name = env.INFO or ""
    if name == last_app then return end
    last_app = name

    local short = #name > 28 and (name:sub(1, 26) .. "…") or name

    island.expand({
        width    = config.width,
        height   = config.height,
        duration = config.duration,
        left     = {
            text          = short,
            font          = config.left.font,
            padding_left  = config.left.padding_left,
            padding_right = config.left.padding_right,
        },
        right    = {
            text          = app_icons[name] or icons.apple,
            font          = config.right.font,
            align         = config.right.align,
            width         = config.right.width,
            padding_left  = config.right.padding_left,
            padding_right = config.right.padding_right,
        },
    })
end)
