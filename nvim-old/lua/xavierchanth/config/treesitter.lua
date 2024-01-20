return {
  -- Highlight, edit, and navigate code
  'nvim-treesitter/nvim-treesitter',
  dependencies = {
    'nvim-treesitter/nvim-treesitter-textobjects',
  },
  build = ':TSUpdate',
  config = function()
    vim.defer_fn(function()
      require('nvim-treesitter.configs').setup {
        -- Add languages to be installed here that you want installed for treesitter
        ensure_installed = {
          'bash',
          'c',
          'cpp',
          'dart',
          'go',
          'javascript',
          'lua',
          'python',
          'rust',
          'tsx',
          'typescript',
          'vimdoc',
          'vim',
          'yaml',
        },
        -- Autoinstall languages that are not installed. Defaults to false (but you can change for yourself!)
        auto_install = true,
        highlight = { enable = true },
        indent = {
          enable = true,
          disable = {
           -- "dart"
          },
        },
        textobjects = {
          move = {
            enable = true,
            goto_next_start = {
              ['<leader>jp'] = '@parameter.outer',
              ['<leader>jc'] = '@class.outer',
              ['<leader>jf'] = '@function.outer',
              ['<leader>jb'] = '@block.outer',
            },
            goto_previous_start = {
              ['<leader>jP'] = '@parameter.outer',
              ['<leader>jC'] = '@class.outer',
              ['<leader>jF'] = '@function.outer',
              ['<leader>jB'] = '@block.outer',
            },
          },
        },
      }
    end, 0)
  end
}
