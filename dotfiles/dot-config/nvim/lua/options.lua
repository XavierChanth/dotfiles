local g = vim.g

g.mapleader = " "
g.maplocalleader = "\\"

local opt = vim.opt

-- BUFFER
opt.autowrite = true
opt.confirm = true

-- OS BINDINGS
opt.clipboard = "unnamedplus"
if vim.env.SSH_TTY and not vim.env.TMUX then
  opt.clipboard = ""
end
opt.grepprg = "rg --vimgrep"
opt.grepformat = "%f:%l:%c:%m"

-- CURSOR
opt.cursorline = true
opt.mouse = "a"
opt.virtualedit = "block" -- Allow cursor to move where there is no text in visual block mode
opt.smoothscroll = true

-- UI - EDITOR
-- opt.colorcolumn = "81,121"
opt.conceallevel = 2
opt.fillchars = {
  foldopen = "",
  foldclose = "",
  fold = " ",
  foldsep = " ",
  diff = "╱",
  eob = " ",
}
opt.list = true
opt.listchars = {
  -- eol = "",
  tab = "┆ ",
  space = "·",
  lead = " ",
  trail = "●",
  extends = "…",
  precedes = "…",
}

opt.showbreak = "󱞩 "
opt.showmode = false

-- UI - BARS
opt.number = true
opt.relativenumber = true
opt.signcolumn = "yes"
opt.laststatus = 3

-- UI - OTHER
opt.termguicolors = true -- True color support
opt.winminwidth = 5 -- Minimum window width
opt.completeopt = "menu,menuone,preview,noselect,noinsert"

-- WHITESPACE / LINES
opt.expandtab = true
opt.linebreak = true
opt.shiftround = true
opt.shiftwidth = 2
opt.tabstop = 2
-- opt.wrap = false -- Disable line wrap

-- FOLDS
opt.foldlevel = 99

-- FORMATTING
opt.formatoptions = "jcroqlnt"

-- CMP
opt.pumblend = 10
opt.pumheight = 10
opt.wildmode = "longest:full,full" -- Command-line completion mode

-- SESSION
opt.sessionoptions = { "buffers", "curdir", "tabpages", "winsize", "help", "globals", "skiprtp", "folds" }

-- CONVENIENCE
opt.inccommand = "nosplit"
opt.ignorecase = true
opt.jumpoptions = "view"
opt.shortmess:append({ W = true, I = true, c = true, C = true })
opt.scrolloff = 8
opt.sidescrolloff = 8
opt.smartcase = true
opt.smartindent = true
opt.smarttab = true

-- SPELLING
opt.spelllang = { "en" }
opt.spelloptions:append("noplainbuffer")

-- SPLITS
opt.splitbelow = true
opt.splitkeep = "screen"
opt.splitright = true

-- TIMEOUTS
opt.timeoutlen = vim.g.vscode and 1000 or 300 -- Lower than default (1000) to quickly trigger which-key
opt.ttimeout = false
opt.updatetime = 200 -- Save swap file and trigger CursorHold

-- UNDO
opt.undofile = true
opt.undolevels = 10000

-- JUMPLIST
opt.jumpoptions = "clean,stack"
