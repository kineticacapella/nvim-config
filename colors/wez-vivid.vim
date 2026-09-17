" vi:syntax=vim

" Scheme name: Wez Vivid
" Original author: FredHappyface (https://github.com/fredHappyface)

if !has('gui_running')
  if exists('g:tinted_shell_path')
    execute 'silent !/bin/sh '.g:tinted_shell_path.'/base24/wez.sh'
  endif
endif

" GUI colors
let s:gui00        = '000000'
let s:gui01        = '000000'
let s:gui02        = '555555'
let s:gui03        = '727272'
let s:gui04        = '909090'
let s:gui05        = 'aeaeae'
let s:gui06        = 'cccccc'
let s:gui07        = 'ffffff'
let s:gui08        = 'cc5555'
let s:gui09        = 'cdcd55'
let s:gui0A        = '5555ff'
let s:gui0B        = '55cc55'
let s:gui0C        = '7acaca'
let s:gui0D        = '5455cb'
let s:gui0E        = 'cc55cc'
let s:gui0F        = '662a2a'
let s:gui10        = '383838'
let s:gui11        = '1c1c1c'
let s:gui12        = 'ff5555'
let s:gui13        = 'ffff55'
let s:gui14        = '55ff55'
let s:gui15        = '55ffff'
let s:gui16        = '5555ff'
let s:gui17        = 'ff55ff'

" Terminal colors
let s:cterm00  = '00'
let s:cterm01  = '18'
let s:cterm02  = '19'
let s:cterm03  = '08'
let s:cterm04  = '20'
let s:cterm05  = '07'
let s:cterm06  = '21'
let s:cterm07  = '15'
let s:cterm08  = '01'
let s:cterm09  = '16'
let s:cterm0A  = '03'
let s:cterm0B  = '02'
let s:cterm0C  = '06'
let s:cterm0D  = '04'
let s:cterm0E  = '05'
let s:cterm0F  = '17'
let s:cterm10  = s:cterm00
let s:cterm11  = s:cterm00
let s:cterm12  = '09'
let s:cterm13  = '11'
let s:cterm14  = '10'
let s:cterm15  = '14'
let s:cterm16  = '12'
let s:cterm17  = '13'

if (exists('base16_colorspace') && base16_colorspace !=? '256') || (exists('base16colorspace') && base16colorspace !=? '256') || (exists('tinted_colorspace') && tinted_colorspace !=? '256')
  let s:cterm01 = s:cterm00
  let s:cterm02 = s:cterm03
  let s:cterm04 = s:cterm03
  let s:cterm05 = s:cterm06
  let s:cterm07 = s:cterm06
  let s:cterm09 = s:cterm08
  let s:cterm0F = s:cterm08
endif

function! s:create_color_globals() abort
  for i in range(0, 23)
    let l:num = printf('%02X', i)
    execute 'let g:tinted_gui' . l:num . ' = s:gui' . l:num
    execute 'let g:tinted_cterm' . l:num . ' = s:cterm' . l:num
    execute 'let g:base16_gui' . l:num . ' = s:gui' . l:num
  endfor
endfunction

call s:create_color_globals()

let s:colors = [
  \ '#000000',
  \ '#cc5555',
  \ '#55cc55',
  \ '#5555ff',
  \ '#5455cb',
  \ '#cc55cc',
  \ '#7acaca',
  \ '#aeaeae',
  \ '#727272',
  \ '#ff5555',
  \ '#55ff55',
  \ '#ffff55',
  \ '#5555ff',
  \ '#ff55ff',
  \ '#55ffff',
  \ '#ffffff'
\]

if has('nvim')
  for i in range(16)
    let g:terminal_color_{i} = s:colors[i]
  endfor
  let g:terminal_color_background = &background ==? 'light' ? s:colors[7] : s:colors[0]
  let g:terminal_color_foreground = &background ==? 'light' ? s:colors[2] : s:colors[5]
elseif has('terminal')
  let g:terminal_ansi_colors = s:colors
endif

if exists('g:tinted_background_transparent') && g:tinted_background_transparent ==? '1'
  let s:guibg = 'NONE'
  let s:ctermbg = 'NONE'
else
  let s:guibg = s:gui00
  let s:ctermbg = s:cterm00
endif

