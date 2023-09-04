require('plugins.treesitter')
require('plugins.lsp')
require('plugins.lualine')
require('plugins.neozoom')
require('plugins.tint')

vim.cmd [[packadd packer.nvim]]

return require('packer').startup( function(use)
	use 'wbthomason/packer.nvim'
end)
