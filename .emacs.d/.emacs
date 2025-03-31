(setq user-emacs-directory "C:/S/EM/.emacs" 
(load "C:/S/EM/init.el")     
(setq desktop-dirname "C:/S/EM/.emacs"  
(setq inhibit-startup-message t)   

(tool-bar-mode -1)        

(menu-bar-mode -1)     

(scroll-bar-mode -1)  

(setq frame-title-format "Emacs-C:/Users/Zacha/OneDrive/Desktop/emacs-29.1_2/bin/ C/Users/Zacha/.emacs")    

(global-hl-line-mode t) 
(line-number-mode t) 

(require 'package) 
(add-to-list 'package-archives '("melpa" . "https://melpa.org/packages/") t) 

(package-initialize) 


frame-title-format (%format "%s"s Emacs" (capitalize user-login-name) 
  
 
: (load-theme 'timu-macos )      

(global-set-key (kbd "C-c l") #'org-store-link)      
(global-set-key (kbd "C-c a") #'org-agenda) 
(global-set-key (kbd "C-c c") #'org-capture 

 '(cua-mode t) 
 '(org-agenda-files t)     
   
(setq org-agenda-files '("c:/S/EM/O"))    
 

(set-frame-font "fira code" nil t) 
 
(setq visible-bell t) 

(require 'use-package)  

(setq use-package-always-ensure t)    


(use-package command-log-mode) 

(desktop-save-mode 1)  

(desktop-read) 

(savehist-mode 1) 

(add-to-list 'savehist-additional-variables 'kill-ring) ;; for example 

