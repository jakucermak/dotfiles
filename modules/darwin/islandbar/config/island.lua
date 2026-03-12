-- island.lua — Dynamic Notch animation engine
--
-- Public API:
--   island.expand(item)       animate to the described state
--   island.restore_idle()     animate back to silent notch
--   island.IDLE_H, island.EXPAND_H   height constants for item descriptors
--
-- item descriptor fields (all optional):
--   width    number   pill width  (default: notch width)
--   height   number   bar height  (default: IDLE_H)
--   left     table    icon slot   { text, font={size,style,family}, color,
--                                   padding_left, padding_right }
--   right    table    label slot  { text, font=…, color, align,
--                                   padding_left, padding_right }
--   duration number   auto-dismiss seconds; 0 = no dismiss (default: 0)
--
-- Slide effect: both slots start centered + transparent inside the narrow
-- notch pill.  On expand the icon alignment shifts to "left" and the label
-- to "right" while the pill grows and color fades in — content slides
-- outward from the centre of the screen.  restore_idle reverses this.

local settings    = require("settings")
local display     = require("display")

-- ── Internal constants ────────────────────────────────────────────────────────

local WHITE       = 0xffffffff
local TRANSPARENT = 0x00ffffff

local NOTCH_W     = display.notch_width
local CORNER_R    = 9 -- must match bar.lua
local IDLE_H      = 51
local EXPAND_H    = 125

-- Vertical content position is controlled by bar.y_offset in bar.lua — NOT by
-- item-level y_offset.  Reason: sketchybar resets item y_offset to 0 at the
-- start of each sbar.animate() batch and interpolates to the target, producing
-- a visible vertical jitter that corrupts horizontal layout.  The bar y_offset
-- is a partial-update property that is immune to this behaviour.
-- To shift content: edit y_offset in bar.lua (more positive = lower content).

local ORIG_MARGIN = math.max(0, math.floor((display.screen_width - NOTCH_W) / 2))

-- ── Helpers ───────────────────────────────────────────────────────────────────

local function resolve_font(f)
    f = f or {}
    local style = f.style or "Semibold"
    return {
        family = f.family or settings.font.text,
        style  = settings.font.style_map[style] or style,
        size   = f.size or 13,
    }
end

-- Auto-place label near the bottom for vertically expanded bars.
local function auto_y_offset(h, padding)
    padding              = padding or 12
    local visible_bottom = h - CORNER_R
    local item_centre    = h / 2 - CORNER_R
    return math.floor(visible_bottom - padding - item_centre)
end

-- ── Island item ───────────────────────────────────────────────────────────────

local island           = sbar.add("item", "island.main", {
    position      = "center",
    width         = NOTCH_W,
    updates       = true,
    padding_left  = 0,
    padding_right = 0,
    -- NO y_offset here: any item-level y_offset in island:set() inside
    -- sbar.animate() is animated from 0 each frame, causing visible jitter.
    click_script  = "islandbar --trigger island_tap",
    icon          = {
        drawing       = true,
        color         = TRANSPARENT,
        string        = "",
        align         = "center", -- idle: centred so it slides outward on expand
        font          = resolve_font({}),
        padding_left  = 12,
        padding_right = 4,
    },
    label         = {
        drawing       = true,
        color         = TRANSPARENT,
        string        = "",
        align         = "center", -- idle: centred so it slides outward on expand
        font          = resolve_font({}),
        width         = NOTCH_W - 20,
        padding_left  = 4,
        padding_right = 12,
        scroll_texts  = true,
    },
    background    = { drawing = false },
})

-- ── 1 Hz dismiss timer ────────────────────────────────────────────────────────

local timer            = sbar.add("item", "island.timer", {
    position      = "center",
    drawing       = false,
    updates       = true,
    update_freq   = 1,
    padding_left  = 0,
    padding_right = 0,
    icon          = { drawing = false },
    label         = { drawing = false },
    background    = { drawing = false },
})

-- ── Shared state ──────────────────────────────────────────────────────────────

local dismiss_deadline = 0 -- os.time() value after which we auto-dismiss; 0 = no dismiss
local is_expanded      = false

-- ── Public API ────────────────────────────────────────────────────────────────

local M                = {}
M.IDLE_H               = IDLE_H
M.EXPAND_H             = EXPAND_H

function M.expand(item)
    item          = item or {}

    local w       = item.width or NOTCH_W
    local h       = item.height or IDLE_H
    local mg      = math.max(0, math.floor((display.screen_width - w) / 2))

    local L       = item.left
    local R       = item.right

    local lpl     = L and (L.padding_left or 12) or 12
    local lpr     = L and (L.padding_right or 4) or 4
    local rpl     = R and (R.padding_left or 4) or 4
    local rpr     = R and (R.padding_right or 12) or 12

    local r_fixed = (L and R) and (R.width or 36) or nil
    local l_width = r_fixed and math.max(0, w - lpl - lpr - rpl - rpr - r_fixed) or nil
    local r_width = r_fixed or (w - 20)

    -- Alignment animates from "center" (idle) to final position → outward slide
    local l_align = "left"
    local r_align = (R and R.align) or (L and "right" or "center")

    sbar.animate("tanh", 20, function()
        sbar.bar({ height = h, margin = mg })
        island:set({
            width = w,
            icon  = {
                string        = L and (L.text or "") or "",
                color         = L and (L.color or WHITE) or TRANSPARENT,
                font          = L and L.font or resolve_font({}),
                width         = l_width,
                align         = l_align,
                padding_left  = lpl,
                padding_right = lpr,
            },
            label = {
                string        = R and (R.text or "") or "",
                color         = R and (R.color or WHITE) or TRANSPARENT,
                align         = r_align,
                width         = r_width,
                font          = R and R.font or resolve_font({}),
                padding_left  = rpl,
                padding_right = rpr,
            },
        })
    end)

    is_expanded      = true
    -- Add 1 to the deadline so that the full duration elapses before the first
    -- eligible timer tick can fire (os.time() has 1-second granularity and the
    -- timer fires at an arbitrary phase, so without the +1 the effective visible
    -- time could be as short as duration-1 seconds).
    dismiss_deadline = (item.duration and item.duration > 0)
        and (os.time() + item.duration + 1)
        or 0
end

function M.restore_idle()
    if not is_expanded then return end
    is_expanded      = false
    dismiss_deadline = 0
    sbar.animate("tanh", 20, function()
        sbar.bar({ height = IDLE_H, margin = ORIG_MARGIN })
        island:set({
            width = NOTCH_W,
            -- slide back to centre and fade out; reset all slot geometry so
            -- the next expand() starts from a clean centered state
            icon  = {
                color         = TRANSPARENT,
                string        = "",
                align         = "center",
                width         = 0, -- clear any fixed width from last expand
                padding_left  = 12,
                padding_right = 4,
            },
            label = {
                color         = TRANSPARENT,
                string        = "",
                align         = "center",
                width         = NOTCH_W - 20,
                padding_left  = 4,
                padding_right = 12,
            },
        })
    end)
end

-- ── Internal subscriptions ────────────────────────────────────────────────────

island:subscribe("island_tap", function(_) M.restore_idle() end)
island:subscribe("apperace_change", function(_) end)

timer:subscribe("routine", function(_)
    if dismiss_deadline > 0 and os.time() >= dismiss_deadline then
        dismiss_deadline = 0
        M.restore_idle()
    end
end)

return M
