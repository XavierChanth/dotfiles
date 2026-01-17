require("mini.pick").setup({
  mappings = {
    mark = "<C-m>",
    choose_marked="<C-q>",
    toggle_info = "<C-i>",
    toggle_preview = "<C-o>",
  },
  window = {
    config = {},
  },
})
-- register mini-pick pickers
require("mini.extra").setup()
