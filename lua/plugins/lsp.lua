return {
    {
        "neovim/nvim-lspconfig",
        opts = {
            servers = {
                tsserver = {
                    enabled = false,
                },
                ts_ls = {
                    enabled = false,
                },
                vtsls = {
                    filetypes = {
                        "javascript",
                        "javascriptreact",
                        "javascript.jsx",
                        "typescript",
                        "typescriptreact",
                        "typescript.tsx",
                    },
                    settings = {
                        typescript = {
                            updateImportsOnFileMove = { enabled = "always" },
                            suggest = {
                                completeFunctionCalls = true,
                            },
                            tsserver = {
                                maxTsServerMemory = 32192,
                            },
                            inlayHints = {
                                enumMemberValues = { enabled = true },
                                functionLikeReturnTypes = { enabled = true },
                                parameterNames = { enabled = "literals" },
                                parameterTypes = { enabled = true },
                                propertyDeclarationTypes = { enabled = true },
                                variableTypes = { enabled = false },
                            },
                            preferences = {
                                includePackageJsonAutoImports = "off",
                            },
                        },
                    },
                },
            },
        },
    },
}
