return {
  {
    "L3MON4D3/LuaSnip",
    dependencies = {
      "rafamadriz/friendly-snippets",
      config = function()
        require("luasnip.loaders.from_vscode").lazy_load()
        require("luasnip.loaders.from_vscode").lazy_load({ paths = vim.fn.stdpath("config") .. "/snippets/" })
      end,
    },
  },
  {
    "hrsh7th/nvim-cmp",
    opts = {
      completion = {
        completeopt = "menu,preview,menuone,noselect,noinsert",
      },
    },
  },
}
