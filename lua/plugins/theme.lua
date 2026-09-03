-- The colorscheme Omarchy currently has selected.
--
-- Kept at this exact module name because omarchy-theme-hotreload.lua reloads
-- `plugins.theme` by name. Returns nothing off Omarchy, where colorscheme.lua
-- picks the theme instead.
local omarchy = require("config.omarchy")

local theme_file = omarchy.theme_file()
if not theme_file then
    return {}
end

return dofile(theme_file)
