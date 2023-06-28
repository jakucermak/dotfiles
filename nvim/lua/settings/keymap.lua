-- Main
vim.g.mapleader = " "

-- Telescope
local file_browser = require "telescope".extensions.file_browser.file_browser
local builtin = require('telescope.builtin')
vim.keymap.set('n', '<leader>ff', builtin.find_files, {})
vim.keymap.set('n', '<leader>fg', builtin.live_grep, {})
vim.keymap.set('n', "<leader>wf", file_browser, {})

-- DAP

vim.keymap.set("n", "<F9>", vim.cmd.DapStepOver)
vim.keymap.set("n", "<F5>", vim.cmd.DapStepInto)
vim.keymap.set("n", "<F6>", vim.cmd.DapStepOut)
vim.keymap.set("n", "<leader>do", vim.cmd.DapContinue)
vim.keymap.set("n", "<leader>dr", ":lua require'dap'.repl.open()<CR>")
vim.keymap.set("n", "<leader>B", ":lua require'dap'.set_breakpoint(vim. fn. input('Breakpoint condition: '))<CR>")
vim.keymap.set("n", "<leader>b", vim.cmd.DapToggleBreakpoint)
