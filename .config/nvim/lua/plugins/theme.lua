local logo = [[
██╗  ██╗ █████╗ ██╗   ██╗██╗███████╗██████╗  ██████╗██╗  ██╗ █████╗ ███╗   ██╗████████╗██╗  ██╗
╚██╗██╔╝██╔══██╗██║   ██║██║██╔════╝██╔══██╗██╔════╝██║  ██║██╔══██╗████╗  ██║╚══██╔══╝██║  ██║
 ╚███╔╝ ███████║██║   ██║██║█████╗  ██████╔╝██║     ███████║███████║██╔██╗ ██║   ██║   ███████║
 ██╔██╗ ██╔══██║╚██╗ ██╔╝██║██╔══╝  ██╔══██╗██║     ██╔══██║██╔══██║██║╚██╗██║   ██║   ██╔══██║
██╔╝ ██╗██║  ██║ ╚████╔╝ ██║███████╗██║  ██║╚██████╗██║  ██║██║  ██║██║ ╚████║   ██║   ██║  ██║
╚═╝  ╚═╝╚═╝  ╚═╝  ╚═══╝  ╚═╝╚══════╝╚═╝  ╚═╝ ╚═════╝╚═╝  ╚═╝╚═╝  ╚═╝╚═╝  ╚═══╝   ╚═╝   ╚═╝  ╚═╝
    ]]

logo = string.rep("\n", 8) .. logo .. "\n\n"

return {
  {
    "nvimdev/dashboard-nvim",
    opts = {
      config = {
        header = vim.split(logo, "\n"),
      },
    },
  },
  {
    "LazyVim/LazyVim",
    dependencies = { "raddari/last-color.nvim" },
    config = {
      colorscheme = function()
        local theme = require("last-color").recall() or "catppuccin"
        vim.cmd(("colorscheme %s"):format(theme))
      end,
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
    },
  },
}
