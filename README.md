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


