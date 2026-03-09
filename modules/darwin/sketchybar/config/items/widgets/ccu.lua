local colors = require("colors")
local settings = require("settings")

local handle = io.popen("defaults read -g AppleInterfaceStyle 2>/dev/null || echo 'Light'")
local output = handle and handle:read("*a"):match("^%s*(.-)%s*$"):lower() or "light"
local appearance = output

-- Cache timezone info once at load using pure Lua (no subprocess)
local cached_tz_name = os.date("%Z")
local now = os.time()
local utc_t = os.date("!*t", now)
local loc_t = os.date("*t", now)
local cached_tz_offset_minutes = (os.time(loc_t) - os.time(utc_t)) / 60

local popup_width = 300
local popup_padding = 10
local bar_height = 8
local bar_track_width = popup_width

local ccu_item = sbar.add("item", "widgets.ccu1", {
    position = "right",
    icon = { drawing = false, string = "" },
    label = {
        string = " CCu ",
        font = { family = settings.font.numbers },
        color = colors[appearance].orange,
        padding_right = 18
    },
})

local ccu_bracket = sbar.add("bracket", "widgets.ccu.bracket", {
    ccu_item.name,
}, {
    background = {
        color = colors.with_alpha(colors[appearance].orange, 0.4),
        padding_left = 0,
        border_width = 0,
    },
    popup = {
        align = "center",
        background = {
            border_width = 0,
        },
        height = 25
    },
})

ccu_bracket:subscribe("apperace_change", function(env)
    sbar.exec("defaults read -g AppleInterfaceStyle 2>/dev/null || echo 'Light'", function(theme)
        appearance = theme:match("^%s*(.-)%s*$"):lower()

        ccu_bracket:set({
            background = {
                color = colors.with_alpha(colors[appearance].magenta_bg, 0.4),
            },
        })

        ccu_item:set({
            label = { color = colors[appearance].magenta },
        })
    end)
end)

sbar.add("item", "widgets.ccu.padding", {
    position = "right",
    width = settings.group_paddings,
})

local popup_item_props = {
    background = {
        color = colors.transparent,
        border_width = 0,
        height = 0,
        padding_left = popup_padding,
        padding_right = popup_padding,
    },
}

local function set_bar_percent(label_item, bar_item, percent)
    local fill_width = math.floor(percent / 100 * bar_track_width + 0.5)
    bar_item:set({ icon = { width = fill_width } })
    label_item:set({ label = { string = percent .. "%" } })
end

-- ── Section: Current Session ──────────────────────────────────────────

sbar.add("item", "widgets.ccu.spacer_0", {
    position = "popup." .. ccu_bracket.name,
    width = popup_width,
    icon = { drawing = false },
    label = {
        string = "",
        color = colors[appearance].grey,
        font = {
            family = settings.font.numbers,
            size = 10.0,
        },
    },
    background = popup_item_props.background,
})

local session_label = sbar.add("item", "widgets.ccu.session_label", {
    position = "popup." .. ccu_bracket.name,
    width = popup_width,
    icon = {
        string = "Current Session",
        color = colors[appearance].magenta,
        width = popup_width / 2,
        font = {
            family = settings.font.text,
            style = settings.font.style_map["Bold"],
            size = 18.0,
        },
    },
    label = {
        string = "--%",
        color = colors[appearance].magenta,
        align = "right",
        width = popup_width / 2,
        font = {
            family = settings.font.numbers,
            size = 13.0,
        },
    },
    background = popup_item_props.background,
})

local session_bar = sbar.add("item", "widgets.ccu.session_bar", {
    position = "popup." .. ccu_bracket.name,
    width = popup_width,
    icon = {
        string = " ",
        width = 0,
        padding_left = 0,
        padding_right = 0,
        background = {
            color = colors[appearance].magenta,
            height = bar_height,
            corner_radius = 2,
        },
    },
    label = { drawing = false },
    background = {
        color = colors.with_alpha(colors[appearance].magenta, 0.2),
        height = bar_height,
        corner_radius = 2,
        border_width = 0,
        padding_left = popup_padding,
        padding_right = popup_padding,
    },
})

