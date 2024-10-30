return {
  "folke/which-key.nvim",
  event = "VeryLazy",
  opts_extend = { "spec" },
  opts = {
    defaults = {},
    spec = {
      {
        mode = { "n", "v" },
        -- core groups
        { "g", group = "goto" },
        { "<leader>c", group = "code" },
        { "<leader>g", group = "git" },

        -- search groups
        { "<leader>f", group = "find" },
        { "<leader>s", group = "search" },
        { "<leader>r", group = "run", icon = { icon = " ", color = "orange" } },

        -- ui groups
        { "<leader>u", group = "ui", icon = { icon = "󰙵 ", color = "cyan" } },
        {
          "<leader>b",
          group = "buffer",
          -- expand = function()
          --   return require("which-key.extras").expand.buf()
          -- end,
        },
        {
          "<leader>w",
          group = "windows",
          proxy = "<c-w>",
          -- expand = function()
          --   return require("which-key.extras").expand.win()
          -- end,
        },
        { "<leader>t", group = "tabs" },

        -- Better descriptions
        { "gx", desc = "Open with system app" },
      },
    },
  },
  keys = {
    {
      "<leader>?",
      function()
        require("which-key").show({ global = false })
      end,
      desc = "Buffer Keymaps (which-key)",
    },
    {
      "<c-w><space>",
      function()
        require("which-key").show({ keys = "<c-w>", loop = true })
      end,
      desc = "Window Hydra Mode (which-key)",
    },
  },
}
