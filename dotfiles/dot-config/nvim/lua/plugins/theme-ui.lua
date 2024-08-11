local logos = require("util.logos")
local actions = require("util.dashboard").actions
local icons = require("lazyvim.config").icons

local selected_logo = "nvim_sharp"
return {
  {
    "nvimdev/dashboard-nvim",
    opts = {
      config = {
        header = vim.split("\n\n" .. logos[selected_logo] .. "\n\n", "\n"),
        center = actions,
      },
    },
  },
  {
    "nvim-lualine/lualine.nvim",
    opts = {
      options = {
        section_separators = { left = "", right = "" },
        component_separators = { left = "", right = "" },
      },
      sections = {
        lualine_a = { { "mode", separator = { left = "", right = "" } } },
        lualine_c = {
          { "filetype", icon_only = true, separator = "", padding = { left = 1, right = 0 } },
          {
            function()
              local abs = require("oil").get_current_dir() or vim.api.nvim_buf_get_name(0)
              return abs:gsub("^" .. require("util.root").git() .. "/?", "")
            end,
          },
        },
        lualine_y = {
          {
            "diagnostics",
            symbols = {
              error = icons.diagnostics.Error,
              warn = icons.diagnostics.Warn,
              info = icons.diagnostics.Info,
              hint = icons.diagnostics.Hint,
            },
          },
          -- {
          --   "buffers",
          --   filetype_names = {
          --     TelescopePrompt = "Telescope",
          --     dashboard = "Dashboard",
          --     packer = "Packer",
          --     fzf = "FZF",
          --     alpha = "Alpha",
          --     oil = "Oil",
          --   },
          --   max_length = vim.o.columns * 1 / 2,
          -- },
        },
        lualine_z = {
          { "progress", separator = { left = "" }, padding = { left = 1, right = 0 } },
          { "location", separator = { right = "" }, padding = { left = 0, right = 1 } },
        },
      },
    },
  },
}
