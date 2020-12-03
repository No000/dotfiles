;; 全体的な設定を記載

;; bytecomplie
;; scratchバッファに行き
;; (byte-recompile-directory (expand-file-name "~/.emacs.d") 0)
;; C-j C-eとする

;; 依存パッケージ（OSのパッケージマネージャーからダウンロードしてねってやつ）
;; emacs-mozc:AURにあります。ビルドファイルを編集しないといけませんが、別ファイルに入れておく予定です。
;; LSP(Language Sever Protocol)に関して
;; Rustはrust-analyzerを使用しており、Manjaroの公式リポジトリからインストールをしたものになります。
;; C/C++はclangdを使用しています。clangをインストールすればついて来ます。ただ、補完を行う場合にcompile_flag.txtが必要になるため、注意が必要です。
;; gitとDockerを入れる必要があります。
;; ttf-cascadia-codeとttf-ricty-diminishedをパッケージマネージャーよりインストール
;; AURでemacs-eafをインストールする必要がある。
;; オプションは全部インストールすること。(明示的には入れてくれないので、自身で入れる)
;; 追加でpython-pyqt5-sipが必要となる。
;; eafでの動画ダウンロードにはyoutube-dlが必要となる
;; 1, 必要なパッケージをインストールする
;; 2, 次のディレクトリがない場合は作成をする"elisp" "conf" "public_repos" "elpa" "mysnippets"
;; ------------------------------------------------------------------------------パッケージリポジトリの設定
(require 'package)  ; package.elを有効化
;; パッケージリポジトリにMarmaladeとMELPAを追加
(setq package-archives
      '(("melpa" . "https://melpa.org/packages/")
        ;; ("melpa-stable" . "https://stable.melpa.org/packages/")
        ("org" . "https://orgmode.org/elpa/")
        ("gnu" . "https://elpa.gnu.org/packages/")))
(package-initialize) ; インストール済みElispを読み込む

