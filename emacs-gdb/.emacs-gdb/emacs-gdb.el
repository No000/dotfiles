
(run-with-idle-timer 60.0 t #'garbage-collect)


(let (;; temporarily increase `gc-cons-threshold' when loading to speed up startup.
      (gc-cons-threshold most-positive-fixnum)
      ;; Empty to avoid analyzing files when loading remote files.
      (file-name-handler-alist nil))


  ()
  
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
  (global-hl-line-mode t)
  (require 'hl-line)


  (gdb)


  )
(setq gc-cons-threshold 100000000)
