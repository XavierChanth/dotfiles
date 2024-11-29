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
  {
    "sschleemilch/slimline.nvim",
    event = "VeryLazy",
    opts = {
      style = "fg",
      spaces = { left = "", right = "" },
      sep = {
        hide = { first = true, last = true },
        left = "",
        right = "",
      },
      components = {
        left = {
          "mode",
          "path",
          Util.statusline.branch_component,
        },
        right = {
          Util.statusline.command_component,
          Util.statusline.mode_component,
          "diagnostics",
          Util.statusline.python_kernel_component,
          "filetype_lsp",
          "progress",
        },
      },
      hl = {
        modes = {
          normal = "MiniIconsBlue",
          insert = "MiniIconsGreen",
          pending = "MiniIconsRed",
          visual = "MiniIconsPurple",
          command = "MiniIconsOrange",
        },
      },
    },
  },
}
