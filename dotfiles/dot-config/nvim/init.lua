-- Bootstrap lazy.nvim
local lazypath = vim.fn.stdpath("data") .. "/nvim/lazy/lazy.nvim"
if not (vim.uv or vim.loop).fs_stat(lazypath) then
  local lazyrepo = "https://github.com/folke/lazy.nvim.git"
  local out = vim.fn.system({
    "git",
    "clone",
    "--filter=blob:none",
    "--branch=stable",
    lazyrepo,
    lazypath,
  })
  if vim.v.shell_error ~= 0 then
    vim.api.nvim_echo({
      { "Failed to clone lazy.nvim:\n", "ErrorMsg" },
      { out, "WarningMsg" },
      { "\nPress any key to exit..." },
    }, true, {})
    vim.fn.getchar()
    os.exit(1)
  end
end
vim.opt.rtp:prepend(lazypath)

P = function(...)
  vim.print(vim.inspect(...))
end

vim.g.mapleader = " "
vim.g.maplocalleader = "\\"

-- OPTIONS
vim.opt.confirm = true
vim.opt.clipboard = "unnamedplus"
if vim.env.SSH_TTY and not vim.env.TMUX then
  vim.opt.clipboard = ""
end
vim.opt.grepprg = "rg --vimgrep"
vim.opt.grepformat = "%f:%l:%c:%m"
vim.opt.virtualedit = "block"
vim.opt.conceallevel = 2
vim.opt.fillchars = {
  foldopen = "",
  foldclose = "",
  fold = " ",
  foldsep = " ",
  diff = "╱",
  eob = " ",
}
vim.opt.list = true
vim.opt.listchars = {
  -- eol = "",
  tab = "┆ ",
  space = "·",
  lead = " ",
  trail = "●",
  extends = "…",
  precedes = "…",
}

vim.opt.showbreak = "  󱞩 "
-- vim.opt.cmdheight = 0
vim.opt.number = true
vim.opt.relativenumber = true
vim.opt.signcolumn = "yes"
vim.opt.laststatus = 3
vim.opt.termguicolors = true -- True color support
vim.opt.completeopt = "menu,menuone,popup,noselect,noinsert"
vim.opt.expandtab = true
vim.opt.linebreak = true
vim.opt.shiftround = true
vim.opt.shiftwidth = 2
vim.opt.tabstop = 2
vim.opt.foldlevel = 99
vim.opt.formatoptions = "jcroqlnt"
vim.opt.pumblend = 0
vim.opt.pumheight = 10
vim.opt.wildmode = "longest:full,full" -- Command-line completion mode
vim.opt.sessionoptions = {
  "buffers",
  "curdir",
  "tabpages",
  "winsize",
  "help",
  "globals",
  "skiprtp",
  "folds",
}
vim.opt.ignorecase = true
vim.opt.jumpoptions = "clean,stack"
vim.opt.shortmess = "ltToOcCFI"
vim.opt.scrolloff = 4
vim.opt.smartcase = true
vim.opt.smartindent = true
vim.opt.smarttab = true
vim.opt.spelllang = { "en" }
vim.opt.spelloptions:append("noplainbuffer")
vim.opt.splitbelow = true
vim.opt.splitkeep = "topline"
vim.opt.splitright = true
-- vim.opt.timeoutlen = 1000
-- vim.opt.ttimeout = false
vim.opt.undofile = true
vim.opt.undolevels = 10000

-- Filetypes
vim.filetype.add({
  extension = {
    xaml = "xml",
  },
  filename = {},
})

-- Autocmds

-- Reload file on context change
vim.api.nvim_create_autocmd({ "FocusGained", "TermClose", "TermLeave" }, {
  callback = function()
    if vim.o.buftype ~= "nofile" then
      vim.cmd("checktime")
    end
  end,
})

-- Highlight on yank
vim.api.nvim_create_autocmd("TextYankPost", {
  callback = function()
    vim.highlight.on_yank()
  end,
})

-- resize splits if window got resized
vim.api.nvim_create_autocmd({ "VimResized" }, {
  callback = function()
    local current_tab = vim.fn.tabpagenr()
    vim.cmd("tabdo wincmd =")
    vim.cmd("tabnext " .. current_tab)
  end,
})

