return {
    {
        "neovim/nvim-lspconfig",
        dependencies = {
            {
                "folke/lazydev.nvim",
                ft = "lua",
                opts = {
                    library = {
                        { path = "${3rd}/luv/library", words = { "vim%.uv" } },
                    },
                },
            },
            { "williamboman/mason.nvim" },
            { "williamboman/mason-lspconfig.nvim" },
            { "hrsh7th/cmp-nvim-lsp" },
        },
        config = function()
            local capabilities = require("cmp_nvim_lsp").default_capabilities()

            require("mason").setup()
            require("mason-lspconfig").setup({
                ensure_installed = {
                    "lua_ls",
                    "gopls",
                    "dockerls",
                    "angularls",
                    "svelte",
                    "terraformls",
                    "basedpyright"
                },
            })

            local ok, pnpm_home = pcall(function()
                return vim.fn.system("pnpm root -g"):gsub("\n", "")
            end)
            if not ok or pnpm_home == "" then
                pnpm_home = nil
            end

            local function with_caps(opts)
                opts = opts or {}
                opts.capabilities = vim.tbl_deep_extend("force", capabilities, opts.capabilities or {})
                return opts
            end

            vim.lsp.config("lua_ls", with_caps({}))

            local ts_ls_opts = with_caps({
                filetypes = { "javascript", "typescript", "vue" },
            })
            if pnpm_home then
                ts_ls_opts.init_options = {
                    plugins = {
                        {
                            name = "@vue/typescript-plugin",
                            location = pnpm_home .. "/@vue/typescript-plugin",
                            languages = { "javascript", "typescript", "vue" },
                        },
                    },
                }
            end
            vim.lsp.config("ts_ls", ts_ls_opts)

            vim.lsp.config("gopls", with_caps({}))

            vim.lsp.config("dockerls", with_caps({
                settings = {
                    docker = {
                        languageserver = {
                            formatter = {
                                ignoreMultilineInstructions = true,
                            },
                        },
                    },
                }
            }))

            vim.lsp.config("angularls", with_caps({}))
            vim.lsp.config("svelte", with_caps({}))

            vim.lsp.config("biome", with_caps({
                cmd = { "biome", "lsp-proxy" },
                filetypes = { "javascript", "typescript", "typescriptreact", "javascriptreact", "json", "css", "scss", "markdown" },
                root_markers = { ".biome.json", ".git" },
                on_attach = function(client, bufnr)
                    if client.server_capabilities.documentFormattingProvider then
                        local opts = { noremap = true, silent = true, buffer = bufnr }
                        vim.keymap.set("n", "<leader>f", vim.lsp.buf.format, opts)
                    end
                end,
            }))

            vim.lsp.enable({
                "lua_ls",
                "ts_ls",
                "gopls",
                "dockerls",
                "angularls",
                "svelte",
                "biome",
            })
        end,
    },
}
