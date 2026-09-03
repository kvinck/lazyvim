-- Seamless <C-h/j/k/l> across Neovim splits and herdr panes.
--
-- Declared through `keys` rather than a plain `config`: LazyVim's
-- safe_keymap_set skips any lhs that a lazy spec has already claimed, so this
-- is what stops LazyVim's own <C-h> "Go to Left Window" defaults, set later on
-- VeryLazy, from silently replacing the pane-crossing versions.
local root = vim.fn.expand("~/git/personal/vim-herdr-navigation")

return {
  {
    dir = root,
    name = "vim-herdr-navigation",
    config = function()
      dofile(root .. "/editor/nvim.lua")
    end,
    keys = {
      { "<C-h>", mode = "n", desc = "Navigate left (vim/herdr)" },
      { "<C-j>", mode = "n", desc = "Navigate down (vim/herdr)" },
      { "<C-k>", mode = "n", desc = "Navigate up (vim/herdr)" },
      { "<C-l>", mode = "n", desc = "Navigate right (vim/herdr)" },
    },
  },
}
