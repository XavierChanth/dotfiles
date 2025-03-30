return {
  {
    "mfussenegger/nvim-lint",
    event = { "BufReadPost", "BufNewFile", "BufReadPre" },
    opts = {
      -- Event to trigger linters
      events = { "BufWritePost", "BufReadPost", "InsertLeave" },
      linters_by_ft = {
        dockerfile = { "hadolint" },
        markdown = { "pymarkdownlnt" },
        sh = { "shellcheck" },
      },
      linters = {
        pymarkdownlnt = {
          cmd = "pymarkdownlnt",
          stdin = true,
          args = { "scan-stdin" },
          stream = nil,
          ignore_exitcode = true,
          parser = function(...)
            return require("lint.parser").from_errorformat("stdin:%l:%c: %m", {
              source = "pymarkdownlnt",
              severity = vim.diagnostic.severity.WARN,
            })(...)
          end,
        },
      },
    },
    config = function(_, opts)
      local lint = require("lint")
      lint.linters_by_ft = opts.linters_by_ft

      for k, v in pairs(opts.linters) do
        if type(v) == "table" then
          lint.linters[k] = v
        end
      end

      vim.api.nvim_create_autocmd(opts.events, {
        group = vim.api.nvim_create_augroup("nvim-lint", { clear = true }),
        callback = function()
          vim.schedule_wrap(require("lint").try_lint)()
        end,
      })
    end,
  },
}
