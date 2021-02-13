set number             "行番号を表示
set autoindent         "改行時に自動でインデントする
set tabstop=2          "タブを何文字の空白に変換するか
set shiftwidth=2       "自動インデント時に入力する空白の数
set expandtab          "タブ入力を空白に変換
set splitright         "画面を縦分割する際に右に開く
set clipboard=unnamed  "yank した文字列をクリップボードにコピー
set hls                "検索した文字をハイライトする


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

call plug#begin('~/.config/nvim/plugins')
    Plug 'scrooloose/nerdtree'
    Plug 'Xuyuanp/nerdtree-git-plugin'
    Plug 'jistr/vim-nerdtree-tabs'
call plug#end()

if plug_install
    PlugInstall --sync
endif
unlet plug_install

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
