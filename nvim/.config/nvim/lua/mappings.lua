local map = vim.keymap.set

-- Vim motions
map("n", "<C-d>", "<C-d>zz", {})
map("n", "<C-u>", "<C-u>zz", {})
map("n", "n", "nzzzv", {})
map("n", "N", "Nzzzv", {})

-- MiniFiles
-- map("n", "<C-n>", ":lua MiniFiles.open()<cr>", {})
map("n", "<C-b>", ":lua MiniFiles.close()<cr>", {})

-- Navigation
map("n", "<leader>l", ":bnext<cr>zz", {})
map("n", "<leader>h", ":bprevious<cr>zz", {})

-- Twilight
map("n", "<leader>tw", ":Twilight<cr>", {})


-- LSP
map("n", "gl", "<cmd>lua vim.diagnostic.open_float()<CR>", {})
vim.api.nvim_create_autocmd("LspAttach", {
    callback = function()
        map("n", "gd", vim.lsp.buf.definition, {})

        map("n", "<leader>r", vim.lsp.buf.rename, {})
        map("n", "<leader>ca", vim.lsp.buf.code_action, {})
    end,
})

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

-- Copilot
map("i", "<C-f>", function()
    return vim.fn['copilot#Accept']('<CR>')
end, { expr = true, replace_keycodes = false })

map('i', '<C-\\>', '<Plug>(copilot-dismiss)')

-- Ng
local ng = require("ng");
map("n", "<leader>at", ng.goto_template_for_component, {})
map("n", "<leader>ac", ng.goto_component_with_template_file, {})
