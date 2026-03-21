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
