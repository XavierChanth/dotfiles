---@diagnostic disable-next-line: missing-fields
require("nvim-treesitter.configs").setup({
  ensure_installed = require("assets.treesitter-spec"),
  sync_install = false,
  auto_install = true,
  highlight = { enable = true },
  indent = { enable = true },
  textobjects = {
    -- move = {
    --   enable = true,
    --   goto_next_start = {
    --     ["]f"] = "@function.outer",
    --     ["]c"] = "@class.outer",
    --     ["]a"] = "@parameter.inner",
    --     ["]o"] = "@code_cell.inner",
    --   },
    --   goto_next_end = {
    --     ["]F"] = "@function.outer",
    --     ["]C"] = "@class.outer",
    --     ["]A"] = "@parameter.inner",
    --     ["]O"] = "@code_cell.inner",
    --   },
    --   goto_previous_start = {
    --     ["[f"] = "@function.outer",
    --     ["[c"] = "@class.outer",
    --     ["[a"] = "@parameter.inner",
    --     ["[o"] = "@code_cell.inner",
    --   },
    --   goto_previous_end = {
    --     ["[F"] = "@function.outer",
    --     ["[C"] = "@class.outer",
    --     ["[A"] = "@parameter.inner",
    --     ["[O"] = "@code_cell.inner",
    --   },
    -- },
  },
})
