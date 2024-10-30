return {
  { "MunifTanjim/nui.nvim", lazy = true },
  {
    "stevearc/dressing.nvim",
    event = "VeryLazy",
    init = function()
      ---@diagnostic disable-next-line: duplicate-set-field
      vim.ui.select = function(...)
        require("lazy").load({ plugins = { "dressing.nvim" } })
        return vim.ui.select(...)
      end
      ---@diagnostic disable-next-line: duplicate-set-field
      vim.ui.input = function(...)
        require("lazy").load({ plugins = { "dressing.nvim" } })
        return vim.ui.input(...)
      end
    end,
  },

  {
    "folke/noice.nvim",
    dependencies = {
      {
        "rcarriga/nvim-notify",
        opts = {
          stages = "static",
          timeout = 3000,
          max_height = function()
            return math.floor(vim.o.lines * 0.75)
          end,
          max_width = function()
            return math.floor(vim.o.columns * 0.75)
          end,
        },
        init = function()
          -- when noice is not enabled, install notify on VeryLazy
          if not Util.lazy.has("noice.nvim") then
            Util.lazy.on_very_lazy(function()
              vim.notify = require("notify")
            end)
          end
        end,
      },
    },
    event = "VeryLazy",
    opts = {
      lsp = {
        override = {
          ["vim.lsp.util.convert_input_to_markdown_lines"] = true,
          ["vim.lsp.util.stylize_markdown"] = true,
          ["cmp.entry.get_documentation"] = true,
        },
      },
      routes = {
        {
          filter = {
            event = "msg_show",
            any = {
              { find = "%d+L, %d+B" },
              { find = "; after #%d+" },
              { find = "; before #%d+" },
            },
          },
          view = "mini",
        },
      },
      presets = {
        bottom_search = true,
        command_palette = true,
        long_message_to_split = true,
      },
    },
        -- stylua: ignore
        keys = {
            { "<leader>n",  "",                                                                            desc = "+noice" },
            { "<leader>nl", function() require("noice").cmd("last") end,                                   desc = "Last Message" },
            { "<leader>nh", function() require("noice").cmd("history") end,                                desc = "History" },
            { "<leader>na", function() require("noice").cmd("all") end,                                    desc = "All" },
            { "<leader>nd", function() require("noice").cmd("dismiss") end,                                desc = "Dismiss All" },
            { "<leader>ns", function() require("noice").cmd("pick") end,                                   desc = "Search" },
            { "<c-f>",      function() if not require("noice.lsp").scroll(4) then return "<c-f>" end end,  silent = true,                           expr = true, desc = "Scroll Forward",  mode = { "i", "n", "s" } },
            { "<c-b>",      function() if not require("noice.lsp").scroll(-4) then return "<c-b>" end end, silent = true,                           expr = true, desc = "Scroll Backward", mode = { "i", "n", "s" } },
        },
    config = function(_, opts)
      -- HACK: noice shows messages from before it was enabled,
      -- but this is not ideal when Lazy is installing plugins,
      -- so clear the messages in this case.
      if vim.o.filetype == "lazy" then
        vim.cmd([[messages clear]])
      end
      require("noice").setup(opts)
      require("telescope").load_extension("noice")
    end,
  },
}
