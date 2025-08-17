--:h highlight
--:h cterm-colors
--:h guifg
--:h syntax

-- Fully ansi compliant theme and syntax highlighting
vim.cmd([[
set notermguicolors

" Resets
highlight clear
if exists("syntax_on")
  syntax reset
endif

" Basic
highlight Visual ctermbg=Grey
highlight WhiteSpace ctermfg=Grey
highlight WhiteSpace ctermfg=Grey
highlight Ignore ctermfg=DarkGrey
highlight Underlined ctermfg=Cyan cterm=underline
highlight MatchParen ctermfg=DarkYellow cterm=bold
highlight Folded ctermfg=Grey ctermbg=DarkGrey
highlight FoldColumn ctermfg=Grey ctermbg=DarkGrey

" Theming
highlight LineNr       ctermfg=DarkGrey
highlight CursorLineNr ctermfg=Grey
highlight SignColumn   ctermbg=DarkGrey
highlight ColorColumn  ctermfg=LightGrey ctermbg=DarkGrey
highlight StatusLine   ctermfg=White ctermbg=Black cterm=NONE
highlight StatusLineNC ctermfg=Grey ctermbg=DarkGrey cterm=NONE
highlight SpellCap     ctermfg=Grey ctermbg=DarkGrey

highlight Pmenu ctermfg=Black ctermbg=White cterm=NONE
highlight PmenuSel ctermfg=Black ctermbg=Blue cterm=bold
highlight NormalFloat ctermbg=Black


" Syntax
highlight Comment ctermfg=Grey cterm=italic
highlight String ctermfg=Green
highlight Character ctermfg=Green
highlight Constant ctermfg=DarkYellow
highlight Statement ctermfg=Magenta
highlight Special ctermfg=Grey
highlight Delimiter ctermfg=Grey
highlight Type ctermfg=DarkCyan
highlight Operator ctermfg=NONE
highlight Preproc ctermfg=Cyan
highlight Keyword ctermfg=Yellow cterm=italic
highlight Function ctermfg=DarkBlue

highlight link @variable Normal
highlight @variable.builtin  ctermfg=Red
highlight @variable.parameter ctermfg=Yellow
highlight @constructor ctermfg=Magenta
highlight @keyword ctermfg=Magenta cterm=italic
highlight @property ctermfg=Blue " Not sure what color to make this yet
highlight @string.special ctermfg=Red
highlight @module.builtin ctermfg=Red
highlight @type.builtin ctermfg=DarkCyan
highlight @label ctermfg=DarkBlue
highlight @punctuation.special ctermfg=cyan
highlight @comment.error ctermfg=DarkRed
highlight @comment.warning ctermfg=DarkYellow
highlight @comment.todo ctermfg=Blue
highlight @comment.hint ctermfg=Cyan

highlight Debug ctermfg=DarkYellow

highlight Error ctermfg=White ctermbg=DarkRed
highlight Todo ctermfg=Black ctermfg=DarkYellow

highlight DiffAdd ctermbg=Green ctermfg=Black
highlight DiffChange ctermbg=Cyan ctermfg=Black
highlight DiffDelete ctermbg=Red ctermfg=Black cterm=NONE

highlight DiagnosticUnderlineWarn guisp=DarkYellow cterm=undercurl
highlight DiagnosticUnderlineError guisp=Red cterm=undercurl
highlight DiagnosticUnderlineInfo guisp=Cyan cterm=undercurl
highlight DiagnosticUnderlineHint guisp=DarkCyan cterm=undercurl
highlight DiagnosticUnderlineOk guisp=Green cterm=underline

" Fix
highlight LspReferenceText ctermfg=NONE ctermbg=NONE " Really annoying
highlight NvimInternalError ctermfg=Black "Otherwise red on red
]])
