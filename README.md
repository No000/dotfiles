# dotfiles  
ドットファイル管理  
OS：ManjaroLinux-KDE

## ディレクトリ構成  
exa -Tで生成  
<後でやる>

## セットアップ
GNU Stowを利用する
> https://www.gnu.org/software/stow/

GNU Stowマニュアル
> https://www.gnu.org/software/stow/manual/stow.html

dotfilesを管理する方法に関して
> http://brandon.invergo.net/news/2012-05-26-using-gnu-stow-to-manage-your-dotfiles.html

### セットアップ手順
```bash
cd ~
git clone https://github.com/No000/dotfiles.git
cd ~/dotfiles
stow -v <対象のドットファイルやドットディレクトリー（複数選択可）>
```

### Emacs  
初回のインストールときのみ、267行目の(all-the-icons-install-fonts)のコメントアウトを外しておく

### 必要なパッケージ
フォント関連  
・ttf-cascadia-code  
・ttf-ricty-diminished  

emacs-application-framework関連  
・emacs-eaf(AUR) <-今は使っていない   
・python-pyqt5  
・python-pyqt5-sip  
・python-pyqtwebengine  
・python-qrcode  
・python-feedparser  
・python-dbus  
・python-pyinotify  
・python-markdown  
・nodejs  
・aria2  
・libreoffice  
・python-grip  
・python-qtconsole  
・filebrowser-bin  
・wmctrl  

lsp関連  
・clnagd  
・rust-analyzer  
・python-language-server  

Magit  
・git  

Docker  
・docker  
・docker-compose  

migemo  
・cmigemo(AUR)  

rutic-mode  
- cargo-outdated
- cargo-edit
- 
### git clone  

elispディレクトリにパッケージを入れる  
eaf  
> https://github.com/manateelazycat/emacs-application-framework.git

aweshell  
> https://github.com/manateelazycat/aweshell.git  
