return {
    {
        "neovim/nvim-lspconfig",
        dependencies = {
            {
                "folke/lazydev.nvim",
                ft = "lua", -- only load on lua files
                opts = {
                    library = {
                        -- See the configuration section for more details
                        -- Load luvit types when the `vim.uv` word is found
                        { path = "${3rd}/luv/library", words = { "vim%.uv" } },
                    },
                },
            },
            {
                "williamboman/mason.nvim",
            },
            {
                "williamboman/mason-lspconfig.nvim",
            }
        },
        opts = {
            servers = {
                biome = {
                    cmd = { "biome", "lsp-proxy" },
                    filetypes = { "javascript", "typescript", "typescriptreact", "javascriptreact", "json", "css", "scss", "markdown" },
                    root_dir = function(fname)
                        return require("lspconfig.util").root_pattern(".biome.json", ".git")(fname)
                    end,
                    on_attach = function(client, bufnr)
                        if client.server_capabilities.documentFormattingProvider then
                            local opts = { noremap = true, silent = true, buffer = bufnr }
                            vim.keymap.set("n", "<leader>f", vim.lsp.buf.format, opts)
                        end
                    end,

                },
            }
        },
        config = function(_, opts)
            local lspconfig = require("lspconfig")
            local mason = require("mason")
            local mason_lsp_config = require("mason-lspconfig")

            mason.setup()

            mason_lsp_config.setup({
                ensure_installed = {
                    "lua_ls",
                    "vue_ls",
                    "gopls",
                    "dockerls",
                    "angularls",
                    "svelte",
                    "terraformls",
                    "basedpyright"
                },
                automatic_enable = {
                    exclude = { "ts_ls", "volar" },
                }
            })

            local pnpm_home = vim.fn.system("pnpm root -g"):gsub("\n", "")

            lspconfig.lua_ls.setup {}

            lspconfig.ts_ls.setup {
                init_options = {
                    plugins = {
                        {
                            name = "@vue/typescript-plugin",
                            location = pnpm_home .. "/@vue/typescript-plugin",
                            languages = { "javascript", "typescript", "vue" },
                        },
                    },
                },
                filetypes = {
                    "javascript",
                    "typescript",
                    "vue",
                },
            }

            -- lspconfig.volar.setup {
            --     init_options = {
            --         typescript = {
            --             tsdk = pnpm_home .. '/typescript/lib',
            --             vue = {
            --                 hybridMode = false,
            --             }
            --         }
            --     }
            -- }

            lspconfig.gopls.setup {}

            lspconfig.dockerls.setup {
                settings = {
                    docker = {
                        languageserver = {
                            formatter = {
                                ignoreMultilineInstructions = true,
                            },
                        },
                    },
                }
            };

            lspconfig.angularls.setup {}

            lspconfig.svelte.setup {}

            for server, server_opts in pairs(opts.servers) do
                lspconfig[server].setup(server_opts)
            end
        end
    }
}
