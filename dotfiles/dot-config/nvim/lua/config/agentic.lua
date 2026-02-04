local a = require("agentic")
a.setup({
  provider = "opencode-acp",
  auto_add_to_context = false,
})

vim.api.nvim_create_user_command("Agentic", function(info)
  if #info.fargs == 0 then
    a.toggle()
  else
    local fn = a[info.fargs[1]]
    if fn then
      fn()
    end
  end
end, {
  nargs = "?",
  complete = function()
    return {
      "toggle",
      "open",
      "close",
      "add_selection",
      "add_file",
      "add_selection_or_file_to_context",
      "new_session",
      "stop_generation",
      "restore_session",
    }
  end,
})

vim.keymap.set({ "n", "v" }, "<leader>l", function()
  a.add_selection_or_file_to_context({})
end)
