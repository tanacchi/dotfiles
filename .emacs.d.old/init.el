;;x-1 ショートカット
(setq inhibit-splash-screen t)

;;色設定
(load-theme 'tango-dark t)
;;(load-theme 'tsdh-dark t)
;;(load-theme 'light-blue t)

;;行・列番号表示
(require 'linum)
(global-linum-mode t)
(set-face-attribute 'linum nil
                    :foreground "grey76"
                    :height 0.9)
(column-number-mode t)

;;日本語フォント設定
(set-fontset-font t 'japanese-jisx0208' "TakaoPGothic")
(add-to-list 'face-font-rescale-alist '(".*Takao P.*" . 0.70))

;;行間
(setq-default line-spacing 8)

;;ツールバー非表示
(tool-bar-mode -1)

;; "yes or no" の選択を "y or n" にする
(fset 'yes-or-no-p 'y-or-n-p)

;; スタートアップ非表示
(setq inhibit-startup-screen t)

;; scratchの初期メッセージ消去
(setq initial-scratch-message "")

;; スクロールバー非表示
(set-scroll-bar-mode nil)

;; タブをスペースで扱う
(setq-default indent-tabs-mode nil)

;; タブ幅
(custom-set-variables
 '(send-mail-function (quote mailclient-send-it))
 '(tab-width 4))

;; ミニバッファの履歴を保存する
(savehist-mode 1)

;; ミニバッファの履歴の保存数を増やす
(setq history-length 3000)

;; フレームの透明度
(set-frame-parameter (selected-frame) 'alpha '(1.0))

;; エラー音をならなくする
(setq ring-bell-function 'ignore)

;; 1行ずつスクロール
(setq scroll-conservatively 35
      scroll-margin 0
      scroll-step 1)
(setq comint-scroll-show-maximum-output t) ;; shell-mode

;; モードラインに行番号表示
(line-number-mode t)

;; 折り返しをしない
;; (setq-default truncate-lines t)
;; (setq-default truncate-partial-width-windows t)

;;file名の補完で大文字小文字を区別しない
(setq completion-ignore-case t)

;; モードラインの割合表示を総行数表示
(defvar my-lines-page-mode t)
(defvar my-mode-line-format)

(when my-lines-page-mode
  (setq my-mode-line-format "%d")
  (if size-indication-mode
      (setq my-mode-line-format (concat my-mode-line-format " of %%I")))
  (cond ((and (eq line-number-mode t) (eq column-number-mode t))
         (setq my-mode-line-format (concat my-mode-line-format " (%%l,%%c)")))
        ((eq line-number-mode t)
         (setq my-mode-line-format (concat my-mode-line-format " L%%l")))
        ((eq column-number-mode t)
         (setq my-mode-line-format (concat my-mode-line-format " C%%c"))))

  (setq mode-line-position
        '(:eval (format my-mode-line-format
                        (count-lines (point-max) (point-min))))))

;; 対応する括弧を光らせる
(show-paren-mode 1)

;;バックアップファイル・オートセーブファイル場所指定
(setq backup-directory-alist
      (cons (cons ".*" (expand-file-name "~/.emacs.d/backup"))
            backup-directory-alist))

(setq auto-save-file-name-transforms
      `((".*" "~/.emacs.d/auto-save-list/" t))
)

;; ediff config
;; ediff 時にフレームを使わない
(setq ediff-window-setup-function 'ediff-setup-windows-plain)

;; load-path で ~/.emacs.d とか書かなくてよくなる
(when load-file-name
  (setq user-emacs-directory (file-name-directory load-file-name)))
