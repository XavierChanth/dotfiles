local lint = require("lint")
lint.linters_by_ft = {
  dockerfile = { "hadolint" },
  markdown = { "pymarkdownlnt" },
  sh = { "shellcheck" },
}
lint.linters["pymarkdownlnt"] = {
  name = "pymarkdownlnt",
  cmd = "uvx",
  stdin = true,
  args = { "pymarkdownlnt", "scan-stdin" },
  stream = nil,
  ignore_exitcode = true,
  parser = function(...)
    return require("lint.parser").from_errorformat("stdin:%l:%c: %m", {
      source = "pymarkdownlnt",
      severity = vim.diagnostic.severity.WARN,
    })(...)
  end,
}

vim.api.nvim_create_autocmd({ "BufWritePost", "BufReadPost", "InsertLeave" }, {
  group = vim.api.nvim_create_augroup("nvim-lint", { clear = true }),
  callback = function()
    vim.schedule_wrap(require("lint").try_lint)()
  end,
})
