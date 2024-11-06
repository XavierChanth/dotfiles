vim.api.nvim_create_autocmd("User", {
  pattern = "VeryLazy",
  callback = function()
    Util.colorscheme.start_timer(3000) -- every 3 seconds
  end,
})

return {
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
        navic = true,
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
