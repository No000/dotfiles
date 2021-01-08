"---------------------------------------
"  Yanorei32 .vimrc
"---------------------------------------

"yanorei32様の.vimrcをベースにカスタマイズしたものを個人的に使用しています。yanorei32には感謝。
"\
"| Tips. 
"|  ':source ~/.vimrc' to reload .vimrc
"/

"---------------------------------------
" Init
"---------------------------------------

filetype off
filetype plugin indent off

"---------------------------------------
" Plugin
"---------------------------------------

" check status
if has('vim_starting')
	" add runtime path
	set rtp+=~/.vim/plugged/vim-plug
	
	" install if not installed
	if !isdirectory(expand('~/.vim/plugged/vim-plug'))
		echo 'install vim-plug'

		echo 'create directory...'
		call system('mkdir -p ~/.vim/plugged/vim-plug')

		echo 'clone repo...'
		call system('git clone https://github.com/junegunn/vim-plug.git ~/.vim/plugged/vim-plug/autoload')

	endif
endif

call plug#begin('~/.vim/plugged')

" plugin manager
Plug 'junegunn/vim-plug', { 'dir': '~/.vim/plugged/vim-plug/autoload' }

" color schemes
Plug 'w0ng/vim-hybrid'
Plug 'jacoborus/tender.vim'
Plug 'tomasr/molokai'

" Vim fugitive
Plug 'tpope/vim-fugitive'

" lightline.vim
" Plug 'itchyny/lightline.vim'

" toggle comment
Plug 'tomtom/tcomment_vim'

" vim surround ( text -> visual select and type S' -> 'text' )
Plug 'tpope/vim-surround'

" nerdtree
Plug 'scrooloose/nerdtree'
Plug 'Xuyuanp/nerdtree-git-plugin'
Plug 'jistr/vim-nerdtree-tabs'

" Emmet
Plug 'mattn/emmet-vim'

" syntax
Plug 'hail2u/vim-css3-syntax'
Plug 'jelera/vim-javascript-syntax'
Plug 'vim-scripts/ShaderHighLight'

" Tabular (:Tableformat wrap)
Plug 'godlygeek/tabular'

" vim-markdown (:Tableformat)
Plug 'rcmdnk/vim-markdown'

" Open Browser
Plug 'tyru/open-browser.vim'

" Previm (Markdown Preview)
Plug 'kannokanno/previm', { 'for': 'markdown' }

" C-eでリサイズを開始する
Plug 'simeji/winresizer'

Plug 'embear/vim-localvimrc'

" LSP
Plug 'prabirshrestha/async.vim'
Plug 'prabirshrestha/asyncomplete.vim'
Plug 'prabirshrestha/asyncomplete-lsp.vim'
Plug 'prabirshrestha/vim-lsp'
Plug 'mattn/vim-lsp-settings'
Plug 'mattn/vim-lsp-icons'
Plug 'hrsh7th/vim-vsnip'
Plug 'hrsh7th/vim-vsnip-integ'
Plug 'andys8/vim-elm-syntax'



" totoの追加Plug
" air-lineの追加
Plug 'vim-airline/vim-airline'
Plug 'vim-airline/vim-airline-themes'

" gitgutter
Plug 'airblade/vim-gitgutter'

" lexima.vim(勝手にカッコを閉じてくれるプラグイン)
Plug 'cohama/lexima.vim'

" vim-orgmode
Plug 'jceb/vim-orgmode'
Plug 'tpope/vim-speeddating'

" cleaver-vim
Plug 'rhysd/clever-f.vim'
" fcitxをEscキーを押すとOFFにするプラグイン
" https://anekos.hatenablog.com/entry/20130523/1369306555 
"Plug 'anekos/felis-cat-igirisu-toast-express'
" https://github.com/vim-scripts/fcitx.vim
Plug 'vim-scripts/fcitx.vim'


call plug#end()
"---------------------------------------
" vim-airline
"---------------------------------------

let g:airline#extensions#tabline#enabled = 1
let g:airline#extensions#tabline#left_sep = ' '
let g:airline#extensions#tabline#left_alt_sep = '|'
let g:airline#extensions#tabline#formatter = 'default'
let g:airline#extensions#tabline#buffer_idx_mode = 1
let g:airline#extensions#tabline#buffer_idx_format = {
			\ '0': '0 ',
			\ '1': '1 ',
			\ '2': '2 ',
			\ '3': '3 ',
			\ '4': '4 ',
			\ '5': '5 ',
			\ '6': '6 ',
			\ '7': '7 ',
			\ '8': '8 ',
			\ '9': '9 '
			\}
let g:airline_powerline_fonts = 1
let g:airline#extensions#tabline#enabled = 1
let g:airline#extensions#tabline#buffer_idx_mode = 1
let g:airline#extensions#whitespace#mixed_indent_algo = 1
let g:airline_theme = 'luna'

