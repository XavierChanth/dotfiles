-- Bro this looks weird, but this is the only way to use ruff without pyright
-- with LazyVim... and I'm lazy so this is what we live with
-- Honestly... the python extra looks like two PRs were both opened and merged
-- at around the same time, these options make no sense relative to eachother

return {
  {
    "nvim-treesitter",
    opts = { ensure_installed = { "ninja", "rst" } },
  },
  {
    "nvim-cmp",
    opts = function(_, opts)
      opts.auto_brackets = opts.auto_brackets or {}
      table.insert(opts.auto_brackets, "python")
    end,
  },
  {
    "nvim-lspconfig",
    opts = {
      servers = {
        basedpyright = {},
        ruff = {
          cmd_env = { RUFF_TRACE = "messages" },
          init_options = {
            settings = {
              logLevel = "error",
            },
          },
          keys = {
            {
              "<leader>co",
              require("util.lsp").action["source.organizeImports"],
              desc = "Organize Imports",
            },
          },
        },
      },
      setup = {
        ruff = function()
          vim.api.nvim_create_autocmd("LspAttach", {
            callback = function(event)
              local client = vim.lsp.get_client_by_id(event.data.client_id)
              if client then
                -- Disable hover in favor of Pyright
                client.server_capabilities.hoverProvider = false
              end
            end,
          })
        end,
      },
    },
  },
  -- Additional plugins
  {
    "linux-cultist/venv-selector.nvim",
    branch = "regexp", -- Use this branch for the new version
    cmd = "VenvSelect",
    opts = {
      settings = {
        options = {
          notify_user_on_venv_activation = true,
        },
      },
    },
    --  Call config for python files and load the cached venv automatically
    ft = "python",
    keys = { { "<leader>cv", "<cmd>:VenvSelect<cr>", desc = "Select VirtualEnv", ft = "python" } },
  },
}
