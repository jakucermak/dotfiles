local arrows = function()
	for _, mode in ipairs({ "i", "", "v" }) do
		vim.api.nvim_set_keymap(mode, '<Up>', '', { noremap = true, silent = true })
		vim.api.nvim_set_keymap(mode, '<Down>', '', { noremap = true, silent = true })
		vim.api.nvim_set_keymap(mode, '<Left>', '', { noremap = true, silent = true })
		vim.api.nvim_set_keymap(mode, '<Right>', '', { noremap = true, silent = true })
	end
end

arrows()

vim.g.mapleader = " "
-- Treesitter
local telescope = require('telescope.builtin')
vim.keymap.set('n', '<leader>ff', telescope.find_files,{})

-- Harpoon
vim.keymap.set('n', '<leader>hm', function () require("harpoon.mark").add_file() end )
local harpoon_ui = require('harpoon.ui')
vim.keymap.set('n', '<leader>hg', harpoon_ui.toggle_quick_menu )
vim.keymap.set('n', '<C-n>', harpoon_ui.nav_next)
vim.keymap.set('n', '<C-p>', harpoon_ui.nav_prev)

--Neozoom

vim.keymap.set('n','<C-ESC>', function ()
	vim.cmd('NeoZoomToggle') 
end, { silent = true, nowait = true })
