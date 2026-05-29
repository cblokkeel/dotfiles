return {
    "zaldih/themery.nvim",
    lazy = false,
    config = function()
        require("themery").setup({
            themes = { "catppuccin", "yugen", "vesper", "kanagawa", "amp", "gruvbox-material" }
        })
    end
}
