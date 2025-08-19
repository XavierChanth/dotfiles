local buffers = {} -- Buffer cache sorted by last entered

vim.api.nvim_create_autocmd("User", {
  pattern = "PersistenceLoadPost",
  callback = function()
    buffers = vim.api.nvim_list_bufs()
  end,
})

local function remove_buf(args)
  for index, value in ipairs(buffers) do
    if value == args.buf then
      table.remove(buffers, index)
    end
  end
end

vim.api.nvim_create_autocmd("BufEnter", {
  callback = function(args)
    remove_buf(args)
    table.insert(buffers, 1, args.buf)
  end,
})

vim.api.nvim_create_autocmd("BufDelete", { callback = remove_buf })

return {
  get = function()
    return buffers
  end,
}
