local logo = [[
██╗  ██╗ █████╗ ██╗   ██╗██╗███████╗██████╗  ██████╗██╗  ██╗ █████╗ ███╗   ██╗████████╗██╗  ██╗
╚██╗██╔╝██╔══██╗██║   ██║██║██╔════╝██╔══██╗██╔════╝██║  ██║██╔══██╗████╗  ██║╚══██╔══╝██║  ██║
 ╚███╔╝ ███████║██║   ██║██║█████╗  ██████╔╝██║     ███████║███████║██╔██╗ ██║   ██║   ███████║
 ██╔██╗ ██╔══██║╚██╗ ██╔╝██║██╔══╝  ██╔══██╗██║     ██╔══██║██╔══██║██║╚██╗██║   ██║   ██╔══██║
██╔╝ ██╗██║  ██║ ╚████╔╝ ██║███████╗██║  ██║╚██████╗██║  ██║██║  ██║██║ ╚████║   ██║   ██║  ██║
╚═╝  ╚═╝╚═╝  ╚═╝  ╚═══╝  ╚═╝╚══════╝╚═╝  ╚═╝ ╚═════╝╚═╝  ╚═╝╚═╝  ╚═╝╚═╝  ╚═══╝   ╚═╝   ╚═╝  ╚═╝
    ]]

logo = string.rep("\n", 8) .. logo .. "\n\n"

local telescope = require("lazyvim.util.telescope")
-- Intentional override of lazyvim's config_files to be the entire dotfiles repo
---@diagnostic disable-next-line: duplicate-set-field
telescope.config_files = function()
  return telescope("files", {
    cwd = vim.fn.expand("$HOME/.dotfiles"),
    show_untracked = true,
    git_command = { "/bin/zsh", "-c", "git ls-files --exclude-standard --cached" },
  })
end

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
    "raddari/last-color.nvim",
    lazy = false,
    config = function()
      local theme = require("last-color").recall() or "catppuccin-mocha"
      vim.cmd(("colorscheme %s"):format(theme))
    end,
  },
  { "folke/tokyonight.nvim", lazy = true },
  {
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
