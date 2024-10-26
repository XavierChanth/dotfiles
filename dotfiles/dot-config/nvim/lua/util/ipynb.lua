local M = {}
-- Provide a command to create a blank new Python notebook
-- note: the metadata is needed for Jupytext to understand how to parse the notebook.
-- if you use another language than Python, you should change it in the template.
local default_notebook = [[
  {
    "cells": [
     {
      "cell_type": "markdown",
      "metadata": {},
      "source": [
        ""
      ]
     }
    ],
    "metadata": {
     "kernelspec": {
      "display_name": "Python 3",
      "language": "python",
      "name": "python3"
     },
     "language_info": {
      "codemirror_mode": {
        "name": "ipython"
      },
      "file_extension": ".py",
      "mimetype": "text/x-python",
      "name": "python",
      "nbconvert_exporter": "python",
      "pygments_lexer": "ipython3"
     }
    },
    "nbformat": 4,
    "nbformat_minor": 5
  }
]]

local function new_notebook(filename)
  local path = filename .. ".ipynb"
  local file = io.open(path, "w")
  if file then
    file:write(default_notebook)
    file:close()
    vim.cmd("edit " .. path)
  else
    print("Error: Could not open new notebook file for writing.")
  end
end

function M.autocmd()
  vim.api.nvim_create_user_command("NewNotebook", function(opts)
    new_notebook(opts.args)
  end, {
    nargs = 1,
    complete = "file",
  })
end

function M.buf_enter(event)
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
    "<localleader>s",
    function()
      vim.cmd("MoltenSave")
    end,
    desc = "save output",
    silent = true,
  })
  map({
    "<localleader>o",
    function()
      vim.cmd("MoltenLoad")
    end,
    desc = "open output",
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
end

return M
