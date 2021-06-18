(run-with-idle-timer 60.0 t #'garbage-collect)


(let (;; temporarily increase `gc-cons-threshold' when loading to speed up startup.
      (gc-cons-threshold most-positive-fixnum)
      ;; Empty to avoid analyzing files when loading remote files.
      (file-name-handler-alist nil))

  (define-key key-translation-map [?\C-h] [?\C-?]) ; helmで使えるように変更

  ;; 別のキーバイドにヘルプを割り当てる
  (define-key global-map (kbd "C-x ?") 'help-command)
  
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

  ;; barを出るようにする
  ;; (global-hl-line-mode t) 

  ;; 現状スクロールバーとメニューバーを使っていないため削除する。
  ;; 可能であればyaskrollのようなものに変更を行いたい。
  (tool-bar-mode -1)     ;ツールバーをなくす
  (menu-bar-mode -1)     ;メニューバーをなくす
;;; これはお好みで
  (scroll-bar-mode -1)   ;スクロールバーをなくす
  
  (setq auto-save-default nil)
  
  (setq make-backup-files nil)


  ;; idoの設定
  ;; C-sで前へ、C-rで後ろへ
  (require 'ido)
  (ido-mode t)
  (ido-everywhere t)


  ;; tab-bar-mode
  (tab-bar-mode t)
  ;; クリップボードと共有

  (cond (window-system
	 (setq x-select-enable-clipboard t)
	 ))

  ;; -------------------------------------------------------------------------------------------------
  ;; <方向キー>でウィンドウ間移動を可能にする
  ;; -------------------------------------------------------------------------------------------------
  ;; eafではではオーバーレイされているため、ace-windowのアルファベットを表示できない。よって、C-c <方向キー>でも移動できるようにしている。
  (global-set-key (kbd "C-c <left>")  'windmove-left)
  (global-set-key (kbd "C-c <right>") 'windmove-right)
  (global-set-key (kbd "C-c <up>")    'windmove-up)
  (global-set-key (kbd "C-c <down>")  'windmove-down)



  
  ;; GCを走らせないようにするためのカッコ（消すな）=====================================
  )
(setq gc-cons-threshold 100000000)
;; 
