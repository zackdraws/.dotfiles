;;; keybindings.el --- iSH Emacs keybindings -*- lexical-binding: t; -*-

(defun ok-bind-existing (key preferred fallback)
  "Bind KEY to PREFERRED when it exists, otherwise FALLBACK."
  (cond
   ((fboundp preferred) (global-set-key (kbd key) preferred))
   ((and fallback (fboundp fallback)) (global-set-key (kbd key) fallback))))

(global-set-key (kbd "C-c a") #'org-agenda)
(global-set-key (kbd "C-c c") #'org-capture)
(global-set-key (kbd "C-c l") #'org-store-link)
(global-set-key (kbd "C-c o") #'ok-open-notes-dir)
(global-set-key (kbd "C-c n n") #'ok-new-note)
(global-set-key (kbd "C-c q") #'make-directory)
(global-set-key (kbd "C-c i") #'overwrite-mode)

(ok-bind-existing "C-s" 'swiper 'isearch-forward)
(ok-bind-existing "M-x" 'counsel-M-x 'execute-extended-command)
(ok-bind-existing "C-x C-f" 'counsel-find-file 'find-file)
(ok-bind-existing "C-x b" 'ivy-switch-buffer 'switch-to-buffer)
(ok-bind-existing "C-c r" 'counsel-outline 'outline-minor-mode)
(ok-bind-existing "C-c k" 'counsel-rg 'rgrep)
(ok-bind-existing "C-c z" 'fzf nil)
(ok-bind-existing "C-x g" 'magit-status nil)
(ok-bind-existing "C-c m" 'magit-status nil)
(ok-bind-existing "C-c f" 'neotree-dir 'dired)
(ok-bind-existing "C-c h" 'neotree-toggle 'dired)
(ok-bind-existing "C-x C-n" 'dired-sidebar-toggle-sidebar 'dired)
(ok-bind-existing "C-c n f" 'org-roam-node-find nil)

(define-key key-translation-map [?\C-h] [?\C-?])

(provide 'keybindings)
;;; keybindings.el ends here
