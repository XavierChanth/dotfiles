local logos = require("logos")
local selected_logo = "ansi_shadow"
return {
  {
    "nvimdev/dashboard-nvim",
    opts = {
      config = {
        header = vim.split("\n\n" .. logos[selected_logo] .. "\n\n", "\n"),
      },
    },
  },
  { "folke/tokyonight.nvim", enabled = false }, -- disable Lazyvim's default theme
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
    "nvim-lualine/lualine.nvim",
    config = {
      options = {
        theme = "catppuccin",
        section_separators = { left = "", right = "" },
      },
      sections = {
        lualine_a = { { "mode", separator = { left = "", right = "" } } },
        lualine_z = { { separator = { right = "" } } },
      },
    },
  },
}
