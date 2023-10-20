return {
  'folke/which-key.nvim',
  config = function()
    require('which-key').register {
      ['<leader>c'] = { name = '[C]ode', _ = 'which_key_ignore' },
      -- ['<leader>d'] = { name = '[D]ocument', _ = 'which_key_ignore' },
      -- ['<leader>f'] = { name = '[F]ind', _ = 'which_key_ignore' },
      -- ['<leader>g'] = { name = '[G]it', _ = 'which_key_ignore' },
      ['<leader>h'] = { name = '[H]arpoon', _ = 'which_key_ignore' },
      -- ['<leader>j'] = { name = '[J]ump', _ = 'which_key_ignore' },
      -- ['<leader>l'] = { name = 'Move [L]ine', _ = 'which_key_ignore' },
      -- ['<leader>n'] = { name = '[N]av', _ = 'which_key_ignore' },
      ['<leader>s'] = { name = '[S]plit', _ = 'which_key_ignore' },
      -- ['<leader>w'] = { name = '[W]orkspace', _ = 'which_key_ignore' },
    }
    -- splits
    vim.keymap.set('n', '<leader>sv', ':vsplit<cr>', { desc = '[S]plit [V]ertically' })
    vim.keymap.set('n', '<leader>sh', ':split<cr>', { desc = '[S]plit [H]orizontally' })
    vim.keymap.set('n', '<leader>se', ':wincmd =<cr>', { desc = '[S]plit [E]venly' })
    vim.keymap.set('n', '<leader>sm', ':MaximizerToggle<cr>', { desc = 'Toggle [S]plit [M]aximize' })
    vim.keymap.set('n', '<leader>w', ':close<cr>', { desc = 'Close Split [W]indow' })

    vim.keymap.set('n', '<leader><leader>', ':', { desc = 'Command Mode'} );
    vim.keymap.set('n', '<leader>p', require('telescope.builtin').find_files, { desc = 'File [P]alette' })
    vim.keymap.set('n', '<leader>F', require('telescope.builtin').live_grep, { desc = 'Global [F]ind' })

    -- Harpoon
    vim.keymap.set('n', '<leader>hh', ':lua require("harpoon.ui").toggle_quick_menu()<cr>', { desc = '[H]arpoon [H]ome' })
    vim.keymap.set('n', '<leader>ha', ':lua require("harpoon.mark").add_file()<cr>', { desc = '[H]arpoon [A]dd' })
    vim.keymap.set('n', '<leader>hn', ':lua require("harpoon.ui").nav_next()<cr>', { desc = '[H]arpoon [N]ext' })
    vim.keymap.set('n', '<leader>hp', ':lua require("harpoon.ui").nav_prev()<cr>', { desc = '[H]arpoon [P]revious' })
    vim.keymap.set('n', '<leader>h1', ':lua require("harpoon.ui").nav_file(1)<cr>', { desc = '[H]arpoon File [1]' })
    vim.keymap.set('n', '<leader>h2', ':lua require("harpoon.ui").nav_file(2)<cr>', { desc = '[H]arpoon File [2]' })
    vim.keymap.set('n', '<leader>h3', ':lua require("harpoon.ui").nav_file(3)<cr>', { desc = '[H]arpoon File [3]' })
    vim.keymap.set('n', '<leader>h4', ':lua require("harpoon.ui").nav_file(4)<cr>', { desc = '[H]arpoon File [4]' })
    vim.keymap.set('n', '<leader>h5', ':lua require("harpoon.ui").nav_file(5)<cr>', { desc = '[H]arpoon File [5]' })
    vim.keymap.set('n', '<leader>h6', ':lua require("harpoon.ui").nav_file(6)<cr>', { desc = '[H]arpoon File [6]' })
    vim.keymap.set('n', '<leader>h7', ':lua require("harpoon.ui").nav_file(7)<cr>', { desc = '[H]arpoon File [7]' })
    vim.keymap.set('n', '<leader>h8', ':lua require("harpoon.ui").nav_file(8)<cr>', { desc = '[H]arpoon File [8]' })
    vim.keymap.set('n', '<leader>h9', ':lua require("harpoon.ui").nav_file(9)<cr>', { desc = '[H]arpoon File [9]' })
    vim.keymap.set('n', '<leader>h0', ':lua require("harpoon.ui").nav_file(10)<cr>', { desc = '[H]arpoon File 1[0]' })
  end,
}
