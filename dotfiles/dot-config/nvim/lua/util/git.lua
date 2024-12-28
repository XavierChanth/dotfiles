---@class util.git
local M = {}

function M.keymaps()
  local map = vim.keymap.set
  map("n", "<leader>gl", function()
    Util.floats.lazygit()
  end, { desc = "LazyGit" })
  map("n", "<leader>gg", function()
    vim.system({ Util.platform.home .. "/.local/bin/jj-term" })
  end, { desc = "JJ terminal" })
  map("n", "<leader>gh", function()
    local opts = { args = { "-f", vim.fn.expand("%") } }
    Util.floats.lazygit(opts)
  end, { desc = "Commit history (file)" })
  map("n", "<leader>gH", function()
    local opts = { args = { "-f", "*" } }
    Util.floats.lazygit(opts)
  end, { desc = "Commit history" })
  map("n", "<leader>gb", M.browse, { desc = "Browse repo" })
  map("n", "<leader>gp", M.prs, { desc = "Pull requests" })
  map("n", "<leader>gi", M.issues, { desc = "Issues" })
end

function M.prs()
  vim.fn.jobstart("gh pr list --web", { detach = true })
end

function M.issues()
  vim.fn.jobstart("gh issues list --web", { detach = true })
end

function M.browse()
  Snacks.gitbrowse()
end
return M
