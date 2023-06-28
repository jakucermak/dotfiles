-- Main
vim.g.mapleader = " "

-- Telescope
local file_browser = require "telescope".extensions.file_browser.file_browser
local builtin = require('telescope.builtin')
vim.keymap.set('n', '<leader>ff', builtin.find_files, {})
vim.keymap.set('n', '<leader>fg', builtin.live_grep, {})
vim.keymap.set('n', "<leader>wf", file_browser, {})
