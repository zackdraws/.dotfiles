;;; theme.el --- Theme configuration with terminal-friendly Catppuccin colors

(use-package catppuccin-theme
  :straight t
  :config
  ;; Load catppuccin theme only if in GUI
  (when (display-graphic-p)
    (load-theme 'catppuccin t))

  ;; Terminal face overrides to approximate Catppuccin palette
  (unless (display-graphic-p)
    (custom-set-faces
     ;; Default face
     '(default ((t (:foreground "#cdd6f4" :background "#1e1e2e"))))
     ;; Comments
     '(font-lock-comment-face ((t (:foreground "#585b70" :slant italic))))
     ;; Strings
     '(font-lock-string-face ((t (:foreground "#f5c2e7"))))
     ;; Keywords
     '(font-lock-keyword-face ((t (:foreground "#f38ba8" :weight bold))))
     ;; Functions
     '(font-lock-function-name-face ((t (:foreground "#89b4fa"))))
     ;; Variables
     '(font-lock-variable-name-face ((t (:foreground "#f9e2af"))))
     ;; Constants
     '(font-lock-constant-face ((t (:foreground "#fab387"))))
     ;; Types
     '(font-lock-type-face ((t (:foreground "#94e2d5"))))
     ;; Warnings and errors
     '(font-lock-warning-face ((t (:foreground "#f38ba8" :weight bold))))
     ;; Mode line (status bar)
     '(mode-line ((t (:background "#313244" :foreground "#cdd6f4"))))
     '(mode-line-inactive ((t (:background "#1e1e2e" :foreground "#585b70"))))
     ;; Minibuffer prompt
     '(minibuffer-prompt ((t (:foreground "#f38ba8" :weight bold))))
     )))

(provide 'theme)
;;; theme.el ends here
