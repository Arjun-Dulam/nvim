return {
  -- which-key.nvim: displays available keybindings in a popup
  {
    "folke/which-key.nvim",
    event = "VeryLazy",
    config = function()
      require("which-key").setup({
        preset = "modern",
        sort = { "manual" },
        spec = {
          { "g", group = "Go to / LSP" },
          { "<leader>e", desc = "Toggle file explorer sidebar" },
          { "<leader>f", group = "Find and Search" },
          { "<leader>b", group = "Buffer Navigation" },
          { "<leader>s", group = "Window Layouts" },
          { "<leader>t", group = "Tabs, Terminal, and Typst" },
          { "<leader>p", group = "Copy File Paths" },
          { "<leader>r", group = "Rename Files and Edit Config" },
          { "<leader>c", group = "Code Actions" },
          { "<leader>l", group = "Language Server Actions" },
          { "<leader>g", group = "Git Change Actions" },
          { "<leader>d", group = "Diagnostics" },
          { "<leader>m", group = "Markdown Preview" },
          { "<leader>q", group = "Session Management" },
        },
        win = {
          border = "rounded",
          padding = { 1, 2 },
        },
        layout = {
          spacing = 3,
          width = { min = 24 },
        },
        icons = {
          mappings = false,
        },
      })
    end,
  },

  -- snacks.nvim: notifier, input UI, and terminal management
  {
    "folke/snacks.nvim",
    priority = 1000,
    lazy = false,
    opts = function()
      local function session_dir()
        return vim.fn.stdpath("state") .. "/sessions"
      end

      local function session_file_to_dir(path)
        local name = vim.fn.fnamemodify(path, ":t:r")
        if name == "" or name == ".vim" then
          return vim.fn.expand("~")
        end

        -- persistence.nvim appends git branches as "%%branch" to the
        -- encoded cwd. Strip that suffix before decoding the path.
        local dir_name = name:match("^(.*)%%%%[^%%]+$") or name
        local decoded = dir_name:gsub("%%", "/")
        decoded = decoded:gsub("/+", "/")
        return decoded
      end

      local function session_project(dir)
        local git_dir = vim.fs.find(".git", { path = dir, upward = true, type = "directory" })[1]
        local root = git_dir and vim.fn.fnamemodify(git_dir, ":h") or dir
        return {
          root = root,
          name = vim.fn.fnamemodify(root, ":t"),
          path = vim.fn.fnamemodify(dir, ":~"),
        }
      end

      local function session_items()
        local dir = session_dir()
        if vim.fn.isdirectory(dir) == 0 then
          return {}
        end

        local files = vim.fn.globpath(dir, "*.vim", false, true)
        table.sort(files, function(a, b)
          return (vim.fn.getftime(a) or 0) > (vim.fn.getftime(b) or 0)
        end)

        local items = {}
        local seen = {}
        for _, file in ipairs(files) do
          local target = session_file_to_dir(file)
          if vim.fn.isdirectory(target) == 1 and not seen[target] then
            seen[target] = true
            local project = session_project(target)
            items[#items + 1] = {
              text = string.format("%s  %s", project.name, project.path),
              title = project.name,
              path = project.path,
              file = file,
              session_dir = target,
            }
          end
        end
        return items
      end

      local function current_dir_section()
        local cwd = vim.fn.getcwd()
        local project = session_project(cwd)

        return {
          {
            pane = 1,
            padding = 1,
            icon = " ",
            title = project.name,
            indent = 2,
          },
          {
            pane = 1,
            desc = project.path,
            indent = 4,
            padding = 1,
          },
        }
      end

      local function manage_sessions(cursor)
        local items = session_items()
        local requested_cursor = type(cursor) == "number" and cursor or 1
        local target_cursor = #items > 0 and math.max(1, math.min(requested_cursor, #items)) or 1

        Snacks.picker({
          title = "Saved Sessions",
          items = items,
          format = "text",
          preview = "none",
          focus = "list",
          on_close = function()
            vim.schedule(function()
              pcall(Snacks.dashboard.update)
            end)
          end,
          on_show = function(picker)
            if #items > 0 then
              picker.list:view(target_cursor, target_cursor)
            end
          end,
          confirm = function(picker, item)
            if not item then
              return
            end

            picker:close()
            vim.cmd("cd " .. vim.fn.fnameescape(item.session_dir))
            require("persistence").load()
          end,
          actions = {
            delete_session = function(picker, item)
              item = item or picker:current()
              if not item then
                return
              end

              local next_cursor = type(picker.list.cursor) == "number" and picker.list.cursor or target_cursor

              vim.fn.delete(item.file)
              vim.notify(item.text, vim.log.levels.INFO, { title = "Deleted session" })
              picker:close()
              vim.schedule(function()
                manage_sessions(next_cursor)
              end)
            end,
          },
          win = {
            input = {
              keys = {
                ["<Del>"] = { "delete_session", mode = { "n", "i" }, desc = "Delete Session" },
                ["<C-d>"] = { "delete_session", mode = { "n", "i" }, desc = "Delete Session" },
              },
            },
            list = {
              keys = {
                ["d"] = "delete_session",
                ["x"] = "delete_session",
                ["<Del>"] = "delete_session",
              },
            },
          },
        })
      end

      return {
        dashboard = {
          enabled = true,
          preset = {
            keys = {
              { icon = " ", key = "f", desc = "Find File", action = "<leader>ff" },
              { icon = " ", key = "r", desc = "Recent Files", action = ":lua Snacks.dashboard.pick('oldfiles')" },
              { icon = " ", key = "s", desc = "Manage Sessions", action = manage_sessions },
              { icon = " ", key = "t", desc = "Terminal", action = "<leader>tt" },
              { icon = " ", key = "q", desc = "Quit", action = ":qa" },
            },
          },
          sections = {
            { section = "header" },
            current_dir_section,
            { section = "keys", gap = 1, padding = 1 },
            function()
              local items = session_items()
              local dashboard_items = {
                {
                  pane = 2,
                  icon = " ",
                  title = "Saved Sessions",
                  padding = 1,
                },
              }

              for _, item in ipairs(items) do
                dashboard_items[#dashboard_items + 1] = {
                  pane = 2,
                  icon = " ",
                  desc = item.path,
                  indent = 2,
                  action = function()
                    vim.cmd("cd " .. vim.fn.fnameescape(item.session_dir))
                    require("persistence").load()
                  end,
                }
              end

              return dashboard_items
            end,
            { section = "startup" },
          },
        },
        input = { enabled = true },
        notifier = {
          enabled = true,
          timeout = 3000,
          style = "compact",
        },
        picker = { enabled = true },
        terminal = { enabled = true },
      }
    end,
    keys = {
      {
        "<leader>qm",
        function()
          local function session_file_to_dir(path)
            local name = vim.fn.fnamemodify(path, ":t:r")
            if name == "" or name == ".vim" then
              return vim.fn.expand("~")
            end
            local dir_name = name:match("^(.*)%%%%[^%%]+$") or name
            return dir_name:gsub("%%", "/"):gsub("/+", "/")
          end

          local function session_project(dir)
            local git_dir = vim.fs.find(".git", { path = dir, upward = true, type = "directory" })[1]
            local root = git_dir and vim.fn.fnamemodify(git_dir, ":h") or dir
            return {
              name = vim.fn.fnamemodify(root, ":t"),
              path = vim.fn.fnamemodify(dir, ":~"),
            }
          end

          local function session_items()
            local dir = vim.fn.stdpath("state") .. "/sessions"
            if vim.fn.isdirectory(dir) == 0 then
              return {}
            end

            local files = vim.fn.globpath(dir, "*.vim", false, true)
            table.sort(files, function(a, b)
              return (vim.fn.getftime(a) or 0) > (vim.fn.getftime(b) or 0)
            end)

            local items = {}
            local seen = {}
            for _, file in ipairs(files) do
              local target = session_file_to_dir(file)
              if vim.fn.isdirectory(target) == 1 and not seen[target] then
                seen[target] = true
                local project = session_project(target)
                items[#items + 1] = {
                  text = string.format("%s  %s", project.name, project.path),
                  file = file,
                  session_dir = target,
                }
              end
            end
            return items
          end

          local function open_manager(cursor)
            local items = session_items()
            local requested_cursor = type(cursor) == "number" and cursor or 1
            local target_cursor = #items > 0 and math.max(1, math.min(requested_cursor, #items)) or 1

            Snacks.picker({
              title = "Saved Sessions",
              items = items,
              format = "text",
              preview = "none",
              focus = "list",
              on_close = function()
                vim.schedule(function()
                  pcall(Snacks.dashboard.update)
                end)
              end,
              on_show = function(picker)
                if #items > 0 then
                  picker.list:view(target_cursor, target_cursor)
                end
              end,
              confirm = function(picker, item)
                if not item then
                  return
                end
                picker:close()
                vim.cmd("cd " .. vim.fn.fnameescape(item.session_dir))
                require("persistence").load()
              end,
              actions = {
                delete_session = function(picker, item)
                  item = item or picker:current()
                  if not item then
                    return
                  end

                  local next_cursor = type(picker.list.cursor) == "number" and picker.list.cursor or target_cursor
                  vim.fn.delete(item.file)
                  vim.notify(item.text, vim.log.levels.INFO, { title = "Deleted session" })
                  picker:close()
                  vim.schedule(function()
                    open_manager(next_cursor)
                  end)
                end,
              },
              win = {
                input = {
                  keys = {
                    ["<Del>"] = { "delete_session", mode = { "n", "i" }, desc = "Delete Session" },
                    ["<C-d>"] = { "delete_session", mode = { "n", "i" }, desc = "Delete Session" },
                  },
                },
                list = {
                  keys = {
                    ["d"] = "delete_session",
                    ["x"] = "delete_session",
                    ["<Del>"] = "delete_session",
                  },
                },
              },
            })
          end

          open_manager()
        end,
        desc = "Manage saved sessions",
      },
      {
        "<leader>tt",
        function()
          Snacks.terminal.toggle(nil, {
            cwd = vim.fn.getcwd(),
            win = {
              position = "right",
              width = 0.4,
            },
          })
        end,
        desc = "Toggle terminal in vertical split",
      },
      {
        "<leader>tf",
        function()
          Snacks.terminal.toggle(vim.o.shell, { cwd = vim.fn.getcwd() })
        end,
        desc = "Toggle floating terminal",
      },
    },
  },

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
        ensure_installed = { "clangd", "protols", "tinymist" },
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
      vim.lsp.config("tinymist", {
        capabilities = capabilities,
        settings = {
          formatterMode = "typstyle",
          exportPdf = "onType",
          semanticTokens = "disable",
        },
      })
      vim.lsp.enable("clangd")
      vim.lsp.enable("protols")
      vim.lsp.enable("tinymist")
    end,
  },

  -- Typst live preview via tinymist
  {
    "chomosuke/typst-preview.nvim",
    ft = "typst",
    version = "1.*",
    opts = {
      dependencies_bin = {
        tinymist = "tinymist",
      },
    },
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
      { "<leader>e", ":NvimTreeToggle<CR>", desc = "Toggle file explorer sidebar" },
    },
  },

  -- Snacks picker keymaps (replaces Telescope)
  {
    "folke/snacks.nvim",
    keys = {
      { "<leader>ff", function() Snacks.picker.files() end,   desc = "Find files in project" },
      { "<leader>fg", function() Snacks.picker.grep() end,    desc = "Search text across project" },
      { "<leader>fb", function() Snacks.picker.buffers() end, desc = "Find among open buffers" },
      { "<leader>fh", function() Snacks.picker.help() end,    desc = "Search Neovim help" },
      { "<leader>fi", function() Snacks.picker.lines() end,   desc = "Search text in current buffer" },
    },
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
      { "<leader>gb", ":Gitsigns blame_line<CR>", desc = "Show blame for current line" },
      { "<leader>gd", ":Gitsigns diffthis<CR>", desc = "Diff current buffer" },
      { "<leader>gh", ":Gitsigns preview_hunk<CR>", desc = "Preview current git hunk" },
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
      { "<leader>fa", "<cmd>Format<CR>", desc = "Format current buffer with Conform" },
    },
  },

  -- lualine: statusline plugin
  {
    "nvim-lualine/lualine.nvim",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    config = function()
      local function project_name()
        return " " .. vim.fn.fnamemodify(vim.fn.getcwd(), ":t")
      end

      local function datetime()
        return " " .. os.date("%a %H:%M:%S")
      end

      -- Battery is cached and refreshed every 60s to avoid spawning a
      -- subprocess on every buffer switch.
      local cached_battery = ""
      local function refresh_battery()
        local raw = vim.fn.system("pmset -g batt 2>/dev/null")
        local pct_str = raw:match("(%d+)%%")
        if not pct_str then
          cached_battery = ""
          return
        end
        local n = tonumber(pct_str) or 0
        local icon = n > 80 and "" or n > 50 and "" or n > 20 and "" or ""
        cached_battery = icon .. " " .. pct_str .. "%%"
      end
      refresh_battery()
      local battery_timer = vim.uv.new_timer()
      battery_timer:start(60000, 60000, vim.schedule_wrap(refresh_battery))

      local function battery()
        return cached_battery
      end

      local mode_hl = {
        n  = "lualine_a_normal",
        i  = "lualine_a_insert",
        v  = "lualine_a_visual",
        V  = "lualine_a_visual",
        ["\22"] = "lualine_a_visual",
        c  = "lualine_a_command",
        R  = "lualine_a_replace",
        r  = "lualine_a_replace",
        t  = "lualine_a_terminal",
      }
      local function active_tab_color()
        return mode_hl[vim.fn.mode()] or "lualine_a_normal"
      end

      vim.api.nvim_create_autocmd("ModeChanged", {
        callback = function()
          require("lualine").refresh({ place = { "tabline" } })
        end,
      })

      require("lualine").setup({
        options = {
          icons_enabled = true,
          theme = "auto",
          component_separators = { left = "", right = "" },
          section_separators = { left = "", right = "" },
          refresh = { statusline = 1000, tabline = 1000, winbar = 1000 },
        },
        -- global statusline: project name | datetime + battery
        sections = {
          lualine_a = { project_name },
          lualine_b = {},
          lualine_c = {},
          lualine_x = {},
          lualine_y = {},
          lualine_z = { battery, datetime },
        },
        inactive_sections = {},
        -- tabline: vim tabs with optional custom names (set via <leader>tr)
        tabline = {
          lualine_a = {
            {
              "tabs",
              mode = 1,
              max_length = vim.o.columns,
              tabs_color = {
                active = active_tab_color,
                inactive = "lualine_b_normal",
              },
              section_separators = { left = "", right = "" },
              component_separators = { left = "│", right = "│" },
              fmt = function(name, context)
                local ok, custom = pcall(vim.api.nvim_tabpage_get_var, context.tabId, "tab_name")
                if ok and custom ~= "" then name = custom end
                local tabnr = vim.api.nvim_tabpage_get_number(context.tabId)
                return tabnr .. ": " .. name
              end,
            },
          },
        },
        -- per-window bar: mode, git, filename, filetype, position
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
      vim.opt.showtabline = 2
      vim.api.nvim_set_hl(0, "StatusLine", { bg = "NONE", fg = "NONE" })
      vim.api.nvim_set_hl(0, "StatusLineNC", { bg = "NONE", fg = "NONE" })
    end,
  },

  -- nvim-lint: disabled — clangd LSP already provides real-time diagnostics
  -- { "mfussenegger/nvim-lint" },


  -- vimtex: LaTeX compilation, Zathura integration, and SyncTeX
  {
    "lervag/vimtex",
    ft = "tex",
    init = function()
      vim.g.vimtex_view_method = "skim"
      vim.g.vimtex_compiler_method = "latexmk"
    end,
  },

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
      { "<leader>mp", ":Markview toggle<CR>",      desc = "Toggle Markdown rendering" },
      { "<leader>ms", ":Markview splitToggle<CR>", desc = "Toggle Markdown split preview" },
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
      { "<leader>qr", function() require("persistence").load() end, desc = "Restore session for current directory" },
      { "<leader>qd", function() require("persistence").stop() end, desc = "Stop saving this session" },
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
