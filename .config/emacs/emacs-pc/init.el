;; ───────────────────────────────────────────────────────────
;; Bootstrap straight.el
;; ───────────────────────────────────────────────────────────

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

;; ───────────────────────────────────────────────────────────
;; Setup use-package with straight.el
;; ───────────────────────────────────────────────────────────

(straight-use-package 'use-package)
(setq straight-use-package-by-default t)
(setq use-package-always-defer t)

;; ───────────────────────────────────────────────────────────
;; UI and Startup Config
;; ───────────────────────────────────────────────────────────

(setq inhibit-startup-echo-area-message "tychoish"
      initial-major-mode 'fundamental-mode
      initial-scratch-message nil
      inhibit-startup-screen t
      inhibit-startup-message t
      initial-buffer-choice nil)

(desktop-save-mode -1)

(tool-bar-mode -1)
(menu-bar-mode -1)
(when (display-graphic-p)
  (scroll-bar-mode -1)
  (tool-bar-mode -1)
  (menu-bar-mode -1))

(setq visible-bell 1)
(setq frame-title-format '((:eval default-directory)))

;; Override empty startup echo area
(defun display-startup-echo-area-message () (message ""))

;; ───────────────────────────────────────────────────────────
;; Org Mode Settings
;; ───────────────────────────────────────────────────────────

(setq org-startup-with-inline-images t
      org-image-actual-width '(260)
      org-duration-format 'h:mm
      org-agenda-files '("~/.ok/ok")
      org-latex-listings 'minted)

;; ───────────────────────────────────────────────────────────
;; Load Packages and Keybindings
;; ───────────────────────────────────────────────────────────

(load-file (expand-file-name "packages.el" user-emacs-directory))
(load-file (expand-file-name "keybindings.el" user-emacs-directory))

;; ───────────────────────────────────────────────────────────
;; Startup Hook: Close unneeded buffers when launching from CLI
;; ───────────────────────────────────────────────────────────

(add-hook 'emacs-startup-hook
          (lambda ()
            (when command-line-args-left
              (mapc (lambda (buf)
                      (unless (or (buffer-file-name buf)
                                  (string= (buffer-name buf) "*Messages*"))
                        (kill-buffer buf)))
                    (buffer-list)))))
(load-file (expand-file-name "theme.el" user-emacs-directory))
