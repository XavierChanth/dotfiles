return {
  "folke/snacks.nvim",
  opts = {
    picker = {
      ui_select = true,
      layout = {
        preset = function()
          return vim.o.columns >= 120 and "default_full" or "vertical_full"
        end,
      },
      layouts = {
        default_full = { preset = "default", layout = { width = 0.99, height = 0.99 } },
        vertical_full = { preset = "vertical", layout = { width = 0.99, height = 0.99 } },
      },
    },
  },
  keys = {
    {
      "<leader><space>",
      function()
        if Snacks.git.get_root() then
          return Snacks.picker.git_files({ untracked = true })
        end
        Snacks.picker.files({})
      end,
      desc = "Git files",
    },
    {
      "<leader>sf",
      function()
        Snacks.picker.files({})
      end,
      desc = "Find files",
    },
    {
      "<leader>sb",
      function()
        Snacks.picker.buffers({})
      end,
      desc = "Buffers",
    },
    {
      "<leader>sh",
      function()
        Snacks.picker.help({})
      end,
      desc = "Help Pages",
    },
    {
      "<leader>sk",
      function()
        Snacks.picker.keymaps({})
      end,
      desc = "Key Maps",
    },
    {
      "<leader>sm",
      function()
        Snacks.picker.marks({})
      end,
      desc = "Marks",
    },
    {
      "<leader>sg",
      function()
        Snacks.picker.grep({})
      end,
      desc = "Grep workspace",
    },
    {
      "<leader>sc",
      function()
        Snacks.picker.resume({})
      end,
      desc = "Continue",
    },
    {
      "<leader>sG",
      function()
        require("fzf-lua").lgrep_curbuf({})
      end,
      desc = "Grep buffer",
    },
    {
      "<leader>ss",
      function()
        Snacks.picker.lsp_symbols({})
      end,
      desc = "Symbols (Buffer)",
    },
    {
      "<leader>sS",
      function()
        Snacks.picker.lsp_workspace_symbols({})
      end,
      desc = "Symbols (Workspace)",
    },
    {
      "<leader>sd",
      function()
        Snacks.picker.diagnostics({})
      end,
      desc = "Diagnostics (Workspace)",
    },
    {
      "<leader>sD",
      function()
        Snacks.picker.diagnostics_buffer({})
      end,
      desc = "Diagnostics (Buffer)",
    },
    {
      "<leader>rc",
      function()
        Snacks.picker.commands({})
      end,
      desc = "Run commands",
    },
    {
      "<leader>j",
      function()
        Snacks.picker.buffers({
          sort_lastused = true,
          focus = "list",
          on_show = function()
            vim.api.nvim_feedkeys("j", "n", false) -- focus alt buffer on show
          end,
          win = {
            list = { keys = { ["<c-x>"] = { "bufdelete", mode = { "n", "i" } } } },
          },
        })
      end,
      desc = "Jump to buffer (all)",
    },
  },
}
