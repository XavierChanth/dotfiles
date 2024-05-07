local Util = require("lazyvim.util")
return {
  {
    "stevearc/oil.nvim",
    keys = {
      {
        "<leader>fo",
        function()
          require("oil").open()
        end,
        desc = "Oil",
      },
      {
        "<leader>fO",
        function()
          require("oil").open(require("lazyvim.util.root").git())
        end,
        desc = "Oil (root dir)",
      },
    },
    opts = {
      columns = {
        "icon",
        -- "permissions",
        -- "size",
        -- "mtime",
      },
      view_options = {
        show_hidden = true,
      },
      use_default_keymaps = false,
      keymaps = {
        ["<leader>e"] = "actions.close",
        ["<leader>E"] = "actions.close",
        ["q"] = "actions.close",
        ["<C-q>"] = { "q", noremap = true },
        ["<C-c>"] = "actions.close",
        ["<backspace>"] = "actions.parent",
        ["<CR>"] = "actions.select",
        -- ["<C-l>"] = "actions.refresh",
        ["H"] = "actions.toggle_hidden",
        ["g?"] = "actions.show_help",
        ["<leader>rs"] = "actions.change_sort",
        ["gx"] = "actions.open_external",
      },
      float = {
        padding = 8,
      },
    },
  },
  {
    "nvim-neo-tree/neo-tree.nvim",
    keys = {
      { "<leader>e", false },
      { "<leader>E", false },
      {
        "<leader>fe",
        function()
          require("neo-tree.command").execute({ toggle = true, dir = Util.root.git() })
        end,
        desc = "File Explorer",
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
      },
    },
  },
}
