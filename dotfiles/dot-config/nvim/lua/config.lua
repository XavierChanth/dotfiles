-- Plugin configuration
local config = {
  -- LIBS
  -- nothing for plenary or nui to add
  {
    "williamboman/mason.nvim",
    cmd = "Mason",
    opts = {
      registries = {
        "github:xavierchanth/mason-registry",
        "github:mason-org/mason-registry",
      },
    },
  },
  -- ESSENTIAL
  {
    "stevearc/oil.nvim",
    init = function()
      vim.api.nvim_create_autocmd("User", {
        pattern = "OilActionsPost",
        callback = function(event)
          if event.data.actions.type == "move" then
            require("snacks.rename").on_rename_file(
              event.data.actions.src_url,
              event.data.actions.dest_url
            )
          end
        end,
      })
      return {}
    end,
    keys = {
      {
        "<leader>e",
        function()
          require("oil").open()
        end,
        desc = "Oil",
      },
    },
    opts = {
      columns = {
        -- "icon",
        -- "permissions",
        -- "size",
        -- "mtime",
      },
      view_options = {
        show_hidden = true,
        natural_order = true,
        case_insensitive = true,
      },
      cleanup_delay_ms = 1,
      use_default_keymaps = false,
      keymaps = {
        ["<leader>e"] = "actions.close",
        ["<leader>E"] = "actions.close",
        ["q"] = "actions.close",
        ["<backspace>"] = "actions.parent",
        ["<CR>"] = "actions.select",
        ["<leader>."] = function()
          local cwd = require("oil").get_current_dir()
          vim.cmd("cd " .. cwd)
        end,
        ["<leader><CR>"] = {
          callback = function()
            local augroup =
              vim.api.nvim_create_augroup("oil-open-all", { clear = true })
            vim.api.nvim_create_autocmd("QuickFixCmdPost", {
              group = augroup,
              callback = function()
                vim.api.nvim_del_augroup_by_id(augroup)
                local timer = vim.uv.new_timer()
                timer:start(
                  10,
                  0,
                  vim.schedule_wrap(function()
                    vim.cmd("cclose")
                    vim.cmd("ldo e %")
                  end)
                )
              end,
            })
            require("oil.actions").send_to_loclist.callback()
          end,
        },
        ["<C-r>"] = "actions.refresh",
        ["H"] = "actions.toggle_hidden",
        ["g?"] = "actions.show_help",
        ["gx"] = "actions.open_external",
        ["<C-t>"] = function() -- opens a new tmux window at the current dir
          require("tmux").neww({ cwd = require("oil").get_current_dir() })
        end,
        ["\\"] = function()
          require("tmux").splitw({ cwd = require("oil").get_current_dir() })
        end,
        ["-"] = function()
          require("tmux").splitw({
            cwd = require("oil").get_current_dir(),
            vertical = true,
          })
        end,
      },
      float = {
        padding = 8,
      },
    },
  },
  {
    "christoomey/vim-tmux-navigator",
    cmd = {
      "TmuxNavigateLeft",
      "TmuxNavigateDown",
      "TmuxNavigateUp",
      "TmuxNavigateRight",
    },
    keys = {
      { "<c-h>", "<cmd>TmuxNavigateLeft<cr>", mode = { "n", "t", "i" } },
      { "<c-j>", "<cmd>TmuxNavigateDown<cr>", mode = { "n", "t", "i" } },
      { "<c-k>", "<cmd>TmuxNavigateUp<cr>", mode = { "n", "t", "i" } },
      { "<c-l>", "<cmd>TmuxNavigateRight<cr>", mode = { "n", "t", "i" } },
    },
  },
  -- QOL
  {
    "folke/persistence.nvim",
    opts = {},
    keys = {
      { "<leader>qq", "<cmd>qa<cr>" },
      {
        "<leader>qs",
        function()
          require("persistence").load()
        end,
      },
    },
    config = function(_, opts)
      local fname = vim.fn.argv(-1)[1]
      -- Ignore sessionizing jj desc files
      if fname and string.find(vim.fs.basename(fname), ".jjdescription") then
        return
      end
      require("persistence").setup(opts)
    end,
  },
  {
    "folke/snacks.nvim",
    init = function()
      vim.api.nvim_create_user_command( "Pick", ":lua Snacks.picker()", {})
    end,
    opts = {
      matcher = { sort_empty = false },
      picker = {
        ui_select = true,
        layout = {
          preset = function()
            return vim.o.columns >= 120 and "default_full" or "vertical_full"
          end,
        },
        layouts = {
          default_full = {
            preset = "default",
            layout = { width = 0.99, height = 0.99 },
          },
          vertical_full = {
            preset = "vertical",
            layout = { width = 0.99, height = 0.99 },
          },
        },
      },
      indent = {
        enabled = true,
        scope = { animate = { easing = "inOutQuad" } },
        chunk = { enabled = true, char = { arrow = "" } },
      },
      quickfile = { enabled = true },
      statuscolumn = { enabled = true },
      zen = {
        toggles = { dim = false, mini_diff_signs = true },
        show = { statusline = true },
      },
    },
    keys = {
      {
        "<leader><space>",
        function()
          Snacks.picker.files({ cwd = vim.lsp.client.root_dir })
        end,
        desc = "Files (LSP Root || Vim PWD)",
      },
      {
        "<leader>sf",
        function()
          if Snacks.git.get_root() then
            return Snacks.picker.git_files({ untracked = true })
          end
          Snacks.picker.files({})
        end,
        desc = "Files (Git Root || Vim PWD)",
      },
      {
        "<leader>sF",
        function()
          local bufinfo = vim.fn.getbufinfo(0)[1]
          local cwd = nil
          if bufinfo.name:match("^/") then
            cwd = vim.fs.dirname(bufinfo.name)
          end
          Snacks.picker.files({ cwd = cwd })
        end,
        desc = "Files (Buffer's PWD || Vim PWD)",
      },
      {
        "<leader>sb",
        function()
          Snacks.picker.buffers({})
        end,
        desc = "Buffers",
      },
      {
        "<leader>sh",
        function()
          Snacks.picker.help({})
        end,
        desc = "Help Pages",
      },
      {
        "<leader>sk",
        function()
          Snacks.picker.keymaps({})
        end,
        desc = "Key Maps",
      },
      {
        "<leader>sm",
        function()
          Snacks.picker.marks({})
        end,
        desc = "Marks",
      },
      {
        "<leader>sg",
        function()
          Snacks.picker.grep({})
        end,
        desc = "Grep workspace",
      },
      {
        "<leader>sc",
        function()
          Snacks.picker.resume({})
        end,
        desc = "Continue",
      },
      {
        "<leader>sG",
        function()
          require("fzf-lua").lgrep_curbuf({})
        end,
        desc = "Grep buffer",
      },
      {
        "<leader>ss",
        function()
          Snacks.picker.lsp_symbols({})
        end,
        desc = "Symbols (Buffer)",
      },
      {
        "<leader>sS",
        function()
          Snacks.picker.lsp_workspace_symbols({})
        end,
        desc = "Symbols (Workspace)",
      },
      {
        "<leader>sd",
        function()
          Snacks.picker.diagnostics({})
        end,
        desc = "Diagnostics (Workspace)",
      },
      {
        "<leader>sD",
        function()
          Snacks.picker.diagnostics_buffer({})
        end,
        desc = "Diagnostics (Buffer)",
      },
      {
        "<leader>rc",
        function()
          Snacks.picker.commands({})
        end,
        desc = "Run commands",
      },
      {
        "<leader>j",
        function()
          Snacks.picker.buffers({
            hidden = false,
            unloaded = true,
            current = true,
            nofile = false,
            sort_lastused = true,
            focus = "list",
            layout = { preview = false, preset = "select" },
            on_show = function()
              vim.api.nvim_feedkeys("j", "n", false) -- focus alt buffer on show
            end,
            win = {
              list = {
                keys = { ["<c-x>"] = { "bufdelete", mode = { "n", "i" } } },
              },
            },
          })
        end,
        desc = "Jump to buffer (all)",
      },
      {
        "<leader>uz",
        function()
          Snacks.zen.zen()
        end,
        desc = "Toggle Zen Mode",
      },
      {
        "<leader>uf",
        function()
          Snacks.zen.zoom()
        end,
        desc = "Toggle Fullscreen",
      },
    },
  },
  {
    "MagicDuck/grug-far.nvim", -- grug gud
    opts = { headerMaxWidth = 80 },
    cmd = "GrugFar",
    keys = {
      {
        "<leader>sr",
        function()
          local grug = require("grug-far")
          local ext = vim.bo.buftype == "" and vim.fn.expand("%:e")
          grug.open({
            transient = true,
            prefills = {
              filesFilter = ext and ext ~= "" and "*." .. ext or nil,
            },
          })
        end,
        mode = { "n", "v" },
        desc = "Search and Replace",
      },
    },
  },
  -- MOTIONS
  { "folke/flash.nvim", opts = {} },
  {
    "echasnovski/mini.ai",
    opts = function()
      local ai = require("mini.ai")
      local extra = require("mini.extra")
      return {
        n_lines = 200,
        -- From LazyVim, with modifications
        custom_textobjects = {
          c = ai.gen_spec.treesitter({
            a = { "@code_cell.outer", "@class.outer" },
            i = { "@code_cell.inner", "@class.inner" },
          }), -- code_cell / class
          o = ai.gen_spec.treesitter({ -- code block
            a = { "@block.outer", "@conditional.outer", "@loop.outer" }, --
            i = { "@block.inner", "@conditional.inner", "@loop.inner" }, --
          }), --
          f = ai.gen_spec.treesitter({
            a = "@function.outer",
            i = "@function.inner",
          }), -- function
          u = ai.gen_spec.function_call(), -- u for "Usage"
          U = ai.gen_spec.function_call({ name_pattern = "[%w_]" }), -- without dot in function name
          t = { "<([%p%w]-)%f[^<%w][^<>]->.-</%1>", "^<.->().*()</[^/]->$" }, -- tags
          d = { "%f[%d]%d+" }, -- digits
          i = extra.gen_ai_spec.indent(), -- indent
          g = extra.gen_ai_spec.buffer(), -- buffer
          e = { -- Word with case
            {
              "%u[%l%d]+%f[^%l%d]",
              "%f[%S][%l%d]+%f[^%l%d]",
              "%f[%P][%l%d]+%f[^%l%d]",
              "^[%l%d]+%f[^%l%d]",
            },
            "^().*()$",
          },
        },
      }
    end,
  },
  -- GIT
  {
    "FabijanZulj/blame.nvim",
    cmd = "BlameToggle",
    keys = {
      { "<leader>gB", "<cmd>BlameToggle window<cr>" },
    },
    opts = { merge_consecutive = false },
  },
  {
    "echasnovski/mini.diff",
    event = "VeryLazy",
    keys = {
      {
        "<leader>go",
        function()
          require("mini.diff").toggle_overlay(0)
        end,
      },
    },
    opts = {
      view = {
        style = "sign",
        signs = { add = "▎", change = "▎", delete = "" },
      },
    },
  },
  -- CORE LANG
  {
    "saghen/blink.cmp",
    init = function()
      -- cmp
      local function cmpvisible()
        return tonumber(vim.fn.pumvisible()) ~= 0
      end
      vim.keymap.set("i", "<cr>", function()
        return cmpvisible() and "<C-y>" or "<cr>"
      end, { expr = true })
    end,
    opts = {
      completion = {
        list = { selection = { auto_insert = true, preselect = false } },
        menu = {
          auto_show = function(ctx)
            return ctx.mode ~= "cmdline"
          end,
        },
      },
      sources = {
        default = { "lazydev", "lsp", "path", "snippets", "buffer" },
        providers = {
          snippets = { score_offset = 40 },
          lsp = { score_offset = 50 },
          buffer = { score_offset = 30 },
          path = { score_offset = 10 },
          lazydev = {
            name = "LazyDev",
            module = "lazydev.integrations.blink",
            score_offset = 60,
          },
        },
      },
      appearance = {
        kind_icons = {
          Copilot = "",
        },
      },
      signature = {
        window = {
          show_documentation = false,
        },
      },
      keymap = {
        preset = "default",
        ["<Esc>"] = {
          function()
            require("blink.cmp").hide()
            if vim.fn.getcmdtype() ~= "" then
              -- replace <Esc> with <C-c> if it's the command line, otherwise the command is submitted
              vim.api.nvim_feedkeys(
                vim.api.nvim_replace_termcodes("<C-c>", true, true, true),
                "n",
                true
              )
              return true
            end
            return false -- call fallback
          end,
          "fallback",
        },
        ["<CR>"] = { "accept", "fallback" },
        ["<C-n>"] = { "show", "select_next", "fallback" },
        ["<C-p>"] = { "show", "select_prev", "fallback" },
        ["<C-u>"] = { "scroll_documentation_up", "fallback" },
        ["<C-d>"] = { "scroll_documentation_down", "fallback" },
      },
    },
  },
  {
    "stevearc/conform.nvim",
    cmd = "ConformInfo",
    init = function()
      vim.opt.formatexpr = "v:lua.require'conform'.formatexpr()"
      vim.g.autoformat = true
      vim.api.nvim_create_user_command(
        "W",
        "lua vim.g.autoformat = false; vim.cmd.w(); vim.g.autoformat = true",
        {}
      )
      vim.api.nvim_create_user_command(
        "WA",
        "lua vim.g.autoformat = false; vim.cmd.wa(); vim.g.autoformat = true",
        {}
      )
      vim.api.nvim_create_user_command(
        "Wa",
        "lua vim.g.autoformat = false; vim.cmd.wa(); vim.g.autoformat = true",
        {}
      )
    end,
    keys = {
      {
        "<leader>cc",
        "<cmd>ConformInfo<cr>",
        desc = "Conform Info",
      },
      {
        "<leader>cf",
        function()
          require("conform").format()
        end,
        desc = "Code Format",
      },
    },
    opts = {
      format_on_save = function(bufnr)
        if not vim.g.autoformat then
          return
        end
        return { buf = bufnr, lsp_format = "fallback" }
      end,
      default_format_opts = {
        timeout_ms = 3000,
        async = false,
        quiet = false,
        lsp_format = "fallback",
      },
      formatters_by_ft = {
        cmake = { "gersemi" },
        cs = { "csharpier" },
        go = { "goimports", "gofumpt" },
        lua = { "stylua" },
        quarto = { "injected" },
        sh = { "shfmt" },
        zig = { "zigfmt" },
        zsh = { "shfmt" },
      },
      formatters = {
        csharpier = {
          command = "dotnet-csharpier",
          args = { "--write-stdout" },
        },
        gersemi = { prepend_args = { "--indent", "2" } }, -- cmake formatter
        injected = {
          options = {
            ignore_errors = false,
            lang_to_ext = {
              bash = "sh",
              c_sharp = "cs",
              elixir = "exs",
              javascript = "js",
              julia = "jl",
              latex = "tex",
              markdown = "md",
              python = "py",
              ruby = "rb",
              rust = "rs",
              teal = "tl",
              r = "r",
              typescript = "ts",
            },
            lang_to_formatters = {},
          },
        },
        condition = function(_, ctx)
          return M.has_parser(ctx)
        end,
        prettier = { prepend_args = { "--prose-wrap", "always" } },
      },
    },
  },
  {
    "mfussenegger/nvim-lint",
    opts = {
      -- Event to trigger linters
      events = { "BufWritePost", "BufReadPost", "InsertLeave" },
      linters_by_ft = {
        dockerfile = { "hadolint" },
        markdown = { "pymarkdownlnt" },
        sh = { "shellcheck" },
      },
      linters = {
        pymarkdownlnt = {
          cmd = "pymarkdownlnt",
          stdin = true,
          args = { "scan-stdin" },
          stream = nil,
          ignore_exitcode = true,
          parser = function(...)
            return require("lint.parser").from_errorformat("stdin:%l:%c: %m", {
              source = "pymarkdownlnt",
              severity = vim.diagnostic.severity.WARN,
            })(...)
          end,
        },
      },
    },
    config = function(_, opts)
      local lint = require("lint")
      lint.linters_by_ft = opts.linters_by_ft

      for k, v in pairs(opts.linters) do
        if type(v) == "table" then
          lint.linters[k] = v
        end
      end

      vim.api.nvim_create_autocmd(opts.events, {
        group = vim.api.nvim_create_augroup("nvim-lint", { clear = true }),
        callback = function()
          vim.schedule_wrap(require("lint").try_lint)()
        end,
      })
    end,
  },
  {
    "nvim-treesitter/nvim-treesitter",
    init = function(plugin)
      require("lazy.core.loader").add_to_rtp(plugin)
      require("nvim-treesitter.query_predicates")
    end,
    cmd = { "TSUpdateSync", "TSUpdate", "TSInstall" },
    opts_extend = { "ensure_installed" },
    ---@type TSConfig
    ---@diagnostic disable-next-line: missing-fields
    opts = {
      highlight = { enable = true },
      indent = { enable = true },
      ensure_installed = require("treesitter-syntax"),
      textobjects = {
        move = {
          enable = true,
          goto_next_start = {
            ["]f"] = "@function.outer",
            ["]c"] = "@class.outer",
            ["]a"] = "@parameter.inner",
            ["]o"] = "@code_cell.inner",
          },
          goto_next_end = {
            ["]F"] = "@function.outer",
            ["]C"] = "@class.outer",
            ["]A"] = "@parameter.inner",
            ["]O"] = "@code_cell.inner",
          },
          goto_previous_start = {
            ["[f"] = "@function.outer",
            ["[c"] = "@class.outer",
            ["[a"] = "@parameter.inner",
            ["[o"] = "@code_cell.inner",
          },
          goto_previous_end = {
            ["[F"] = "@function.outer",
            ["[C"] = "@class.outer",
            ["[A"] = "@parameter.inner",
            ["[O"] = "@code_cell.inner",
          },
        },
      },
    },
    config = function(_, opts)
      require("nvim-treesitter.configs").setup(opts)
    end,
  },
  {
    "nvim-treesitter/nvim-treesitter-textobjects",
    config = function()
      -- If treesitter is already loaded, we need to run config again for textobjects
      local ts = require("lazy.core.config").spec.plugins["nvim-treesitter"]
      if ts and ts._.loaded then
        local opts = require("lazy.core.plugin").values(ts, "opts", false)
        ---@diagnostic disable-next-line: missing-fields
        require("nvim-treesitter.configs").setup({
          textobjects = opts.textobjects,
        })
      end

      -- When in diff mode, we want to use the default
      -- vim text objects c & C instead of the treesitter ones.
      local move = require("nvim-treesitter.textobjects.move") ---@type table<string,fun(...)>
      local configs = require("nvim-treesitter.configs")
      for name, fn in pairs(move) do
        if name:find("goto") == 1 then
          move[name] = function(q, ...)
            if vim.wo.diff then
              local config = configs.get_module("textobjects.move")[name] ---@type table<string,string>
              for key, query in pairs(config or {}) do
                if q == query and key:find("[%]%[][cC]") then
                  vim.cmd("normal! " .. key)
                  return
                end
              end
            end
            return fn(q, ...)
          end
        end
      end
    end,
  },
  { "windwp/nvim-ts-autotag", opts = {} },
  { "folke/ts-comments.nvim", opts = {} },
  {
    "folke/trouble.nvim",
    cmd = { "Trouble" },
    opts = {
      auto_preview = false,
    },
    keys = {
      { "<leader>x", "", desc = "+diagnostics" },
      { "<leader>xl", "<cmd>lopen<cr>", desc = "Location List" },
      { "<leader>xq", "<cmd>copen<cr>", desc = "Quickfix List" },
      {
        "<leader>xx",
        "<cmd>Trouble diagnostics toggle<cr>",
        desc = "Diagnostics (Trouble)",
      },
      {
        "<leader>xX",
        "<cmd>Trouble diagnostics toggle filter.buf=0<cr>",
        desc = "Buffer Diagnostics (Trouble)",
      },
      {
        "<leader>xs",
        "<cmd>Trouble symbols toggle<cr>",
        desc = "Symbols (Trouble)",
      },
      {
        "<leader>xS",
        "<cmd>Trouble lsp toggle<cr>",
        desc = "LSP references/definitions/... (Trouble)",
      },
      {
        "<leader>xL",
        "<cmd>Trouble loclist toggle<cr>",
        desc = "Location List (Trouble)",
      },
      {
        "<leader>xQ",
        "<cmd>Trouble qflist toggle<cr>",
        desc = "Quickfix List (Trouble)",
      },
      {
        "<leader>cd",
        function()
          vim.diagnostic.open_float({
            border = "rounded",
          })
        end,
        desc = "Diagnostics (Line)",
      },
    },
  },
  {
    "folke/todo-comments.nvim",
    keys = {
      {
        "<leader>xt",
        function()
          require("trouble").toggle({
            mode = "todo",
            groups = {
              { "directory" },
              { "filename" },
            },
          })
        end,
        desc = "Todo (Trouble)",
      },
      {
        "<leader>xT",
        "<cmd>Trouble todo toggle filter = {tag = {TODO,FIX,FIXME}}<cr>",
        desc = "Todo/Fix/Fixme (Trouble)",
      },
      { "<leader>st", "<cmd>TodoFzfLua<cr>", desc = "Todo" },
      {
        "<leader>sT",
        "<cmd>TodoFzfLua keywords=TODO,FIX,FIXME<cr>",
        desc = "Todo/Fix/Fixme",
      },
    },
    opts = {
      -- Had to override all of them so I could add highlighting to plurals
      keywords = {
        FIX = {
          icon = " ",
          color = "error",
          alt = { "FIXME", "BUG", "FIXIT", "ISSUE" },
        },
        TODOS = { icon = " ", color = "info", alt = { "TODO" } },
        HACKS = { icon = " ", color = "warning" },
        WARN = { icon = " ", color = "warning", alt = { "WARNING", "XXX" } },
        PERF = { icon = " ", alt = { "OPTIM", "PERFORMANCE", "OPTIMIZE" } },
        NOTES = { icon = " ", color = "hint", alt = { "NOTE", "INFO" } },
        TESTS = {
          icon = "⏲ ",
          color = "test",
          alt = { "TEST", "TESTING", "PASSED", "FAILED" },
        },
      },
      highlight = {
        pattern = [[.*<(KEYWORDS)\s*]],
      },
      search = {
        pattern = [[\b(KEYWORDS)\b]],
      },
    },
  },
  -- THEME
  {
    "folke/snacks.nvim",
    opts = {
      dashboard = {
        sections = {
          { section = "header" },
          function()
            local root = Snacks.git.get_root()
            if root then
              return {
                {
                  title = "repo: ",
                  desc = vim.fs.basename(root),
                  icon = " ",
                  key = "b",
                  action = Snacks.gitbrowse,
                },
                {
                  desc = "pull requests",
                  icon = " ",
                  key = "p",
                  action = function()
                    vim.fn.jobstart("gh pr list --web", { detach = true })
                  end,
                },
                {
                  desc = "issues",
                  icon = " ",
                  key = "i",
                  action = function()
                    vim.fn.jobstart("gh issues list --web", { detach = true })
                  end,
                  padding = 1,
                },
              }
            end
          end,
          { title = "session" },
          {
            desc = "restore",
            icon = " ",
            key = "s",
            action = function()
              require("persistence").load()
            end,
          },
          {
            desc = "quit",
            icon = " ",
            key = "q",
            action = ":qa",
            padding = 1,
          },
          { section = "startup" },
        },
        preset = {
          header = require("logo"),
          keys = {},
        },
      },
    },
  },
  {
    "sschleemilch/slimline.nvim",
    opts = {
      style = "fg",
      spaces = { left = "", right = "" },
      sep = {
        hide = { first = true, last = true },
        left = "",
        right = "",
      },
      components = {
        left = { "mode", "path" },
        right = { "diagnostics", "filetype_lsp", "progress" },
      },
      configs = {
        modes = {
          hl = {
            normal = "MiniIconsBlue",
            insert = "MiniIconsGreen",
            pending = "MiniIconsRed",
            visual = "MiniIconsPurple",
            command = "MiniIconsOrange",
          },
        },
      },
    },
  },
  {
    "echasnovski/mini.icons",
    opts = {
      file = {
        [".keep"] = { glyph = "󰊢", hl = "MiniIconsGrey" },
        ["devcontainer.json"] = { glyph = "", hl = "MiniIconsAzure" },
      },
      filetype = {
        dotenv = { glyph = "", hl = "MiniIconsYellow" },
      },
    },
    init = function()
      package.preload["nvim-web-devicons"] = function()
        require("mini.icons").mock_nvim_web_devicons()
        return package.loaded["nvim-web-devicons"]
      end
    end,
  },
  -- nothing for tokyonight
  {
    "catppuccin/nvim",
    name = "catppuccin",
    opts = {
      integrations = {
        cmp = true,
        dashboard = true,
        flash = true,
        gitsigns = true,
        grug_far = true,
        harpoon = true,
        indent_blankline = { enabled = true },
        lsp_trouble = true,
        mason = true,
        markdown = true,
        mini = true,
        native_lsp = {
          enabled = true,
          underlines = {
            errors = { "undercurl" },
            hints = { "undercurl" },
            warnings = { "undercurl" },
            information = { "undercurl" },
          },
        },
        navic = true,
        neotest = true,
        noice = true,
        notify = true,
        render_markdown = true,
        semantic_tokens = true,
        treesitter = true,
        treesitter_context = true,
        which_key = true,
      },
    },
  },
  -- AI
  {
    "zbirenbaum/copilot.lua",
    cmd = "Copilot",
    opts = {
      suggestions = { enabled = false },
      panel = { enabled = false },
    },
  },
  {
    "CopilotC-Nvim/CopilotChat.nvim",
    init = function()
      vim.treesitter.language.register("markdown", "copilot-chat")
    end,
    opts = {
      model = "claude-3.5-sonnet",
      temperature = 0.1,

      -- Enable intelligent resource processing (skips unnecessary resources to save tokens)
      resource_processing = true,

      headers = {
        user = "## 👤 You: ",
        assistant = "## 🤖 Copilot: ",
        tool = "## 🔧 Tool: ",
      },

      window = {
        -- layout = "float",
        -- border = "none",
        -- width = 1,
        -- height = 1,
        layout = "vertical",
        border = "single",
      },

      -- providers = {},

      -- functions = {},

      -- prompts = {},

      mappings = {
        complete = {
          insert = "<CR>",
        },
        close = {
          normal = "q",
          insert = "",
        },
        reset = {
          normal = "<C-c>",
          insert = "<C-c>",
        },
      },
    },
    keys = {
      {
        "<leader>ll",
        function()
          local mode = vim.api.nvim_get_mode().mode
          require("CopilotChat").open({
            selection = function(source)
              local select = require("CopilotChat.select")
              if mode == "v" then
                return select.visual(source)
              end
              return select.buffer(source)
            end,
          })
        end,
        mode = { "n", "v" },
        desc = "Copilot",
      },
    },
  },
  {
    "ravitemer/mcphub.nvim",
    cmd = "MCPHub",
    keys = {
      {
        "<leader>lm",
        "<cmd>MCPHub<CR>",
        desc = "MCPHub",
      },
    },
    opts = {
      use_bundled_binary = true, -- Use local `mcp-hub` binary
      config = vim.fn.expand("~/.config/mcphub/servers.json"),
      port = 37373,

      mcp_request_timeout = 5000, -- in ms

      auto_approve = false, -- Auto approve mcp tool calls
      auto_toggle_mcp_servers = true, -- Let LLMs start and stop MCP servers automatically

      extensions = {
        copilotchat = {
          enabled = true,
          convert_tools_to_functions = true, -- Convert MCP tools to CopilotChat functions
          convert_resources_to_functions = true, -- Convert MCP resources to CopilotChat functions
          add_mcp_prefix = true, -- Add "mcp_" prefix to function names
        },
      },

      workspace = {
        enabled = true, -- Enable project-local configuration files
        look_for = {
          ".mcphub/servers.json",
          ".vscode/mcp.json",
          ".cursor/mcp.json",
        }, -- Files to look for when detecting project boundaries (VS Code format supported)
        reload_on_dir_changed = true, -- Automatically switch hubs on DirChanged event
        port_range = { min = 40000, max = 41000 }, -- Port range for generating unique workspace ports
        get_port = nil, -- Optional function returning custom port number. Called when generating ports to allow custom port assignment logic
      },

      global_env = {},
      native_servers = {},

      builtin_tools = {
        edit_file = {
          parser = {
            track_issues = true,
            extract_inline_content = true,
          },
          locator = {
            fuzzy_threshold = 0.8,
            enable_fuzzy_matching = true,
          },
          ui = {
            go_to_origin_on_complete = true,
            keybindings = {
              accept = ".",
              reject = ",",
              next = "n",
              prev = "p",
              accept_all = "ga",
              reject_all = "gr",
            },
          },
        },
      },
      ui = {
        window = {
          width = 1, -- 0-1 (ratio); "50%" (percentage); 50 (raw number)
          height = 1, -- 0-1 (ratio); "50%" (percentage); 50 (raw number)
          align = "center", -- "center", "top-left", "top-right", "bottom-left", "bottom-right", "top", "bottom", "left", "right"
          relative = "editor",
          zindex = 50,
          border = "rounded", -- "none", "single", "double", "rounded", "solid", "shadow"
        },
        wo = { -- window-scoped options (vim.wo)
          winhl = "Normal:MCPHubNormal,FloatBorder:MCPHubBorder",
        },
      },
      json_decode = nil, -- Custom JSON parser function (e.g., require('json5').parse for JSON5 support)
      on_ready = function(hub)
        -- Called when hub is ready
      end,
      on_error = function(err)
        -- Called on errors
      end,
      log = {
        level = vim.log.levels.WARN,
        to_file = false,
        file_path = nil,
        prefix = "MCPHub",
      },
    },
  },
  -- HANDY
  {
    "m00qek/baleia.nvim",
    config = function()
      local baleia = require("baleia").setup({})

      -- Command to colorize the current buffer
      vim.api.nvim_create_user_command("AnsiColorize", function()
        baleia.once(vim.api.nvim_get_current_buf())
      end, { bang = true })

      -- Command to show logs
      vim.api.nvim_create_user_command(
        "AnsiLogs",
        baleia.logger.show,
        { bang = true }
      )
    end,
    cmd = { "AnsiColorize", "AnsiLogs" },
  },
  {
    "lukas-reineke/virt-column.nvim",
    opts = { char = { "▏" }, virtcolumn = "81,121" },
  },
  -- LANG SPECIFIC
  -- Nothing for a bunch of these
  {
    "folke/lazydev.nvim",
    cmd = "LazyDev",
    opts = {
      library = {
        { path = "luvit-meta/library", words = { "vim%.uv" } },
        { path = "LazyVim", words = { "LazyVim" } },
        { path = "lazy.nvim", words = { "LazyVim" } },
      },
    },
  },
  {
    "Saecki/crates.nvim",
    opts = {
      completion = {
        crates = {
          enabled = true,
        },
      },
      lsp = {
        enabled = true,
        actions = true,
        completion = true,
        hover = true,
      },
    },
  },
  {
    "maxandron/goplements.nvim",
    opts = {
      -- The prefixes prepended to the type names
      prefix = {
        interface = "implemented by: ",
        struct = "implements: ",
      },
      -- Whether to display the package name along with the type name (i.e., builtins.error vs error)
      display_package = false,
    },
  },
  {
    "linux-cultist/venv-selector.nvim",
    cmd = "VenvSelect",
    keys = {
      {
        "<leader>cv",
        "<cmd>:VenvSelect<cr>",
        desc = "Select VirtualEnv",
        ft = "python",
      },
    },
    opts = {
      settings = {
        options = {
          on_venv_activate_callback = nil, -- callback function for after a venv activates
          enable_default_searches = true, -- switches all default searches on/off
          enable_cached_venvs = true, -- use cached venvs that are activated automatically when a python file is registered with the LSP.
          cached_venv_automatic_activation = false, -- if set to false, the VenvSelectCached command becomes available to manually activate them.
          activate_venv_in_terminal = true, -- activate the selected python interpreter in terminal windows opened from neovim
          set_environment_variables = true, -- sets VIRTUAL_ENV or CONDA_PREFIX environment variables
          notify_user_on_venv_activation = true, -- notifies user on activation of the virtual env
          search_timeout = 5, -- if a search takes longer than this many seconds, stop it and alert the user
          fd_binary_name = "fd", -- plugin looks for `fd` or `fdfind` but you can set something else here
          require_lsp_activation = false, -- require activation of an lsp before setting env variables
        },
      },
    },
  },
  -- MARKDOWN
  {
    "MeanderingProgrammer/render-markdown.nvim",
    opts = {
      code = {
        sign = false,
        width = "block",
        right_pad = 1,
      },
      heading = {
        sign = false,
        icons = {},
      },
      checkbox = {
        custom = {
          rightarrow = {
            raw = "[>]",
            rendered = " ",
            highlight = "RenderMarkdownInfo",
            scope_highlight = nil,
          },
          tilde = {
            raw = "[~]",
            rendered = "󰰱 ",
            highlight = "RenderMarkdownError",
            scope_highlight = nil,
          },
          important = {
            raw = "[!]",
            rendered = " ",
            highlight = "RenderMarkdownWarn",
            scope_highlight = nil,
          },
        },
      },
      html = {
        -- Turn on / off all HTML rendering
        enabled = true,
        comment = {
          -- Turn on / off HTML comment concealing
          conceal = false,
        },
      },
    },
    keys = {
      {
        "<leader>mr",
        function()
          require("render-markdown").toggle()
        end,
        ft = "markdown",
      },
    },
  },
  {
    "iamcco/markdown-preview.nvim",
    cmd = { "MarkdownPreviewToggle", "MarkdownPreview", "MarkdownPreviewStop" },
    keys = {
      {
        "<leader>mpb",
        "<cmd>MarkdownPreviewToggle<cr>",
        desc = "Preview in Browser",
        ft = "markdown",
      },
    },
    config = function()
      vim.cmd([[do FileType]])
    end,
  },
  {
    "bullets-vim/bullets.vim",
    config = function()
      vim.g.bullets_enabled_file_types = { "markdown" }
      vim.g.bullets_outline_levels = { "num", "abc", "std-" }
      vim.g.bullets_checkbox_markers = " x"
    end,
  },
  -- REMOVE?
  {
    "ThePrimeagen/harpoon",
    keys = function()
      local keys = {
        {
          "<leader>h",
          function()
            local harpoon = require("harpoon")
            harpoon.ui:toggle_quick_menu(harpoon:list())
          end,
        },
        {
          "<leader>H",
          function()
            require("harpoon"):list():add()
          end,
        },
      }
      for i = 1, 5 do
        keys[#keys + 1] = {
          "<leader>" .. i,
          function()
            require("harpoon"):list():select(i)
          end,
        }
      end
      return keys
    end,
  },
  {
    "jiaoshijie/undotree",
    opts = {
      ignore_filetype = { "undotree", "undotreeDiff", "qf", "dashboard" },
    },
    keys = {
      { "<leader>uh", 'lua require("undotree").toggle()' },
    },
  },
}

for _, v in ipairs(config) do
  v.optional = true
end

return config
