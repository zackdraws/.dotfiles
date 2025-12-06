(defvar bootstrap-version)
(let ((bootstrap-file
       (expand-file-name
        "straight/repos/straight.el/bootstrap.el"
        (or (bound-and-true-p straight-base-dir)
            user-emacs-directory)))
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
(use-package emacs
  :init
  (setq initial-scratch-message nil)
  (defun display-startup-echo-area-message ()
    (message "")))
;; Use straight.el for packages
(straight-use-package 'org)
;;(straight-use-package 'org-roam)
;;(straight-use-package 'calfw)
;;(straight-use-package 'calfw-org)
(straight-use-package 'base16-theme)
(straight-use-package 'catppuccin-theme)
(straight-use-package 'ivy)
(straight-use-package 'counsel)
;;(straight-use-package 'neotree)
(straight-use-package 'peep-dired)
(straight-use-package 'catppuccin-theme)
(straight-use-package 'cape)
(straight-use-package 'fzf)
(straight-use-package 'impatient-mode)
(straight-use-package 'simple-httpd)
(straight-use-package 'magit)
(straight-use-package 'company)
(straight-use-package 'corfu)
(straight-use-package 'dirvish)
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
(require 'company)
(load-theme 'base16-hopscotch t)
;; Disable startup screen and message
(setq inhibit-startup-echo-area-message "tychoish")
(setq initial-major-mode 'fundamental-mode)
(setq initial-scratch-message 'nil)
(setq inhibit-startup-screen t)
(setq inhibit-startup-message t)
(setq initial-scratch-message nil)
(setq initial-buffer-choice nil)
(setq inhibit-startup-screen t)
(global-display-line-numbers-mode)
(desktop-save-mode -1)
(global-corfu-mode)
(global-company-mode)
;; Org Mode configuration
(setq org-startup-with-inline-images t
      org-image-actual-width (list 260)
      org-duration-format 'h:mm
      org-agenda-files '("~/.ok/ok")
      org-latex-listings 'minted)
;; Org Mode Calendar
;; Enable ivy-mode
(ivy-mode 1)
;; Enable cua-mode
(cua-mode 1)
;; UI tweaks
(tool-bar-mode -1)
(menu-bar-mode -1)
(scroll-bar-mode -1)
(setq visible-bell 1)
(setq frame-title-format '((:eval default-directory)))
;; Global keybindings
(global-set-key (kbd "C-c n f") #'org-roam-node-find)
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
;; Custom sets
(custom-set-variables
 '(custom-safe-themes t))
(custom-set-faces)
;; Close all other buffers except the file(s) opened from CLI
(add-hook 'emacs-startup-hook
	  (lambda ()
	    ;; Only do this if files were opened from CLI
	    (when command-line-args-left
	      (mapc (lambda (buf)
		      (unless (or (buffer-file-name buf)
				  (string= (buffer-name buf) "*Messages*"))
			(kill-buffer buf)))
		    (buffer-list)))))
(defvar bootstrap-version)
(let ((bootstrap-file
       (expand-file-name
	"straight/repos/straight.el/bootstrap.el"
	(or (bound-and-true-p straight-base-dir)
	    user-emacs-directory)))
      (bootstrap-version 7))
  (unless (file-exists-p bootstrap-file)
    (with-current-buffer
	(url-retrieve-synchronously
	 "https://raw.githubusercontent.com/radian-software/straight.el/develop/install.el"
	 'silent 'inhibit-cookies)
      (goto-char (point-max))
      (eval-print-last-sexp)))
    (load bootstrap-file nil 'nomessage))
(use-package dired-sidebar
  :bind (("C-x C-n" . dired-sidebar-toggle-sidebar))
  :ensure t
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

;; -----------------------------
;; AUCTeX / XeLaTeX integration
;; -----------------------------
(setq TeX-engine 'xetex)         ;; Use XeLaTeX by default
(setq TeX-PDF-mode t)            ;; Always generate PDF
(setq TeX-save-query nil)        ;; Save without asking

(add-hook 'LaTeX-mode-hook
          (lambda ()
            (setq TeX-command-default "XeLaTeX")
            (TeX-global-PDF-mode 1)
            ;; Optional: view with PDF Tools if installed
            (setq TeX-view-program-selection '((output-pdf "PDF Tools")))))

;; Optional quick keybinding to compile current file with XeLaTeX
(global-set-key (kbd "C-c x") (lambda ()
                                (interactive)
                                (TeX-command "XeLaTeX" 'TeX-master-file -1)))

