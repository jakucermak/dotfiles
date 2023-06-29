vim.wo.number = true
vim.wo.relativenumber = true

vim.opt.guifont = { "JetBrains Mono NL Custom", ":h14" }
vim.opt.signcolumn = "yes:2"
vim.opt.fillchars = { eob = ' ' }

vim.cmd [[colorscheme ayu-mirage]]


vim.api.nvim_set_hl(0, 'DapBreakpoint', { ctermbg = 0, fg = '#F24935', bg = '#1F2430' })
vim.api.nvim_set_hl(0, 'DapLogPoint', { ctermbg = 0, fg = '#61afef', bg = '#1F2430' })
vim.api.nvim_set_hl(0, 'DapStopped', { ctermbg = 0, fg = '#98c379', bg = '#1F2430' })
vim.fn.sign_define('DapBreakpoint', { text = '', texthl = 'DapBreakpoint', linehl = 'DapBreakpoint',
	numhl = 'DapBreakpoint' })
vim.fn.sign_define('DapBreakpointCondition',
	{ text = 'ﳁ', texthl = 'DapBreakpoint', linehl = 'DapBreakpoint', numhl = 'DapBreakpoint' })
vim.fn.sign_define('DapBreakpointRejected',
	{ text = '', texthl = 'DapBreakpoint', linehl = 'DapBreakpoint', numhl = 'DapBreakpoint' })
vim.fn.sign_define('DapLogPoint', { text = '', texthl = 'DapLogPoint', linehl = 'DapLogPoint', numhl = 'DapLogPoint' })
vim.fn.sign_define('DapStopped', { text = '', texthl = 'DapStopped', linehl = 'DapStopped', numhl = 'DapStopped' })



-- NEOVIDE
vim.g.neovide_padding_left = 15
