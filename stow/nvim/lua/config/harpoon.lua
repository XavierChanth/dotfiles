local exceptions = { "^oil://", ".jjdescription$", "^/tmp/" }
vim.api.nvim_create_autocmd("BufEnter", {
  callback = function(args)
    if #args.file == 0 then
      return
    end
    for _, exception in ipairs(exceptions) do
      if args.file:find(exception) then
        return
      end
    end
    local l = require("harpoon"):list("buffers")
    l:remove()
    l:prepend()
  end,
})
vim.api.nvim_create_autocmd("BufDelete", {
  callback = function(args)
    local l = require("harpoon"):list("buffers")
    local v = l:get_by_value(args.file)
    l:remove(v)
  end,
})
