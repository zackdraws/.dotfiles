;;; theme.el --- Terminal-friendly theme for iSH Emacs -*- lexical-binding: t; -*-

(if (and (display-graphic-p) (require 'catppuccin-theme nil t))
    (load-theme 'catppuccin t)
  (custom-set-faces
   '(default ((t (:foreground "#cdd6f4" :background "#1e1e2e"))))
   '(cursor ((t (:background "#f5e0dc"))))
   '(region ((t (:background "#45475a"))))
   '(minibuffer-prompt ((t (:foreground "#89b4fa" :weight bold))))
   '(font-lock-comment-face ((t (:foreground "#6c7086" :slant italic))))
   '(font-lock-string-face ((t (:foreground "#a6e3a1"))))
   '(font-lock-keyword-face ((t (:foreground "#cba6f7" :weight bold))))
   '(font-lock-function-name-face ((t (:foreground "#89b4fa"))))
   '(font-lock-variable-name-face ((t (:foreground "#f9e2af"))))
   '(font-lock-constant-face ((t (:foreground "#fab387"))))
   '(font-lock-type-face ((t (:foreground "#94e2d5"))))
   '(font-lock-warning-face ((t (:foreground "#f38ba8" :weight bold))))
   '(mode-line ((t (:background "#313244" :foreground "#cdd6f4"))))
   '(mode-line-inactive ((t (:background "#181825" :foreground "#7f849c"))))
   '(line-number ((t (:foreground "#6c7086" :background "#1e1e2e"))))
   '(line-number-current-line ((t (:foreground "#f9e2af" :background "#1e1e2e"))))))

(provide 'theme)
;;; theme.el ends here
