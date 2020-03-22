;;; init.el --- Emacs configuration of Radek Dymacz  -*- lexical-binding: t; -*-

;; Copyright (C) 2018  Radek Dymacz

;; Author: Radek Dymacz <radek@Radeks-MacBook-Pro-1168.local>
;; Keywords: conienience

;;; Commentary:

;;; Package setup

;;; Code:

;; Package configs


(require 'package)

(setq package-archives
      '(("GNU ELPA" . "http://elpa.gnu.org/packages/")
        ("MELPA"    . "http://melpa.org/packages/")
        ("ORG"      . "https://orgmode.org/elpa/")))

(package-initialize)

;; Bootstrap `use-package'

(unless (package-installed-p 'use-package)
  (package-refresh-contents)
  (package-install 'use-package))

;; PATH

(use-package exec-path-from-shell
  :ensure t
  :init
  (exec-path-from-shell-initialize))
(exec-path-from-shell-copy-env "GOPATH")


;;; Validation
(use-package validate                   ; Validate options
  :ensure t)

;;Customize look

(show-paren-mode 1)
(setq-default frame-title-format '("%f [%m]"))
(fset 'yes-or-no-p 'y-or-n-p)
(menu-bar-mode -1)
(tool-bar-mode -1)
(scroll-bar-mode -1)
(horizontal-scroll-bar-mode -1)
(tooltip-mode -1)
(global-set-key (kbd "C-x k") 'kill-this-buffer)


;;; Theme
(validate-setq custom-safe-themes t)    ; Treat themes as safe

(use-package color-theme-sanityinc-tomorrow ; Default theme
  :ensure t
  :config
  (load-theme 'sanityinc-tomorrow-night 'no-confirm))

(set-frame-font "Inconsolata 14")

(global-auto-revert-mode t)
(add-hook 'before-save-hook 'whitespace-cleanup)

(set-face-foreground 'vertical-border "#333")

(global-visual-line-mode nil)

(set-face-attribute 'fringe nil :background nil)


;; Disable annoying prompts
(setq-default read-answer-short t)
(validate-setq kill-buffer-query-functions
               (remq 'process-kill-buffer-query-function
                     kill-buffer-query-functions))

;; Disable startup messages
(validate-setq
 ring-bell-function #'ignore
 inhibit-startup-screen t
 initial-scratch-message nil)

;; Disable startup echo area message
(fset 'display-startup-echo-area-message #'ignore)

;; disable auto-save and auto-backup
(setq auto-save-default nil)
(setq make-backup-files nil)

;; switch windows
(global-set-key [M-left] 'windmove-left)          ; move to left window
(global-set-key [M-right] 'windmove-right)        ; move to right window
(global-set-key [M-up] 'windmove-up)              ; move to upper window
(global-set-key [M-down] 'windmove-down)          ; move to lower window


;;; Packages

;;; IVY
(use-package ivy
  :ensure t
  :config (setq ivy-use-selectable-prompt t)
  :init (ivy-mode 1))

(use-package counsel
  :ensure t
  :bind
  ("C-c i" . counsel-imenu)
  ("C-c s" . swiper)
  ("C-c g" . counsel-git-grep)
  ("C-x C-y" . counsel-yank-pop))

;; Projectile
(use-package projectile
  :ensure t
  :diminish projectile-mode
  :init (progn
          (setq projectile-completion-system 'ivy)
          (projectile-cleanup-known-projects)
          (define-key projectile-mode-map (kbd "s-p") 'projectile-command-map)
          (define-key projectile-mode-map (kbd "C-c p") 'projectile-command-map)
          (projectile-mode 1)))

;;Paredit
(use-package paredit
  :ensure t
  :diminish paredit-mode
  :init
  (add-hook 'clojure-mode-hook 'enable-paredit-mode)
  (add-hook 'cider-repl-mode-hook 'enable-paredit-mode)
  (add-hook 'lisp-mode-hook 'enable-paredit-mode)
  (add-hook 'emacs-lisp-mode-hook 'enable-paredit-mode)
  (add-hook 'lisp-interaction-mode-hook 'enable-paredit-mode)
  (add-hook 'ielm-mode-hook 'enable-paredit-mode)
  (add-hook 'json-mode-hook 'enable-paredit-mode))

;; Flycheck
(use-package flycheck
  :ensure t
  :init
  (progn
    (global-flycheck-mode nil))
  )

;; Magit
(use-package magit
  :ensure t
  :defer 2
  :bind (("C-x g" . magit-status)))



(use-package rainbow-delimiters
  :ensure t
  :config (add-hook 'prog-mode-hook #'rainbow-delimiters-mode))


;;; Markdown mode
(use-package markdown-mode
  :ensure t
  :mode (("README\\.md\\'" . gfm-mode)
         ("\\.md\\'" . markdown-mode)
         ("\\.markdown\\'" . markdown-mode))
  :init (setq markdown-command "multimarkdown"))


(use-package treemacs
  :ensure t
  :defer t
  :config
  (progn
    (setq treemacs-collapse-dirs                 (if (executable-find "python3") 3 0)
          treemacs-deferred-git-apply-delay      0.5
          treemacs-display-in-side-window        t
          treemacs-eldoc-display                 t
          treemacs-file-event-delay              5000
          treemacs-file-follow-delay             0.2
          treemacs-follow-after-init             t
          treemacs-git-command-pipe              ""
          treemacs-goto-tag-strategy             'refetch-index
          treemacs-indentation                   2
          treemacs-indentation-string            " "
          treemacs-is-never-other-window         nil
          treemacs-max-git-entries               5000
          treemacs-missing-project-action        'ask
          treemacs-no-png-images                 t
          treemacs-no-delete-other-windows       t
          treemacs-project-follow-cleanup        nil
          treemacs-persist-file                  (expand-file-name ".cache/treemacs-persist" user-emacs-directory)
          treemacs-recenter-distance             0.1
          treemacs-recenter-after-file-follow    nil
          treemacs-recenter-after-tag-follow     nil
          treemacs-recenter-after-project-jump   'always
          treemacs-recenter-after-project-expand 'on-distance
          treemacs-show-cursor                   nil
          treemacs-show-hidden-files             t
          treemacs-silent-filewatch              nil
          treemacs-silent-refresh                nil
          treemacs-sorting                       'alphabetic-desc
          treemacs-space-between-root-nodes      0
          treemacs-tag-follow-cleanup            t
          treemacs-tag-follow-delay              1.5
          treemacs-width                         35)

    ;; The default width and height of the icons is 22 pixels. If you are
    ;; using a Hi-DPI display, uncomment this to double the icon size.
    ;;(treemacs-resize-icons 44)

    (treemacs-follow-mode t)
    (treemacs-filewatch-mode t)
    (treemacs-fringe-indicator-mode t)
    (pcase (cons (not (null (executable-find "git")))
                 (not (null (executable-find "python3"))))
      (`(t . t)
       (treemacs-git-mode 'deferred))
      (`(t . _)
       (treemacs-git-mode 'simple))))
  :bind
  (:map global-map
        ("M-0"       . treemacs-select-window)
        ("C-x t 1"   . treemacs-delete-other-windows)
        ("C-x t t"   . treemacs)
        ("C-x t B"   . treemacs-bookmark)
        ("C-x t C-t" . treemacs-find-file)
        ("C-x t M-t" . treemacs-find-tag)))


(use-package treemacs-projectile
  :after treemacs projectile
  :ensure t)


(use-package rich-minority
  :ensure t
  :init (rich-minority-mode 1)
  :config (setq rm-blacklist ""))

(use-package diminish                   ; Hide modes in the mode-line
  :ensure t)

(use-package s
  :ensure t)

(use-package hydra
  :ensure t)

(use-package better-defaults
  :ensure t)

;; which key
(use-package which-key
  :ensure t
  :diminish which-key-mode
  :config
  (which-key-mode 1))

;; Expand snippets
(use-package yasnippet
  :ensure t
  :config
  (yas-global-mode 1)
  (yas-reload-all))

(use-package yasnippet-snippets
  :ensure t
  :after yasnippet
  :config (yasnippet-snippets-initialize))

(use-package go-snippets
  :ensure t)


(use-package clojure-snippets
  :ensure t)

(use-package restclient
  :ensure t)

;;; super key
;;(setq mac-option-modifier 'super)

;;; Clojure

(use-package cider
  :ensure t
  :config
  (setq cider-enhanced-cljs-completion-p nil)
  )


(use-package clj-refactor
  :ensure t
  )

(use-package flycheck-clj-kondo
  :ensure t)

;; then install the checker as soon as `clojure-mode' is loaded
(use-package clojure-mode
  :ensure t
  :config
  (require 'flycheck-clj-kondo))

;;; Go
(use-package go-mode
  :ensure t
  :init )

(use-package company-go
  :ensure t
  :init )

;;; JS React




;; json-mode: Major mode for editing JSON files with emacs
;; https://github.com/joshwnj/json-mode
(use-package json-mode
  :ensure t
  :mode "\\.js\\(?:on\\|[hl]int\\(rc\\)?\\)\\'"
  :config
  (add-hook 'json-mode-hook #'prettier-js-mode)
  (setq json-reformat:indent-width 2)
  (setq json-reformat:pretty-string? t)
  (setq js-indent-level 2))

(use-package company
  :diminish company-mode
  :defines (company-dabbrev-ignore-case company-dabbrev-downcase)
  :commands company-abort
  :bind (("M-/" . company-complete)
         ("<backtab>" . company-yasnippet)
         :map company-active-map
         ("C-p" . company-select-previous)
         ("C-n" . company-select-next)
         ("<tab>" . company-complete-common-or-cycle)
         ("<backtab>" . my-company-yasnippet)
         ;; ("C-c C-y" . my-company-yasnippet)
         :map company-search-map
         ("C-p" . company-select-previous)
         ("C-n" . company-select-next))
  :hook (after-init . global-company-mode)
  :init
  (defun my-company-yasnippet ()
    "Hide the current completeions and show snippets."
    (interactive)
    (company-abort)
    (call-interactively 'company-yasnippet))
  :config
  (setq company-tooltip-align-annotations t
        company-tooltip-limit 12
        company-idle-delay 0
        company-echo-delay (if (display-graphic-p) nil 0)
        company-minimum-prefix-length 2
        company-require-match nil
        company-dabbrev-ignore-case nil
        company-dabbrev-downcase nil)

  ;; Better sorting and filtering
  (use-package company-prescient
    :ensure t
    :init (company-prescient-mode 1))

  ;; Popup documentation for completion candidates

  (use-package company-quickhelp
    :ensure t
    :defines company-quickhelp-delay
    :bind (:map company-active-map
                ([remap company-show-doc-buffer] . company-quickhelp-manual-begin))
    :hook (global-company-mode . company-quickhelp-mode)
    :init (setq company-quickhelp-delay 0.5)))


;;;  Distraction free editing

;;; Olivetti
(use-package olivetti
  :ensure t
  :config
  (progn
    (setq-default olivetti-body-width 160)
    (visual-line-mode)))


(global-set-key (kbd "C-c o") 'olivetti-mode)

;;; Enable olivetti mode everywhere
(add-hook 'prog-mode-hook 'olivetti-mode)


(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(dart-format-on-save t t)
 '(js2-strict-missing-semi-warning nil)
 '(line-number-mode nil)
 '(package-selected-packages
   (quote
    (go-snippets js2-refactor js-comint eldoc-box company-quickhelp company-box company-prescient yasnippet-snippets dockerfile-mode docker olivetti virtualenvwrapper rich-minority python-pytest tide clj-refactor flycheck-clj-kondo js-react-redux-yasnippets company-tern prettier-js-mode emmet-mode add-node-modules-path web-mode company-terraform terraform-mode flutter dart-mode dap-java dap-mode lsp-java lsp-ui company-lsp lsp-mode github-theme ag neotree gist ob-sagemath elpy counsel spaceline-all-the-icons spaceline doom-themes omnibox elm-yasnippets ac-capf elm-mode org-plus-contrib json-mode yaml-mode clojure-snippets arjen-grey-theme go-guru restclient markdown-mode writeroom-mode multi-term google-this better-defaults ace-jump-mode popwin fill-column-indicator eyebrowse disable-mouse paredit-everywhere which-key go-direx treemacs-projectile treemacs multiple-cursors multiple-cursor go-eldoc company-go smart-mode-line github-modern-theme inf-clojure rainbow-identifiers rainbow-delimiters go-mode ac-dabbrev auto-complete color-theme-sanityinc-tomorrow powerline magit validate use-package shell-pop paredit helm-projectile helm-ag flycheck exec-path-from-shell diminish company cider)))
 '(safe-local-variable-values nil)
 '(send-mail-function (quote mailclient-send-it)))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )
 ;; Local Variables:
;; coding: utf-8
;; indent-tabs-mode: nil
;; End:

;;; init.el ends here
