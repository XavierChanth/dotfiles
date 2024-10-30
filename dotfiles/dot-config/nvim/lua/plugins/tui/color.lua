return {
  {
    "raddari/last-color.nvim",
    priority = 1000,
    lazy = false,
    config = function()
      Util.colorscheme.setup({
        default_theme = "catppucin-mocha",
        reload_time = 5000,
        on_switch = function(theme, is_first)
          if not is_first then
            Util.external.tmux.reload_config()
            Util.external.sketchybar.reload()
            Util.external.wezterm.set_lastcolor(theme)
          end
        end,
      })
    end,
  },
  { "folke/tokyonight.nvim" },
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
}
