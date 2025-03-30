local keys = {
  {
    "<leader>h",
    function()
      local harpoon = require("harpoon")
      harpoon.ui:toggle_quick_menu(harpoon:list())
    end,
    desc = "Harpoon",
  },
  {
    "<leader>H",
    function()
      require("harpoon"):list():add()
    end,
    desc = "Harpoon",
  },
}
for i = 1, 5 do
  keys[#keys + 1] = {
    "<leader>" .. i,
    function()
      require("harpoon"):list():select(i)
    end,
    desc = "Harpoon " .. i,
  }
end

return {
  "ThePrimeagen/harpoon",
  branch = "harpoon2",
  opts = {},
  keys = keys,
}
