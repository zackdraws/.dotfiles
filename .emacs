(setq inhibit-startup-message t) 

(tool-bar-mode -1)               

(menu-bar-mode -1)               

(scroll-bar-mode -1)             

(cua-mode t) 

(ivy-mode t)

(setq visible-bell 1)

test

(set-frame-parameter (selected-frame) 'alpha '(95 . 95)) 



(set-frame-font "Cascadia Code Regular" t)



(setq frame-title-format '((:eval default-directory)))



(load-theme 'base16-hopscotch t)



(require 'use-package)

(setq use-package-always-ensure t)



(require 'org)

(require 'pdf-tools)



(setq org-agenda-files '("C:/S/EM/O"))

(setq org-latex-listings 'minted)

(setq org-startup-with-inline-images t)

(setq org-image-actual-width (list 260))



;; PDF Tools Setup

(pdf-tools-install)

(setq TeX-view-program-selection '((output-pdf "PDF Tools"))

      TeX-view-program-list '(("PDF Tools" TeX-pdf-tools-sync-view))

      TeX-source-correlate-start-server t)

(setq pdf-view-use-scaling t)

(setq pdf-view-resize-factor 1.05)



(setq org-duration-format 'h:mm)

(require 'calfw)

(require 'calfw-org)

(setq cfw:org-agenda-schedule-args '(:timestamp))



(global-set-key (kbd "C-c n j") 'org-roam-dailies-capture-today)

(global-set-key (kbd "C-c n i") 'org-roam-node-insert)

(global-set-key (kbd "C-c n c") 'org-roam-node-capture)

(global-set-key (kbd "C-c n g") 'org-roam-node-find)

(global-set-key (kbd "C-c n l") 'org-roam-buffer-toggle)

(global-set-key (kbd "C-c q") 'make-directory)

(global-set-key (kbd "C-c t") 'set-frame-alpha)

(global-set-key (kbd "C-c n f") 'org-roam-node-find)

(global-set-key (kbd "C-c l") #'org-store-link)    

(global-set-key (kbd "C-c a") #'org-agenda)

(global-set-key (kbd "C-c c") #'org-capture)  

(global-set-key (kbd "C-c f") #'neotree-dir)

(global-set-key (kbd "C-c h") #'neotree-toggle)

(global-set-key (kbd "C-c g") #'0blayout-switch)

(global-set-key (kbd "C-c w") 'peep-dired)

(global-set-key (kbd "C-c h") 'httpd-serve-directory)

(global-set-key (kbd "C-c e") 'impatient-mode)

(global-set-key (kbd "C-c m") 'magit)

(global-set-key (kbd "C-c r") 'counsel-outline)

(global-set-key (kbd "C-c i") 'overwrite-mode)

(global-set-key (kbd "C-c d") 'org-clock-timestamps-down) 

(global-set-key (kbd "C-c e") 'org-clock-timestamps-up)



(use-package dirvish

  :ensure t

  :config

  (dirvish-override-dired-mode))



(global-auto-complete-mode t)

(ac-config-default)



(require 'openwith)

(setq openwith-associations

      '(("\\.mp4\\'" "mpv" (file))))

(openwith-mode t)



(setq enable-local-eval t)

(setq safe-local-eval-forms '((progn (org-agenda-list) (other-window 1))))



(setq custom-safe-themes

      (append '("your-theme-hash-here") custom-safe-themes))



(add-hook 'TeX-after-compilation-finished-functions #'TeX-revert-document-buffer)

(add-hook 'image-mode-hook 'scale-image-register-hook)



(setq TeX-source-correlate-mode t)

(setq font-latex-fontify-script nil)

(setq reftex-extra-bindings t)



;; Enable desktop save mode to save session state

(desktop-save-mode 1)

(custom-set-variables

 ;; custom-set-variables was added by Custom.

 ;; If you edit it by hand, you could mess it up, so be careful.

 ;; Your init file should contain only one such instance.

 ;; If there is more than one, they won't work right.

 '(ignored-local-variable-values

   '((org-export-initial-scope . buffer)

     (org-export-with-title . t)

     (org-export-with-properties))))

(custom-set-faces

 ;; custom-set-faces was added by Custom.

 ;; If you edit it by hand, you could mess it up, so be careful.

 ;; Your init file should contain only one such instance.

 ;; If there is more than one, they won't work right.

 )

