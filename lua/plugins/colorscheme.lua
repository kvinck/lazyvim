-- Tokyonight, except on Omarchy, where theme.lua follows whatever
-- `omarchy theme set` has selected. Both files set LazyVim's `colorscheme`
-- opt, so exactly one of them may return a spec.
if require("config.omarchy").enabled() then
    return {}
end

return {
    { "folke/tokyonight.nvim", name = "tokyonight", priority = 1000 },
    {
        "LazyVim/LazyVim",
        opts = {
            colorscheme = "tokyonight",
        },
    },
}
