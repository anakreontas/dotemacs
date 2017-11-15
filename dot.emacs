(defun transpose-buffers (arg)
  "Transpose the buffers shown in two windows."
  (interactive "p")
  (let ((selector (if (>= arg 0) 'next-window 'previous-window)))
    (while (/= arg 0)
      (let ((this-win (window-buffer))
            (next-win (window-buffer (funcall selector))))
        (set-window-buffer (selected-window) next-win)
        (set-window-buffer (funcall selector) this-win)
        (select-window (funcall selector)))
      (setq arg (if (plusp arg) (1- arg) (1+ arg))))))


(defun eos/turn-off-flyspell ()
  (interactive)
  (flyspell-mode -1))

(defun eos/add-watchwords ()
  "Highlight FIXME, TODO, and NOTE"
  (font-lock-add-keywords
   nil '(("\\<\\(TODO\\(?:(.*)\\)?:?\\)\\>"  1 'warning prepend)
         ("\\<\\(FIXME\\(?:(.*)\\)?:?\\)\\>" 1 'error prepend)
         ("\\<\\(NOTE\\(?:(.*)\\)?:?\\)\\>"  1 'warning prepend))))


(defun eos/dired-mode-hook ()
  (setq-local truncate-lines t))
(setq eos/hl-line-enabled t)

(defun eos/turn-on-hl-line ()
  (interactive)
  (when eos/hl-line-enabled
    (hl-line-mode 1)))

(defun eos/turn-off-hl-line ()
  (interactive)
  (hl-line-mode -1))

(defun eos/turn-off-autofill ()
  (interactive)
  (auto-fill-mode -1))

(defun copy-to-clipboard ()
  (interactive)
  (if (display-graphic-p)
      (progn
        (message "Yanked region to x-clipboard!")
        (call-interactively 'clipboard-kill-ring-save)
        )
    (if (region-active-p)
        (progn
          (shell-command-on-region (region-beginning) (region-end) "xsel -i -b")
          (message "Yanked region to clipboard!")
          (deactivate-mark))
      (message "No region active; can't yank to clipboard!")))
  )

(defun paste-from-clipboard ()
  (interactive)
  (if (display-graphic-p)
      (progn
        (clipboard-yank)
        (message "graphics active")
        )
    (insert (shell-command-to-string "xsel -o -b"))
    )
  )

(defun rl-save-and-LaTeX ()
  "Save and LaTeX `TeX-master-file' (without querying the user).
Any files \\input by `TeX-master-file' are also saved without prompting."
  (interactive)
  (let (TeX-save-query)                    ;the following will save without prompting
    (TeX-save-document (TeX-master-file))) ;save master document and its files
  (TeX-command "LaTeX" 'TeX-master-file))  ;LaTeX master document

(set-charset-priority 'unicode)
(set-default-coding-systems 'utf-8)
(set-terminal-coding-system 'utf-8)
(set-keyboard-coding-system 'utf-8)
(set-selection-coding-system 'utf-8)
(prefer-coding-system 'utf-8)

(when (executable-find "aspell")
  (progn (setq ispell-program-name (executable-find "aspell")
               ispell-extra-args  (list "--sug-mode=fast" ;; ultra|fast|normal|bad-spellers
                                        "--lang=en_US"
                                        "--ignore=4")
               ispell-dictionary "british")
         (add-to-list 'ispell-skip-region-alist '("[^\000-\377]+"))
         (add-to-list 'ispell-skip-region-alist '(":\\(PROPERTIES\\|LOGBOOK\\):" . ":END:"))
         (add-to-list 'ispell-skip-region-alist '("#\\+BEGIN_SRC" . "#\\+END_SRC"))
         (add-to-list 'ispell-skip-region-alist '("#\\+BEGIN_EXAMPLE" . "#\\+END_EXAMPLE"))))

(setq user-full-name "Anakreontas Mentis"
      user-mail-address "anakreonmejdi@gmail.com"
      default-process-coding-system '(utf-8-unix . utf-8-unix)
      message-log-max 4000
      idle-update-delay 2
      gnutls-min-prime-bits 4096
      ring-bell-function (lambda ())
      inhibit-startup-screen t
      make-pointer-invisible t
      diff-switches "-u"
      desktop-restore-eager 10
      desktop-files-not-to-save "\\(^/[^/:]*:\\|(ftp)$\\|KILL\\)"
      desktop-restore-frames nil
      desktop-auto-save-timeout 10
      delete-auto-save-files t
      auto-save-file-name-transforms '((".*" "~/.emacs_backups/" t))
      delete-old-versions t
      kill-do-not-save-duplicates t
      switch-to-buffer-preserve-window-point t
      visible-bell t
      reftex-plug-into-auctex t
      display-time-world-list '(("UTC" "UTC")
                                ("Europe/London" "London")
                                ("Europe/Paris" "Paris")
                                ("Europe/Athens" "Athens")
                                ("Australia/Sydney" "Sydney"))
      electric-pair-preserve-balance t
      electric-pair-delete-adjacent-pairs t
      electric-pair-open-newline-between-pairs nil
      comint-scroll-to-bottom-on-output t
      comint-scroll-show-maximum-output t
      comint-input-ignoredups t
      comint-completiton-addsuffix t
      comint-prompt-regexp t)

(setq-default fill-column 80
              default-tab-width 2
              indent-tabs-mode nil
              save-place t
              backup-directory-alist '((".*" . "~/.emacs_backups"))
              imenu-auto-rescan t)

(defalias 'yes-or-no-p 'y-or-n-p)
(when (functionp 'menu-bar-mode)        (menu-bar-mode -1))
(when (functionp 'set-scroll-bar-mode)  (set-scroll-bar-mode 'nil))
(when (functionp 'mouse-wheel-mode)     (mouse-wheel-mode -1))
(when (functionp 'tooltip-mode)         (tooltip-mode -1))
(when (functionp 'tool-bar-mode)        (tool-bar-mode -1))
(when (functionp 'blink-cursor-mode)    (blink-cursor-mode -1))
;; Create the directory for backups if it doesn't exist
(when (not (file-exists-p "~/.emacs_backups")) (make-directory "~/.emacs_backups"))

(global-set-key (kbd "<C-tab>")    #'other-window)
(global-set-key (kbd "C-x k")      #'kill-this-buffer)
(global-set-key (kbd "<backtab>")  #'transpose-buffers)
(global-set-key (kbd "C-<return>") #'modalka-mode)
(global-set-key (kbd "<f8>")       #'copy-to-clipboard)
(global-set-key (kbd "<f9>")       #'paste-from-clipboard)
(global-set-key (kbd "M-;")        #'comment-dwim-2) ;

(add-hook 'LaTeX-mode-hook (lambda ()
                             (define-key
                               LaTeX-mode-map (kbd "<C-f5>") 'rl-save-and-LaTeX)
                             (TeX-fold-mode 1)))

(add-hook 'text-mode-hook 'turn-on-auto-fill)
(add-hook 'prog-mode-hook #'eos/add-watchwords)
(add-hook 'org-mode-hook #'turn-off-fci-mode)
(add-hook 'comint-output-filter-functions #'comint-truncate-buffer)
(add-hook 'shell-mode-hook #'ansi-color-for-comint-mode-on)

(column-number-mode 1)
(delete-selection-mode 1)
(desktop-save-mode 1)
(display-time)
(electric-pair-mode -1)
(global-font-lock-mode t)
(line-number-mode 1)
(random t)
(show-paren-mode 1)

(let ((my-cabal-path (expand-file-name "~/.cabal/bin")))
  (setenv "PATH" (concat my-cabal-path path-separator (getenv "PATH")))
  (add-to-list 'exec-path my-cabal-path))

(add-to-list 'auto-mode-alist '("\\.m\\'" . octave-mode))

(require 'package)
(package-initialize)

(add-to-list 'package-archives
  '("melpa" . "http://melpa.milkbox.net/packages/") t)


(use-package diminish :init (diminish 'auto-fill-function ""))

(use-package savehist
  :ensure t
  :config (setq savehist-file (concat user-emacs-directory "savehist")
                savehist-save-minibuffer-history 1
                savehist-additional-variables
                '(kill-ring search-ring regexp-search-ring))
  :init (savehist-mode 1))

(use-package ws-butler
  :ensure t
  :diminish ws-butler-mode
  :init
  (add-hook 'prog-mode-hook #'ws-butler-mode)
  (add-hook 'org-mode-hook #'ws-butler-mode)
  (add-hook 'text-mode-hook #'ws-butler-mode))

(use-package java-mode-hook
  :config
  (progn
    (setq c-basic-offset 4
          tab-width 4
          indent-tabs-mode t)
    (subword-mode))
  :init
  :bind (("C-h j" . javadoc-lookup)
         ("C-h i" . add-java-import)))

;; pop-up windows
(use-package popwin
  :ensure t
  :commands popwin-mode
  :init (popwin-mode 1)
  :config
  (progn
    (defvar popwin:special-display-config-backup popwin:special-display-config)
    (setq display-buffer-function 'popwin:display-buffer)

    ;; remove compilation-mode from popwin, I want a full window
    (setq popwin:special-display-config
          (remove '(compilation-mode :noselect t) popwin:special-display-config))

    ;; basic
    (push '("*Help*" :stick t) popwin:special-display-config)
    (push '("*Pp Eval Output*" :stick t) popwin:special-display-config)

    ;; dictionaly
    (push '("*dict*" :stick t) popwin:special-display-config)
    (push '("*sdic*" :stick t) popwin:special-display-config)

    ;; popwin for slime
    (push '(slime-repl-mode :stick t) popwin:special-display-config)

    ;; man
    (push '(Man-mode :stick t :height 20) popwin:special-display-config)

    ;; Elisp
    (push '("*ielm*" :stick t) popwin:special-display-config)
    (push '("*eshell pop*" :stick t) popwin:special-display-config)

    ;; python
    (push '("*Python*"   :stick t) popwin:special-display-config)
    (push '("*Python Help*" :stick t :height 20) popwin:special-display-config)
    (push '("*jedi:doc*" :stick t :noselect t) popwin:special-display-config)

    ;; Haskell
    (push '("*haskell*" :stick t) popwin:special-display-config)
    (push '("*GHC Info*") popwin:special-display-config)

    ;; git-gutter
    (push '("*git-gutter:diff*" :width 0.5 :stick t)
          popwin:special-display-config)

    (push '("*Occur*" :stick t) popwin:special-display-config)

    ;; prodigy
    (push '("*prodigy*" :stick t) popwin:special-display-config)

    ;; org-mode
    (push '("*Org tags*" :stick t :height 30)
          popwin:special-display-config)

    ;; Completions
    (push '("*Completions*" :stick t :noselect t) popwin:special-display-config)

    ;; ggtags
    (push '("*ggtags-global*" :stick t :noselect t :height 30) popwin:special-display-config)

    ;; async shell commands
    (push '("*Async Shell Command*" :stick t) popwin:special-display-config)))

(use-package bookmark+
  :ensure t
  :defer 10
  :config
  (progn
    (setq bookmark-version-control t
          ;; auto-save bookmarks
          bookmark-save-flag 1)))

(use-package flyspell-correct-ivy :ensure t)

(use-package flyspell
  :ensure t
  :defer t
  :diminish ""
  :init
  (add-hook 'prog-mode-hook #'flyspell-prog-mode)
  (add-hook 'text-mode-hook #'flyspell-mode)
  :config
  :bind (("C-;" . flyspell-auto-correct-word)))

(use-package modalka
  :ensure t
  :defer t
  :init
  (add-to-list 'modalka-excluded-modes 'magit-status-mode)
  (add-to-list 'modalka-excluded-modes 'magit-popup-mode)
  (add-to-list 'modalka-excluded-modes 'eshell-mode)
  (add-to-list 'modalka-excluded-modes 'deft-mode)
  (add-to-list 'modalka-excluded-modes 'term-mode)
  (add-to-list 'modalka-excluded-modes 'org-mode)
  (add-to-list 'modalka-excluded-modes 'vc-log-edit)

  (add-hook 'prog-mode-hook #'modalka-mode)
  (add-hook 'text-mode-hook #'modalka-mode)
  :config
  (modalka-define-kbd "SPC" "C-SPC")    ;mark region
  ;; '
  (modalka-define-kbd "," "C-,")        ;flyspell-goto-next-error
  ;; -
  (modalka-define-kbd "/" "M-.")        ;haskell-mode-jump-to-def-or-tag
  (modalka-define-kbd "." "C-.")        ;company-complete
  (modalka-define-kbd ":" "M-;")        ;comment-dwim-2
  (modalka-define-kbd ";" "C-;")
  (modalka-define-kbd "?" "M-,")        ;tags-loop-continue

  (modalka-define-kbd "0" "C-x 0")      ;delete-window
  (modalka-define-kbd "1" "C-x 1")      ;split-window-below
  (modalka-define-kbd "2" "C-x 2")      ;split-window-horizontally
  (modalka-define-kbd "3" "C-x 3")      ;split-window-vertically
  (modalka-define-kbd "4" "C-4")        ;number prefixes
  (modalka-define-kbd "5" "C-5")
  (modalka-define-kbd "6" "C-6")
  (modalka-define-kbd "7" "C-7")
  (modalka-define-kbd "8" "C-8")
  (modalka-define-kbd "9" "C-9")

  (modalka-define-kbd "a" "C-a")        ;move-beginning-of-line
  (modalka-define-kbd "b" "C-b")        ;backward-char
  (modalka-define-kbd "d" "C-d")        ;delete-char
  (modalka-define-kbd "e" "C-e")        ;move-end-of-line
  (modalka-define-kbd "f" "C-f")        ;forward-char
  (modalka-define-kbd "g" "C-g")        ;keyboard-quit
  (modalka-define-kbd "h" "M-h")        ;mark-paragraph
  (modalka-define-kbd "i" "C-i")        ;tab
  (modalka-define-kbd "j" "M-j")        ;indent-new-comment-line
  (modalka-define-kbd "k" "C-k")        ;cut line
  (modalka-define-kbd "l" "C-l")        ;recenter-top-bottom
  (modalka-define-kbd "m" "C-m")        ;autopair-newline
  (modalka-define-kbd "n" "C-n")        ;next-line
  (modalka-define-kbd "o" "C-o")        ;open-line
  (modalka-define-kbd "p" "C-p")        ;previous-line
  (modalka-define-kbd "q" "M-q")        ;fill-paragraph
  (modalka-define-kbd "r" "C-r")        ;isearch-backward
  (modalka-define-kbd "s" "C-s")        ;isearch-forward
  (modalka-define-kbd "t" "C-t")        ;transpose-chars
  (modalka-define-kbd "u" "C-u")        ;universal-argument
  (modalka-define-kbd "v" "C-v")        ;scroll-up-command
  (modalka-define-kbd "w" "C-w")        ;kill-region
  (modalka-define-kbd "y" "C-y")        ;yank
  (modalka-define-kbd "z" "M-z")        ;zap-to-char

  (modalka-define-kbd "A" "M-SPC")      ;just-one-space
  (modalka-define-kbd "B" "M-b")        ;backward-word
  (modalka-define-kbd "C" "M-c")        ;capitalize-word
  (modalka-define-kbd "D" "M-d")        ;kill-word
  (modalka-define-kbd "E" "M-e")        ;forward-sentence
  (modalka-define-kbd "F" "M-f")        ;forward-word

  ;; J
  (modalka-define-kbd "K" "M-k")        ;kill-sentence
  (modalka-define-kbd "L" "M-l")        ;downcase-word
  (modalka-define-kbd "M" "M-m")        ;back-to-indentation
  (modalka-define-kbd "N" "M-n")        ;ghc-goto-next-error
  (modalka-define-kbd "P" "M-p")        ;ghc-goto-prev-error
  (modalka-define-kbd "R" "M-r")        ;move-to-window-line-top-bottom
  (modalka-define-kbd "T" "M-t")        ;transpose-words
  (modalka-define-kbd "U" "M-u")        ;upcase-word
  (modalka-define-kbd "V" "M-v")        ;scroll-down
  (modalka-define-kbd "W" "M-w")        ;kill-ring-save

  ;; X
  (modalka-define-kbd "Y" "M-y")        ;show-kill-ring
  (modalka-define-kbd "Z" "C-z"))

(use-package smooth-scrolling
  :ensure t
  :init (smooth-scrolling-mode  1))

(use-package rainbow-delimiters
  :ensure t
  :disabled t
  :init
  (add-hook 'prog-mode-hook 'rainbow-delimiters-mode)
  :config
  (set-face-attribute 'rainbow-delimiters-unmatched-face nil
                      :foreground 'unspecified
                      :inherit 'error))

(use-package highlight-numbers
  :ensure t
  :init
  (add-hook 'prog-mode-hook #'highlight-numbers-mode))

(use-package highlight-quoted
  :ensure t
  :init
  (add-hook 'prog-mode-hook #'highlight-quoted-mode))

(use-package highlight-operators
  :ensure t
  :init
  (add-hook 'c-mode-common-hook #'highlight-operators-mode))

(use-package avy
  :ensure t
  :bind (("C-'" . avy-goto-char)
         ("M-'" . avy-goto-word-0)
         ("C-c c" . avy-goto-line)))

(use-package company
  :ensure t
  :diminish company-mode
  ;; stupid flyspell steals the binding I really want, `C-.`
  :bind (("C-c ." . company-complete)
         ("C-." . company-complete))
  :init
  (add-hook 'after-init-hook #'global-company-mode)
  (use-package company-quickhelp
    :ensure t
    :init (add-hook 'company-mode-hook #'company-quickhelp-mode)
    :config (setq company-quickhelp-delay 2))
  :config
  (setq company-selection-wrap-around t
        ;; do or don't automatically start completion
        ;;company-idle-delay nil
        company-idle-delay 0.7
        company-minimum-prefix-length 3
        ;; don't downcase dabbrev suggestions
        company-dabbrev-downcase nil
        company-dabbrev-ignore-case nil
        company-dabbrev-code-ignore-case nil
        ;; sort completions by occurrence
        company-transformers '(company-sort-by-occurrence))
  (bind-keys :map company-active-map
             ("C-n" . company-select-next)
             ("C-p" . company-select-previous)
             ("C-d" . company-show-doc-buffer)
             ("C-l" . company-show-location)
             ("<tab>" . company-complete)))

(use-package smart-tab
  :ensure t
  :defer t
  :diminish ""
  :init (global-smart-tab-mode 1)
  :config
  (setq smart-tab-using-hippie-expand t)
  (add-to-list 'smart-tab-disabled-major-modes 'mu4e-compose-mode)
  (add-to-list 'smart-tab-disabled-major-modes 'erc-mode)
  (add-to-list 'smart-tab-disabled-major-modes 'shell-mode))

(use-package hippie-exp
  :config
  (setq hippie-expand-try-functions-list
        '(;; Try to expand word "dynamically", searching the current buffer.
          try-expand-dabbrev
          ;; Try to expand word "dynamically", searching all other buffers.
          try-expand-dabbrev-all-buffers
          ;; Try to expand word "dynamically", searching the kill ring.
          try-expand-dabbrev-from-kill
          ;; Try to complete text as a file name, as many characters as unique.
          try-complete-file-name-partially
          ;; Try to complete text as a file name.
          try-complete-file-name
          ;; Try to expand word before point according to all abbrev tables.
          try-expand-all-abbrevs
          ;; Try to complete the current line to an entire line in the buffer.
          try-expand-list
          ;; Try to complete the current line to an entire line in the buffer.
          try-expand-line
          ;; Try to complete as an Emacs Lisp symbol, as many characters as
          ;; unique.
          try-complete-lisp-symbol-partially
          ;; Try to complete word as an Emacs Lisp symbol.
          try-complete-lisp-symbol)))

(use-package fill-column-indicator
  :ensure t
  :config
  (setq fci-rule-width 1
        fci-rule-character-color "darkblue"
        fci-rule-column 80)
  :init
  (add-hook 'prog-mode-hook #'fci-mode))

(use-package autopair
  :ensure t
  :init
  (add-hook 'prog-mode-hook #'autopair-mode)
  :diminish "")

(use-package diff-hl
  :ensure t
  :init
  (add-hook 'prog-mode-hook #'turn-on-diff-hl-mode)
  (add-hook 'vc-dir-mode-hook #'turn-on-diff-hl-mode))

(use-package ivy
  :ensure t
  :diminish ""
  :init
  (progn
    (use-package counsel :ensure t)
    (use-package ivy-rich :ensure t)
    (use-package flyspell-correct-ivy :ensure t)
    (use-package swiper :ensure t)
    (setq ivy-use-virtual-buffers t
          ivy-count-format "")
    (ivy-mode 1))
  :bind (("M-s" . swiper)
         ("C-c f" . counsel-git)
         ("C-c j" . counsel-git-grep)
         ("C-c C-r" . ivy-resume)
         ("M-y" . counsel-yank-pop)))

(use-package counsel :ensure t)

(use-package ivy-rich
  :ensure t
  :config (progn
            (ivy-set-display-transformer 'ivy-switch-buffer 'ivy-rich-switch-buffer-transformer)
            (setq ivy-virtual-abbreviate 'full
                  ivy-rich-switch-buffer-align-virtual-buffer t
                  ivy-rich-abbreviate-paths t)))

;; disabled haskell interactive mode and associated keybindings
;; (require 'haskell-interactive-mode)
;; (require 'haskell-process)
;; (add-hook 'haskell-mode-hook 'interactive-haskell-mode)

(use-package haskell-mode
  :ensure t
  :defer t
  :init
  (add-hook 'haskell-mode-hook #'haskell-indentation-mode)
  (add-hook 'haskell-mode-hook #'turn-on-haskell-doc-mode)
  (add-hook 'haskell-mode-hook #'pretty-greek)
  (add-hook 'haskell-mode-hook (lambda ()
                                 (setq mysymbols '(("\\"  . 955)
                                                   ("->"  . 8594)
                                                   ("<-"  . 8592)
                                                   ("=>"  . 8658))
                                       prettify-symbols-alist mysymbols)
                                 (prettify-symbols-mode t)))
  :config
  (setq
   haskell-process-suggest-remove-import-lines t
   haskell-process-auto-import-loaded-modules t
   haskell-process-log t
   haskell-process-type 'auto
   haskell-hoogle-url "http://hoogle.haskell.org/?hoogle=%s"
   haskell-hasktags-path "/home/anakreontas/.local/bin/hasktags --ignore-close-implementation"
   haskell-indentation-layout-offset 4
   haskell-indentation-left-offset 4
   haskell-indentation-starter-offset 4
   haskell-indentation-where-post-offset 4
   haskell-indentation-where-pre-offset 4
   haskell-font-lock-symbols t
   haskell-tags-on-save t)

  (use-package s)
  (defun joes-import (new-import)
    (interactive
     (list (read-from-minibuffer "Module Name: " nil nil nill 'haskell-import-history)))
    (save-excursion
      (progn (goto-char 0)
             (re-search-forward "^import " nil nil)
             (let ((processed-import (s-chop-prefix "import " (s-trim new-import)))
                   (insert processed-import)
                   (insert "\nimport ")
                   (message (concat "Imported " processed-import))
                   (haskell-sort-imports))))))
  :bind
  (("C-h h" . hoogle)
   ("C-c i" . joes-import)
   ("C-`"    . haskell-interactive-bring)))

(use-package etags-select
  :ensure t
  :config (setq etags-select-go-if-unambiguous t)
  :bind (("M-." . etags-select-find-tag-at-point )
         ("M-?" . etags-select-find-tag)))


;; (add-to-list 'load-path "~/.emacs.d/site-lisp/")
;; (require 'org-conf)

(use-package dired
  :bind ("C-x C-j" . dired-jump)
  :config
  (use-package dired-x
    :init (setq-default dired-omit-files-p t)
    :config
    (add-to-list 'dired-omit-extensions ".DS_Store"))
  (customize-set-variable 'diredp-hide-details-initially-flag nil)
  (use-package dired+
    :ensure t)
  (use-package dired-aux
    :init
    (use-package dired-async
      :ensure async))
  (put 'dired-find-alternate-file 'disabled nil)
  (setq ls-lisp-dirs-first t
        dired-recursive-copies 'always
        dired-recursive-deletes 'always
        dired-dwim-target t
        ;; -F marks links with @
        dired-ls-F-marks-symlinks t
        delete-by-moving-to-trash nil
        ;; Auto refresh dired
        global-auto-revert-non-file-buffers t
        wdired-allow-to-change-permissions t)
  (define-key dired-mode-map (kbd "RET") #'dired-find-alternate-file)
  (define-key dired-mode-map (kbd "C-x C-q") #'wdired-change-to-wdired-mode)
  (bind-key "l" #'dired-up-directory dired-mode-map)
  (bind-key "M-!" #'async-shell-command dired-mode-map)
  (add-hook 'dired-mode-hook 'eos/turn-on-hl-line)
  (add-hook 'dired-mode-hook #'eos/dired-mode-hook))


(use-package dired-narrow
  :ensure t
  :bind (:map dired-mode-map
              ("/" . dired-narrow)))

(use-package gnuplot  :ensure t)
(use-package gnuplot-mode :ensure t)

(use-package smart-mode-line
  :ensure t
  :config
  (setq sml/modified-char "*"
        sml/shorten-directory t
        sml/theme 'smart-mode-line-respectful
        sml/shorten-modes t
        sml/no-confirm-load-theme t))

(sml/setup)

(use-package elscreen
  :ensure t
  :config
  (setq elscreen-display-tab nil)
  (setq elscreen-tab-display-control nil)
  :init
  (elscreen-start))

(use-package markdown-mode
  :ensure t
  :commands (markdown-mode gfm-mode)
  :mode (("README\\.md" . markdown-mode)
         ("\\.md" . markdown-mode)
         ("\\.markdown" . markdown-mode))
  :init (setq markdown-command "markdown"))

(use-package comment-dwim-2 :ensure t)

;; TAG files
(setq tags-table-list (quote ""))

(load-theme 'tango-dark)
;; (load-theme 'wheatgrass)

(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(TeX-PDF-mode t)
 '(ansi-color-faces-vector
   [default default default italic underline success warning error])
 '(ansi-color-names-vector
   ["black" "#d55e00" "#009e73" "#f8ec59" "#0072b2" "#cc79a7" "#56b4e9" "white"])
 '(auto-completion-syntax-alist (quote (accept . word)))
 '(auto-insert-mode t nil (autoinsert))
 '(blink-cursor-mode nil)
 '(bmkp-last-as-first-bookmark-file "~/.emacs.d/bookmarks")
 '(browse-url-mozilla-program "firefox")
 '(browse-url-netscape-program "firefox")
 '(case-fold-search t)
 '(compilation-ask-about-save nil)
 '(compilation-read-command nil)
 '(custom-safe-themes
   (quote
    ("d677ef584c6dfc0697901a44b885cc18e206f05114c8a3b7fde674fce6180879" "8aebf25556399b58091e533e455dd50a6a9cba958cc4ebb0aab175863c25b9a4" "a8245b7cc985a0610d71f9852e9f2767ad1b852c2bdea6f4aadc12cce9c4d6d0" default)))
 '(dabbrev-case-fold-search (quote case-fold-search))
 '(diredp-hide-details-initially-flag nil)
 '(font-latex-title-fontify (quote color))
 '(graphviz-dot-view-command "qiv %s")
 '(history-delete-duplicates t)
 '(ispell-highlight-p t)
 '(ispell-query-replace-choices t)
 '(org-export-backends (quote (ascii beamer html latex md)))
 '(package-selected-packages
   (quote
    (s markdown-mode php-mode intero swiper etags-select ivy-rich counsel diff-hl fill-column-indicator autopair auto-pair auto-pair-mode fci-mode avy avi flyspell-correct-ivy comment-dwim-2 savehist-mode smart-mode-line dired-narrow quick-preview async dired+ ws-butler use-package smooth-scrolling smart-tab popwin modalka highlight-quoted highlight-operators highlight-numbers haskell-mode gnuplot-mode gnuplot elscreen company-quickhelp bookmark+)))
 '(parse-sexp-ignore-comments t)
 '(predictive-auto-learn t)
 '(safe-local-variable-values
   (quote
    ((ispell-dictionary . "english")
     (org-export-taskjuggler-default-reports "include \"gantexport.tji\"")
     (org-export-taskjuggler-target-version . 3.0)
     (ispell-dictionary . "en")
     (ispell-dictionary . "el")
     (TeX-engine . xelatex))))
 '(save-place t nil (saveplace)))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(mode-line ((t (:background "dark slate gray" :foreground "ivory" :inverse-video nil :box (:line-width -1 :style released-button))))))
(put 'downcase-region 'disabled nil)
(put 'narrow-to-region 'disabled nil)
