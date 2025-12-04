---@diagnostic disable: missing-fields
require("goplements").setup({
  -- The prefixes prepended to the type names
  prefix = {
    interface = "implementers: ",
    struct = "implements: ",
  },
  -- Whether to display the package name along with the type name (i.e., builtins.error vs error)
  display_package = false,
  highlight = "DiagnosticHint"
})
