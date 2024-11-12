return {
  {
    "nvimdev/dashboard-nvim",
    cmd = "Dashboard",
    lazy = vim.fn.argc(-1) ~= 0,
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
          header = vim.split("\n\n" .. Util.logo .. "\n\n", "\n"),
          center = Util.dashboard.actions,
        },
      }
    end,
  },
  Util.statusline.dependencies,
  Util.statusline.slimline,
}
