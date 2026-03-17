local ai = require("mini.ai")
local extra = require("mini.extra")
ai.setup({
  n_lines = 200,
  -- From LazyVim, with modifications
  custom_textobjects = {
    c = ai.gen_spec.treesitter({
      a = { "@code_cell.outer", "@class.outer" },
      i = { "@code_cell.inner", "@class.inner" },
    }), -- code_cell / class
    o = ai.gen_spec.treesitter({ -- code block
      a = { "@block.outer", "@conditional.outer", "@loop.outer" }, --
      i = { "@block.inner", "@conditional.inner", "@loop.inner" }, --
    }), --
    f = ai.gen_spec.treesitter({
      a = "@function.outer",
      i = "@function.inner",
    }), -- function
    u = ai.gen_spec.function_call(), -- u for "Usage"
    U = ai.gen_spec.function_call({ name_pattern = "[%w_]" }), -- without dot in function name
    t = { "<([%p%w]-)%f[^<%w][^<>]->.-</%1>", "^<.->().*()</[^/]->$" }, -- tags
    d = { "%f[%d]%d+" }, -- digits
    i = extra.gen_ai_spec.indent(), -- indent
    g = extra.gen_ai_spec.buffer(), -- buffer
    e = { -- Word with case
      {
        "%u[%l%d]+%f[^%l%d]",
        "%f[%S][%l%d]+%f[^%l%d]",
        "%f[%P][%l%d]+%f[^%l%d]",
        "^[%l%d]+%f[^%l%d]",
      },
      "^().*()$",
    },
  },
})
