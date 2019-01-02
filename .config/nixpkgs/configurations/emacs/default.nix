{ pkgs, ... }:

{
  imports = [ ../../modules/programs/emacs ./overrides.nix ];

  programs.emacs.init = {
    enable = true;
    recommendedGcSettings = true;
    startupTimer = true;
    diminish = true;
    bindKey = true;

    prelude = ''
      (menu-bar-mode -1) ; Removes the menu-bar
      (when window-system
        (tool-bar-mode -1) ; Removes the toolbar in graphic editor
        (tooltip-mode -1) ; Removes mouse hover tooltips
        (scroll-bar-mode -1)) ; Removes the scollbar

      (setq-default indent-tabs-mode nil
                    fill-column 80
                    show-trailing-whitespace t)

      (setq initial-major-mode 'org-mode ; Sets the *scratch* to org mode as default
            initial-scratch-message nil ; Sets the *scratch* message
            inhibit-splash-screen t ; Prevents the Emacs Startup menu
            confirm-nonexistent-file-or-buffer t
            save-interprogram-paste-before-kill t ; Save pastebin to kill ring
            dired-omit-mode t ; Hides uninteresting files
            ring-bell-function 'ignore ; Removing the beep when error
            confirm-kill-emacs 'y-or-n-p ; Ask before closing
            minibuffer-prompt-properties
            '(read-only t point-entered minibuffer-avoid-prompt face minibuffer-prompt) ; Prevent Read-only warnings in prompt
            use-dialog-box nil ; Prevent emacs from showing GUI-dialogs

            ;; Indentation
            tab-width 2
            standard-indent 2
            tab-stop-list (number-sequence 2 120 2) ; Set the amount of spaces on identation
            css-indent-offset 2
            c-basic-offset 2
            history-length 1000

            require-final-newline t ; Always end files with a newline character.
            line-move-visual nil ; Don't want to move based on visual line.

            ;; Disable backups
            auto-save-default nil
            create-lockfiles nil
            make-backup-files nil
            backup-inhibited t
            frame-title-format '("Emacs @ " system-name ": %b %+%+ %f") ; Sets the window title to more useful
            sentence-end-double-space nil ; Only one space after sentence
            echo-keystrokes 0.1 ; Show keystrokes at once in the bottom
            system-uses-terminfo nil ; Shell mode character fix
            password-cache-expiry (* 60 15) ; Time before asking for su pass again
            fringes-outside-margins t
            desktop-restore-frames nil ; for desktop-mode
            dired-listing-switches "-aBhl  --group-directories-first"

            ;; Scrolling settings
            mouse-wheel-progressive-speed nil
            mouse-wheel-scroll-amount '(1 ((shift) . 1))
            mouse-wheel-follow-mouse t
            show-paren-delay 0)

      (blink-cursor-mode -1); No blinking cursor
      (mouse-avoidance-mode 'animate) ; Moves the cursor if in the way
      (delete-selection-mode 1) ; Delete region on typing, like other editors
      (defalias 'yes-or-no-p 'y-or-n-p) ; y for yes and n for no
      (winner-mode 1)
      (savehist-mode 1)
      (global-auto-revert-mode t)
      (global-subword-mode 1) ; Move in CamelCasing
      (show-paren-mode) ; Highlight mathing parentese
      (line-number-mode 1) ; show linenumber in modebar
      (column-number-mode 1) ; show linenumber in modebar
      (transient-mark-mode 1)

      ;; Unbind Pesky Sleep Button
      (global-unset-key [(control z)])
      (global-unset-key [(control x)(control z)])
    '';

    usePackage = {
      gruvbox-theme = {
        enable = true;
        config = ''
          ;; Only use theme if GUI
          (if (display-graphic-p)
            (load-theme 'gruvbox-light-soft t))
        '';
      };

      which-key = {
        enable = true;
        commands = [ "which-key-mode" ];
        diminish = [ "which-key-mode" ];
        defer = 2;
        config = "(which-key-mode)";
      };

      highlight-symbol = {
        enable = true;
        diminish = [ "highlight-symbol-mode" ];
        config = ''
          (add-hook 'prog-mode-hook 'highlight-symbol-mode)
          (setq highlight-symbol-idle-delay .2
                highlight-symbol-highlight-single-occurrence nil)
        '';
      };

      # Remember where we where in a previously visited file.
      saveplace = {
        enable = true;
        config = ''
          (setq-default save-place t)
          (setq save-place-file (locate-user-emacs-file "places"))
        '';
      };

      # More helpful buffer names.
      uniquify = {
        enable = true;
        config = ''
          (setq uniquify-buffer-name-style 'post-forward)
        '';
      };

      # Git
      magit = {
        enable = true;
        bind = {
          "C-x g s" = "magit-status";
        };
        config = ''
          (setq magit-completing-read-function 'ivy-completing-read
                magit-log-section-arguments '("--graph" "--color" "--decorate" "-n256"))
          (add-to-list 'git-commit-style-convention-checks
                       'overlong-summary-line)
        '';
      };

      # Evil
      evil = {
        enable = true;
        init = ''
          (setq evil-want-integration t)
          (setq evil-want-keybinding nil)
        '';
        config = "(evil-mode 1)";
      };
      evil-collection = {
        enable = true;
        after = [ "evil" ];
        config = "(evil-collection-init)";
      };
      evil-surround = {
        enable = true;
        config = "(global-evil-surround-mode 1)";
      };
      evil-commentary = {
        enable = true;
        config = "(evil-commentary-mode)";
      };

      # Ivy
      ivy = {
        enable = true;
        diminish = [ "ivy-mode" ];
        config = ''
          (setq ivy-height 15)
          (ivy-mode 1)
        '';
      };
      swiper = {
        enable = true;
        bind = {
          "C-s" = "swiper";
        };
      };
      counsel = {
        enable = true;
        diminish = [ "counsel-mode" ];
        bind = {
          "C-x C-f" = "counsel-find-file";
          "C-x C-r" = "counsel-recentf";
          "C-x C-y" = "counsel-yank-pop";
          "M-x" = "counsel-M-x";
        };
      };

      # Syntax checking
      flycheck = {
        enable = true;
        commands = [ "global-flycheck-mode" ];
        config = ''
          ;; Only check buffer when mode is enabled or buffer is saved.
          (setq flycheck-check-syntax-automatically '(mode-enabled save))

          ;; Enable flycheck in all eligible buffers.
          (global-flycheck-mode)
        '';
      };

      flycheck-haskell = {
        enable = true;
        hook = [ "(flycheck-mode . flycheck-haskell-setup)" ];
      };

      # Languages
      systemd = {
        enable = true;
        defer = true;
      };
      nix-mode = {
        enable = true;
        mode = [
          ''"\\.nix\\'"''
        ];
      };

      haskell-mode = {
        enable = true;
        mode = [
          ''"\\.hs\\'"''
          ''"\\.hsc\\'"''
          ''"\\.c2hs\\'"''
          ''"\\.cpphs\\'"''
          ''("\\.lhs\\'" . literate-haskell-mode)''
        ];
        hook = [
          ''
            (haskell-mode
             . (lambda ()
                 (subword-mode +1)
                 (interactive-haskell-mode +1)
                 (haskell-doc-mode +1)
                 (haskell-indentation-mode +1)
                 (haskell-decl-scan-mode +1)))
          ''
        ];
        config = ''
          (require 'haskell)
          (require 'haskell-doc)

          (setq haskell-process-auto-import-loaded-modules t
                haskell-process-suggest-remove-import-lines t
                haskell-process-log t
                haskell-tags-on-save t
                haskell-notify-p t)

          (setq haskell-process-args-cabal-repl
                '("--ghc-options=+RTS -M500m -RTS -ferror-spans -fshow-loaded-modules"))
        '';
      };

    };
  };
}
