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
-- disabled this, it can actually be quite annoying in some languages, you can always use f/t motions to deal with individual segments of a word
-- vim.opt.iskeyword = "@,48-57,192-255" -- default, but underscore removed

vim.opt.showbreak = "  󱞩 "
-- vim.opt.cmdheight = 0
vim.opt.number = true
vim.opt.relativenumber = true
vim.opt.signcolumn = "yes"
vim.opt.laststatus = 3
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
vim.opt.wildmenu = true
vim.opt.wildmode = "noselect:longest:lastused,full" -- Command-line completion mode
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

-- Non-vim options
vim.g.bullets_enabled_file_types = { "markdown" }
vim.g.bullets_outline_levels = { "num", "abc", "std-" }
vim.g.bullets_checkbox_markers = " x"