-- go to last cursor pos when opening a buffer
vim.api.nvim_create_autocmd("BufReadPost", {
  callback = function(event)
    local exclude = { "gitcommit" }
    local buf = event.buf
    if
      vim.tbl_contains(exclude, vim.bo[buf].filetype)
      or vim.b[buf].lazyvim_last_loc
    then
      return
    end
    vim.b[buf].lazyvim_last_loc = true
    local mark = vim.api.nvim_buf_get_mark(buf, '"')
    local lcount = vim.api.nvim_buf_line_count(buf)
    if mark[1] > 0 and mark[1] <= lcount then
      pcall(vim.api.nvim_win_set_cursor, 0, mark)
    end
  end,
})

-- Auto create dir when saving a file, in case some intermediate directory does not exist
vim.api.nvim_create_autocmd({ "BufWritePre" }, {
  callback = function(event)
    if event.match:match("^%w%w+:[\\/][\\/]") then
      return
    end
    local file = vim.uv.fs_realpath(event.match) or event.match
    vim.fn.mkdir(vim.fn.fnamemodify(file, ":p:h"), "p")
  end,
})

-- LAZY CONFIG
local lazy_config = {
  checker = { enabled = false }, -- disable check for updates
  change_detection = { enabled = false },
  defaults = {
    lazy = true,
    version = "*",
  },
  -- dev = {
  --   -- To add a plugin to this folder use the following command
  --   -- ln -s /path/to/plugin/worktree ~/src/xc/local_nvim_plugins/plugin_name
  --   path = "~/src/xc/local_nvim_plugins",
  --   -- which plugins should be pulled locally
  --   patterns = { "xavierchanth" },
  --   fallback = true,
  -- },
  install = {
    missing = false,
    colorscheme = { "retrobox", "unokai", "habamax" },
  },
  performance = {
    rtp = {
      disabled_plugins = { "matchit", "netrwPlugin", "tutor" },
    },
  },
  rocks = { hererocks = false },
  ui = { border = "none", size = { width = 1, height = 1 } },
}

-- KEYMAPS
vim.keymap.set({ "n", "v" }, "<leader>", "")
vim.keymap.set({ "i", "n" }, "<esc>", "<cmd>noh<cr><esc>")

vim.keymap.set(
  { "n", "x" },
  "j",
  "v:count == 0 ? 'gj' : 'j'",
  { expr = true, silent = true }
)
vim.keymap.set(
  { "n", "x" },
  "k",
  "v:count == 0 ? 'gk' : 'k'",
  { expr = true, silent = true }
)

-- window maps
vim.keymap.set("n", "<leader>w", "<c-w>", { remap = true })
vim.keymap.set("n", "<leader>-", "<C-W>s", { remap = true })
vim.keymap.set("n", "<leader>\\", "<C-W>v", { remap = true })

-- Better indenting
vim.keymap.set("v", "<", "<gv")
vim.keymap.set("v", ">", ">gv")

-- Better search
-- https://github.com/mhinz/vim-galore#saner-behavior-of-n-and-n
vim.keymap.set(
  { "n", "x", "o" },
  "n",
  "'Nn'[v:searchforward].'zv'",
  { expr = true }
)
vim.keymap.set(
  { "n", "x", "o" },
  "N",
  "'nN'[v:searchforward].'zv'",
  { expr = true }
)

-- Escape behaviors
vim.keymap.set("t", "<ESC><ESC>", "<C-\\><C-n>", { noremap = true })
vim.keymap.set("t", "<S-Space>", "<Space>", { noremap = true })

-- Undo break points
vim.keymap.set("i", ",", ",<c-g>u")
vim.keymap.set("i", ".", ".<c-g>u")
vim.keymap.set("i", ";", ";<c-g>u")

-- PLUGINS

local FILE = { "BufReadPost", "BufNewFile", "BufReadPre" }
local LAZYFILE = { "BufReadPost", "BufNewFile", "BufReadPre", "VeryLazy" }

