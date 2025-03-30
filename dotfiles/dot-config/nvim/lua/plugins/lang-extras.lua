return {
  -- schemas
  {
    "b0o/SchemaStore.nvim",
    lazy = true,
    version = false, -- last release is way too old
  },
  -- csharp
  { "Hoffs/omnisharp-extended-lsp.nvim", lazy = true },
  { "Decodetalkers/csharpls-extended-lsp.nvim" },

  -- justfiles
  { "NoahTheDuke/vim-just", event = "BufReadPre justfile" },

  -- kmonad
  { "kmonad/kmonad-vim", event = "BufReadPre *.kbd" },

  -- lua
  { "Bilal2453/luvit-meta", lazy = true },
  {
    "folke/lazydev.nvim",
    ft = "lua",
    cmd = "LazyDev",
    opts = {
      library = {
        { path = "luvit-meta/library", words = { "vim%.uv" } },
        { path = "LazyVim", words = { "LazyVim" } },
        { path = "lazy.nvim", words = { "LazyVim" } },
      },
    },
  },

  -- rust
  {
    "Saecki/crates.nvim",
    event = { "BufRead Cargo.toml" },
    opts = {
      completion = {
        crates = {
          enabled = true,
        },
      },
      lsp = {
        enabled = true,
        actions = true,
        completion = true,
        hover = true,
      },
    },
  },

  -- go
  {
    "maxandron/goplements.nvim",
    ft = "go",
    opts = {
      -- The prefixes prepended to the type names
      prefix = {
        interface = "implemented by: ",
        struct = "implements: ",
      },
      -- Whether to display the package name along with the type name (i.e., builtins.error vs error)
      display_package = false,
    },
  },

  -- python
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
