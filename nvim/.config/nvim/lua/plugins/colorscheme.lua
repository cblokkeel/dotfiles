local catppuccin = {
    {
        "catppuccin/nvim",
        lazy = true,
        name = "catppuccin",
        opts = {
            transparent_background = true,
            integrations = {
                cmp = true,
                gitsigns = true,
                mason = true,
                mini = true,
                native_lsp = {
                    enabled = true,
                    underlines = {
                        errors = { "undercurl" },
                        hints = { "undercurl" },
                        warnings = { "undercurl" },
                        information = { "undercurl" },
                    },
                },
                snacks = true,
                telescope = true,
                treesitter = true,
            },
        },
    },
}

return {
    catppuccin,
    { 'bettervim/yugen.nvim', lazy = true },
    { 'datsfilipe/vesper.nvim', lazy = true },
    {
        "rebelot/kanagawa.nvim",
        lazy = true,
        opts = {
            transparent = true,
            theme = "wave",
            background = {
                dark = "wave",
                light = "lotus",
            }
        }
    },
    {
        "cblokkeel/nvim-amp-theme",
        lazy = true,
        opts = {
            variant = "dark",
            transparent = true,
            terminal_colors = true,
        }
    },
    {
        'sainnhe/gruvbox-material',
        lazy = false,
        priority = 1000,
        config = function()
            vim.g.gruvbox_material_enable_italic = true
            vim.g.gruvbox_material_background = 'hard'
            vim.g.gruvbox_material_transparent_background = 2
        end
    }
}
