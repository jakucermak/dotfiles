vim.cmd([[colorscheme ayu]])
vim.wo.number = true
vim.wo.relativenumber = true

if vim.g.neovide then
	vim.opt.guifont = { "JetBrainsMonoNL", ":h14" }
	vim.opt.linespace = 8
	vim.g.neovide_hide_mouse_when_typing = true
end

vim.opt.fillchars = { eob = " " }

vim.api.nvim_set_hl(0, "LineNrAbove", { fg = "#5F6166" })
vim.api.nvim_set_hl(0, "LineNr", { fg = "#C8C9C3" })
vim.api.nvim_set_hl(0, "LineNrBelow", { fg = "#5F6166" })
vim.cmd("set laststatus=3")
vim.cmd("set cmdheight=0")

local arrows = function()
	for _, mode in ipairs({ "i", "", "v" }) do
		vim.api.nvim_set_keymap(mode, "<Up>", "", { noremap = true, silent = true })
		vim.api.nvim_set_keymap(mode, "<Down>", "", { noremap = true, silent = true })
		vim.api.nvim_set_keymap(mode, "<Left>", "", { noremap = true, silent = true })
		vim.api.nvim_set_keymap(mode, "<Right>", "", { noremap = true, silent = true })
	end
end

arrows()
