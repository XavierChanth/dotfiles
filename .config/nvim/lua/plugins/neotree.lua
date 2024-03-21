local Util = require("lazyvim.util")
return {
  "nvim-neo-tree/neo-tree.nvim",
  keys = {
    {
      "<leader>e",
      function()
        require("neo-tree.command").execute({ toggle = true, dir = Util.root() })
      end,
      desc = "Explorer (root dir)",
    },
    {
      "<leader>E",
      function()
        require("neo-tree.command").execute({ toggle = true, dir = vim.loop.cwd() })
      end,
      desc = "Explorer (cwd)",
    },
    {
      "<leader>uec",
      function()
        require("neo-tree.command").execute({ toggle = false, position = "current" })
      end,
      desc = "Ui explorer (current)",
    },
    {
      "<leader>uef",
      function()
        require("neo-tree.command").execute({ toggle = false, position = "float" })
      end,
      desc = "Ui explorer (float)",
    },
    {
      "<leader>uel",
      function()
        require("neo-tree.command").execute({ toggle = false, position = "left" })
      end,
      desc = "Ui explorer (left)",
    },
    {
      "<leader>uer",
      function()
        require("neo-tree.command").execute({ toggle = false, position = "right" })
      end,
      desc = "Ui explorer (right)",
    },
    {
      "<leader>ge",
      function()
        require("neo-tree.command").execute({ source = "git_status", toggle = true })
      end,
      desc = "Git explorer",
    },
    {
      "<leader>be",
      function()
        require("neo-tree.command").execute({ source = "buffers", toggle = true })
      end,
      desc = "Buffer explorer",
    },
  },
  opts = {
    window = {
      position = "float",
      mappings = {
        ["w"] = {
          function(state)
            local current_node = state.tree:get_node()
            local path = current_node:get_id()

            -- If you want to set the root as well
            -- require("neo-tree.sources.filesystem.commands").set_root(state)
            vim.cmd("cd " .. path)
            vim.print("cwd: " .. path)
          end,
          desc = "set working directory",
        },
      },
    },
  },
}
