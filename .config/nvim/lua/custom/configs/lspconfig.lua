local on_attach = require("plugins.configs.lspconfig").on_attach
local capabilities = require("plugins.configs.lspconfig").capabilities

local lspconfig = require "lspconfig"

lspconfig.gopls.setup {
    on_attach = on_attach,
    capabilities = capabilities,
    cmd = { "gopls" },
    filetypes = { "go", "gomod", "gowork", "gotmpl" },
    settings = {
        gopls = {
            completeUnimported = true,
            usePlaceholders = true,
            analyses = {
                unusedparams = true
            }
        }
    }
}

lspconfig.tsserver.setup {
    on_attach = on_attach,
    capabilities = capabilities,
    init_options = {
        preferences = {
            disableSuggestions = true
        }
    },
    filetypes = { "typescript", "javascript", "javascriptreact", "typescriptreact" },
}

lspconfig.volar.setup({
    filetypes = {
        'vue',
    },
    init_options = {
        typescript = {
            tsdk = '/Users/cblokkeel/.local/share/nvim/mason/packages/vue-language-server/node_modules/typescript/lib',
        },
        preferences = {
            disableSuggestions = true,
        },
        languageFeatures = {
            implementation = true,
            references = true,
            definition = true,
            typeDefinition = true,
            callHierarchy = true,
            hover = true,
            rename = true,
            renameFileRefactoring = true,
            signatureHelp = true,
            codeAction = true,
            workspaceSymbol = true,
            diagnostics = true,
            semanticTokens = true,
            completion = {
                defaultTagNameCase = 'both',
                defaultAttrNameCase = 'kebabCase',
                getDocumentNameCasesRequest = false,
                getDocumentSelectionRequest = false,
            },
        },
    },
})

lspconfig.emmet_ls.setup {}

lspconfig.dockerls.setup {}

lspconfig.templ.setup {}

lspconfig.html.setup {
    on_attach = on_attach,
    capabilities = capabilities,
    filetypes = { "html", "templ" },
}

lspconfig.htmx.setup {
    on_attach = on_attach,
    capabilities = capabilities,
    filetypes = { "html", "templ" },
}

lspconfig.tailwindcss.setup({
    on_attach = on_attach,
    capabilities = capabilities,
    filetypes = { "templ", "astro", "javascript", "typescript", "react", "vue" },
    init_options = { userLanguages = { templ = "html" } },
})
