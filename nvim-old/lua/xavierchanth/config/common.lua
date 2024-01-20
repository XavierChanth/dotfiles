return {
  -- { 'tpope/vim-fugitive', },
  -- { 'tpope/vim-sleuth', },
  { 'ntpeters/vim-better-whitespace', },
  { 'Pocco81/auto-save.nvim', },
  {
    'numToStr/Comment.nvim',
    config = function()
      require('Comment').setup()
    end
  },
}
