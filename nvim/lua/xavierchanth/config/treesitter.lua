return {
  -- Highlight, edit, and navigate code
  'nvim-treesitter/nvim-treesitter',
  dependencies = {
    'nvim-treesitter/nvim-treesitter-textobjects',
  },
  build = ':TSUpdate',
  config = function()
    vim.defer_fn(function()
      -- local parser = require("nvim-treesitter.parsers").get_parser_configs()
      -- parser.dart = {
      --   install_info = {
      --     url = "https://github.com/UserNobody14/tree-sitter-dart",
      --     files = { "src/parser.c", "src/scanner.c" },
      --     revision = "8aa8ab977647da2d4dcfb8c4726341bee26fbce4", -- The last commit before the snail speed
      --   },
      -- }
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
            "dart"
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
