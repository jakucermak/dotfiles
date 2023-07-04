-- Main
vim.g.mapleader = " "
vim.api.nvim_set_keymap('', '<D-v>', '+p<CR>', { noremap = true, silent = true })
vim.api.nvim_set_keymap('!', '<D-v>', '<C-R>+', { noremap = true, silent = true })
vim.api.nvim_set_keymap('t', '<D-v>', '<C-R>+', { noremap = true, silent = true })
vim.api.nvim_set_keymap('v', '<D-v>', '<C-R>+', { noremap = true, silent = true })
-- vim.api.

local arrows = function()
	for _, mode in ipairs({ "i", "", "v" }) do
		vim.api.nvim_set_keymap(mode, '<Up>', '', { noremap = true, silent = true })
		vim.api.nvim_set_keymap(mode, '<Down>', '', { noremap = true, silent = true })
		vim.api.nvim_set_keymap(mode, '<Left>', '', { noremap = true, silent = true })
		vim.api.nvim_set_keymap(mode, '<Right>', '', { noremap = true, silent = true })
	end
end

arrows()
-- Buffers
vim.keymap.set('n', '<leader>bd', vim.cmd.bdelete)
	 	
vim.keymap.set('n', '<leader>bn', vim.cmd.bnext)
vim.keymap.set('n', '<leader>bp', vim.cmd.bprevious)

--ToggleTerm
vim.keymap.set('n', '<leader>t', vim.cmd.ToggleTerm)

-- Dashboard
vim.keymap.set('n', '<leader>D', vim.cmd.Dashboard)

-- Telescope
local file_browser = require "telescope".extensions.file_browser.file_browser
local builtin = require('telescope.builtin')
vim.keymap.set('n', '<leader>ff', builtin.find_files, {})
vim.keymap.set('n', '<leader>fg', builtin.live_grep, {})
vim.keymap.set('n', "<leader>wf", file_browser, {})

-- DAP

vim.keymap.set("n", "<F9>", vim.cmd.DapStepOver)
vim.keymap.set("n", "<F5>", vim.cmd.DapStepInto)
vim.keymap.set("n", "<F6>", vim.cmd.DapStepOut)
vim.keymap.set("n", "<leader>do", vim.cmd.DapContinue)
vim.keymap.set("n", "<leader>dr", ":lua require'dap'.repl.open()<CR>")
vim.keymap.set("n", "<leader>B", ":lua require'dap'.set_breakpoint(vim. fn. input('Breakpoint condition: '))<CR>")
vim.keymap.set("n", "<leader>b", vim.cmd.DapToggleBreakpoint)

-- ToggleTerm
vim.keymap.set('t', '<esc>', [[<C-\><C-n>]])

-- LSP
vim.keymap.set('n', '<space>e', vim.diagnostic.open_float)
vim.keymap.set('n', '[d', vim.diagnostic.goto_prev)
vim.keymap.set('n', ']d', vim.diagnostic.goto_next)
vim.keymap.set('n', '<space>q', vim.diagnostic.setloclist)

-- Use LspAttach autocommand to only map the following keys
-- after the language server attaches to the current buffer
vim.api.nvim_create_autocmd('LspAttach', {
	group = vim.api.nvim_create_augroup('UserLspConfig', {}),
	callback = function(ev)
		-- Enable completion triggered by <c-x><c-o>
		vim.bo[ev.buf].omnifunc = 'v:lua.vim.lsp.omnifunc'

		-- Buffer local mappings.
		-- See `:help vim.lsp.*` for documentation on any of the below functions
		local opts = { buffer = ev.buf }
		vim.keymap.set('n', 'gD', vim.lsp.buf.declaration, opts)
		vim.keymap.set('n', 'gd', vim.lsp.buf.definition, opts)
		vim.keymap.set('n', 'K', vim.lsp.buf.hover, opts)
		vim.keymap.set('n', 'gi', vim.lsp.buf.implementation, opts)
		vim.keymap.set('n', '<C-k>', vim.lsp.buf.signature_help, opts)
		vim.keymap.set('n', '<space>wa', vim.lsp.buf.add_workspace_folder, opts)
		vim.keymap.set('n', '<space>wr', vim.lsp.buf.remove_workspace_folder, opts)
		vim.keymap.set('n', '<space>wl', function()
			print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
		end, opts)
		vim.keymap.set('n', '<space>D', vim.lsp.buf.type_definition, opts)
		vim.keymap.set('n', '<space>rn', vim.lsp.buf.rename, opts)
		vim.keymap.set({ 'n', 'v' }, '<space>ca', vim.lsp.buf.code_action, opts)
		vim.keymap.set('n', 'gr', vim.lsp.buf.references, opts)
		vim.keymap.set('n', '<space>f', function()
			vim.lsp.buf.format { async = true }
		end, opts)
	end,
})

-- UFO Code folding
-- Using ufo provider need remap `zR` and `zM`. If Neovim is 0.6.1, remap yourself
vim.keymap.set('n', 'zR', require('ufo').openAllFolds)
vim.keymap.set('n', 'zM', require('ufo').closeAllFolds)

-- NeoZoom
vim.keymap.set('n', '<CR>', function() vim.cmd('NeoZoomToggle') end, { silent = true, nowait = true })

-- Harpoon
vim.keymap.set('n', '<leader>hm', function () require("harpoon.mark").add_file() end )
vim.keymap.set('n', '<leader>hg', function () require("harpoon.ui").toggle_quick_menu() end)
vim.keymap.set('n', '<leader>hn', function () require("harpoon.ui").nav_next() end)
vim.keymap.set('n', '<leader>hp', function () require("harpoon.ui").nav_prev() end)
