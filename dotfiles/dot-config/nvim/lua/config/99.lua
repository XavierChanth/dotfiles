local _99 = require("99")
_99.setup({
  completion = {
    custom_rules = {},
  },
  md_files = {
    "AGENTS.md",
  },
})
-- TODO wip
vim.api.nvim_create_user_command("P99", function(info)
  if info.range then
    _99.visual()
    return
  end
  P(info)
  if #info.fargs > 0 and info.fargs[1] == "stop" then
    _99.stop_all_requests()
    return
  end
  _99.fill_in_function()
end, {
  range = true,
  nargs = "?",
  complete = function()
    return {
      "stop",
      "function",
    }
  end,
})
