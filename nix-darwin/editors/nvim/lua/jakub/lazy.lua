local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not (vim.uv or vim.loop).fs_stat(lazypath) then
  vim.fn.system({
    "git",
    "clone",
    "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable", -- latest stable release
    lazypath,
  })
end
vim.opt.rtp:prepend(lazypath)
vim.g.mapleader = " "

return require("lazy").setup({

'Shatur/neovim-ayu',
'nvim-lua/plenary.nvim',
'tpope/vim-commentary',

{import = "jakub.plugins"}, {import = "jakub.plugins.lsp"}, checker = {

    enabled = true,
    notify = false,
  },
  change_detection = {
    notify = false,
  },
}
)
