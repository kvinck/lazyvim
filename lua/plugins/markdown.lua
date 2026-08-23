-- markdownlint-cli2 resolves its config relative to the process cwd when reading
-- from stdin (how nvim-lint invokes it), so a config sitting in a vault or repo
-- root never gets picked up. Select one per buffer and pass it explicitly.
local config_dir = vim.fn.stdpath("config")
local default_config = vim.fs.joinpath(config_dir, "markdownlint.jsonc")
local vault_config = vim.fs.joinpath(config_dir, "markdownlint-vault.jsonc")

-- A vault is any directory holding `.obsidian/`, so notes are recognised
-- wherever the vaults happen to live instead of by hardcoded paths.
local function config_for(path)
    if path == nil or path == "" then
        return default_config
    end
    local found = vim.fs.find(".obsidian", {
        path = vim.fs.dirname(path),
        upward = true,
        type = "directory",
    })
    return vim.tbl_isempty(found) and default_config or vault_config
end

-- Linting reruns on InsertLeave, so cache the upward scan. Buffer-scoped state
-- expires with the buffer, which is exactly the lifetime of the answer.
local function config_for_buf()
    local ok, cached = pcall(vim.api.nvim_buf_get_var, 0, "markdownlint_config")
    if ok then
        return cached
    end
    local config = config_for(vim.api.nvim_buf_get_name(0))
    vim.api.nvim_buf_set_var(0, "markdownlint_config", config)
    return config
end

return {
    {
        "mfussenegger/nvim-lint",
        optional = true,
        opts = function()
            local linter = require("lint").linters["markdownlint-cli2"]
            linter.args = { "--config", config_for_buf, "-" }
        end,
    },
    {
        "stevearc/conform.nvim",
        optional = true,
        opts = {
            formatters = {
                ["markdownlint-cli2"] = {
                    prepend_args = function(_, ctx)
                        return { "--config", config_for(ctx.filename) }
                    end,
                },
            },
        },
    },
}
