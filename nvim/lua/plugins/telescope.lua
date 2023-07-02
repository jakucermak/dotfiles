vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1

require("telescope").setup {


	defaults = {
		layout_config = {
			vertical = { width = 0.6, heigth = 0.6 }
		}
	},

	extensions = {
		file_browser = {

			grouped = true,
			initial_browser = "tree",
			-- disables netrw and use telescope-file-browser in its place
			mappings = {
				["i"] = {
					-- your custom insert mode mappings
				},
				["n"] = {
					-- your custom normal mode mappings
				},
			},
		},
	},
}

require("telescope").load_extension("file_browser")
require("telescope").load_extension("command_center")
require'telescope'.load_extension('repo')
