return {
  {
    "stevearc/oil.nvim",
    keys = {
      {
        "<leader>e",
        function()
          require("oil").open()
        end,
        desc = "Oil",
      },
      {
        "<leader>E",
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
      cleanup_delay_ms = 0,
      use_default_keymaps = false,
      keymaps = {
        ["<leader>e"] = "actions.close",
        ["<leader>E"] = "actions.close",
        ["q"] = "actions.close",
        ["<backspace>"] = "actions.parent",
        ["<CR>"] = "actions.select",
        ["<C-r>"] = "actions.refresh",
        ["H"] = "actions.toggle_hidden",
        ["g?"] = "actions.show_help",
        ["gx"] = "actions.open_external",
        ["<C-_>"] = function()
          LazyVim.terminal(nil, { cwd = require("oil").get_current_dir() })
        end,
        ["<C-t>"] = function()
          require("util.tmux").neww({ cwd = require("oil").get_current_dir() })
        end,
      },
      float = {
        padding = 8,
      },
    },
  },
}