-- Here we define:
-- - how plugins load
-- - how they are built
-- - how they are loaded (event, ft)
-- keys and cmd go in the other config
lazy_config.spec = {
  -- LIBS
  { "nvim-lua/plenary.nvim", version = false },
  { "MunifTanjim/nui.nvim" },
  { "williamboman/mason.nvim", build = ":MasonUpdate" },

  -- ESSENTIAL
  { "stevearc/oil.nvim", lazy = vim.fn.argc(-1) == 0 },
  "christoomey/vim-tmux-navigator",

  -- QOL
  { "folke/persistence.nvim", event = "BufReadPre" },
  { "folke/snacks.nvim", priority = 1000, lazy = false },
  "MagicDuck/grug-far.nvim",

  -- MOTIONS
  { "folke/flash.nvim", event = "VeryLazy" },
  {
    "echasnovski/mini.ai",
    event = "VeryLazy",
    dependencies = {
      "echasnovski/mini.extra",
    },
  },

  -- GIT
  -- { "julienvincent/hunk.nvim", cmd = "DiffEditor" },
  "FabijanZulj/blame.nvim",
  "echasnovski/mini.diff",

  -- CORE LANG
  {
    "saghen/blink.cmp",
    event = "InsertEnter",
    dependencies = {
      "rafamadriz/friendly-snippets",
    },
  },
  { "stevearc/conform.nvim", event = FILE },
  { "mfussenegger/nvim-lint", event = FILE },
  {
    "nvim-treesitter/nvim-treesitter",
    version = false,
    lazy = vim.fn.argc(-1) == 0,
    event = LAZYFILE,
    build = ":TSUpdate",
  },
  { "nvim-treesitter/nvim-treesitter-textobjects", event = "VeryLazy" },
  { "windwp/nvim-ts-autotag", event = FILE },
  { "folke/ts-comments.nvim", event = "VeryLazy" },
  "folke/trouble.nvim",
  { "folke/todo-comments.nvim", event = FILE },

  -- THEME
  { "sschleemilch/slimline.nvim", event = "VeryLazy" },
  { "echasnovski/mini.icons", lazy = true },
  "folke/tokyonight.nvim",
  "catppuccin/nvim",

  -- AI
  { "CopilotC-Nvim/CopilotChat.nvim", build = "make tiktoken" },
  { "ravitemer/mcphub.nvim", build = "bundled_build.lua" },

  -- HANDY
  { "m00qek/baleia.nvim" },
  { "lukas-reineke/virt-column.nvim", event = FILE },

  -- LANG SPECIFIC
  { "b0o/SchemaStore.nvim", version = false },
  { "Hoffs/omnisharp-extended-lsp.nvim", lazy = true },
  { "Decodetalkers/csharpls-extended-lsp.nvim", ft = "c_sharp" },
  { "NoahTheDuke/vim-just", event = "BufReadPre justfile" },
  { "kmonad/kmonad-vim", event = "BufReadPre *.kbd" },
  { "Bilal2453/luvit-meta", lazy = true, ft = "lua" },
  { "folke/lazydev.nvim", ft = "lua" },
  { "Saecki/crates.nvim", event = { "BufRead Cargo.toml" } },
  { "maxandron/goplements.nvim", ft = "go" },
  { "linux-cultist/venv-selector.nvim", branch = "regexp", ft = "python" },
  { "chomosuke/typst-preview.nvim", cmd = "TypstPreview", ft = "typst" },

  -- MARKDOWN
  { "masukomi/vim-markdown-folding", ft = "markdown" },
  { "MeanderingProgrammer/render-markdown.nvim", ft = "markdown" },
  {
    "iamcco/markdown-preview.nvim",
    ft = "markdown",
    build = function()
      require("lazy").load({ plugins = { "markdown-preview.nvim" } })
      vim.fn["mkdp#util#install"]()
    end,
  },
  { "bullets-vim/bullets.vim", ft = "markdown" },

  -- REMOVE?
  { "ThePrimeagen/harpoon", branch = "harpoon2" },
  "jiaoshijie/undotree",
}

local mason_packages = {
  "asm-lsp",
  "basedpyright",
  "clangd",
  "csharp-language-server",
  "csharpier",
  "docker-compose-language-service",
  "dockerfile-language-server",
  "gersemi",
  "gofumpt",
  "goimports",
  "gopls",
  "hadolint",
  "json-lsp",
  "lua-language-server",
  "neocmakelsp",
  "omnisharp",
  "prettier",
  "pymarkdownlnt",
  "rubocop",
  "ruby-lsp",
  "ruff",
  "rust-analyzer",
  "shellcheck",
  "shfmt",
  "stylua",
  "tailwindcss-language-server",
  "tinymist",
  "vtsls",
  "yaml-language-server",
  "zls",
}
vim.api.nvim_create_autocmd("User", {
  pattern = "VeryLazy",
  callback = function()
    require("mason-installer").install_packages(mason_packages)
  end,
})

lazy_config.spec[#lazy_config.spec + 1] = require("config")
require("lazy").setup(lazy_config)
require("lsp")

-- Colorscheme
vim.api.nvim_create_autocmd("User", {
  pattern = "VeryLazy",
  callback = function()
    if not require("platform").is_windows() then
      require("colorscheme-timer").start(3000)
    end
  end,
})
vim.api.nvim_create_autocmd("ColorScheme", {
  pattern = "*",
  command = "highlight Normal ctermbg=NONE guibg=NONE",
})
