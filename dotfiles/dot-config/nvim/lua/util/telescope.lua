local actions = require("telescope.actions")
local action_state = require("telescope.actions.state")
local finders = require("telescope.finders")
local make_entry = require("telescope.make_entry")
local pickers = require("telescope.pickers")
local utils = require("telescope.utils")

local entry_display = require("telescope.pickers.entry_display")
local conf = require("telescope.config").values

local function make_entry_gen_from_commands(opts)
  local displayer = entry_display.create({
    separator = "▏",
    items = {
      { width = 0.2 },
      { width = 4 },
      { width = 4 },
      { width = 11 },
      { remaining = true },
    },
  })

  local make_display = function(entry)
    local attrs = ""
    if entry.bang then
      attrs = attrs .. "!"
    end
    if entry.bar then
      attrs = attrs .. "|"
    end
    if entry.register then
      attrs = attrs .. '"'
    end
    return displayer({
      { entry.name, "TelescopeResultsIdentifier" },
      -- attrs,
      -- entry.nargs,
      -- entry.complete or "",
      -- entry.definition:gsub("\n", " "),
    })
  end

  return function(entry)
    return make_entry.set_default_entry_mt({
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

local function run_command(opts, filter)
  -- modified version of telescope's builtin.commands to allow filters
  local params = { opts = opts, filter = filter }
  opts = params.opts or {}
  filter = params.filter

  pickers
    .new(opts, {
      prompt_title = "Commands",
      finder = finders.new_table({
        results = (function()
          local command_iter = vim.api.nvim_get_commands({})
          local commands = {}

          for _, cmd in pairs(command_iter) do
            if filter.pattern == nil or cmd.name:find(filter.pattern) ~= nil then
              table.insert(commands, cmd)
            end
          end

          local need_buf_command = vim.F.if_nil(opts.show_buf_command, true)

          if need_buf_command then
            local buf_command_iter = vim.api.nvim_buf_get_commands(0, {})
            buf_command_iter[true] = nil -- remove the redundant entry
            for _, cmd in pairs(buf_command_iter) do
              if filter.pattern == nil or cmd.name:find(filter.pattern) ~= nil then
                table.insert(commands, cmd)
              end
            end
          end
          return commands
        end)(),
        entry_maker = opts.entry_maker or make_entry_gen_from_commands(opts),
      }),
      sorter = conf.generic_sorter(opts),
      attach_mappings = function(prompt_bufnr)
        actions.select_default:replace(function()
          local selection = action_state.get_selected_entry()
          if selection == nil then
            utils.__warn_no_selection("builtin.commands")
            return
          end

          actions.close(prompt_bufnr)
          local val = selection.value
          local cmd = string.format([[:%s ]], val.name)

          if val.nargs == "0" then
            local cr = vim.api.nvim_replace_termcodes("<cr>", true, false, true)
            cmd = cmd .. cr
          end
          vim.cmd([[stopinsert]])
          vim.api.nvim_feedkeys(cmd, "nt", false)
        end)

        return true
      end,
    })
    :find()
end

return {
  run_command = run_command,
}
