local actions = require("telescope.actions")
local action_state = require("telescope.actions.state")

local M = {}
M.command = {}
-- Just the command name, nice and clean
function M.command.entry_maker(opts)
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
function M.command.finder(opts)
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
  local terminals = require("util.terminal").terminals
  require("telescope.pickers")
    .new(opts, {
      prompt_title = "Terminals",
      finder = M.finder_from_table(terminals),
      sorter = require("telescope.config").values.generic_sorter(opts),
      attach_mappings = function(prompt_bufnr, _)
        actions.select_default:replace(function()
          actions.close(prompt_bufnr)
          local selection = action_state.get_selected_entry()
          LazyVim.terminal(nil, { cwd = selection[1] })
        end)
        return true
      end,
    })
    :find()
end

function M.finder_from_table(t)
  return require("telescope.finders").new_table(t)
end

function M.builtin(builtin, opts)
  return require("telescope.builtin")[builtin](opts)
end

function M.git_files(opts)
  opts = opts or {}
  opts.cwd = opts.cwd or require("util.root").git(opts)
  if require("util.git_worktree").is_inside_worktree(opts.cwd) then
    return M.builtin("git_files", opts)
  else
    return M.find_files(opts)
  end
end

function M.find_files(opts)
  return M.builtin("find_files", opts)
end

function M.config()
  return M.git_files({
    cwd = vim.fn.expand("$HOME/.dotfiles"),
    show_untracked = true,
    git_command = { "/bin/zsh", "-c", "git ls-files --exclude-standard --cached" },
  })
end

function M.buffers(opts)
  opts = vim.tbl_extend("force", {
    sort_lastused = true,
    sort_mru = true,
    attach_mappings = function(prompt_bufnr, map)
      map("n", "D", function()
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

M.defaults = {
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
}

return M
