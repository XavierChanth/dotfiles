local venv_bin = "~/.dotfiles/.venv/bin/"

local bufgroup = vim.api.nvim_create_augroup("Molten", { clear = true })

-- WIP, for now, no code execution or latex support
return {
  {
    "benlubas/molten-nvim",
    event = "BufReadPre *.ipynb",
    build = ":UpdateRemotePlugins",
    dependencies = {
      { -- lsp provider
        "quarto-dev/quarto-nvim",
        opts = { ft_runners = { python = "molten" } },
        dependencies = {
          "jmbuhr/otter.nvim",
          "nvim-treesitter",
          "GCBallesteros/jupytext.nvim",
        },
      },
      { -- for images
        "willothy/wezterm.nvim",
        opts = { create_commands = false },
      },
    },
    init = function()
      vim.g.python3_host_prog = vim.fn.expand(venv_bin .. "python3")

      vim.g.molten_auto_open_output = false
      vim.g.molten_wrap_output = true
      vim.g.molten_virt_text_output = true
      vim.g.molten_virt_lines_off_by_1 = true
      vim.g.magma_image_provider = "wezterm"

      vim.api.nvim_create_autocmd("BufReadPre", {
        group = bufgroup,
        pattern = "*.ipynb",
        callback = function(event)
          local function setup_buffer()
            vim.cmd("MoltenInit python3")
            require("otter").activate()
            require("quarto").activate()
          end
          if not require("util.lazy").is_loaded("jupytext") then
            -- first time setup
            require("jupytext").setup({
              style = "markdown",
              output_extension = "md",
              force_ft = "markdown",
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
      -- vim.api.nvim_create_autocmd("BufEnter", {
      --   group = vim.api.nvim_create_augroup("MoltenKeys", { clear = true }),
      --   callback = function(event)
      --     local map = function(keymap)
      --       keymap.mode = keymap.mode or "n"
      --       vim.keymap.set(keymap.mode, keymap[1], keymap[2], { buffer = event.buf, desc = "ipynb: " .. keymap.desc })
      --     end
      --     map({
      --       "<leader>rm",
      --       function()
      --         local telescope = require("util.telescope")
      --         telescope.command.picker({
      --           regex = "Molten.*",
      --         })
      --       end,
      --       desc = "Molten (jupyter) commands",
      --     })
      --     map({ "<localleader>e", ":MoltenEvaluateOperator<CR>", desc = "evaluate operator", silent = true })
      --     map({ "<localleader>o", ":noautocmd MoltenEnterOutput<CR>", desc = "open output window", silent = true })
      --     map({ "<localleader>rr", ":MoltenReevaluateCell<CR>", desc = "re-eval cell", silent = true })
      --     map({
      --       "<localleader>r",
      --       ":<C-u>MoltenEvaluateVisual<CR>gv",
      --       desc = "execute visual selection",
      --       mode = "v",
      --       silent = true,
      --     })
      --     map({
      --       "<localleader>h",
      --       ":MoltenHideOutput<CR>",
      --       desc = "close output window",
      --       silent = true,
      --     })
      --     map({ "<localleader>d", ":MoltenDelete<CR>", desc = "delete Molten cell", silent = true })
      --     map({ "<localleader>gx", ":MoltenOpenInBrowser<CR>", desc = "open output in browser", silent = true })
      --
      --     --quarto setup
      --     map({
      --       "<localleader>c",
      --       function()
      --         require("quarto.runner").run_cell()
      --       end,
      --       desc = "run cell",
      --       silent = true,
      --     })
      --     map({
      --       "<localleader>b",
      --       function()
      --         require("quarto.runner").run_above()
      --       end,
      --       desc = "run cell and cell before",
      --       silent = true,
      --     })
      --     map({
      --       "<localleader>a",
      --       function()
      --         require("quarto.runner").run_all()
      --       end,
      --       desc = "run all cells",
      --       silent = true,
      --     })
      --     map({
      --       "<localleader>l",
      --       function()
      --         require("quarto.runner").run_line()
      --       end,
      --       desc = "run line",
      --       silent = true,
      --     })
      --     map({
      --       "<localleader>r",
      --       function()
      --         require("quarto.runner").run_range()
      --       end,
      --       desc = "run visual range",
      --       silent = true,
      --       mode = "v",
      --     })
      --     map({
      --       "<localleader>A",
      --       function()
      --         require("quarto.runner").run_all(true)
      --       end,
      --       desc = "run all cells of all languages",
      --       silent = true,
      --     })
      --   end,
      -- })
    end,
  },
}
