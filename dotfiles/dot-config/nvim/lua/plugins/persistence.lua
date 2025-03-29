return {
  "folke/persistence.nvim",
  event = "BufReadPre",
  opts = {},
  -- stylua: ignore
  keys = {
    { "<leader>q",  "",                                                          desc = "+quit/session" },
    { "<leader>qq", "<cmd>qa<cr>",                                               desc = "Quit All" },
    { "<leader>qs", function() require("persistence").load() end,                desc = "Restore Session" },
    { "<leader>qS", function() require("persistence").select() end,              desc = "Select Session" },
    { "<leader>ql", function() require("persistence").load({ last = true }) end, desc = "Restore Last Session" },
    { "<leader>qd", function() require("persistence").stop() end,                desc = "Don't Save Current Session" },
  },
  config = function(_, opts)
    local fname = vim.fn.argv(-1)[1]
    if fname and string.find(vim.fs.basename(fname), ".jjdescription") then
      return
    end
    require("persistence").setup(opts)
  end,
}