if !exists('g:tinted_bold')
  let g:tinted_bold = 1
endif
if !exists('g:tinted_italic')
  let g:tinted_italic = 1
endif
if !exists('g:tinted_strikethrough')
  let g:tinted_strikethrough = 1
endif
if !exists('g:tinted_underline')
  let g:tinted_underline = 1
endif
if !exists('g:tinted_undercurl')
  let g:tinted_undercurl = g:tinted_underline
endif

let s:attrs = {
      \ 'bold': g:tinted_bold,
      \ 'italic': g:tinted_italic,
      \ 'strikethrough': g:tinted_strikethrough,
      \ 'underline': g:tinted_underline,
      \ 'undercurl': g:tinted_undercurl,
      \}

" Theme setup
let g:colors_name = 'wez-vivid'

function! g:Tinted_Hi(group, guifg, guibg, ctermfg, ctermbg, ...)
  exec 'hi! clear ' . a:group
  let l:attr = join(filter(split(get(a:, 1, ''), ','), 'get(s:attrs, v:val, 1)'), ',')
  let l:guisp = get(a:, 2, '')
  let l:gui_special_names = ['NONE', 'bg', 'background', 'fg', 'foreground']

  if a:guifg !=? ''
    if index(l:gui_special_names, a:guifg) >= 0
      exec 'hi! ' . a:group . ' guifg=' . a:guifg
    else
      exec 'hi! ' . a:group . ' guifg=#' . a:guifg
    endif
  endif
  if a:guibg !=? ''
    if index(l:gui_special_names, a:guibg) >= 0
      exec 'hi! ' . a:group . ' guibg=' . a:guibg
    else
      exec 'hi! ' . a:group . ' guibg=#' . a:guibg
    endif
  endif
  if a:ctermfg !=? ''
    exec 'hi! ' . a:group . ' ctermfg=' . a:ctermfg
  endif
  if a:ctermbg !=? ''
    exec 'hi! ' . a:group . ' ctermbg=' . a:ctermbg
  endif
  if l:attr !=? ''
    exec 'hi! ' . a:group . ' gui=' . l:attr . ' cterm=' . l:attr
  endif
  if l:guisp !=? ''
    if index(l:gui_special_names, l:guisp) >= 0
      exec 'hi! ' . a:group . ' guisp=' . l:guisp
    else
      exec 'hi! ' . a:group . ' guisp=#' . l:guisp
    endif
  endif
endfunction

fun <sid>hi(group, guifg, guibg, ctermfg, ctermbg, attr, guisp)
  call g:Tinted_Hi(a:group, a:guifg, a:guibg, a:ctermfg, a:ctermbg, a:attr, a:guisp)
endfun

" Vim Editor Colors
call <sid>hi('ColorColumn',   '', s:gui01, '', s:cterm01, '', '')
call <sid>hi('Conceal',       s:gui0D, '', s:cterm0D, '', '', '')
call <sid>hi('CurSearch',     s:gui00, s:gui14, s:cterm00, s:cterm14,  '', '')
call <sid>hi('Cursor',        'bg', 'fg', '', '', '', '')
hi! link lCursor Cursor
hi! link CursorIM Cursor
call <sid>hi('CursorColumn',  '', s:gui11, '', s:cterm11, 'none', '')
call <sid>hi('CursorLine',    '', s:gui11, '', s:cterm11, 'none', '')
call <sid>hi('Directory',     s:gui0D, '', s:cterm0D, '', 'bold', '')

call <sid>hi('DiffAdd',       s:gui0B, s:gui01, s:cterm0B, s:cterm01, '', '')
call <sid>hi('DiffChange',    s:gui09, s:gui01, s:cterm09, s:cterm01, '', '')
call <sid>hi('DiffDelete',    s:gui08, s:gui01, s:cterm08, s:cterm01, '', '')
call <sid>hi('DiffText',      s:gui00, s:gui0A, s:cterm00, s:cterm0A, 'bold', '')

call <sid>hi('EndOfBuffer',   s:gui02, s:guibg, s:cterm02, s:ctermbg, '', '')
call <sid>hi('ErrorMsg',      s:gui12, '', s:cterm12, '', 'bold', '')
if has('nvim')
  call <sid>hi('WinSeparator',  s:gui02, s:guibg, s:cterm02, s:ctermbg, '', '')
