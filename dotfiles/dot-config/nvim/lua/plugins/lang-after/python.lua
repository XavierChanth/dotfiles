return {
  require("util.lazy").ensure_installed({
    treesitter = { "python", "ninja", "rst" },
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
      override_on_attach = {
        ruff = function(client, event)
          vim.api.nvim_buf_set_var(event.buf, "shiftwidth", 4)
          vim.api.nvim_buf_set_var(event.buf, "tabstop", 4)
          -- Disable hover in favor of Pyright
          client.server_capabilities.hoverProvider = false
        end,
      },
      -- if you set an on_attach for basedpyright here make sure
      -- it doesn't override / get overridden by ipynb config
    },
  },
  -- Additional plugins
  {
    "linux-cultist/venv-selector.nvim",
    branch = "regexp",
    ft = "python",
    cmd = "VenvSelect",
    keys = {
      { "<leader>cv", "<cmd>:VenvSelect<cr>", desc = "Select VirtualEnv", ft = "python" },
    },
    opts = {
      settings = {
        options = {
          on_venv_activate_callback = nil, -- callback function for after a venv activates
          enable_default_searches = true, -- switches all default searches on/off
          enable_cached_venvs = true, -- use cached venvs that are activated automatically when a python file is registered with the LSP.
          cached_venv_automatic_activation = false, -- if set to false, the VenvSelectCached command becomes available to manually activate them.
          activate_venv_in_terminal = true, -- activate the selected python interpreter in terminal windows opened from neovim
          set_environment_variables = true, -- sets VIRTUAL_ENV or CONDA_PREFIX environment variables
          notify_user_on_venv_activation = true, -- notifies user on activation of the virtual env
          search_timeout = 5, -- if a search takes longer than this many seconds, stop it and alert the user
          fd_binary_name = "fd", -- plugin looks for `fd` or `fdfind` but you can set something else here
          require_lsp_activation = false, -- require activation of an lsp before setting env variables
        },
      },
    },
  },
}
