" A theme modeled after syntax highlighting for tokyonight-storm
" Note: it's not exactly the same...
" This only uses cterm colors so it automatically syncs with your terminal theme
let colors_name = "tokyonight-cterm"

set notermguicolors
hi clear
if exists("syntax_on")
  syntax reset
endif

if &background == "dark"
  hi Comment ctermfg=8 cterm=italic
  hi Visual ctermbg=7
  hi WhiteSpace ctermfg=8
  hi Ignore ctermfg=8
  hi Folded ctermfg=8 ctermbg=8
  hi FoldColumn ctermfg=8 ctermbg=8
  hi LineNr       ctermfg=8
  hi CursorLineNr ctermfg=7
  hi SignColumn   ctermbg=8
  hi ColorColumn  ctermfg=15 ctermbg=8 cterm=NONE
  hi StatusLine   ctermfg=15 ctermbg=NONE cterm=NONE
  hi SpellCap     ctermfg=0 ctermbg=7
  hi Pmenu ctermfg=0 ctermbg=15 cterm=NONE
  hi PmenuSel ctermfg=0 ctermbg=Blue cterm=bold
  hi Delimiter ctermfg=7
  hi Operator ctermfg=7
  hi @variable ctermfg=15

  hi DiffAdd ctermbg=2 ctermfg=0
  hi DiffChange ctermbg=6 ctermfg=0
  hi DiffDelete ctermbg=1 ctermfg=0 cterm=NONE

  hi SnacksIndentScope ctermfg=7

  hi DiagnosticUnderlineWarn guisp=LightYellow cterm=undercurl
  hi DiagnosticUnderlineError guisp=LightRed cterm=undercurl
  hi DiagnosticUnderlineInfo guisp=LightBlue cterm=undercurl
  hi DiagnosticUnderlineHint guisp=LightCyan cterm=undercurl
  hi DiagnosticUnderlineOk guisp=LightGreen cterm=underline

  hi BgError ctermbg=1 ctermfg=0
  hi BgWarn ctermbg=3 ctermfg=0
  hi BgInfo ctermbg=4 ctermfg=0
  hi BgHint ctermbg=6 ctermfg=0
  hi BgTest ctermbg=5 ctermfg=0

  hi RenderMarkdownH1Bg ctermbg=4 ctermfg=0
  hi RenderMarkdownH2Bg ctermbg=3 ctermfg=0
  hi RenderMarkdownH3Bg ctermbg=2 ctermfg=0
  hi RenderMarkdownH4Bg ctermbg=5 ctermfg=0
  hi RenderMarkdownH5Bg ctermbg=6 ctermfg=0
  hi RenderMarkdownH6Bg ctermbg=1 ctermfg=0

  hi RenderMarkdownCode ctermbg=0
  hi RenderMarkdownCodeBorder ctermbg=7
else
  hi Visual ctermbg=7
  hi Comment ctermfg=8 cterm=italic
  hi WhiteSpace ctermfg=8
  hi Ignore ctermfg=7
  hi Folded ctermfg=7 ctermbg=8
  hi FoldColumn ctermfg=7 ctermbg=8
  hi LineNr       ctermfg=7
  hi CursorLineNr ctermfg=8
  hi SignColumn   ctermbg=7
  hi ColorColumn  ctermbg=8 cterm=NONE
  hi CursorColumn  ctermbg=7 cterm=NONE
  hi StatusLine   ctermfg=0 ctermbg=NONE cterm=NONE
  hi SpellCap     ctermfg=15 ctermbg=8
  hi Pmenu ctermfg=15 ctermbg=0 cterm=NONE
  hi PmenuSel ctermfg=15 ctermbg=Blue cterm=bold
  hi Delimiter ctermfg=7
  hi Operator ctermfg=7
  hi @variable ctermfg=0

  hi DiffAdd ctermbg=2 ctermfg=15
  hi DiffChange ctermbg=6 ctermfg=15
  hi DiffDelete ctermbg=1 ctermfg=15 cterm=NONE

  hi SnacksIndentScope ctermfg=8

  hi DiagnosticUnderlineWarn guisp=DarkYellow cterm=undercurl
  hi DiagnosticUnderlineError guisp=DarkRed cterm=undercurl
  hi DiagnosticUnderlineInfo guisp=LightBlue cterm=undercurl
  hi DiagnosticUnderlineHint guisp=DarkCyan cterm=undercurl
  hi DiagnosticUnderlineOk guisp=DarkGreen cterm=underline

  hi BgError ctermbg=9 ctermfg=0
  hi BgWarn ctermbg=11 ctermfg=0
  hi BgInfo ctermbg=12 ctermfg=0
  hi BgHint ctermbg=14 ctermfg=0
  hi BgTest ctermbg=13 ctermfg=0

  hi RenderMarkdownH1Bg ctermbg=12 ctermfg=0
  hi RenderMarkdownH2Bg ctermbg=11 ctermfg=0
  hi RenderMarkdownH3Bg ctermbg=10 ctermfg=0
  hi RenderMarkdownH4Bg ctermbg=13 ctermfg=0
  hi RenderMarkdownH5Bg ctermbg=14 ctermfg=0
  hi RenderMarkdownH6Bg ctermbg=9 ctermfg=0
  hi RenderMarkdownCode ctermbg=15
  hi RenderMarkdownCodeBorder ctermbg=0
endif
hi Underlined ctermfg=6 cterm=underline
hi MatchParen ctermfg=3 cterm=bold
hi String ctermfg=2
hi Character ctermfg=2
hi Constant ctermfg=1
hi Statement ctermfg=13
hi Special ctermfg=1
hi Type ctermfg=14
hi Preproc ctermfg=6
hi Keyword ctermfg=3 cterm=italic
hi Function ctermfg=4
hi @variable.builtin ctermfg=1
hi @variable.parameter ctermfg=3
hi @constructor ctermfg=5
hi @keyword ctermfg=5 cterm=italic
hi @property ctermfg=12
hi @string.special ctermfg=13
hi @module.builtin ctermfg=1
hi @type.builtin ctermfg=6
hi @label ctermfg=4
hi @punctuation.special ctermfg=14
hi @comment.error ctermfg=10
hi @comment.warning ctermfg=11
hi @comment.todo ctermfg=12
hi @comment.hint ctermfg=14
hi Debug ctermfg=3
hi Error ctermfg=15 ctermbg=9
hi Todo ctermfg=0 ctermfg=11
hi LspReferenceText ctermfg=NONE ctermbg=NONE " Really annoying
hi NvimInternalError ctermfg=0 " Otherwise red on red
hi link SnacksIndent WhiteSpace
hi link StatusLineNC StatusLine
