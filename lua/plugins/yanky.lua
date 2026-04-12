return {
  "gbprod/yanky.nvim",
  opts = {
    highlight = { timer = 150 },
  },
  keys = {
    -- Disable <leader>p for yank history (we'll use it for system clipboard paste)
    { "<leader>p", false },
  },
}
