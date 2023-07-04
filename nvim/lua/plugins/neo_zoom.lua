require('neo-zoom').setup {

	popup = {
		enabled = true,
		exclude_filetypes = {},
		exclude_buftypes = {},
	},
	exclude_buftypes = { 'terminal' },
	exclude_filetypes = { 'lspinfo', 'mason', 'lazy', 'fzf', 'qf' },
	winopts = {
		offset = {
			-- NOTE: omit `top`/`left` to center the floating window vertically/horizontally.
			top = 0.03,
			left = 0.03,
			width = 0.9,
			height = 0.9,
		},
		-- NOTE: check :help nvim_open_win() for possible border values.
		border = 'rounded', -- this is a preset, try it :)
	},
	presets = {
		{
			-- NOTE: regex pattern can be used here!
			filetypes = { 'dapui_.*', 'dap-repl' },
			winopts = {
				offset = { top = 0.02, left = 0.26, width = 0.74, height = 0.25 },
			},
		},
		{
			filetypes = { 'markdown' },
			callbacks = {
				function() vim.wo.wrap = true end,

			},
		},
	},
}

