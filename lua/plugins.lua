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
        ensure_installed = { "clangd" },
      })
    end,
  },

  -- Lspconfig: language server configurations
  {
    "neovim/nvim-lspconfig",
    dependencies = { "williamboman/mason-lspconfig.nvim" },
    config = function()
      vim.lsp.config("clangd", {})
      vim.lsp.enable("clangd")
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
        },
        formatters = {
          ["clang-format"] = {
            args = { "--style=Google" },
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

  -- nvim-lint: linting
  {
    "mfussenegger/nvim-lint",
    event = "BufReadPost",
    config = function()
      local lint = require("lint")
      lint.linters_by_ft = {
        cpp = { "clang-tidy" },
        c = { "clang-tidy" },
      }
      vim.api.nvim_create_autocmd({ "BufWritePost" }, {
        callback = function()
          lint.try_lint()
        end,
      })
    end,
  },

  -- cmake-tools: CMake integration
  {
    "Civitasv/cmake-tools.nvim",
    dependencies = { "nvim-lua/plenary.nvim" },
    config = function()
      require("cmake-tools").setup()
    end,
    keys = {
      { "<leader>cb", ":CMakeBuild<CR>", desc = "CMake build" },
      { "<leader>cc", ":CMakeRun<CR>", desc = "CMake run" },
      { "<leader>cq", ":CMakeClose<CR>", desc = "CMake close" },
    },
  },
}
