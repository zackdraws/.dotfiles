;;; early-init.el --- Emacs early initialization

;; Increase garbage collection threshold to speed up startup
(setq gc-cons-threshold most-positive-fixnum)

;; Prevent package.el from initializing packages before init.el runs
(setq package-enable-at-startup nil)

;; Disable GUI elements early for faster startup and cleaner frame
(when (fboundp 'tool-bar-mode)
  (tool-bar-mode -1))

(when (fboundp 'menu-bar-mode)
  (menu-bar-mode -1))

(when (fboundp 'scroll-bar-mode)
  (scroll-bar-mode -1))

;; Optional: Set initial frame size here (width, height)
;; (setq initial-frame-alist '((width . 100) (height . 40)))

;; Optional: Disable splash screen early (also done in init.el)
(setq inhibit-startup-screen t
      inhibit-startup-message t
      initial-scratch-message nil)

(provide 'early-init)
;;; early-init.el ends here
