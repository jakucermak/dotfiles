require("plugins.remap")
require("plugins.packer")
require("plugins.telescope")
require("plugins.lualine")
require("plugins.treesitter")
require("plugins.lsp")



vim.wo.number = true
vim.wo.relativenumber = true
require('onedark').setup {
    style = 'dark'
}
require('onedark').load()

