---@class util.telescope
local M = {}
M.command = {}

-- Finder that allows you to specify a regex filter
function M.command.finder(opts)
  return require("telescope.finders").new_table({
    results = (function()
      local command_iter = vim.api.nvim_get_commands({})
      local commands = {}

      for _, cmd in pairs(command_iter) do
        if opts.regex == nil or cmd.name:find(opts.regex) ~= nil then
          table.insert(commands, cmd)
        end
      end

      local need_buf_command = vim.F.if_nil(opts.show_buf_command, true)

      if need_buf_command then
        local buf_command_iter = vim.api.nvim_buf_get_commands(0, {})
        buf_command_iter[true] = nil -- remove the redundant entry
        for _, cmd in pairs(buf_command_iter) do
          if cmd.name:find(opts.regex) ~= nil then
            table.insert(commands, cmd)
          end
        end
      end
      return commands
    end)(),
    entry_maker = opts.entry_maker or M.command.entry_maker(opts),
  })
end

-- Picker that allows you to specify a regex filter
function M.command.picker(opts)
  require("telescope.builtin")["commands"]({
    finder = M.command.finder(opts),
    theme = "dropdown",
  })
end

function M.terminals(opts)
  local util = Util.terminal
  local terminals = {}
  for index, term in pairs(util.get_terminals()) do
    if term ~= nil then
      terminals[#terminals + 1] = index
    end
  end

  require("telescope.pickers")
    .new(opts, {
      prompt_title = "Terminals",
      finder = M.finder_from_table(terminals),
      sorter = require("telescope.config").values.generic_sorter(opts),
      initial_mode = "normal",
      attach_mappings = function(prompt_bufnr, map)
        local actions = require("telescope.actions")
        local action_state = require("telescope.actions.state")

        actions.select_default:replace(function()
          actions.close(prompt_bufnr)
          local item = action_state.get_selected_entry()[1]
          util.existing_terminal(item)
          vim.schedule(vim.cmd.startinsert)
        end)
        local function delete_from_telescope()
          ---@diagnostic disable-next-line: redundant-parameter
          local cwd = action_state.get_selected_entry(prompt_bufnr)[1]
          util.remove(cwd)
        end
        map("i", "<C-d>", delete_from_telescope)
        map("n", "<C-d>", delete_from_telescope)
        return true
      end,
    })
    :find()
end

function M.finder_from_table(t)
  return require("telescope.finders").new_table(t)
end

function M.builtin(builtin, opts)
  if opts == nil then
    return function(o)
      return require("telescope.builtin")[builtin](o)
    end
  end
  return require("telescope.builtin")[builtin](opts)
end

function M.buffers(opts)
  opts = vim.tbl_extend("force", {
    sort_lastused = true,
    sort_mru = true,
    attach_mappings = function(prompt_bufnr, map)
      local actions = require("telescope.actions")
      local action_state = require("telescope.actions.state")

      map("n", "<C-d>", function()
        local current_picker = action_state.get_current_picker(prompt_bufnr)
        local multi_selections = current_picker:get_multi_selection()

        if next(multi_selections) == nil then
          local selection = action_state.get_selected_entry()
          actions.close(prompt_bufnr)
          vim.api.nvim_buf_delete(selection.bufnr, {})
        else
          actions.close(prompt_bufnr)
          for _, selection in ipairs(multi_selections) do
            vim.api.nvim_buf_delete(selection.bufnr, {})
          end
        end
      end)
      return true
    end,
  }, opts or {})
  M.builtin("buffers", opts)
end

return M
