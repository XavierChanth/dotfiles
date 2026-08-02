-- For vim-markdown-folding
vim.opt_local.foldmethod = "expr"
-- vim.opt_local.wrap = false
vim.opt_local.shiftwidth = 2
vim.opt_local.spell = true

local function divider_textobject(ai_type)
  local dividers = {}
  local regions = {}

  for line_number, line in ipairs(vim.api.nvim_buf_get_lines(0, 0, -1, false)) do
    local indent = line:match("^( *)%-%-%-[ \t]*$")
    if indent and #indent <= 3 then
      dividers[#dividers + 1] = line_number
    end
  end

  for index = 1, #dividers - 1 do
    local first_line = dividers[index]
    local last_line = dividers[index + 1]
    local from_line = ai_type == "a" and first_line or first_line + 1
    local to_line = ai_type == "a" and last_line or last_line - 1

    if from_line <= to_line then
      regions[#regions + 1] = {
        from = { line = from_line, col = 1 },
        to = { line = to_line, col = 1 },
        vis_mode = "V",
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
