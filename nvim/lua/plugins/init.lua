require("plugins.remap")
require("plugins.packer")
print("hello from plugins folder")

vim.wo.number = true

require('onedark').setup {
    style = 'dark'
}
require('onedark').load()
