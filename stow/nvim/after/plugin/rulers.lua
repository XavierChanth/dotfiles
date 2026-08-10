local group =
  vim.api.nvim_create_augroup("column_rulers_lazy", { clear = true })

vim.api.nvim_create_autocmd({ "BufReadPost", "BufNewFile" }, {
  group = group,
  callback = function(event)
    if vim.bo[event.buf].buftype ~= "" then
      return
    end

    require("config.rulers")
    vim.api.nvim_del_augroup_by_id(group)
  end,
})
