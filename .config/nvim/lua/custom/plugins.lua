local plugins = {
    {
    "neovim/nvim-lspconfig",
        config = function ()
          require "plugins.configs.lspconfig"
          require "custom.configs.lspconfig"
        end
    },
    {
        "williamboman/mason.nvim",
        opts = {
          ensure_installed = {
            "gopls",
            "gofumpt",
            "goimports-reviser",
            "vue-language-server",
            "typescript-language-server",
            "eslint-lsp",
            "prettierd",
            "emmet-ls",
            "html-lsp",
            "htmx-lsp",
          }
        }
    },
    {
        "nvimtools/none-ls.nvim",
        event = "VeryLazy",
        opts = function ()
          return require "custom.configs.null-ls"
        end
    },
    {
        "olexsmir/gopher.nvim",
        ft = "go",
        config = function (_, opts)
          require("gopher").setup(opts)
        end,
        build = function ()
          vim.cmd [[silent! GoInstallDeps]]
        end,
    },
    {
        "christoomey/vim-tmux-navigator",
        lazy = false
    }
}

return plugins
