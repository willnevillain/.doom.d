;;; ~/.doom.d/config.el -*- lexical-binding: t; -*-

;; Place your private configuration here

;; Start in full screen by default
(toggle-frame-maximized)

;;;;
;; BEGIN: Org Mode
;;;;
(defvar dub/org-directory "~/Dropbox/org/")
(setq org-directory dub/org-directory)
(setq org-log-repeat "time")
(setq org-agenda-files (cons dub/org-directory '()))
(setq org-todo-keywords
      '((sequence "TODO(t)" "WAIT(w@/!)""DONE(d!)")))
(setq org-todo-keyword-faces
      '(("WAIT" . "yellow")))
(setq org-babel-load-languages
      (quote ((emacs-lisp . t)
              (python . t)
              (org . t))))
(after! org-capture
  (setq org-capture-templates
    '(("t" "Quick TODO" entry
        (file+headline "~/Dropbox/org/gtd.org" "Shortterm")
        "* TODO %?\nSCHEDULED: %t\nCaptured: %U\n")
      ("p" "Personal TODO" entry
        (file+headline "~/Dropbox/org/gtd.org" "Personal")
        "* TODO %?\nCaptured: %U\n")
      ("e" "Emacs Todo" entry
        (file+headline "~/Dropbox/org/gtd.org" "Emacs")
        "* TODO %?\nCaptured: %U\n")
      ("r" "Restaurant" entry
        (file+headline "~/Dropbox/org/lists.org" "Restaurants")
        "* UPCOMING %?\nCaptured: %U\nPrimary: \nRecommended Dishes: \nSource: \n")
      ("l" "Web Link" entry
        (file+headline "~/Dropbox/org/lists.org" "Internet Content")
        "* UPCOMING %:description\nCaptured: %U\n%:link\n")
      ("m" "Movie" entry
        (file+headline "~/Dropbox/org/lists.org" "Movies")
        "* UPCOMING %?\nCaptured: %U\nGist: \nSource: \n")
      ("s" "TV Show" entry
        (file+headline "~/Dropbox/org/lists.org" "TV Shows")
        "* UPCOMING %?\nCaptured: %U\nGist: \nSource: \n"))))

(defun dub/org-find-file ()
  "Quickly open a file in the org directory."
  (interactive)
  (counsel-file-jump "" dub/org-directory))

;; Bindings
(map!
 (:leader
   (:desc "orgmode" :prefix "O"
     :desc "Open org agenda" :n "a" #'org-agenda
     :desc "Open org file" :n "f" #'dub/org-find-file)))
;;;;
;; END: Org Mode
;;;;

;;;;
;; BEGIN: Projectile
;;;;
(after! projectile
  (setq projectile-project-search-path '("~/.emacs.d/"))
  (if (file-directory-p "~/.doom.d/")
      (add-to-list 'projectile-project-search-path "~/.doom.d/"))
  (if (file-directory-p "~/code/")
      (add-to-list 'projectile-project-search-path "~/code/"))
  (if (file-directory-p "~/dev/")
      (add-to-list 'projectile-project-search-path "~/dev/"))
  (add-to-list 'projectile-globally-ignored-directories "env")
  (add-to-list 'projectile-globally-ignored-directories ".venv"))
;;;;
;; END:  Projectile
;;;;

(after! lsp-mode
  (setq lsp-pyls-configuration-sources ["flake8" "pycodestyle"])
  (setq lsp-pyls-plugins-flake8-enabled t)
  (setq lsp-pyls-plugins-pylint-enabled nil)
  (setq lsp-pyls-plugins-pyflakes-enabled nil)
  (setq lsp-pyls-plugins-yapf-enabled nil)

  (setq lsp-language-id-configuration
        '((python-mode . "python")
          (typescript-mode . "typescript")
          (javascript-mode . "javascript")))

  (defun lsp-set-cfg ()
    (let ((lsp-cfg `(:pyls (:configurationSources ("flake8")))))
      (lsp--set-configuration lsp-cfg)))
  (add-hook 'lsp-mode-hook 'lsp-set-cfg))

(after! lsp-ui
  (setq lsp-prefer-flymake :none))

(add-hook 'typescript-mode-hook 'prettier-js-mode)

(defvar dub/olympus-env-dir "~/code/olympus/env")
(defun olympus-activate ()
  (interactive)
  (pyvenv-activate dub/olympus-env-dir)
  (setenv "VIRTUAL_ENV" dub/olympus-env-dir))

(setq company-idle-delay 0)
(setq company-minimum-prefix-length 1)
(setq company-selection-wrap-around t)
(setq company-global-modes (append company-global-modes '(org-mode)))

(setq typescript-indent-level 2)
(add-to-list 'auto-mode-alist '("\\.tsx\\'" . typescript-mode))
