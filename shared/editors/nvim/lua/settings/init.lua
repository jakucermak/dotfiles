require("settings.keymap")

vim.cmd([[colorscheme ayu]])
vim.opt.fillchars = { eob = " " }
vim.wo.number = true
vim.wo.relativenumber = true

if vim.g.neovide then
	vim.opt.guifont = { "JetBrainsMonoNL Nerd Font", ":h14" }
	vim.opt.linespace = 8
	vim.g.neovide_hide_mouse_when_typing = true
end

vim.opt.fillchars = { eob = " " }

vim.api.nvim_set_hl(0, "LineNrAbove", { fg = "#5F6166" })
vim.api.nvim_set_hl(0, "LineNr", { fg = "#C8C9C3" })
vim.api.nvim_set_hl(0, "LineNrBelow", { fg = "#5F6166" })
vim.cmd("set laststatus=3")
vim.cmd("set cmdheight=0")
