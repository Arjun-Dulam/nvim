-- Leader keys (must be set before loading lazy.nvim)
vim.g.mapleader = " "
vim.g.maplocalleader = " "

require("config.lazy")

-- Basic Settings
vim.opt.number = true
vim.opt.relativenumber = true
vim.opt.cursorline = true      -- highlighting the line with cursor on it
vim.opt.wrap = false
vim.scrolloff = 10
vim.sidescrolloff = 8

-- Indentation
vim.opt.tabstop = 4
vim.opt.shiftwidth = 4
vim.opt.softtabstop = 4
vim.opt.expandtab = true
vim.opt.smartindent = true
vim.opt.autoindent = true

-- Searching
vim.opt.ignorecase = true      -- Ignoring case when searching
vim.opt.smartcase = true       -- Do not ignore case when upper case in search
vim.opt.hlsearch = false       -- Do not highlight the search terms within the editor
vim.opt.incsearch = true       -- Show matches as you type

-- Visual Settings
vim.opt.termguicolors = true     -- Enable 24-bit colors
vim.opt.signcolumn = "yes"       -- Always show sign column
vim.opt.colorcolumn = "100"      -- Show column at 100 characters
vim.opt.showmatch = true         -- Highlight matching brackets
vim.opt.matchtime = 2            -- How long to show matching bracket
vim.opt.cmdheight = 1            -- Command line height
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
vim.api.nvim_set_hl(0, "InsertCursor", { bg = "#FFFFFF" }) -- Must be after colorscheme
vim.opt.guicursor = "n-v-c:block,i-ci-ve:ver20-InsertCursor-blinkwait100-blinkon200-blinkoff200,r-cr:hor20"
-- Block in normal, blinking vertical in insert, underline in replace

-- Neovide Settings
if vim.g.neovide then
  vim.g.neovide_scroll_animation_length = 0.15   -- Short smooth scroll, no lingering friction
  vim.g.neovide_scroll_animation_far_lines = 1   -- Consistent animation on fast scroll
  vim.g.neovide_cursor_vfx_mode = "railgun"            -- Cursor particle effect
  vim.g.neovide_cursor_animation_length = .10           -- Smooth cursor movement
  vim.g.neovide_cursor_animate_in_insert_mode = false     -- No animation while typing
  vim.g.neovide_input_macos_option_key_is_meta = "both"  -- Option key acts as Alt/Meta
end

-- Keybindings
vim.keymap.set("n", "Y", "y$", { desc = "Yank to end of line" }) -- Set Y to copy till EOL 

-- Center screen when jumping
vim.keymap.set("n", "n", "nzzzv",   { desc = "Next search result (centered)" })
vim.keymap.set("n", "N", "Nzzzv",   { desc = "Previous search result (centered)" })
vim.keymap.set("n", "<C-d>", "<C-d>zz", { desc = "Half page down (centered)" })
vim.keymap.set("n", "<C-u>", "<C-u>zz", { desc = "Half page up (centered)" })

-- Buffer navigation
vim.keymap.set("n", "<leader>bn", ":bnext<CR>",     { desc = "Next buffer" })
vim.keymap.set("n", "<leader>bp", ":bprevious<CR>", { desc = "Previous buffer" })

-- Splitting & Resizing
vim.keymap.set("n", "<leader>sv", ":vsplit<CR>",            { desc = "Split window vertically" })
vim.keymap.set("n", "<leader>sh", ":split<CR>",             { desc = "Split window horizontally" })
vim.keymap.set("n", "<C-Up>",    ":resize +2<CR>",          { desc = "Increase window height" })
vim.keymap.set("n", "<C-Down>",  ":resize -2<CR>",          { desc = "Decrease window height" })
vim.keymap.set("n", "<C-Left>",  ":vertical resize -2<CR>", { desc = "Decrease window width" })
vim.keymap.set("n", "<C-Right>", ":vertical resize +2<CR>", { desc = "Increase window width" })

-- Move lines up/down
vim.keymap.set("n", "<A-j>", ":m .+1<CR>==",        { desc = "Move line down" })
vim.keymap.set("n", "<A-k>", ":m .-2<CR>==",        { desc = "Move line up" })
vim.keymap.set("v", "<A-j>", ":m '>+1<CR>gv=gv",   { desc = "Move selection down" })
vim.keymap.set("v", "<A-k>", ":m '<-2<CR>gv=gv",   { desc = "Move selection up" })

-- Better indenting in visual mode
vim.keymap.set("v", "<", "<gv", { desc = "Indent left and reselect" })
vim.keymap.set("v", ">", ">gv", { desc = "Indent right and reselect" })

-- Quick file navigation
vim.keymap.set("n", "<leader>e", ":Explore<CR>", { desc = "Open file explorer" })
vim.keymap.set("n", "<leader>ff", ":find", { desc = "Find file" })

-- Copy directory of current file
vim.keymap.set("n", "<leader>pa", function()
    local path = vim.fn.expand("%:p:h")
    vim.fn.setreg("+", path)
    print("dir:", path)
end, { desc = "Copy file directory" })

-- Quick config editing
vim.keymap.set("n", "<leader>rc", ":e ~/.config/nvim/init.lua<CR>", { desc = "Edit config" })

-- Copy full / relative file path
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
vim.keymap.set("n", "<leader>tn", ":tabnew<CR>",   { desc = "New tab" })
vim.keymap.set("n", "<leader>tx", ":tabclose<CR>", { desc = "Close tab" })

