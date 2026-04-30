-- modules/powerwatch.lua
-- Monitors per-app energy impact via `ei` and sends a notification when an app
-- sustains high energy usage (on battery, or extreme usage on AC).

local M        = {}

local cfg      = require("config")
local utils    = require("modules.utils")
local json     = hs.json

local notified = {} -- [appName] = true  (suppresses repeated alerts)
local highRuns = {} -- [appName] = consecutive polls above threshold
local timer
local pcfg          -- resolved config (test or production)

-- ── Query ei ─────────────────────────────────────────────────────────────────

local function queryEnergy()
    local cmd = string.format("%s query --window %d --rows 50 2>/dev/null",
        cfg.powerwatch.ei, pcfg.windowHours)
    local out = hs.execute(cmd)
    if not out or out == "" then return {} end

    local ok, procs = pcall(json.decode, out)
    if not ok or type(procs) ~= "table" then return {} end

    local result = {}
    for _, p in ipairs(procs) do
        local name = p.name
        if name and name ~= "DEAD_TASKS" and not cfg.powerwatch.ignore[name] then
            local existing = result[name]
            if existing then
                existing.avg_energy     = existing.avg_energy + (p.avg_energy or 0)
                existing.current_energy = existing.current_energy + (p.current_energy or 0)
                existing.samples        = existing.samples + (p.samples or 0)
                existing.active_seconds = existing.active_seconds + (p.active_seconds or 0)
            else
                result[name] = {
                    avg_energy     = p.avg_energy or 0,
                    current_energy = p.current_energy or 0,
                    samples        = p.samples or 0,
                    active_seconds = p.active_seconds or 0,
                }
            end
        end
    end
    return result
end

-- ── Check & notify ────────────────────────────────────────────────────────────

local function trigger(event, args)
    local cmd = cfg.powerwatch.islandbar .. " --trigger " .. event
    if args then
        for k, v in pairs(args) do
            local quoted = "'" .. tostring(v):gsub("'", "'\\''") .. "'"
            cmd = cmd .. " " .. k .. "=" .. quoted
        end
    end
    print(cmd)
    hs.execute(cmd)
end

local function onBattery()
    return hs.battery.powerSource() == "Battery Power"
end

local function checkThresholds(procs)
    local battery   = onBattery()
    local threshold = battery and pcfg.energyThreshold or pcfg.acThreshold
    local minActiveSecs = pcfg.minActiveSecs or 0
    local requiredPolls = pcfg.requiredPolls or 1

    for name, info in pairs(procs) do
        local energy = info.avg_energy
        local activeSeconds = info.active_seconds or 0

        if energy >= threshold and activeSeconds >= minActiveSecs then
            highRuns[name] = (highRuns[name] or 0) + 1
        else
            highRuns[name] = nil
        end

        if not notified[name] and (highRuns[name] or 0) >= requiredPolls then
            trigger("island_cpuload", {
                percent = string.format("%.0f", energy),
                app = name,
            })
            notified[name] = true
        end
    end

    -- Lift suppression once an app's energy drops below half the threshold
    for name in pairs(notified) do
        if not procs[name] or procs[name].avg_energy < threshold / 2 then
            notified[name] = nil
            highRuns[name] = nil
        end
    end

    for name in pairs(highRuns) do
        if not procs[name] then
            highRuns[name] = nil
        end
    end
end

-- ── Poll ──────────────────────────────────────────────────────────────────────

local function poll()
    local procs = queryEnergy()
    checkThresholds(procs)
end

-- ── Public API ────────────────────────────────────────────────────────────────

function M.start()
    pcfg = cfg.powerwatch.testMode
        and cfg.powerwatch.test
        or cfg.powerwatch.production

    timer = hs.timer.doEvery(pcfg.pollSecs, poll)
    poll()

    hs.printf("[powerwatch] started — poll %ds, window %dh, threshold %.0f energy",
        pcfg.pollSecs, pcfg.windowHours, pcfg.energyThreshold)
end

function M.stop()
    if timer then
        timer:stop(); timer = nil
    end
    notified = {}
    highRuns = {}
end

return M
