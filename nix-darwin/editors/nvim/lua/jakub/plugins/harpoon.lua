return({
	'ThePrimeagen/harpoon',
	config = function ()
		vim.keymap.set('n', '<leader>hm', function () require("harpoon.mark").add_file() end )
		local harpoon_ui = require('harpoon.ui')
		vim.keymap.set('n', '<leader>hg', harpoon_ui.toggle_quick_menu )
		vim.keymap.set('n', '<C-n>', harpoon_ui.nav_next)
		vim.keymap.set('n', '<C-p>', harpoon_ui.nav_prev)
	end
})
