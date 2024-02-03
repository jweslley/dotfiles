return {
	"nvim-neo-tree/neo-tree.nvim",
	branch = "v3.x",
	dependencies = {
		"nvim-lua/plenary.nvim",
		"nvim-tree/nvim-web-devicons",
		"MunifTanjim/nui.nvim",
	},
	config = function()
		require("neo-tree").setup({
			default_component_configs = {
				indent = {
					indent_size = 1,
					padding = 0,
					with_markers = false,
				},
			},
			window = {
				position = "left",
				width = 32,
				mappings = {
					["h"] = "toggle_node",
					["l"] = "open",
					["q"] = "close_window",
					["s"] = "open_split",
					["v"] = "open_vsplit",
				},
			},
		})

		vim.keymap.set("n", "<leader>q", ":Neotree reveal<CR>", {})
	end,
}
