return {
  "f-person/auto-dark-mode.nvim",
  dependencies = {
    'nvim-lualine/lualine.nvim',
    'sainnhe/edge',
    'joshdick/onedark.vim',
  },
  config = {
    update_interval = 1000,
    set_dark_mode = function()
      vim.o.termguicolors = true
      vim.api.nvim_set_option("background", "dark")
      vim.cmd("colorscheme onedark")
      require('lualine').setup {
        options = {
          theme = 'onedark',
          icons_enabled = true,
          component_separators = '|',
          section_separators = '',
        },
      }
    end,
    set_light_mode = function()
      vim.o.termguicolors = true
      vim.api.nvim_set_option("background", "light")
      vim.cmd("colorscheme edge")
      require('lualine').setup {
        options = {
          theme = 'edge',
          icons_enabled = true,
          component_separators = '|',
          section_separators = '',
        },
      }
    end,
  },
}
