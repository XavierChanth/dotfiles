return {
  {
    "nvchad/showkeys",
    cmd = "ShowkeysToggle",
    keys = {
      {
        "<leader>uk",
        function()
          vim.cmd("ShowkeysToggle")
        end,
        desc = "Showkeys (toggle)",
      },
    },
    opts = {
      excluded_modes = { "t", "i" },
      timeout = 1,
      maxkeys = 3,
      show_count = true,
    },
  },
}
