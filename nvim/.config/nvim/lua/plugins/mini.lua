return {
    {
        'echasnovski/mini.nvim',
        version = false,
        config = function()
            require("mini.files").setup({
                windows = {
                    preview = true
                }
            })
            require("mini.icons").setup({})
            require("mini.pairs").setup({})

            require('mini.completion').setup({})

            require("mini.sessions").setup({})

            require("mini.operators").setup({})

            require("mini.comment").setup({})

            require("mini.statusline").setup({})
        end
    }
}
