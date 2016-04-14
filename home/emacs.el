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
(menu-bar-mode -1)
(tool-bar-mode -1)
(scroll-bar-mode -1)
(global-linum-mode 1)

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

;; Replace yes-or-no with y-or-n.
(defalias 'yes-or-no-p 'y-or-n-p)

(use-package solarized-theme
  :if window-system
  :config (load-theme 'solarized-light t))

(use-package helm-config
  :ensure helm
  :demand
  :diminish helm-mode
  :bind (("C-x C-f" . helm-find-files)
	 ("C-x b" . helm-mini)
	 ("M-x" . helm-M-x))
  :config (helm-mode 1))

(use-package company
  :ensure t
  :config (progn
	    (global-company-mode)
	    (use-package company-auctex
	      :ensure t
	      :config (company-auctex-init))))

(use-package magit
  :ensure t
  :bind ("C-x g" . magit-status))

(use-package which-key
  :ensure t
  :diminish ""
  :config (which-key-mode))

(use-package org
  :ensure t
  :mode ("\\.org\\'" . org-mode))

(use-package asm-mode
  :ensure t
  :mode ("\\.j\\'" . asm-mode))

(use-package evil
  :disabled t
  :ensure t
  :chords ("jk" . evil-normal-state)
  :init (progn
	  (use-package evil-leader
	    :ensure t
	    :init (setq evil-default-cursor t)
	    :config (progn
		      (evil-leader/set-leader ",")
		      (global-evil-leader-mode)))
	  (evil-mode 1))
  :config (progn
	    (use-package evil-surround
	      :ensure t
	      :config (global-evil-surround-mode 1))))

(use-package tex-site
  :ensure auctex
  :init (progn
	  (setq TeX-auto-save t)
	  (setq TeX-parse-self t)
	  (setq TeX-PDF-mode t)
	  (setq TeX-save-query nil))
  :config (progn
	    (add-hook 'LaTeX-mode-hook 'auto-fill-mode)
	    (add-hook 'LaTeX-mode-hook 'LaTeX-math-mode)))
