return {
  {
    "lukas-reineke/virt-column.nvim",
    event = { "BufReadPost", "BufNewFile", "BufReadPre" },
    opts = {
      char = { "▏" },
      virtcolumn = "81,121",
      -- highlight = { "NonText" },
    },
  },
}
