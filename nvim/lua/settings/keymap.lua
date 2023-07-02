-- Main
vim.g.mapleader = " "
vim.api.nvim_set_keymap('', '<D-v>', '+p<CR>', { noremap = true, silent = true})
vim.api.nvim_set_keymap('!', '<D-v>', '<C-R>+', { noremap = true, silent = true})
vim.api.nvim_set_keymap('t', '<D-v>', '<C-R>+', { noremap = true, silent = true})
vim.api.nvim_set_keymap('v', '<D-v>', '<C-R>+', { noremap = true, silent = true})

-- Buffers
vim.keymap.set('n', '<leader>bd', vim.cmd.bdelete)
vim.keymap.set('n', '<leader>bn', vim.cmd.bnext)
vim.keymap.set('n', '<leader>bp', vim.cmd.bprevious)

--ToggleTerm
vim.keymap.set('n', '<leader>t', vim.cmd.ToggleTerm)

-- Dashboard
vim.keymap.set('n', '<leader>D', vim.cmd.Dashboard)

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

-- ToggleTerm 
vim.keymap.set('t', '<esc>', [[<C-\><C-n>]])
