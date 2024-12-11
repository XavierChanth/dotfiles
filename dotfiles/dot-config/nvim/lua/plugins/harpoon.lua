local keys = {
  {
    "<leader>h",
    function()
      require("harpoon.ui").toggle_quick_menu()
    end,
    desc = "Harpoon",
  },
  {
    "<leader>H",
    function()
      require("harpoon.mark").add_file()
    end,
    desc = "Harpoon",
  },
}
for i = 1, 5 do
  keys[#keys + 1] = {
    "<leader>" .. i,
    function()
      require("harpoon.ui").nav_file(i)
    end,
    desc = "Harpoon " .. i,
  }
end

return {
  "ThePrimeagen/harpoon",
  opts = {},
  keys = keys,
}
