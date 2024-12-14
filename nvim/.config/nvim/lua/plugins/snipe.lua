return {
	{
		"leath-dub/snipe.nvim",
		keys = {
			{
				"<leader>sn",
				function()
					require("snipe").open_buffer_menu()
				end,
				desc = "Open snipe buffer menu",
			},
		},
		opts = {
            position = "center",
            sort = "last",
        },
	},
}
