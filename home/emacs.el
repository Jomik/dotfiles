;; Jonas' .emacs.el
;; Emacs v24.5

;; ---------------------- Window settings -----------------------------
(menu-bar-mode -1)
(global-linum-mode 1)
(when window-system
  (tool-bar-mode -1)
  (tooltip-mode -1)
  (scroll-bar-mode -1))

(require 'package)
(setq package-enable-at-startup nil)
(add-to-list 'package-archives
             '("melpa" . "http://melpa.org/packages/") t)
(package-initialize)

;; Bootstrap use-package
(unless (package-installed-p 'use-package)
  (package-refresh-contents)
  (package-install 'use-package))
(require 'use-package)
(use-package use-package-chords
  :ensure t
  :config (key-chord-mode 1))

;; ---------------------- Global settings -----------------------------
;; Set font
(set-face-attribute 'default nil
                    :family "Source Code Pro"
                    :height 105
                    :weight 'normal
                    :width 'normal)

(setq-default indent-tabs-mode nil              ; Use spaces instead of tabs
              fill-column 80                    ;
              tab-width 2                       ; Set tab-width
              truncate-lines 1)	                ; Disables word-wrap

(setq initial-major-mode 'org-mode      ; Sets the *scratch* to org mode as default
      initial-scratch-message nil       ; Sets the *scratch* message
      inhibit-splash-screen t           ; Prevents the Emacs Startup menu
      dired-omit-mode t                 ; Hides uninteresting files
      standard-indent 2                 ; Indentation setting
      tab-stop-list (number-sequence 2 120 2) ; Set the amount of spaces on identation
      gc-cons-threshold 104857600             ; Set garbage-collecter to run at 100 MB
      frame-title-format '("Emacs @ " system-name ": %b %+%+ %f")          ; Sets the window title to more useful
      backup-directory-alist `((".*" . ,temporary-file-directory))         ; Places all backup files in same folder
      auto-save-file-name-transforms `((".*" ,temporary-file-directory t)) ; Places all autosave files in same folder
      sentence-end-double-space nil   ; Only one space after sentence
      echo-keystrokes 0.1             ; Show keystrokes at once in the bottom
      system-uses-terminfo nil        ; Shell mode character fix
      password-cache-expiry (* 60 15) ; Time before asking for su pass again
      use-dialog-box nil)             ; Prevent emacs from showing GUI-dialogs

(blink-cursor-mode -1)                ; No blinking!
(mouse-avoidance-mode 'animate)       ; Move mouse away from cursor
(global-hl-line-mode 1)               ; Highlight current line
(global-prettify-symbols-mode 1)      ; Text to symbols
(defalias 'yes-or-no-p 'y-or-n-p)     ; y for yes, n for no. No confirmation

;; Unbind suspend-frame keys
(unbind-key "C-z")
(unbind-key "C-x C-z")

;; ---------------------- Built-in packages -----------------------------
(use-package simple
	:demand
	:bind (("M-J" . join-line)
         ("M-j" . join-with-next-line))
	:config
	(defun join-with-next-line () (interactive) (join-line -1))
	(line-number-mode 1)
	(column-number-mode 1))

;; Mouse wheel support
(use-package mwheel
  :config
  (setq mouse-wheel-progressive-speed nil
        mouse-wheel-scroll-amount '(1 ((shift) . 1))
        mouse-wheel-follow-mouse t))

(use-package subword
  :diminish ""
  :config (global-subword-mode 1))

;; Highlight parens and brackets
(use-package paren
  :config
  (setq show-paren-delay 0)
  (show-paren-mode))

;; ---------------------- Melpa packages -----------------------------
(setq use-package-always-ensure t)

(use-package solarized-theme
  :if window-system
  :config (load-theme 'solarized-light t))

;; Autoindent all the time
(use-package aggressive-indent
  :diminish ""
  :config
  (add-hook 'nix-mode-hook (lambda () (aggressive-indent-mode -1)))
  (global-aggressive-indent-mode 1))

;; Colors the parenteses in pairs
(use-package rainbow-delimiters
  :defer 1
  :config (add-hook 'prog-mode-hook 'rainbow-delimiters-mode))

;; Smooth Scrolling
(use-package sublimity
  :config
  (setq sublimity-scroll-weight 20
        sublimity-scroll-drift-length 10)
  (require 'sublimity-scroll)
  (sublimity-mode 1))

(use-package helm-config
  :ensure helm
  :demand
  :diminish helm-mode
  :bind (("C-x C-f" . helm-find-files)
         ("C-x b" . helm-mini)
         ("M-x" . helm-M-x))
  :config
  (use-package helm-descbinds
    :bind ("C-h b" . helm-descbinds)
    :config (helm-descbinds-mode))
  (helm-mode 1))

(use-package company
  :diminish ""
  :config (global-company-mode))

;; Git integration
(use-package magit
  :bind ("C-x g s" . magit-status)
  :config (magit-auto-revert-mode -1))

;; Show git differences in buffers
(use-package git-gutter+
  :defer 1
  :diminish ""
  :bind (("C-x g n" . git-gutter+-next-hunk)
         ("C-x g p" . git-gutter+-previous-hunk)
         ("C-x g d" . git-gutter+-show-hunk-inline-at-point))
  :config
  (use-package git-gutter-fringe+)
  (global-git-gutter+-mode 1))

(use-package which-key
  :diminish ""
  :config
  (which-key-mode))

;; Highlights changed text after some commands
(use-package volatile-highlights
  :diminish volatile-highlights-mode
  :config (volatile-highlights-mode t))

;; Auto pair brackets
(use-package smartparens-config
  :ensure smartparens
  :diminish smartparens-mode
  :demand
  :bind (:map smartparens-mode-map
              ("C-M-f" . sp-forward-sexp)
              ("C-M-b" . sp-backward-sexp)
              ("C-M-k" . sp-kill-sexp))
  :config (smartparens-global-mode))

(use-package smart-comment
  :bind ("M-;" . smart-comment))

;; Realtime syntaks checking
(use-package flycheck
  :defer t)

;; Realtime spell-checking
(use-package flyspell
  :defer t
  :config
  (setq ispell-program-name "aspell"
        ispell-dictionary "english"))

;; Clean whitespace trailing on save
(use-package whitespace-cleanup-mode
  :diminish whitespace-cleanup-mode
  :defer 1
  :config (global-whitespace-cleanup-mode 1))

;; Move lines and regions up or down
(use-package move-text
  :bind
  ("M-P" . move-text-up)
  ("M-N" . move-text-down))

(use-package origami
  :disabled t)

;; ---------------------- Language settings -----------------------------

(use-package org
  :mode ("\\.org\\'" . org-mode)
  :bind
  ("C-z o" . org-open-main-file)
  ("C-z a" . org-agenda)
  ("C-z c" . org-capture)
  :config
  (setq org-log-done t
        org-default-notes-file "~/organizer.org"
        org-refile-targets '((org-agenda-files . (:maxlevel . 6)))
        org-todo-keywords '((sequence "TODO" "INPROGRESS" "DONE"))
        org-todo-keyword-faces '(("INPROGRESS" . (:foreground "blue" :weight bold))))
  (defun org-open-main-file () (interactive) (find-file "~/organizer.org"))
  (use-package org-bullets
    :config (add-hook 'org-mode-hook 'org-bullets-mode 1)))

(use-package scheme
  :ensure nil
  :mode ("\\.scm\\'" . scheme-mode)
  :config (setq scheme-program-name "petite"))

;; Tool for writing LaTeX
(use-package tex-site
  :ensure auctex
  :defer t
  :config
  (setq TeX-auto-save t
        TeX-parse-self t
        TeX-PDF-mode t
        TeX-save-query nil)
  (add-hook 'LaTeX-mode-hook 'auto-fill-mode)
  (add-hook 'LaTeX-mode-hook 'LaTeX-math-mode)
  (add-hook 'LaTeX-mode-hook 'flyspell-mode)
  (add-hook 'LaTeX-mode-hook 'flyspell-buffer)
  (use-package company-auctex
    :config (company-auctex-init)))
