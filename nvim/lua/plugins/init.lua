require("plugins.remap")
require("plugins.packer")
require("plugins.telescope")
require("plugins.lualine")
require("plugins.treesitter")
require("plugins.lsp")
require("plugins.nvimtree")
require("plugins.gitsigns")
require("plugins.toggle_term")
require("plugins.dap.dap")

vim.wo.number = true
vim.wo.relativenumber = true
vim.signcolumn = "yes"
vim.wo.fillchars='eob: '
vim.g.neovide_padding_top = 70

-- Helper function for transparency formatting
local alpha = function()
  return string.format("%x", math.floor(255 * vim.g.transparency or 1.0))
end
-- g:neovide_transparency should be 0 if you want to unify transparency of content and title bar.
vim.g.neovide_transparency = 0.0
vim.g.transparency = 1.0
vim.g.neovide_background_color = "1f232e" .. alpha()

require('ayu').setup({
    mirage = true, -- Set to `true` to use `mirage` variant instead of `dark` for dark background.
    overrides = {
    }, -- A dictionary of group names, each associated with a dictionary of parameters (`bg`, `fg`, `sp` and `style`) and colors in hex.
})

vim.cmd [[colorscheme ayu]]
