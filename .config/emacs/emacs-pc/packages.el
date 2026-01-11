;; === Core Packages ===
(use-package org
  :straight t
  :defer t
  :config
  (setq org-startup-with-inline-images t
        org-image-actual-width '(260)
        org-duration-format 'h:mm
        org-agenda-files '("~/.ok/ok")
        org-latex-listings 'minted))
(use-package ivy
  :straight t
  :init
  (ivy-mode 1))
(use-package counsel
  :straight t
  :after ivy)
(use-package company
  :straight t
  :init
  (global-company-mode))
(use-package corfu
  :straight t
  :init
  (global-corfu-mode))
(use-package cape
  :straight t
  :after corfu)
(use-package cua-base
  :init
  (cua-mode 1))

(use-package dirvish
  :straight t)

(use-package fzf
  :straight t)

(use-package magit
  :straight t)

(use-package impatient-mode
  :straight t)

(use-package simple-httpd
  :straight t)

(use-package base16-theme
  :straight t
  :config
  (load-theme 'base16-hopscotch t))

(use-package catppuccin-theme
  :straight t)

;; === Org Extensions ===


(use-package org-roam
  :straight t
  :defer t)

(use-package calfw
  :straight t
  :defer t)

(use-package calfw-org
  :straight t
  :after calfw)

;; === File & Project Browsing ===

(use-package neotree
  :straight t)

(use-package peep-dired
  :straight t)

(use-package dired-sidebar
  :straight t
  :bind (("C-x C-n" . dired-sidebar-toggle-sidebar))
  :commands (dired-sidebar-toggle-sidebar)
  :init
  (add-hook 'dired-sidebar-mode-hook
            (lambda ()
              (unless (file-remote-p default-directory)
                (auto-revert-mode))))
  :config
  (push 'toggle-window-split dired-sidebar-toggle-hidden-commands)
  (push 'rotate-windows dired-sidebar-toggle-hidden-commands)
  (setq dired-sidebar-subtree-line-prefix "__")
  (setq dired-sidebar-theme 'vscode)
  (setq dired-sidebar-use-term-integration t)
  (setq dired-sidebar-use-custom-font t))
