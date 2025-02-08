return {
  {
    "saghen/blink.cmp",
    -- lazy = false, -- lazy loading handled internally
    event = "InsertEnter",
    dependencies = { "rafamadriz/friendly-snippets", "fang2hou/blink-copilot" },
    opts = {
      completion = {
        list = { selection = { auto_insert = true, preselect = false } },
      },
      sources = {
        default = { "lsp", "copilot", "path", "snippets", "buffer" },
        providers = {
          copilot = {
            name = "copilot",
            module = "blink-copilot",
            score_offset = 100,
            async = true,
          },
        },
      },
      appearance = {
        kind_icons = {
          Copilot = "",
        },
      },
      signature = {
        window = {
          show_documentation = false,
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
    },
  },
}