(when (not (package-installed-p 'use-package))
  (package-refresh-contents)
  (package-install 'use-package))
(setq use-package-enable-imenu-support t)
(setq use-package-always-ensure t)
(add-to-list 'load-path "~/.emacs.d/elpa/")
(require 'use-package)
(use-package bind-key)
(use-package diminish)



;; もしも設定ファイルを分割する場合に有効にする
;;init-loader
;; (use-package init-loader
;;  :ensure t
;;  :config
;;  (init-loader-load "~/.emacs.d/inits"))



;; 文字コードの設定
(set-language-environment "Japanese")
(prefer-coding-system 'utf-8)

;; 行番号
;;(global-linum-mode t)
(global-display-line-numbers-mode)
;; カラム番号を表示
;;(line-number-mode t)
(column-number-mode t)

;; 警告音の代わりに画面フラッシュ
(setq visible-bell t)

;; スタートアップページを表示しない
(setq inhibit-startup-message t)

;; 警告音もフラッシュも全て無効(警告音が完全に鳴らなくなるので注意)
;; (setq ring-bell-function 'ignore)


;; 現状スクロールバーとメニューバーを使っていないため削除する。
;; 可能であればyaskrollのようなものに変更を行いたい。
(tool-bar-mode -1)     ;ツールバーをなくす
(menu-bar-mode -1)     ;メニューバーをなくす
;;; これはお好みで
(scroll-bar-mode -1)   ;スクロールバーをなくす

;; c-hとbackspaceで上書き
;; (global-set-key "\C-h" 'delete-backward-char)
(define-key key-translation-map [?\C-h] [?\C-?]) ; helmで使えるように変更

;; 別のキーバイドにヘルプを割り当てる
(define-key global-map (kbd "C-x ?") 'help-command)

;; 折り返しトグルコマンド
;; 使わないので消した
;; (define-key global-map (kbd "C-c l") 'toggle-truncate-lines) 

;; "C-x j"でウィンドウを切り替える
(define-key global-map (kbd "C-x j") 'other-window)

(electric-pair-mode 1)					; かぎかっこを対応させる

;; マウスのスクロール
(setq mouse-wheel-scroll-amount '(0.07))
(setq mouse-wheel-progressive-speed nil)
;; 右クリックで選択領域をコピー
(global-set-key (kbd "<mouse-3>") 'copy-region-as-kill)


;;------------------
;; フォントの設定
;; フォント設定

;; 合字フォントを実現するための処理.
(use-package composite
  :ensure nil
  :defer t
  :init
  (defvar composition-ligature-table (make-char-table nil))
  :hook
  (((prog-mode conf-mode nxml-mode markdown-mode help-mode) ;ここでフックするモードを決めている。ここでフックしていないモードは合字の表記が行われない。
    . (lambda () (setq-local composition-function-table composition-ligature-table))))
  :config
  ;; support ligatures, some toned down to prevent hang
  (when (version<= "27.0" emacs-version)
    (let ((alist
           '((33 . ".\\(?:\\(==\\|[!=]\\)[!=]?\\)")
             (35 . ".\\(?:\\(###?\\|_(\\|[(:=?[_{]\\)[#(:=?[_{]?\\)")
             (36 . ".\\(?:\\(>\\)>?\\)")
             (37 . ".\\(?:\\(%\\)%?\\)")
             (38 . ".\\(?:\\(&\\)&?\\)")
             (42 . ".\\(?:\\(\\*\\*\\|[*>]\\)[*>]?\\)")
             ;; (42 . ".\\(?:\\(\\*\\*\\|[*/>]\\).?\\)")
             (43 . ".\\(?:\\([>]\\)>?\\)")
             ;; (43 . ".\\(?:\\(\\+\\+\\|[+>]\\).?\\)")
             (45 . ".\\(?:\\(-[->]\\|<<\\|>>\\|[-<>|~]\\)[-<>|~]?\\)")
             ;; (46 . ".\\(?:\\(\\.[.<]\\|[-.=]\\)[-.<=]?\\)")
             (46 . ".\\(?:\\(\\.<\\|[-=]\\)[-<=]?\\)")
             (47 . ".\\(?:\\(//\\|==\\|[=>]\\)[/=>]?\\)")
             ;; (47 . ".\\(?:\\(//\\|==\\|[*/=>]\\).?\\)")
             (48 . ".\\(?:\\(x[a-fA-F0-9]\\).?\\)")
             (58 . ".\\(?:\\(::\\|[:<=>]\\)[:<=>]?\\)")
             (59 . ".\\(?:\\(;\\);?\\)")
             (60 . ".\\(?:\\(!--\\|\\$>\\|\\*>\\|\\+>\\|-[-<>|]\\|/>\\|<[-<=]\\|=[<>|]\\|==>?\\||>\\||||?\\|~[>~]\\|[$*+/:<=>|~-]\\)[$*+/:<=>|~-]?\\)")
             (61 . ".\\(?:\\(!=\\|/=\\|:=\\|<<\\|=[=>]\\|>>\\|[=>]\\)[=<>]?\\)")
             (62 . ".\\(?:\\(->\\|=>\\|>[-=>]\\|[-:=>]\\)[-:=>]?\\)")
             (63 . ".\\(?:\\([.:=?]\\)[.:=?]?\\)")
             (91 . ".\\(?:\\(|\\)[]|]?\\)")
             ;; (92 . ".\\(?:\\([\\n]\\)[\\]?\\)")
             (94 . ".\\(?:\\(=\\)=?\\)")
             (95 . ".\\(?:\\(|_\\|[_]\\)_?\\)")
             (119 . ".\\(?:\\(ww\\)w?\\)")
             (123 . ".\\(?:\\(|\\)[|}]?\\)")
             (124 . ".\\(?:\\(->\\|=>\\||[-=>]\\||||*>\\|[]=>|}-]\\).?\\)")
             (126 . ".\\(?:\\(~>\\|[-=>@~]\\)[-=>@~]?\\)"))))
      (dolist (char-regexp alist)
        (set-char-table-range composition-ligature-table (car char-regexp)
                              `([,(cdr char-regexp) 0 font-shape-gstring]))))
    (set-char-table-parent composition-ligature-table composition-function-table))
  )


(when (member "Cascadia Code" (font-family-list))
  (add-to-list 'default-frame-alist '(font . "Cascadia Code 11")))



;; Ricty Diminished 11
;; Cascadia Code 11

;; Use variable width font faces in current buffer
(defun ricty-font-change ()
  "Set font to a variable width (proportional) fonts in current buffer"
  (interactive)
  (setq buffer-face-mode-face '(:family "Ricty Diminished"))
  (buffer-face-mode))

;; 日本語フォントの設定
;; https://qiita.com/Maizu/items/fee34328f559c7dc59d8
(set-fontset-font t 'japanese-jisx0208 "Ricty Diminished")

;; ==========================================================================
;; CalcadiaCode側をフックするとうまくいかないので、逆で行く
;; 合字フォントを使いたくない場合はここに記載
(add-hook 'emacs-lisp-mode-hook 'ricty-font-change)
;; (add-hook 'dashboard-mode-hook 'ricty-font-change)
;; ==========================================================================

;;(when (member "Ricty Diminished" (font-family-list))
;;  (add-to-list 'default-frame-alist '(font . "Ricty Diminished 11")))

;; ------------------------------------------------------------------------------モードラインの設定
;; ファイルサイズを表示
(size-indication-mode t)
;; 時計を表示
(setq display-time-day-and-date t)	;月曜日・月・火を表示
(setq display-time-24hr-format t)	;24時間表示
(display-time-mode t)
;; バッテリー情報を記載
(display-battery-mode t)
;; タイトルバーにファイルのフルパスを表示
(setq frame-title-format "%f")


;; -----------------------------------------------------------------------------インデントの設定
;; TABの表示幅。初期値は8
(setq-default tab-width 4)

;; インデントにタブ文字使用しない場合
;; (setq-default indent-tabs-mode nil)
;; 特定のモードでタブを使用しない場合
;; (add-hook 'php-mode-hook
;;		  (lambda ()
;;			(c-set-style "bsd")))

;; -----------------------------------------------------------------------------load パス関連
;; load-pathを追加する関数を定義
(defun add-to-load-path (&rest paths)
  (let (path)
    (dolist (path paths paths)
      (let ((default-directory
			  (expand-file-name (concat user-emacs-directory path))))
		(add-to-list 'load-path default-directory)
		(if (fboundp 'normal-top-level-add-subdirs-to-load-path)
			(normal-top-level-add-subdirs-to-load-path))))))

;; 引数のディレクトリとそのサブディレクトリをload-pathに追加
(add-to-load-path "elisp" "conf" "public_repos")

;; カスタムファイルを別ファイルにする
(setq custom-file (locate-user-emacs-file "custom.el"))
;; カスタムファイルが存在しない場合は作成する
(unless (file-exists-p custom-file)
  (write-region "" nil custom-file))
;; カスタムファイルを読見込む
(load custom-file)

;;
;; backup の保存先
;;
(setq backup-directory-alist
	  (cons (cons ".*" (expand-file-name "~/.emacs.d/backup"))
			backup-directory-alist))


(setq auto-save-file-name-transforms
	  `((".*", (expand-file-name "~/.emacs.d/backup/") t)))

;; ------------------------------------------------------------------------------ハイライト関連

;; https://qiita.com/Ladicle/items/feb5f9dce9adf89652cf#%E5%AF%BE%E5%BF%9C%E3%81%99%E3%82%8B%E6%8B%AC%E5%BC%A7%E3%82%92%E5%88%86%E3%81%8B%E3%82%8A%E3%82%84%E3%81%99%E3%81%8F----paren
;; 対応するカッコを強調表示
;; 画面外の場合に強調が行われる

(use-package paren
  :ensure nil
  :hook
  (after-init . show-paren-mode)
  :custom-face
  (show-paren-match ((nil (:background "#44475a" :foreground "#f1fa8c"))))
  :custom
  (show-paren-style 'mixed)
  (show-paren-when-point-inside-paren t)
  (show-paren-when-point-in-periphery t))

;; VScodeのBrancketのようなパッケージ
(use-package rainbow-delimiters
  :ensure t
  :hook
  (prog-mode . rainbow-delimiters-mode))


(use-package all-the-icons)
;;(all-the-icons-install-fonts) ; 初期インストール

;; -----------------------------------------------------------------------------オートセーブ・バックアップ関連
;; (add-to-list 'backup-directory-alist	
;;			 (cons "." "~/.emacs.d/backups/"))
;;(setq auto-save-file-name-transforms
;;	  '((".*",(expand-file-name "~/.emacs.d/backups") t)))

;; オートセーブをファイル作成までの秒間隔
(setq auto-save-timeout 15)
;; オートセーブファイル作成までのタイプ間隔
(setq auto-save-interval 60)




;; ------------------------------------------------------------------------------日本語入力
;; emacs-mozc（packgeでmozcをインストールしてから有効化する）
;;(setq ac-use-menu-map t) 
;; overlayは処理が重いため変更する
;;(setq mozc-candidate-style 'overlay)

(use-package mozc
  :config
  (setq default-input-method "japanese-mozc")

  ;; 全角半角キーで on/off
  (global-set-key [zenkaku-hankaku] 'toggle-input-method)

  ;; 無変換キーでon
  (global-set-key [eisu-toggle] 'toggle-input-method)
  ;; 全角半角キーと無変換キーのキーイベントを横取りする
  (defadvice mozc-handle-event (around intercept-keys (event))
    "Intercept keys eisu-toggle and zenkaku-hankaku, before passing keys
to mozc-server (which the function mozc-handle-event does), to
properly disable mozc-mode."
    (if (member event (list 'zenkaku-hankaku 'eisu-toggle))
        (progn
          (mozc-clean-up-session)
          (toggle-input-method))
      (progn                          ;(message "%s" event) ;debug
        ad-do-it)))
  (ad-activate 'mozc-handle-event)


  )


(use-package mozc-popup					;overlayだと重いため変更
  :ensure t
  :config
  (setq mozc-candidate-style 'popup) ; select popup style.
  )


(prefer-coding-system 'utf-8)

;;(set-language-environment "Japanese")
;;    (require 'mozc)  ; or (load-file "/path/to/mozc.el")
;;(setq default-input-method "japanese-mozc")
;; (setq mozc-candidate-style 'overlay)

;; -------------------------------------------------------------------------------見た目関連
;;(load-theme 'zenburn t)
;; https://github.com/hlissner/emacs-doom-themes
(use-package doom-themes
  :custom
  (doom-themes-enable-italic t)
  (doom-themes-enable-bold t)
  (doom-themes-neotree-file-icons t)	;これはアイコンをすべて使うようにするオプション
  :custom-face
  (doom-modeline-bar ((t (:background "#6272a4"))))


  
  (org-link ((t (:foreground "#ebe087" :underline t))))
  (org-list-dt ((t (:foreground "#bd93f9"))))
  (org-special-keyword ((t (:foreground "#6272a4"))))
  (org-todo ((t (:background "#272934" :foreground "#51fa7b" :weight bold))))
  (org-document-title ((t (:foreground "#f1fa8c" :weight bold))))
  (org-done ((t (:background "#373844" :foreground "#216933" :strike-through nil :weight bold))))
  (org-footnote ((t (:foreground "#76e0f3"))))
  :config
  ;; ----------------------------------------------------------------------
  ;; ----------------------------------------------------------------------
  (load-theme 'doom-Iosvkem t)			;ここでテーマの種類を変えることができる。
  ;; (load-theme 'doom-dracula t)
  ;; (load-theme 'doom-horizon t)			;ここでテーマの種類を変えることができる。
  ;;(load-theme 'doom-zenburn t)
  ;; ----------------------------------------------------------------------
  ;; ----------------------------------------------------------------------
  (doom-themes-neotree-config)
  (doom-themes-org-config))
(setq org-todo-keyword-faces
      '(("WAIT" . (:foreground "#6272a4":weight bold))
        ("NEXT"   . (:foreground "#f1fa8c" :weight bold))
        ("CARRY/O" . (:foreground "#6272a4" :background "#373844" :weight bold))))




(setq org-todo-keyword-faces
      '(("WAIT" . (:foreground "#6272a4":weight bold))
        ("NEXT"   . (:foreground "#f1fa8c" :weight bold))
        ("CARRY/O" . (:foreground "#6272a4" :background "#373844" :weight bold))))

;; https://github.com/seagle0128/doom-modeline
(use-package doom-modeline
  :custom
  (doom-modeline-buffer-file-name-style 'truncate-with-project)
  (doom-modeline-icon t)
  (doom-modeline-major-mode-icon t)
  (doom-modeline-minor-modes nil)
  :hook
  (after-init . doom-modeline-mode)
  :config
  (line-number-mode 0)
  (column-number-mode 0)
  (doom-modeline-def-modeline 'main
    '(bar  matches buffer-info remote-host buffer-position parrot selection-info)
    '(misc-info persp-name lsp github debug minor-modes input-method major-mode process vcs checker)))

;; これは黄色にポォンと出るやつ
(use-package beacon
  :custom
  (beacon-color "yellow")
  :config
  (beacon-mode 1))

(use-package page-break-lines)

;; プロジェクト管理パッケージ
(use-package projectile)
(projectile-mode +1)
(define-key projectile-mode-map (kbd "s-p") 'projectile-command-map)
(define-key projectile-mode-map (kbd "C-c p") 'projectile-command-map)
;; これはタイトルをオシャンティーにするやつ
(use-package dashboard
  :bind (("<f5>" . open-dashboard)
		 :map dashboard-mode-map
		 ("<f5>" . quit-dashboard))
  :diminish
  (dashboard-mode page-break-lines-mode)
  :custom
  (dashboard-startup-banner 3)
  (dashboard-items '((recents . 15)
					 (projects . 5)
					 (bookmarks . 5)
					 (agenda . 5)))
  :hook
  (after-init . dashboard-setup-startup-hook)
  :config
  (add-to-list 'dashboard-items '(agenda) t))


(defun open-dashboard ()
  "Open the *dashboard* buffer and jump to the first widget."
  (interactive)
  (delete-other-windows)
  ;; Refresh dashboard buffer
  (if (get-buffer dashboard-buffer-name)
      (kill-buffer dashboard-buffer-name))
  (dashboard-insert-startupify-lists)
  (switch-to-buffer dashboard-buffer-name)
  ;; Jump to the first section
  (goto-char (point-min))
  (dashboard-goto-recent-files))

(defun quit-dashboard ()
  "Quit dashboard window."
  (interactive)
  (quit-window t)
  (when (and dashboard-recover-layout-p
			 (bound-and-true-p winner-mode))
    (winner-undo)
    (setq dashboard-recover-layout-p nil)))

;; ---------------------------------------------------------------------------------multi-term
(use-package multi-term)
(when (require 'multi-term nil t)
  ;;使用するシェルを指定
  (setq multi-term-program "/usr/bin/fish"))

;; ---------------------------------------------------------------------------------

(require 'wgrep nil t)


;; --------------------------------------------------------------------------------undotree
(use-package undo-tree)
(when (require 'undo-tree nil t)
  (global-undo-tree-mode))


;; -------------------------------------------------------------------------------Elscreen
;; 場違いなため無効化しました。
;; ElScreenのプレフィクスキーを変更する（初期値はC-z）
;; (setq elscreen-prefix nil t)
;;(when (require 'elscreen nil t)
;;  (elscreen-start)
;;  ;; C-z C-zをタイプした場合にデフォルトのC-zりようする。
;;  (if window-system
;;	  (define-key elscreen-map (kbd "C-z") 'iconify-or-deiconify-frame)
;;	(define-key elscreen-map(kbd "C-z") 'suspend-emacs)))


;; --------------------------------------------------------------------------------neotree

;;all-the-icons
(use-package all-the-icons)
(use-package neotree)
;; F8でnetreee-windowが開くようにする
(global-set-key [f8] 'neotree-toggle)
;; neotreeでファイルを新規作成した場合のそのファイルを開く
(setq neo-create-file-auto-open t)
;; delete-other-window で neotree ウィンドウを消さない
(setq neo-persist-show t)
(setq neo-theme (if (display-graphic-p) 'icons 'arrow))
(setq neo-show-hidden-files t) ;隠しファイルを表示
(setq neo-window-fixed-size nil)		;固定されていたウィンドウサイズを変更かのうへ　
(setq neo-window-width 30)				;20から40に変更

;;-------------------------------------------------------------------------------ivy
(use-package ivy)
(when (require 'ivy nil t)

  ;; M-o を ivy-hydra-read-action に割り当てる．
  (when (require 'ivy-hydra nil t)
    (setq ivy-read-action-function #'ivy-hydra-read-action))

  ;; `ivy-switch-buffer' (C-x b) のリストに recent files と bookmark を含める．
  (setq ivy-use-virtual-buffers t)

  ;; ミニバッファでコマンド発行を認める
  (when (setq enable-recursive-minibuffers t)
    (minibuffer-depth-indicate-mode 1)) ;; 何回層入ったかプロンプトに表示．

  ;; ESC連打でミニバッファを閉じる
  (define-key ivy-minibuffer-map (kbd "<escape>") 'minibuffer-keyboard-quit)

  ;; プロンプトの表示が長い時に折り返す（選択候補も折り返される）
  (setq ivy-truncate-lines nil)

  ;; リスト先頭で `C-p' するとき，リストの最後に移動する
  (setq ivy-wrap t)

  ;; アクティベート
  (ivy-mode 1))

;; postframeの設定
(use-package ivy-posframe)

;; -------------------------------------------------------------------------------swipperの設定
;; swiper
(use-package swiper)
(when (require 'swiper nil t)
  ;; キーバインドは一例です．好みに変えましょう．
  (global-set-key (kbd "M-s M-s") 'swiper-thing-at-point))

;;----------------------------------------------------------------------------------

;; display at `ivy-posframe-style'
;;(setq ivy-posframe-display-functions-alist '((t . ivy-posframe-display)))
(setq ivy-posframe-display-functions-alist '((t . ivy-posframe-display-at-frame-center)))
;;(setq ivy-posframe-display-functions-alist '((t . ivy-posframe-display-at-window-center)))
;; (setq ivy-posframe-display-functions-alist '((t . ivy-posframe-display-at-frame-bottom-left)))
;; (setq ivy-posframe-display-functions-alist '((t . ivy-posframe-display-at-window-bottom-left)))
;; (setq ivy-posframe-display-functions-alist '((t . ivy-posframe-display-at-frame-top-center)))
(ivy-posframe-mode 1)


;; パッケージマネージャーの支援パッケージ
;; Githubのスター表示や一括アップグレードを行ってくれる
;; 利用する場合は、paradox-list-packageで起動する。
(use-package paradox
  :ensure t
  :custom
  (paradox-github-token t))
;; 右クリックで選択領域をコピー
(global-set-key (kbd "<mouse-3>") 'copy-region-as-kill)




;; ---------------------------------------------------------------------------------指マークでわかりやすく
(defface my-ivy-arrow-visible
  '((((class color) (background light)) :foreground "orange")
    (((class color) (background dark)) :foreground "#EE6363"))
  "Face used by Ivy for highlighting the arrow.")

(defface my-ivy-arrow-invisible
  '((((class color) (background light)) :foreground "#FFFFFF")
    (((class color) (background dark)) :foreground "#31343F"))
  "Face used by Ivy for highlighting the invisible arrow.")

(if window-system
    (when (require 'all-the-icons nil t)
      (defun my-ivy-format-function-arrow (cands)
        "Transform CANDS into a string for minibuffer."
        (ivy--format-function-generic
         (lambda (str)
           (concat (all-the-icons-faicon
                    "hand-o-right"
                    :v-adjust -0.2 :face 'my-ivy-arrow-visible)
                   " " (ivy--add-face str 'ivy-current-match)))
         (lambda (str)
           (concat (all-the-icons-faicon
                    "hand-o-right" :face 'my-ivy-arrow-invisible) " " str))
         cands
         "\n"))
      (setq ivy-format-functions-alist
            '((t . my-ivy-format-function-arrow))))
  (setq ivy-format-functions-alist '((t . ivy-format-function-arrow))))

;;-------------------------------------------------------------------------
(use-package all-the-icons-ivy)
(when (require 'all-the-icons-ivy nil t)
  (dolist (command '(counsel-projectile-switch-project
                     counsel-ibuffer))
    (add-to-list 'all-the-icons-ivy-buffer-commands command))
  (all-the-icons-ivy-setup))


;; ------------------------------------------------------------------------company
(use-package company)
(global-company-mode) ; 全バッファで有効にする 
(setq company-idle-delay 0) ; デフォルトは0.5
(setq company-minimum-prefix-length 2) ; デフォルトは4
(setq company-selection-wrap-around t) ; 候補の一番下でさらに下に行こうとすると一番上に戻る
;;(add-to-list 'company-backends 'company-yasnippet) ; 何故か指定しなくても動作をするので入れていない

(define-key company-active-map (kbd "M-n") nil)
(define-key company-active-map (kbd "M-p") nil)
(define-key company-active-map (kbd "C-n") 'company-select-next)
(define-key company-active-map (kbd "C-p") 'company-select-previous)
(define-key company-active-map (kbd "C-h") nil)
;;------------------------------------------------------------------------eglot
;; https://granddaifuku.hatenablog.com/entry/emacs-eglot
;; https://mopemope.com/emacs-config/
(use-package eglot)
(use-package rustic)
(setq rustic-lsp-client 'eglot)
(add-to-list 'eglot-server-programs '(c++-mode . ("clangd"))) ;clangdというlspの設定
(add-to-list 'eglot-server-programs '(c-mode . ("clangd" "-header-insertion=never"))) ;clangdというlspの設定
;; -header-insertion=neverで勝手にヘッダーincludeをコードに追記するのを中止している
(add-to-list 'eglot-server-programs '(rust-mode . ("rust-analyzer")))
(add-hook 'c++-mode-hook 'eglot-ensure)
(add-hook 'c-mode-hook 'eglot-ensure)
(add-hook 'rust-mode-hook 'eglot-ensure)
(remove-hook 'rustic-mode-hook 'flycheck-mode);flycheckを無効化
;;(add-hook 'eglot--managed-mode-hook (lambda () (flymake-mode -1))); flycheckを利用する場合
(define-key eglot-mode-map (kbd "C-c e f") 'eglot-format)
(define-key eglot-mode-map (kbd "C-c e n") 'eglot-rename)

(define-key eglot-mode-map (kbd "<f6>") 'xref-find-definitions)


;; yasnippetは他の方からもらってきた
;; http://ayageman.blogspot.com/2019/02/emacsyasnippet.html
;; 一応、なぜかcompanyと馴染んでいる。（理由はわからない）
;; Rustは対応していないので調整をする必要がある

(use-package yasnippet :ensure t
  :diminish
  ;; :after (counsel)
  :after ivy ;; [201904]
  :bind (
		 :map yas-minor-mode-map
		 ("C-c s i" . yas-insert-snippet)  ; 既存へ挿入
		 ("C-c s n" . yas-new-snippet)     ; 新規作成
		 ("C-c s v" . yas-visit-snippet-file)  ; 既存の閲覧編集
		 ("C-c s l" . yas-describe-tables) ; 選択可能なスニペットの一覧表示
		 ("C-c s g" . yas-reload-all))
  :hook ((prog-mode . yas-minor-mode)
         (markdown-mode . yas-minor-mode)
         (rst-mode . yas-minor-mode)
         (org-mode . yas-minor-mode))
  :config
  (yas-reload-all) ;;[201904]
  (yas-minor-mode) ;;[201904]
  (setq yas-snippet-dirs '("~/.emacs.d/mysnippets")) ;;[201907]
  ;;  Original value ("/home/hogehoge/.emacs.d/snippets")
  ;;  に戻す。別ディレクトだと、うまくいかない。
  ;; -------------------------------------------------------------------------------------------------
  ;; yasnippet-snippets
  ;; -------------------------------------------------------------------------------------------------
  ;; yasnippetの例がいっぱい入っているやつ
  (use-package yasnippet-snippets :ensure t) ;; mainのdirsは自動設定

  ;; -------------------------------------------------------------------------------------------------
  ;; ivy-yasnippet
  ;; -------------------------------------------------------------------------------------------------
  ;; ivy-yasnippets : call ivy-yasnippet in yas-minor-mode.
  (use-package ivy-yasnippet :ensure t
	:bind ("C-c y s" . ivy-yasnippet)
	:config
	(setq ivy-yasnippet-expand-keys "smart") ; nil "always" , "smart"
	;; https://github.com/seagle0128/.emacs.d/blob/master/lisp/init-ivy.el
	(advice-add #'ivy-yasnippet--preview :override #'ignore)
	)
  ;; こいつをdataに入れれば、indentが反映される。
  ;; # expand-env: ((yas-indent-line 'fixed) (yas-wrap-around-region 'nil))
  )

;; -------------------------------------------------------------------------------------------------
;; sublimity
;; -------------------------------------------------------------------------------------------------
;; -----------------------------------------sublimetext風のminimap
;;(use-package sublimity)
;;  (require 'sublimity)
;;  (require 'sublimity-scroll)
;;
;;(require 'sublimity-map)
;;(setq sublimity-map-size 40)
;;(setq sublimity-map-fraction 0.3)
;;(setq sublimity-map-text-scale -7)

;; -------------------------------------------------------------------------------------------------
;; minimap
;; -------------------------------------------------------------------------------------------------
;; VScodeやsublimetextのように右にminmapを表示することができる。
(use-package minimap
  :commands
  (minimap-bufname minimap-create minimap-kill)
  :custom
  (minimap-major-modes '(prog-mode))

  (minimap-window-location 'right)
  (minimap-update-delay 0.2)
  (minimap-minimum-width 20)
  :bind
  ([f9] . minimap-mode)

  :config
  (custom-set-faces
   '(minimap-active-region-background
     ((((background dark)) (:background "#555555555555"))
      (t (:background "#C847D8FEFFFF"))) :group 'minimap)))



;; With use-package:
;; -------------------------------------------------------------------------------------------------
;; company-box
;; -------------------------------------------------------------------------------------------------
;; モダンな補完機能
(use-package company-box
  :hook (company-mode . company-box-mode))
;; -------------------------------------------------------------------------------------------------
;; company-quickhel
;; -------------------------------------------------------------------------------------------------
;; VScodeみたいに補完の隣に説明を表示してくれる
(use-package company-quickhelp          ; Documentation popups for Company
  :ensure t
  :defer t
  :init (add-hook 'global-company-mode-hook #'company-quickhelp-mode))

;; -------------------------------------------------------------------------------------------------
;; imenu-list
;; -------------------------------------------------------------------------------------------------
;; 関数参照などを行えるようになる
(use-package imenu-list
  :bind
  ("<f10>" . imenu-list-smart-toggle)
  :custom-face
  (imenu-list-entry-face-1 ((t (:foreground "white"))))
  :custom
  (imenu-list-focus-after-activation t)
  (imenu-list-auto-resize nil))
;; -------------------------------------------------------------------------------------------------
;; openwith
;; -------------------------------------------------------------------------------------------------
;; Dirやneotreeで動画ファイルなどを開いた際に外部コマンドで実行を行う

(use-package openwith)
(when (require 'openwith nil 'noerror)
  (setq openwith-associations
        (list
         (list (openwith-make-extension-regexp
                '("mpg" "mpeg" "mp3" "mp4"
                  "avi" "wmv" "wav" "mov" "flv"
                  "ogm" "ogg" "mkv"))
               "vlc"
               '(file))
         (list (openwith-make-extension-regexp
                '("xbm" "pbm" "pgm" "ppm" "pnm"
                  "png" "gif" "bmp" "tif" "jpeg" "jpg"))
               "gwenview"
               '(file))
         (list (openwith-make-extension-regexp
                '("doc" "xls" "ppt" "odt" "ods" "odg" "odp"))
               "libreoffice"
               '(file))
         ;;'("\\.lyx" "lyx" (file))
         ;;'("\\.chm" "kchmviewer" (file))
         (list (openwith-make-extension-regexp
                '("pdf" "ps" "ps.gz" "dvi"))
               "okular"
               '(file))
         ))
  (openwith-mode 1))


;; -------------------------------------------------------------------------------------------------
;; EmacsApplicationFramework
;; -------------------------------------------------------------------------------------------------
;; Emacs内でWebブラウザやビデオ再生を可能とするフレームワーク
;; dbusでPyQtと通信を行い、オーバーレイすることで表示を行っている
;; AURでemacs-eafをインストールする必要がある。
;; オプションは全部インストールすること。(明示的には入れてくれないので、自身で入れる)
;; 追加でpython-pyqt5-sipが必要となる。
;; Emacsの２窓をするとかなり不安定になるためおすすめしない。そもそもしないと思うけどデバッグの際に注意が必要
;; ea-open-gitはまだ使い方がいまいちわからないので入れていない(必要なパッケージは、PyGit2)
(use-package eaf
  :load-path "/usr/share/emacs/site-lisp/eaf" ; Set to "~/.emacs.d/site-lisp/emacs-application-framework" if installed from AUR
  ;; :load-path "/home/toto/Git/emacs-application-framework"
  :custom
  (eaf-find-alternate-file-in-dired t)
  (eaf-browser-continue-where-left-off t)
  :config
  (eaf-bind-key scroll_up "C-n" eaf-pdf-viewer-keybinding)
  (eaf-bind-key scroll_down "C-p" eaf-pdf-viewer-keybinding)
  (eaf-bind-key take_photo "p" eaf-camera-keybinding))


;; -------------------------------------------------------------------------------------------------
;; ace-window
;; -------------------------------------------------------------------------------------------------
;; tmux風のWindow間を移動する手段
(use-package ace-window
  ;; :functions hydra-frame-window/body
  :config
  (global-set-key (kbd "C-x o") 'ace-window)

  ;; ("C-M-o" . hydra-frame-window/body)
  :custom
  (aw-keys '(?j ?k ?l ?i ?o ?h ?y ?u ?p))
  :custom-face
  (aw-leading-char-face ((t (:height 4.0 :foreground "#f1fa8c")))))
;; -------------------------------------------------------------------------------------------------
;; <方向キー>でウィンドウ間移動を可能にする
;; -------------------------------------------------------------------------------------------------
;; eafではではオーバーレイされているため、ace-windowのアルファベットを表示できない。よって、C-c <方向キー>でも移動できるようにしている。
(global-set-key (kbd "C-c <left>")  'windmove-left)
(global-set-key (kbd "C-c <right>") 'windmove-right)
(global-set-key (kbd "C-c <up>")    'windmove-up)
(global-set-key (kbd "C-c <down>")  'windmove-down)

;; EmacsのデフォルトのブラウザをEafに変更
(setq browse-url-browser-function 'eaf-open-browser)
(defalias 'browse-web #'eaf-open-browser)

;; -------------------------------------------------------------------------------------------------
;; whichkey
;; -------------------------------------------------------------------------------------------------
;; キーマップのチートシート
;; which-key-show-mapで表示することができる。
(use-package which-key
  :diminish which-key-mode
  :hook (after-init . which-key-mode))

;; -------------------------------------------------------------------------------------------------
;; モダンなタブであるcetaur-tabs
;; -------------------------------------------------------------------------------------------------
;; https://github.com/ema2159/centaur-tabs
(use-package centaur-tabs
  :ensure t
  :config
  (setq centaur-tabs-style "wave"		;どんなタブにするかを選択することができる
		centaur-tabs-height 32
		centaur-tabs-set-icons t
		centaur-tabs-set-modified-marker t
		centaur-tabs-show-navigation-buttons t
		centaur-tabs-set-bar 'under
		x-underline-at-descent-line t)
  (centaur-tabs-headline-match)
  ;; (setq centaur-tabs-gray-out-icons 'buffer)
  ;; (centaur-tabs-enable-buffer-reordering)
  ;; (setq centaur-tabs-adjust-buffer-order t)
  (centaur-tabs-mode t)
  (setq uniquify-separator "/")
  (setq uniquify-buffer-name-style 'forward)
  (defun centaur-tabs-buffer-groups ()
    "`centaur-tabs-buffer-groups' control buffers' group rules.

 Group centaur-tabs with mode if buffer is derived from `eshell-mode' `emacs-lisp-mode' `dired-mode' `org-mode' `magit-mode'.
 All buffer name start with * will group to \"Emacs\".
 Other buffer group by `centaur-tabs-get-group-name' with project name."
    (list
     (cond
	  ;; ((not (eq (file-remote-p (buffer-file-name)) nil))
	  ;; "Remote")
	  ((or (string-equal "*" (substring (buffer-name) 0 1))
	       (memq major-mode '(magit-process-mode
							  magit-status-mode
							  magit-diff-mode
							  magit-log-mode
							  magit-file-mode
							  magit-blob-mode
							  magit-blame-mode
							  )))
	   "Emacs")
	  ((derived-mode-p 'prog-mode)
	   "Editing")
	  ((derived-mode-p 'dired-mode)
	   "Dired")
	  ((memq major-mode '(helpful-mode
						  help-mode))
	   "Help")
	  ((memq major-mode '(org-mode
						  org-agenda-clockreport-mode
						  org-src-mode
						  org-agenda-mode
						  org-beamer-mode
						  org-indent-mode
						  org-bullets-mode
						  org-cdlatex-mode
						  org-agenda-log-mode
						  diary-mode))
	   "OrgMode")
	  (t
	   (centaur-tabs-get-group-name (current-buffer))))))
  :hook
  (dashboard-mode . centaur-tabs-local-mode)
  (term-mode . centaur-tabs-local-mode)
  (calendar-mode . centaur-tabs-local-mode)
  (org-agenda-mode . centaur-tabs-local-mode)
  (helpful-mode . centaur-tabs-local-mode)
  :bind
  ("C-<prior>" . centaur-tabs-backward)
  ("C-<next>" . centaur-tabs-forward)
  ("C-c t s" . centaur-tabs-counsel-switch-group)
  ("C-c t p" . centaur-tabs-group-by-projectile-project)
  ("C-c t g" . centaur-tabs-group-buffer-groups))

;; -----------------------------------------------------------------------------------------------
;; whitespacの設定
;; -----------------------------------------------------------------------------------------------
(use-package whitespace
  :ensure nil)
;; 空白
(set-face-foreground 'whitespace-space nil)
(set-face-background 'whitespace-space "SlateBlue3") ;全角の空白の表示の色
;; ファイル先頭と末尾の空行
(set-face-background 'whitespace-empty "gray33")
;; タブ
(set-face-foreground 'whitespace-tab nil)
(set-face-background 'whitespace-tab nil)
;; ???
(set-face-background 'whitespace-trailing "gray33")
(set-face-background 'whitespace-hspace "gray33")

(setq whitespace-style '(face           ; faceで可視化
                         trailing       ; 行末
						 ;;                         tabs           ; タブ（Makefileでほしいのでそのままで）
						 ;;                         empty          ; 先頭/末尾の空行(うっとおしい惜しいので解除)
                         spaces         ; 空白
                         ;; space-mark     ; 表示のマッピング
						 ;;                         tab-mark
						 ))

;; スペースは全角のみを可視化
(setq whitespace-space-regexp "\\(\u3000+\\)")

;; タブの表示を変更
(setq whitespace-display-mappings
      '((tab-mark ?\t [?\xBB ?\t])))

;; 発動
(global-whitespace-mode 1)


;;------------------------------------------------------------------------------------------------
;; org-mode
;;------------------------------------------------------------------------------------------------

;; 画像をインラインで表示
(setq org-startup-with-inline-images t)

;; 見出しの余分な*を消す
(setq org-hide-leading-stars t)

;; LOGBOOK drawerに時間を格納する
(setq org-clock-into-drawer t)

;; .orgファイルは自動的にorg-mode
(add-to-list 'auto-mode-alist '("\\.org\\'" . org-mode))


										; ファイルの場所
(setq org-directory "~/Documents/Org")
;; org-directory内のファイルすべてからagendaを作成する
(setq my-org-agenda-dir "~/Documents/Org/agenda/")
(setq org-agenda-files (list my-org-agenda-dir))

;; TODO状態
(setq org-todo-keywords
      '((sequence "TODO(t)" "WAIT(w)" "NOTE(n)"  "|" "DONE(d)" "SOMEDAY(s)" "CANCEL(c)")))

;; DONEの時刻を記録
(setq org-log-done 'time)

;; ショートカットキー
(global-set-key "\C-cl" 'org-store-link)
(global-set-key "\C-cc" 'org-capture)
(global-set-key "\C-ca" 'org-agenda)
(global-set-key "\C-cb" 'org-iswitchb)

;; http://www.mhatta.org/wp/2018/08/16/org-mode-101-1/
;; から拝借
;; Org-captureのテンプレート（メニュー）の設定
;; ("キーバインド" "表示名" type (target) template properties)
;; ここにorg-capureですぐ書きたいやつを追加する
(setq org-capture-templates
      '(
		("n" "Note" entry (file+headline "~/Documents/Org/notes.org" "Notes")"* %?\nEntered on %U\n %i\n %a")
		("t" "ToDo" entry (file+headline "~/Documents/Org/agenda/todo11.org" "TOP")"* REMIND %? (wrote on %U)")
		)
	  )

; メモをC-M-^一発で見るための設定
; https://qiita.com/takaxp/items/0b717ad1d0488b74429d から拝借
(defun show-org-buffer (file)
  "Show an org-file FILE on the current buffer."
  (interactive)
  (if (get-buffer file)
      (let ((buffer (get-buffer file)))
        (switch-to-buffer buffer)
        (message "%s" file))
    (find-file (concat "~/Documents/Org/" file))))
(global-set-key (kbd "C-M-^") '(lambda () (interactive)
                                 (show-org-buffer "notes.org")))
;; org-modeを見やすくするためのパッケージ
;; https://github.com/sabof/org-bullets
(use-package org-bullets
  :ensure t
  :hook (org-mode . org-bullets-mode))



;; ---------------------------------------------------------------
;; Magitの設定
;; ---------------------------------------------------------------
;; C-x g でmagitが起動
;; C-x M-gでmagitのヘルプメニューが起動
(use-package magit
  :ensure t
  :bind (("C-x g" . magit-status)
         ("C-x M-g" . magit-dispatch-pop))
  :init
  :config
  )

;; --------------------------------------------------------------
;; Docker関連の設定
;; --------------------------------------------------------------
;; docker.el
;; https://github.com/Silex/docker.el
(use-package docker
  :ensure t
  :bind ("C-c d" . docker))

;; dockerfile-mode
;; https://github.com/spotify/dockerfile-mode
(use-package dockerfile-mode
  :ensure t)
(add-to-list 'auto-mode-alist '("Dockerfile\\'" . dockerfile-mode))

;; docker-tramp
(use-package docker-tramp
  :ensure t)
(require 'docker-tramp-compat)
(set-variable 'docker-tramp-use-names t) ; コンテナの補完をIDではなくNAMESでしてほしい場合

;; --------------------------------------------------------------------------------
;; gdbの設定
;; --------------------------------------------------------------------------------
(setq gdb-many-windows t)
(setq gdb-use-separate-io-buffer t) ; "IO buffer" が必要ない場合は  nil で

;; --------------------------------------------------------------------------------
;; delsel
;; --------------------------------------------------------------------------------
;; 選択した状態で入力をすると削除される
;; https://github.com/jaseemabid/emacs.d/blob/master/init.el
(use-package delsel
  :config
  ;; type over a region
  (pending-delete-mode t))

