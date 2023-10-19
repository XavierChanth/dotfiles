return {
  {
    'VonHeikemen/lsp-zero.nvim',
    branch = 'v3.x',
    on_attach = function(client, bufnr)
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

      -- Autoformat on save
      -- local auto_group = vim.api.nvim_create_augroup("LspAuGroup", { clear = true })
      -- if client.server_capabilities.documentFormattingProvider then
      --   vim.api.nvim_create_autocmd("BufWritePre", {
      --     callback = function() vim.lsp.buf.format() end,
      --     group = auto_group,
      --   })
      -- end
    end,
  },

  { 'williamboman/mason.nvim',
  },
  { 'williamboman/mason-lspconfig.nvim' },
  { 'neovim/nvim-lspconfig' },
  { 'hrsh7th/nvim-cmp' },
  { 'hrsh7th/cmp-nvim-lsp' },
  { 'hrsh7th/cmp-buffer', },
  { 'L3MON4D3/LuaSnip' },
  { 'zbirenbaum/copilot.lua' },
  { 'zbirenbaum/copilot-cmp' },
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
}
