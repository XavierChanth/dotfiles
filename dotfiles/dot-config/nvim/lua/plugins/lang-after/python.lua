return {
  require("util.lazy").ensure_installed({
    treesitter = { "ninja", "rst" },
    lsp = { "ruff", "basedpyright" },
  }),
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
                vim.opt_local.tabstop = 4
                vim.opt_local.shiftwidth = 4
                -- Disable hover in favor of Pyright
                client.server_capabilities.hoverProvider = false
              end
            end,
          })
        end,
        basedpyright = function()
          vim.api.nvim_create_autocmd("LspAttach", {
            callback = function(event)
              local filename = vim.api.nvim_buf_get_name(event.buf)
              local ft = vim.api.nvim_buf_get_var(event.buf, "filetype")
              local client = vim.lsp.get_client_by_id(event.data.client_id)
              if client and (ft == "quarto" or #filename:match("*.ipynb") > 0) then
                --FIXME
                client.settings.basedpyright.analysis.diagnosticSeverityOverrides.reportUnusedExpression = "none"
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
