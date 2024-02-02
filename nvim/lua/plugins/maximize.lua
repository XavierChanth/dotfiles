local function maximize_status()
  return vim.t.maximized and "   " or ""
end

return {
  "declancm/maximize.nvim",
  lazy = false,
  config = function()
    local maximize = require("maximize")

    maximize.setup({
      default_keymaps = false,
    })

    vim.keymap.set("n", "<leader>wm", maximize.maximize, { silent = true, desc = "Maximized" })
    vim.keymap.set("n", "<leader>wr", maximize.restore, { silent = true, desc = "Restore from maximized" })

    require("lualine").setup({
      sections = {
        lualine_c = { maximize_status },
      },
    })
  end,
}
