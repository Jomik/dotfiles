(require 'package)
(setq package-enable-at-startup nil)
(add-to-list 'package-archives
             '("melpa-stable" . "http://stable.melpa.org/packages/") t)
(add-to-list 'package-archives
             '("melpa" . "http://melpa.org/packages/") t)
(package-initialize)

;; Bootstrap `use-package'
(unless (package-installed-p 'use-package)
  (package-refresh-contents)
  (package-install 'use-package))
(require 'use-package)
(use-package use-package-chords
  :ensure t
  :config (key-chord-mode 1))

;; Global settings
;(menu-bar-mode -1)
;(tool-bar-mode -1)
;(scroll-bar-mode -1)

(set-default-font "Knack 10")

;; Set up a file for the customization system
(setq custom-file "~/.emacs.d/etc/custom.el")
(load custom-file)

;; Change backup and autosave settings
(setq backup-directory-alist '((".*" . "~/.emacs.d/backup")))
(setq version-control t)
(setq delete-old-versions t)
(setq auto-save-list-file-prefix "~/.emacs.d/autosave/")
(setq auto-save-file-name-transforms '((".*" "~/.emacs.d/autosave/" t)))

;; Disable ads
(setq inhibit-startup-screen t)
(defun display-startup-echo-area-message ()
  (message "Let the hacking begin!"))

;; Make use of our memory. Garbage collection happens at 50MiB
(setq gc-cons-threshold 50000000)

;; Save place in file
(setq-default save-place t)
(setq save-place-file "~/.emacs.d/etc/saveplace")

(use-package solarized-theme
  :ensure t
  :config (load-theme 'solarized-light t))

;; Better M-x
(use-package smex
  :ensure t
  :config
  (smex-initialize)
  :bind (("M-x" . smex)
    ("M-X" . smex-major-mode-commands)
    ("C-c C-c M-x" . execute.extended-command)))

(use-package org
  :ensure t
  :config (add-to-list 'auto-mode-alist '("\\.org$" . org-mode)))

(use-package evil
  :ensure t
  :init (progn
    (use-package evil-leader
      :ensure t
      :init
      (setq evil-default-cursor t)
      :config
      (evil-leader/set-leader ",")
      (global-evil-leader-mode))
    (evil-mode t))
  :chords ("jk" . evil-normal-state))
