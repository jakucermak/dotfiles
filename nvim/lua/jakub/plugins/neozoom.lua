return {
	"nyngwang/NeoZoom.lua",
	config = function()
		require("neo-zoom").setup({
			winopts = {
				offset = {
					width = 0.95,
					height = 0.95,
				},
				border = "rounded",
			},
		})

		vim.keymap.set("n", "<C-ESC>", function()
			vim.cmd("NeoZoomToggle")
		end, { silent = true, nowait = true })
	end,
}