else
  call <sid>hi('VertSplit',     s:gui02, s:guibg, s:cterm02, s:ctermbg, '', '')
endif
call <sid>hi('Folded',        s:gui03, s:gui11, s:cterm03, s:cterm11, 'italic', '')
call <sid>hi('FoldColumn',    s:gui03, s:guibg, s:cterm03, s:ctermbg, '', '')
call <sid>hi('SignColumn',    s:gui03, s:guibg, s:cterm03, s:ctermbg, '', '')
hi! link IncSearch CurSearch
hi! link Substitute Search
call <sid>hi('LineNr',        s:gui03, s:guibg, s:cterm03, s:ctermbg, '', '')
hi! link LineNrAbove LineNr
hi! link LineNrBelow LineNr
call <sid>hi('CursorLineNr',   s:gui13, s:guibg, s:cterm13, s:ctermbg, 'bold', '')
call <sid>hi('CursorLineFold', s:gui13, s:guibg, s:cterm13, s:ctermbg, '', '')
hi! link CursorLineSign SignColumn
call <sid>hi('MatchParen',     s:gui13, s:gui02, s:cterm13, s:cterm02, 'bold', '')
call <sid>hi('ModeMsg',        s:gui0B, '', s:cterm0B, '', 'bold', '')
hi! link MsgArea None
hi! link MsgSeparator WinSeparator
call <sid>hi('MoreMsg',        s:gui0B, '', s:cterm0B, '', '', '')
call <sid>hi('NonText',        s:gui03, '', s:cterm03, '', '', '')
call <sid>hi('Normal',         s:gui05, s:guibg, s:cterm05, s:ctermbg, '', '')
call <sid>hi('NormalFloat',    s:gui06, s:gui11, s:cterm06, s:cterm11, 'none', '')
call <sid>hi('FloatBorder',    s:gui0D, s:gui11, s:cterm0D, s:cterm11, 'none', '')
hi! link FloatTitle Title
hi! link FloatFooter FloatTitle
hi! link NormalNC None
call <sid>hi('PMenu',           s:gui06, s:gui10, s:cterm06, s:cterm10, 'none', '')
call <sid>hi('PMenuSel',        s:gui00, s:gui0C, s:cterm00, s:cterm0C, 'bold', '')
hi! link PMenuKind PMenu
hi! link PMenuKindSel PMenuSel
hi! link PMenuExtra PMenu
hi! link PMenuExtraSel PMenuSel
call <sid>hi('PMenuSbar',      '', s:gui02, '', s:cterm02, '', '')
call <sid>hi('PMenuThumb',     '', s:gui0C, '', s:cterm0C, '', '')
call <sid>hi('PMenuMatch',     s:gui13, '', s:cterm13, '', 'bold', '')
call <sid>hi('PMenuMatchSel',  s:gui13, s:gui0C, s:cterm13, s:cterm0C, 'bold', '')
call <sid>hi('Question',       s:gui0D, '', s:cterm0D, '', '', '')
call <sid>hi('QuickFixLine',   '', s:gui02, '', s:cterm02, 'none', '')
call <sid>hi('Search',         s:gui00, s:gui09, s:cterm00, s:cterm09,  '', '')
hi! link SnippetTabstop Visual
call <sid>hi('SpecialKey',     s:gui03, '', s:cterm03, '', '', '')

call <sid>hi('SpellBad',       '', '', s:ctermbg, s:cterm12, 'undercurl', s:gui08)
call <sid>hi('SpellLocal',     '', '', s:ctermbg, s:cterm15, 'undercurl', s:gui15)
call <sid>hi('SpellCap',       '', '', s:ctermbg, s:cterm16, 'undercurl', s:gui16)
call <sid>hi('SpellRare',      '', '', s:ctermbg, s:cterm0E, 'undercurl', s:gui0E)

call <sid>hi('StatusLine',     s:gui06, s:gui10, s:cterm06, s:cterm10, 'none', '')
call <sid>hi('StatusLineNC',   s:gui03, s:gui11, s:cterm03, s:cterm11, 'none', '')
hi! link StatusLineTerm StatusLine
hi! link StatusLineTermNC StatusLineNC
hi! link TabLine StatusLine
call <sid>hi('TabLineSel',     s:gui00, s:gui0D, s:cterm00, s:cterm0D, 'bold', '')
hi! link TabLineFill StatusLine

