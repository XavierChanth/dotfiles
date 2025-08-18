M = {}
--:h highlight
--:h cterm-colors
--:h guifg
--:h syntax

-- Fully ansi compliant theme and syntax highlighting
-- 0: Black        │   8: Bright Black (dark gray)
-- 1: Red          │   9: Bright Red
-- 2: Green        │  10: Bright Green
-- 3: Yellow       │  11: Bright Yellow
-- 4: Blue         │  12: Bright Blue
-- 5: Magenta      │  13: Bright Magenta
-- 6: Cyan         │  14: Bright Cyan
-- 7: White (gray) │  15: Bright White

function M.load()
  vim.cmd([[
set notermguicolors
highlight clear
if exists("syntax_on")
  syntax reset
endif
]])

  if vim.o.background == "dark" then
--stylua: ignore
vim.cmd [[
highlight Comment ctermfg=8 cterm=italic
highlight Visual ctermbg=7
highlight WhiteSpace ctermfg=8
highlight Ignore ctermfg=8
highlight Folded ctermfg=8 ctermbg=8
highlight FoldColumn ctermfg=8 ctermbg=8
highlight LineNr       ctermfg=8
highlight CursorLineNr ctermfg=7
highlight SignColumn   ctermbg=8
highlight ColorColumn  ctermfg=7 ctermbg=8
highlight StatusLine   ctermfg=15 ctermbg=NONE cterm=NONE
highlight SpellCap     ctermfg=0 ctermbg=7
highlight Pmenu ctermfg=0 ctermbg=15 cterm=NONE
highlight PmenuSel ctermfg=0 ctermbg=Blue cterm=bold
highlight Delimiter ctermfg=7
highlight Operator ctermfg=7
highlight @variable ctermfg=15
highlight SnacksIndentScope ctermfg=7
]]
  else
--stylua: ignore
vim.cmd [[
highlight Visual ctermbg=7
highlight Comment ctermfg=7 cterm=italic
highlight WhiteSpace ctermfg=7
highlight Ignore ctermfg=7
highlight Folded ctermfg=7 ctermbg=8
highlight FoldColumn ctermfg=7 ctermbg=8
highlight LineNr       ctermfg=7
highlight CursorLineNr ctermfg=8
highlight SignColumn   ctermbg=7
highlight ColorColumn  ctermfg=8 ctermbg=7
highlight StatusLine   ctermfg=0 ctermbg=NONE cterm=NONE
highlight SpellCap     ctermfg=15 ctermbg=8
highlight Pmenu ctermfg=15 ctermbg=0 cterm=NONE
highlight PmenuSel ctermfg=15 ctermbg=Blue cterm=bold
highlight Delimiter ctermfg=8
highlight Operator ctermfg=8
highlight @variable ctermfg=0
highlight SnacksIndentScope ctermfg=8
]]
  end

  vim.cmd([[
highlight Underlined ctermfg=6 cterm=underline
highlight MatchParen ctermfg=3 cterm=bold
highlight String ctermfg=2
highlight Character ctermfg=2
highlight Constant ctermfg=1
highlight Statement ctermfg=13
highlight Special ctermfg=1
highlight Type ctermfg=14
highlight Preproc ctermfg=6
highlight Keyword ctermfg=3 cterm=italic
highlight Function ctermfg=4
highlight @variable.builtin ctermfg=1
highlight @variable.parameter ctermfg=3
highlight @constructor ctermfg=5
highlight @keyword ctermfg=5 cterm=italic
highlight @property ctermfg=12
highlight @string.special ctermfg=13
highlight @module.builtin ctermfg=1
highlight @type.builtin ctermfg=6
highlight @label ctermfg=4
highlight @punctuation.special ctermfg=14
highlight @comment.error ctermfg=10
highlight @comment.warning ctermfg=11
highlight @comment.todo ctermfg=12
highlight @comment.hint ctermfg=14
highlight Debug ctermfg=3
highlight Error ctermfg=15 ctermbg=9
highlight Todo ctermfg=0 ctermfg=11
highlight DiffAdd ctermbg=2 ctermfg=0
highlight DiffChange ctermbg=6 ctermfg=0
highlight DiffDelete ctermbg=1 ctermfg=0 cterm=NONE
highlight DiagnosticUnderlineWarn guisp=Yellow cterm=undercurl
highlight DiagnosticUnderlineError guisp=Red cterm=undercurl
highlight DiagnosticUnderlineInfo guisp=Blue cterm=undercurl
highlight DiagnosticUnderlineHint guisp=Cyan cterm=undercurl
highlight DiagnosticUnderlineOk guisp=Green cterm=underline
highlight LspReferenceText ctermfg=NONE ctermbg=NONE " Really annoying
highlight NvimInternalError ctermfg=0 " Otherwise red on red
highlight link SnacksIndent WhiteSpace
highlight link StatusLineNC StatusLine
]])
end
return M
