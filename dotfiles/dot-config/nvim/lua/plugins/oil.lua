return {
  {
    "stevearc/oil.nvim",
    lazy = vim.fn.argc(-1) == 0, -- lazy load if we don't need it at startup
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
          Util.terminal("yazi", {})
        end,
        cond = Util.platform.supports_terminal(),
        desc = "Open Yazi",
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
        natural_order = true,
        case_insensitive = true,
      },
      cleanup_delay_ms = 1,
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
          Util.terminal.from_oil()
        end,
        ["<C-t>"] = function() -- opens a new tmux window at the current dir
          if Util.platform.is_gui() or Util.platform.is_windows() then
            return
          end
          Util.tmux.neww({ cwd = require("oil").get_current_dir() })
        end,
      },
      float = {
        padding = 8,
      },
    },
  },
}
