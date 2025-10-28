return {
    { "rcarriga/nvim-notify", enabled = false },
    { "akinsho/bufferline.nvim", enabled = false },
    {
        "neovim/nvim-lspconfig",
        opts = {
            inlay_hints = { enabled = false },
        },
    },
    {
        "nvim-treesitter/nvim-treesitter",
        opts = { indent = { enable = false } },
    },
}
