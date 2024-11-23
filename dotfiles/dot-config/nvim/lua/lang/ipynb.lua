local keygroup = vim.api.nvim_create_augroup("MoltenKeys", { clear = true })

-- Manual installation steps
-- 1. First time setup (Do once)
--    brew install quarto
--
-- 2. Install venv (Do once)
--    uv venv
--    source .venv/bin/activate
--    uv pip install pynvim jupyter_client cairosvg plotly kaleido pnglatex pyperclip jupytext
--
-- 3. Setup project (Do for each new project)
--    uv init
--    uv add --dev ipykernel
--    uv run -m ipykernel install --user --name <KERNEL_NAME>

return {
  {
    "nvim-lspconfig",
    opts = {
      attach_server = {
        basedpyright = function(client, event)
          if event.match:match("ipynb.otter") then
            client.config.settings.basedpyright = vim.tbl_deep_extend("force", client.config.settings.basedpyright, {
              analysis = { diagnosticSeverityOverrides = { reportUnusedExpression = "none" } },
            })
          end
        end,
      },
    },
  },
  {
    "conform.nvim",
    opts = {
      formatters_by_ft = {
        quarto = { "injected" },
      },
    },
  },
  {
    "benlubas/molten-nvim",
    ft = "ipynb",
    build = ":UpdateRemotePlugins",
    dependencies = {
      "GCBallesteros/jupytext.nvim",
      "quarto-dev/quarto-nvim",
      "jmbuhr/otter.nvim",
      "willothy/wezterm.nvim",
    },
    init = function()
      vim.filetype.add({
        extension = {
          ipynb = "ipynb",
        },
      })
      vim.g.python3_host_prog = vim.fn.expand("~/.dotfiles/.venv/bin/python3")
    end,
    config = function()
      require("wezterm").setup({ create_commands = false })
      require("jupytext").setup({
        style = "quarto",
        output_extension = "qmd",
        force_ft = "quarto",
      })

      require("otter").setup({
        buffers = { set_filetype = true },
      })
      require("quarto").setup({
        lspFeatures = {
          enabled = true,
          chunks = "curly",
          languages = { "python", "bash", "html" },
        },
        codeRunner = {
          enabled = true,
          default_method = "molten",
          ft_runners = { python = "molten" },
          never_run = { "yaml" },
        },
      })

      -- Tell treesitter to parse quarto as markdown
      vim.treesitter.language.register("markdown", "quarto")

      vim.g.molten_auto_open_output = false
      vim.g.molten_wrap_output = true
      vim.g.molten_virt_text_output = true
      vim.g.molten_virt_lines_off_by_1 = true
      vim.g.molten_image_provider = "wezterm"
      vim.g.molten_auto_image_popup = true
      vim.api.nvim_set_hl(0, "MoltenOutputBorder", { link = "Comment" })

      -- Setup keybinds when we enter a quarto buffer
      vim.api.nvim_create_autocmd("Filetype", {
        pattern = "quarto",
        group = keygroup,
        callback = function(...)
          Util.ipynb.buf_enter(...)
        end,
      })

      vim.api.nvim_create_autocmd("BufDelete", {
        pattern = "*.ipynb",
        group = keygroup,
        callback = function(...)
          Util.ipynb.buf_delete(...)
        end,
      })

      -- Activate quarto when MoltenInit is finished
      vim.api.nvim_create_autocmd("User", {
        pattern = "MoltenInitPost",
        callback = function()
          vim.schedule(require("quarto").activate)
        end,
      })

      vim.schedule(function()
        -- Add jupytext to PATH
        vim.cmd('let $PATH=$"' .. vim.fn.expand("~/.dotfiles/.venv/bin/") .. ':{$PATH}"')

        -- reopen the buffers so buffer loads in qmd
        vim.cmd("e")
      end)
    end,
  },
}