if !exists('g:airline_symbols')
	let g:airline_symbols = {}
endif

" unicode symbols

" let g:airline_left_sep = '»'
" let g:airline_left_sep = '▶'
" let g:airline_right_sep = '«'
" let g:airline_right_sep = '◀'
 let g:airline_symbols.crypt = '🔒'
" let g:airline_symbols.linenr = '␊'
" let g:airline_symbols.linenr = '␤'
" let g:airline_symbols.linenr = '¶'
let g:airline_symbols.maxlinenr = '☰'
" let g:airline_symbols.maxlinenr = ''
" let g:airline_symbols.branch = '⎇'
let g:airline_symbols.paste = 'ρ'
" let g:airline_symbols.paste = 'Þ'
" let g:airline_symbols.paste = '∥'
 let g:airline_symbols.spell = 'Ꞩ'
 let g:airline_symbols.notexists = '∄'
 let g:airline_symbols.whitespace = 'Ξ'

" powerline symbols
" https://github.com/ryanoasis/powerline-extra-symbols
let g:airline_left_sep = "\ue0b0"
let g:airline_left_alt_sep = "\ue0b1"
let g:airline_right_sep = "\ue0b2"
let g:airline_right_alt_sep = "\ue0b3"
let g:airline_symbols.branch = ''
let g:airline_symbols.readonly = ''
let g:airline_symbols.linenr = ''


"---------------------------------------
" LSP
"---------------------------------------

function! s:on_lsp_buffer_enabled() abort
  setlocal omnifunc=lsp#complete
  setlocal signcolumn=yes
  nmap <buffer> gd <plug>(lsp-definition)
  nmap <buffer> <f2> <plug>(lsp-rename)
	inoremap <expr> <cr> pumvisible() ? "\<c-y>\<cr>" : "\<cr>"
" 補完表示時のEnterで改行をしない
endfunction

augroup lsp_install
  au!
  autocmd User lsp_buffer_enabled call s:on_lsp_buffer_enabled()
augroup END
command! LspDebug let lsp_log_verbose=1 | let lsp_log_file = expand('~/lsp.log')
set completeopt=menuone,noinsert,noselect
let g:lsp_diagnostics_enabled = 1
let g:lsp_diagnostics_echo_cursor = 1
let g:asyncomplete_auto_popup = 1
let g:asyncomplete_auto_completeopt = 0
let g:asyncomplete_popup_delay = 200
let g:lsp_text_edit_enabled = 1
inoremap <expr> <CR> pumvisible() ? 'C-Y' : <CR>
"---------------------------------------
" Lightline Plugin
"---------------------------------------

" " StatusLine show
" set laststatus=2

" " Show Tabline
" set showtabline=2

" " Vim Default Status Bar Mode View
" set noshowmode

" function! LightlineModified()
" 	return &ft =~ 'help\|vimfiler\|gundo' ? '' : &modified ? '+' : &modifiable ? '' : '-'
" endfunction

" function! LightlineReadonly()
" 	return &ft !~? 'help\|vimfiler\|gundo' && &readonly ? 'RO' : ''
" endfunction

" function! LightlineFilename()
" 	return ('' != LightlineReadonly() ? LightlineReadonly() . ' ' : '') .
" \		(&ft == 'vimfiler' ? vimfiler#get_status_string() :
" \		&ft == 'unite' ? unite#get_status_string() :
" \		&ft == 'vimshell' ? vimshell#get_status_string() :
" \		'' != expand('%:t') ? expand('%:t') : '[No Name]') .
" \		('' != LightlineModified() ? ' ' . LightlineModified() : '')
" endfunction

" function! LightlineFugitive()
" 	if &ft !~? 'vimfiler\|gundo' && exists('*fugitive#head')
" 		let g:a = fugitive#head()
" 		if g:a != ''
" 			return ''.fugitive#head()
" 		else
" 			return 'No git'
" 		endif
" 	else
" 		return ''
" 	endif
" endfunction

" function! LightlineFileformat()
" 	return winwidth(0) > 70 ? &fileformat : ''
" endfunction

" function! LightlineFiletype()
" 	return winwidth(0) > 70 ? (&filetype !=# '' ? &filetype : 'no ft') : ''
" endfunction

" function! LightlineFileencoding()
" 	return winwidth(0) > 70 ? (&fenc !=# '' ? &fenc : &enc) : ''
" endfunction

" function! LightlineMode()
" 	return winwidth(0) > 60 ? lightline#mode() : ''
" endfunction

