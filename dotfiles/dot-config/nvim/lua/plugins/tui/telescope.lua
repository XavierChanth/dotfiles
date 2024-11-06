return {
  {
    "nvim-telescope/telescope.nvim",
    cmd = "Telescope",
    version = false,
    opts = {
      defaults = Util.telescope.defaults,
      pickers = {
        buffers = {
          initial_mode = "normal",
          mappings = {
            n = {
              ["<c-x>"] = function(prompt_bufnr)
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
    },
    keys = {
      --   { "<leader><space>", Util.telescope.git_files, desc = "Git files" },
      --   { "<leader>rr", Util.telescope.builtin("commands"), desc = "Run commands" },
      --   { "<leader>sf", Util.telescope.find_files, desc = "Find files" },
      --   {
      --     "<leader>sh",
      --     Util.telescope.builtin("help_tags"),
      --     desc = "Help Pages",
      --   },
      --   {
      --     "<leader>sk",
      --     Util.telescope.builtin("keymaps"),
      --     desc = "Key Maps",
      --   },
      --   {
      --     "<leader>sm",
      --     Util.telescope.builtin("marks"),
      --     desc = "Marks",
      --   },
      --   {
      --     "<leader>sg",
      --     Util.telescope.builtin("live_grep"),
      --     desc = "Grep workspace",
      --   },
      --   {
      --     "<leader>sG",
      --     function()
      --       Util.telescope.builtin("current_buffer_fuzzy_find")({ skip_empty_lines = true })
      --     end,
      --     desc = "Find in buffer",
      --   },
      --
      --   {
      --     "<leader>sc",
      --     Util.telescope.builtin("resume"),
      --     desc = "Continue",
      --   },
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
      -- {
      --   "<leader>m",
      --   Util.telescope.terminals,
      --   desc = "Find terminals",
      -- },
      {
        "<leader>j",
        function()
          Util.telescope.builtin("buffers", { sort_lastused = true, sort_mru = true, only_cwd = false })
        end,
        desc = "Jump to buffer (all)",
      },
      -- {
      --   "<leader>k",
      --   function()
      --     Util.telescope.builtin("buffers", { sort_lastused = true, sort_mru = true, only_cwd = true })
      --   end,
      --   desc = "Jump to buffer (cwd)",
      -- },
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
}
