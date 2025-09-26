;; Ubuntuでも実行可能を目指す
;; よってvtermはコメントアウト


(run-with-idle-timer 60.0 t #'garbage-collect)


(let (;; temporarily increase `gc-cons-threshold' when loading to speed up startup.
      (gc-cons-threshold most-positive-fixnum)
      ;; Empty to avoid analyzing files when loading remote files.
      (file-name-handler-alist nil))


  ()
  (require 'package)  ; package.elを有効化
  (setq package-archives
		'(("melpa" . "https://melpa.org/packages/")
          ("org" . "https://orgmode.org/elpa/")
          ("gnu" . "https://elpa.gnu.org/packages/")
	  ("nongnu" . "https://elpa.nongnu.org/nongnu/")))
  (package-initialize) ; インストール済みElispを読み込む

  (when (not (package-installed-p 'use-package))
	(package-refresh-contents)
	(package-install 'use-package))
  (setq use-package-enable-imenu-support t)
  (setq use-package-always-ensure t)
  (add-to-list 'load-path "~/.emacs.d/elpa/")
  (require 'use-package)
  (use-package bind-key)
  (use-package diminish
    :ensure t)
  (setq package-native-compile t)


  ;; .zshrc のPATHロード
  (let ((path (shell-command-to-string ". ~/.zshrc; echo -n $PATH")))
    (setenv "PATH" path)
    (setq exec-path
          (append
           (split-string-and-unquote path ":")
           exec-path)))
  (let ((path (shell-command-to-string ". ~/.bashrc; echo -n $PATH")))
    (setenv "PATH" path)
    (setq exec-path
          (append
           (split-string-and-unquote path ":")
           exec-path)))


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

  ;; 相対表示する
  ;; (setq display-line-numbers-type 'relative)
  
  (add-hook 'dired-mode-hook (lambda () (display-line-numbers-mode -1)))
  (add-hook 'vterm-mode-hook (lambda () (display-line-numbers-mode -1)))
  (add-hook 'undo-tree-visualizer-mode-hook (lambda () (display-line-numbers-mode -1)))
  (add-hook 'eat-mode-hook (lambda () (display-line-numbers-mode -1)))
  (add-hook 'xwidget-webkit-mode-hook (lambda () (display-line-numbers-mode -1)))

  ;; ================================================================================
  ;; 細かい設定
  ;; ================================================================================


  

  ;; 右クリックで選択領域をコピー
  (global-set-key (kbd "<mouse-3>") 'copy-region-as-kill)

  
  ;; カラム番号を表示
  (column-number-mode t)

  ;; 警告音の代わりに画面フラッシュ
  (setq visible-bell t)

  ;; スタートアップページを表示しない
  (setq inhibit-startup-message t)

  ;; 警告音もフラッシュも全て無効(警告音が完全に鳴らなくなるので注意)
  ;; (setq ring-bell-function 'ignore)

  ;; barを出るようにする
  (global-hl-line-mode t)
  (require 'hl-line)

  ;; 矢印キーでウィンドウ移動をできるようにする
  (windmove-default-keybindings)
  (global-set-key (kbd "M-<left>")  'windmove-left)
  (global-set-key (kbd "M-<right>") 'windmove-right)
  (global-set-key (kbd "M-<up>")    'windmove-up)
  (global-set-key (kbd "M-<down>")  'windmove-down)

  (xterm-mouse-mode t)
  ;; 現状スクロールバーとメニューバーを使っていないため削除する。
  ;; 可能であればyaskrollのようなものに変更を行いたい。
  (tool-bar-mode -1)     ;ツールバーをなくす


  ;; (menu-bar-mode -1)     ;メニューバーをなくす
;;; これはお好みで
  (scroll-bar-mode -1)   ;スクロールバーをなくす

  ;; c-hとbackspaceで上書き
  (define-key key-translation-map [?\C-h] [?\C-?]) ; helmで使えるように変更

  ;; 別のキーバイドにヘルプを割り当てる
  (define-key global-map (kbd "C-x ?") 'help-command)

  ;; list-buffers -> ibuffer
  (global-set-key [remap list-buffers] 'ibuffer)

  ;; "C-x j"でウィンドウを切り替える
  (define-key global-map (kbd "C-x j") 'other-window)

  (electric-pair-mode 1)					; かぎかっこを対応させる

  ;; マウスのスクロール
  (setq mouse-wheel-scroll-amount '(0.04))
  (setq mouse-wheel-progressive-speed nil)
  ;; 右クリックで選択領域をコピー
  (global-set-key (kbd "<mouse-3>") 'copy-region-as-kill)

  ;; ripgrep
  (setq grep-command "rg -nS --no-heading "
      grep-use-null-device nil)

  ;; C-v M-vでスクロールした場合に残す量
  (setq next-screen-context-lines 10)
  ;; カーソル位置維持
  (setq scroll-preserve-screen-position t)
  ;; vi-like line insertion
  ;; vim のoコマンドのような挙動に修正
  
  (global-set-key (kbd "C-c o") 'facemenu-keymap)
  (global-set-key (kbd "C-S-o") (lambda () (interactive)(end-of-line)(newline-and-indent)))
  (global-set-key (kbd "M-o") (lambda () (interactive)(previous-line)(end-of-line)(newline-and-indent)))
  (bind-key* "M-h" 'backward-kill-word)

  ;; 時間の表示
  ;; 以下の書式に従ってモードラインに日付・時刻を表示する
  (setq display-time-string-forms
        '((format "%s/%s/%s(%s) %s:%s" year month day dayname 24-hours minutes)
          load
          (if mail " Mail" "")))


  ;; 画面拡大ショートカット割当
  (define-key global-map (kbd "C-<f11>") 'toggle-frame-maximized)
  ;; バッテリー情報を表示
  ;; (display-battery-mode 1)

  ;; c-mode indent
  (setq-default c-basic-offset 8     ;;基本インデント量4
    			tab-width 8          ;;タブ幅4
                )

  ;; (defun bsd ()
  ;;        (c-set-style "bsd")
  ;;        (setq indent-tabs-mode t)
  ;;        ;; Use C-c C-s at points of source code so see which
  ;;        ;; c-set-offset is in effect for this situation
  ;;        (c-set-offset 'defun-block-intro 8)
  ;;        (c-set-offset 'statement-block-intro 8)
  ;;        (c-set-offset 'statement-case-intro 8)
  ;;        (c-set-offset 'substatement-open 4)
  ;;        (c-set-offset 'substatement 8)
  ;;        (c-set-offset 'arglist-cont-nonempty 4)
  ;;        (c-set-offset 'inclass 8)
  ;;        (c-set-offset 'knr-argdecl-intro 8)
  ;;        )

  (use-package clang-format
    :ensure t)

  (add-hook 'c-mode-common-hook (lambda ()
                                  (c-set-style "bsd")
                                  (setq indent-tabs-mode t)
                                  ;; Use C-c C-s at points of source code so see which
                                  ;; c-set-offset is in effect for this situation
                                  (c-set-offset 'defun-block-intro 8)
                                  (c-set-offset 'statement-block-intro 8)
                                  (c-set-offset 'statement-case-intro 8)
                                  (c-set-offset 'substatement-open 4)
                                  (c-set-offset 'substatement 8)
                                  (c-set-offset 'arglist-cont-nonempty 4)
                                  (c-set-offset 'inclass 8)
                                  (c-set-offset 'knr-argdecl-intro 8)))
  ;; (add-hook 'c-mode-common-hook 'bsd)
  ;; (add-hook 'c++-mode-common-hook 'bsd)

  (defun my-bsd () (interactive)
         (c-set-style "bsd")
         (setq indent-tabs-mode t)
         (c-set-offset 'defun-block-intro 8)
         (c-set-offset 'statement-block-intro 8)
         (c-set-offset 'statement-case-intro 8)
         (c-set-offset 'substatement-open 4)
         (c-set-offset 'substatement 8)
         (c-set-offset 'arglist-cont-nonempty 4)
         (c-set-offset 'inclass 8)
         (c-set-offset 'knr-argdecl-intro 8)
         )

  (add-hook 'c-mode-common-hook 'my-bsd)

  ;; (defun bsd ()
  ;;        (c-set-style "bsd")
  ;;        (setq indent-tabs-mode t)
  ;;        ;; Use C-c C-s at points of source code so see which
  ;;        ;; c-set-offset is in effect for this situation
  ;;        (c-set-offset 'defun-block-intro 8)
  ;;        (c-set-offset 'statement-block-intro 8)
  ;;        (c-set-offset 'statement-case-intro 8)
  ;;        (c-set-offset 'substatement-open 4)
  ;;        (c-set-offset 'substatement 8)
  ;;        (c-set-offset 'arglist-cont-nonempty 4)
  ;;        (c-set-offset 'inclass 8)
  ;;        (c-set-offset 'knr-argdecl-intro 8)
  ;;        )

  (use-package clang-format
    :ensure t)

  (add-hook 'c-mode-common-hook (lambda ()
                                  (c-set-style "bsd")
                                  (setq indent-tabs-mode t)
                                  ;; Use C-c C-s at points of source code so see which
                                  ;; c-set-offset is in effect for this situation
                                  (c-set-offset 'defun-block-intro 8)
                                  (c-set-offset 'statement-block-intro 8)
                                  (c-set-offset 'statement-case-intro 8)
                                  (c-set-offset 'substatement-open 4)
                                  (c-set-offset 'substatement 8)
                                  (c-set-offset 'arglist-cont-nonempty 4)
                                  (c-set-offset 'inclass 8)
                                  (c-set-offset 'knr-argdecl-intro 8)))
  ;; (add-hook 'c-mode-common-hook 'bsd)
  ;; (add-hook 'c++-mode-common-hook 'bsd)

  (when (equal system-type 'darwin)
    (if (not (string-match "\\(^\\|:\\)/usr/local/bin\\($\\|\\:\\)" (getenv "PATH")))
        (setenv "PATH" (concat '"/usr/local/bin:" (getenv "PATH"))))
    (if (not (member "/usr/local/bin" exec-path))
        (setq exec-path (cons "/usr/local/bin" exec-path)))
    (setenv "PATH" (concat '"/usr/local/opt/llvm/bin/:" (getenv "PATH")))
    )


  (tab-bar-mode t)

  ;; ================================================================================
  ;; async
  ;; ================================================================================

  (use-package async
	:ensure t)
  (autoload 'dired-async-mode "dired-async.el" nil t) ;これはhelmで効果を発揮するらしいけど、ivyだとどうなんだろ。
  (dired-async-mode 1)

  (async-bytecomp-package-mode 1)			;非同期でパッケージのコンパイルを行う

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
  (add-to-load-path "elisp" "conf")

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
  ;; (setq all-the-icons-mode-icon-alist
  ;;       `(,@all-the-icons-mode-icon-alist

  ;;   	  (twittering-mode all-the-icons-faicon "twitter" :v-adjust 0.0 :face all-the-icons-blue)
  ;;         ))



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
    :ensure t
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

  (setq mozc-candidate-style 'echo-area)


  
  (prefer-coding-system 'utf-8)

  ;; C-n,C-pを追加
  (defun advice:mozc-key-event-with-ctrl-key--with-ctrl (r)
    (cond ((and (not (null (cdr r))) (eq (cadr r) 'control) (null (cddr r)))
           (pcase (car r)               ;case からpcaseに変更(最新だと動かった)
             (102 r) ; C-f
             (98 r) ; C-b
             (110 '(down)) ; C-n
             (112 '(up))  ; C-p
             (t r)
             ))
          (t r)))

  (advice-add 'mozc-key-event-to-key-and-modifiers :filter-return 'advice:mozc-key-event-with-ctrl-key--with-ctrl)
  ;; (advice-remove 'mozc-key-event-to-key-and-modifiers 'mozc-key-event-with-ctrl-key)


  (use-package nerd-icons
    :ensure t
    )


  (use-package eat
    :ensure t)
  ;; For `eat-eshell-mode'.
  (add-hook 'eshell-load-hook #'eat-eshell-mode)

  ;; For `eat-eshell-visual-command-mode'.
  (add-hook 'eshell-load-hook #'eat-eshell-visual-command-mode)
  
  ;; ================================================================================
  ;; doom-thema & doom-modeline
  ;; ================================================================================


  ;;https://github.com/hlissner/emacs-doom-themes
  (use-package doom-themes
    :ensure t
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
    (load-theme 'doom-Iosvkem t)

    ;; ----------------------------------------------------------------------
    ;; ----------------------------------------------------------------------
    (doom-themes-neotree-config)
    (doom-themes-org-config))
  (setq doom-modeline-height 30)
  (setq org-todo-keyword-faces
    	'(("WAIT" . (:foreground "#6272a4":weight bold))
          ("NEXT"   . (:foreground "#f1fa8c" :weight bold))
          ("CARRY/O" . (:foreground "#6272a4" :background "#373844" :weight bold))))


  (setq org-todo-keyword-faces
    	'(("WAIT" . (:foreground "#6272a4":weight bold))
          ("NEXT"   . (:foreground "#f1fa8c" :weight bold))
          ("CARRY/O" . (:foreground "#6272a4" :background "#373844" :weight bold))))


  ;; https://github.com/seagle0128/doom-modeline
  ;; (use-package doom-modeline
  ;;   :ensure t
  ;; 	:custom
  ;;   (setq doom-modeline-buffer-file-name-style 'auto)
  ;; 	(doom-modeline-buffer-file-name-style 'truncate-with-project)
  ;; 	;; (doom-modeline-icon t)
  ;;   (doom-modeline-icon (display-graphic-p)) ;GUIかの変数から拾わせる
  ;; 	(doom-modeline-major-mode-icon t)
  ;;   (doom-modeline-major-mode-color-icon t)
  ;;   (doom-modeline-unicode-fallback t)
  ;; 	(doom-modeline-minor-modes nil)     ;うっとおしい
  ;;   ;; (doom-modeline-mu4e t)
  ;;   (doom-modeline-indent-info t)
  ;;   (doom-modeline-display-default-persp-name t)
  ;;   (doom-modeline-time-icon nil)



  ;;   :init (doom-modeline-mode 1)
  ;; 	:config
  ;; 	(line-number-mode 0)
  ;; 	(column-number-mode 0)
  ;; 	)

  ;; ================================================================================
  ;; dashboard
  ;; ================================================================================
  ;; プロジェクト管理パッケージ
  (use-package projectile
    :ensure t)
  (projectile-mode +1)
  (define-key projectile-mode-map (kbd "s-p") 'projectile-command-map)
  (define-key projectile-mode-map (kbd "C-c C-p") 'projectile-command-map) ;jupyterを使うために退避

  (use-package dashboard
    :ensure t
	:custom
    (dashboard-page-separator "\n\n\n")
    (dashboard-center-content t)
	(dashboard-items '((recents . 10)
					   (projects . 5)
					   (bookmarks . 5)))
	:config
    (dashboard-setup-startup-hook)
    (setq dashboard-set-heading-icons t)
    (setq dashboard-set-file-icons t)
    )

  (setq dashboard-set-navigator t)

  (if (< (length command-line-args) 2)
      (setq initial-buffer-choice (lambda () (get-buffer "*dashboard*")))) ; コマンドラインから起動したときにdashboardを起動しないようにする



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

  (if (< (length command-line-args) 2)
      (setq initial-buffer-choice (lambda () (get-buffer "*dashboard*")))) ; コマンドラインから起動したときにdashboardを起動しないようにする

  ;; ================================================================================
  ;; undotree
  ;; ================================================================================
  (use-package undo-tree
    :ensure t)
  (setq undo-tree-auto-save-history nil) ; 勝手に保存するファイルを無効化する
  (when (require 'undo-tree nil t)
	(global-undo-tree-mode))

  
  ;; ================================================================================
  ;; Vertico
  ;; ================================================================================
  (use-package vertico
    :ensure t
    :custom
    ;; (vertico-scroll-margin 0) ;; Different scroll margin
    (vertico-count 10) ;; Show more candidates
    (vertico-resize t) ;; Grow and shrink the Vertico minibuffer
    (vertico-cycle t) ;; Enable cycling for `vertico-next/previous'
    :init
    (vertico-mode))

  ;; Persist history over Emacs restarts. Vertico sorts by history position.
  (use-package savehist
    :init
    (savehist-mode))

  ;; Emacs minibuffer configurations.
  (use-package emacs
    :custom
    ;; Enable context menu. `vertico-multiform-mode' adds a menu in the minibuffer
    ;; to switch display modes.
    (context-menu-mode t)
    ;; Support opening new minibuffers from inside existing minibuffers.
    (enable-recursive-minibuffers t)
    ;; Hide commands in M-x which do not work in the current mode.  Vertico
    ;; commands are hidden in normal buffers. This setting is useful beyond
    ;; Vertico.
    (read-extended-command-predicate #'command-completion-default-include-p)
    ;; Do not allow the cursor in the minibuffer prompt
    (minibuffer-prompt-properties
     '(read-only t cursor-intangible t face minibuffer-prompt)))

  ;; ================================================================================
  ;; orderless
  ;; ================================================================================
  (use-package orderless
    :ensure t
      :custom
      (completion-styles '(orderless basic))
      (completion-category-overrides '((file (styles basic partial-completion)))))

  ;; ------------------------------------------------------------------------company
  (use-package company
    :ensure t)
  (global-company-mode) ; 全バッファで有効にする
  ;; (setq company-auto-expand nil) ;; 1個目を自動的に補完
  (setq company-idle-delay 0.5) ; デフォルトは0.5
  (setq company-minimum-prefix-length 2) ; デフォルトは4
  (setq company-selection-wrap-around t) ; 候補の一番下でさらに下に行こうとすると一番上に戻る
  (setq company-auto-complete nil)
  (if tramp-mode
      (setq company-clang-modes nil))

  (add-hook 'gdb-mode-hook (lambda () (company-mode -1)))
  (global-set-key (kbd "M-/") 'company-capf)
  (define-key company-active-map (kbd "M-n") nil)
  (define-key company-active-map (kbd "M-p") nil)
  (define-key company-active-map (kbd "C-n") nil)
  (define-key company-active-map (kbd "C-p") nil)
  (define-key company-active-map (kbd "C-n") 'company-select-next)
  (define-key company-active-map (kbd "C-p") 'company-select-previous)
  (define-key company-active-map (kbd "C-h") nil)

  
  ;; ================================================================================
  ;; rustic
  ;; ================================================================================

  (use-package poly-markdown
    :ensure t)
  
  ;; cargoのPATHの設定
  (add-to-list 'exec-path (expand-file-name "~/.cargo/bin/"))
  (use-package rustic
	:ensure t
	:config
	(setq rustic-lsp-client 'eglot)
	:custom
	  (rustic-analyzer-command '("rustup" "run" "stable" "rust-analyzer"))
	  )
  ;; (add-hook 'eglot--managed-mode-hook (lambda () (flymake-mode -1)))
  ;; 本当にwithout switchしているわけではなく前のウィンドウにフォーカスを戻すだけ
  (defun pop-to-buffer-without-switch (buffer-or-name &optional action norecord)
	(pop-to-buffer buffer-or-name action norecord)
	(other-window -1)
	)
  
  ;; ===========================================================================================
  ;; eglot
  ;; ===========================================================================================
  (use-package eglot
    :ensure t
    :hook
    (c-mode . eglot-ensure)
    (rustic-mode . eglot-ensure)
    (c++-mode . eglot-ensure)
    :bind (("M-t" . xref-find-definitions)
           ("M-r" . xref-find-references)
           ("C-t" . xref-go-back)))

  (with-eval-after-load 'eglot
    (add-to-list 'eglot-server-programs
                 '((c-mode c++-mode cc-mode)
                   . ("clangd"
                      "-j=8"
                      "--log=error"
                      "--malloc-trim"
                      "--background-index"
                      "--clang-tidy"
                      "--cross-file-rename"
                      "--completion-style=detailed"
                      "--pch-storage=memory"
                      "--header-insertion=never"
                      "--header-insertion-decorators=0"))))

  ;; ===========================================================================================
  ;; gdb
  ;; ===========================================================================================
;;; GDB 関連
;;; 有用なバッファを開くモード
  (setq gdb-many-windows t)

;;; 変数の上にマウスカーソルを置くと値を表示
  (add-hook 'gdb-mode-hook '(lambda () (gud-tooltip-mode t)))

;;; I/O バッファを表示
  (setq gdb-use-separate-io-buffer t)
;;; t にすると mini buffer に値が表示される
  (defun my-gdbmi-bnf-target-stream-output (c-string)
    "Change behavior for GDB/MI targe the target-stream-output so that it is displayed to the console."
    (gdb-console c-string))

  (advice-add 'gdb-display-memory-buffer :around 'gdb-display-memory-buffer-custom)
  (advice-add 'gdbmi-bnf-target-stream-output :override 'my-gdbmi-bnf-target-stream-output)

  ;; ===========================================================================================
  ;; yasnippet
  ;; ===========================================================================================

  (use-package yasnippet :ensure t
	:diminish
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
    )
  ;; -------------------------------------------------------------------------------------------------
  ;; yasnippet-snippets
  ;; -------------------------------------------------------------------------------------------------
  ;; yasnippetの例がいっぱい入っているやつ
  (use-package yasnippet-snippets :ensure t) ;; mainのdirsは自動設定

  ;; -------------------------------------------------------------------------------------------------
  ;; モダンな補完機能
  (use-package company-box
    :ensure t
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
  ;; whichkey
  ;; -------------------------------------------------------------------------------------------------
  ;; キーマップのチートシート
  ;; which-key-show-mapで表示することができる。
  (use-package which-key
    :ensure t
	:diminish which-key-mode
	:hook (after-init . which-key-mode))


  ;; ================================================================================
  ;; highlight-indent-guides
  ;; ================================================================================
  ;; https://github.com/DarthFennec/highlight-indent-guides
  (use-package highlight-indent-guides
    :ensure t
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
    ;; (magit-todos-mode)
	)


  ;; https://github.com/emacs-pe/docker-tramp.el#:~:text=%E3%83%88%E3%83%A9%E3%83%B3%E3%83%97%E3%81%AF%E3%83%AA%E3%83%A2%E3%83%BC%E3%83%88%E3%82%92%E5%B0%8A%E9%87%8D%E3%81%97%E3%81%BE%E3%81%9B%E3%82%93PATH
  (require 'tramp)
  ;; (add-to-list 'tramp-remote-path 'tramp-own-remote-path)
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
  ;; git-gutter
  ;; ================================================================================
  ;; https://github.com/emacsorphanage/git-gutter
  ;; https://qiita.com/Ladicle/items/feb5f9dce9adf89652cf#%E5%A4%89%E6%9B%B4%E7%AF%84%E5%9B%B2%E3%81%A8%E6%93%8D%E4%BD%9C%E3%82%92%E5%8F%AF%E8%A6%96%E5%8C%96----git-gutter
  ;; git diffコマンドを活用した変更箇所の可視化

  (use-package git-gutter
    :ensure t
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
  ;; real-auto-save
  ;; ================================================================================
  ;; 自動で保存をしてくれる
  ;; lspが走っている場合、保存のたびに構文チェックが毎回走り重くなることがあるので自動保存がほしいモード
  (use-package real-auto-save
	:ensure t)

  (add-hook 'emacs-lisp-mode-hook 'real-auto-save-mode)

  (setq real-auto-save-interval 1) ;; １秒刻みで自動保存を行う


  ;; ================================================================================
  ;; goto-line-preview
  ;; ================================================================================
  ;; goto-lineを強化することができる。

  (use-package goto-line-preview
	:ensure t)

  (global-set-key [remap goto-line] 'goto-line-preview)


  (use-package nasm-mode
	:ensure t)
  (add-to-list 'auto-mode-alist '("\\.asm\\'" . nasm-mode))

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

  ;; なぜあるか不明
  ;; PATHを拾う
  (when (require 'exec-path-from-shell nil t)
    (exec-path-from-shell-initialize))

  ;; ================================================================================
  ;; volatile-hights
  ;; ================================================================================
  ;;
  (use-package volatile-highlights
    :ensure t
    :diminish
    :hook
    (after-init . volatile-highlights-mode)
    :custom-face
    (vhl/default-face ((nil (:foreground "#FF3333" :background "#FFCDCD")))))


  ;; ================================================================================
  ;; mlscroll
  ;; ================================================================================
  (use-package mlscroll
    :ensure t
    :config
                                        ; (setq mlscroll-shortfun-min-width 11) ;truncate which-func, for default mode-line-format's
    (mlscroll-mode 1))


  ;; editorconfig
  (use-package editorconfig
    :ensure t
    :config
    (editorconfig-mode 1))

  ;; https://github.com/10sr/editorconfig-generate-el/tree/47a31f928f46d2a0188db8e2cffa5d6354a81573
  (use-package editorconfig-generate
    :ensure t)

  (use-package editorconfig-custom-majormode
    :ensure t
    :hook
    (editorconfig-custom-hooks . editorconfig-custom-majormode))


  (winner-mode)
  (global-set-key (kbd "C-c <prior>") 'winner-undo)
  (global-set-key (kbd "C-c q") 'winner-undo)
  (global-set-key (kbd "C-c <next>") 'winner-redo)

  (use-package sr-speedbar
    :ensure t
    :bind
    ("C-c t" . sr-speedbar-toggle)
    )


  (use-package plantuml-mode
    :ensure t
    :config
    (setq plantuml-executable-path "/usr/bin/plantuml")
    (setq plantuml-default-exec-mode 'executable)
    (setq plantuml-output-type "png")
    )

  ;; (use-package breadcrumb
  ;;   :ensure t
  ;;   :custom
  ;;   (breadcrumb-mode t))

  ;;================================================================================
  ;; dynamic module settings at following
  ;; ===============================================================================
  
  ;; ================================================================================
  ;; vterm
  ;; ================================================================================
  ;; https://github.com/akermu/emacs-libvterm

  (use-package vterm
    :ensure t
	:bind
	("<f9>" . vterm-toggle)
	:config
	;; (setq vterm-keymap-exceptions . '("C-x"))
	(setq vterm-shell "/usr/bin/zsh")	; vtermで使用するshellを指定
 	(define-key vterm-mode-map (kbd "C-x") nil)
	(setq vterm-max-scrollback 10000)
	(setq vterm-buffer-name-string "vterm: %s")
    (setq-default vterm-keymap-exceptions '("C-c" "C-x"))
    (setq vterm-keymap-exceptions '("C-c" "C-x"))
	)

  (use-package multi-vterm :ensure t)

  ;; ================================================================================
  ;; tree-sitter-mode
  ;; ================================================================================
  ;; (setq treesit-language-source-alist
  ;;  '((bash "https://github.com/tree-sitter/tree-sitter-bash")
  ;;    (cmake "https://github.com/uyha/tree-sitter-cmake")
  ;;    (css "https://github.com/tree-sitter/tree-sitter-css")
  ;;    (elisp "https://github.com/Wilfred/tree-sitter-elisp")
  ;;    (go "https://github.com/tree-sitter/tree-sitter-go")
  ;;    (html "https://github.com/tree-sitter/tree-sitter-html")
  ;;    (javascript "https://github.com/tree-sitter/tree-sitter-javascript" "master" "src")
  ;;    (json "https://github.com/tree-sitter/tree-sitter-json")
  ;;    (make "https://github.com/alemuller/tree-sitter-make")
  ;;    (markdown "https://github.com/ikatyang/tree-sitter-markdown")
  ;;    (python "https://github.com/tree-sitter/tree-sitter-python")
  ;;    (toml "https://github.com/tree-sitter/tree-sitter-toml")
  ;;    (tsx "https://github.com/tree-sitter/tree-sitter-typescript" "master" "tsx/src")
  ;;    (typescript "https://github.com/tree-sitter/tree-sitter-typescript" "master" "typescript/src")
  ;;    (yaml "https://github.com/ikatyang/tree-sitter-yaml")))

  ;; (mapc #'treesit-install-language-grammar (mapcar #'car treesit-language-source-alist))

  ;; (use-package treesit
  ;;   :config
  ;;   (setq treesit-font-lock-level 4))
  
  (use-package tree-sitter
    :ensure t)

  (use-package tree-sitter-langs
    :ensure t)

  (global-tree-sitter-mode)

  
  (add-hook 'tree-sitter-after-on-hook #'tree-sitter-hl-mode)
  )
(setq gc-cons-threshold 100000000)
