-- Completion and snippets
vim.g.cmp_use_blink = true

return {
  {
    "saghen/blink.cmp",
    cond = vim.g.cmp_use_blink,
    lazy = false, -- lazy loading handled internally
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
  {
    "hrsh7th/nvim-cmp",
    cond = not vim.g.cmp_use_blink,
    version = false,
    event = "InsertEnter",
    dependencies = {
      "hrsh7th/cmp-nvim-lsp",
      "hrsh7th/cmp-buffer",
      "hrsh7th/cmp-path",
      {
        "garymjr/nvim-snippets",
        commit = "b29b16daaeb44c7b370ea9a4a9468229155c1adb",
        dependencies = { "rafamadriz/friendly-snippets" },
        opts = { friendly_snippets = true },
      },
    },
    keys = {
      {
        "<Tab>",
        function()
          return vim.snippet.active({ direction = 1 }) and "<cmd>lua vim.snippet.jump(1)<cr>" or "<Tab>"
        end,
        expr = true,
        silent = true,
        mode = { "i", "s" },
      },
      {
        "<S-Tab>",
        function()
          return vim.snippet.active({ direction = -1 }) and "<cmd>lua vim.snippet.jump(-1)<cr>" or "<S-Tab>"
        end,
        expr = true,
        silent = true,
        mode = { "i", "s" },
      },
    },
    opts = function()
      local cmp = require("cmp")
      local defaults = require("cmp.config.default")()
      return {
        completion = {
          completeopt = "menu,menuone,preview,noselect,noinsert",
        },
        mapping = {
          ["<C-n>"] = {
            i = function()
              if cmp.visible() then
                cmp.select_next_item({ behavior = cmp.SelectBehavior.Insert })
              else
                cmp.complete()
              end
            end,
          },
          ["<C-p>"] = {
            i = function()
              if cmp.visible() then
                cmp.select_prev_item({ behavior = cmp.SelectBehavior.Insert })
              else
                cmp.complete()
              end
            end,
          },
          ["<C-e>"] = { i = cmp.mapping.abort() },
          ["<C-b>"] = { i = cmp.mapping.scroll_docs(-4) },
          ["<C-u>"] = { i = cmp.mapping.scroll_docs(-4) },
          ["<C-f>"] = { i = cmp.mapping.scroll_docs(4) },
          ["<C-d>"] = { i = cmp.mapping.scroll_docs(4) },
          ["<CR>"] = { i = cmp.mapping.confirm({ select = false }) },
        },
        sources = cmp.config.sources({
          { name = "nvim_lsp" },
          { name = "snippets" },
          { name = "buffer" },
          { name = "path" },
        }),
        sorting = defaults.sorting,
        performance = {
          debounce = 0,
          throttle = 0,
        },
        snippet = {
          expand = function(item)
            vim.snippet.expand(item.body)
          end,
          preselect = cmp.PreselectMode.None,
        },
      }
    end,
  },
}
