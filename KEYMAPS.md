# Neovim Keymaps Reference

> **Leader key:** `Space`
> Search this file for a category name or key combo to jump straight to what you need.

---

## Table of Contents

- [Navigation](#navigation)
- [Editing](#editing)
- [Yank / Textobjects](#yank--textobjects)
- [Files & Buffers](#files--buffers)
- [Splits & Windows](#splits--windows)
- [Tabs](#tabs)
- [LSP](#lsp)
- [Diagnostics](#diagnostics)
- [Git](#git)
- [Telescope](#telescope)
- [Sessions](#sessions)
- [Markdown](#markdown)

---

## Navigation

### Search

| Key | Mode | Action |
|-----|------|--------|
| `n` | Normal | Next search result (auto-centered) |
| `N` | Normal | Previous search result (auto-centered) |
| `<C-d>` | Normal | Half page down (auto-centered) |
| `<C-u>` | Normal | Half page up (auto-centered) |

### Word / Line

| Key | Mode | Action |
|-----|------|--------|
| `<M-Left>` / `⌥←` | Normal, Insert | Jump to previous word |
| `<M-Right>` / `⌥→` | Normal, Insert | Jump to next word |
| `<D-Left>` / `⌘←` | Normal, Insert | Beginning of line |
| `<D-Right>` / `⌘→` | Normal, Insert | End of line |
| `<D-Up>` / `⌘↑` | Normal, Insert | Beginning of file |
| `<D-Down>` / `⌘↓` | Normal, Insert | End of file |

---

## Editing

### Line Operations

| Key | Mode | Action |
|-----|------|--------|
| `<A-j>` / `⌥j` | Normal | Move line down |
| `<A-k>` / `⌥k` | Normal | Move line up |
| `<A-j>` / `⌥j` | Visual | Move selection down |
| `<A-k>` / `⌥k` | Visual | Move selection up |
| `<D-x>` / `⌘x` | Insert | Delete current line |

### Indenting

| Key | Mode | Action |
|-----|------|--------|
| `>` | Visual | Indent right (keeps selection) |
| `<` | Visual | Indent left (keeps selection) |

### Word Deletion

| Key | Mode | Action |
|-----|------|--------|
| `<M-BS>` / `⌥⌫` | Insert | Delete previous word |
| `<M-Del>` / `⌥⌦` | Insert | Delete next word |

### Commenting

| Key | Mode | Action |
|-----|------|--------|
| `<D-/>` / `⌘/` | Normal, Insert | Toggle comment on line |
| `<D-/>` / `⌘/` | Visual | Toggle comment on selection |

---

## Yank / Textobjects

| Key | Mode | Action |
|-----|------|--------|
| `Y` | Normal | Yank to end of line (like `D` but copies) |
| `yaf` | Normal | Yank around function (whole function + signature) |
| `yif` | Normal | Yank inner function (body only) |
| `yac` | Normal | Yank around class |
| `yic` | Normal | Yank inner class |

> **Tip:** `af` / `if` / `ac` / `ic` are full textobjects — combine them with any operator.
> Examples: `daf` (delete function), `vif` (visually select body), `cac` (change whole class).
> `lookahead = true` means the cursor doesn't need to be on the opening brace — it finds the next one ahead.

---

## Files & Buffers

### File Explorer

| Key | Mode | Action |
|-----|------|--------|
| `<leader>e` | Normal | Toggle file explorer (nvim-tree) |

### Saving & Config

| Key | Mode | Action |
|-----|------|--------|
| `<D-s>` / `⌘s` | Normal, Insert | Save file |
| `<leader>rc` | Normal | Edit `init.lua` config |
| `<leader>rr` | Normal | Rename current file |

### Path Copying (copies to system clipboard)

| Key | Mode | Action |
|-----|------|--------|
| `<leader>pa` | Normal | Copy file's **directory** path |
| `<leader>pf` | Normal | Copy **full** absolute file path |
| `<leader>pr` | Normal | Copy **relative** file path |

### Buffer Navigation

| Key | Mode | Action |
|-----|------|--------|
| `<leader>bn` | Normal | Next buffer |
| `<leader>bp` | Normal | Previous buffer |

---

## Splits & Windows

| Key | Mode | Action |
|-----|------|--------|
| `<leader>sv` | Normal | Split window vertically |
| `<leader>sh` | Normal | Split window horizontally |
| `<C-Up>` | Normal | Increase window height |
| `<C-Down>` | Normal | Decrease window height |
| `<C-Left>` | Normal | Decrease window width |
| `<C-Right>` | Normal | Increase window width |

---

## Tabs

| Key | Mode | Action |
|-----|------|--------|
| `<leader>tn` | Normal | New tab |
| `<leader>tx` | Normal | Close current tab |
| `gt` | Normal | Next tab (built-in) |
| `gT` | Normal | Previous tab (built-in) |

---

## LSP

> These keybindings are only active when a language server is attached to the buffer.

| Key | Mode | Action |
|-----|------|--------|
| `gd` | Normal | Go to **definition** |
| `gD` | Normal | Go to **declaration** |
| `gi` | Normal | Go to **implementation** |
| `gr` | Normal | Show all **references** |
| `K` | Normal | Hover documentation popup |
| `<leader>D` | Normal | Go to **type definition** |
| `<leader>rn` | Normal | **Rename** symbol everywhere |
| `<leader>ca` | Normal | **Code actions** (quick fixes, imports…) |
| `<leader>f` | Normal | Format file via LSP |
| `<leader>fa` | Normal | Format file via conform.nvim |

---

## Diagnostics

| Key | Mode | Action |
|-----|------|--------|
| `nd` | Normal | Jump to **next** diagnostic |
| `pd` | Normal | Jump to **previous** diagnostic |
| `<leader>dl` | Normal | Show diagnostic popup for current line |
| `<leader>q` | Normal | Open diagnostic list (location list) |

---

## Git

> Powered by gitsigns.nvim

| Key | Mode | Action |
|-----|------|--------|
| `<leader>gb` | Normal | Git blame current line |
| `<leader>gd` | Normal | Git diff current file |
| `<leader>gh` | Normal | Preview current hunk |

---

## Telescope

| Key | Mode | Action |
|-----|------|--------|
| `<leader>ff` | Normal | Find files (fuzzy) |
| `<leader>fg` | Normal | Live grep across project |
| `<leader>fb` | Normal | Find open buffers |
| `<leader>fh` | Normal | Search help tags |

---

## Sessions

> Powered by persistence.nvim — sessions are saved per working directory.

| Key | Mode | Action |
|-----|------|--------|
| `<leader>qs` | Normal | Restore session for current directory |
| `<leader>ql` | Normal | Restore last session |
| `<leader>qd` | Normal | Stop auto-saving the session |

---

## Markdown

> Only active in `.md` files. Powered by markview.nvim.

| Key | Mode | Action |
|-----|------|--------|
| `<leader>mp` | Normal | Toggle in-buffer markdown preview |
| `<leader>ms` | Normal | Toggle markdown split view |
