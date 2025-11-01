-- Filetypes
vim.filetype.add({
  extension = {
    -- xaml = "xml",
  },
  filename = {
    ["pubspec.yaml"] = "pubspec",
  },
})
vim.treesitter.language.register("xml", { "xaml" })
vim.treesitter.language.register("yaml", { "pubspec" })

