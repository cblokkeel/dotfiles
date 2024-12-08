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
		},
		config = function()
			local lspconfig = require("lspconfig")
			local mason = require("mason")
			mason.setup()

			lspconfig.lua_ls.setup {}

            lspconfig.ts_ls.setup {
                init_options = {
                    plugins = {
                        {
                            name = "@vue/typescript-plugin",
                            location = "/Users/cblokkeel/Library/pnpm/global/5/node_modules/@vue-typescript-plugin",
                            languages = {"javascript", "typescript", "vue"},
                        },
                    },
                },
                filetypes = {
                    "javascript",
                    "typescript",
                    "vue",
                },
            }

            lspconfig.volar.setup {
                init_options = {
                    typescript = {
                        -- Warning: may need to change the path
                        tsdk = '/Users/cblokkeel/Library/pnpm/global/5/node_modules/typescript/lib',
                        vue = {
                            hybridMode = false,
                        }
                    }
                }
            }

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
		end
	}
}
