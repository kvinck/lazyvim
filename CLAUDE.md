# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Overview

This is a LazyVim-based Neovim configuration built on top of the LazyVim starter template. LazyVim provides a base configuration that is extended through plugin overrides and custom configuration.

## Architecture

### Configuration Structure

The configuration follows LazyVim's standard structure:

- `init.lua` - Entry point that bootstraps lazy.nvim and loads the config
- `lua/config/` - Core configuration overrides
  - `lazy.lua` - Lazy.nvim setup and plugin spec definition
  - `options.lua` - Vim options (loaded before lazy.nvim)
  - `keymaps.lua` - Custom keybindings (loaded on VeryLazy event)
  - `autocmds.lua` - Custom autocommands (loaded on VeryLazy event)
- `lua/plugins/` - Plugin specifications and overrides
- `lazyvim.json` - LazyVim extras configuration (managed by LazyVim UI)
- `lazy-lock.json` - Plugin version lockfile (managed by lazy.nvim)

### Plugin System

This config uses lazy.nvim as the plugin manager. The plugin loading architecture:

1. LazyVim core plugins are imported via `{ "LazyVim/LazyVim", import = "lazyvim.plugins" }`
2. Custom plugins and overrides are loaded from `lua/plugins/*.lua` via `{ import = "plugins" }`
3. Each file in `lua/plugins/` should return a table (single plugin) or array of tables (multiple plugins)
4. To override LazyVim plugin settings, create a file that returns a table with the plugin name and new `opts`

### Key Plugin Overrides

- **LSP Configuration** (`lua/plugins/lsp.lua`): Disables tsserver/ts_ls in favor of vtsls with custom TypeScript settings including inlay hints, auto-imports, and memory limits
- **AI Integration** (`lua/plugins/ai.lua`): Configures sidekick.nvim with tmux multiplexing and custom Claude CLI path
- **Completion** (`lua/plugins/blink.lua`): Enables blink.cmp ghost text
- **Navigation** (`lua/plugins/hop.lua`): Configures hop.nvim for quick word jumping with custom key sequence

### Enabled LazyVim Extras

The `lazyvim.json` file tracks enabled extras. Notable ones:
- Languages: TypeScript, Python, Go, Elixir, PHP, Svelte, Vue, Terraform, Ansible, Docker
- Tools: DAP debugger, Prettier formatting, ESLint linting, testing framework
- UI: Aerial, outline, neo-tree, snacks picker/explorer, treesitter-context
- Coding: mini-surround, yanky, inc-rename, dial

## Custom Settings

### Vim Options (lua/config/options.lua)

- Tab width: 4 spaces (overrides LazyVim's default of 2)
- Scroll offset: 10 lines
- ESLint auto-format: enabled
- Snacks animations: disabled
- Augment workspace folders: Includes `~/git/gocbshub/` and `~/git/gocbshub-wx54/`

### Custom Keybindings (lua/config/keymaps.lua)

Notable custom mappings:
- `<C-v>` - Exit insert mode (replaces Esc)
- `<C-s>` - Save all files
- `gh` / `gl` - Jump to start/end of line
- `gw` - Hop to word (using hop.nvim)
- `<leader>p` - Paste without overwriting clipboard (visual mode)
- `<leader>y/Y` - Yank to system clipboard
- `<leader>d` - Delete to black hole register
- `Q` - Disabled (no-op)

## Development Commands

### Plugin Management

```bash
# Launch Neovim
nvim

# Inside Neovim:
:Lazy          # Open lazy.nvim UI
:Lazy sync     # Install/update/clean plugins
:Lazy restore  # Restore plugins to lockfile versions
:Lazy profile  # View plugin load times
```

### LazyVim Management

```bash
# Inside Neovim:
:LazyVim       # Open LazyVim UI (manage extras)
:LazyExtras    # Browse and toggle LazyVim extras
```

### LSP & Formatting

```bash
# Inside Neovim:
:LspInfo       # Show LSP status
:Mason         # Open Mason UI for LSP/DAP/linter management
:ConformInfo   # Show formatter status
:checkhealth   # Run health checks
```

## Testing Configuration Changes

When modifying this configuration:

1. Test plugin changes: Open Neovim in a clean state with `:Lazy sync` to install/update
2. Test LSP changes: Open a file of the relevant type and run `:LspInfo` to verify server attachment
3. Test keymaps: Use `:map <key>` to verify mapping or `:Telescope keymaps` to browse all
4. Check for errors: Run `:checkhealth` and review messages
5. Test from scratch: Run `nvim --clean -u lua/config/lazy.lua` to test without cache

## Important Notes

- Plugin configurations should be placed in separate files under `lua/plugins/`
- To disable a LazyVim plugin, set `enabled = false` in its plugin spec
- The `lazyvim.json` file should not be manually edited; use `:LazyExtras` instead
- Custom options/keymaps/autocmds extend (not replace) LazyVim defaults
- TypeScript projects use vtsls LSP server with 32GB memory limit configured
- AI tooling is configured to work with tmux multiplexing via sidekick.nvim
