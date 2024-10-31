local map = vim.keymap.set

-- RESETS - modifies default keys with preferred behavior
-- Nicer j/k with wrapped lines
map({ "n", "x" }, "j", "v:count == 0 ? 'gj' : 'j'", { desc = "Down", expr = true, silent = true })
map({ "n", "x" }, "k", "v:count == 0 ? 'gk' : 'k'", { desc = "Up", expr = true, silent = true })

-- Better indenting
map("v", "<", "<gv")
map("v", ">", ">gv")

-- Better search
-- https://github.com/mhinz/vim-galore#saner-behavior-of-n-and-n
map({ "n", "x", "o" }, "n", "'Nn'[v:searchforward].'zv'", { expr = true, desc = "Next Search Result" })
map({ "n", "x", "o" }, "N", "'nN'[v:searchforward].'zv'", { expr = true, desc = "Prev Search Result" })

-- RELOADS
-- Clear search with <esc>
map({ "i", "n" }, "<esc>", "<cmd>noh<cr><esc>", { desc = "Escape and Clear hlsearch" })

-- Clear search, diff update and redraw
-- taken from runtime/lua/_editor.lua
map(
  "n",
  "<leader>ur",
  "<Cmd>nohlsearch<Bar>diffupdate<Bar>normal! <C-L><CR>",
  { desc = "Redraw / Clear hlsearch / Diff Update" }
)

-- BUFFERS
map("n", "<leader>bn", "<cmd>enew<cr>", { desc = "Buffer New" })
map("n", "<leader>bb", "<cmd>e#<cr>", { desc = "Switch to Other Buffer" })
map("n", "<leader>bd", "<cmd>bd<cr>", { desc = "Delete Buffer" })
map("n", "<leader>bD", "<cmd>:bd<cr>", { desc = "Delete Buffer and Window" })
map("n", "<leader>bo", "<cmd>%bd|e#|bd#<cr>", { desc = "Delete Other Buffers" })
map("n", "<leader>br", "<cmd>e<cr>", { desc = "Reload buffer" })

-- WINDOWS
map("n", "<leader>w", "<c-w>", { desc = "Windows", remap = true })
map("n", "<leader>-", "<C-W>s", { desc = "Split Window Below", remap = true })
map("n", "<leader>\\", "<C-W>v", { desc = "Split Window Right", remap = true })
map("n", "<leader>wd", "<C-W>c", { desc = "Delete Window", remap = true })
-- If I miss this I will add it back, I probably will...
-- LazyVim.toggle.map("<leader>wm", LazyVim.toggle.maximize)

-- TABS
map("n", "<leader>tc", "<cmd>tabnew<cr>", { desc = "Tab Create" })
map("n", "<leader>td", "<cmd>tabclose<cr>", { desc = "Close Tab" })
map("n", "<leader>to", "<cmd>tabonly<cr>", { desc = "Close Other Tabs" })
map("n", "<leader>th", "<cmd>tabnext -1<cr>", { desc = "Tab Left" })
map("n", "<leader>tl", "<cmd>tabnext<cr>", { desc = "Tab Right" })

if Util.platform.supports_terminal() then
  -- TERMINAL
  map("t", "<S-Space>", "<Space>", { desc = "which_key_ignore", noremap = true })
  map("t", "<c-_>", "<cmd>close<cr>", { desc = "Terminal (Close)" })
  map("n", "<c-_>", function()
    Util.terminal.toggle()
  end, { desc = "Terminal" })
  map("n", "<leader>E", function()
    Util.terminal("yazi", {})
  end, { desc = "Open Yazi" })
  map("n", "<leader>gg", function()
    Util.lazygit()
  end, { desc = "Lazygit" })
  map("n", "<leader>gb", function()
    Util.lazygit.blame_line()
  end, { desc = "Git blame" })

  -- LAZY
  map("n", "<leader>l", "<cmd>Lazy<cr>", { desc = "Lazy" })
end

-- UNDO BREAKING POINTS
map("i", ",", ",<c-g>u")
map("i", ".", ".<c-g>u")
map("i", ";", ";<c-g>u")

-- MOVE LINES (visual mode)
map("v", "J", ":m '>+1<cr>gv=gv", { noremap = true, desc = "Move selected lines down" })
map("v", "K", ":m '<-2<cr>gv=gv", { noremap = true, desc = "Move selected lines up" })


-- INDENTATION
local spaces = { 2, 4, 8 }
for _, indent in ipairs(spaces) do
  local str = tostring(indent)
  map("n", "<leader>c" .. str, function()
    vim.opt_local.shiftwidth = indent
    vim.opt_local.tabstop = indent
  end, { desc = str .. " spaces" })
end

return {}
