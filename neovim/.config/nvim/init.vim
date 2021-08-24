

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
	" Plug 'scrooloose/nerdtree'
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

    "  ctagのプラグイン
    Plug 'majutsushi/tagbar', { 'on': 'TagbarToggle' }
    " indentのガイド
    Plug 'Yggdroot/indentLine'
	" air-lineの追加
	Plug 'vim-airline/vim-airline'
	Plug 'vim-airline/vim-airline-themes'


    " foatterm
    Plug 'voldikss/vim-floaterm'

    " vimのテーマ関連
    Plug 'joshdick/onedark.vim'
    " doom-one
    Plug 'romgrk/doom-one.vim'
    " kill-ring的な
    Plug 'Shougo/neoyank.vim'
    " fzf
    Plug 'junegunn/fzf.vim'
		Plug 'junegunn/fzf'
	" vimのファイラ
	if has('nvim')
  	Plug 'Shougo/defx.nvim', { 'do': ':UpdateRemotePlugins' }
	else
  	Plug 'Shougo/defx.nvim'
  	Plug 'roxma/nvim-yarp'
  	Plug 'roxma/vim-hug-neovim-rpc'
	endif
    Plug 'kristijanhusak/defx-icons'
    Plug 'ryanoasis/vim-devicons'

    if has('nvim')
		Plug 'Shougo/denite.nvim', { 'do': ':UpdateRemotePlugins' }
	else
		Plug 'Shougo/denite.nvim'
		Plug 'roxma/nvim-yarp'
		Plug 'roxma/vim-hug-neovim-rpc'
    endif	

    " nerdtreeの近代実装
    Plug 'ms-jpq/chadtree', {'branch': 'chad', 'do': 'python3 -m chadtree deps'}
    
	" tagの表示
	Plug 'liuchengxu/vista.vim'

    " vimeasymotion
    Plug 'easymotion/vim-easymotion'

    " nvim-treesitter
    " :TSInstall allが必要
    Plug 'nvim-treesitter/nvim-treesitter', {'do': ':TSUpdate'}  " We recommend updating the parsers on update
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
set showcmd

" leaderキーのセット
let mapleader = "\<Space>"

" Nerdtree用の設定
" let g:NERDTreeGitStatusIndicatorMapCustom = {
" \		"Modified"  : "✹",
" \		"Staged"    : "✚",
" \		"Untracked" : "✭",
" \		"Renamed"   : "➜",
" \		"Unmerged"  : "═",
" \		"Deleted"   : "✖",
" \		"Dirty"     : "✗",
" \		"Clean"     : "✓",
" \		"Unknown"   : "?"
" \	}

" map <C-n> <plug>NERDTreeTabsToggle<CR>

"chadtree
nnoremap <leader>v <cmd>CHADopen<cr>

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

" shellをzshに変更
set sh=/bin/zsh


" fzf.vimの設定
nmap <M-c> :Files<cr>

nmap <M-x> :Commands<cr>


" colorscheme onedark
let g:airline_theme='onedark'
set termguicolors
colorscheme doom-one
" ctag
map <F10> :TagbarToggle<CR>
let g:floaterm_keymap_toggle = '<F9>'



function! NearestMethodOrFunction() abort
  return get(b:, 'vista_nearest_method_or_function', '')
endfunction

set statusline+=%{NearestMethodOrFunction()}

" By default vista.vim never run if you don't call it explicitly.
"
" If you want to show the nearest function in your statusline automatically,
" you can add the following line to your vimrc
autocmd VimEnter * call vista#RunForNearestMethodOrFunction()



" How each level is indented and what to prepend.
" This could make the display more compact or more spacious.
" e.g., more compact: ["▸ ", ""]
" Note: this option only works for the kind renderer, not the tree renderer.
let g:vista_icon_indent = ["╰─▸ ", "├─▸ "]

" Executive used when opening vista sidebar without specifying it.
" See all the avaliable executives via `:echo g:vista#executives`.
let g:vista_default_executive = 'ctags'

" Set the executive for some filetypes explicitly. Use the explicit executive
" instead of the default one for these filetypes when using `:Vista` without
" specifying the executive.
let g:vista_executive_for = {
  \ 'cpp': 'vim_lsp',
  \ 'php': 'vim_lsp',
  \ }

" Declare the command including the executable and options used to generate ctags output
" for some certain filetypes.The file path will be appened to your custom command.
" For example:
let g:vista_ctags_cmd = {
      \ 'haskell': 'hasktags -x -o - -c',
      \ }

" To enable fzf's preview window set g:vista_fzf_preview.
" The elements of g:vista_fzf_preview will be passed as arguments to fzf#vim#with_preview()
" For example:
let g:vista_fzf_preview = ['right:50%']


" Ensure you have installed some decent font to show these pretty symbols, then you can enable icon for the kind.
let g:vista#renderer#enable_icon = 1

" The default icons can't be suitable for all the filetypes, you can extend it as you wish.
" let g:vista#renderer#icons = {
" \   "function": "\uf794",
" \   "variable": "\uf71b",
" \  }

" easymotionの設定
let g:EasyMotion_use_migemo = 1


" nvim-treesitterの設定
lua <<EOF
require'nvim-treesitter.configs'.setup {
  ensure_installed = "maintained",
  highlight = {
    enable = true,
    disable = {},
  },
}
EOF
