return {
  {
    'dccsillag/magma-nvim',
    event = "BufReadPre",
    build = function()
      vim.cmd("UpdateRemotePlugins")
    end,
    cmd = {
      "MagmaInit",
      "MagmaDeinit",
      "MagmaEvaluateLine",
      "MagmaEvaluateVisual",
      "MagmaEvaluateOperator",
      "MagmaEvaluateArgument",
      "MagmaReevaluateCell",
      "MagmaDelete",
      "MagmaShowOutput",
      "MagmaInterrupt",
      "MagmaRestart",
      "MagmaSave",
      "MagmaLoad",
      "MagmaEnterOutput",
    },
    -- TODO: setup other keys
    keys = {
      {
        "<leader>rm",
        function()
          local telescope = require("util.telescope")
          telescope.command.picker(
            {
              regex = "Magma.*"
            })
        end,
        desc = "Magma (ipynb) commands",
      }
    },
    config = function()
      -- vim.g.python3_host_prog = '/Users/chant/.dotfiles/.venv/bin/python'
    end,
  }
}