call <sid>hi('Title',          s:gui0D, '', s:cterm0D, '', 'bold', '')
call <sid>hi('Visual',         '', s:gui02, '', s:cterm02, '', '')
hi! link VisualNOS Visual
call <sid>hi('WarningMsg',     s:gui09, '', s:cterm09, '', '', '')
call <sid>hi('Whitespace',     s:gui02, '', s:cterm02, '', '', '')
call <sid>hi('WildMenu',       s:gui00, s:gui0C, s:cterm00, s:cterm0C, 'bold', '')
hi! link WinBar StatusLine
hi! link WinBarNC StatusLineNC

" Standard Syntax (Vivid Palette Mapping)
call <sid>hi('Comment',        s:gui03, '', s:cterm03, '', 'italic', '')
call <sid>hi('Constant',       s:gui09, '', s:cterm09, '', 'none', '')
call <sid>hi('String',         s:gui0B, '', s:cterm0B, '', 'none', '')
call <sid>hi('Character',      s:gui0C, '', s:cterm0C, '', 'none', '')
call <sid>hi('Number',         s:gui09, '', s:cterm09, '', 'none', '')
call <sid>hi('Boolean',        s:gui13, '', s:cterm13, '', 'bold', '')
call <sid>hi('Float',          s:gui09, '', s:cterm09, '', 'none', '')

call <sid>hi('Identifier',     s:gui08, '', s:cterm08, '', 'none', '')
call <sid>hi('Function',       s:gui0D, '', s:cterm0D, '', 'none', '')

call <sid>hi('Statement',      s:gui0E, '', s:cterm0E, '', 'bold', '')
call <sid>hi('Conditional',    s:gui0E, '', s:cterm0E, '', 'none', '')
call <sid>hi('Repeat',         s:gui0E, '', s:cterm0E, '', 'none', '')
call <sid>hi('Label',          s:gui0E, '', s:cterm0E, '', 'none', '')
call <sid>hi('Operator',       s:gui0C, '', s:cterm0C, '', 'none', '')
call <sid>hi('Keyword',        s:gui0E, '', s:cterm0E, '', 'bold', '')
call <sid>hi('Exception',      s:gui0E, '', s:cterm0E, '', 'none', '')

call <sid>hi('PreProc',        s:gui0C, '', s:cterm0C, '', 'none', '')
call <sid>hi('Include',        s:gui0D, '', s:cterm0D, '', 'none', '')
call <sid>hi('Define',         s:gui0E, '', s:cterm0E, '', 'none', '')
call <sid>hi('Macro',          s:gui08, '', s:cterm08, '', 'none', '')
call <sid>hi('PreCondit',      s:gui0C, '', s:cterm0C, '', 'none', '')

call <sid>hi('Type',           s:gui0A, '', s:cterm0A, '', 'none', '')
call <sid>hi('StorageClass',   s:gui0A, '', s:cterm0A, '', 'none', '')
call <sid>hi('Structure',      s:gui0E, '', s:cterm0E, '', 'none', '')
call <sid>hi('Typedef',        s:gui0A, '', s:cterm0A, '', 'none', '')

call <sid>hi('Special',        s:gui0C, '', s:cterm0C, '', 'none', '')
call <sid>hi('SpecialChar',    s:gui0F, '', s:cterm0F, '', 'none', '')
call <sid>hi('Tag',            s:gui09, '', s:cterm09, '', 'none', '')
call <sid>hi('Delimiter',      s:gui0C, '', s:cterm0C, '', 'none', '')
call <sid>hi('SpecialComment', s:gui0A, '', s:cterm0A, '', 'italic', '')
call <sid>hi('Debug',          s:gui08, '', s:cterm08, '', 'none', '')

call <sid>hi('Underlined',     '', '', '', '', 'underline', '')
hi! link Ignore Normal
call <sid>hi('Error',          s:gui08, s:guibg, s:cterm08, s:ctermbg, 'bold', '')
call <sid>hi('Todo',           s:gui00, s:gui13, s:cterm00, s:cterm13, 'bold', '')

