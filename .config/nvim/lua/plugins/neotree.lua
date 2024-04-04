local Util = require("lazyvim.util")
return {
  "nvim-neo-tree/neo-tree.nvim",
  keys = {
    {
      "<leader>e",
      function()
        require("neo-tree.command").execute({ toggle = true, reveal = true, dir = Util.root() })
      end,
      desc = "Explorer (root dir)",
    },
    {
      "<leader>E",
      function()
        require("neo-tree.command").execute({ toggle = true, reveal = true, dir = vim.loop.cwd() })
      end,
      desc = "Explorer (cwd)",
    },
    {
      "<leader>fe",
      function()
        require("neo-tree.command").execute({ toggle = true, reveal = true, position = "current", dir = Util.root() })
      end,
      desc = "Fullscreen Explorer (root dir)",
    },
    {
      "<leader>fE",
      function()
        require("neo-tree.command").execute({ toggle = true, reveal = true, position = "current", dir = vim.loop.cwd() })
      end,
      desc = "Fullscreen Explorer (cwd)",
    },
    {
      "<leader>uef",
      function()
        require("neo-tree.command").execute({ toggle = false, position = "float" })
      end,
      desc = "Explorer position (float)",
    },
    {
      "<leader>uel",
      function()
        require("neo-tree.command").execute({ toggle = false, position = "left" })
      end,
      desc = "Explorer position (left)",
    },
    {
      "<leader>uer",
      function()
        require("neo-tree.command").execute({ toggle = false, position = "right" })
      end,
      desc = "Explorer position (right)",
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
    event_handlers = {
      {
        event = "neo_tree_buffer_enter",
        handler = function()
          vim.opt_local.relativenumber = true
        end,
      },
    },
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
        ["F"] = {
          function(state)
            local current_node = state.tree:get_node()
            local path = current_node:get_id()

            vim.cmd("!open -R " .. path)
          end,
        },
      },
    },
  },
}
