-- which-key entries
if vim.g.vscode then
  return {}
end

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
map("n", "<leader>br", "<cmd>bd|e#<cr>", { desc = "Reload buffer" })

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

-- UNDO BREAKING POINTS
map("i", ",", ",<c-g>u")
map("i", ".", ".<c-g>u")
map("i", ";", ";<c-g>u")

-- MOVE LINES (visual mode)
map("v", "J", ":m '>+1<cr>gv=gv", { noremap = true, desc = "Move selected lines down" })
map("v", "K", ":m '<-2<cr>gv=gv", { noremap = true, desc = "Move selected lines up" })

-- LAZY
map("n", "<leader>l", "<cmd>Lazy<cr>", { desc = "Lazy" })

-- INDENTATION
local spaces = { 2, 4, 8 }
for _, indent in ipairs(spaces) do
  local str = tostring(indent)
  map("n", "<leader>c" .. str, function()
    vim.opt.tabstop = indent
    vim.opt.shiftwidth = indent
  end, { desc = str .. " spaces" })
end

return {
  {
    "folke/which-key.nvim",
    event = "VeryLazy",
    opts_extend = { "spec" },
    opts = {
      defaults = {},
      spec = {
        {
          mode = { "n", "v" },
          -- core groups
          { "g", group = "goto" },
          { "<leader>c", group = "code" },
          { "<leader>g", group = "git" },

          -- search groups
          { "<leader>f", group = "find" },
          { "<leader>s", group = "search" },
          { "<leader>r", group = "run", icon = { icon = " ", color = "orange" } },

          -- ui groups
          { "<leader>u", group = "ui", icon = { icon = "󰙵 ", color = "cyan" } },
          {
            "<leader>b",
            group = "buffer",
            -- expand = function()
            --   return require("which-key.extras").expand.buf()
            -- end,
          },
          {
            "<leader>w",
            group = "windows",
            proxy = "<c-w>",
            -- expand = function()
            --   return require("which-key.extras").expand.win()
            -- end,
          },
          { "<leader>t", group = "tabs" },

          -- Better descriptions
          { "gx",        desc = "Open with system app" },
        },
      },
    },
    keys = {
      {
        "<leader>?",
        function()
          require("which-key").show({ global = false })
        end,
        desc = "Buffer Keymaps (which-key)",
      },
      {
        "<c-w><space>",
        function()
          require("which-key").show({ keys = "<c-w>", loop = true })
        end,
        desc = "Window Hydra Mode (which-key)",
      },
    },
  },
}
