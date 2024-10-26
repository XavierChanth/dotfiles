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

function M.select_kernel(opts)
  opts = opts or {}
  opts.kernels = opts.kernels or {}

  require("telescope.pickers")
    .new(opts, {
      prompt_title = "Select Kernel",
      finder = require("util.telescope").finder_from_table(opts.kernels),
      sorter = require("telescope.config").values.generic_sorter(opts),
      attach_mappings = function(prompt_bufnr, _)
        local actions = require("telescope.actions")
        local action_state = require("telescope.actions.state")
        actions.select_default:replace(function()
          actions.close(prompt_bufnr)
          local choice = action_state.get_selected_entry()[1]
          vim.cmd("MoltenInit " .. choice)
          vim.schedule(vim.cmd.startinsert)
        end)

        return true
      end,
    })
    :find()
end

function M.autocmd()
  vim.api.nvim_create_user_command("NewNotebook", function(opts)
    new_notebook(opts.args)
  end, {
    nargs = 1,
    complete = "file",
  })
end
return M
