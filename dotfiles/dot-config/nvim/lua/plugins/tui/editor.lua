local zen_loaded = false
return {
  {
    "folke/flash.nvim",
    event = "VeryLazy",
    opts = {},
    -- stylua: ignore
    keys = {
      { "s", mode = { "n", "x", "o" }, function() require("flash").jump() end, desc = "Flash" },
      { "S", mode = { "n", "x", "o" }, function() require("flash").treesitter() end, desc = "Flash Treesitter" },
      { "r", mode = "o", function() require("flash").remote() end, desc = "Remote Flash" },
    },
  },
  {
    "lukas-reineke/indent-blankline.nvim",
    event = { "BufReadPost", "BufNewFile", "BufReadPre" },
    opts = {
      indent = {
        char = "│",
        tab_char = "│",
      },
      scope = { show_start = false, show_end = false },
      exclude = {
        filetypes = {
          "help",
          "alpha",
          "dashboard",
          "neo-tree",
          "Trouble",
          "trouble",
          "lazy",
          "mason",
          "notify",
          "toggleterm",
          "lazyterm",
        },
      },
    },
    main = "ibl",
  },
  {
    "MagicDuck/grug-far.nvim",
    opts = { headerMaxWidth = 80 },
    cmd = "GrugFar",
    keys = {
      {
        "<leader>sr",
        function()
          local grug = require("grug-far")
          local ext = vim.bo.buftype == "" and vim.fn.expand("%:e")
          grug.open({
            transient = true,
            prefills = {
              filesFilter = ext and ext ~= "" and "*." .. ext or nil,
            },
          })
        end,
        mode = { "n", "v" },
        desc = "Search and Replace",
      },
    },
  },
  {
    "folke/zen-mode.nvim",
    opts = {
      window = {
        width = function()
          local wininfo = vim.fn.getwininfo(vim.fn.win_getid())
          if not (wininfo and wininfo[1]) then
            vim.notify("Failed to get wininfo", vim.log.levels.WARN)
            return
          end
          local width = wininfo[1].width
          return vim.fn.max({
            vim.fn.floor(width / 2),
            121 + wininfo[1].textoff,
          })
        end,
      },
      plugins = {
        options = { laststatus = nil },
        tmux = { enabled = false },
      },
    },
    keys = {
      {
        "<leader>uz",
        function()
          if not zen_loaded then
            vim.api.nvim_create_autocmd("User", {
              pattern = "PersistenceSavePre",
              callback = require("zen-mode").close,
            })
            zen_loaded = true
          end
          require("zen-mode").toggle()
        end,
        desc = "Toggle Zen Mode",
      },
    },
  },
}
