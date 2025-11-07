vim.api.nvim_create_user_command("Blame", function()
  local pos = vim.fn.getpos(".")
  vim.cmd[[tabnew | r!jj file annotate --color always #]]
  require("utils.ansi-hi").apply()

  -- Adjust cursor position in the blame buffer
  pos[2] = pos[2] + 1
  pos[3] = 0
  vim.fn.setpos(".", pos)
end, {})
