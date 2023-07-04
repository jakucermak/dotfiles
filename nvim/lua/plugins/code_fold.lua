-- Neovim hasn't added foldingRange to default capabilities, users must add it manually

vim.o.foldcolumn = '1' -- '0' is not bad
vim.o.foldlevel = 99 -- Using ufo provider need a large value, feel free to decrease the value
vim.o.foldlevelstart = 99
vim.o.foldenable = true
vim.o.fillchars = [[eob: ,fold: ,foldopen:\uf078,foldsep: ,foldclose:\uf054]]

local capabilities = vim.lsp.protocol.make_client_capabilities()
capabilities.textDocument.foldingRange = {
	dynamicRegistration = false,
	lineFoldingOnly = true
}
local language_servers = require("lspconfig").util.available_servers()          -- or list servers manually like {'gopls', 'clangd'}
for _, ls in ipairs(language_servers) do
	require('lspconfig')[ls].setup({
		capabilities = capabilities
		-- you can add other fields for setting up lsp server in this table
	})
end
require('ufo').setup()
