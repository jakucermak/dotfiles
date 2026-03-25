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
--                                   width, padding_left, padding_right }
--   right    table    label slot  { text, font=…, color, align,
--                                   width, padding_left, padding_right }
--   subtitle table    second line { text, font=…, color, align }
--            set OUTSIDE sbar.animate() → instant appear/disappear;
--            y_offset calculated from font size so sketchybar cannot tween it
--   duration number   auto-dismiss seconds; 0 = no dismiss (default: 0)
--
-- Width layout rules (left / right):
--   left.width set  → left is a fixed column, right fills remaining space
--   right.width set → right is fixed (default 36 for icon glyphs), left fills remaining
--   neither set     → right fills the full pill

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
    if type(f) == "string" then return f end  -- raw font string passthrough (e.g. app-icon font)
    f = f or {}
    local style = f.style or "Semibold"
    return {
        family = f.family or settings.font.text,
        style  = settings.font.style_map[style] or style,
        size   = f.size or 13,
    }
end

-- ── Subtitle item (line 2) ────────────────────────────────────────────────────
-- Registered BEFORE island.main so it sits to the LEFT in the center group.
-- With width=0 it takes no space, but its label starts at the pill's left edge
-- and spans the pill width.  Hidden at idle via transparent colour + zero width.
-- click_script forwards taps since the label visually overlaps island.main.

local island_sub       = sbar.add("item", "island.sub", {
    position      = "center",
    width         = 0,    -- takes no horizontal space; rendered via label slot
    updates       = false,
    click_script  = "islandbar --trigger island_tap",
    padding_left  = 0,
    padding_right = 0,
    icon          = { drawing = false },
    label         = {
        drawing       = true,
        color         = TRANSPARENT,
        string        = "",
        width         = 0,
        font          = resolve_font({ size = 12, style = "Regular" }),
        padding_left  = 0, -- keep 0 at idle; set to lpl in expand() to avoid layout offset
        padding_right = 0,
        align         = "center",
    },
    background    = { drawing = false },
})

-- ── Island item (line 1) ──────────────────────────────────────────────────────

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
    local S       = item.subtitle

    local lpl     = L and (L.padding_left or 12) or 12
    local lpr     = L and (L.padding_right or 4) or 4
    local rpl     = R and (R.padding_left or 4) or 4
    local rpr     = R and (R.padding_right or 12) or 12

    -- Width layout rules (see header comment)
    local l_fixed = L and L.width or nil
    local r_fixed
    if l_fixed then
        r_fixed = (L and R) and R.width or nil         -- right fills remaining; no default
    else
        r_fixed = (L and R) and (R.width or 36) or nil -- default 36 for icon glyph
    end

    local l_width, r_width
    if l_fixed and r_fixed then
        l_width = l_fixed
        r_width = r_fixed
    elseif l_fixed then
        l_width = l_fixed
        r_width = math.max(0, w - lpl - lpr - rpl - rpr - l_fixed)
    elseif r_fixed then
        l_width = math.max(0, w - lpl - lpr - rpl - rpr - r_fixed)
        r_width = r_fixed
    else
        l_width = nil
        r_width = w - 20
    end

    -- Alignment animates from "center" (idle) to final position → outward slide
    local l_align = "left"
    local r_align = (R and R.align) or (L and "right" or "center")

    -- Resolve subtitle font before the animate block so sub_y is available.
    local sfont = S and resolve_font(S.font or { size = 12, style = "Regular" }) or nil
    local sub_y = sfont and -(sfont.size + 16) or 0

    sbar.animate("tanh", 20, function()
        sbar.bar({ height = h, margin = mg })
        island:set({
            width = w,
            icon  = {
                string        = L and (L.text or "") or "",
                color         = L and (L.color or WHITE) or TRANSPARENT,
                font          = resolve_font(L and L.font or {}),
                width         = l_width or 0,  -- 0 clears any stale width from a previous layout
                align         = l_align,
                padding_left  = lpl,
                padding_right = lpr,
            },
            label = {
                string        = R and (R.text or "") or "",
                color         = R and (R.color or WHITE) or TRANSPARENT,
                align         = r_align,
                width         = r_width or 0,  -- 0 clears any stale width from a previous layout
                font          = resolve_font(R and R.font or {}),
                padding_left  = rpl,
                padding_right = rpr,
            },
        })
        -- Subtitle inside animate: x-position is driven by the same batch as
        -- the bar width, so no horizontal slide.  y_offset animates 0 → sub_y
        -- (a short downward glide that looks intentional).
        if S then
            island_sub:set({
                y_offset = sub_y,
                label    = {
                    color         = S.color or WHITE,
                    string        = S.text or "",
                    width         = w - lpl - rpr,
                    font          = sfont,
                    align         = S.align or "left",
                    padding_left  = lpl,
                    padding_right = rpr,
                },
            })
        else
            island_sub:set({
                y_offset = 0,
                label    = { color = TRANSPARENT, string = "", width = 0 },
            })
        end
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

    -- Clear subtitle instantly (outside animate) so it vanishes before the
    -- pill shrinks back.  Reset padding so the zero-width label has no footprint.
    island_sub:set({ y_offset = 0, label = { color = TRANSPARENT, string = "", width = 0, padding_left = 0, padding_right = 0 } })

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
