local M = {}

-- Show a brief notification.
-- Optional `image` (hs.image) is shown as the content thumbnail.
function M.notify(title, message, image)
    local n = hs.notify.new({ title = title, informativeText = message or "" })
    if image then n:contentImage(image) end
    n:send()
end

-- Run a shell command and return trimmed output
function M.shell(cmd)
    local output, ok = hs.execute(cmd)
    if ok then
        return output:gsub("%s+$", "")
    end
end

-- Reload Hammerspoon config with notification
function M.reload()
    M.notify("Hammerspoon", "Config reloaded")
    hs.reload()
end

return M
