return {
  {
    "mfussenegger/nvim-lint",
    event = { "BufReadPost", "BufNewFile", "BufReadPre" },
    dependencies = { "mason.nvim" },
    opts = {
      -- Event to trigger linters
      events = { "BufWritePost", "BufReadPost", "InsertLeave" },
      linters_by_ft = {},
      linters = {},
    },
    config = function(_, opts)
      vim.api.nvim_create_autocmd(opts.events, {
        group = vim.api.nvim_create_augroup("nvim-lint", { clear = true }),
        callback = function()
          local timer = vim.uv.new_timer()
          return function()
            timer:start(100, 0, function()
              timer:stop()
              vim.schedule_wrap(require("lint").try_lint)()
            end)
          end
        end
      })

      require("mason-nvim-lint").setup()
    end,
  },
  {
    "rshkarin/mason-nvim-lint",
    dependencies = { "nvim-lint" },
    opts = {
      automatic_installation = false,
      quiet_mode = true,
    },
  },
}
