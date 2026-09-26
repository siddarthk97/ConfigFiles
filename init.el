;;; init.el --- Emacs config (Linux / WSL) -*- lexical-binding: t; -*-
;;; ---------------------------------------------------------------------
;;; Custom writes to its own file, never into this one
;;; ---------------------------------------------------------------------
(setq custom-file (expand-file-name "custom.el" user-emacs-directory))
(load custom-file 'noerror 'nomessage)
;;; ---------------------------------------------------------------------
;;; Packages
;;; ---------------------------------------------------------------------
(require 'package)
(add-to-list 'package-archives '("melpa" . "https://melpa.org/packages/") t)
(package-initialize)
;; Refresh manually with M-x package-refresh-contents when an install 404s —
;; MELPA deletes old snapshots, so a stale index points at missing files.
(unless package-archive-contents
  (package-refresh-contents))
(unless (require 'use-package nil 'noerror)
  (package-install 'use-package)
  (require 'use-package))
(setq use-package-always-ensure t)
;; Native compilation is noisy on first install; this keeps the warnings
;; in *Warnings* without popping the buffer open at you.
(setq native-comp-async-report-warnings-errors 'silent)
;;; ---------------------------------------------------------------------
;;; UI
;;; ---------------------------------------------------------------------
(when (fboundp 'menu-bar-mode)   (menu-bar-mode -1))
(when (fboundp 'tool-bar-mode)   (tool-bar-mode -1))
(when (fboundp 'scroll-bar-mode) (scroll-bar-mode -1))
(setq inhibit-startup-screen t
      ring-bell-function 'ignore
      use-short-answers t
      create-lockfiles nil
      scroll-conservatively 101
      scroll-margin 5)
(setq-default indent-tabs-mode nil)
;; Guarded — a missing font signals an error and kills the rest of the file
(when (member "JetBrains Mono" (font-family-list))
  (set-face-attribute 'default nil :family "JetBrains Mono" :height 140))
(use-package gruber-darker-theme
  :config
  (load-theme 'gruber-darker t))
;; 'relative == vim hybrid: the current line shows its absolute number.
;; Hooked rather than global, so no numbers in vterm, dired, magit or help.
(setq display-line-numbers-type 'relative)
(dolist (hook '(prog-mode-hook text-mode-hook conf-mode-hook))
  (add-hook hook #'display-line-numbers-mode))
;; Keep *~ and #file# out of working directories
(setq backup-directory-alist
      `(("." . ,(expand-file-name "backups/" user-emacs-directory)))
      auto-save-file-name-transforms
      `((".*" ,(expand-file-name "auto-save/" user-emacs-directory) t)))
(global-auto-revert-mode 1)
(save-place-mode 1)
(recentf-mode 1)
(savehist-mode 1)
(column-number-mode 1)
;; RET / ^ act like forward/back instead of piling up dired buffers
(setq dired-kill-when-opening-new-dired-buffer t)
;; Built in on Emacs 30+
(when (fboundp 'which-key-mode) (which-key-mode 1))
;;; ---------------------------------------------------------------------
;;; Evil
;;; ---------------------------------------------------------------------
(use-package evil
  :init
  (setq evil-want-integration t
        evil-want-keybinding nil        ; required by evil-collection
        evil-want-C-u-scroll t
        evil-want-C-i-jump t
        evil-undo-system 'undo-redo)
  :config
  (evil-mode 1))
(use-package evil-collection
  :after evil
  :config
  (evil-collection-init))
;; gcc, gc<motion>, gc in visual state, gy
(use-package evil-commentary
  :after evil
  :config
  (evil-commentary-mode 1))
(use-package evil-mc
  :after evil
  :config                               ; :config, not :init
  (global-evil-mc-mode 1)
  (set-face-attribute 'evil-mc-cursor-default-face nil
                      :background "#ffdd33" :foreground "black")
  (setq evil-mc-disabled-modes '(dired-mode))
  (add-to-list 'evil-mc-known-commands
             '(wdired--self-insert . ((:default . evil-mc-execute-call)))))
(dolist (state '(normal visual))
  (evil-define-key state 'global (kbd "grm") #'evil-mc-make-all-cursors)
  (evil-define-key state 'global (kbd "grn") #'evil-mc-make-and-goto-next-match)
  (evil-define-key state 'global (kbd "grp") #'evil-mc-make-and-goto-prev-match)
  (evil-define-key state 'global (kbd "grq") #'evil-mc-undo-all-cursors)
  (evil-define-key state 'global (kbd "grh") #'evil-mc-make-cursor-here))

(use-package evil-surround
  :ensure t
  :config
  (global-evil-surround-mode 1))
;;; ---------------------------------------------------------------------
;;; Completion
;;; ---------------------------------------------------------------------
(use-package vertico
  :init
  (setq vertico-count 12
        vertico-resize nil)
  (vertico-mode 1))
(use-package marginalia
  :init (marginalia-mode 1))
(use-package orderless
  :init
  (setq completion-styles '(orderless basic)
        completion-category-overrides
        '((file (styles basic partial-completion)))))
;; Child frames need a GUI — does nothing under emacs -nw
(use-package vertico-posframe
  :after vertico
  :if (display-graphic-p)
  :config
  (setq vertico-posframe-poshandler #'posframe-poshandler-frame-center
        vertico-posframe-width 120
        vertico-posframe-height 20
        vertico-posframe-border-width 2
        vertico-posframe-parameters '((left-fringe . 8) (right-fringe . 8)))
  (vertico-posframe-mode 1))
;;; ---------------------------------------------------------------------
;;; Org
;;; ---------------------------------------------------------------------
(setq org-directory "~/notes"
      org-startup-indented t
      org-log-done 'time)
;; Agenda. Only headings with a TODO keyword appear; give one a date with
;; C-c C-s (schedule) or C-c C-d (deadline) to show in the calendar view.
;; Pointing at a directory scans .org files directly inside it, NOT
;; recursively.
(setq org-agenda-files '("~/notes")
      org-agenda-span 'week
      org-agenda-start-on-weekday 1
      org-agenda-skip-scheduled-if-done t
      org-agenda-skip-deadline-if-done t
      org-deadline-warning-days 5
      org-agenda-window-setup 'current-window)
(setq org-todo-keywords
      '((sequence "TODO(t)" "NEXT(n)" "WAIT(w)" "|" "DONE(d)" "CANCELLED(c)")))
(keymap-global-set "C-c a" #'org-agenda)
;; Deferred — at top level this forces org to load on every startup
(with-eval-after-load 'org
  (org-babel-do-load-languages
   'org-babel-load-languages
   '((python . t) (shell . t) (emacs-lisp . t)))
  (setq org-confirm-babel-evaluate nil
        org-babel-python-command "python3"))
(use-package evil-org
  :after org
  :hook (org-mode . evil-org-mode)
  :config
  (evil-org-set-key-theme
   '(navigation insert textobjects additional shift todo heading))
  (require 'evil-org-agenda)
  (evil-org-agenda-set-keys))
;;; ---------------------------------------------------------------------
;;; Tools
;;; ---------------------------------------------------------------------
(use-package magit
  :commands (magit-status magit-blame magit-log-all)
  :config
  (setq magit-display-buffer-function
        #'magit-display-buffer-fullframe-status-v1))
(keymap-global-set "C-c g" #'magit-status)
;; Needs cmake and libtool installed; compiles a native module on first run
(use-package vterm
  :commands vterm
  :custom (vterm-always-compile-module t)
  :config
  (setq vterm-max-scrollback 10000))
;; The usual TRAMP hang is a fancy prompt in the REMOTE shell rc file.
;; TRAMP sets TERM=dumb, so bail out early there:
;;   [[ $TERM == "dumb" ]] && unsetopt zle && PS1='$ ' && return
(use-package tramp
  :ensure nil                           ; built in
  :config
  (setq tramp-default-method "ssh"
        tramp-verbose 1)                ; raise to 6 to debug
  (setq vc-ignore-dir-regexp
        (format "\\(%s\\)\\|\\(%s\\)"
                vc-ignore-dir-regexp tramp-file-name-regexp)))

;; -------------------------------------------------------------
;; Programming modes
;; -------------------------------------------------------------
;; YAML mode
(use-package yaml-mode
  :ensure t
  :mode ("\\.yml\\'" "\\.yaml\\'"))

;; PDF Tools
(use-package pdf-tools
  :magic ("%PDF" . pdf-view-mode)
  :config
  (pdf-tools-install :no-query))

;; Rust mode
(use-package rust-mode
  :mode ("\\.rs\\'"))

;;; ---------------------------------------------------------------------
;;; Keybindings
;;;
;;; Normal state only, never global-set-key: insert state and the
;;; minibuffer need C-a / C-k / C-j for their Emacs defaults, and the
;;; minibuffer has no evil at all.
;;; ---------------------------------------------------------------------
(defun my/find-file-dwim ()
  "Find a file in the current project, or in the current directory."
  (interactive)
  (if (project-current)
      (project-find-file)
    (call-interactively #'find-file)))
(evil-define-key 'normal 'global (kbd "C-j") #'my/find-file-dwim)
(evil-define-key 'normal 'global (kbd "C-k") #'switch-to-buffer)
(evil-define-key 'normal 'global (kbd "C-a") #'project-find-regexp)
(evil-define-key 'normal 'global (kbd "-")   #'dired-jump)
;;; ---------------------------------------------------------------------
;;; Mode overrides — MUST come after evil-collection-init
;;;
;;; Keymap precedence, roughly:
;;;   evil state maps > minor mode maps > major mode maps > global map
;;; evil-collection installs normal-state bindings INTO mode maps, so a
;;; plain global binding loses to them. When C-j or C-k stops working in
;;; some mode: C-h k to find the map, then add a line below.
;;; ---------------------------------------------------------------------
(defun my/rebind-nav-keys (map)
  "Restore C-j and C-k in MAP, normal state."
  (evil-define-key* 'normal map (kbd "C-j") #'my/find-file-dwim)
  (evil-define-key* 'normal map (kbd "C-k") #'switch-to-buffer))
(with-eval-after-load 'org   (my/rebind-nav-keys org-mode-map))
(with-eval-after-load 'term  (my/rebind-nav-keys term-mode-map))
(with-eval-after-load 'vterm (my/rebind-nav-keys vterm-mode-map))
(with-eval-after-load 'magit (my/rebind-nav-keys magit-status-mode-map))

(keymap-global-set "M-u" #'universal-argument)
