return {
  {

    "epwalsh/obsidian.nvim",
    version = "*",
    lazy = true,
    ft = "markdown",
    opts = {
      workspaces = {
        {
          name = "obsidian vault",
          path = "~/dev/obsidian",
        },
      },

      -- TODO: configure this later
      -- https://github.com/epwalsh/obsidian.nvim
      -- see below for full list of options 👇
    },
  },
}
