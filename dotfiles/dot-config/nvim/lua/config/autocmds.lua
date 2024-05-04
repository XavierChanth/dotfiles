-- Autocmds are automatically loaded on the VeryLazy event
-- Default autocmds that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/autocmds.lua
-- Add any additional autocmds here

local lazy_cmds = vim.api.nvim_create_augroup("lazy_cmds", { clear = true })
local snapshot_dir = vim.fn.stdpath("data") .. "/plugin-snapshot"
local lockfile = vim.fn.stdpath("config") .. "/lazy-lock.json"

-- LazyVim Snapshots on Update
vim.api.nvim_create_autocmd("User", {
  group = lazy_cmds,
  pattern = "LazyUpdatePre",
  desc = "Backup lazy.nvim lockfile",
  callback = function(_)
    vim.fn.mkdir(snapshot_dir, "p")
    local snapshot = snapshot_dir .. os.date("/%Y-%m-%dT%H:%M:%S.json")

    vim.loop.fs_copyfile(lockfile, snapshot)
  end,
})
-- Browse Snapshots with :LazySnapshots
vim.api.nvim_create_user_command("LazySnapshots", "edit " .. snapshot_dir, {})
