return {
    {
        "leath-dub/snipe.nvim",
        commit = "2a1b738dfae8502e6162eddfc774da65ed404142",
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
