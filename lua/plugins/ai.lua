return {
    "folke/sidekick.nvim",
    opts = {
        cli = {
            mux = {
                backend = "tmux",
                enabled = true,
            },
            tools = {
                claude = { cmd = { "/Users/kevin.vinck/.claude/local/claude" } },
            },
        },
    },
}
