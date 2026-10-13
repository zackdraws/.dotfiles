(setq package-enable-at-startup nil
      gc-cons-threshold most-positive-fixnum
      gc-cons-percentage 0.6)

(when (and (eq system-type 'windows-nt) (getenv "MSYSTEM"))
  (set-language-environment "UTF-8")
  (prefer-coding-system 'utf-8-unix)
  (set-default-coding-systems 'utf-8-unix)
  (set-terminal-coding-system 'utf-8-unix))

(setq visible-bell nil
      ring-bell-function #'ignore)

(defun ucrt64-decode-unicode-escapes (beg end)
  "Replace Unicode escape notation in the region with UTF-8 characters."
  (interactive "r")
  (save-excursion
    (goto-char beg)
    (while (re-search-forward "\\\\[uU]\\([[:xdigit:]]\\{4,8\\}\\)" end t)
      (let ((codepoint (string-to-number (match-string 1) 16)))
        (when (<= codepoint #x10FFFF)
          (replace-match (char-to-string codepoint) t t))))))

(global-set-key (kbd "C-c u") #'ucrt64-decode-unicode-escapes)

(add-hook 'emacs-startup-hook
          (lambda ()
            (setq gc-cons-threshold (* 16 1024 1024)
                  gc-cons-percentage 0.1)))
