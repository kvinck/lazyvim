return {
    "obsidian-nvim/obsidian.nvim",
    version = "*", -- track the latest release rather than main
    ft = "markdown",
    cmd = "Obsidian",
    ---@module 'obsidian'
    ---@return obsidian.config
    opts = function()
        return {
            legacy_commands = false, -- removed upstream in 4.0.0

            workspaces = {
                { name = "vault", path = "~/Documents/Vault" },
                { name = "osk", path = "~/Documents/OSK Vault" },
                { name = "main", path = "~/Documents/Main" },
            },

            picker = { name = "snacks.picker" },

            -- Match how the Obsidian app names files: readable titles, not zettel IDs.
            note_id_func = require("obsidian.builtin").title_id,
            link = { style = "wiki", format = "shortest" },

            -- These vaults own their frontmatter (OSK note-type schemas), so don't let
            -- the plugin inject or reorder `id`/`aliases`/`tags` on every write.
            frontmatter = { enabled = false },

            -- render-markdown.nvim (LazyVim's lang.markdown extra) already draws markdown.
            ui = { enable = false },
        }
    end,
    keys = {
        { "<leader>o", "", desc = "+obsidian" },
        { "<leader>oo", "<cmd>Obsidian quick_switch<cr>", desc = "Quick switch note" },
        { "<leader>os", "<cmd>Obsidian search<cr>", desc = "Search notes" },
        { "<leader>on", "<cmd>Obsidian new<cr>", desc = "New note" },
        { "<leader>ot", "<cmd>Obsidian today<cr>", desc = "Today's daily note" },
        { "<leader>oy", "<cmd>Obsidian yesterday<cr>", desc = "Yesterday's daily note" },
        { "<leader>od", "<cmd>Obsidian dailies<cr>", desc = "Browse daily notes" },
        { "<leader>og", "<cmd>Obsidian tags<cr>", desc = "Search tags" },
        { "<leader>ow", "<cmd>Obsidian workspace<cr>", desc = "Switch workspace" },
        { "<leader>ob", "<cmd>Obsidian backlinks<cr>", desc = "Backlinks", ft = "markdown" },
        { "<leader>ol", "<cmd>Obsidian links<cr>", desc = "Links in note", ft = "markdown" },
        { "<leader>oc", "<cmd>Obsidian toc<cr>", desc = "Table of contents", ft = "markdown" },
        { "<leader>op", "<cmd>Obsidian paste_img<cr>", desc = "Paste image", ft = "markdown" },
        { "<leader>or", "<cmd>Obsidian rename<cr>", desc = "Rename note", ft = "markdown" },
        { "<leader>oe", "<cmd>Obsidian extract_note<cr>", desc = "Extract to new note", mode = "v", ft = "markdown" },
        { "<leader>ok", "<cmd>Obsidian link<cr>", desc = "Link to note", mode = "v", ft = "markdown" },
    },
}
