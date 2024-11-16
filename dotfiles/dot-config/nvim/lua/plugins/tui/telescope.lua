return {
  {
    "nvim-telescope/telescope.nvim",
    cmd = "Telescope",
    version = false,
    opts = {
      defaults = {
        mappings = {
          n = {
            ["q"] = function(prompt_bufnr)
              require("telescope.actions").close(prompt_bufnr)
            end,
            ["o"] = function(bufnr)
              require("telescope.actions.layout").toggle_preview(bufnr)
            end,
          },

          i = {
            ["<C-o>"] = function(bufnr)
              require("telescope.actions.layout").toggle_preview(bufnr)
            end,
          },
        },
        get_selection_window = function()
          -- open files in the first window that is an actual file.
          -- use the current window if no other window is available.
          local wins = vim.api.nvim_list_wins()
          table.insert(wins, 1, vim.api.nvim_get_current_win())
          for _, win in ipairs(wins) do
            local buf = vim.api.nvim_win_get_buf(win)
            if vim.bo[buf].buftype == "" then
              return win
            end
          end
          return 0
        end,
        results_title = false,
        sorting_strategy = "ascending",
        layout_strategy = "flex",
        layout_config = {
          anchor = "top",
          prompt_position = "top",
        },
      },
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
          entry_maker = function(opts)
            local make_display = function(entry)
              return require("telescope.pickers.entry_display").create({
                separator = "▏",
                items = {
                  { width = 100 },
                  { remaining = true },
                },
              })({
                { entry.name, "TelescopeResultsIdentifier" },
              })
            end

            return function(entry)
              return require("telescope.make_entry").set_default_entry_mt({
                name = entry.name,
                bang = entry.bang,
                nargs = entry.nargs,
                complete = entry.complete,
                definition = entry.definition,
                --
                value = entry,
                ordinal = entry.name,
                display = make_display,
              }, opts)
            end
          end,
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
      {
        "<leader>ss",
        function()
          require("telescope.builtin")["lsp_document_symbols"]()
        end,
        desc = "Symbols (Buffer)",
      },
      {
        "<leader>sS",
        function()
          require("telescope.builtin")["lsp_dynamic_workspace_symbols"]()
        end,
        desc = "Symbols (Workspace)",
      },
      {
        "<leader>j",
        function()
          require("telescope.builtin")["buffers"]({ sort_lastused = true, sort_mru = true, only_cwd = false })
        end,
        desc = "Jump to buffer (all)",
      },
      {
        "<leader>k",
        function()
          require("telescope.builtin")["buffers"]({ sort_lastused = true, sort_mru = true, only_cwd = true })
        end,
        desc = "Jump to buffer (cwd)",
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
}
