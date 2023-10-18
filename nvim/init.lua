-- set leader key to space
vim.g.mapleader = ' '
vim.g.maplocalleader = ' '

-- setup lazy.nvim (nvim package manager)
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({
    "git",
    "clone",
    "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable", -- latest stable release
    lazypath,
  })
end
vim.opt.rtp:prepend(lazypath)

-- setup packages
require('lazy').setup({
  -- NOTE: First, some plugins that don't require any configuration

  -- Git related plugins
  'tpope/vim-fugitive', -- General Git wrapper
  'tpope/vim-rhubarb',  -- General GitHub wrapper

  -- Detect tabstop and shiftwidth automatically
  'tpope/vim-sleuth',

  -- 'ys<motion>' to wrap
  -- 'ds<motion>' to delete
  -- 'cs<motion>' to change
  -- 'tpope/vim-surround',

  -- 'gr<motion>' to replace
  'vim-scripts/ReplaceWithRegister',

  -- commenting
  'numToStr/Comment.nvim',

  -- whitespace highlighting
  'ntpeters/vim-better-whitespace',

  -- tmux & split window navigation
  'christoomey/vim-tmux-navigator',
  'szw/vim-maximizer',

  {
    'VonHeikemen/lsp-zero.nvim',
    branch = 'v2.x',
    lazy = true,
    config = function()
      -- This is where you modify the settings for lsp-zero
      -- Note: autocompletion settings will not take effect

      require('lsp-zero.settings').preset({})
    end
  },

  -- Autocompletion
  {
    'hrsh7th/nvim-cmp',
    dependencies = {
      {
        'L3MON4D3/LuaSnip',
        'github/copilot.vim',
      },
    },
    config = function()
      -- Here is where you configure the autocompletion settings.
      -- The arguments for .extend() have the same shape as `manage_nvim_cmp`:
      -- https://github.com/VonHeikemen/lsp-zero.nvim/blob/v2.x/doc/md/api-reference.md#manage_nvim_cmp

      require('lsp-zero.cmp').extend()

      -- And you can configure cmp even more, if you want to.
      local cmp = require('cmp')
      local cmp_action = require('lsp-zero.cmp').action()

      cmp.setup({
        mapping = {
          ['<C-Space>'] = cmp.mapping(cmp.mapping.complete({
            reason = cmp.ContextReason.Auto,
          }), { 'i', 'c' }),
          ['<CR>'] = cmp.mapping.confirm {
            behavior = cmp.ConfirmBehavior.Replace,
            select = true,
          },
          ['<C-G>'] = cmp.mapping(function(fallback)
            local copilot_keys = vim.fn['copilot#Accept']('')
            if copilot_keys ~= '' and type(copilot_keys) == 'string' then
              vim.api.nvim_feedkeys(copilot_keys, 'i', true)
            else
              fallback()
            end
          end, { 'i', 's' }),
          ['<Tab>'] = cmp.mapping.select_next_item({ behavior = 'select' }),
          ['<S-Tab>'] = cmp.mapping.select_prev_item({ behavior = 'select' }),
        },
        sources = {
          { name = 'nvim_lsp' },
          { name = 'luasnip' },
          { name = 'path' },
          { name = 'buffer' },
        },
      })
    end,
  },

  -- LSP
  {
    'neovim/nvim-lspconfig',
    cmd = 'LspInfo',
    event = { 'BufReadPre', 'BufNewFile' },
    dependencies = {
      'hrsh7th/cmp-nvim-lsp',
      'hrsh7th/cmp-buffer',
      'williamboman/mason-lspconfig.nvim',
      'williamboman/mason.nvim',
      'akinsho/flutter-tools.nvim',
    },
    config = function()
      -- This is where all the LSP shenanigans will live

      local lsp = require('lsp-zero')

      lsp.on_attach(function(_, bufnr)
        -- see :help lsp-zero-keybindings
        -- to learn the available actions
        lsp.default_keymaps({ buffer = bufnr })

        local nmap = function(keys, func, desc)
          if desc then
            desc = 'LSP: ' .. desc
          end

          vim.keymap.set('n', keys, func, { buffer = bufnr, desc = desc })
        end

        nmap('<leader>cr', vim.lsp.buf.rename, '[C]ode [R]ename')
        nmap('<leader>ca', vim.lsp.buf.code_action, '[C]ode [A]ction')
        nmap('<leader>ch', vim.lsp.buf.hover, '[C]ode [H]over')
        nmap('<leader>cs', vim.lsp.buf.workspace_symbol, '[C]ode [S]ymbol')

        nmap('gd', require('telescope.builtin').lsp_definitions, '[G]oto [D]efinition')
        nmap('gr', require('telescope.builtin').lsp_references, '[G]oto [R]eferences')
        nmap('gI', require('telescope.builtin').lsp_implementations, '[G]oto [I]mplementation')
        nmap('<leader>D', require('telescope.builtin').lsp_type_definitions, 'Type [D]efinition')
        nmap('<leader>ds', require('telescope.builtin').lsp_document_symbols, '[D]ocument [S]ymbols')
        nmap('<leader>ws', require('telescope.builtin').lsp_dynamic_workspace_symbols, '[W]orkspace [S]ymbols')

        vim.api.nvim_buf_create_user_command(bufnr, 'Format', function(_)
          vim.lsp.buf.format()
        end, { desc = 'Format current buffer with LSP' })

        nmap('<leader>cf', vim.lsp.buf.format, '[C]ode [F]ormat')
      end)

      -- (Optional) Configure lua language server for neovim
      require('lspconfig').lua_ls.setup(lsp.nvim_lua_ls())

      lsp.setup()

      local dart_lsp = lsp.build_options('dartls', {})

      require('flutter-tools').setup({
        lsp = {
          capabilities = dart_lsp.capabilities
        }
      })
    end,
  },

  {
    'akinsho/flutter-tools.nvim',
    lazy = false,
    dependencies = {
      'nvim-lua/plenary.nvim',
      'stevearc/dressing.nvim', -- optional for vim.ui.select
    },
    config = true,
  },

  -- Useful plugin to show you pending keybinds.
  { 'folke/which-key.nvim',  opts = {} },
  {
    -- Adds git related signs to the gutter, as well as utilities for managing changes
    'lewis6991/gitsigns.nvim',
    opts = {
      -- See `:help gitsigns.txt`
      signs = {
        add = { text = '+' },
        change = { text = '~' },
        delete = { text = '_' },
        topdelete = { text = '‾' },
        changedelete = { text = '~' },
      },
      on_attach = function(bufnr)
        -- vim.keymap.set('n', '<leader>hp', require('gitsigns').preview_hunk, { buffer = bufnr, desc = 'Preview git hunk' })

        -- don't override the built-in and fugitive keymaps
        -- local gs = package.loaded.gitsigns
        -- vim.keymap.set({ 'n', 'v' }, ']c', function()
        --   if vim.wo.diff then
        --     return ']c'
        --   end
        --   vim.schedule(function()
        --     gs.next_hunk()
        --   end)
        --   return '<Ignore>'
        -- end, { expr = true, buffer = bufnr, desc = 'Jump to next hunk' })
        -- vim.keymap.set({ 'n', 'v' }, '[c', function()
        --   if vim.wo.diff then
        --     return '[c'
        --   end
        --   vim.schedule(function()
        --     gs.prev_hunk()
        --   end)
        --   return '<Ignore>'
        -- end, { expr = true, buffer = bufnr, desc = 'Jump to previous hunk' })
      end,
    },
  },

  {
    "f-person/auto-dark-mode.nvim",
    dependencies = {
      'nvim-lualine/lualine.nvim',
      'sainnhe/edge',
      'joshdick/onedark.vim',
    },
    config = {
      update_interval = 1000,
      set_dark_mode = function()
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
  },

  {
    -- Add indentation guides even on blank lines
    'lukas-reineke/indent-blankline.nvim',
    -- Enable `lukas-reineke/indent-blankline.nvim`
    -- See `:help ibl`
    main = 'ibl',
    opts = {},
  },

  -- "gc" to comment visual regions/lines
  { 'numToStr/Comment.nvim', opts = {} },

  -- Fuzzy Finder (files, lsp, etc)
  {
    'nvim-telescope/telescope.nvim',
    branch = '0.1.x',
    dependencies = {
      'nvim-lua/plenary.nvim',
      -- Fuzzy Finder Algorithm which requires local dependencies to be built.
      -- Only load if `make` is available. Make sure you have the system
      -- requirements installed.
      {
        'nvim-telescope/telescope-fzf-native.nvim',
        -- NOTE: If you are having trouble with this installation,
        --       refer to the README for telescope-fzf-native for more instructions.
        build = 'make',
        cond = function()
          return vim.fn.executable 'make' == 1
        end,
      },
    },
    config = {
      defaults = {
        defaults = {
        file_ignore_patterns = {
            '.git',
            'node_modules',
          }
        },
        mappings = {
          i = {
            ['<C-u>'] = false,
            ['<C-d>'] = false,
          },
        },
      },
    },
  },

  {
    -- Highlight, edit, and navigate code
    'nvim-treesitter/nvim-treesitter',
    dependencies = {
      'nvim-treesitter/nvim-treesitter-textobjects',
    },
    build = ':TSUpdate',
  },

  {
    'nvim-tree/nvim-tree.lua',
    lazy = false,
    dependencies = {
      'nvim-tree/nvim-web-devicons',
    },
    config = {
      view = {
        adaptive_size = true,
      },
      actions = {
        open_file = {
          quit_on_open = true,
          window_picker = {
            enable = false,
          },
        },
      },
    },
  },

  {
    'ThePrimeagen/harpoon',
    dependencies = {
      'nvim-lua/plenary.nvim',
    },
    config = {
      menu = {
        width = vim.api.nvim_win_get_width(0) - 4,
      },
    },
  },

}, {})

-- [[ Highlight on yank ]]
-- See `:help vim.highlight.on_yank()`
local highlight_group = vim.api.nvim_create_augroup('YankHighlight', { clear = true })
vim.api.nvim_create_autocmd('TextYankPost', {
  callback = function()
    vim.highlight.on_yank()
  end,
  group = highlight_group,
  pattern = '*',
})

-- [[ Configure Telescope ]]
-- See `:help telescope` and `:help telescope.setup()`

-- Enable telescope fzf native, if installed
pcall(require('telescope').load_extension, 'fzf')

-- [[ Configure Treesitter ]]
-- See `:help nvim-treesitter`
-- Defer Treesitter setup after first render to improve startup time of 'nvim {filename}'
vim.defer_fn(function()
  local parser = require("nvim-treesitter.parsers").get_parser_configs()
  parser.dart = {
    install_info = {
      url = "https://github.com/UserNobody14/tree-sitter-dart",
      files = { "src/parser.c", "src/scanner.c" },
      revision = "8aa8ab977647da2d4dcfb8c4726341bee26fbce4", -- The last commit before the snail speed
    },
  }
  require('nvim-treesitter.configs').setup {
    -- Add languages to be installed here that you want installed for treesitter
    ensure_installed = { 'c', 'cpp', 'go', 'lua', 'python', 'rust', 'tsx', 'javascript', 'typescript', 'vimdoc', 'vim',
      'bash', 'dart' },

    -- Autoinstall languages that are not installed. Defaults to false (but you can change for yourself!)
    auto_install = true,
    highlight = { enable = true },
    indent = {
      enable = true,
      disable = {
        "dart"
      },
    },
    incremental_selection = {
      enable = true,
      keymaps = {
        -- init_selection = '<c-space>',
        -- node_incremental = '<c-space>',
        -- scope_incremental = '<c-s>',
        -- node_decremental = '<M-space>',
      },
    },
    textobjects = {
      select = {
        enable = true,
        lookahead = true, -- Automatically jump forward to textobj, similar to targets.vim
        keymaps = {
          -- You can use the capture groups defined in textobjects.scm
          -- ['aa'] = '@parameter.outer',
          -- ['ia'] = '@parameter.inner',
          -- ['af'] = '@function.outer',
          -- ['if'] = '@function.inner',
          -- ['ac'] = '@class.outer',
          -- ['ic'] = '@class.inner',
        },
      },
      move = {
        enable = true,
        set_jumps = true, -- whether to set jumps in the jumplist
        goto_next_start = {
          -- [']m'] = '@function.outer',
          -- [']]'] = '@class.outer',
        },
        goto_next_end = {
          -- [']M'] = '@function.outer',
          -- [']['] = '@class.outer',
        },
        goto_previous_start = {
          -- ['[m'] = '@function.outer',
          -- ['[['] = '@class.outer',
        },
        goto_previous_end = {
          -- ['[M'] = '@function.outer',
          -- ['[]'] = '@class.outer',
        },
      },
      swap = {
        enable = true,
        swap_next = {
          -- ['<leader>a'] = '@parameter.inner',
        },
        swap_previous = {
          -- ['<leader>A'] = '@parameter.inner',
        },
      },
    },
  }
end, 0)


-- [[ General settings ]]
-- line numbers
vim.opt.relativenumber = true
vim.opt.number = true

-- tabs & indentation
vim.opt.tabstop = 2
vim.opt.shiftwidth = 2
vim.opt.expandtab = true
vim.opt.autoindent = true

-- line wrapping
vim.opt.wrap = false

-- search settings
vim.opt.ignorecase = true
vim.opt.smartcase = true

-- cursor line
vim.opt.cursorline = true

-- backspace
vim.opt.backspace = "indent,eol,start"

-- split windows
vim.opt.splitright = true
vim.opt.splitbelow = true

-- make '-' count as a word
vim.opt.iskeyword:append("-")

-- Set completeopt to have a better completion experience
vim.opt.completeopt = 'menuone,noselect'

-- NOTE: You should make sure your terminal supports this
-- vim.o.termguicolors = true

-- [[ Configure nvim-tree ]]
vim.g.loaded = 1
vim.g.loaded_netrwPlugin = 1

vim.cmd([[ highlight NvimTreeIndentMarker guifg=#3FC5FF ]])
vim.keymap.set("n", "<leader>e", ":NvimTreeToggle<CR>") -- Toggle [E]xplorer

require 'nvim-tree.view'.View.winopts.relativenumber = true

-- document existing key chains
require('which-key').register {
  ['<leader>c'] = { name = '[C]ode', _ = 'which_key_ignore' },
  ['<leader>d'] = { name = '[D]ocument', _ = 'which_key_ignore' },
  ['<leader>f'] = { name = '[F]ind', _ = 'which_key_ignore' },
  ['<leader>g'] = { name = '[G]it', _ = 'which_key_ignore' },
  ['<leader>h'] = { name = '[H]arpoon', _ = 'which_key_ignore' },
  ['<leader>l'] = { name = 'Move [L]ine', _ = 'which_key_ignore' },
  ['<leader>n'] = { name = '[N]o', _ = 'which_key_ignore' },
  ['<leader>s'] = { name = '[S]plit', _ = 'which_key_ignore' },
  ['<leader>t'] = { name = '[T]ab', _ = 'which_key_ignore' },
  ['<leader>w'] = { name = '[W]orkspace', _ = 'which_key_ignore' },
}

-- Remove highlights from searching
vim.keymap.set('n', '<leader>nh', '<cmd>:nohl<CR>', { desc = '[N]o [H]ighlight after search' })

-- Git
vim.keymap.set('n', '<leader>gs', ':Git status<cr>', { desc = '[G]it [S]tatus' })
vim.keymap.set('n', '<leader>gd', ':Gdiffsplit<cr>', { desc = '[G]it [D]iff split' })

-- Copilot
vim.g.copilot_assume_mapped = true

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
vim.keymap.set('n', '<leader>fg', require('telescope.builtin').git_files, { desc = '[F]ind [G]it Files' })
-- These binds were search but will need to be changed from <leader>s which is now [S]plit
-- vim.keymap.set('n', '<leader>sh', require('telescope.builtin').help_tags, { desc = '[S]earch [H]elp' })
-- vim.keymap.set('n', '<leader>sw', require('telescope.builtin').grep_string, { desc = '[S]earch current [W]ord' })
-- vim.keymap.set('n', '<leader>sg', require('telescope.builtin').live_grep, { desc = '[S]earch by [G]rep' })
-- vim.keymap.set('n', '<leader>sd', require('telescope.builtin').diagnostics, { desc = '[S]earch [D]iagnostics' })
-- vim.keymap.set('n', '<leader>sr', require('telescope.builtin').resume, { desc = '[S]earch [R]esume' })

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

-- The line beneath this is called `modeline`. See `:help modeline`
-- vim: ts=2 sts=2 sw=2 et
