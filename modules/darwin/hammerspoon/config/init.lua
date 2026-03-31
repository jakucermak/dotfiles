local cfg = require("config")

-- Load and start each module listed in config
for _, name in ipairs(cfg.modules) do
    local ok, mod = pcall(require, name)
    if ok then
        if type(mod.start) == "function" then
            mod.start()
        end
    else
        hs.printf("Failed to load module '%s': %s", name, mod)
    end
end

-- Reload config on Cmd+Alt+Ctrl+R
hs.hotkey.bind(cfg.hyper, "R", function()
    require("modules.utils").reload()
end)
