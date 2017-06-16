(require 'package)

(add-to-list 'package-archives '("org" . "http://orgmode.org/elpa/"))
(add-to-list 'package-archives '("melpa" . "http://melpa.org/packages/"))
(add-to-list 'package-archives '("melpa-stable" . "http://stable.melpa.org/packages/"))

(setq package-enable-at-startup nil)
(package-initialize)
(require 'evil)
(evil-mode t)

(setq backup-directory-alist `(("." . "~/.saves")))
(load-theme `ujelly t)
(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(custom-safe-themes
   (quote
    ("f63388792c1cda0570e2fe60a22a82a592a4d064839dadb1840b6e206f4e4be3" default)))
 '(inhibit-startup-screen t))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )

(setq initial-major-mode 'lisp-interaction-mode)
(setq initial-scratch-message "\
;;   ___               _____
;;  / _ \\             |  ___|
;; / /_\\ \\  ___   ___ | |__   _ __ ___    __ _   ___  ___
;; |  _  | / __| / _ \\|  __| | '_ ` _ \\  / _` | / __|/ __|
;; | | | || (__ |  __/| |___ | | | | | || (_| || (__ \\__ \\
;; \\_| |_/ \\___| \\___|\\____/ |_| |_| |_| \\__,_| \\___||___/
")

(provide 'init)
(setq-default tab-width 4)
