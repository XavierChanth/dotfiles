return {
  {
    "akinsho/toggleterm.nvim",
    cmd = "ToggleTerm",
    version = "*",
    opts = {
      direction = "float",
      float_opts = {
        border = "curved",
      },
    },
    keys = {
      {
        "<c-_>",
        function()
          require("util.terminal").toggle_terminal()
        end,
        desc = "Terminal (Last / Root)"
      },
      { "<c-_>",     "<cmd>close<cr>", mode = "t", desc = "which_key_ignore" },
      { "<S-Space>", "<Space>",        mode = "t", desc = "which_key_ignore", noremap = true, },
      {
        "<leader>E",
        function()
          require("util.terminal").terminal("yazi", {})
        end,
        desc = "Open Yazi"
      },
      {
        "<leader>gg",
        function()
          require("util.lazygit").lazygit()
        end,
        desc = "Lazygit"
      },
      -- Lazygit
      -- If I miss these I will add them
      -- map("n", "<leader>gb", LazyVim.lazygit.blame_line, { desc = "Git Blame Line" })
      -- map("n", "<leader>gB", LazyVim.lazygit.browse, { desc = "Git Browse" })
      --
      -- map("n", "<leader>gf", function()
      --   local git_path = vim.api.nvim_buf_get_name(0)
      --   LazyVim.lazygit({args = { "-f", vim.trim(git_path) }})
      -- end, { desc = "Lazygit Current File History" })
      --
      -- map("n", "<leader>gl", function()
      --   LazyVim.lazygit({ args = { "log" }, cwd = LazyVim.root.git() })
      -- end, { desc = "Lazygit Log" })
      -- map("n", "<leader>gL", function()
      --   LazyVim.lazygit({ args = { "log" } })
      -- end, { desc = "Lazygit Log (cwd)" })
    }
  },
}
