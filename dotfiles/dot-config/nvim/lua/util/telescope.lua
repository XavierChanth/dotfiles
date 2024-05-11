-- Just the command name, nice and clean
local function command_entry_maker(opts)
  local make_display = function(entry)
    return require("telescope.pickers.entry_display").create({
      separator = "▏",
      items = {
        { width = 100 },
        { remaining = true },
      },
    })({
      { entry.name, "TelescopeResultsIdentifier" },
    })
  end

  return function(entry)
    return require("telescope.make_entry").set_default_entry_mt({
      name = entry.name,
      bang = entry.bang,
      nargs = entry.nargs,
      complete = entry.complete,
      definition = entry.definition,
      --
      value = entry,
      ordinal = entry.name,
      display = make_display,
    }, opts)
  end
end

-- Finder that allows you to specify a regex filter
local command_finder = function(opts)
  local regex = opts.regex or ".*"
  return require("telescope.finders").new_table({
    results = (function()
      local command_iter = vim.api.nvim_get_commands({})
      local commands = {}

      for _, cmd in pairs(command_iter) do
        if cmd.name:find(regex) ~= nil then
          table.insert(commands, cmd)
        end
      end

      local need_buf_command = vim.F.if_nil(opts.show_buf_command, true)

      if need_buf_command then
        local buf_command_iter = vim.api.nvim_buf_get_commands(0, {})
        buf_command_iter[true] = nil -- remove the redundant entry
        for _, cmd in pairs(buf_command_iter) do
          if cmd.name:find(regex) ~= nil then
            table.insert(commands, cmd)
          end
        end
      end
      return commands
    end)(),
    entry_maker = opts.entry_maker or command_entry_maker(opts),
  })
end

-- Picker that allows you to specify a regex filter
local command_picker = function(opts)
  require("telescope.builtin")["commands"]({
    finder = command_finder(opts),
    theme = "dropdown",
  })
end

return {
  command_entry_maker = command_entry_maker,
  -- command_finder = command_finder, -- no need to use this when command picker does the extra wrapping
  command_picker = command_picker,
  defaults = {
    mappings = {
      n = {
        ["o"] = require("telescope.actions.layout").toggle_preview,
      },
      i = {
        ["<C-o>"] = require("telescope.actions.layout").toggle_preview,
      },
    },
    results_title = false,
    sorting_strategy = "ascending",
    layout_strategy = "flex",
    layout_config = {
      anchor = "top",
      prompt_position = "top",
    },
  },
}
