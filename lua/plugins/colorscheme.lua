-- Retro '82, except on Omarchy, where theme.lua follows whatever
-- `omarchy theme set` has selected. Both files set LazyVim's `colorscheme`
-- opt, so exactly one of them may return a spec.
if require("config.omarchy").enabled() then
    return {}
end

return {
    {
        "OldJobobo/retro-82.nvim",
        name = "retro-82",
        priority = 1000,
    },
    {
        "LazyVim/LazyVim",
        opts = {
            colorscheme = "retro-82",
        },
    },
}
