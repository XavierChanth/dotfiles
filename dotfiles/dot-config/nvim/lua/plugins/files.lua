return {
  {
    "stevearc/oil.nvim",
    lazy = false, -- load at startup since we override netrw with oil
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
          require("oil").open(require("util.root").git())
        end,
        desc = "Oil (root dir)",
      },
    },
    opts = {
      columns = {
        -- "icon",
        -- "permissions",
        -- "size",
        -- "mtime",
      },
      view_options = {
        show_hidden = true,
      },
      cleanup_delay_ms = 1,
      natural_order = false,
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
        ["<C-_>"] = function() -- opens the floating terminal at the current dir
          require("util.terminal").open_oil_terminal()
        end,
        ["<C-t>"] = function() -- opens a new tmux window at the current dir
          local platform = require("util.platform")
          if platform.is_gui() or platform.is_windows() then
            return
          end
          require("util.tmux").neww({ cwd = require("oil").get_current_dir() })
        end,
      },
      float = {
        padding = 8,
      },
    },
  },
}
