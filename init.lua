-- Leader keys (must be set before loading lazy.nvim)
vim.g.mapleader = " "
vim.g.maplocalleader = " "

require("config.lazy")

-- Basic Settings
-- number: shows absolute line numbers in the gutter
-- relativenumber: shows distance to other lines (e.g. "3" means 3 lines away), useful for jumping with 3j/3k
-- cursorline: highlights the entire line your cursor is on so you don't lose it
-- wrap: disabled so long lines don't wrap around — they stay on one line and you scroll horizontally
-- scrolloff: keeps 10 lines visible above/below your cursor so you're never editing at the edge of the screen
-- sidescrolloff: same but horizontally — 8 columns always visible left/right of cursor
vim.opt.number = true
vim.opt.relativenumber = true
vim.opt.cursorline = true      -- highlighting the line with cursor on it
vim.opt.wrap = false
vim.opt.scrolloff = 10
vim.opt.sidescrolloff = 8

-- Indentation
-- tabstop: how wide a tab character looks (2 spaces wide)
-- shiftwidth: how many spaces >> and << indent by
-- softtabstop: how many spaces the Tab key inserts/deletes in insert mode
-- expandtab: pressing Tab inserts spaces instead of a real tab character
-- smartindent: automatically indents new lines based on code structure (e.g. after { or if)
-- autoindent: new lines inherit the indentation of the line above
vim.opt.tabstop = 2
vim.opt.shiftwidth = 2
vim.opt.softtabstop = 2
vim.opt.expandtab = true
vim.opt.smartindent = true
vim.opt.autoindent = true

-- Searching
-- ignorecase: /foo matches "foo", "Foo", "FOO" — case doesn't matter by default
-- smartcase: if you type any uppercase letter (e.g. /Foo), case sensitivity turns back on automatically
-- hlsearch: disabled so search matches don't stay highlighted after you're done searching
-- incsearch: shows matches live as you type your search pattern
vim.opt.ignorecase = true      -- Ignoring case when searching
vim.opt.smartcase = true       -- Do not ignore case when upper case in search
vim.opt.hlsearch = false       -- Do not highlight the search terms within the editor
vim.opt.incsearch = true       -- Show matches as you type

-- Visual Settings
-- termguicolors: enables full 24-bit RGB colors — required for themes like moonfly to look correct
-- signcolumn: always reserves a column on the left for signs (LSP errors, git changes) so the text doesn't jump around
-- colorcolumn: draws a vertical line at column 100 as a reminder to keep lines from getting too long
-- showmatch + matchtime: when you type a closing bracket/paren, briefly jumps to show the matching opener (for 0.2s)
-- cmdheight: height of the command bar at the bottom (1 line is standard)
-- completeopt: controls autocomplete popup behavior — show menu even for one match, don't auto-insert, don't auto-select
-- showmode: disabled because the statusline already shows the current mode
-- pumheight: autocomplete popup shows at most 10 items at once
-- pumblend: autocomplete popup is 10% transparent
-- winblend: floating windows (like LSP hover) are fully opaque (0 = no transparency)
-- conceallevel: 0 means never hide markup characters (e.g. markdown asterisks stay visible)
-- concealcursor: no concealment on the cursor line either
-- lazyredraw: screen doesn't redraw while running macros, making them faster
-- synmaxcol: only syntax-highlight the first 300 columns — avoids slowdown on very long lines
vim.opt.termguicolors = true     -- Enable 24-bit colors
vim.opt.signcolumn = "yes"       -- Always show sign column
vim.opt.colorcolumn = "100"      -- Show column at 100 characters
vim.opt.showmatch = true         -- Highlight matching brackets
vim.opt.matchtime = 2            -- How long to show matching bracket
vim.opt.cmdheight = 1            -- Command line height
vim.opt.laststatus = 3           -- Global statusline (prevents per-split statuslines)
vim.opt.fillchars:append("horiz:─,horizup:─,horizdown:─,vert:│,vertleft:│,vertright:│")
vim.api.nvim_set_hl(0, "WinSeparator", { fg = "#444444", bg = "NONE" })
vim.opt.showtabline = 2          -- Always show tabline
vim.opt.completeopt = "menuone,noinsert,noselect" -- Completion options
vim.opt.showmode = false         -- Don't show mode in command line
vim.opt.pumheight = 10           -- Popup menu height
vim.opt.pumblend = 10            -- Popup menu transparency
vim.opt.winblend = 0             -- Floating window transparency
vim.opt.conceallevel = 0         -- Don't hide markup
vim.opt.concealcursor = ""       -- Don't hide cursor line markup
vim.opt.lazyredraw = true        -- Don't redraw during macros
vim.opt.synmaxcol = 300          -- Syntax highlighting limit

-- Undo/Backup Settings
-- backup + writebackup: both disabled — no need for backup files when using git
-- swapfile: disabled — swap files are used to recover crashes but clutter your filesystem; git handles this better
-- undofile: saves your undo history to disk, so even after closing and reopening a file you can still undo changes
-- undodir: where those undo history files are stored
-- updatetime: how long Neovim waits after you stop typing before writing the swap file / triggering CursorHold events
--             300ms makes LSP feel more responsive
-- timeoutlen: how long to wait for the next key in a multi-key mapping (e.g. <leader>bn) before giving up — 500ms
-- ttimeoutlen: how long to wait for a key code sequence (e.g. escape sequences from terminal) — 0 means instant
-- autoread: if a file changes on disk while you have it open, automatically reload it
-- autowrite: disabled — files are only saved when you explicitly do so (:w)
vim.opt.backup = false           -- Don't create backup files
vim.opt.writebackup = false      -- Don't create backup before writing
vim.opt.swapfile = false         -- Don't create swap files
vim.opt.undofile = true          -- Persistent undo
vim.opt.undodir = vim.fn.expand("~/.vim/undodir") -- Undo directory
vim.opt.updatetime = 300         -- Faster completion
vim.opt.timeoutlen = 500         -- Key timeout duration
vim.opt.ttimeoutlen = 0          -- Key code timeout
vim.opt.autoread = true          -- Auto reload files changed outside vim
vim.opt.autowrite = false        -- Don't auto save

-- Behavior Settings
-- hidden: lets you switch away from a buffer with unsaved changes without being forced to save or discard first
-- errorbells: disabled — no beep/flash on errors
-- backspace: makes backspace work intuitively in insert mode (can delete indentation, line breaks, and text before insert started)
-- autochdir: disabled — Neovim's working directory stays fixed rather than following whichever file you open
-- iskeyword "-": treats hyphen as part of a word, so dw on "my-variable" deletes the whole thing, not just "my"
-- path "**": when using :find, searches recursively through all subdirectories
-- selection: "exclusive" means the character under the cursor at the end of a selection is not included — standard behavior
-- mouse: "a" enables mouse support in all modes (click to move cursor, scroll, resize splits)
-- clipboard: uses the system clipboard, so yanking in Neovim copies to your Mac clipboard and vice versa
-- modifiable: buffers can be edited (this is the default, but explicit)
-- encoding: file encoding set to UTF-8
vim.opt.hidden = true            -- Allow hidden buffers
vim.opt.errorbells = false       -- No error bells
vim.opt.backspace = "indent,eol,start" -- Better backspace behavior
vim.opt.autochdir = false        -- Don't auto change directory
vim.opt.iskeyword:append("-")    -- Treat dash as part of word
vim.opt.path:append("**")        -- Include subdirectories in searc
vim.opt.selection = "exclusive"  -- Selection behavior
vim.opt.mouse = "a"              -- Enable mouse support
vim.opt.clipboard:append("unnamedplus") -- Use system clipboard
vim.opt.modifiable = true        -- Allow buffer modifications
vim.opt.encoding = "UTF-8"       -- Set encoding

-- Cursor Settings
-- InsertCursor: defines a white highlight group used to color the cursor in insert mode
-- guicursor: sets cursor shape per mode —
--   normal/visual/command: solid block
--   insert: vertical bar (ver20 = 20% wide), white, blinking (100ms before blink starts, 200ms on, 200ms off)
--   replace: horizontal underline (hor20 = 20% tall)
vim.api.nvim_set_hl(0, "InsertCursor", { bg = "#FFFFFF" }) -- Must be after colorscheme
vim.opt.guicursor = "n-v-c:block,i-ci-ve:ver20-InsertCursor-blinkwait100-blinkon200-blinkoff200,r-cr:hor20"

-- Neovide Settings (only applied when running inside Neovide GUI, ignored in terminal Neovim)
-- scroll_animation_length: how long the smooth scroll animation takes (0.15s — short and snappy)
-- scroll_animation_far_lines: keeps animation consistent even when scrolling large distances
-- cursor_vfx_mode: particle trail behind the cursor ("railgun" = fast streaking particles)
-- cursor_animation_length: how long the cursor glide animation takes when moving (0.10s)
-- cursor_animate_in_insert_mode: disabled — cursor doesn't animate while you're actively typing, only when moving
-- input_macos_option_key_is_meta: makes the Option key act as Alt for key mappings like <A-j>/<A-k>
if vim.g.neovide then
  vim.o.guifont = "JetBrainsMono Nerd Font Mono:h14"
  vim.g.neovide_scroll_animation_length = 0.15   -- Short smooth scroll, no lingering friction
  vim.g.neovide_scroll_animation_far_lines = 1   -- Consistent animation on fast scroll
  vim.g.neovide_cursor_vfx_mode = "railgun"            -- Cursor particle effect
  vim.g.neovide_cursor_animation_length = .10           -- Smooth cursor movement
  vim.g.neovide_cursor_animate_in_insert_mode = false     -- No animation while typing
  vim.g.neovide_input_macos_option_key_is_meta = "both"  -- Option key acts as Alt/Meta
end

-- Keybindings
-- Leader key is Space. A "leader" mapping means you press Space first, then the rest of the keys.
-- e.g. <leader>bn = Space + b + n

-- Y: by default, Y does the same as yy (yank whole line). This remaps it to y$ so it yanks
--    from the cursor to end of line — consistent with how D and C work.
vim.keymap.set("n", "Y", "y$", { desc = "Yank to end of line" })

-- Center screen when jumping
-- After jumping to a search result or scrolling, the cursor can end up near the top or bottom
-- of the screen. zz re-centers the view on your cursor. zv opens folds if needed.
-- n/N: next/prev search match, then center. <C-d>/<C-u>: half-page scroll, then center.
vim.keymap.set("n", "n", "nzzzv",   { desc = "Next search result (centered)" })
vim.keymap.set("n", "N", "Nzzzv",   { desc = "Previous search result (centered)" })
vim.keymap.set("n", "<C-d>", "<C-d>zz", { desc = "Half page down (centered)" })
vim.keymap.set("n", "<C-u>", "<C-u>zz", { desc = "Half page up (centered)" })

-- Buffer navigation
-- Buffers are open files in memory. You can have many files open at once and switch between them.
-- bn = buffer next, bp = buffer previous. Like browser tab switching but for files.
vim.keymap.set("n", "<leader>bn", ":bnext<CR>",     { desc = "Next buffer" })
vim.keymap.set("n", "<leader>bp", ":bprevious<CR>", { desc = "Previous buffer" })

-- Splitting & Resizing
-- Splits let you view multiple files (or different parts of the same file) side by side.
-- sv = split vertical (two windows side by side), sh = split horizontal (stacked top/bottom).
-- Arrow keys with Ctrl resize the focused split by 2 lines/columns at a time.
vim.keymap.set("n", "<leader>sv", ":vsplit<CR>",            { desc = "Split window vertically" })
vim.keymap.set("n", "<leader>sh", ":split<CR>",             { desc = "Split window horizontally" })
vim.keymap.set("n", "<C-Up>",    ":resize +2<CR>",          { desc = "Increase window height" })
vim.keymap.set("n", "<C-Down>",  ":resize -2<CR>",          { desc = "Decrease window height" })
vim.keymap.set("n", "<C-Left>",  ":vertical resize -2<CR>", { desc = "Decrease window width" })
vim.keymap.set("n", "<C-Right>", ":vertical resize +2<CR>", { desc = "Increase window width" })

-- Option key text editing (macOS muscle memory)
vim.keymap.set("i", "<M-BS>",    "<C-w>",          { desc = "Delete previous word" })
vim.keymap.set("i", "<M-Del>",   "<C-o>dw",        { desc = "Delete next word" })
vim.keymap.set("i", "<M-Left>",  "<C-o>b",         { desc = "Jump to previous word" })
vim.keymap.set("i", "<M-Right>", "<C-o>w",         { desc = "Jump to next word" })
vim.keymap.set("n", "<M-Left>",  "b",              { desc = "Jump to previous word" })
vim.keymap.set("n", "<M-Right>", "w",              { desc = "Jump to next word" })

-- Command key line/file navigation (macOS muscle memory)
vim.keymap.set("n", "<D-Left>",  "^",               { desc = "Beginning of line" })
vim.keymap.set("n", "<D-Right>", "$",               { desc = "End of line" })
vim.keymap.set("n", "<D-Up>",    "gg",              { desc = "Beginning of file" })
vim.keymap.set("n", "<D-Down>",  "G",               { desc = "End of file" })
vim.keymap.set("i", "<D-Left>",  "<C-o>^",          { desc = "Beginning of line" })
vim.keymap.set("i", "<D-Right>", "<C-o>$",          { desc = "End of line" })
vim.keymap.set("i", "<D-Up>",    "<C-o>gg",         { desc = "Beginning of file" })
vim.keymap.set("i", "<D-Down>",  "<C-o>G",          { desc = "End of file" })
vim.keymap.set("i", "<D-x>",     "<C-o>dd",         { desc = "Delete line" })
vim.keymap.set("n", "<D-s>", ":w<CR>", { desc = "Save file" })
vim.keymap.set("i", "<D-s>", function() vim.cmd("w") end, { desc = "Save file" })
vim.keymap.set("n", "<D-/>", "gcc", { remap = true, desc = "Toggle comment" })
vim.keymap.set("i", "<D-/>", "<C-o>gcc", { remap = true, desc = "Toggle comment" })
vim.keymap.set("v", "<D-/>", "gc", { remap = true, desc = "Toggle comment" })

-- Move lines up/down
-- Option+j/k physically moves the current line (or selected lines in visual mode) up or down.
-- The == after normal mode movement re-indents the line to match its new context.
-- gv=gv in visual mode re-selects the moved block and re-indents it.
vim.keymap.set("n", "<A-j>", ":m .+1<CR>==",        { desc = "Move line down" })
vim.keymap.set("n", "<A-k>", ":m .-2<CR>==",        { desc = "Move line up" })
vim.keymap.set("v", "<A-j>", ":m '>+1<CR>gv=gv",   { desc = "Move selection down" })
vim.keymap.set("v", "<A-k>", ":m '<-2<CR>gv=gv",   { desc = "Move selection up" })

-- Better indenting in visual mode
-- By default, > and < indent/unindent but drop the selection so you have to reselect to do it again.
-- gv reselects the previous visual selection, so you can keep pressing > or < to indent multiple levels.
vim.keymap.set("v", "<", "<gv", { desc = "Indent left and reselect" })
vim.keymap.set("v", ">", ">gv", { desc = "Indent right and reselect" })

-- Quick file navigation
-- <leader>e and <leader>ff are handled by nvim-tree and telescope respectively (see plugins.lua)

-- Path utilities — all copy to the system clipboard and print in the command bar
-- pa: directory containing the current file (e.g. /Users/you/project/src)
-- pf: absolute full path (e.g. /Users/you/project/src/main.lua)
-- pr: path relative to Neovim's working directory (e.g. src/main.lua)
vim.keymap.set("n", "<leader>pa", function()
    local path = vim.fn.expand("%:p:h")
    vim.fn.setreg("+", path)
    print("dir:", path)
end, { desc = "Copy file directory" })

-- Quick config editing — jump straight to init.lua from anywhere
vim.keymap.set("n", "<leader>rc", ":e ~/.config/nvim/init.lua<CR>", { desc = "Edit config" })

vim.keymap.set("n", "<leader>pf", function()
  local path = vim.fn.expand("%:p")
  vim.fn.setreg("+", path)
  print("full path:", path)
end, { desc = "Copy full file path" })

vim.keymap.set("n", "<leader>pr", function()
  local path = vim.fn.expand("%")
  vim.fn.setreg("+", path)
  print("relative path:", path)
end, { desc = "Copy relative file path" })

-- Rename current file
-- Prompts for a new name, saves the file under that name, then deletes the old file.
-- Uses the current filename as the default so you can just edit it rather than retype.
vim.keymap.set("n", "<leader>rr", function()
  local old = vim.fn.expand("%")
  local new = vim.fn.input("New file name: ", old)
  if new ~= "" and new ~= old then
    vim.cmd("saveas " .. new)
    vim.fn.delete(old)
    print("Renamed to: " .. new)
  end
end, { desc = "Rename current file" })

-- Tabs
-- Tabs in Neovim are window layouts — each tab can have its own split arrangement.
-- gt / gT (built-in) switch between tabs. tn = new tab, tx = close current tab.
vim.keymap.set("n", "<leader>tn", ":tabnew<CR>",   { desc = "New tab" })
vim.keymap.set("n", "<leader>tx", ":tabclose<CR>", { desc = "Close tab" })

-- Autocmd group
-- An augroup is a named container for autocmds. Using { clear = true } means if this file is
-- re-sourced, the old autocmds are wiped first so they don't pile up and fire multiple times.
local augroup = vim.api.nvim_create_augroup("UserConfig", { clear = true })

vim.api.nvim_create_autocmd("FileType", {
  group = augroup,
  pattern = "markdown",
  callback = function()
    vim.opt_local.colorcolumn = ""
  end,
})

-- Highlight yanked text
-- After you yank (copy) text, briefly flashes a highlight over what was yanked so you can
-- see exactly what got copied. The flash duration is controlled by vim.opt.updatetime (300ms).
vim.api.nvim_create_autocmd("TextYankPost", {
  group = augroup,
  callback = function()
    vim.highlight.on_yank()
  end,
})

-- Return to last edit position when opening files
-- Neovim remembers where your cursor was when you last closed a file (stored in the shada file).
-- This autocmd reads that saved position and jumps back to it when you reopen the file.
-- Skips git commit/rebase buffers and diff mode where jumping would be confusing.
vim.api.nvim_create_autocmd("BufReadPost", {
  group = augroup,
  callback = function()
    local mark = vim.api.nvim_buf_get_mark(0, '"')
    local lcount = vim.api.nvim_buf_line_count(0)
    local line = mark[1]
    local ft = vim.bo.filetype
    if line > 0 and line <= lcount
      and vim.fn.index({ "commit", "gitrebase", "xxd" }, ft) == -1
      and not vim.o.diff then
      pcall(vim.api.nvim_win_set_cursor, 0, mark)
    end
  end,
})

-- Auto-resize splits when Neovide window is resized
-- When you drag the Neovide window to a new size, all open splits are re-equalized so they
-- stay proportional rather than one becoming huge and another tiny.
vim.api.nvim_create_autocmd("VimResized", {
  group = augroup,
  callback = function() vim.cmd("tabdo wincmd =") end,
})

-- ============================================================================
-- LSP
-- ============================================================================
-- LSP (Language Server Protocol) is how Neovim talks to language-specific tools
-- (e.g. a TypeScript server, a Lua language server) to get features like:
--   go to definition, hover docs, rename symbol, find references, code actions, formatting.
-- This setup_lsp() function configures how diagnostics (errors/warnings) are displayed
-- and sets up keybindings that only activate when a language server actually attaches to a buffer.
-- Language servers themselves are installed separately (e.g. via mason.nvim).

local function setup_lsp()
  -- signs: icons shown in the gutter (left column) next to lines that have errors/warnings/hints
  local signs = {
    Error = "\u{f06a} ", Warn = "\u{f071} ", Hint = "\u{f0eb} ", Info = "\u{f05a} "
  }
  for type, icon in pairs(signs) do
    local hl = "DiagnosticSign" .. type
    vim.fn.sign_define(hl, { text = icon, texthl = hl, numhl = hl })
  end

  -- diagnostic.config: controls how errors/warnings are shown
  --   virtual_text: inline text shown to the right of the line with the issue (● prefix, 4 spaces indent)
  --   signs: show icons in the gutter column
  --   underline: squiggle under the problematic code
  --   update_in_insert: false means diagnostics don't update while you're typing (less distraction)
  --   severity_sort: errors show above warnings in lists
  --   float: the popup that appears when you press <leader>dl — rounded border, always shows the source
  vim.diagnostic.config({
    virtual_text = { prefix = "●", spacing = 4 },
    signs = true,
    underline = true,
    update_in_insert = false,
    severity_sort = true,
    float = { border = "rounded", source = "always", header = "", prefix = "" },
  })

  -- LspAttach: these keybindings are only set when a language server connects to the current buffer.
  -- They won't exist in buffers with no LSP (e.g. plain text files).
  --   gd: jump to where a function/variable is defined
  --   gD: jump to where it's declared (different from definition in some languages like C)
  --   K: show hover documentation popup for whatever's under the cursor
  --   gi: go to implementation (e.g. the concrete class that implements an interface)
  --   <leader>D: go to the type definition of a variable
  --   <leader>rn: rename symbol everywhere it's used across the codebase
  --   <leader>ca: show code actions (quick fixes, import suggestions, etc.)
  --   gr: show all references to the symbol under the cursor
  --   <leader>f: format the entire file using the language server's formatter
  vim.api.nvim_create_autocmd("LspAttach", {
    group = augroup,
    callback = function(ev)
      local opts = { buffer = ev.buf }
      vim.keymap.set("n", "gD", vim.lsp.buf.declaration, opts)
      vim.keymap.set("n", "gd", vim.lsp.buf.definition, opts)
      vim.keymap.set("n", "K",  vim.lsp.buf.hover, opts)
      vim.keymap.set("n", "gi", vim.lsp.buf.implementation, opts)
      vim.keymap.set("n", "<leader>D",  vim.lsp.buf.type_definition, opts)
      vim.keymap.set("n", "<leader>rn", vim.lsp.buf.rename, opts)
      vim.keymap.set("n", "<leader>ca", vim.lsp.buf.code_action, opts)
      vim.keymap.set("n", "gr", vim.lsp.buf.references, opts)
      vim.keymap.set("n", "<leader>f", function()
        vim.lsp.buf.format { async = true }
      end, opts)
    end,
  })

  -- Patches all LSP floating windows (hover docs, signature help) to use rounded borders
  local orig = vim.lsp.util.open_floating_preview
  function vim.lsp.util.open_floating_preview(contents, syntax, opts, ...)
    opts = opts or {}
    opts.border = opts.border or "rounded"
    return orig(contents, syntax, opts, ...)
  end
end

-- Diagnostic navigation — available in all buffers, not just ones with LSP
-- pd/nd: jump to the previous/next diagnostic (error or warning) in the file
-- <leader>q: dump all diagnostics into the location list (a scrollable panel)
-- <leader>dl: open a floating popup showing the full diagnostic message for the current line
vim.keymap.set("n", "pd", vim.diagnostic.goto_prev, { desc = "Previous diagnostic" })
vim.keymap.set("n", "nd", vim.diagnostic.goto_next, { desc = "Next diagnostic" })
vim.keymap.set("n", "<leader>q",  vim.diagnostic.setloclist,  { desc = "Open diagnostic list" })
vim.keymap.set("n", "<leader>dl", vim.diagnostic.open_float,  { desc = "Show line diagnostics" })

setup_lsp()
