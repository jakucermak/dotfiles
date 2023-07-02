vim.cmd [[packadd packer.nvim]]

return require('packer').startup(function(use)
	use 'wbthomason/packer.nvim'
	use { 'Shatur/neovim-ayu' }
	use 'nvim-treesitter/nvim-treesitter'
	use {
		'nvim-telescope/telescope.nvim',
		requires = { { 'nvim-lua/plenary.nvim' } }
	}

	use {
		"nvim-telescope/telescope-file-browser.nvim",
		requires = { "nvim-telescope/telescope.nvim", "nvim-lua/plenary.nvim" }
	}

	use {
		'VonHeikemen/lsp-zero.nvim',
		branch = 'v2.x',
		requires = {
			-- LSP Support
			{ 'neovim/nvim-lspconfig' }, -- Required
			{       -- Optional
				'williamboman/mason.nvim',
				run = function()
					pcall(vim.cmd, 'MasonUpdate')
				end,
			},
			{ 'williamboman/mason-lspconfig.nvim' }, -- Optional

			-- Autocompletion
			{ 'hrsh7th/nvim-cmp' }, -- Required
			{ 'hrsh7th/cmp-nvim-lsp' }, -- Required
			{ 'L3MON4D3/LuaSnip' }, -- Required
		}
	}
	use 'lewis6991/gitsigns.nvim'
	use 'f-person/git-blame.nvim'
	use {
		'nvim-lualine/lualine.nvim',
		requires = { 'nvim-tree/nvim-web-devicons', opt = true }
	}
	use {
		"FeiyouG/command_center.nvim",
		requires = { "nvim-telescope/telescope.nvim" }
	}
	use {
		'numToStr/Comment.nvim',
		config = function()
			require('Comment').setup()
		end
	}
	use 'cohama/lexima.vim'
	use 'mfussenegger/nvim-dap'
	use "rcarriga/nvim-dap-ui"
	use 'kdheepak/tabline.nvim'
	use 'kyazdani42/nvim-web-devicons'
	use { 'glepnir/dashboard-nvim',
	event = 'VimEnter'}
	use 'cljoly/telescope-repo.nvim'
	use "akinsho/toggleterm.nvim"
end)
