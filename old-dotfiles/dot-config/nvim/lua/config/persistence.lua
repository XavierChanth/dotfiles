local persistence = require("persistence")
local fname = vim.fn.argv(-1)[1]
-- Ignore sessionizing jj desc files
if fname and string.find(vim.fs.basename(fname), ".jjdescription") then
  P("disable")
  return
end

persistence.setup({})
