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
(use-package key-chord 
  :config
  (key-chord-mode 1)
  (key-chord-two-keys-delay 0.2))

;; Global settings
;(menu-bar-mode -1)
;(tool-bar-mode -1)
;(scroll-bar-mode -1)

(set-default-font "Knack 10")

(use-package solarized-theme
  :ensure t
  :config
  (load-theme 'solarized-light t))

(use-package evil
  :ensure t
  :init
  (progn
    (use-package evil-leader
      :ensure t
      :init
      (setq evil-default-cursor t)
      :config
      (evil-leader/set-leader ",")
      (global-evil-leader-mode))
    (evil-mode t))
  :config
  (key-chord-define evil-insert-state-map "jk" 'evil-normal-state))
