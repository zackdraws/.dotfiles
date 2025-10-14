;; ----------------------------------------------------------------------------
;; Global Keyboard Shortcuts
;; ----------------------------------------------------------------------------

;; Org
(global-set-key (kbd "C-c a") #'org-agenda)
(global-set-key (kbd "C-c c") #'org-capture)

;; Ivy / Swiper
(global-set-key (kbd "C-s")     #'swiper)
(global-set-key (kbd "C-c C-r") #'ivy-resume)
(global-set-key (kbd "C-x b")   #'ivy-switch-buffer)

;; Counsel
(global-set-key (kbd "M-x")     #'counsel-M-x)
(global-set-key (kbd "C-x C-f") #'counsel-find-file)
(global-set-key (kbd "C-c k")   #'counsel-rg)
(global-set-key (kbd "C-c g")   #'counsel-git)

;; Dirvish
(global-set-key (kbd "C-x C-d") #'dirvish)

;; FZF
(global-set-key (kbd "C-c f")   #'fzf)

;; Magit
(global-set-key (kbd "C-x g")   #'magit-status)

;; Web server + preview
(global-set-key (kbd "C-c w s") #'httpd-start)
(global-set-key (kbd "C-c w q") #'httpd-stop)
(global-set-key (kbd "C-c w p") #'impatient-mode)

;; Optional bindings (uncomment if you use these packages)
;; (global-set-key (kbd "C-c n f") #'org-roam-node-find)
;; (global-set-key (kbd "C-c c w") #'cfw:open-calendar-buffer)
;; (global-set-key (kbd "C-c n")   #'neotree-toggle)

;; Example: Your own utilities
;; (global-set-key (kbd "C-c t") #'ansi-term)
;; (global-set-key (kbd "C-c e") #'eshell)

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
