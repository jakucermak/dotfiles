vim.wo.number = true
vim.wo.relativenumber = true
vim.opt.guifont = { "JetBrains Mono NL Custom", ":h14" }

vim.api.nvim_exec('language en_US', true)

vim.opt.signcolumn = "yes:2"
vim.opt.fillchars = { eob = ' ' }

vim.cmd [[colorscheme ayu-mirage]]
vim.cmd [[autocmd BufWritePre <buffer> lua vim.lsp.buf.format()]]


vim.api.nvim_create_autocmd({ "BufEnter", "BufNew" }, {

	callback = function()
		vim.api.nvim_set_hl(0, 'DapBreakpoint', { ctermbg = 0, fg = '#F24935', bg = '#1F2430' })
		vim.api.nvim_set_hl(0, 'DapLogPoint', { ctermbg = 0, fg = '#61afef', bg = '#1F2430' })
		vim.api.nvim_set_hl(0, 'DapStopped', { ctermbg = 0, fg = '#98c379', bg = '#1F2430' })
		vim.fn.sign_define('DapBreakpoint', {
			text = '',
			texthl = 'DapBreakpoint',
			linehl = 'DapBreakpoint',
			numhl = 'DapBreakpoint'
		})
		vim.fn.sign_define('DapBreakpointCondition',
			{ text = 'ﳁ', texthl = 'DapBreakpoint', linehl = 'DapBreakpoint', numhl = 'DapBreakpoint' })
		vim.fn.sign_define('DapBreakpointRejected',
			{ text = '', texthl = 'DapBreakpoint', linehl = 'DapBreakpoint', numhl = 'DapBreakpoint' })
		vim.fn.sign_define('DapLogPoint',
			{ text = '', texthl = 'DapLogPoint', linehl = 'DapLogPoint', numhl = 'DapLogPoint' })
		vim.fn.sign_define('DapStopped',
			{ text = '', texthl = 'DapStopped', linehl = 'DapStopped', numhl = 'DapStopped' })
		-- more commands
	end,
})

-- NEOVIDE
if vim.g.neovide then
	-- Put anything you want to happen only in Neovide here
	vim.g.neovide_padding_left = 15
	vim.g.neovide_remember_window_size = true
	vim.g.neovide_input_use_logo = true
	vim.opt.clipboard = "unnamedplus"
end
