---@type logo
local logo = require("util.logos")["nvim_sharp"]
return {
  {
    "nvimdev/dashboard-nvim",
    opts = {
      config = {
        header = vim.split("\n\n" .. logo .. "\n\n", "\n"),
        center = require("util.dashboard").actions,
      },
    },
  },
  require("util.statusline").get({
    statusline = "lualine",
    theme = "minimal",
  }),
  -- Setup catppuccin theme
  {
    "catppuccin/nvim",
    name = "catppuccin",
    lazy = false,
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
        neotest = true,
        noice = true,
        notify = true,
        render_markdown = true,
        semantic_tokens = true,
        telescope = { enabled = true },
        treesitter = true,
        treesitter_context = true,
        which_key = true,
      },
    },
  },
  {
    "folke/tokyonight.nvim",
  },
}
