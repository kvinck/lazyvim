-- markdownlint-cli2 resolves its config relative to the process cwd when reading
-- from stdin (how nvim-lint invokes it), so a config sitting in a vault or repo
-- root never gets picked up. Point both the linter and the formatter at one
-- config that ships with this repo instead.
local config = vim.fs.joinpath(vim.fn.stdpath("config"), "markdownlint.jsonc")

return {
    {
        "mfussenegger/nvim-lint",
        optional = true,
        opts = function()
            local linter = require("lint").linters["markdownlint-cli2"]
            linter.args = { "--config", config, "-" }
        end,
    },
    {
        "stevearc/conform.nvim",
        optional = true,
        opts = {
            formatters = {
                ["markdownlint-cli2"] = {
                    prepend_args = { "--config", config },
                },
            },
        },
    },
}
