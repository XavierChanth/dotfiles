local path = vim.env.HOME .. "/src/xc/notes"
return {
  {
    "iamcco/markdown-preview.nvim",
    cmd = { "MarkdownPreviewToggle", "MarkdownPreview", "MarkdownPreviewStop" },
    ft = { "markdown" },
    build = function()
      vim.fn["mkdp#util#install"]()
    end,
  },
  {
    "edluffy/hologram.nvim",
    opts = {
      auto_display = true,
    },
  },
}
