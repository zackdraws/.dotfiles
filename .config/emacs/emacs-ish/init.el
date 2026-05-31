;;; init.el --- iSH / iPhone Emacs config -*- lexical-binding: t; -*-

(setq inhibit-startup-screen t
      inhibit-startup-message t
      inhibit-startup-echo-area-message "ok"
      initial-major-mode 'fundamental-mode
      initial-scratch-message nil
      ring-bell-function 'ignore
      visible-bell t
      frame-title-format '((:eval default-directory))
      use-dialog-box nil
      use-file-dialog nil
      confirm-kill-processes nil
      backup-by-copying t
      create-lockfiles nil
      auto-save-default t
      auto-save-timeout 20
      auto-save-interval 200)

(defconst ok-ish-config-dir
  (file-name-directory (or load-file-name buffer-file-name)))

(defconst ok-ish-notes-dir
  (expand-file-name "~/.ok/ok/"))

(make-directory ok-ish-notes-dir t)
(make-directory (expand-file-name "backups/" user-emacs-directory) t)
(make-directory (expand-file-name "auto-save/" user-emacs-directory) t)

(setq backup-directory-alist
      `(("." . ,(expand-file-name "backups/" user-emacs-directory)))
      auto-save-file-name-transforms
      `((".*" ,(expand-file-name "auto-save/" user-emacs-directory) t)))

(prefer-coding-system 'utf-8)
(set-language-environment "UTF-8")
(setq-default indent-tabs-mode nil
              tab-width 4
              fill-column 80
              truncate-lines nil
              word-wrap t)

(when (fboundp 'tool-bar-mode) (tool-bar-mode -1))
(when (fboundp 'menu-bar-mode) (menu-bar-mode -1))
(when (fboundp 'scroll-bar-mode) (scroll-bar-mode -1))
(when (fboundp 'blink-cursor-mode) (blink-cursor-mode -1))
(when (fboundp 'global-display-line-numbers-mode)
  (global-display-line-numbers-mode 1))
(when (fboundp 'column-number-mode) (column-number-mode 1))
(when (fboundp 'global-visual-line-mode) (global-visual-line-mode 1))
(when (fboundp 'delete-selection-mode) (delete-selection-mode 1))
(when (fboundp 'cua-mode) (cua-mode 1))
(unless (display-graphic-p)
  (when (fboundp 'xterm-mouse-mode) (xterm-mouse-mode 1)))

(require 'dired-x nil t)
(require 'org)

(setq org-directory ok-ish-notes-dir
      org-default-notes-file (expand-file-name "inbox.org" ok-ish-notes-dir)
      org-agenda-files (list ok-ish-notes-dir)
      org-startup-with-inline-images t
      org-image-actual-width '(260)
      org-duration-format 'h:mm
      org-support-shift-select t
      org-return-follows-link t
      org-log-done 'time
      org-capture-templates
      '(("t" "Todo" entry
         (file+headline org-default-notes-file "Tasks")
         "* TODO %?\n  %U\n")
        ("n" "Note" entry
         (file+headline org-default-notes-file "Notes")
         "* %?\n  %U\n")))

(defun ok-open-notes-dir ()
  "Open the iSH notes directory."
  (interactive)
  (dired ok-ish-notes-dir))

(defun ok-new-note ()
  "Create a timestamped Org note in `ok-ish-notes-dir'."
  (interactive)
  (find-file (expand-file-name
              (format-time-string "%Y%m%d%H%M.org")
              ok-ish-notes-dir)))

(defun ok-load-ish-file (file)
  "Load FILE from the iSH Emacs config directory when present."
  (let ((path (expand-file-name file ok-ish-config-dir)))
    (when (file-exists-p path)
      (load-file path))))

(ok-load-ish-file "packages.el")
(ok-load-ish-file "theme.el")
(ok-load-ish-file "keybindings.el")

(provide 'init)
;;; init.el ends here
