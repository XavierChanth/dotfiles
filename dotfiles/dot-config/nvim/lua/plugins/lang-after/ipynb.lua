local keygroup = vim.api.nvim_create_augroup("MoltenKeys", { clear = true })
local function create_reloadgroup()
  return vim.api.nvim_create_augroup("MoltenReload", { clear = true })
end

-- Manual installation steps
-- 1. First time setup (Do once)
--    brew install quarto
--
-- 2. Install venv (Do once)
--    uv venv
--    source .venv/bin/activate
--    uv pip install pynvim jupyter_client cairosvg plotlu kaleido pnglatex pyperclip jupytext
--
-- 3. Setup project (Do for each new project)
--    uv init
--    uv add --dev ipykernel
--    uv python -m ipykernel install --user --name <KERNEL_NAME>

return {
  {
    "GCBallesteros/jupytext.nvim",
    opts = {
      style = "quarto",
      output_extension = "qmd",
      force_ft = "quarto",
    },
  },
  {
    "quarto-dev/quarto-nvim",
    opts = {
      debug = false,
      closePreviewOnExit = true,
      lspFeatures = {
        enabled = true,
        chunks = "curly",
        languages = { "r", "python", "julia", "bash", "html" },
        diagnostics = {
          enabled = true,
          triggers = { "BufWritePost" },
        },
        completion = {
          enabled = true,
        },
      },
      codeRunner = {
        enabled = true,
        default_method = "molten", -- 'molten' or 'slime'
        ft_runners = { python = "molten" },
        never_run = { "yaml" }, -- filetypes which are never sent to a code runner
      },
    },
    dependencies = {
      "jupytext.nvim",
      "jmbuhr/otter.nvim",
    },
  },
  {
    "benlubas/molten-nvim",
    event = "BufReadPre *.ipynb",
    build = ":UpdateRemotePlugins",
    dependencies = {
      "quarto-nvim",
      { -- for images
        "willothy/wezterm.nvim",
        opts = { create_commands = false },
      },
    },
    init = function()
      vim.g.python3_host_prog = vim.fn.expand("~/.dotfiles/.venv/bin/python3")
      vim.g.molten_auto_open_output = false
      vim.g.molten_wrap_output = true
      vim.g.molten_virt_text_output = true
      vim.g.molten_virt_lines_off_by_1 = true
      vim.g.magma_image_provider = "wezterm"
      vim.g.molten_auto_image_popup = true
      vim.api.nvim_set_hl(0, "MoltenOutputBorder", { link = "Comment" })
    end,
    config = function()
      vim.api.nvim_create_autocmd("User", {
        pattern = "MoltenInitPost",
        callback = function()
          require("quarto").activate()
        end,
      })

      vim.api.nvim_create_autocmd("BufEnter", {
        pattern = "*.ipynb",
        group = keygroup,
        callback = require("util.ipynb").buf_enter,
      })
    end,
  },
}
