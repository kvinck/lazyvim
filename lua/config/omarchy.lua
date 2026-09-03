-- Omarchy integration.
--
-- Omarchy points ~/.local/state/omarchy/current/theme at the active theme and
-- repoints it on `omarchy theme set`. A stock Omarchy install symlinks
-- lua/plugins/theme.lua into that directory, which this config cannot do -- it
-- is a git repository shared with a Mac, where the target does not exist. So
-- everything Omarchy-specific is instead guarded on the state directory being
-- there, and reads the theme spec out of it at load time.
local M = {}

local THEME_DIR = vim.fn.expand("~/.local/state/omarchy/current/theme")

-- Absolute path of the current theme's Neovim spec, or nil when this is not
-- an Omarchy machine.
function M.theme_file()
    local file = THEME_DIR .. "/neovim.lua"
    if vim.fn.filereadable(file) == 1 then
        return file
    end
    return nil
end

function M.enabled()
    return M.theme_file() ~= nil
end

return M
