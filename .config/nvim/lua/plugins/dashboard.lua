local logo = [[
██╗  ██╗ █████╗ ██╗   ██╗██╗███████╗██████╗  ██████╗██╗  ██╗ █████╗ ███╗   ██╗████████╗██╗  ██╗
╚██╗██╔╝██╔══██╗██║   ██║██║██╔════╝██╔══██╗██╔════╝██║  ██║██╔══██╗████╗  ██║╚══██╔══╝██║  ██║
 ╚███╔╝ ███████║██║   ██║██║█████╗  ██████╔╝██║     ███████║███████║██╔██╗ ██║   ██║   ███████║
 ██╔██╗ ██╔══██║╚██╗ ██╔╝██║██╔══╝  ██╔══██╗██║     ██╔══██║██╔══██║██║╚██╗██║   ██║   ██╔══██║
██╔╝ ██╗██║  ██║ ╚████╔╝ ██║███████╗██║  ██║╚██████╗██║  ██║██║  ██║██║ ╚████║   ██║   ██║  ██║
╚═╝  ╚═╝╚═╝  ╚═╝  ╚═══╝  ╚═╝╚══════╝╚═╝  ╚═╝ ╚═════╝╚═╝  ╚═╝╚═╝  ╚═╝╚═╝  ╚═══╝   ╚═╝   ╚═╝  ╚═╝
    ]]

logo = string.rep("\n", 8) .. logo .. "\n\n"

local telescope = require("lazyvim.util.telescope")
-- Intentional override of lazyvim's config_files to be the entire dotfiles repo
---@diagnostic disable-next-line: duplicate-set-field
telescope.config_files = function()
  return telescope("files", {
    cwd = vim.fn.expand("$HOME/.dotfiles"),
    show_untracked = true,
    git_command = { "/bin/zsh", "-c", "git ls-files --exclude-standard --cached; echo .zshenv" },
  })
end

return {
  "nvimdev/dashboard-nvim",
  opts = {
    config = {
      header = vim.split(logo, "\n"),
    },
  },
}
