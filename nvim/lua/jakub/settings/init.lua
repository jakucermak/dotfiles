vim.cmd([[colorscheme ayu]])
vim.wo.number = true
vim.wo.relativenumber = true

if vim.g.neovide then
	vim.opt.guifont = { "JetBrainsMonoNL", ":h14" }
	vim.opt.linespace = 8
	vim.g.neovide_hide_mouse_when_typing = true
	vim.g.neovide_floating_blur_amount_x = 10.0
	vim.g.neovide_floating_blur_amount_y = 10.0
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

-- NTree
vim.keymap.set("n", "<leader>nt", vim.cmd.Ntree)

vim.api.nvim_set_keymap("", "<D-v>", "+p<CR>", { noremap = true, silent = true })
vim.api.nvim_set_keymap("!", "<D-v>", "<C-R>+", { noremap = true, silent = true })
vim.api.nvim_set_keymap("t", "<D-v>", "<C-R>+", { noremap = true, silent = true })
vim.api.nvim_set_keymap("v", "<D-v>", "<C-R>+", { noremap = true, silent = true })

--Split navigation
vim.keymap.set("n", "<C-k>", "<C-w>k")
vim.keymap.set("n", "<C-j>", "<C-w>j")
vim.keymap.set("n", "<C-h>", "<C-w>h")
vim.keymap.set("n", "<C-l>", "<C-w>l")

--Toggleterm
vim.keymap.set("t", "<esc>t", [[<C-\><C-n>]])
