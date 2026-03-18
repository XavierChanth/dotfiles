local diff = require("mini.diff")
diff.setup({
  view = {
    style = "sign",
    signs = { add = "▎", change = "▎", delete = "" },
  },
})
