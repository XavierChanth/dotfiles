vim.api.nvim_create_user_command(
  "PackUpdate",
  "lua vim.pack.update()",
  {}
)

vim.api.nvim_create_user_command(
  "PackInstall",
  [[lua require("utils/pack").install()]],
  {}
)

local pack_complete = function(arg_lead)
  local matches = {}
  local prefix = "^" .. vim.pesc(arg_lead or "")
  for _, plugin in ipairs(vim.pack.get()) do
    local name = plugin.spec and plugin.spec.name or nil
    if name and name:match(prefix) then
      table.insert(matches, name)
    end
  end
  table.sort(matches)
  return matches
end

vim.api.nvim_create_user_command(
  "PackRemove",
  function(opts)
    vim.pack.del(opts.fargs)
  end,
  {
    nargs = "+",
    complete = function(arg_lead, _, _)
      return pack_complete(arg_lead)
    end,
  }
)
