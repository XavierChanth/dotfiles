local M = {}

local supported = {
  "css",
  "graphql",
  "handlebars",
  "html",
  "javascript",
  "javascriptreact",
  "json",
  "jsonc",
  "less",
  "markdown",
  "markdown.mdx",
  "scss",
  "typescript",
  "typescriptreact",
  "vue",
  "yaml",
}

function M.has_config(ctx)
  vim.fn.system({ "prettier", "--find-config-path", ctx.filename })
  return vim.v.shell_error == 0
end

function M.has_parser(ctx)
  local ft = vim.bo[ctx.buf].filetype --[[@as string]]
  -- default filetypes are always supported
  if vim.tbl_contains(supported, ft) then
    return true
  end
  -- otherwise, check if a parser can be inferred
  local ret = vim.fn.system({ "prettier", "--file-info", ctx.filename })
  ---@type boolean, string?
  local ok, parser = pcall(function()
    return vim.fn.json_decode(ret).inferredParser
  end)
  return ok and parser and parser ~= vim.NIL
end

M.has_config = require("util.lazy").memoize(M.has_config)
M.has_parser = require("util.lazy").memoize(M.has_parser)

return {
  {
    "stevearc/conform.nvim",
    dependencies = { "mason.nvim" },
    init = function()
      -- Install the conform formatter on VeryLazy
      vim.api.nvim_create_autocmd("User", {
        pattern = "VeryLazy",
        callback = function()
          require("util.format").register({
            name = "conform.nvim",
            priority = 100,
            primary = true,
            format = function(buf)
              require("conform").format({ bufnr = buf })
            end,
            sources = function(buf)
              local ret = require("conform").list_formatters(buf)
              ---@param v conform.FormatterInfo
              return vim.tbl_map(function(v)
                return v.name
              end, ret)
            end,
          })
        end,
      })
    end,
    opts = {
      default_format_opts = {
        timeout_ms = 3000,
        async = false,
        quiet = false,
        lsp_format = "fallback",
      },
      formatters = {
        injected = {},
        prettier = { prepend_args = { "--prose-wrap", "always" } },
      },
    },
  },
  -- Setup prettier
  {
    "conform.nvim",
    opts = function(_, opts)
      opts.formatters_by_ft = opts.formatters_by_ft or {}
      for _, ft in ipairs(supported) do
        opts.formatters_by_ft[ft] = { "prettier" }
      end

      opts.formatters = opts.formatters or {}
      opts.formatters.prettier = {
        condition = function(_, ctx)
          return M.has_parser(ctx) and (M.has_config(ctx))
        end,
      }
    end,
  },
}
