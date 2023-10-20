return {
  dependencies = {
    { 'VonHeikemen/lsp-zero.nvim',        branch = 'v3.x', },
    { 'hrsh7th/nvim-cmp' },
    { 'neovim/nvim-lspconfig' },
    { 'L3MON4D3/LuaSnip' },
    { 'hrsh7th/cmp-buffer' },
    { 'hrsh7th/cmp-path' },
    { 'hrsh7th/cmp-calc' },
    { 'zbirenbaum/copilot.lua' },
    { 'zbirenbaum/copilot-cmp' },
    { 'hrsh7th/cmp-nvim-lsp' },
    { 'williamboman/mason.nvim' },
    { 'williamboman/mason-lspconfig.nvim' },
    { 'akinsho/flutter-tools.nvim' }
  },
  setup = function()
    -- Startup function for LSP and CMP
    local lsp_zero = require('lsp-zero')

    -- CMP
    lsp_zero.extend_cmp()

    require('copilot').setup({
      suggestion = { enabled = false },
      panel = { enabled = false },
    })
    require('copilot_cmp').setup()

    -- And you can configure cmp even more, if you want to.
    local cmp = require('cmp')
    local cmp_action = lsp_zero.cmp_action()
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

    -- LSP
    lsp_zero.extend_lspconfig()

    -- on_attach
    lsp_zero.on_attach = function(client, bufnr)
      lsp_zero.default_keymaps({ buffer = bufnr })

      local nmap = function(keys, func, desc)
        if desc then
          desc = 'LSP: ' .. desc
        end

        vim.keymap.set('n', keys, func, { buffer = bufnr, desc = desc })
      end

      nmap('<F2>', vim.lsp.buf.rename, '[C]ode [R]ename')
      nmap('<leader>ca', vim.lsp.buf.code_action, '[C]ode [A]ction')
      nmap('<leader>ch', vim.lsp.buf.hover, '[C]ode [H]over')
      -- nmap('<leader>cs', vim.lsp.buf.workspace_symbol, '[C]ode [S]ymbol')

      nmap('gd', require('telescope.builtin').lsp_definitions, '[G]oto [D]efinition')
      nmap('gr', require('telescope.builtin').lsp_references, '[G]oto [R]eferences')
      -- nmap('gI', require('telescope.builtin').lsp_implementations, '[G]oto [I]mplementation')
      -- nmap('<leader>ds', require('telescope.builtin').lsp_document_symbols, '[D]ocument [S]ymbols')
      -- nmap('<leader>ws', require('telescope.builtin').lsp_dynamic_workspace_symbols, '[W]orkspace [S]ymbols')

      vim.api.nvim_buf_create_user_command(bufnr, 'Format', function(_)
        vim.lsp.buf.format()
      end, { desc = 'Format current buffer with LSP' })

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

    -- mason
    require('mason').setup({})
    require('mason-lspconfig').setup({
      ensure_installed = {
        'bashls',
        'clangd',
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
        end,
      }
    })

    -- flutter tools
    require('flutter-tools').setup({
      lsp = {
        capabilities = lsp_zero.get_capabilities()
      },
    })
  end
}