call <sid>hi('Added',          s:gui14, '', s:cterm14, '', '', '')
call <sid>hi('Changed',        s:gui16, '', s:cterm16, '', '', '')
call <sid>hi('Removed',        s:gui12, '', s:cterm12, '', '', '')

" Extended Treesitter Highlights
if has('nvim-0.8.0')
  call <sid>hi('@variable',                   s:gui08, '', s:cterm08, '', 'none', '')
  call <sid>hi('@variable.builtin',           s:gui12, '', s:cterm12, '', 'italic', '')
  call <sid>hi('@variable.parameter',         s:gui13, '', s:cterm13, '', 'italic', '')
  hi! link @variable.parameter.builtin @variable.builtin
  call <sid>hi('@variable.member',            s:gui15, '', s:cterm15, '', 'none', '')

  hi! link @constant Constant
  call <sid>hi('@constant.builtin',           s:gui13, '', s:cterm13, '', 'italic', '')
  hi! link @constant.macro Constant

  call <sid>hi('@module',                     s:gui0A, '', s:cterm0A, '', 'none', '')
  call <sid>hi('@module.builtin',             s:gui16, '', s:cterm16, '', 'italic', '')
  hi! link @label Tag

  hi! link @string String
  hi! link @string.documentation String
  call <sid>hi('@string.regexp',              s:gui0C, '', s:cterm0C, '', 'none', '')
  call <sid>hi('@string.escape',              s:gui0F, '', s:cterm0F, '', 'bold', '')
  call <sid>hi('@string.special',             s:gui0F, '', s:cterm0F, '', 'none', '')
  call <sid>hi('@string.special.symbol',      s:gui0F, '', s:cterm0F, '', 'none', '')
  call <sid>hi('@string.special.path',        s:gui0D, '', s:cterm0D, '', 'italic', '')
  call <sid>hi('@string.special.url',         s:gui0D, '', s:cterm0D, '', 'underline', '')

  hi! link @character Character
  hi! link @character.special SpecialChar

  hi! link @boolean Boolean
  hi! link @number Number
  hi! link @number.float Float

  hi! link @type Type
  call <sid>hi('@type.builtin',               s:gui0A, '', s:cterm0A, '', 'italic', '')
  hi! link @type.definition Typedef

  call <sid>hi('@attribute',                  s:gui09, '', s:cterm09, '', 'none', '')
  call <sid>hi('@attribute.builtin',          s:gui09, '', s:cterm09, '', 'italic', '')
  call <sid>hi('@property',                   s:gui15, '', s:cterm15, '', 'none', '')

  call <sid>hi('@function',                   s:gui16, '', s:cterm16, '', 'bold', '')
  call <sid>hi('@function.builtin',           s:gui15, '', s:cterm15, '', 'italic', '')
  hi! link @function.call @function
  hi! link @function.macro Macro

  call <sid>hi('@function.method',            s:gui0D, '', s:cterm0D, '', 'none', '')
  hi! link @function.method.call @function.method

  call <sid>hi('@constructor',                s:gui0A, '', s:cterm0A, '', 'bold', '')
  call <sid>hi('@operator',                   s:gui0C, '', s:cterm0C, '', 'none', '')

  hi! link @keyword Keyword
  hi! link @keyword.coroutine Repeat
  hi! link @keyword.function Keyword
  call <sid>hi('@keyword.operator',           s:gui0E, '', s:cterm0E, '', 'bold', '')
  call <sid>hi('@keyword.import',             s:gui0E, '', s:cterm0E, '', 'italic', '')
  hi! link @keyword.type Keyword
  hi! link @keyword.modifier Repeat
  hi! link @keyword.repeat Repeat
  hi! link @keyword.return Keyword
  hi! link @keyword.debug Debug
  hi! link @keyword.exception Exception

  hi! link @keyword.conditional Conditional
  hi! link @keyword.ternary Conditional

  hi! link @keyword.directive PreProc
  hi! link @keyword.directive.define Define

  call <sid>hi('@punctuation.delimiter',      s:gui0C, '', s:cterm0C, '', 'none', '')
  call <sid>hi('@punctuation.bracket',        s:gui06, '', s:cterm06, '', 'none', '')
  call <sid>hi('@punctuation.special',        s:gui17, '', s:cterm17, '', 'none', '')

  hi! link @comment Comment
  hi! link @comment.documentation Comment

  call <sid>hi('@comment.error',   s:gui08, '', s:cterm08, '', 'italic', '')
  call <sid>hi('@comment.warning', s:gui09, '', s:cterm09, '', 'italic', '')
  call <sid>hi('@comment.note',    s:gui0D, '', s:cterm0D, '', 'italic', '')
  call <sid>hi('@comment.todo',    s:gui0C, '', s:cterm0C, '', 'italic', '')

  if (g:tinted_bold == 1)
    hi! @markup.strong        gui=bold          cterm=bold
  endif
  if (g:tinted_italic == 1)
    hi! @markup.italic        gui=italic        cterm=italic
  endif
  if (g:tinted_strikethrough == 1)
    hi! @markup.strikethrough gui=strikethrough cterm=strikethrough
  endif
  if (g:tinted_underline == 1)
    hi! @markup.underline     gui=underline     cterm=underline
  endif

  hi! link @markup.heading Title
  hi! link @markup.quote String
  hi! link @markup.math Special

  call <sid>hi('@markup.link',        s:gui08, '', s:cterm08, '', '', '')
  hi! link @markup.link.label         @markup.link
  call <sid>hi('@markup.link.url',    s:gui0D, '', s:cterm0D, '', 'underline', '')

  call <sid>hi('@markup.raw',         s:gui0B, '', s:cterm0B, '', '', '')
  hi! link @markup.raw.block          Identifier

  hi! link @markup.list               SpecialChar
  hi! link @markup.list.checked       DiagnosticOk
  hi! link @markup.list.unchecked     DiagnosticError

  hi! link @diff.plus                 Added
  hi! link @diff.minus                Removed
  hi! link @diff.delta                Changed

  hi! link @tag                       Tag
  call <sid>hi('@tag.builtin',        s:gui09, '', s:cterm09, '', 'italic', '')
  call <sid>hi('@tag.attribute',      s:gui0A, '', s:cterm0A, '', 'none', '')
  call <sid>hi('@tag.delimiter',      s:gui0C, '', s:cterm0C, '', 'none', '')

  " LSP Semantic Tokens
  hi! link @lsp.type.class            @type
  hi! link @lsp.type.comment          @comment
  hi! link @lsp.type.decorator        @attribute
  hi! link @lsp.type.enum             @type
  hi! link @lsp.type.enumMember       @constant
  hi! link @lsp.type.event            @type
  hi! link @lsp.type.function         @function
  hi! link @lsp.type.interface        @type
  hi! link @lsp.type.keyword          @keyword
  hi! link @lsp.type.macro            @function.macro
  hi! link @lsp.type.method           @function.method
  hi! link @lsp.type.modifier         @type.modifier
  hi! link @lsp.type.namespace        @module
  hi! link @lsp.type.number           @number
  hi! link @lsp.type.operator         @operator
  hi! link @lsp.type.parameter        @variable.parameter
  hi! link @lsp.type.property        @property
  hi! link @lsp.type.regexp          @string.regexp
  hi! link @lsp.type.string          @string
  hi! link @lsp.type.struct          @type
  hi! link @lsp.type.type            @type
  hi! link @lsp.type.typeParameter   @variable.parameter
  hi! link @lsp.type.variable        @variable

  call <sid>hi('@lsp.mod.defaultLibrary', '', '', '', '', 'italic', '')
  hi! link @lsp.mod.deprecated        DiagnosticDeprecated
