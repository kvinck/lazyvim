-- Options are automatically loaded before lazy.nvim startup
-- Default options that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/options.lua
-- Add any additional options here

-- Route "+ through OSC 52 when this session's yanks may need to reach another
-- machine. No-ops outside tmux/SSH, so `clipboard = ""` below still gives
-- plain `y` its default, register-local behaviour on a local Neovim.
require("config.remote_clipboard").setup()

vim.opt.scrolloff = 10
vim.o.tabstop = 4
vim.o.expandtab = true
vim.o.softtabstop = 4
vim.o.shiftwidth = 4
vim.g.snacks_animate = false
vim.g.lazyvim_eslint_auto_format = true
vim.g.augment_workspace_folders = { "~/git/gocbshub/", "~/git/gocbshub-wx54/" }

-- Disable clipboard integration to restore default yank behavior
vim.opt.clipboard = ""
