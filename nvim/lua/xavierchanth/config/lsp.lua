return {
  {
    'VonHeikemen/lsp-zero.nvim',
    branch = 'v3.x',
    lazy = true,
    config = false,
    init = function()
      -- Disable automatic setup, we are doing it manually
      vim.g.lsp_zero_extend_cmp = 0
      vim.g.lsp_zero_extend_lspconfig = 0
    end,
  },

  {
    'hrsh7th/nvim-cmp',
    event = 'InsertEnter',
    dependencies = {
      { 'L3MON4D3/LuaSnip' },
      { 'hrsh7th/cmp-buffer' },
      { 'hrsh7th/cmp-path' },
      { 'hrsh7th/cmp-calc' },
      { 'zbirenbaum/copilot.lua' },
      { 'zbirenbaum/copilot-cmp' },
    },
    config = function()
      -- Here is where you configure the autocompletion settings.
      local lsp_zero = require('lsp-zero')
      lsp_zero.extend_cmp()

      require('copilot').setup({
        suggestion = { enabled = false },
        panel = { enabled = false },
      })
      require('copilot_cmp').setup()

      -- And you can configure cmp even more, if you want to.
      local cmp = require('cmp')
      -- local cmp_action = lsp_zero.cmp_action()
      cmp.setup({
        sources = {
          { name = 'nvim_lsp' },
          { name = 'buffer' },
          { name = 'path' },
          { name = 'calc' },
          { name = 'copilot' },
        },
        mapping = cmp.mapping.preset.insert({
          ['<CR>'] = cmp.mapping.confirm({
            -- documentation says this is important.
            -- I don't know why.
            behavior = cmp.ConfirmBehavior.Replace,
            select = false,
          })
        })
      })
    end
  },

  {
    'neovim/nvim-lspconfig',
    cmd = 'LspInfo',
    event = { 'BufReadPre', 'BufNewFile' },
    dependencies = {
      { 'hrsh7th/cmp-nvim-lsp' },
      { 'williamboman/mason.nvim', },
      { 'williamboman/mason-lspconfig.nvim', },
    },
    config = function()
      -- This is where all the LSP shenanigans will live
      local lsp_zero = require('lsp-zero')
      lsp_zero.extend_lspconfig()

      lsp_zero.on_attach = function(client, bufnr)
        lsp_zero.extend_lspconfig()
        lsp_zero.default_keymaps({ buffer = bufnr })

        local nmap = function(keys, func, desc)
          if desc then
            desc = 'LSP: ' .. desc
          end

          vim.keymap.set('n', keys, func, { buffer = bufnr, desc = desc })
        end

        nmap('<F2>', vim.lsp.buf.rename, '[C]ode [R]ename')
        nmap('<leader>ca', vim.lsp.buf.code_action, '[C]ode [A]ction')
        -- nmap('<leader>ch', vim.lsp.buf.hover, '[C]ode [H]over')
        -- nmap('<leader>cs', vim.lsp.buf.workspace_symbol, '[C]ode [S]ymbol')

        nmap('gd', require('telescope.builtin').lsp_definitions, '[G]oto [D]efinition')
        nmap('gr', require('telescope.builtin').lsp_references, '[G]oto [R]eferences')
        -- nmap('gI', require('telescope.builtin').lsp_implementations, '[G]oto [I]mplementation')
        -- nmap('<leader>ds', require('telescope.builtin').lsp_document_symbols, '[D]ocument [S]ymbols')
        -- nmap('<leader>ws', require('telescope.builtin').lsp_dynamic_workspace_symbols, '[W]orkspace [S]ymbols')

        -- vim.api.nvim_buf_create_user_command(bufnr, 'Format', function(_)
        --   vim.lsp.buf.format()
        -- end, { desc = 'Format current buffer with LSP' })

        -- nmap('<leader>cf', vim.lsp.buf.format, '[C]ode [F]ormat')

        -- Autoformat on save
        -- local auto_group = vim.api.nvim_create_augroup("LspAuGroup", { clear = true })
        -- if client.server_capabilities.documentFormattingProvider then
        --   vim.api.nvim_create_autocmd("BufWritePre", {
        --     callback = function() vim.lsp.buf.format() end,
        --     group = auto_group,
        --   })
        -- end
      end

      require('mason').setup({})
      require('mason-lspconfig').setup({
        ensure_installed = {
          'bashls',
          'clangd',
          'dartls',
          'dockerls',
          'docker_compose_language_service',
          'eslint',
          'emmet_ls',
          'gopls',
          'gradle_ls',
          'html',
          'jsonls',
          'jdtls',
          'tsserver',
          'kotlin_language_server',
          'lua_ls',
          'marksman',
          'jedi_language_server',
          'rust_analyzer',
          'sqlls',
          'svelte',
          'vuels',
          'yamlls',
        },
        handlers = {
          lsp_zero.default_setup,
          lua_ls = function()
            local lua_opts = lsp_zero.nvim_lua_ls()
            require('lspconfig').lua_ls.setup(lua_opts)
          end
        }
      }
      )
    end
  },

  {
    'akinsho/flutter-tools.nvim',
    dependencies = {
      'nvim-lua/plenary.nvim',
      'stevearc/dressing.nvim',
      'VonHeikemen/lsp-zero.nvim'
    },
    config = function()
      return {
        lsp = {
          capabilities = require('lsp-zero').get_capabilities()
        }
      }
    end
  },
}, function()

end
