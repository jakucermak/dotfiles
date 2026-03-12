local settings      = require("settings")
local icons         = require("icons")
local app_icons     = require("helpers.app_icons")
local display       = require("display")

-- ── Constants ─────────────────────────────────────────────────────────────────
-- Geometry (must match bar.lua)
--   bar y_offset  = -25  → bar top is 25px above screen edge
--   idle:    visible bar = 45-25 = 20px  (just the notch cap)
--   expanded: visible bar = 125-25 = 100px
--
-- Item is vertically centred inside the bar.
--   item_center_from_screen = bar_height/2 + bar_y_offset
--     idle:    45/2  - 25 = -2.5 px  → above screen → label naturally hidden
--     expanded: 125/2 - 25 = 37.5 px → within visible area
--
-- LABEL_Y_EXP: push label to ~12 px above visible bottom
--   desired label y = (bar_height - bar_y_offset_abs) - 12
--                   = (125 - 25) - 12 = 88 px from screen
--   label.y_offset  = 88 - item_center = 88 - 37.5 = 50.5 → 52 (add padding)

local WHITE         = 0xffffffff
local TRANSPARENT   = 0x00ffffff -- transparent white; avoids RGB flash on fade
local NOTCH_WIDTH   = display.notch_width
local IDLE_H        = 45
local EXPAND_H      = 125
local LABEL_Y_EXP   = 52  -- slides label to near-bottom of expanded bar

-- ── State ─────────────────────────────────────────────────────────────────────

local state         = "idle"
local expire_time   = 0
local music_playing = false
local current_app   = ""

local function set_timer(s) expire_time = os.time() + s end

-- ── Icon helpers ──────────────────────────────────────────────────────────────

local function vol_icon(v)
    if v == 0 then
        return icons.volume._0
    elseif v < 10 then
        return icons.volume._10
    elseif v < 33 then
        return icons.volume._33
    elseif v < 66 then
        return icons.volume._66
    else
        return icons.volume._100
    end
end

local function vol_bar(v)
    local n = math.floor(v / 10)
    return string.rep("█", n) .. string.rep("░", 10 - n)
end

-- ── Island item ───────────────────────────────────────────────────────────────
-- The bar itself is the solid black pill; no background needed on the item.

local island = sbar.add("item", "island.main", {
    position      = "center",
    width         = NOTCH_WIDTH,
    updates       = true,
    padding_left  = 0,
    padding_right = 0,
    y_offset      = 0, -- centred in bar; in idle this places it above screen
    click_script  = "sketchybar --bar name=islandbar --trigger island_tap",
    icon          = { drawing = false },
    label         = {
        color         = TRANSPARENT,
        align         = "center",
        font          = {
            family = settings.font.text,
            style  = settings.font.style_map["Semibold"],
            size   = 13,
        },
        width         = NOTCH_WIDTH - 20,
        y_offset      = 0,
        padding_left  = 0,
        padding_right = 0,
        scroll_texts  = true,
    },
    background    = { drawing = false }, -- bar IS the visual; no item background
})

-- ── Hidden 1 Hz timer ─────────────────────────────────────────────────────────

local timer = sbar.add("item", "island.timer", {
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

-- ── Animate helpers ───────────────────────────────────────────────────────────

local function animate_expand(label_str)
    sbar.animate("tanh", 20, function()
        sbar.bar({ height = EXPAND_H })
        island:set({
            label = {
                string   = label_str,
                color    = WHITE,
                y_offset = LABEL_Y_EXP,
            },
        })
    end)
end

local function animate_collapse()
    sbar.animate("tanh", 20, function()
        sbar.bar({ height = IDLE_H })
        island:set({
            label = {
                color    = TRANSPARENT,
                y_offset = 0,
            },
        })
    end)
end

-- ── State transitions ─────────────────────────────────────────────────────────

local function restore_idle()
    state       = "idle"
    expire_time = 0
    animate_collapse()
end

local function show_volume(vol)
    if music_playing then return end
    state = "volume"
    local text = vol_icon(vol) .. "  " .. vol_bar(vol) .. "  " .. string.format("%d%%", vol)
    animate_expand(text)
    set_timer(3)
end

local function show_music(title, artist)
    state = "music"
    local display = title ~= "" and title or "Playing"
    if artist ~= "" then display = display .. "  ·  " .. artist end
    animate_expand(icons.media.play_pause .. "  " .. display)
end

local function show_appswitch(app_name)
    if music_playing then return end
    state          = "appswitch"
    local icon_str = app_icons[app_name] or icons.apple
    local short    = app_name
    if #short > 22 then short = short:sub(1, 20) .. "…" end
    animate_expand(icon_str .. "  " .. short)
    set_timer(2)
end

-- ── Event subscriptions ───────────────────────────────────────────────────────

island:subscribe("volume_change", function(env)
    show_volume(tonumber(env.INFO) or 0)
end)

island:subscribe("front_app_switched", function(env)
    local name = env.INFO or ""
    current_app = name
    show_appswitch(name)
end)

island:subscribe("media_change", function(env)
    local info   = env.INFO or {}
    local title  = info.title or ""
    local artist = info.artist or ""
    local ms     = info.state or ""
    if ms == "playing" and title ~= "" then
        music_playing = true
        show_music(title, artist)
    else
        music_playing = false
        if state == "music" then restore_idle() end
    end
end)

island:subscribe("island_tap", function(_)
    restore_idle()
end)

island:subscribe("apperace_change", function(_) end) -- pill is always black

timer:subscribe("routine", function(_)
    if expire_time > 0 and os.time() >= expire_time then
        if music_playing then
            expire_time = 0
        else
            restore_idle()
        end
    end
end)
