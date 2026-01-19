require("mini.pick").setup({
  mappings = {
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
