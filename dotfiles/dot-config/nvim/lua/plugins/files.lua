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
      use_default_keymaps = false,
      keymaps = {
        ["<leader>e"] = "actions.close",
        ["<leader>E"] = "actions.close",
        ["q"] = "actions.close",
        ["<backspace>"] = "actions.parent",
        ["<CR>"] = "actions.select",
        ["<C-l>"] = "actions.refresh",
        ["H"] = "actions.toggle_hidden",
        ["g?"] = "actions.show_help",
        ["gx"] = "actions.open_external",
      },
      float = {
        padding = 8,
      },
    },
  },
}
