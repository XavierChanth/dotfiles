return {
  { -- input & select
    "stevearc/dressing.nvim",
    opts = {
      select = {
        backend = { "fzf_lua", "telescope", "builtin" },
      },
    },
    init = function()
      -- This supports normal mode, whereas noice doesn't
      ---@diagnostic disable-next-line: duplicate-set-field
      vim.ui.input = function(...)
        require("lazy").load({ plugins = { "dressing.nvim" } })
        return vim.ui.input(...)
      end
      ---@diagnostic disable-next-line: duplicate-set-field
      vim.ui.select = function(...)
        require("lazy").load({ plugins = { "dressing.nvim" } })
        return vim.ui.select(...)
      end
    end,
  },
  { -- notifications
    "rcarriga/nvim-notify",
    -- event = "VeryLazy", -- noice will load this
    opts = {
      render = "wrapped-compact",
      fps = 144,
      timeout = 200,
      max_height = 5,
      max_width = 50,
    },
  },
  { -- messages, cmdline, popupmenu
    "folke/noice.nvim",
    event = "VeryLazy",
    dependencies = { "MunifTanjim/nui.nvim" },
    opts = {
      cmdline = { format = { filter = { title = "Shell" } } },
      lsp = {
        progress = {
          enabled = false,
        },
        override = {
          ["vim.lsp.util.convert_input_to_markdown_lines"] = true,
          ["vim.lsp.util.stylize_markdown"] = true,
          ["cmp.entry.get_documentation"] = true,
        },
      },
      commands = {
        all = { view = "popup" },
        history = { view = "popup" },
      },
      views = {
        popup = {
          size = { width = "85%", height = "85%" },
          win_options = {
            wrap = true,
          },
        },
      },
      routes = {
        {
          filter = {
            event = "msg_show",
            any = { { find = "%d+L, %d+B" } },
          },
          view = "mini",
        },
        {
          filter = {
            event = "msg_show",
            any = {
              { find = "%d+ lines indented" },
              { find = "%d+ lines [<>]ed %d+ time" },
              { find = "%d+ substitutions on %d+ lines" },
              { find = "%d+ lines yanked" },
              { find = "%d+ fewer lines" },
              { find = "%d+ more lines" },
              { find = "; after #%d+" },
              { find = "; before #%d+" },
            },
          },
          opts = { skip = true },
        },
      },
      presets = {
        bottom_search = false,
        command_palette = true,
        long_message_to_split = true,
        lsp_doc_border = true,
      },
    },
    keys = {
      {
        "<leader>sn",
        function()
          require("noice").cmd("fzf")
        end,
        desc = "Noice Messages",
      },
      {
        "<c-f>",
        function()
          if not require("noice.lsp").scroll(4) then
            return "<c-f>"
          end
        end,
        silent = true,
        expr = true,
        desc = "Scroll Forward",
        mode = { "i", "n", "s" },
      },
      {
        "<c-b>",
        function()
          if not require("noice.lsp").scroll(-4) then
            return "<c-b>"
          end
        end,
        silent = true,
        expr = true,
        desc = "Scroll Backward",
        mode = { "i", "n", "s" },
      },
    },
    config = function(_, opts)
      if vim.o.filetype == "lazy" then
        vim.cmd([[messages clear]])
      end
      require("noice").setup(opts)
    end,
  },
}
