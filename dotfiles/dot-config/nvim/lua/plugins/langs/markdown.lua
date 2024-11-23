local ft = { "markdown" }
local ft_quarto = { "markdown", "quarto" }

return {
  Util.lazy.ensure_installed({
    treesitter = { "markdown", "markdown_inline" },
    lint = { "pymarkdownlnt" },
  }),
  -- Vim has built in folding but it doesn't work with yaml frontmatter
  -- vim.g.markdown_folding = 1
  { "masukomi/vim-markdown-folding" },
  {
    "nvim-lint",
    opts = {
      linters_by_ft = {
        markdown = { "pymarkdownlnt" },
      },
      linters = {
        pymarkdownlnt = {
          cmd = "pymarkdownlnt",
          stdin = true,
          args = {
            "-s",
            "plugins.md012.maximum=$#2",
            "scan-stdin",
          },
          stream = nil,
          ignore_exitcode = true,
          parser = function()
            return require("lint.parser").from_errorformat("stdin:%l:%c: %m", {
              source = "pymarkdownlnt",
              severity = vim.diagnostic.severity.WARN,
            })
          end,
        },
      },
    },
  },
  -- Additional plugins
  {
    "MeanderingProgrammer/render-markdown.nvim",
    ft = ft_quarto,
    opts = {
      file_types = ft_quarto,
      code = {
        sign = false,
        width = "block",
        right_pad = 1,
      },
      heading = {
        sign = false,
        icons = {},
      },
      checkbox = {
        custom = {
          rightarrow = { raw = "[>]", rendered = " ", highlight = "RenderMarkdownInfo", scope_highlight = nil },
          tilde = { raw = "[~]", rendered = "󰰱 ", highlight = "RenderMarkdownError", scope_highlight = nil },
          important = { raw = "[!]", rendered = " ", highlight = "RenderMarkdownWarn", scope_highlight = nil },
        },
      },
    },
    keys = {
      {
        "<leader>um",
        function()
          require("render-markdown").toggle()
        end,
        desc = "Toggle Render markdown",
        ft = ft_quarto,
      },
    },
  },
  {
    "iamcco/markdown-preview.nvim",
    cmd = { "MarkdownPreviewToggle", "MarkdownPreview", "MarkdownPreviewStop" },
    build = function()
      require("lazy").load({ plugins = { "markdown-preview.nvim" } })
      vim.fn["mkdp#util#install"]()
    end,
    keys = {
      {
        "<leader>up",
        "<cmd>MarkdownPreviewToggle<cr>",
        desc = "Markdown Preview",
        ft = ft,
      },
    },
    config = function()
      vim.cmd([[do FileType]])
    end,
  },
}
