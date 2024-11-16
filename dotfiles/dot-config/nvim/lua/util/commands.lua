---@class util.commands
local M = {}

-- Finder that allows you to specify a regex filter
function M.finder(opts)
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
  })
end

-- Picker that allows you to specify a regex filter
function M.picker(opts)
  require("telescope.builtin")["commands"]({
    finder = M.finder(opts),
    theme = "dropdown",
  })
end

return M