-- Autocmd group
local augroup = vim.api.nvim_create_augroup("UserConfig", { clear = true })

-- Highlight yanked text
vim.api.nvim_create_autocmd("TextYankPost", {
  group = augroup,
  callback = function()
    vim.highlight.on_yank()
  end,
})

-- Return to last edit position when opening files
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
vim.api.nvim_create_autocmd("VimResized", {
  group = augroup,
  callback = function() vim.cmd("tabdo wincmd =") end,
})

-- ============================================================================
-- STATUSLINE
-- ============================================================================

local cached_branch = ""
local last_check = 0
local function git_branch()
  local now = vim.loop.now()
  if now - last_check > 5000 then
    cached_branch = vim.fn.system("git branch --show-current 2>/dev/null | tr -d '\n'")
    last_check = now
  end
  if cached_branch ~= "" then
    return " \u{e725} " .. cached_branch .. " "
  end
  return ""
end

local function file_type()
  local ft = vim.bo.filetype
  local icons = {
    lua = "\u{e620} ", python = "\u{e73c} ", javascript = "\u{e74e} ",
    typescript = "\u{e628} ", javascriptreact = "\u{e7ba} ", typescriptreact = "\u{e7ba} ",
    html = "\u{e736} ", css = "\u{e749} ", scss = "\u{e749} ", json = "\u{e60b} ",
    markdown = "\u{e73e} ", vim = "\u{e62b} ", sh = "\u{f489} ", bash = "\u{f489} ",
    zsh = "\u{f489} ", rust = "\u{e7a8} ", go = "\u{e724} ", c = "\u{e61e} ",
    cpp = "\u{e61d} ", java = "\u{e738} ", php = "\u{e73d} ", ruby = "\u{e739} ",
    swift = "\u{e755} ", kotlin = "\u{e634} ", dart = "\u{e798} ", sql = "\u{e706} ",
    yaml = "\u{f481} ", toml = "\u{e615} ", dockerfile = "\u{f308} ",
  }
  if ft == "" then return " \u{f15b} " end
  return (icons[ft] or " \u{f15b} " .. ft)
end

local function file_size()
  local size = vim.fn.getfsize(vim.fn.expand("%"))
  if size < 0 then return "" end
  if size < 1024 then return " \u{f016} " .. size .. "B " end
  if size < 1024 * 1024 then return " \u{f016} " .. string.format("%.1fK", size / 1024) .. " " end
  return " \u{f016} " .. string.format("%.1fM", size / 1024 / 1024) .. " "
end

local function mode_icon()
  local mode = vim.fn.mode()
  local modes = {
    n = " \u{f040} NORMAL", i = " \u{f303} INSERT", v = " \u{f06e} VISUAL",
    V = " \u{f06e} V-LINE", ["\22"] = " \u{f06e} V-BLOCK", c = " \u{f120} COMMAND",
    R = " \u{f044} REPLACE", r = " \u{f044} REPLACE", t = " \u{f120} TERMINAL",
  }
  return modes[mode] or " \u{f059} " .. mode:upper()
end

_G.mode_icon  = mode_icon
_G.git_branch = git_branch
_G.file_type  = file_type
_G.file_size  = file_size

vim.api.nvim_set_hl(0, "StatusLineBold", { bold = true })

vim.api.nvim_create_autocmd({ "WinEnter", "BufEnter" }, {
  group = augroup,
  callback = function()
    vim.opt_local.statusline = table.concat {
      "  ", "%#StatusLineBold#", "%{v:lua.mode_icon()}", "%#StatusLine#",
      " \u{e0b1} %f %h%m%r", "%{v:lua.git_branch()}", "\u{e0b1} ",
      "%{v:lua.file_type()}", "\u{e0b1} ", "%{v:lua.file_size()}",
      "%=", " \u{f017} %l:%c  %P ",
    }
  end,
})

vim.api.nvim_create_autocmd({ "WinLeave", "BufLeave" }, {
  group = augroup,
  callback = function()
    vim.opt_local.statusline = "  %f %h%m%r \u{e0b1} %{v:lua.file_type()} %=  %l:%c   %P "
  end,
})

-- ============================================================================
-- LSP
-- ============================================================================

local function setup_lsp()
  local signs = {
    Error = "\u{f06a} ", Warn = "\u{f071} ", Hint = "\u{f0eb} ", Info = "\u{f05a} "
  }
  for type, icon in pairs(signs) do
    local hl = "DiagnosticSign" .. type
    vim.fn.sign_define(hl, { text = icon, texthl = hl, numhl = hl })
  end

  vim.diagnostic.config({
    virtual_text = { prefix = "●", spacing = 4 },
    signs = true,
    underline = true,
    update_in_insert = false,
    severity_sort = true,
    float = { border = "rounded", source = "always", header = "", prefix = "" },
  })

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

  local orig = vim.lsp.util.open_floating_preview
  function vim.lsp.util.open_floating_preview(contents, syntax, opts, ...)
    opts = opts or {}
    opts.border = opts.border or "rounded"
    return orig(contents, syntax, opts, ...)
  end
end

vim.keymap.set("n", "pd", vim.diagnostic.goto_prev, { desc = "Previous diagnostic" })
vim.keymap.set("n", "nd", vim.diagnostic.goto_next, { desc = "Next diagnostic" })
vim.keymap.set("n", "<leader>q",  vim.diagnostic.setloclist,  { desc = "Open diagnostic list" })
vim.keymap.set("n", "<leader>dl", vim.diagnostic.open_float,  { desc = "Show line diagnostics" })

setup_lsp()
