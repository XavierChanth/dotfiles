local logo = Util.logos["nvim_sharp"]
return {
  {
    "nvimdev/dashboard-nvim",
    cmd = "Dashboard",
    lazy = false,
    cond = not (vim.g.no_dashboard or false),
    opts = function()
      if vim.o.filetype == "lazy" then
        vim.api.nvim_create_autocmd("WinClosed", {
          pattern = tostring(vim.api.nvim_get_current_win()),
          once = true,
          callback = function()
            vim.schedule(function()
              vim.api.nvim_exec_autocmds("UIEnter", { group = "dashboard" })
            end)
          end,
        })
      end
      return {
        theme = "doom",
        config = {
          header = vim.split("\n\n" .. logo .. "\n\n", "\n"),
          center = Util.dashboard.actions,
        },
      }
    end,
  },
  -- Load both statuslines so Lazy doesn't try to clean them
  "nvim-lualine/lualine.nvim",
  "sschleemilch/slimline.nvim",
  -- Explicitly configure and activate the one in use
  Util.statusline.slimline,
}
