;;; packages.el --- Optional packages for iSH Emacs -*- lexical-binding: t; -*-

(require 'package)

(setq package-archives
      '(("gnu" . "https://elpa.gnu.org/packages/")
        ("nongnu" . "https://elpa.nongnu.org/nongnu/")
        ("melpa" . "https://melpa.org/packages/")))

(package-initialize)

(defvar ok-ish-package-list
  '(ivy
    counsel
    company
    corfu
    cape
    fzf
    magit
    neotree
    dired-sidebar
    catppuccin-theme
    org-roam
    calfw
    calfw-org)
  "Packages that approximate the desktop Emacs setup on iSH.")

(defun ok-install-phone-packages ()
  "Install optional packages for the iSH Emacs config."
  (interactive)
  (unless package-archive-contents
    (package-refresh-contents))
  (dolist (pkg ok-ish-package-list)
    (unless (package-installed-p pkg)
      (condition-case err
          (package-install pkg)
        (error
         (message "Could not install %s: %s" pkg (error-message-string err)))))))

(defun ok-require (feature)
  "Require FEATURE without failing startup."
  (require feature nil t))

(when (ok-require 'ivy)
  (ivy-mode 1)
  (setq ivy-use-virtual-buffers t
        ivy-count-format "(%d/%d) "))

(when (ok-require 'counsel)
  (when (fboundp 'counsel-mode)
    (counsel-mode 1)))

(when (ok-require 'company)
  (when (fboundp 'global-company-mode)
    (global-company-mode 1)))

(when (ok-require 'corfu)
  (when (fboundp 'global-corfu-mode)
    (global-corfu-mode 1)))

(ok-require 'cape)
(ok-require 'fzf)
(ok-require 'magit)
(ok-require 'neotree)
(ok-require 'dired-sidebar)
(ok-require 'org-roam)
(ok-require 'calfw)
(ok-require 'calfw-org)

(provide 'packages)
;;; packages.el ends here