endif

" Diagnostics
call <sid>hi('DiagnosticError',          s:gui08, '', s:cterm08, '', '', '')
call <sid>hi('DiagnosticWarn',           s:gui09, '', s:cterm09, '', '', '')
call <sid>hi('DiagnosticInfo',           s:gui0C, '', s:cterm0C, '', '', '')
call <sid>hi('DiagnosticHint',           s:gui0D, '', s:cterm0D, '', '', '')
call <sid>hi('DiagnosticOk',             s:gui0B, '', s:cterm0B, '', '', '')

call <sid>hi('DiagnosticUnderlineError', '', '', s:ctermbg, s:cterm08, 'underline', s:gui08)
call <sid>hi('DiagnosticUnderlineWarn',  '', '', s:ctermbg, s:cterm09, 'underline', s:gui09)
call <sid>hi('DiagnosticUnderlineInfo',  '', '', s:ctermbg, s:cterm0C, 'underline', s:gui0C)
call <sid>hi('DiagnosticUnderlineHint',  '', '', s:ctermbg, s:cterm0D, 'underline', s:gui0D)
call <sid>hi('DiagnosticUnderlineOk',    '', '', s:ctermbg, s:cterm0B, 'underline', s:gui0B)

call <sid>hi('DiagnosticFloatingError',  s:gui08, s:gui10, s:cterm08, s:cterm10, '', '')
call <sid>hi('DiagnosticFloatingWarn',   s:gui09, s:gui10, s:cterm09, s:cterm10, '', '')
call <sid>hi('DiagnosticFloatingInfo',   s:gui0C, s:gui10, s:cterm0C, s:cterm10, '', '')
call <sid>hi('DiagnosticFloatingHint',   s:gui0D, s:gui10, s:cterm0D, s:cterm10, '', '')
call <sid>hi('DiagnosticFloatingOk',     s:gui0B, s:gui10, s:cterm0B, s:cterm10, '', '')

