local any = vim.version.range("*")
-- data.config is a require path to a script which will load plugin config
return {
  -- Loads during init.lua
  init = {
    {
      src = "https://github.com/nvim-lua/plenary.nvim",
      version = nil,
    },
    {
      src = "https://github.com/MunifTanjim/nui.nvim",
      version = any,
    },
    {
      src = "https://github.com/stevearc/oil.nvim",
      version = any,
      data = { config = "config/oil" },
    },
    {
      src = "https://github.com/christoomey/vim-tmux-navigator",
      version = any,
    },
    {
      src = "https://github.com/folke/persistence.nvim",
      version = any,
      data = { config = "config/persistence" },
    },
    {
      src = "https://github.com/folke/snacks.nvim",
      version = any,
      data = {
        config = "config/snacks",
      },
    },
    {
      src = "https://github.com/ThePrimeagen/harpoon",
      version = "harpoon2",
      data = { config = "config/harpoon" },
    },
    {
      src = "https://github.com/echasnovski/mini.icons",
      version = any,
      data = { config = "config/mini-icons" },
    },
    {
      src = "https://github.com/rafamadriz/friendly-snippets",
      verison = any,
    },
    {
      src = "https://github.com/saghen/blink.cmp",
      version = any,
      data = { config = "config/cmp" },
    },
    {
      src = "https://github.com/stevearc/conform.nvim",
      version = any,
      data = { config = "config/conform" },
    },
    {
      src = "https://github.com/mfussenegger/nvim-lint",
      version = any,
      data = { config = "config/lint" },
    },
    {
      src = "https://github.com/nvim-treesitter/nvim-treesitter",
      version = nil,
      data = {
        build = function()
          vim.cmd("TSUpdate")
        end,
        config = "config/treesitter",
      },
    },
    {
      src = "https://github.com/nvim-treesitter/nvim-treesitter-textobjects",
      version = nil,
    },
    { -- Needed by LSP, could make this lazy but it would be pain.
      src = "https://github.com/b0o/SchemaStore.nvim",
      version = nil,
    },
  },
  -- Loads on VimEnter
  lazy = {
    { -- Needed by pick, ai
      src = "https://github.com/echasnovski/mini.extra",
      version = any,
    },
    {
      src = "https://github.com/sschleemilch/slimline.nvim",
      version = any,
      data = { config = "config/slimline" },
    },
    {
      src = "https://github.com/echasnovski/mini.ai",
      version = any,
      data = { config = "config/mini-ai" },
    },
    {
      src = "https://github.com/MagicDuck/grug-far.nvim",
      version = any,
      data = { config = "config/grug" },
    },
    {
      src = "https://github.com/echasnovski/mini.diff",
      version = any,
      data = { config = "config/mini-diff" },
    },
    -- {
    --   src = "https://github.com/sudo-tee/opencode.nvim",
    --   version = nil,
    --   data = { config = "config/opencode" },
    -- },
    -- {
    --   src = "https://github.com/carlos-algms/agentic.nvim",
    --   version = nil,
    --   data = { config = "config/agentic" },
    -- },
    -- {
    --   src = "https://github.com/ThePrimeagen/99",
    --   version = nil,
    --   data = { config = "config/99" },
    -- },
  },
  -- Loads on specific file type
  ft = {
    cs = {
      {
        src = "https://github.com/Hoffs/omnisharp-extended-lsp.nvim",
        version = nil,
      },
      {
        src = "https://github.com/Decodetalkers/csharpls-extended-lsp.nvim",
        version = any,
      },
    },
    just = {
      { src = "https://github.com/NoahTheDuke/vim-just", version = nil },
    },
    lua = {
      {
        src = "https://github.com/folke/lazydev.nvim",
        version = any,
        data = { config = "config/lazydev" },
      },
    },
    rust = {
      {
        src = "https://github.com/Saecki/crates.nvim",
        version = any,
        data = { config = "config/crates" },
      },
    },
    go = {
      {
        src = "https://github.com/maxandron/goplements.nvim",
        version = nil,
        data = { config = "config/goplements" },
      },
    },
    python = {
      {
        src = "https://github.com/linux-cultist/venv-selector.nvim",
        version = "main",
        data = { config = "config/venv-selector" },
      },
    },
    swayconfig = {
      {
        src = "https://github.com/jamespeapen/swayconfig.vim",
        version = nil,
      },
    },
    typst = {
      {
        src = "https://github.com/chomosuke/typst-preview.nvim",
        version = any,
      },
    },
    markdown = {
      {
        src = "https://github.com/MeanderingProgrammer/render-markdown.nvim",
        version = any,
        data = {
          config = "config/render-markdown",
        },
      },
      {
        src = "https://github.com/bullets-vim/bullets.vim",
        version = any,
      },
    },
  },
}
