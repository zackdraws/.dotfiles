;; shortcuts
(setq org-display-remote-inline-images 'cache)
(setq org-startup-with-inline-images t)
(global-set-key (kbd "C-c n t") #'treemacs)
(global-set-key (kbd "C-c a") #'org-agenda)
(global-set-key (kbd "C-c c") #'org-capture)
(global-set-key (kbd "C-c d") #'org-clock-timestamps-down)
(global-set-key (kbd "C-c e") #'org-clock-timestamps-up)
(global-set-key (kbd "C-c f") #'neotree-dir)
(global-set-key (kbd "C-c g") #'0blayout-switch)
(global-set-key (kbd "C-c h") #'httpd-serve-directory)
(global-set-key (kbd "C-c i") #'overwrite-mode)
(global-set-key (kbd "C-c l") #'org-store-link)
(global-set-key (kbd "C-c m") #'magit)
(global-set-key (kbd "C-c q") #'make-directory)
(global-set-key (kbd "C-c r") #'counsel-outline)
(global-set-key (kbd "C-c t") #'set-frame-alpha)
(global-set-key (kbd "C-c w") #'peep-dired)
(global-set-key (kbd "C-c z") #'fzf)
(global-set-key (kbd "C-c n f") #'org-roam-node-find)
(global-set-key (kbd "C-c n i") #'org-roam-node-insert)
(global-set-key (kbd "C-c n b") #'org-roam-buffer-toggle)
;; Bootstrap straight.el & use-package
(defvar bootstrap-version)
(let ((bootstrap-file
       (expand-file-name "straight/repos/straight.el/bootstrap.el"
                         user-emacs-directory))
      (bootstrap-version 7))
  (unless (file-exists-p bootstrap-file)
    (with-current-buffer
        (url-retrieve-synchronously
         "https://raw.githubusercontent.com/radian-software/straight.el/develop/install.el"
         'silent 'inhibit-cookies)
      (goto-char (point-max))
      (eval-print-last-sexp)))
  (load bootstrap-file nil 'nomessage))
(straight-use-package 'use-package)
(setq straight-use-package-by-default t)
(setq use-package-always-defer t)
;; Basic Emacs tweaks
(setq inhibit-startup-screen t
      inhibit-startup-message t
      initial-scratch-message nil
      initial-major-mode 'fundamental-mode
      visible-bell t)
(tool-bar-mode -1)
(menu-bar-mode -1)
(scroll-bar-mode -1)
(global-display-line-numbers-mode)
;; Themes
(straight-use-package 'base16-theme)
(straight-use-package 'catppuccin-theme)
(load-theme 'catppuccin :no-confirm)
(setq catppuccin-flavor 'frappe) ;; or 'latte, 'macchiato, or 'mocha
(catppuccin-reload)
;; (load-theme 'base16-hopscotch t)
;; Completion & UI
;; (straight-use-package 'calfw)
;; (straight-use-package 'calfw-org)
(straight-use-package 'neotree)
(straight-use-package 'treemacs)
(straight-use-package 'ivy)
(straight-use-package 'counsel)
(straight-use-package 'company)
(straight-use-package 'corfu)
(straight-use-package 'cape)
(straight-use-package 'fzf)
(ivy-mode 1)
(global-company-mode 1)
(global-corfu-mode 1)
(cua-mode 1)
;; Dired enhancements
(straight-use-package 'peep-dired)
(straight-use-package 'dired-sidebar)
(use-package dired-sidebar
  :bind (("C-x C-n" . dired-sidebar-toggle-sidebar))
  :init
  (add-hook 'dired-sidebar-mode-hook
            (lambda ()
              (unless (file-remote-p default-directory)
                (auto-revert-mode))))
  :config
  (setq dired-sidebar-subtree-line-prefix "__"
        dired-sidebar-theme 'vscode
        dired-sidebar-use-term-integration t
        dired-sidebar-use-custom-font t))
;; Version control & web
(straight-use-package 'magit)
(straight-use-package 'simple-httpd)
(straight-use-package 'impatient-mode)
;; Org-mode & Org-roam
(straight-use-package 'org)
(straight-use-package 'org-roam)
(straight-use-package 'org-roam-ui)
(straight-use-package 'citar)
(straight-use-package 'dirvish)
;;
(require 'company)
;; Require packages
(require 'org)
(require 'corfu)
;;(require 'org-roam)
;;(require 'calfw)
;;(require 'calfw-org)
(require 'ivy)
(require 'counsel)
;;(require 'cua-base)
;;(require 'neotree)
(require 'peep-dired)
(require 'fzf)
;;(require 'impatient-mode)
(require 'simple-httpd)
;;(require 'magit)
;; org
(setq org-startup-with-inline-images t
      org-image-actual-width (list 1200)
      org-duration-format 'h:mm
      org-agenda-files '("~/.ok/ok/"))
(setq org-roam-directory (file-truename "~/ok/org"))
(use-package org-roam)
(use-package org-roam-ui)
  (setq org-roam-ui-sync-theme t
        org-roam-ui-follow t
        org-roam-ui-update-on-save t
        org-roam-ui-open-on-start nil)
;; citar
(setq citar-bibliography '("~/ok/org/biblio.bib"))
(setq citar-notes-paths '("~/ok/org/reference"))
;;(use-package citar
;;  :ensure t
;;  :custom
;;  (citar-bibliography '("~/.ok/ok/org/biblio.bib"))) 
;;(setq native-comp-async-report-warnings-errors nil)
;; AUCTeX / XeLaTeX integration
;;(setq TeX-engine 'xetex) 
;;(setq TeX-PDF-mode t)    
;;(setq TeX-save-query nil)       
;;(add-hook 'LaTeX-mode-hook
;;          (lambda ()
;;           (setq TeX-command-default "XeLaTeX")
;; (TeX-global-PDF-mode 1)
;; (setq TeX-view-program-selection '((output-pdf
;; (setq TeX-view-program-selection '((output-pdf
;;"PDF Tools")))))
(use-package nano-calendar
  :straight (:host github :repo "rougier/nano-calendar")
  :bind ("C-c c" . nano-calendar))
(set-face-attribute 'default nil
                    :family "FiraCode Nerd Font Regular" )
;;(use-package org-roam
;;  :straight (:host github :repo "org-roam/org-roam"
;;             :files (:defaults "extensions/*"))
;;  ...)

;;(use-package org-roam-ui
;;  :straight
;;    (:host github :repo "org-roam/org-roam-ui" :branch "main" :files ("*.el" "out"))
;;    :after org-roam
         normally we'd recommend hooking orui after org-roam, but since org-roam does not have
         a hookable mode anymore, you're advised to pick something yourself
         if you don't care about startup time, use
;;  :hook (after-init . org-roam-ui-mode)
;;    :config
;;    (setq org-roam-ui-sync-theme t
;;          org-roam-ui-follow t		
;;          org-roam-ui-update-on-save t
;;          org-roam-ui-open-on-start t))

;;(use-package org-roam
;;  :ensure t
;;  :custom
;;  (org-roam-directory (file-truename "~/ok/org"))
;;  :bind (("C-c n l" . org-roam-buffer-toggle)
;;         ("C-c n f" . org-roam-node-find)
;;         ("C-c n g" . org-roam-graph)
;;         ("C-c n i" . org-roam-node-insert)
;;         ("C-c n c" . org-roam-capture)
;;         ;; Dailies
;;         ("C-c n j" . org-roam-dailies-capture-today))
;;  :config
  ;; If you're using a vertical completion framework, you might want a more informative completion interface
;;  (setq org-roam-node-display-template (concat "${title:*} " (propertize "${tags:10}" 'face 'org-tag)))
;;  (org-roam-db-autosync-mode)
  ;; If using org-roam-protocol
;;  (require 'org-roam-protocol))