local session_reset = sbar.add("item", "widgets.ccu.session_reset", {
    position = "popup." .. ccu_bracket.name,
    width = popup_width,
    icon = { drawing = false },
    label = {
        string = "Resets: --",
        color = colors[appearance].grey,
        font = {
            family = settings.font.numbers,
            size = 13.0,
        },
    },
    background = popup_item_props.background,
})

sbar.add("item", "widgets.ccu.spacer_1", {
    position = "popup." .. ccu_bracket.name,
    width = popup_width,
    icon = { drawing = false },
    label = {
        string = "",
        color = colors[appearance].grey,
        font = {
            family = settings.font.numbers,
            size = 1.0,
        },
    },
    background = popup_item_props.background,
})

-- ── Section: Weekly Usage ─────────────────────────────────────────────

local weekly_label = sbar.add("item", "widgets.ccu.weekly_label", {
    position = "popup." .. ccu_bracket.name,
    width = popup_width,
    icon = {
        string = "Weekly Usage",
        color = colors[appearance].blue,
        width = popup_width / 2,
        font = {
            family = settings.font.text,
            style = settings.font.style_map["Bold"],
            size = 18.0,
        },
    },
    label = {
        string = "--%",
        color = colors[appearance].blue,
        align = "right",
        width = popup_width / 2,
        font = {
            family = settings.font.numbers,
            size = 13.0,
        },
    },
    background = popup_item_props.background,
})

local weekly_bar = sbar.add("item", "widgets.ccu.weekly_bar", {
    position = "popup." .. ccu_bracket.name,
    width = popup_width,
    icon = {
        string = " ",
        width = 0,
        padding_left = 0,
        padding_right = 0,
        background = {
            color = colors[appearance].blue,
            height = bar_height,
            corner_radius = 2,
        },
    },
    label = { drawing = false },
    background = {
        color = colors.with_alpha(colors[appearance].blue, 0.2),
        height = bar_height,
        corner_radius = 2,
        border_width = 0,
        padding_left = popup_padding,
        padding_right = popup_padding,
    },
})

local weekly_reset = sbar.add("item", "widgets.ccu.weekly_reset", {
    position = "popup." .. ccu_bracket.name,
    width = popup_width,
    icon = { drawing = false },
    label = {
        string = "Resets: --",
        color = colors[appearance].grey,
        font = {
            family = settings.font.numbers,
            size = 13.0,
        },
    },
    background = popup_item_props.background,

})


sbar.add("item", "widgets.ccu.spacer_2", {
    position = "popup." .. ccu_bracket.name,
    width = popup_width,
    icon = { drawing = false },
    label = {
        string = "",
        color = colors[appearance].grey,
        font = {
            family = settings.font.numbers,
            size = 10.0,
        },
    },
    background = popup_item_props.background,
})


-- ── Toggle / Collapse ─────────────────────────────────────────────────

local session_key_file = "/Users/jakubcermak/.config/claude-session-key"

local function read_session_key()
    local f = io.open(session_key_file, "r")
    if not f then return nil end
    local key = f:read("*a"):match("^%s*(.-)%s*$")
    f:close()
    if key == "" then return nil end
    return key
end

