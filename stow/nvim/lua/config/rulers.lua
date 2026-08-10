-- ▏ │ ┊ ╎ ┆
local ruler_char = "▏"
-- local ruler_char = "│"
-- local ruler_char = "┊"
-- local ruler_char = "╎"
-- local ruler_char = "┆"

local columns = { 81, 121 }
local highlight = "ColumnRuler"
local namespace = vim.api.nvim_create_namespace("column_rulers")

local function set_highlight()
  vim.api.nvim_set_hl(0, highlight, { default = true, link = "WhiteSpace" })
end

set_highlight()
vim.api.nvim_create_autocmd("ColorScheme", {
  group = vim.api.nvim_create_augroup(
    "column_rulers_highlight",
    { clear = true }
  ),
  callback = set_highlight,
})

vim.api.nvim_set_decoration_provider(namespace, {
  on_win = function(_, win, buf, top, bottom)
    if vim.bo[buf].buftype ~= "" then
      return false
    end

    local last = math.min(bottom + 1, vim.api.nvim_buf_line_count(buf))
    local lines = vim.api.nvim_buf_get_lines(buf, top, last, false)
    local leftcol, text_width, line_widths

    vim.api.nvim_win_call(win, function()
      local window_info = vim.fn.getwininfo(win)[1]
      leftcol = vim.fn.winsaveview().leftcol
      text_width = vim.api.nvim_win_get_width(win) - window_info.textoff
      line_widths = vim.tbl_map(vim.fn.strdisplaywidth, lines)
    end)

    for offset, line_width in ipairs(line_widths) do
      local row = top + offset - 1
      for _, column in ipairs(columns) do
        local window_column = column - 1 - leftcol
        local column_is_visible = window_column >= 0
          and window_column < text_width
        local column_has_text = line_width >= column

        if column_is_visible and not column_has_text then
          vim.api.nvim_buf_set_extmark(buf, namespace, row, 0, {
            ephemeral = true,
            hl_mode = "combine",
            priority = 1,
            strict = false,
            virt_text = { { ruler_char, highlight } },
            virt_text_hide = true,
            virt_text_pos = "overlay",
            virt_text_win_col = window_column,
          })
        end
      end
    end
  end,
})
