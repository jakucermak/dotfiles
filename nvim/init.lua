require("settings.keymap")
require("plugins.packer")
require("plugins.treesitter")
require("plugins.telescope")
require("plugins.gitsigns")
require("plugins.lsp")
require("plugins.lualine")

vim.wo.number = true
vim.wo.relativenumber = true

vim.opt.signcolumn = "yes:2"
vim.opt.fillchars = { eob = ' ' }
vim.cmd [[colorscheme ayu-mirage]]
