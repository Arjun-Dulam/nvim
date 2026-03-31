return {
  -- Mason: package manager for language servers, linters, formatters
  {
    "williamboman/mason.nvim",
    config = function()
      require("mason").setup()
    end,
  },

  -- Mason-lspconfig: bridge between mason and lspconfig
  {
    "williamboman/mason-lspconfig.nvim",
    dependencies = { "mason.nvim" },
    config = function()
      require("mason-lspconfig").setup({
        ensure_installed = { "clangd", "protols" },
      })
    end,
  },

  -- Lspconfig: language server configurations
  {
    "neovim/nvim-lspconfig",
    dependencies = { "williamboman/mason-lspconfig.nvim", "hrsh7th/cmp-nvim-lsp" },
    config = function()
      local capabilities = require("cmp_nvim_lsp").default_capabilities()
      vim.lsp.config("clangd", { capabilities = capabilities })
      vim.lsp.config("protols", { capabilities = capabilities })
      vim.lsp.enable("clangd")
      vim.lsp.enable("protols")
    end,
  },

  -- nvim-tree: file explorer sidebar
  {
    "nvim-tree/nvim-tree.lua",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    config = function()
      require("nvim-tree").setup({
        view = { width = 30 },
        renderer = { icons = { show = { file = true, folder = true } } },
      })
    end,
    keys = {
      { "<leader>e", ":NvimTreeToggle<CR>", desc = "Toggle file explorer" },
    },
  },

  -- Telescope: fuzzy finder
  {
    "nvim-telescope/telescope.nvim",
    dependencies = { "nvim-lua/plenary.nvim", "nvim-telescope/telescope-fzf-native.nvim" },
    config = function()
      local telescope = require("telescope")
      telescope.setup({
        defaults = { layout_strategy = "vertical" },
        extensions = { fzf = { fuzzy = true, override_generic_sorter = true, override_file_sorter = true } },
      })
      telescope.load_extension("fzf")
    end,
    keys = {
      { "<leader>ff", ":Telescope find_files<CR>", desc = "Find files" },
      { "<leader>fg", ":Telescope live_grep<CR>", desc = "Live grep" },
      { "<leader>fb", ":Telescope buffers<CR>", desc = "Find buffers" },
      { "<leader>fh", ":Telescope help_tags<CR>", desc = "Help tags" },
    },
  },

  -- telescope-fzf-native: native fzf sorter for telescope
  {
    "nvim-telescope/telescope-fzf-native.nvim",
    build = "cmake -S. -Bbuild -DCMAKE_BUILD_TYPE=Release && cmake --build build --config Release && cmake --install build --prefix build",
  },

  -- Gitsigns: git signs and commands
  {
    "lewis6991/gitsigns.nvim",
    event = "BufReadPre",
    config = function()
      require("gitsigns").setup({
        signs = {
          add = { text = "│" },
          change = { text = "│" },
          delete = { text = "_" },
          topdelete = { text = "‾" },
          changedelete = { text = "~" },
        },
      })
    end,
    keys = {
      { "<leader>gb", ":Gitsigns blame_line<CR>", desc = "Git blame" },
      { "<leader>gd", ":Gitsigns diffthis<CR>", desc = "Git diff" },
      { "<leader>gh", ":Gitsigns preview_hunk<CR>", desc = "Git preview hunk" },
    },
  },

  -- conform.nvim: code formatter with clang-format for C++
  {
    "stevearc/conform.nvim",
    event = "BufWritePre",
    config = function()
      require("conform").setup({
        formatters_by_ft = {
          cpp = { "clang-format" },
          c = { "clang-format" },
          proto = { "buf" },
          cmake = { "cmake_format" },
        },
        formatters = {
          ["clang-format"] = {
            args = { "--style={BasedOnStyle: Google, IndentWidth: 2}" },
          },
          ["buf"] = {
            command = "buf",
            args = function(self, ctx)
              return { "format", ctx.filename }
            end,
            stdin = false,
            cwd = function(self, ctx)
              return vim.fn.fnamemodify(ctx.filename, ":h")
            end,
          },
        },
        format_on_save = {
          timeout_ms = 500,
          lsp_fallback = true,
        },
      })
      vim.api.nvim_create_user_command("Format", function()
        require("conform").format({ async = true })
      end, {})
    end,
    keys = {
      { "<leader>fa", "<cmd>Format<CR>", desc = "Format buffer" },
    },
  },

  -- lualine: statusline plugin
  {
    "nvim-lualine/lualine.nvim",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    config = function()
      require("lualine").setup({
        options = {
          icons_enabled = true,
          theme = "auto",
          component_separators = { left = "", right = "" },
          section_separators = { left = "", right = "" },
        },
        sections = {},
        inactive_sections = {},
        winbar = {
          lualine_a = { "mode" },
          lualine_b = { "branch", "diff", "diagnostics" },
          lualine_c = { { "filename", path = 1 } },
          lualine_x = { "filetype" },
          lualine_y = { "progress" },
          lualine_z = { "location" },
        },
        inactive_winbar = {
          lualine_c = { { "filename", path = 1 } },
        },
      })
      vim.opt.laststatus = 3
      vim.api.nvim_set_hl(0, "StatusLine", { bg = "NONE", fg = "NONE" })
      vim.api.nvim_set_hl(0, "StatusLineNC", { bg = "NONE", fg = "NONE" })
      vim.opt.statusline = " "
    end,
  },

  -- nvim-lint: disabled — clangd LSP already provides real-time diagnostics
  -- { "mfussenegger/nvim-lint" },


  -- protobuf.vim: syntax highlighting and indent for protobuf/gRPC
  { "wfxr/protobuf.vim", ft = "proto" },

  -- nvim-treesitter: parser installation and queries (highlight is built-in to Neovim now)
  {
    "nvim-treesitter/nvim-treesitter",
    build = ":TSUpdate",
  },

  -- nvim-treesitter-textobjects: af/if/ac/ic textobjects for functions and classes
  {
    "nvim-treesitter/nvim-treesitter-textobjects",
    dependencies = { "nvim-treesitter/nvim-treesitter" },
    config = function()
      require("nvim-treesitter-textobjects").setup({ select = { lookahead = true } })
      local select = require("nvim-treesitter-textobjects.select")
      local keymaps = {
        ["af"] = "@function.outer",
        ["if"] = "@function.inner",
        ["ac"] = "@class.outer",
        ["ic"] = "@class.inner",
      }
      for key, query in pairs(keymaps) do
        vim.keymap.set({ "x", "o" }, key, function()
          select.select_textobject(query, "textobjects")
        end)
      end
    end,
  },

  -- markview.nvim: in-buffer markdown renderer with splitview support
  {
    "OXY2DEV/markview.nvim",
    ft = "markdown",
    config = function()
      require("markview").setup()
    end,
    keys = {
      { "<leader>mp", ":Markview toggle<CR>",      desc = "Toggle markdown preview" },
      { "<leader>ms", ":Markview splitToggle<CR>", desc = "Toggle markdown splitview" },
    },
  },

  -- persistence.nvim: auto-save and restore sessions per directory
  {
    "folke/persistence.nvim",
    event = "BufReadPre",
    config = function()
      require("persistence").setup()
    end,
    keys = {
      { "<leader>qs", function() require("persistence").load() end, desc = "Restore session" },
      { "<leader>ql", function() require("persistence").load({ last = true }) end, desc = "Restore last session" },
      { "<leader>qd", function() require("persistence").stop() end, desc = "Stop persistence" },
    },
  },

  -- nvim-autopairs: auto-close brackets and quotes
  {
    "windwp/nvim-autopairs",
    event = "InsertEnter",
    config = function()
      require("nvim-autopairs").setup()
    end,
  },

  -- LuaSnip: snippet engine
  {
    "L3MON4D3/LuaSnip",
    dependencies = { "rafamadriz/friendly-snippets" },
    config = function()
      require("luasnip.loaders.from_vscode").lazy_load()
    end,
  },

  -- nvim-cmp: completion engine
  {
    "hrsh7th/nvim-cmp",
    event = "InsertEnter",
    dependencies = {
      "hrsh7th/cmp-nvim-lsp",
      "hrsh7th/cmp-buffer",
      "hrsh7th/cmp-path",
      "saadparwaiz1/cmp_luasnip",   -- Snippet completions
      "hrsh7th/cmp-nvim-lsp-signature-help", -- Function signature while typing
    },
    config = function()
      local cmp = require("cmp")
      local luasnip = require("luasnip")
      cmp.setup({
        snippet = {
          expand = function(args)
            luasnip.lsp_expand(args.body)
          end,
        },
        sources = cmp.config.sources({
          { name = "nvim_lsp", priority = 100 },
          { name = "nvim_lsp_signature_help", priority = 90 },
          { name = "luasnip", priority = 80 },
          { name = "buffer", priority = 50 },
          { name = "path", priority = 40 },
        }),
        mapping = cmp.mapping.preset.insert({
          ["<C-b>"] = cmp.mapping.scroll_docs(-4),
          ["<C-f>"] = cmp.mapping.scroll_docs(4),
          ["<C-Space>"] = cmp.mapping.complete(),
          ["<C-e>"] = cmp.mapping.abort(),
          ["<CR>"] = cmp.mapping.confirm({ select = true }),
          ["<Tab>"] = cmp.mapping(function(fallback)
            if cmp.visible() then
              cmp.select_next_item()
            elseif luasnip.expand_or_jumpable() then
              luasnip.expand_or_jump()
            else
              fallback()
            end
          end, { "i", "s" }),
          ["<S-Tab>"] = cmp.mapping(function(fallback)
            if cmp.visible() then
              cmp.select_prev_item()
            elseif luasnip.jumpable(-1) then
              luasnip.jump(-1)
            else
              fallback()
            end
          end, { "i", "s" }),
        }),
      })
    end,
  },
}