local function get_claude_usage(callback)
    local session_key = read_session_key()
    if not session_key then return end

    local cmd =
        '/etc/profiles/per-user/jakubcermak/bin/curl -s "https://claude.ai/api/organizations/49f236ea-065f-4887-b49c-b29884f2be3f/usage" '
        .. '-H "accept: */*" '
        .. '-H "accept-language: en-US,en;q=0.9" '
        .. '-H "content-type: application/json" '
        .. '-H "anthropic-client-platform: web_claude_ai" '
        .. '-H "anthropic-client-version: 1.0.0" '
        .. '-H "user-agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/131.0.0.0 Safari/537.36" '
        .. '-H "origin: https://claude.ai" '
        .. '-H "referer: https://claude.ai/settings/usage" '
        .. '-H "sec-fetch-dest: empty" '
        .. '-H "sec-fetch-mode: cors" '
        .. '-H "sec-fetch-site: same-origin" '
        .. '-H "Cookie: sessionKey=' .. session_key .. '"'

    sbar.exec(cmd, function(result)
        local fh = type(result) == "table" and result.five_hour or nil
        local sd = type(result) == "table" and result.seven_day or nil
        print("CCU: " .. tostring(result))
        callback({
            five_hour        = fh and tonumber(fh.utilization),
            weekly           = sd and tonumber(sd.utilization),
            resets_at        = fh and fh.resets_at,
            weekly_resets_at = sd and sd.resets_at,
        })
    end)
end

local function format_datetime(iso)
  local date, time = iso:match("^(%d%d%d%d%-%d%d%-%d%d)T(%d%d:%d%d):%d[%d.]*[+-]%d%d:%d%d$")

  if not date then
    return iso
  end

  local h, m = time:match("^(%d%d):(%d%d)$")
  local total_minutes = tonumber(h) * 60 + tonumber(m) + cached_tz_offset_minutes

  local day_offset = 0
  if total_minutes >= 1440 then
    total_minutes = total_minutes - 1440
    day_offset = 1
  elseif total_minutes < 0 then
    total_minutes = total_minutes + 1440
    day_offset = -1
  end

  local local_h = math.floor(total_minutes / 60)
  local local_m = total_minutes % 60
  local local_time = string.format("%02d:%02d", local_h, local_m)

  local local_date = date
  if day_offset ~= 0 then
    local y, mo, d = tonumber(date:sub(1,4)), tonumber(date:sub(6,7)), tonumber(date:sub(9,10))
    d = d + day_offset
    if d < 1 then
      mo = mo - 1
      if mo < 1 then mo = 12; y = y - 1 end
      local days_in_month = ({ 31,28,31,30,31,30,31,31,30,31,30,31 })[mo]
      if mo == 2 and (y % 4 == 0 and (y % 100 ~= 0 or y % 400 == 0)) then days_in_month = 29 end
      d = days_in_month
    elseif d > 28 then
      local days_in_month = ({ 31,28,31,30,31,30,31,31,30,31,30,31 })[mo]
      if mo == 2 and (y % 4 == 0 and (y % 100 ~= 0 or y % 400 == 0)) then days_in_month = 29 end
      if d > days_in_month then
        d = 1; mo = mo + 1
        if mo > 12 then mo = 1; y = y + 1 end
      end
    end
    local_date = string.format("%04d-%02d-%02d", y, mo, d)
  end

  return string.format("%s %s (%s)", local_date, local_time, cached_tz_name)
end


-- Použití


local function ccu_collapse()
    local drawing = ccu_bracket:query().popup.drawing == "on"
    if not drawing then return end
    ccu_bracket:set({ popup = { drawing = false } })
end

local function ccu_toggle(env)
    local should_draw = ccu_bracket:query().popup.drawing == "off"
    if not should_draw then
        ccu_collapse()
        return
    end

    ccu_bracket:set({ popup = { drawing = true } })

    get_claude_usage(function(result)
        if result.five_hour then
            set_bar_percent(session_label, session_bar, result.five_hour)
        end
        session_reset:set({ label = { string = "Resets: " .. (result.resets_at and format_datetime(result.resets_at) or "---") } })

        if result.weekly then
            set_bar_percent(weekly_label, weekly_bar, result.weekly)
        end
        weekly_reset:set({ label = { string = "Resets: " .. (result.weekly_resets_at and format_datetime(result.weekly_resets_at) or "---") } })
    end)
end

ccu_item:subscribe("mouse.clicked", ccu_toggle)
ccu_item:subscribe("mouse.exited.global", ccu_collapse)