" let g:lightline = {
" \		'colorscheme': 'wombat',
" \		'mode_map': { 'c': 'NORMAL' },
" \		'active': {
" \			'left': [
" \				[ 'mode', 'paste' ],
" \				[ 'fugitive', 'filename' ]
" \			]
" \		},
" \		'component_function': {
" \			'modified':			'LightlineModified',
" \			'filename':			'LightlineFilename',
" \			'readonly':			'LightlineReadonly',
" \			'fileformat':		'LightlineFileformat',
" \			'fugitive':			'LightlineFugitive',
" \			'filetype':			'LightlineFiletype',
" \			'fileencoding':	'LightlineFileencoding',
" \			'mode':					'LightlineMode'
" \		}
" \	}

"---------------------------------------
" Other Plugins
"---------------------------------------

let g:vim_markdown_folding_disabled = 1

let g:localvimrc_persistent = 1

let g:NERDTreeGitStatusIndicatorMapCustom = {
\		"Modified"  : "✹",
\		"Staged"    : "✚",
\		"Untracked" : "✭",
\		"Renamed"   : "➜",
\		"Unmerged"  : "═",
\		"Deleted"   : "✖",
\		"Dirty"     : "✗",
\		"Clean"     : "✓",
\		"Unknown"   : "?"
\	}

map <C-n> <plug>NERDTreeTabsToggle<CR>

"---------------------------------------
" Language / Encoding
"---------------------------------------

" internal encoding
set encoding=utf-8

" terminal encoding
set termencoding=utf-8

set fileformats=unix,dos,mac
set fileencodings=ucs-bom,utf-8,iso-2022-jp,euc-jp,cp932,utf-16le,utf-16,default

"---------------------------------------
" Tab Short cut
"---------------------------------------

" set [Tag] key
nnoremap [Tag] <Nop>
nmap t [Tag]

" change tab shortcut <t-N>
for n in range(1,9)
	execute 'nnoremap <silent> [Tag]'.n ':<C-u>tabnext'.n.'<CR>'
endfor

nnoremap <silent> [Tag]c :tabnew<CR>
nnoremap <silent> [Tag]x :tabclose<CR>
nnoremap <silent> [Tag]n :tabnext<CR>
nnoremap <silent> [Tag]p :tabprevious<CR>

"---------------------------------------
" Syntax
"---------------------------------------

syntax on
set t_Co=256
set number
set nowrap
set background=dark
set cursorline
set list
set listchars=tab:>\ ,trail:-,eol:¬,extends:»,precedes:«

" SYNTAX: hybrid
colorscheme hybrid 
let g:hybrid_reduced_contrast = 1

" " SYNTAX: molokai
" colorscheme molokai

" " SYNTAX: tender
" colorscheme tender

"---------------------------------------
" Basic
"---------------------------------------

set nocompatible
set backspace=2

set tabstop=4
set shiftwidth=4
set autoindent
set smartindent

" Fast
set synmaxcol=160
set lazyredraw
set ttyfast
set re=1
set timeoutlen=1000 ttimeoutlen=0

set incsearch
set hlsearch

" search word display center
nmap n nzz
nmap N Nzz

" clear highlight after ctrl-l
nnoremap <silent> <C-l> :<C-u>nohlsearch<CR><C-l>

" Disable multi-line comment
autocmd FileType * setlocal formatoptions-=ro

" Don't break select after ctrl-a and ctrl-x
vnoremap <c-a> <c-a>gv
vnoremap <c-x> <c-x>gv

"---------------------------------------
" Language configure
"---------------------------------------

autocmd FileType html,ruby,vim setlocal tabstop=2 shiftwidth=2

autocmd FileType python setlocal cinwords=if,elif,else,for,while,try,except,finally,def,class
autocmd FileType python setlocal expandtab tabstop=4 shiftwidth=4 softtabstop=4

autocmd FileType html setlocal matchpairs& matchpairs+=<:>

autocmd FileType cpp setlocal path=.,/usr/include/c++/6/


"---------------------------------------
" finalize
"---------------------------------------

filetype plugin indent on
filetype on

"totoの追加した部分
"スクロールバーを消す
set guioptions-=r
set guioptions-=R
set guioptions-=l
set guioptions-=L
" ツールバーを非表示
set guioptions-=T
" メニューバーを非表示
set guioptions-=m

set clipboard&
set clipboard^=unnamedplus
" 検索をかけた際にハイライトが残るのがうっとおしいので修正
nnoremap <ESC><ESC> :nohl<CR>
" 困った点
" cleaverの設定
let g:clever_f_use_migemo = 1
" 
let g:clever_f_fix_key_direction = 1
let g:clever_f_show_prompt = 1
let g:clever_f_across_no_line = 1

nmap ; <Plug>(clever-f-reset) " ;コマンドをノーマルモードで押すとclever-fをキャンセルできる

