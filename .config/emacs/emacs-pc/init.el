(when (and (eq system-type 'windows-nt) (getenv "MSYSTEM"))
  (set-language-environment "UTF-8")
  (prefer-coding-system 'utf-8-unix)
  (set-default-coding-systems 'utf-8-unix)
  (set-terminal-coding-system 'utf-8-unix))
(setq visible-bell nil
      ring-bell-function #'ignore)

(when (display-graphic-p)
  (set-fontset-font t 'emoji (font-spec :family "Segoe UI Emoji") nil 'prepend)
  (set-fontset-font t 'symbol (font-spec :family "Segoe UI Symbol") nil 'prepend)
  ;; Phonetic Extensions includes ᴗ (U+1D17), used in text faces such as •ᴗ•.
  (set-fontset-font t '(#x1D00 . #x1D7F)
                    (font-spec :family "Segoe UI") nil 'prepend))

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

(when (and (eq system-type 'windows-nt) (getenv "MSYSTEM"))
  (set-language-environment "UTF-8")
  (prefer-coding-system 'utf-8-unix)
  (set-default-coding-systems 'utf-8-unix)
  (set-terminal-coding-system 'utf-8-unix))

(setq visible-bell nil
      ring-bell-function #'ignore)

(defun ucrt64-decode-unicode-escapes (beg end)
  (interactive "r")
  (save-excursion
    (goto-char beg)
    (while (re-search-forward "\\\\[uU]\\([[:xdigit:]]\\{4,8\\}\\)" end t)
      (let ((codepoint (string-to-number (match-string 1) 16)))
        (when (<= codepoint #x10FFFF)
          (replace-match (char-to-string codepoint) t t))))))

(global-set-key (kbd "C-c u") #'ucrt64-decode-unicode-escapes)
(setq frame-title-format '((:eval default-directory)))

(defun display-startup-echo-area-message () (message ""))


(setq org-startup-with-inline-images t
      org-image-actual-width '(260)
      org-duration-format 'h:mm
      org-agenda-files '("~/.ok/ok")
      org-latex-listings 'minted)

(load-file (expand-file-name "packages.el" user-emacs-directory))
(load-file (expand-file-name "keybindings.el" user-emacs-directory))


(add-hook 'emacs-startup-hook
          (lambda ()
            (when command-line-args-left
              (mapc (lambda (buf)
                      (unless (or (buffer-file-name buf)
                                  (string= (buffer-name buf) "*Messages*"))
                        (kill-buffer buf)))
                    (buffer-list)))))
(load-file (expand-file-name "theme.el" user-emacs-directory))
