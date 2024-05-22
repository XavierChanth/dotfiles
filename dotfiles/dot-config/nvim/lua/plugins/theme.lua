local logos = require("util.logos")
local actions = require("util.dashboard").actions
local icons = require("lazyvim.config").icons

local selected_logo = "ansi_shadow"
return {
  {
    "nvimdev/dashboard-nvim",
    opts = {
      config = {
        header = vim.split("\n\n" .. logos[selected_logo] .. "\n\n", "\n"),
        center = actions,
      },
    },
  },
  { -- Setup catppuccin theme
    "catppuccin/nvim",
    name = "catppuccin",
    lazy = false,
    opts = {
      integrations = {
        aerial = true,
        alpha = true,
        cmp = true,
        dashboard = true,
        flash = true,
        gitsigns = true,
        headlines = true,
        illuminate = true,
        indent_blankline = { enabled = true },
        leap = true,
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
        navic = { enabled = true, custom_bg = "lualine" },
        neotest = true,
        neotree = true,
        noice = true,
        notify = true,
        semantic_tokens = true,
        telescope = true,
        treesitter = true,
        treesitter_context = true,
        which_key = true,
      },
    },
  },
  {
    "folke/tokyonight.nvim",
    commit = "4a9f04a647356d7727e5d41f7e7438a6f18381f4",
  },
  {
    "nvim-lualine/lualine.nvim",
    opts = {
      options = {
        section_separators = { left = "", right = "" },
        component_separators = { left = "", right = "" },
      },
      sections = {
        lualine_a = { { "mode", separator = { left = "", right = "" } } },
        lualine_c = {
          -- LazyVim.lualine.root_dir(),
          { "filetype", icon_only = true, separator = "", padding = { left = 1, right = 0 } },
          { LazyVim.lualine.pretty_path() },
        },
        lualine_y = {
          {
            "diagnostics",
            symbols = {
              error = icons.diagnostics.Error,
              warn = icons.diagnostics.Warn,
              info = icons.diagnostics.Info,
              hint = icons.diagnostics.Hint,
            },
          },
          -- {
          --   "buffers",
          --   filetype_names = {
          --     TelescopePrompt = "Telescope",
          --     dashboard = "Dashboard",
          --     packer = "Packer",
          --     fzf = "FZF",
          --     alpha = "Alpha",
          --     oil = "Oil",
          --   },
          --   max_length = vim.o.columns * 1 / 2,
          -- },
        },
        lualine_z = {
          { "progress", separator = { left = "" }, padding = { left = 1, right = 0 } },
          { "location", separator = { right = "" }, padding = { left = 0, right = 1 } },
        },
      },
    },
  },
}
