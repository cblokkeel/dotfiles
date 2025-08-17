-- lua/plugins/json.lua
return {
    {
        "mogelbrod/vim-jsonpath",
        -- You can specify when it should load. For a JSON-specific plugin,
        -- loading it when a JSON file is opened is a good practice.
        ft = { "json", "jsonc" }, -- Load for json and jsonc filetypes
        -- Or, you could load it when the command is first used:
        -- cmd = "JsonPath",

        -- Optional: Configure the plugin using its global variables
        -- This function will run before the plugin is loaded.
        init = function()
            -- Example: Set the register to yank the path to (e.g., system clipboard)
            vim.g.jsonpath_yank_register = "+" -- Use '+' for system clipboard

            -- Example: Automatically yank the path when :JsonPath is called
            vim.g.jsonpath_auto_yank = 1 -- Set to 1 to enable, 0 to disable (default)
        end,

        -- Optional: Add keymappings
        keys = {
            {
                "<leader>jp", -- Or any keybinding you prefer
                "<cmd>JsonPath<CR>",
                mode = "n", -- Normal mode
                desc = "Get JSON Path",
            },
            -- If you want to yank it directly without auto_yank and without changing the default register
            {
                "<leader>jP", -- Example: Shift + j + p
                function()
                    -- Store current yank register
                    local old_reg = vim.fn.getreginfo('"')
                    vim.cmd('let g:jsonpath_yank_register = \'"\'') -- Use unnamed register
                    vim.cmd('let g:jsonpath_auto_yank = 1')
                    vim.cmd("JsonPath")
                    -- Restore original auto_yank and register settings if needed, or just reset
                    vim.cmd('let g:jsonpath_auto_yank = 0') -- Assuming default is 0
                    -- If you changed jsonpath_yank_register from a non-default, restore it
                    -- vim.fn.setreg('"', old_reg) -- This might be too complex if you just want a quick yank
                    print("JSON Path yanked to unnamed register")
                end,
                mode = "n",
                desc = "Yank JSON Path to unnamed register",
            },
        },
    },
}
