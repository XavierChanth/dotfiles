return {
  'folke/which-key.nvim',
  config = function()
    require('which-key').register {
      ['<leader>c'] = { name = '[C]ode', _ = 'which_key_ignore' },
      ['<leader>d'] = { name = '[D]ocument', _ = 'which_key_ignore' },
      ['<leader>f'] = { name = '[F]ind', _ = 'which_key_ignore' },
      ['<leader>g'] = { name = '[G]it', _ = 'which_key_ignore' },
      ['<leader>h'] = { name = '[H]arpoon', _ = 'which_key_ignore' },
      ['<leader>j'] = { name = '[J]ump', _ = 'which_key_ignore' },
      ['<leader>l'] = { name = 'Move [L]ine', _ = 'which_key_ignore' },
      ['<leader>n'] = { name = '[N]av', _ = 'which_key_ignore' },
      ['<leader>s'] = { name = '[S]plit', _ = 'which_key_ignore' },
      ['<leader>t'] = { name = '[T]ab', _ = 'which_key_ignore' },
      ['<leader>w'] = { name = '[W]orkspace', _ = 'which_key_ignore' },
    }

    -- Remove highlights from searching
    vim.keymap.set('n', '<leader>nh', '<cmd>:nohl<CR>', { desc = '[N]o [H]ighlight after search' })

    -- Git
    vim.keymap.set('n', '<leader>gs', ':Git status<cr>', { desc = '[G]it [S]tatus' })
    vim.keymap.set('n', '<leader>gd', ':Gdiffsplit<cr>', { desc = '[G]it [D]iff split' })
    vim.keymap.set('n', '<leader>gv', ':GV<cr>', { desc = '[G]it [V]iew graph' })


    -- tab management
    vim.keymap.set('n', '<leader>tt', ':tabnew<cr>', { desc = '[T]ab New' })
    vim.keymap.set('n', '<leader>tw', ':tabclose<cr>', { desc = '[T]ab Close' })
    vim.keymap.set('n', '<leader>tn', ':tabn<cr>', { desc = '[T]ab [N]ext' })
    vim.keymap.set('n', '<leader>tp', ':tabp<cr>', { desc = '[T]ab [P]revious' })

    -- splits
    vim.keymap.set('n', '<leader>sv', ':vsplit<cr>', { desc = '[S]plit [V]ertically' })
    vim.keymap.set('n', '<leader>sh', ':split<cr>', { desc = '[S]plit [H]orizontally' })
    vim.keymap.set('n', '<leader>se', ':wincmd =<cr>', { desc = '[S]plit [E]venly' })
    vim.keymap.set('n', '<leader>sw', ':close<cr>', { desc = 'Close Split Window' })
    vim.keymap.set('n', '<leader>sm', ':MaximizerToggle<cr>', { desc = '[M]aximize split' })

    -- Telescope
    vim.keymap.set('n', '<leader>?', require('telescope.builtin').oldfiles, { desc = '[?] Find recently opened files' })
    vim.keymap.set('n', '<leader><space>', require('telescope.builtin').buffers, { desc = '[ ] Find existing buffers' })
    vim.keymap.set('n', '<leader>/', function()
      -- You can pass additional configuration to telescope to change theme, layout, etc.
      require('telescope.builtin').current_buffer_fuzzy_find(require('telescope.themes').get_dropdown {
        winblend = 10,
        previewer = false,
      })
    end, { desc = '[/] Fuzzily search in current buffer' })

    vim.keymap.set('n', '<leader>ff', require('telescope.builtin').find_files, { desc = '[F]ind [F]iles' })
    vim.keymap.set('n', '<leader>fg', require('telescope.builtin').live_grep, { desc = '[F]ind by [G]rep' })
    vim.keymap.set('n', '<leader>fd', require('telescope.builtin').diagnostics, { desc = '[F]ind [D]iagnostics' })
    vim.keymap.set('n', '<leader>fr', require('telescope.builtin').resume, { desc = '[F]ind [R]esume' })

    -- Move Lines
    vim.keymap.set('n', '<leader>d', ':move .+1<cr>==', { desc = '[L]ine [D]own' })
    vim.keymap.set('n', '<leader>u', ':move .-2<cr>==', { desc = '[L]ine [U]p' })

    -- Numbers
    vim.keymap.set('n', '<leader>ni', '<C-a>', { desc = '[N]umber [I]ncrement' })
    vim.keymap.set('n', '<leader>nd', '<C-x>', { desc = '[N]umber [D]ecrement' })

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

    -- navigation
    vim.keymap.set('n', '<leader>nb', '<C-o>', { desc = '[N]avigate [B]ack' })
    vim.keymap.set('n', '<leader>nf', '<C-i>', { desc = '[N]avigate [F]orward' })
    vim.keymap.set('n', '<leader>ct', ':TroubleToggle<cr>', { desc = '[C]ode [T]rouble' })
  end,
}
