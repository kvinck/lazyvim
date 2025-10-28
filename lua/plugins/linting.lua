return {
    {
        "mfussenegger/nvim-lint",
        opts = {
            linters_by_ft = {
                -- Disable golangci-lint for Go files (gopls with staticcheck handles this)
                go = {},
            },
        },
    },
}
