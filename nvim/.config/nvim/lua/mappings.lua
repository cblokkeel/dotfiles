local map = vim.keymap.set

-- Vim motions
map("n", "<C-d>", "<C-d>zz", {})
map("n", "<C-u>", "<C-u>zz", {})
map("n", "n", "nzzzv", {})
map("n", "N", "Nzzzv", {})

-- MiniFiles
map("n", "<C-n>", ":lua MiniFiles.open()<cr>", {})
map("n", "<C-b>", ":lua MiniFiles.close()<cr>", {})

-- Navigation
map("n", "<leader>l", ":bnext<cr>zz", {})
map("n", "<leader>h", ":bprevious<cr>zz", {})

local harpoon = require("harpoon")

-- Harpoon
map("n", "<leader>a", function() harpoon:list():add() end)
map("n", "<C-e>", function() harpoon.ui:toggle_quick_menu(harpoon:list()) end)

map("n", "<C-h>", function() harpoon:list():select(1) end)
map("n", "<C-t>", function() harpoon:list():select(2) end)
map("n", "<C-v>", function() harpoon:list():select(3) end)
map("n", "<C-s>", function() harpoon:list():select(4) end)

-- Toggle previous & next buffers stored within Harpoon list
map("n", "<C-S-P>", function() harpoon:list():prev() end)
map("n", "<C-S-N>", function() harpoon:list():next() end)

-- Twilight
map("n", "<leader>tw", ":Twilight<cr>", {})


-- LSP
map("n", "gl", "<cmd>lua vim.diagnostic.open_float()<CR>", {})
map("n", "gd", vim.lsp.buf.definition, {})

map("n", "<leader>r", vim.lsp.buf.rename, {})

-- Close quickfix after jumping to a location
vim.api.nvim_create_autocmd("FileType", {
    pattern = "qf",
    command = [[nnoremap <buffer> <CR> <CR>:cclose<CR>]]
})

-- Misc
local function close_all_buffers()
    local bufs = vim.api.nvim_list_bufs()
    local current_buf = vim.api.nvim_get_current_buf()
    for _, i in ipairs(bufs) do
        if i ~= current_buf then
            vim.api.nvim_buf_delete(i, {})
        end
    end
end

map("n", "<leader>ca", close_all_buffers, {})
