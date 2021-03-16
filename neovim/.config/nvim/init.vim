

" vim-plugの設定を追加

let plug_install = 0
let autoload_plug_path = stdpath('config') . '/autoload/plug.vim'
if !filereadable(autoload_plug_path)
    silent exe '!curl -fL --create-dirs -o ' . autoload_plug_path . 
        \ ' https://raw.github.com/junegunn/vim-plug/master/plug.vim'
    execute 'source ' . fnameescape(autoload_plug_path)
    let plug_install = 1
endif
unlet autoload_plug_path


" パッケージを入れる前の依存関係

" polygrid用
set nocompatible

call plug#begin('~/.config/nvim/plugins')
	Plug 'scrooloose/nerdtree'
	Plug 'Xuyuanp/nerdtree-git-plugin'
	Plug 'jistr/vim-nerdtree-tabs'
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
	" Emacsのモード的なやつ
	Plug 'sheerun/vim-polyglot'
	" 範囲コメントアウト
	Plug 'tpope/vim-commentary'
	" rust
	Plug 'rust-lang/rust.vim'
	" lsp
	" Use release branch (recommend)
	Plug 'neoclide/coc.nvim', {'branch': 'release'}
	" air-lineの追加
	Plug 'vim-airline/vim-airline'
	Plug 'vim-airline/vim-airline-themes'
call plug#end()

if plug_install
    PlugInstall --sync
endif
unlet plug_install

" neovim組み込みの設定

set number             "行番号を表示
set relativenumber	   "相対的な行番号表示をサポート
set autoindent         "改行時に自動でインデントする
set tabstop=2          "タブを何文字の空白に変換するか
set shiftwidth=2       "自動インデント時に入力する空白の数
set expandtab          "タブ入力を空白に変換
set splitright         "画面を縦分割する際に右に開く
set clipboard=unnamed  "yank した文字列をクリップボードにコピー
set hls                "検索した文字をハイライトする
set encoding=UTF-8

" Nerdtree用の設定
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

" LSP-----------------------------------------------------------------------------------------------
syntax enable
filetype plugin indent on

" rust auto format
let g:rustfmt_autosave = 1


set number

" Having longer updatetime (default is 4000 ms = 4 s) leads to noticeable
" delays and poor user experience.
set updatetime=300

" Always show the signcolumn, otherwise it would shift the text each time
" diagnostics appear/become resolved.
if has("patch-8.1.1564")
  " Recently vim can merge signcolumn and number column into one
  set signcolumn=number
else
  set signcolumn=yes
endif

" Make <CR> auto-select the first completion item and notify coc.nvim to
" format on enter, <cr> could be remapped by other vim plugin
inoremap <silent><expr> <cr> pumvisible() ? coc#_select_confirm()
                              \: "\<C-g>u\<CR>\<c-r>=coc#on_enter()\<CR>"

" GoTo code navigation.
nmap <silent> gd <Plug>(coc-definition)
nmap <silent> gy <Plug>(coc-type-definition)
nmap <silent> gi <Plug>(coc-implementation)
nmap <silent> gr <Plug>(coc-references)


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

