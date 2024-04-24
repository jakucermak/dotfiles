local lsp = require('lsp-zero')

lsp.preset('recommended')

require('mason').setup({})
require('mason-lspconfig').setup({
	ensure_installed = {},
	handlers = {
		lsp.default_setup,
	}
})
require('lspconfig').bashls.setup({
	filetypes = {
		'zsh'
	}
})
local cmp = require('cmp')
local cmp_select = { behavior = cmp.SelectBehavior.Select }
