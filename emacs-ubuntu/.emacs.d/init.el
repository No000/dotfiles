;; Ubuntuでも実行可能を目指す
;; よってvtermはコメントアウト


(run-with-idle-timer 60.0 t #'garbage-collect)


(let (;; temporarily increase `gc-cons-threshold' when loading to speed up startup.
      (gc-cons-threshold most-positive-fixnum)
      ;; Empty to avoid analyzing files when loading remote files.
      (file-name-handler-alist nil))


  
  
  (require 'package)  ; package.elを有効化
  (setq package-archives
		'(("melpa" . "https://melpa.org/packages/")
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



  ;; ================================================================================
  ;; 文字コードの設定
  ;; ================================================================================
  (set-language-environment "Japanese")
  (prefer-coding-system 'utf-8)



  ;; ================================================================================
  ;; 行番号  
  ;; ================================================================================
  
  ;; 行番号
  ;;(global-linum-mode t)
  (global-display-line-numbers-mode)
  (add-hook 'neotree-mode-hook (lambda () (display-line-numbers-mode -1)))
  (add-hook 'imenu-list-major-mode-hook (lambda () (display-line-numbers-mode -1)))
  (add-hook 'shell-mode-hook (lambda () (display-line-numbers-mode -1)))
  (add-hook 'eshell-mode-hook (lambda () (display-line-numbers-mode -1)))
  (add-hook 'dired-mode-hook (lambda () (display-line-numbers-mode -1)))
  (add-hook 'neotree-mode-hook (lambda () (display-line-numbers-mode -1)))


  ;; ================================================================================
  ;; 細かい設定
  ;; ================================================================================


  ;; 右クリックで選択領域をコピー
  (global-set-key (kbd "<mouse-3>") 'copy-region-as-kill)

  
  ;; カラム番号を表示
  ;;(line-number-mode t)
  (column-number-mode t)

  ;; 警告音の代わりに画面フラッシュ
  (setq visible-bell t)

  ;; スタートアップページを表示しない
  (setq inhibit-startup-message t)

  ;; 警告音もフラッシュも全て無効(警告音が完全に鳴らなくなるので注意)
  ;; (setq ring-bell-function 'ignore)

  ;; barを出るようにする
  (global-hl-line-mode t) 

  ;; 現状スクロールバーとメニューバーを使っていないため削除する。
  ;; 可能であればyaskrollのようなものに変更を行いたい。
  (tool-bar-mode -1)     ;ツールバーをなくす
  (menu-bar-mode -1)     ;メニューバーをなくす
;;; これはお好みで
  (scroll-bar-mode -1)   ;スクロールバーをなくす

  ;; c-hとbackspaceで上書き
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

  ;; vi-like line insertion
  ;; vim のoコマンドのような挙動に修正
  
  (global-set-key (kbd "C-c o") 'facemenu-keymap)
  (global-set-key (kbd "C-o") (lambda () (interactive)(end-of-line)(newline-and-indent)))
  (global-set-key (kbd "M-o") (lambda () (interactive)(previous-line)(end-of-line)(newline-and-indent)))
  (bind-key* "M-h" 'backward-kill-word)




  ;; 画面拡大ショートカット割当
  (define-key global-map (kbd "C-<f11>") 'toggle-frame-maximized)




  (setq-default c-basic-offset 4     ;;基本インデント量4
				tab-width 4          ;;タブ幅4
				indent-tabs-mode nil)  ;;インデントをタブでするかスペースでするか



  ;; ================================================================================
  ;; async
  ;; ================================================================================

  (use-package async
	:ensure t)
  (autoload 'dired-async-mode "dired-async.el" nil t) ;これはhelmで効果を発揮するらしいけど、ivyだとどうなんだろ。
  (dired-async-mode 1)

  (async-bytecomp-package-mode 1)			;非同期でパッケージのコンパイルを行う


  ;; ================================================================================
  ;; 合字フォントを実現するための処理.
  ;; ================================================================================
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

  ;; 絵文字
  
  (use-package emojify :ensure t
    :if (display-graphic-p)
    :hook (after-init . global-emojify-mode)
    :bind
    ("C-c E" . 'emojify-insert-emoji)
	:config
	(add-hook 'prog-mode-hook (lambda () (emojify-mode -1)))
    )


  ;; Use variable width font faces in current buffer
  (defun ricty-font-change ()
	"Set font to a variable width (proportional) fonts in current buffer"
	(interactive)
	(setq buffer-face-mode-face '(:family "Ricty Diminished"))
	(buffer-face-mode))

  ;; 日本語フォントの設定
  ;; https://qiita.com/Maizu/items/fee34328f559c7dc59d8
  (set-fontset-font t 'japanese-jisx0208 "Ricty Diminished")


  ;; CalcadiaCode側をフックするとうまくいかないので、逆で行く
  ;; 合字フォントを使いたくない場合はここに記載
  (add-hook 'emacs-lisp-mode-hook 'ricty-font-change)


  ;; ================================================================================
  ;; インデントの設定
  ;; ================================================================================

  
  ;; TABの表示幅。初期値は8
  (setq-default tab-width 4)

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
  (setq custom-file (locate-user-emacs-file "~/.emacs.d/custom.el"))
  ;; カスタムファイルが存在しない場合は作成する
  (unless (file-exists-p custom-file)
	(write-region "" nil custom-file))
  ;; カスタムファイルを読見込む
  (load custom-file)
  

  ;;
  ;; backup の保存先
  ;;
  (setq backup-directory-alist
		(cons (cons ".*" (expand-file-name "~/.emacs.d/backup/"))
			  backup-directory-alist))


  (setq auto-save-file-name-transforms
		`((".*", (expand-file-name "~/.emacs.d/backup/") t)))



  ;; ================================================================================
  ;; ハイライト関連
  ;; ================================================================================

  
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


  (use-package all-the-icons
    )
  ;; (all-the-icons-install-fonts) ; 初期インストール
  (use-package all-the-icons-ibuffer
    :ensure t
    :init (all-the-icons-ibuffer-mode 1))

  ;; all-the-iconsを追加する
  (setq all-the-icons-mode-icon-alist
        `(,@all-the-icons-mode-icon-alist

    	  (twittering-mode all-the-icons-faicon "twitter" :v-adjust 0.0 :face all-the-icons-blue)
          ))



  ;; ================================================================================
  ;; オートセーブ・バックアップ関連
  ;; ================================================================================
  
  ;; オートセーブをファイル作成までの秒間隔
  (setq auto-save-timeout 15)
  ;; オートセーブファイル作成までのタイプ間隔
  (setq auto-save-interval 60)


  ;; ================================================================================
  ;; mozc関連
  ;; ================================================================================

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

  ;; ================================================================================
  ;; doom-thema & doom-modeline
  ;; ================================================================================

  
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
    ;; (doom-modeline-major-mode-color-icon t)
	(doom-modeline-minor-modes nil)
    (doom-modeline-mu4e t)
	:hook
	(after-init . doom-modeline-mode)
	:config
	(line-number-mode 0)
	(column-number-mode 0)
	)

  ;; ================================================================================
  ;; dashboard
  ;; ================================================================================
  (use-package page-break-lines)

  ;; プロジェクト管理パッケージ
  (use-package projectile)
  (projectile-mode +1)
  (define-key projectile-mode-map (kbd "s-p") 'projectile-command-map)
  (define-key projectile-mode-map (kbd "C-c C-p") 'projectile-command-map) ;jupyterを使うために退避
  ;; これはタイトルをオシャンティーにするやつ
  (use-package dashboard
	;; :bind (("<f5>" . open-dashboard)
	;; 	   :map dashboard-mode-map
	;; 	   ("<f5>" . quit-dashboard))
	:diminish
	(dashboard-mode page-break-lines-mode)
	:custom
	(dashboard-startup-banner 3)
	(dashboard-items '((recents . 15)
					   (projects . 5)
					   (bookmarks . 5)))
	:hook
	(after-init . dashboard-setup-startup-hook)
	:config
	;; (add-to-list 'dashboard-items '(agenda) t)
    )


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
  ;; ================================================================================
  ;; multi-term
  ;; ================================================================================

  
  (use-package multi-term)
  (when (require 'multi-term nil t)
	;;使用するシェルを指定
	(setq multi-term-program "/usr/bin/fish"))

  
  (require 'wgrep nil t)

  ;; ================================================================================
  ;; undotree
  ;; ================================================================================
  (use-package undo-tree)
  (when (require 'undo-tree nil t)
	(global-undo-tree-mode))

  
  ;; ================================================================================
  ;; neotree
  ;; ================================================================================


  (use-package neotree)
  ;; F8でnetreee-windowが開くようにする
  (global-set-key [f7] 'neotree-toggle)
  ;; neotreeでファイルを新規作成した場合のそのファイルを開く
  (setq neo-create-file-auto-open t)
  ;; delete-other-window で neotree ウィンドウを消さない
  (setq neo-persist-show t)
  (setq neo-theme (if (display-graphic-p) 'icons 'arrow))
  (setq neo-show-hidden-files t) ;隠しファイルを表示
  (setq neo-window-fixed-size nil)		;固定されていたウィンドウサイズを変更かのうへ　
  (setq neo-window-width 30)				;20から40に変更

  ;; ================================================================================
  ;; paradox
  ;; ================================================================================


  (use-package paradox
	:ensure t
	:custom
	(paradox-github-token t))

  
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



  (use-package ivy-posframe
	:ensure t)


  ;; -------------------------------------------------------------------------------counselの設定

  (use-package counsel
	:ensure t)



  ;; ;; キーバインドは一例です．好みに変えましょう．
  (global-set-key (kbd "M-x") 'counsel-M-x)
  (global-set-key (kbd "M-y") 'counsel-yank-pop)
  (global-set-key (kbd "C-M-z") 'counsel-fzf)
  (global-set-key (kbd "C-M-r") 'counsel-recentf)
  (global-set-key (kbd "C-x C-b") 'counsel-ibuffer)
  (global-set-key (kbd "C-M-f") 'counsel-ag)
  (global-set-key (kbd "C-M-f") 'counsel-ag)
  (global-set-key (kbd "C-M-f") 'counsel-ag)
  (global-set-key (kbd "C-c h") 'counsel-recentf)
  ;; (global-set-key (kbd "C-c b") 'counsel-switch-buffer)


  ;; -------------------------------------------------------------------------------swipperの設定
  ;; swiper
  (use-package swiper)
  (when (require 'swiper nil t)
	;; キーバインドは一例です．好みに変えましょう．
	(global-set-key (kbd "M-s M-s") 'swiper-thing-at-point))



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
                      :v-adjust -0.2 :face 'my-ivy-arrow-visible :height 0.6 ) ;文が切れるので調整を行った。
					 " " (ivy--add-face str 'ivy-current-match)))
           (lambda (str)
			 (concat (all-the-icons-faicon
                      "hand-o-right" :face 'my-ivy-arrow-invisible :height 0.6) " " str))
           cands
           "\n"))
		(setq ivy-format-functions-alist
              '((t . my-ivy-format-function-arrow))))
	(setq ivy-format-functions-alist '((t . ivy-format-function-arrow))))

  ;;-------------------------------------------------------------------------
  (use-package all-the-icons-ivy
	:ensure t)
  (when (require 'all-the-icons-ivy nil t)
	(dolist (command '(counsel-projectile-switch-project
                       counsel-ibuffer))
      (add-to-list 'all-the-icons-ivy-buffer-commands command))
	(all-the-icons-ivy-setup))
  ;; (setq all-the-icons-ivy-rich-icon-size 0.5)


  (use-package all-the-icons-ivy-rich
    :ensure t
    :init (all-the-icons-ivy-rich-mode 1))

  (use-package ivy-rich
    :ensure t
    :init (ivy-rich-mode 1))

  (with-eval-after-load "all-the-icons-ivy"
    (defvar my-tab-width tab-width)
    (defun my-tab-width-2 () (setq tab-width 2))
    (defun my-tab-width-1 () (setq tab-width 1))
    (defun my-tab-width-8 () (setq tab-width 8))
    (defun my-tab-width-original ()
      (setq tab-width my-tab-width))
    (add-hook 'minibuffer-setup-hook #'my-tab-width-2)
    (add-hook 'minibuffer-exit-hook #'my-tab-width-original))
  ;; ------------------------------------------------------------------------company
  (use-package company)
  (global-company-mode) ; 全バッファで有効にする 
  (setq company-idle-delay 0) ; デフォルトは0.5
  (setq company-minimum-prefix-length 2) ; デフォルトは4
  (setq company-selection-wrap-around t) ; 候補の一番下でさらに下に行こうとすると一番上に戻る

  (define-key company-active-map (kbd "M-n") nil)
  (define-key company-active-map (kbd "M-p") nil)
  (define-key company-active-map (kbd "C-n") 'company-select-next)
  (define-key company-active-map (kbd "C-p") 'company-select-previous)
  (define-key company-active-map (kbd "C-h") nil)



  
  ;; ================================================================================
  ;; rustic
  ;; ================================================================================

  ;; cargoのPATHの設定
  (add-to-list 'exec-path (expand-file-name "~/.cargo/bin/"))
  (use-package rustic
	:ensure t)
  ;; 本当にwithout switchしているわけではなく前のウィンドウにフォーカスを戻すだけ
  (defun pop-to-buffer-without-switch (buffer-or-name &optional action norecord)
	(pop-to-buffer buffer-or-name action norecord)
	(other-window -1)
	)


  ;; ===========================================================================================
  ;; lsp-mode
  ;; ===========================================================================================

  ;; eglotの対応が少ないのが辛いのでlsp-modeに移行する
  ;;set prefix for lsp-command-keymap (few alternatives - "C-l", "C-c l")

  (add-to-list 'global-mode-string '(t (:eval lsp-modeline--code-actions-string)))
  (custom-set-variables '(rustic-format-display-method 'pop-to-buffer-without-switch))
  
  (use-package lsp-mode
	:ensure t
    :config
    (setq lsp-headerline-breadcrumb-enable nil)
	:custom
	(lsp-headerline-breadcrumb-mode t)

	:hook (;; replace XXX-mode with concrete major-mode(e. g. python-mode)
           (c-mode . lsp)
		   (c++-mode . lsp)
		   ;;		   (nim-mode . lsp)
		   (rustic-mode . lsp)
		   (python-mode . lsp)
           (sh-mode . lsp)
           (go-mode . lsp-deferred)
           ;; if you want which-key integration
           (lsp-mode . lsp-enable-which-key-integration)
           (lsp-managed-mode . lsp-modeline-diagnostics-mode)
           ;; (lsp-mode . lsp-headerline-breadcrumb-mode)   ;; Ubunutuだと調子がわるくなるので設定
           (lsp-mode . lsp-modeline-code-actions-mode))
    
	:commands lsp lsp-deferred)





  

  (setq-default rustic-format-trigger 'on-save)
  (setq rustic-lsp-server 'rust-analyzer)
  ;; optionally
  (use-package lsp-ui
	:ensure t
	:custom
	;; lsp-ui-peek
	(lsp-ui-peek-enable t)
	(lsp-ui-peek-peek-height 20)
	(lsp-ui-peek-list-width 50)
	(lsp-ui-peek-fontify 'always) ;; never, on-demand, or always
	(lsp-ui-sideline-enable t)
	(lsp-ui-doc-use-childframe t)
	(lsp-ui-doc-use-webkit t)
	:commands lsp-ui-mode
	:preface
	(defun ladicle/toggle-lsp-ui-doc ()
      (interactive)
      (if lsp-ui-doc-mode
          (progn
			(lsp-ui-doc-mode -1)
			(lsp-ui-doc--hide-frame))
		(lsp-ui-doc-mode 1)))
	:bind
	("C-c r" . lsp-ui-peek-find-references)
	("<f6>"   . ladicle/toggle-lsp-ui-doc)
	;; ("C-c j" . lsp-ui-peek-find-definitions)
	;; ("C-c i"   . lsp-ui-peek-find-implementation) ; clangdがサポートしていない
	)
  ;; if you are helm user

  ;; if you are ivy user
  (use-package lsp-ivy
	:ensure t
	:commands lsp-ivy-workspace-symbol)

  ;; (use-package lsp-treemacs
  ;;   :ensure t
  ;;   :commands lsp-treemacs-errors-list)

  ;; optionally if you want to use debugger
  (use-package dap-mode
	:ensure t)
  ;; (use-package dap-LANGUAGE) to load the dap adapter for your language

  (setq lsp-clients-clangd-executable "/usr/bin/clangd")
  (setq lsp-clients-clangd-args
		'(;;"-j=2"
          ;; "--background-index"
          ;;"--clang-tidy"
          ;; "--completion-style=bundled"
          ;;"--pch-storage=memory"
          "--header-insertion=never"
          ;;"--header-insertion-decorators=0"
		  ))
  
  (defvar lsp-clients-clangd-args '("-header-insertion=never")) ;; if change clangd arguments here. see clangd --help

  ;; lsp-modeのパフォーマンスを上げるための調整
  (setq gc-cons-threshold 100000000)
  (setq read-process-output-max (* 1024 1024)) ;; 1mb
  (setq lsp-completion-provider :capf)

  ;; (define-key lsp-mode-map (kbd "<f6>") 'lsp-ui-peek-find-definition)
  ;; ===========================================================================================
  ;; yasnippet
  ;; ===========================================================================================
  ;; yasnippetは他の方からもらってきた
  ;; http://ayageman.blogspot.com/2019/02/emacsyasnippet.html

  ;; yasnippetはtabで出てきます。

  (use-package yasnippet :ensure t
	:diminish
	;;:after (counsel)
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
	)




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
  ;; GCを走らせないようにするためのカッコ（消すな）=====================================


  ;; -------------------------------------------------------------------------------------------------
  ;; EmacsApplicationFramework
  ;; -------------------------------------------------------------------------------------------------
  ;; Emacs内でWebブラウザやビデオ再生を可能とするフレームワーク
  ;; dbusでPyQtと通信を行い、オー;; バーレイすることで表示を行っている
  ;; AURでemacs-eafをインストールする必要がある。
  ;; オプションは全部インストールすること。(明示的には入れてくれないので、自身で入れる)
  ;; 追加でpython-pyqt5-sipが必要となる。
  ;; Emacsの２窓をするとかなり不安定になるためおすすめしない。そもそもしないと思うけどデバッグの際に注意が必要
  ;; ea-open-gitはまだ使い方がいまいちわからないので入れていない(必要なパッケージは、PyGit2)
  ;; (use-package eaf
  ;; 	;;:load-path "/usr/share/emacs/site-lisp/eaf" ; Set to "~/.emacs.d/site-lisp/emacs-application-framework" if installed from AUR
  ;; 	:load-path "~/dotfiles/emacs/.emacs.d/elisp/emacs-application-framework"
  ;; 	:custom
  ;; 	(eaf-find-alternate-file-in-dired t)
  ;; 	(eaf-browser-continue-where-left-off t)
  ;; 	:config
  ;; 	(eaf-bind-key scroll_up "C-n" eaf-pdf-viewer-keybinding)
  ;; 	(eaf-bind-key scroll_down "C-p" eaf-pdf-viewer-keybinding)
  ;; 	(eaf-bind-key take_photo "p" eaf-camera-keybinding))

  
  ;; (use-package epc
  ;;   :ensure t
  ;;   :defer t)

  ;; (use-package ctable	
  ;;   :ensure t
  ;;   :defer t)

  ;; (use-package deferred
  ;;   :ensure t
  ;;   )
  
  ;; (use-package eaf
  ;;   :load-path "~/dotfiles/emacs-simple-coding/.emacs.d/elisp/emacs-application-framework" ; Set to "/usr/share/emacs/site-lisp/eaf" if installed from AUR
  ;;   :init
  ;;   (use-package epc
  ;;     :defer t)
  ;;   (use-package ctable
  ;;     :defer t)
  ;;   (use-package deferred
  ;;     :defer t)
  ;;   (use-package s
  ;;     :defer t
  ;;     :ensure t)
  ;;   :custom
  ;;   (eaf-browser-continue-where-left-off t)
  ;;   :config
  ;;   (eaf-setq eaf-browser-enable-adblocker "true")
  ;;   (eaf-bind-key scroll_up "C-n" eaf-pdf-viewer-keybinding)
  ;;   (eaf-bind-key scroll_down "C-p" eaf-pdf-viewer-keybinding)
  ;;   (eaf-bind-key take_photo "p" eaf-camera-keybinding)
  ;;   (eaf-bind-key nil "M-q" eaf-browser-keybinding)) ;; unbind, see more in the Wiki
  ;; ;; (add-hook 'eaf-mode-hook 'eaf--update-modeline-icon)
  ;; (require 'eaf-all-the-icons)
  
  ;; ;; ブラウザ検索のショートカット
  ;; (global-set-key (kbd "C-c w")  'eaf-search-it)
  ;; ;; ブラウザ履歴の閲覧
  ;; (global-set-key (kbd "C-c W")  'eaf-open-browser-with-history)
  ;; ;; ブラウザのURLを叩いて飛ぶ用
  ;; (global-set-key (kbd "C-c u")  'eaf-open-browser)
  ;; (global-set-key (kbd "C-c p")  'eaf-open-jupyter) ;jupyterのキーバインド割当


  ;; ;; (require 'cl) を見逃す(起動時の警告対策)
  ;; (setq byte-compile-warnings '(not cl-functions obsolete))

  ;; ;; EmacsのデフォルトのブラウザをEafに変更
  ;; (setq browse-url-browser-function 'eaf-open-browser)
  ;; (defalias 'browse-web #'eaf-open-browser)

  
  ;; -------------------------------------------------------------------------------------------------
  ;; <方向キー>でウィンドウ間移動を可能にする
  ;; -------------------------------------------------------------------------------------------------
  ;; eafではではオーバーレイされているため、ace-windowのアルファベットを表示できない。よって、C-c <方向キー>でも移動できるようにしている。
  (global-set-key (kbd "C-c <left>")  'windmove-left)
  (global-set-key (kbd "C-c <right>") 'windmove-right)
  (global-set-key (kbd "C-c <up>")    'windmove-up)
  (global-set-key (kbd "C-c <down>")  'windmove-down)


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
	;; (mozc-mode . centaur-tabs-local-mode)
	:bind
	("C-<prior>" . centaur-tabs-backward)
	("C-<next>" . centaur-tabs-forward)
	("C-c t s" . centaur-tabs-counsel-switch-group)
	("C-c t p" . centaur-tabs-group-by-projectile-project)
	("C-c t g" . centaur-tabs-group-buffer-groups))






  ;; ================================================================================
  ;; highlight-indent-guides
  ;; ================================================================================
  ;; https://github.com/DarthFennec/highlight-indent-guides
  (use-package highlight-indent-guides
	:diminish
	:hook
	((prog-mode yaml-mode) . highlight-indent-guides-mode)
	:custom
	(highlight-indent-guides-auto-enabled t)
	(highlight-indent-guides-responsive t)
	(highlight-indent-guides-method 'bitmap)) ; column

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

  ;; 折り返すようにする
  (setq org-startup-truncated nil)
  
  ;; 画像をインラインで表示
  (setq org-startup-with-inline-images t)

  ;; 見出しの余分な*を消す
  (setq org-hide-leading-stars t)

  ;; LOGBOOK drawerに時間を格納する
  (setq org-clock-into-drawer t)

  ;; ソースのインデントをなくす
  (setq org-src-preserve-indentation nil
        org-edit-src-content-indentation 0)

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

  (setq org-src-preserve-indentation t)		;ソースブロックでインデントの有効化

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

  ;; ---------------------------------------------------------------
  ;; git関連のモード追加
  ;; ---------------------------------------------------------------
  (use-package gitignore-mode
	:ensure t)

  (add-to-list 'auto-mode-alist
               (cons "/.gitignore\\'" 'gitignore-mode))
  
  (use-package gitattributes-mode
	:ensure t)

  (add-to-list 'auto-mode-alist
               (cons "/.gitattributes\\'" 'gitignore-mode))

  (use-package gitconfig-mode
	:ensure t)
  
  (add-to-list 'auto-mode-alist
               (cons "/..gitconfig\\'" 'gitignore-mode))
  
  ;; --------------------------------------------------------------
  ;; Docker関連の設定
  ;; --------------------------------------------------------------
  ;; docker.el
  ;; https://github.com/Silex/docker.el
  (use-package docker
	:ensure t
	:bind ("C-c d" . docker))
  (setq docker-container-shell-file-name "/bin/bash")


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


  ;; ================================================================================
  ;; xterm-256color
  ;; ================================================================================
  ;; https://github.com/atomontage/xterm-color

  (use-package xterm-color
	:ensure t)

  ;; ================================================================================
  ;; eshell
  ;; ================================================================================





  (use-package eshell-prompt-extras
	:ensure t)

  (eval-after-load 'esh-opt
	'(progn (require 'eshell-prompt-extras)
			(setq eshell-highlight-prompt nil
				  eshell-prompt-function 'epe-theme-lambda)))

  (eval-after-load 'esh-opt
	'(progn (require 'eshell-prompt-extras)
			(setq eshell-highlight-prompt nil
				  eshell-prompt-function 'epe-theme-lambda)))

  (use-package fish-completion
	:ensure t)
  
  (when (and (executable-find "fish")
			 (require 'fish-completion nil t))
	(global-fish-completion-mode))


  (use-package eshell-syntax-highlighting
	:ensure t
	:after esh-mode
	:demand t ;; Install if not already installed.
	:config
	;; Enable in all Eshell buffers.
	(eshell-syntax-highlighting-global-mode +1))





  (setq comint-prompt-read-only t)		;これでshellとtermのプロンプトが消されることはなくなる
  
  (setq eshell-cmpl-ignore-case t)
  (setq eshell-glob-include-dot-dot nil)
  (setq eshell-ask-to-save-history (quote always))
  (setq eshell-history-size 100000)
  (setq eshell-hist-ignoredups t)

  ;; ;; https://github.com/4DA/eshell-toggle
  (use-package eshell-toggle
	:ensure t
	:custom
	(eshell-toggle-run-command nil)
	:bind
	("<f8>" . eshell-toggle))

  ;; alias
  (defvar *shell-alias* '(("ll" "ls -la")
                          ("cdd" "cd ~/Desktop")))
  (defvar eshell-command-aliases-list (append *shell-alias*))

  ;; ここにeshellだと表示やキーバインドが奪われるコマンドを追記する
  (setq eshell-visual-commands
		'("vim" "nvim"                                ; what is going on??
		  "htop"                      ; ok, a valid program...
		  "less" "more"                       ; M-x view-file)
		  "qemu-system-x86_64"				; qemuのCLI起動時に対応するため
		  ))


  (require 'em-term)
  (defun eshell-exec-visual (&rest args)
	(apply 'start-process
           "eshell-exec-visual" " eshell-exec-visual"
           "konsole" "-title" "eshell-exec-visual" "-e" args)
	nil)


  ;; ================================================================================
  ;; shell
  ;; ================================================================================
  ;; shellモードでプロンプトのカラー表示
  (require 'shell)
  (add-hook 'shell-mode-hook
			(lambda ()
			  (face-remap-set-base 'comint-highlight-prompt :inherit nil)))

  (setq comint-output-filter-functions
		(remove 'ansi-color-process-output comint-output-filter-functions))

  (add-hook 'shell-mode-hook
			(lambda ()
              ;; Disable font-locking in this buffer to improve performance
              (font-lock-mode -1)
              ;; Prevent font-locking from being re-enabled in this buffer
              (make-local-variable 'font-lock-function)
              (setq font-lock-function (lambda (_) nil))
              (add-hook 'comint-preoutput-filter-functions 'xterm-color-filter nil t)))

  ;; Also set TERM accordingly (xterm-256color) in the shell itself.

  ;; ================================================================================
  ;; git-gutter
  ;; ================================================================================
  ;; https://github.com/emacsorphanage/git-gutter
  ;; https://qiita.com/Ladicle/items/feb5f9dce9adf89652cf#%E5%A4%89%E6%9B%B4%E7%AF%84%E5%9B%B2%E3%81%A8%E6%93%8D%E4%BD%9C%E3%82%92%E5%8F%AF%E8%A6%96%E5%8C%96----git-gutter
  ;; git diffコマンドを活用した変更箇所の可視化

  (use-package git-gutter
	:custom
	(git-gutter:modified-sign "~")
	(git-gutter:added-sign    "+")
	(git-gutter:deleted-sign  "-")
	:init
	(add-hook 'c-mode-hook 'git-gutter-mode) ; add-hookしないとうまくうごかないので
	:custom-face
	(git-gutter:modified ((t (:background "#f1fa8c"))))
	(git-gutter:added    ((t (:background "#50fa7b"))))
	(git-gutter:deleted  ((t (:background "#ff79c6"))))
	:config
	(global-git-gutter-mode +1))
  

  ;; ================================================================================
  ;; google-translate
  ;; ================================================================================


  ;; popwin
  ;; https://github.com/emacsorphanage/popwin
  (use-package popwin
	:ensure t)
  (popwin-mode 1)

  ;; google翻訳
  ;; https://github.com/atykhonov/google-translate
  (use-package google-translate
	:ensure t)
  (require 'google-translate-smooth-ui)

  ;; 以下コードは以下のサイトより引用
  ;; https://blog.shibayu36.org/entry/2016/05/29/123342

  (defvar google-translate-english-chars "[:ascii:]"
	"これらの文字が含まれているときは英語とみなす")
  (defun google-translate-enja-or-jaen (&optional string)
	"regionか現在位置の単語を翻訳する。C-u付きでquery指定も可能"
	(interactive)
	(setq string
          (cond ((stringp string) string)
				(current-prefix-arg
				 (read-string "Google Translate: "))
				((use-region-p)
				 (buffer-substring (region-beginning) (region-end)))
				(t
				 (thing-at-point 'word))))
	(let* ((asciip (string-match
					(format "\\`[%s]+\\'" google-translate-english-chars)
					string)))
      (run-at-time 0.1 nil 'deactivate-mark)
      (google-translate-translate
       (if asciip "en" "ja")
       (if asciip "ja" "en")
       string)))


  (setq popwin:popup-window-position 'bottom)
  (push '("\*Google Translate\*") popwin:special-display-config)

  (global-set-key (kbd "C-c e") 'google-translate-enja-or-jaen)



  ;; 現状におけるバグなのか以下の記載がないと動かない
  ;; https://github.com/atykhonov/google-translate/issues/137#issuecomment-723938431
  (defun google-translate--search-tkk ()
	"Search TKK."
	(list 430675 2721866130))

  ;; ================================================================================
  ;; real-auto-save
  ;; ================================================================================
  ;; 自動で保存をしてくれる
  ;; lspが走っている場合、保存のたびに構文チェックが毎回走り重くなることがあるので自動保存がほしいモード
  (use-package real-auto-save
	:ensure t)

  (add-hook 'emacs-lisp-mode-hook 'real-auto-save-mode)

  (setq real-auto-save-interval 1) ;; １秒刻みで自動保存を行う


  ;; ================================================================================
  ;; evil-numvers
  ;; ================================================================================
  (use-package evil-numbers
	:ensure t)

  (global-set-key (kbd "M-+") 'evil-numbers/inc-at-pt)
  (global-set-key (kbd "M-*") 'evil-numbers/dec-at-pt)

  ;; ================================================================================
  ;; goto-line-preview
  ;; ================================================================================
  ;; goto-lineを強化することができる。

  (use-package goto-line-preview
	:ensure t)

  (global-set-key [remap goto-line] 'goto-line-preview)



  ;; ================================================================================
  ;; migemo
  ;; ================================================================================


  (use-package migemo
	:ensure t)

  ;; cmigemo(default)
  (setq migemo-command "cmigemo")
  (setq migemo-options '("-q" "--emacs"))

  ;; Set your installed path
  (setq migemo-dictionary "/usr/share/migemo/utf-8/migemo-dict")

  (setq migemo-user-dictionary nil)
  (setq migemo-regex-dictionary nil)
  (setq migemo-coding-system 'utf-8-unix)
  (migemo-init)


  ;; ================================================================================
  ;; avy-migemo
  ;; ================================================================================

  (use-package avy-migemo
	:ensure t)
  ;; `avy-migemo-mode' overrides avy's predefined functions using `advice-add'.
  (avy-migemo-mode 1)
  (global-set-key (kbd "M-g m m") 'avy-migemo-mode)
  (setq avy-timeout-seconds nil)
  (global-set-key (kbd "C-M-;") 'avy-migemo-goto-char-timer)

  ;; (use-package avy
  ;; 	:ensure t)

  ;; avy-goto-word-0を１行に限定する関数
  ;; https://twitter.com/conao_3/status/1355069656466288643?s=20
  (defun avy-goto-word-0-back (arg)
	(interactive "P")
	(avy-with avy-goto-word-0
	  (avy-goto-word-0 arg (point) (line-end-position))))

  (defun avy-goto-word-0-forward (arg)
	(interactive "P")
	(avy-with avy-goto-word-0
	  (avy-goto-word-0 arg (line-beginning-position) (point))))


  (global-set-key (kbd "<henkan>") 'avy-goto-word-0-back)
  (global-set-key (kbd "<muhenkan>") 'avy-goto-word-0-forward)

  ;; avyで行移動のショートカットを追加（C-c j）
  (global-set-key (kbd "<hiragana-katakana>") 'avy-goto-line)




  ;; ================================================================================
  ;; eaf-historyやswipperでmozcが使えない問題を解消
  ;; ================================================================================
  ;; migemoを利用している
  (defun ytn-ivy-migemo-re-builder (str)
	(let* ((sep " \\|\\^\\|\\.\\|\\*")
           (splitted (--map (s-join "" it)
							(--partition-by (s-matches-p " \\|\\^\\|\\.\\|\\*" it)
											(s-split "" str t)))))
      (s-join "" (--map (cond ((s-equals? it " ") ".*?")
                              ((s-matches? sep it) it)
                              (t (migemo-get-pattern it)))
						splitted))))

  ;; swipperにmigemoがうまく動いていなかったので修正
  (setq ivy-re-builders-alist '((t . ivy--regex-plus)
								(eaf-open-browser-with-history . ytn-ivy-migemo-re-builder)
								(swiper . ytn-ivy-migemo-re-builder)
							    (ivy-switch-buffer . ytn-ivy-migemo-re-builder)
                                (counsel-ibuffer . ytn-ivy-migemo-re-builder)))



  (use-package vimrc-mode
	:ensure t)
  (add-to-list 'auto-mode-alist '("\\.vim\\(rc\\)?\\'" . vimrc-mode))

  ;; ================================================================================
  ;; quick-run
  ;; ================================================================================
  (use-package quickrun
	:ensure t)

  (global-set-key (kbd "<f5>") 'quickrun)
  (global-set-key (kbd "C-<f5>") 'quickrun-with-arg)
  (global-set-key (kbd "M-<f5>") 'quickrun-compile-only)


  (use-package nasm-mode
	:ensure t)
  (add-to-list 'auto-mode-alist '("\\.asm\\'" . nasm-mode))




  ;; ================================================================================
  ;; transparency
  ;; ================================================================================
  ;; from https://emacs.stackexchange.com/questions/44011/how-to-make-everything-except-the-text-transparent

  (setq transparency_level 0)
  (defun my:change_transparency ()
	"Toggles transparency of Emacs between 3 settings (none, mild, moderate)."
	(interactive)
	(if (equal transparency_level 0)
		(progn (set-frame-parameter (selected-frame) 'alpha '(90 . 85))
			   (setq transparency_level 1))
      (if (equal transparency_level 1)
		  (progn (set-frame-parameter (selected-frame) 'alpha '(50 . 85))
				 (setq transparency_level 2))
		(if (equal transparency_level 2)
			(progn (set-frame-parameter (selected-frame) 'alpha '(100 . 85))
				   (setq transparency_level 0)))
		)))

  (define-key global-map (kbd "C-c q") 'my:change_transparency)
  ;; ================================================================================
  ;; window-resize
  ;; ================================================================================
  ;; 
  (defun win-resize-top-or-bot ()
	"Figure out if the current window is on top, bottom or in the
middle"
	(let* ((win-edges (window-edges))
		   (this-window-y-min (nth 1 win-edges))
		   (this-window-y-max (nth 3 win-edges))
		   (fr-height (frame-height)))
      (cond
       ((eq 0 this-window-y-min) "top")
       ((eq (- fr-height 1) this-window-y-max) "bot")
       (t "mid"))))

  (defun win-resize-left-or-right ()
	"Figure out if the current window is to the left, right or in the middle"
	(let* ((win-edges (window-edges))
		   (this-window-x-min (nth 0 win-edges))
		   (this-window-x-max (nth 2 win-edges))
		   (fr-width (frame-width)))
      (cond
       ((eq 0 this-window-x-min) "left")
       ((eq (+ fr-width 4) this-window-x-max) "right")
       (t "mid"))))

  (defun win-resize-enlarge-horiz ()
	(interactive)
	(cond
	 ((equal "top" (win-resize-top-or-bot)) (enlarge-window -1))
	 ((equal "bot" (win-resize-top-or-bot)) (enlarge-window 1))
	 ((equal "mid" (win-resize-top-or-bot)) (enlarge-window -1))
	 (t (message "nil"))))

  (defun win-resize-minimize-horiz ()
	(interactive)
	(cond
	 ((equal "top" (win-resize-top-or-bot)) (enlarge-window 1))
	 ((equal "bot" (win-resize-top-or-bot)) (enlarge-window -1))
	 ((equal "mid" (win-resize-top-or-bot)) (enlarge-window 1))
	 (t (message "nil"))))

  (defun win-resize-enlarge-vert ()
	(interactive)
	(cond
	 ((equal "left" (win-resize-left-or-right)) (enlarge-window-horizontally -1))
	 ((equal "right" (win-resize-left-or-right)) (enlarge-window-horizontally 1))
	 ((equal "mid" (win-resize-left-or-right)) (enlarge-window-horizontally -1))))

  (defun win-resize-minimize-vert ()
	(interactive)
	(cond
	 ((equal "left" (win-resize-left-or-right)) (enlarge-window-horizontally 1))
	 ((equal "right" (win-resize-left-or-right)) (enlarge-window-horizontally -1))
	 ((equal "mid" (win-resize-left-or-right)) (enlarge-window-horizontally 1))))

  (global-set-key [C-M-down] 'win-resize-minimize-vert)
  (global-set-key [C-M-up] 'win-resize-enlarge-vert)
  (global-set-key [C-M-left] 'win-resize-minimize-horiz)
  (global-set-key [C-M-right] 'win-resize-enlarge-horiz)
  (global-set-key [C-M-up] 'win-resize-enlarge-horiz)
  (global-set-key [C-M-down] 'win-resize-minimize-horiz)
  (global-set-key [C-M-left] 'win-resize-enlarge-vert)
  (global-set-key [C-M-right] 'win-resize-minimize-vert)

  ;; ================================================================================
  ;; restart-emacs
  ;; ================================================================================
  ;; https://github.com/iqbalansari/restart-emacs
  (use-package restart-emacs
	:ensure t)

  ;; ================================================================================
  ;; all-the-icons-dired
  ;; ================================================================================
  ;; https://github.com/jtbm37/all-the-icons-dired
  (use-package all-the-icons-dired
	:ensure t)
  (add-hook 'dired-mode-hook 'all-the-icons-dired-mode)

 
  ;; ================================================================================
  ;; git-timemachine
  ;; ================================================================================
  ;; https://gitlab.com/pidu/git-timemachine/tree/8d675750e921a047707fcdc36d84f8439b19a907
  (use-package git-timemachine
	:ensure t
	:config
	(bind-key "C-c g" 'git-timemachine-toggle))


  ;; ================================================================================
  ;; nhexl-mode
  ;; ================================================================================
  ;;


  (use-package nhexl-mode
    :ensure t)

  ;; ================================================================================
  ;; deepl
  ;; ================================================================================
  ;;

  (defun my/trans-deepl (beg end)
    (interactive "r")
    (let ((str (buffer-substring beg end)))
      (browse-url
       (concat "https://www.deepl.com/translator#en/ja/" (url-hexify-string str)))))

  ;; begとendを外したらエラーになる理由を調べる
  (defun my/trans-deepl-killring ()
    (interactive)
    (let ((str (current-kill 0 t)))
      (browse-url
       (concat "https://www.deepl.com/translator#en/ja/" (url-hexify-string str)))))


  ;; ================================================================================
  ;; package-utils
  ;; ================================================================================
  ;;
  (use-package package-utils
    :ensure t)
  
  ;; ================================================================================
  ;;company-org-block
  ;; ================================================================================
  (use-package company-org-block
  :ensure t
  :custom
  (company-org-block-edit-style 'auto) ;; 'auto, 'prompt, or 'inline
  :hook ((org-mode . (lambda ()
                       (setq-local company-backends '(company-org-block))
                       (company-mode +1)))))

(org-babel-do-load-languages
 'org-babel-load-languages
 '((python . t)
   (C . t)
   (shell . t)))
  

  (setq org-latex-pdf-process
      '("xelatex -shell-escape -interaction nonstopmode -output-directory %o %f"
        "bibtex %b"
        "xelatex -shell-escape -interaction nontopmode -output-directory %o %f"
      "xelatex -shell-escape -interaction nonstopmode -output-directory %o %f"))

;;
;; Org mode
  ;;

  ;; https://texwiki.texjp.org/?Emacs%2FOrg%20mode 
  
(require 'ox-latex)
(add-to-list 'auto-mode-alist '("\\.org$" . org-mode))
(setq org-latex-default-class "bxjsarticle")
;; (setq org-latex-pdf-process '("latexmk -e '$latex=q/uplatex %S/' -e '$bibtex=q/upbibtex %B/' -e '$biber=q/biber --bblencoding=utf8 -u -U --output_safechars %B/' -e '$makeindex=q/upmendex -o %D %S/' -e '$dvipdf=q/dvipdfmx -o %D %S/' -norc -gg -pdfdvi %f"))
;(setq org-latex-pdf-process '("latexmk -e '$lualatex=q/lualatex %S/' -e '$bibtex=q/upbibtex %B/' -e '$biber=q/biber --bblencoding=utf8 -u -U --output_safechars %B/' -e '$makeindex=q/upmendex -o %D %S/' -norc -gg -pdflua %f"))
;; (setq org-export-in-background t)
(setq org-file-apps
      '(("pdf" . "evince %s")))


(setq org-latex-listings 'minted
      org-latex-packages-alist '(("" "minted"))
      org-latex-minted-options '(("breaklines" "true")
                                 ("breakanywhere" "true")
                                 ("mathescape")
                                 ("frame" "lines")
                                 ("bgcolor" "yellow!5")))

(add-to-list 'org-latex-classes
             '("bxjsarticle"
               "\\documentclass[autodetect-engine,dvi=dvipdfmx,11pt,a4paper,ja=standard]{bxjsarticle}
[NO-DEFAULT-PACKAGES]
\\usepackage{amsmath}
\\usepackage{newtxtext,newtxmath}
\\usepackage{graphicx}
\\usepackage{hyperref}
\\ifdefined\\kanjiskip
  \\usepackage{pxjahyper}
  \\hypersetup{colorlinks=true}
\\else
  \\ifdefined\\XeTeXversion
      \\hypersetup{colorlinks=true}
  \\else
    \\ifdefined\\directlua
      \\hypersetup{pdfencoding=auto,colorlinks=true}
    \\else
      \\hypersetup{unicode,colorlinks=true}
    \\fi
  \\fi
\\fi"
               ("\\section{%s}" . "\\section*{%s}")
               ("\\subsection{%s}" . "\\subsection*{%s}")
               ("\\subsubsection{%s}" . "\\subsubsection*{%s}")
               ("\\paragraph{%s}" . "\\paragraph*{%s}")
               ("\\subparagraph{%s}" . "\\subparagraph*{%s}")))

(add-to-list 'org-latex-classes
             '("jlreq"
               "\\documentclass[11pt,paper=a4]{jlreq}
[NO-DEFAULT-PACKAGES]
\\usepackage{amsmath}
\\usepackage{newtxtext,newtxmath}
\\ifdefined\\kanjiskip
  \\usepackage[dvipdfmx]{graphicx}
  \\usepackage[dvipdfmx]{hyperref}
  \\usepackage{pxjahyper}
  \\hypersetup{colorlinks=true}
\\else
  \\usepackage{graphicx}
  \\usepackage{hyperref}
  \\hypersetup{pdfencoding=auto,colorlinks=true}
\\fi"
               ("\\section{%s}" . "\\section*{%s}")
               ("\\subsection{%s}" . "\\subsection*{%s}")
               ("\\subsubsection{%s}" . "\\subsubsection*{%s}")
               ("\\paragraph{%s}" . "\\paragraph*{%s}")
               ("\\subparagraph{%s}" . "\\subparagraph*{%s}")))

(add-to-list 'org-latex-classes
             '("jlreq-tate"
               "\\documentclass[tate,11pt,paper=a4]{jlreq}
[NO-DEFAULT-PACKAGES]
\\usepackage{amsmath}
\\usepackage{newtxtext,newtxmath}
\\ifdefined\\kanjiskip
  \\usepackage[dvipdfmx]{graphicx}
  \\usepackage[dvipdfmx]{hyperref}
  \\usepackage{pxjahyper}
  \\hypersetup{colorlinks=true}
\\else
  \\usepackage{graphicx}
  \\usepackage{hyperref}
  \\hypersetup{pdfencoding=auto,colorlinks=true}
\\fi"
               ("\\section{%s}" . "\\section*{%s}")
               ("\\subsection{%s}" . "\\subsection*{%s}")
               ("\\subsubsection{%s}" . "\\subsubsection*{%s}")
               ("\\paragraph{%s}" . "\\paragraph*{%s}")
               ("\\subparagraph{%s}" . "\\subparagraph*{%s}")))


;; PATHを拾う
(when (require 'exec-path-from-shell nil t)
  (exec-path-from-shell-initialize))



  )
(setq gc-cons-threshold 100000000)