call <sid>hi('DiagnosticDeprecated',     '', '', s:cterm0F, s:cterm0F, 'strikethrough', '')
hi! link DiagnosticUnnecessary Comment

" Telescope Integrations
call <sid>hi('TelescopeBorder',         s:gui02, s:gui10, s:cterm02, s:cterm10, '', '')
call <sid>hi('TelescopePromptBorder',   s:gui0D, s:gui11, s:cterm0D, s:cterm11, '', '')
call <sid>hi('TelescopePromptNormal',   s:gui06, s:gui11, s:cterm06, s:cterm11, '', '')
call <sid>hi('TelescopePromptPrefix',   s:gui08, s:gui11, s:cterm08, s:cterm11, 'bold', '')
call <sid>hi('TelescopeNormal',         s:gui05, s:gui10, s:cterm05, s:cterm10, '', '')
call <sid>hi('TelescopePreviewTitle',  s:gui00, s:gui0B, s:cterm00, s:cterm0B, 'bold', '')
call <sid>hi('TelescopePromptTitle',   s:gui00, s:gui08, s:cterm00, s:cterm08, 'bold', '')
call <sid>hi('TelescopeResultsTitle',  s:gui00, s:gui0D, s:cterm00, s:cterm0D, 'bold', '')
call <sid>hi('TelescopeSelection',     s:gui07, s:gui02, s:cterm07, s:cterm02, 'bold', '')

" NvimTree / Neo-tree
call <sid>hi('NvimTreeRootFolder',      s:gui0E, '', s:cterm0E, '', 'bold', '')
call <sid>hi('NvimTreeFolderIcon',      s:gui0D, '', s:cterm0D, '', '', '')
call <sid>hi('NvimTreeFolderName',      s:gui0D, '', s:cterm0D, '', '', '')
call <sid>hi('NvimTreeOpenedFolderName',s:gui0D, '', s:cterm0D, '', 'bold', '')
call <sid>hi('NvimTreeEmptyFolderName', s:gui03, '', s:cterm03, '', '', '')
call <sid>hi('NvimTreeGitDirty',        s:gui09, '', s:cterm09, '', '', '')
call <sid>hi('NvimTreeGitNew',          s:gui0B, '', s:cterm0B, '', '', '')
call <sid>hi('NvimTreeGitDeleted',      s:gui08, '', s:cterm08, '', '', '')

" Clean up internal setup logic
delf <sid>hi

unlet s:gui00 s:gui01 s:gui02 s:gui03 s:gui04 s:gui05 s:gui06 s:gui07 s:gui08 s:gui09 s:gui0A s:gui0B s:gui0C s:gui0D s:gui0E s:gui0F s:guibg s:gui10 s:gui11 s:gui12 s:gui13 s:gui14 s:gui15 s:gui16 s:gui17
unlet s:cterm00 s:cterm01 s:cterm02 s:cterm03 s:cterm04 s:cterm05 s:cterm06 s:cterm07 s:cterm08 s:cterm09 s:cterm0A s:cterm0B s:cterm0C s:cterm0D s:cterm0E s:cterm0F s:ctermbg s:cterm10 s:cterm11 s:cterm12 s:cterm13 s:cterm14 s:cterm15 s:cterm16 s:cterm17
