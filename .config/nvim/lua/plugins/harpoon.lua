local maps = function(harpoon)
  vim.keymap.set("n", "<leader>hh", function()
    harpoon.ui:toggle_quick_menu(harpoon:list())
  end, { desc = "Harpoon Home" })
  vim.keymap.set("n", "<leader>ha", function()
    harpoon:list():append()
  end, { desc = "Harpoon Add" })
  vim.keymap.set("n", "<leader>hn", function()
    harpoon:list():next()
  end, { desc = "Harpoon Next" })
  vim.keymap.set("n", "<leader>hp", function()
    harpoon:list():prev()
  end, { desc = "Harpoon Previous" })
  vim.keymap.set("n", "<leader>hc", function()
    harpoon:list():clear()
  end, { desc = "Harpoon Clear" })
  vim.keymap.set("n", "<leader>h1", function()
    harpoon:list():select(1)
  end, { desc = "Harpoon File 1" })
  vim.keymap.set("n", "<leader>h2", function()
    harpoon:list():select(2)
  end, { desc = "Harpoon File 2" })
  vim.keymap.set("n", "<leader>h3", function()
    harpoon:list():select(3)
  end, { desc = "Harpoon File 3" })
  vim.keymap.set("n", "<leader>h4", function()
    harpoon:list():select(4)
  end, { desc = "Harpoon File 4" })
  vim.keymap.set("n", "<leader>h5", function()
    harpoon:list():select(5)
  end, { desc = "Harpoon File 5" })
  vim.keymap.set("n", "<leader>h6", function()
    harpoon:list():select(6)
  end, { desc = "Harpoon File 6" })
  vim.keymap.set("n", "<leader>h7", function()
    harpoon:list():select(7)
  end, { desc = "Harpoon File 7" })
  vim.keymap.set("n", "<leader>h8", function()
    harpoon:list():select(8)
  end, { desc = "Harpoon File 8" })
  vim.keymap.set("n", "<leader>h9", function()
    harpoon:list():select(9)
  end, { desc = "Harpoon File 9" })
  vim.keymap.set("n", "<leader>h0", function()
    harpoon:list():select(0)
  end, { desc = "Harpoon File 10" })
end

return {
  "ThePrimeagen/harpoon",
  lazy = false,
  branch = "harpoon2",
  dependencies = {
    "nvim-lua/plenary.nvim",
    "nvim-telescope/telescope.nvim",
  },
  config = function()
    require("which-key").register({
      ["<leader>h"] = { name = "harpoon" },
    })
    local harpoon = require("harpoon")
    harpoon:setup({})
    maps(harpoon)
  end,
}
