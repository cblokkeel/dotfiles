return {
    "nvim-tree/nvim-tree.lua",
    dependencies = {
        "nvim-tree/nvim-web-devicons",
    },
    config = function()
        require("nvim-tree").setup()
        -- vim.keymap.set("n", "<C-n>", ":NvimTreeFocus<cr>", { desc = "Toggle Nvim Tree" })
        --
        -- vim.keymap.set("n", "<C-k>", ":NvimTreeFindFileToggle<cr>", { desc = "Toggle Nvim Tree" })
    end
}
