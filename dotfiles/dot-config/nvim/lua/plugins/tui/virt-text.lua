return {
  {
    "lukas-reineke/virt-column.nvim",
    event = { "BufReadPost", "BufNewFile", "BufReadPre" },
    opts = {
      char = { "┆" },
      virtcolumn = "80,120",
      highlight = { "NonText" },
    },
  },
  {
    "lukas-reineke/indent-blankline.nvim",
    event = { "BufReadPost", "BufNewFile", "BufReadPre" },
    opts = {
      indent = {
        char = "│",
        tab_char = "│",
      },
      scope = { show_start = false, show_end = false },
      exclude = {
        filetypes = {
          "help",
          "alpha",
          "dashboard",
          "neo-tree",
          "Trouble",
          "trouble",
          "lazy",
          "mason",
          "notify",
          "toggleterm",
          "lazyterm",
        },
      },
    },
    main = "ibl",
  },
}
