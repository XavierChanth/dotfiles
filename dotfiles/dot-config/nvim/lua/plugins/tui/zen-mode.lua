local zen_loaded = false
return {
  "folke/zen-mode.nvim",
  opts = {
    window = {
      width = function()
        local wininfo = vim.fn.getwininfo(vim.fn.win_getid())
        if not (wininfo and wininfo[1]) then
          vim.notify("Failed to get wininfo", vim.log.levels.WARN)
          return
        end
        local width = wininfo[1].width
        return vim.fn.max({
          vim.fn.floor(width / 2),
          121 + wininfo[1].textoff,
        })
      end,
    },
    plugins = {
      options = { laststatus = nil },
      tmux = { enabled = false },
    },
  },
  keys = {
    {
      "<leader>uz",
      function()
        if not zen_loaded then
          vim.api.nvim_create_autocmd("User", {
            pattern = "PersistenceSavePre",
            callback = require("zen-mode").close,
          })
          zen_loaded = true
        end
        require("zen-mode").toggle()
      end,
      desc = "Toggle Zen Mode",
    },
  },
}
