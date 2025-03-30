return {
  {
    "folke/snacks.nvim",
    priority = 1000,
    lazy = false,
    opts = {
      bigfile = { enabled = true },
      indent = {
        enabled = true,
        scope = {
          animate = { easing = "inOutQuad" },
        },
        chunk = {
          enabled = true,
          char = { arrow = "" },
        },
      },
      quickfile = { enabled = true },
      statuscolumn = {
        enabled = true,
      },
      zen = {
        toggles = { dim = false, mini_diff_signs = true },
        show = { statusline = true },
      },
    },
    keys = {
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
}
