local telescope = require("util.telescope")
return {
  {
    "nvim-telescope/telescope.nvim",
    cmd = "Telescope",
    opts = {
      defaults = telescope.defaults,
      pickers = {
        buffers = {
          initial_mode = "normal",
          mappings = {
            n = {
              ["<C-d>"] = function(prompt_bufnr)
                local actions = require("telescope.actions")
                local action_state = require("telescope.actions.state")

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
                return true
              end,
            },
          },
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
    keys = {
      { "<leader><space>", telescope.git_files, desc = "Git files" },
      { "<leader>ff", telescope.find_files, desc = "Find files" },
      {
        "<leader>sh",
        function()
          telescope.builtin("help_tags")
        end,
        desc = "Help Pages",
      },
      {
        "<leader>sk",
        function()
          telescope.builtin("keymaps")
        end,
        desc = "Key Maps",
      },
      {
        "<leader>sm",
        function()
          telescope.builtin("marks")
        end,
        desc = "Jump to Mark",
      },
      {
        "<leader>sg",
        function()
          telescope.builtin("live_grep")
        end,
        desc = "Grep (Root Dir)",
      },
      {
        "<leader>sc",
        function()
          telescope.builtin("resume")
        end,
        desc = "Continue (resume)",
      },
      {
        "<leader>ss",
        function()
          telescope.builtin("lsp_document_symbols")
        end,
        desc = "Goto Symbol",
      },
      {
        "<leader>sS",
        function()
          telescope.builtin("lsp_dynamic_workspace_symbols")
        end,
        desc = "Goto Symbol (Workspace)",
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
          telescope.builtin("buffers")
        end,
        desc = "Find buffers",
      },
      { "<leader>,", false },
      {
        "<leader>m",
        function()
          require("util.telescope").terminals()
        end,
        desc = "Find terminals",
      },
      {
        "<leader>j",
        function()
          telescope.builtin("buffers", {
            sort_lastused = true,
            sort_mru = true,
          })
        end,
        desc = "Jump to buffer",
      },
      {
        "<leader>uc",
        function()
          local colors = require("util.colorscheme")
          telescope.builtin("colorscheme", {
            finder = require("util.telescope").finder_from_table(colors.configured),
            enable_preview = true,
            attach_mappings = function(prompt_bufnr, _)
              local actions = require("telescope.actions")
              local action_state = require("telescope.actions.state")

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
      {
        "<leader>uh",
        "<cmd>Telescope undo<cr>",
        desc = "undo history",
      },
    },
    dependencies = {
      {
        "nvim-telescope/telescope-fzf-native.nvim",
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
      },
    },
  },
}
