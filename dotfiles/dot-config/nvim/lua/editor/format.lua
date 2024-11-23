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
  "scss",
  "typescript",
  "typescriptreact",
  "vue",
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

M.has_parser = Util.lazy.memoize(M.has_parser)

return {
  {
    "stevearc/conform.nvim",
    event = { "BufReadPost", "BufNewFile", "BufReadPre" },
    cmd = "ConformInfo",
    dependencies = { "mason.nvim" },
    init = function()
      vim.opt.formatexpr = "v:lua.require'conform'.formatexpr()"
      vim.g.autoformat = true
      vim.api.nvim_create_user_command("W", "lua vim.g.autoformat = false; vim.cmd.w(); vim.g.autoformat = true", {})
      vim.api.nvim_create_user_command("WA", "lua vim.g.autoformat = false; vim.cmd.wa(); vim.g.autoformat = true", {})
      vim.api.nvim_create_user_command("Wa", "lua vim.g.autoformat = false; vim.cmd.wa(); vim.g.autoformat = true", {})
    end,
    keys = {
      {
        "<leader>cc",
        "<cmd>ConformInfo<cr>",
        desc = "Conform Info",
      },
      {
        "<leader>cf",
        function()
          require("conform").format()
        end,
        desc = "Code Format",
      },
    },
    opts = {
      format_on_save = function(bufnr)
        if not vim.g.autoformat then
          return
        end
        return { buf = bufnr, lsp_format = "fallback" }
      end,
      default_format_opts = {
        timeout_ms = 3000,
        async = false,
        quiet = false,
        lsp_format = "fallback",
      },
      formatters = {
        injected = {
          options = {
            ignore_errors = false,
            lang_to_ext = {
              bash = "sh",
              c_sharp = "cs",
              elixir = "exs",
              javascript = "js",
              julia = "jl",
              latex = "tex",
              markdown = "md",
              python = "py",
              ruby = "rb",
              rust = "rs",
              teal = "tl",
              r = "r",
              typescript = "ts",
            },
            lang_to_formatters = {},
          },
        },
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
  {
    "LittleEndianRoot/mason-conform",
    event = "VeryLazy",
    dependencies = { "conform.nvim" },
    opts = {
      ensure_installed = { "prettier" },
      automatic_installation = false,
    },
  },
}
