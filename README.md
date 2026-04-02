# Neovim Config

Personal Neovim setup built for C++/Protobuf development. Managed via [lazy.nvim](https://github.com/folke/lazy.nvim).

**Leader key:** `Space`

## Stack

| Category | Plugin |
|---|---|
| Package manager | mason.nvim |
| LSP | nvim-lspconfig + clangd, protols |
| Formatter | conform.nvim (clang-format, buf) |
| Completion | nvim-cmp + LuaSnip |
| Fuzzy finder | Telescope + fzf-native |
| File explorer | nvim-tree |
| Git | gitsigns.nvim |
| Treesitter | nvim-treesitter + textobjects |
| Statusline | lualine.nvim |
| Sessions | persistence.nvim |
| Markdown | markview.nvim |
| Keybinding hints | which-key.nvim |
| Colorscheme | moonfly |

## Key Files

- `init.lua` — entry point, options, keymaps
- `lua/plugins.lua` — all plugin specs
- `KEYMAPS.md` — full keymap reference

## Notable Keymaps

See [KEYMAPS.md](KEYMAPS.md) for the full reference. Quick highlights:

| Key | Action |
|---|---|
| `<leader>ff` | Find files (Telescope) |
| `<leader>fg` | Live grep |
| `<leader>e` | Toggle file explorer |
| `gd` / `gr` / `K` | LSP: definition / references / hover |
| `<leader>rn` | Rename symbol |
| `<leader>ca` | Code actions |
| `<leader>gb` | Git blame |
| `<leader>mp` | Toggle markdown preview |
| `<leader>qs` | Restore session |
