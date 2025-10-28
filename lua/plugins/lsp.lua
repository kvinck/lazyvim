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
                gopls = {
                    settings = {
                        gopls = {
                            usePlaceholders = false,
                            completeUnimported = true,
                            staticcheck = true,
                            gofumpt = true,
                            analyses = {
                                unusedparams = true,
                                shadow = false,
                                fieldalignment = false,
                            },
                            hints = {
                                assignVariableTypes = true,
                                compositeLiteralFields = true,
                                compositeLiteralTypes = true,
                                constantValues = true,
                                functionTypeParameters = true,
                                parameterNames = true,
                                rangeVariableTypes = true,
                            },
                            -- Ensure gopls watches all files in the workspace
                            directoryFilters = {
                                "-**/node_modules",
                                "-**/.git",
                                "-**/vendor",
                            },
                            semanticTokens = true,
                            -- Enable codelenses for better integration
                            codelenses = {
                                gc_details = true,
                                generate = true,
                                regenerate_cgo = true,
                                test = true,
                                tidy = true,
                                upgrade_dependency = true,
                                vendor = true,
                            },
                        },
                    },
                },
            },
        },
    },
}
