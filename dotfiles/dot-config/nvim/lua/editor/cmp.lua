return {
  {
    "saghen/blink.cmp",
    -- lazy = false, -- lazy loading handled internally
    event = "InsertEnter",
    version = "v0.7.3",
    dependencies = { "rafamadriz/friendly-snippets" },
    opts = {
      completion = {
        list = { selection = "auto_insert" },
      },
      sources = {
        completion = {
          enabled_providers = function(ctx)
            local ok, node = pcall(vim.treesitter.get_node, ctx)
            if ok and node and vim.tbl_contains({ "comment", "line_comment", "block_comment" }, node:type()) then
              return { "buffer" }
            end
            return { "lsp", "path", "snippets", "buffer" }
          end,
        },
      },
      keymap = {
        preset = "default",
        ["<Esc>"] = {
          function()
            require("blink.cmp").hide()
            return false -- always call fallback after
          end,
          "fallback",
        },
        ["<CR>"] = { "accept", "fallback" },
        ["<C-n>"] = { "show", "select_next", "fallback" },
        ["<C-p>"] = { "show", "select_prev", "fallback" },
        ["<C-u>"] = { "scroll_documentation_up", "fallback" },
        ["<C-d>"] = { "scroll_documentation_down", "fallback" },
      },

      documentation = {
        auto_show = true,
      },
    },
  },
}
