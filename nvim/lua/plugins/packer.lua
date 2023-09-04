vim.cmd [[packadd packer.nvim]]

return require('packer').startup(function(use)
	use 'wbthomason/packer.nvim'
	use 'Shatur/neovim-ayu'
	use 'nvim-lua/plenary.nvim'
	use 'ThePrimeagen/harpoon'
	use 'nvim-telescope/telescope.nvim'
	use('nvim-treesitter/nvim-treesitter', { run = ':TSUpdate' })
	use {
		'VonHeikemen/lsp-zero.nvim',
		branch = 'dev-v3',
		requires = {
			{ 'williamboman/mason.nvim' },
			{ 'williamboman/mason-lspconfig.nvim' },

			-- LSP Support
			{ 'neovim/nvim-lspconfig' },
			-- Autocompletion
			{ 'hrsh7th/nvim-cmp' },
			{ 'hrsh7th/cmp-nvim-lsp' },
			{ 'L3MON4D3/LuaSnip' },
		}
	}
	use {
		'nvim-lualine/lualine.nvim',
		requires = { 'nvim-tree/nvim-web-devicons', opt = true }
	}
	use 'nyngwang/NeoZoom.lua'
	use 'levouh/tint.nvim'
end)
