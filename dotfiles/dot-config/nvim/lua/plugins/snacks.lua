return {
  {
    "folke/snacks.nvim",
    priority = 1000,
    lazy = false,
    version = "15f0607fb74bbbbaa8f712a26afc37abeb28756b",
    opts = {
      bigfile = { enabled = true },
      quickfile = { enabled = true },
      indent = {
        enabled = true,
        indent = { char = "│" },
        chunk = { enabled = true },
      },
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
  {
    "lukas-reineke/virt-column.nvim",
    event = { "BufReadPost", "BufNewFile", "BufReadPre" },
    opts = {
      char = { "▏" },
      virtcolumn = "81,121",
      highlight = { "NonText" },
    },
  },
}
