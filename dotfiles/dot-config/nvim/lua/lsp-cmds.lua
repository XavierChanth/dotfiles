local configured_lsps = function(arg)
  return vim
    .iter(vim.api.nvim_get_runtime_file(("lsp/%s*.lua"):format(arg), true))
    :map(function(path)
      local file_name = path:match("[^/]*.lua$")
      return file_name:sub(0, #file_name - 4)
    end)
    :totable()
end

vim.api.nvim_create_user_command("LspRestart", function(info)
  local clients = info.fargs

  -- Default to restarting all active servers
  if #clients == 0 then
    clients = vim
      .iter(vim.lsp.get_clients())
      :map(function(client)
        return client.name
      end)
      :totable()
  end

  for _, name in ipairs(clients) do
    if vim.lsp.config[name] == nil then
      vim.notify(("Invalid server name '%s'"):format(name))
    else
      vim.lsp.enable(name, false)
    end
  end

  local timer = assert(vim.uv.new_timer())
  timer:start(500, 0, function()
    for _, name in ipairs(clients) do
      vim.schedule_wrap(function(x)
        vim.lsp.enable(x)
      end)(name)
    end
  end)
end, {
  desc = "Restart the given client",
  nargs = "?",
  complete = configured_lsps,
})
vim.api.nvim_create_user_command("LspStart", function(conf)
  if conf.args ~= "" then
    vim.lsp.enable(conf.args)
  else
    Snacks.picker()
  end
end, {
  nargs = "?",
  complete = configured_lsps,
})

vim.api.nvim_create_user_command("LspInfo", ":che vim.lsp", {})
vim.api.nvim_create_user_command("LspLog", function()
  vim.cmd(string.format("tabnew %s", vim.lsp.log.get_filename()))
end, {})
