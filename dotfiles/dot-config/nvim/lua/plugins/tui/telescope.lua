return {
  {
    "nvim-telescope/telescope.nvim",
    cmd = "Telescope",
    opts = {
      defaults = Util.telescope.defaults,
      pickers = {
        buffers = {
          initial_mode = "normal",
          mappings = {
            n = {
              ["<c-f><c-d>"] = function(prompt_bufnr)
                local actions = require("telescope.actions")
                local action_state = require("telescope.actions.state")

                local current_picker = action_state.get_current_picker(prompt_bufnr)
                local multi_selections = current_picker:get_multi_selection()

                if next(multi_selections) == nil then
                  current_picker:delete_selection(function(selection)
                    vim.api.nvim_buf_delete(selection.bufnr, {})
                  end)
                else
                  actions.close(prompt_bufnr)
                  for _, selection in ipairs(multi_selections) do
                    vim.api.nvim_buf_delete(selection.bufnr, {})
                  end
                end
                return true
              end,
            },
          },
        },
        commands = {
          entry_maker = Util.telescope.command.entry_maker({}),
        },
        lsp_document_symbols = {
          symbol_width = 48,
        },
        lsp_dynamic_workspace_symbols = {
          fname_width = 48,
          symbol_width = 48,
        },
      },
      extensions = {
        undo = {
          use_delta = true,
          mappings = {
            i = {
              ["<cr>"] = function(prompt_bufnr)
                return require("telescope-undo.actions").restore(prompt_bufnr)
              end,
              ["<C-y>"] = function(prompt_bufnr)
                return require("telescope-undo.actions").yank_additions(prompt_bufnr)
              end,
              ["<C-Y>"] = function(prompt_bufnr)
                return require("telescope-undo.actions").yank_deletions(prompt_bufnr)
              end,
            },
            n = {
              ["<cr>"] = function(prompt_bufnr)
                return require("telescope-undo.actions").restore(prompt_bufnr)
              end,
              ["y"] = function(prompt_bufnr)
                return require("telescope-undo.actions").yank_additions(prompt_bufnr)
              end,
              ["Y"] = function(prompt_bufnr)
                return require("telescope-undo.actions").yank_deletions(prompt_bufnr)
              end,
            },
          },
        },
      },
    },
    keys = {
      { "<leader><space>", Util.telescope.git_files, desc = "Git files" },
      { "<leader>rr", Util.telescope.builtin("commands"), desc = "Run commands" },
      { "<leader>sf", Util.telescope.find_files, desc = "Find files" },
      {
        "<leader>sh",
        Util.telescope.builtin("help_tags"),
        desc = "Help Pages",
      },
      {
        "<leader>sk",
        Util.telescope.builtin("keymaps"),
        desc = "Key Maps",
      },
      {
        "<leader>sm",
        Util.telescope.builtin("marks"),
        desc = "Marks",
      },
      {
        "<leader>sg",
        Util.telescope.builtin("live_grep"),
        desc = "Grep",
      },
      {
        "<leader>sc",
        Util.telescope.builtin("resume"),
        desc = "Continue",
      },
      {
        "<leader>ss",
        Util.telescope.builtin("lsp_document_symbols"),
        desc = "Symbols (Buffer)",
      },
      {
        "<leader>sS",
        Util.telescope.builtin("lsp_dynamic_workspace_symbols"),
        desc = "Symbols (Workspace)",
      },
      {
        "<leader>m",
        function()
          Util.telescope.terminals()
        end,
        desc = "Find terminals",
      },
      {
        "<leader>j",
        function()
          Util.telescope.builtin("buffers", {
            sort_lastused = true,
            sort_mru = true,
          })
        end,
        desc = "Jump to buffer",
      },
      {
        "<leader>uc",
        Util.telescope.colorscheme,
        desc = "Colorscheme with Preview",
      },
    },
  },
  {
    "nvim-telescope/telescope-fzf-native.nvim",
    event = "VeryLazy",
    dependencies = { "telescope.nvim" },
    build = "make",
    config = function()
      require("telescope").load_extension("fzf")
    end,
  },
  {
    "debugloop/telescope-undo.nvim",
    config = function()
      require("telescope").load_extension("undo")
    end,
    keys = {
      {
        "<leader>su",
        "<cmd>Telescope undo<cr>",
        desc = "Undo history",
      },
    },
  },
}
