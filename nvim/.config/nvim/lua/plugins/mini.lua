local open_files_on_current_location = function()
  local MiniFiles = require("mini.files")
  local _ = MiniFiles.close()
    or MiniFiles.open(vim.api.nvim_buf_get_name(0), false)
  vim.defer_fn(function()
    MiniFiles.reveal_cwd()
  end, 30)
end


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

            vim.keymap.set("n", "<C-k>", open_files_on_current_location, {})

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
