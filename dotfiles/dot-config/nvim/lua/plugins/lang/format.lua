local M = {}

local prettier_supported = {
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

function M.has_parser(ctx)
  local ft = vim.bo[ctx.buf].filetype --[[@as string]]
  -- default filetypes are always supported
  if vim.tbl_contains(prettier_supported, ft) then
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

M.has_parser = require("util.lazy").memoize(M.has_parser)

return {
  {
    "stevearc/conform.nvim",
    event = { "BufReadPost", "BufNewFile", "BufReadPre" },
    cmd = "ConformInfo",
    dependencies = { "mason.nvim" },
    opts = {
      format_on_save = function(bufnr)
        if vim.g.autoformat then
          return
        end

        local ignore_filetypes = { "sql", "java" }
        if vim.tbl_contains(ignore_filetypes, vim.bo[bufnr].filetype) then
          return
        end

        local bufname = vim.api.nvim_buf_get_name(bufnr)
        if bufname:match("/node_modules/") then
          return
        end

        return {}
      end,
      default_format_opts = {
        timeout_ms = 3000,
        async = false,
        quiet = false,
        lsp_format = "fallback",
      },
      formatters = {
        injected = {},
        condition = function(_, ctx)
          return M.has_parser(ctx)
        end,
        prettier = { prepend_args = { "--prose-wrap", "always" } },
      },
    },
  },
  -- Setup prettier for a bunch of file types
  {
    "stevearc/conform.nvim",
    opts = function(_, opts)
      opts.formatters_by_ft = opts.formatters_by_ft or {}
      for _, ft in ipairs(prettier_supported) do
        opts.formatters_by_ft[ft] = { "prettier" }
      end
    end,
  },
}
