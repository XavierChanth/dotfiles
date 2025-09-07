vim.api.nvim_create_user_command("AnsiColorize", function()
  local buf = vim.api.nvim_get_current_buf()
  local lines = vim.api.nvim_buf_get_lines(buf, 0, -1, false)
  while #lines > 0 and vim.trim(lines[#lines]) == "" do
    lines[#lines] = nil
  end
  vim.api.nvim_buf_set_lines(buf, 0, -1, false, {})
  vim.api.nvim_chan_send(
    vim.api.nvim_open_term(buf, {}),
    table.concat(lines, "\r\n")
  )
end, {})

vim.api.nvim_create_user_command("Format", function()
  require("conform").format({})
end, {})
