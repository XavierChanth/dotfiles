-- For vim-markdown-folding
vim.opt_local.foldmethod = "expr"
-- vim.opt_local.wrap = false
vim.opt_local.shiftwidth = 2
vim.opt_local.spell = true

local function divider_textobject(ai_type)
  local regions = {}

  for line_number, line in ipairs(vim.api.nvim_buf_get_lines(0, 0, -1, false)) do
    local indent = line:match("^( *)%-%-%-[ \t]*$")
    if indent and #indent <= 3 then
      regions[#regions + 1] = {
        from = { line = line_number, col = 1 },
        to = { line = line_number, col = #line },
        vis_mode = ai_type == "a" and "V" or "v",
      }
    end
  end

  return regions
end

vim.b.miniai_config = vim.tbl_deep_extend("force", vim.b.miniai_config or {}, {
  custom_textobjects = {
    m = divider_textobject,
  },
})
