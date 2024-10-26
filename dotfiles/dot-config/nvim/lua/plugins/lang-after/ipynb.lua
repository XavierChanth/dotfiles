local venv_bin = "~/.dotfiles/.venv/bin/"
local bufgroup = vim.api.nvim_create_augroup("Molten", { clear = true })

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
      "jmbuhr/otter.nvim",
      "nvim-treesitter",
      "GCBallesteros/jupytext.nvim",
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
      -- Initialize the buffer properly
      vim.api.nvim_create_autocmd("BufReadPre", {
        group = bufgroup,
        pattern = "*.ipynb",
        callback = function(_)
          local function setup_buffer()
            vim.g.python3_host_prog = vim.fn.expand(venv_bin .. "python3")

            vim.g.molten_auto_open_output = false
            vim.g.molten_wrap_output = true
            vim.g.molten_virt_text_output = true
            vim.g.molten_virt_lines_off_by_1 = true
            vim.g.magma_image_provider = "wezterm"
            vim.g.molten_auto_image_popup = true

            vim.cmd("MoltenInit")
            require("quarto").activate()
          end
          if not require("util.lazy").is_loaded("jupytext") then
            -- first time setup
            require("jupytext").setup({
              style = "quarto",
              output_extension = "qmd",
              force_ft = "quarto",
            }) -- jupytext must start first

            vim.schedule(function()
              vim.cmd("bd|e#")
            end)
            vim.schedule(setup_buffer)
          else
            setup_buffer()
          end
        end,
      })
      -- Setup keymaps on enter
      vim.api.nvim_create_autocmd("BufEnter", {
        group = vim.api.nvim_create_augroup("MoltenKeys", { clear = true }),
        callback = function(event)
          local map = function(keymap)
            keymap.mode = keymap.mode or "n"
            vim.keymap.set(keymap.mode, keymap[1], keymap[2], { buffer = event.buf, desc = "ipynb: " .. keymap.desc })
          end
          map({
            "<localleader>k",
            function()
              vim.cmd("MoltenInit")
            end,
            desc = "kernel",
            silent = true,
          })
          map({
            "<localleader>i",
            function()
              vim.cmd("MoltenInfo")
            end,
            desc = "info",
            silent = true,
          })
          map({
            "<localleader>p",
            function()
              require("quarto").quartoPreview()
            end,
            desc = "run cell",
            silent = true,
          })

          map({
            "<localleader>r",
            function()
              require("quarto.runner").run_cell()
            end,
            desc = "run cell",
            silent = true,
          })
          map({
            "<localleader>l",
            function()
              require("quarto.runner").run_line()
            end,
            desc = "run line",
            silent = true,
          })
          map({
            "<localleader>a",
            function()
              require("quarto.runner").run_all()
            end,
            desc = "run all cells",
            silent = true,
          })
          map({
            "<localleader>A",
            function()
              require("quarto.runner").run_all(true)
            end,
            desc = "run all cells of all languages",
            silent = true,
          })
          map({
            "gr",
            function()
              require("quarto.runner").run_range()
            end,
            desc = "run visual range",
            silent = true,
            mode = "v",
          })
        end,
      })
    end,
  },
}
