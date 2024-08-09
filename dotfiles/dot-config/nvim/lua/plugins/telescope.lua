local telescope = require("util.telescope")
local actions = require("telescope.actions")
local action_state = require("telescope.actions.state")

return {
  {
    "nvim-telescope/telescope.nvim",
    dependencies = {
      "nvim-telescope/telescope-fzf-native.nvim",
      build = "make",
      config = function()
        require("telescope").load_extension("fzf")
      end,
    },
    keys = {
      {
        "<leader><space>",
        telescope.git_files,
        desc = "Git files",
      },
      {
        "<leader>ff",
        telescope.find_files,
        desc = "Find files",
      },
      {
        "<leader>fF",
        function()
          telescope.find_files({ cwd = vim.uv.cwd() })
        end,
        desc = "Find files",
      },
      {
        "<leader>fb",
        function()
          telescope.builtin("buffers", {})
        end,
        desc = "Find buffers",
      },
      { "<leader>ft", false },
      { "<leader>fT", false },
      {
        "<leader>j",
        function()
          telescope.builtin("buffers", {
            sort_lastused = true,
            sort_mru = true,
            attach_mappings = function(prompt_bufnr, map)
              map("n", "D", function()
                local current_picker = action_state.get_current_picker(prompt_bufnr)
                local multi_selections = current_picker:get_multi_selection()

                if next(multi_selections) == nil then
                  local selection = action_state.get_selected_entry()
                  actions.close(prompt_bufnr)
                  vim.api.nvim_buf_delete(selection.bufnr, {})
                else
                  actions.close(prompt_bufnr)
                  for _, selection in ipairs(multi_selections) do
                    vim.api.nvim_buf_delete(selection.bufnr, {})
                  end
                end
              end)
              return true
            end,
          })
        end,
        desc = "Jump to buffer (telescope)",
      },
      {
        "<leader>uC",
        function()
          local colors = require("colors")
          telescope.builtin("colorscheme", {
            finder = require("util.telescope").finder_from_table(colors.configured),
            enable_preview = true,
            attach_mappings = function(prompt_bufnr, _)
              actions.select_default:replace(function()
                actions.close(prompt_bufnr)
                colors.switch(action_state.get_selected_entry().value)
              end)
              return true
            end,
          })
        end,
        desc = "Colorscheme with Preview",
      },
    },
    opts = {
      defaults = telescope.defaults,
      pickers = {
        buffers = {
          initial_mode = "normal",
        },
        commands = {
          entry_maker = telescope.command.entry_maker({}),
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
  },
  {
    "debugloop/telescope-undo.nvim",
    keys = {
      {
        "<leader>uh",
        "<cmd>Telescope undo<cr>",
        desc = "undo history",
      },
    },
    config = function()
      require("telescope").load_extension("undo")
    end,
  },
  {
    "polarmutex/git-worktree.nvim",
    commit = "604ab2dd763776a36d1aad9fd81a3c513c1d4d94",
    keys = {
      {
        "<leader>ga",
        require("util.git_worktree").add,
        desc = "Git worktree add",
      },
      {
        "<leader>gw",
        require("util.git_worktree").telescope,
        desc = "Git worktrees",
      },
    },
    config = require("util.git_worktree").config,
  },
}
