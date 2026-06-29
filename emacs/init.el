;;; init.el -*- lexical-binding: t; -*-

;; Package management
(use-package package
  :ensure nil
  :config
  (setq package-archives
        '(("gnu-elpa" . "https://elpa.gnu.org/packages/")
          ("nongnu" . "https://elpa.nongnu.org/nongnu/")
          ("melpa" . "https://melpa.org/packages/")))
  (setq package-archive-priorities
        '(("gnu-elpa" . 3)
          ("nongnu" . 2)
          ("melpa" . 1))))

;; Emacs options
(use-package emacs
  :ensure nil
  :custom
  (make-backup-files nil)
  (create-lockfiles nil)
  (auto-save-default nil)
  (display-line-numbers-type 'relative)
	(column-number-mode t)
	(delete-selection-mode 1)
	(global-auto-revert-non-file-buffers t)
  (inhibit-splash-screen t)
  (inhibit-startup-message t)
  (initial-scratch-message "")
  (initial-major-mode 'fundamental-mode)
  (display-time-default-load-average t)
  (history-length 25)
  (pixel-scroll-precision-mode t)
  (pixel-scroll-precision-use-momentum nil)
  (ring-bell-function 'ignore)
  (split-width-threshold 300)
  (switch-to-buffer-obey-display-actions t)
  (indent-tabs-mode nil)
  (tab-always-indent 'complete)
  (tab-width 2)
  (treesit-font-lock-level 4)
  (truncate-lines t)
  (use-dialog-box nil)
  (use-short-answers t)
  (warning-minimum-level :emergency)
  (read-process-output-max (* 1024 1024))
  (package-quickstart t)
  (scroll-margin 5)
  :hook
  (prog-mode . display-line-numbers-mode)
  (before-save . delete-trailing-whitespace)
  :config
  ;; Fonts
  ;; Set your favourite font family and height here.  The :height is
  ;; 10x the point size you most commonly find on other applications.
  (set-face-attribute 'default nil :family "Iosevka Nerd Font" :height 160)
  ;; Set your favourite font for elements that are designed to always
  ;; be monospaced.  The height SHOULD BE a floating point, which is
  ;; interpreted as relative to the `default'.
  (set-face-attribute 'fixed-pitch nil :family "Iosevka Nerd Font" :height 1.0)
  ;; Same as above for proportionately spaced elements.  Make any
  ;; buffer proportionately spaced by enabling the `variable-pitch-mode'.
  ;;
  ;; [ NOTE: If you use the Modus themes or derivatives, set
  ;;   `modus-themes-mixed-fonts', load the theme for the option to
  ;;   take effect, and then enable `variable-pitch-mode':
  ;;   spacing-sensitive elements like Org tables and code blocks will
  ;;   remain monospaced. ]
  ;;(set-face-attribute 'variable-pitch nil :family "Iosevka Etoile" :height 1.0)
  (set-face-attribute 'variable-pitch nil :family "Fira Sans" :height 1.0)
  ;; Without the `custom-file', Emacs writes directly to the "init.el",
  ;; which can be confusing.
  (setq custom-file (locate-user-emacs-file "custom.el"))
  (load custom-file :no-error-if-file-is-missing)
  ;; Makes Emacs vertical divisor the symbol │ instead of |.
  (set-display-table-slot standard-display-table 'vertical-border (make-glyph-code ?│))
  :init
  (setq-default line-spacing 0)
  (electric-pair-mode 1)
  (add-hook 'emacs-startup-hook
    (lambda ()
      (when (< (length command-line-args) 2)
        (when-let (buf (get-buffer "*scratch*")) (kill-buffer buf))
        (condition-case nil
            (call-interactively #'tabspaces-open-or-create-project-and-workspace)
          (error (switch-to-buffer (get-buffer-create "*Messages*"))))
        (when-let (buf (get-buffer "*scratch*")) (kill-buffer buf))
        (run-with-idle-timer 0.5 nil
          (lambda ()
            (when-let (buf (get-buffer "*scratch*"))
              (kill-buffer buf)))))))
  (global-hl-line-mode -1)
  (global-auto-revert-mode 1)
  (recentf-mode 1)
  (savehist-mode 1)
  (save-place-mode 1)
  (winner-mode 1)
  (xterm-mouse-mode 1)
  (file-name-shadow-mode 1)
  ;; Set the default coding system for files to UTF-8.
  (modify-coding-system-alist 'file "" 'utf-8))

;; Dynamic GC: high threshold while active, collect during idle
(use-package gcmh
  :ensure t
  :hook (after-init . gcmh-mode)
  :custom
  (gcmh-idle-delay 5)
  (gcmh-high-cons-threshold (* 64 1024 1024)))

;; Themes
(setopt modus-themes-to-toggle '(modus-operandi-tinted modus-vivendi))
(load-theme 'modus-operandi-tinted :no-confirm)

(defun my/consult-workspace-buffers ()
  "Show only buffers in the current workspace."
  (interactive)
  (let ((consult-buffer-sources '(consult--source-workspace)))
    (consult-buffer)))

(defun my/kill-other-buffers ()
  "Kill all buffers except the current one."
  (interactive)
  (mapc #'kill-buffer (delq (current-buffer) (buffer-list))))

(defun my/eshell-toggle ()
  "Toggle an eshell window at the bottom of the frame."
  (interactive)
  (if-let (win (get-buffer-window "*eshell*"))
      (delete-window win)
    (let ((buf (get-buffer-create "*eshell*")))
      (display-buffer-in-side-window buf
        '((side . bottom) (window-height . 0.45)))
      (select-window (get-buffer-window buf))
      (unless (eq major-mode 'eshell-mode)
        (eshell)))))

;; Keybinding framework — provides my/leader-def with inline :which-key labels
(use-package general
  :ensure t
  :config
  (general-evil-setup t)
  (general-create-definer my/leader-def
    :states '(normal visual)
    :keymaps 'override
    :prefix "SPC"))

;; Evil mode
(use-package evil
  :ensure t
  :init
  (setq evil-want-integration t)
  (setq evil-want-keybinding nil)
  (setq evil-respect-visual-line-mode t)
  (setq evil-undo-system 'undo-redo)
  (setq evil-shift-width 2)
  (setq evil-want-C-u-scroll t)       ;; Makes C-u scroll
  (setq evil-want-C-u-delete t)       ;; Makes C-u delete on insert mode
  (setq evil-mode-line-format nil)    ;; Let doom-modeline handle evil state display
  :config
  (setq evil-want-fine-undo t)
  (evil-mode 1)
  ;; Leader bindings via general.el
  (my/leader-def
    ;; Top-level
    "SPC" '(my/consult-workspace-buffers :which-key "switch buffer")
    "/"   '(consult-line                :which-key "search buffer")
    ":"   '(execute-extended-command    :which-key "M-x")
    "."   '(embark-act                  :which-key "embark act")
    "f"   '(dirvish                     :which-key "files")
    "P"   '(consult-yank-from-kill-ring :which-key "yank ring")
    "u"   '(vundo                       :which-key "undo tree")

    ;; Buffers
    "b"   '(:ignore t                   :which-key "buffers")
    "bb"  '(my/consult-workspace-buffers :which-key "switch (workspace)")
    "ba"  '(consult-buffer              :which-key "switch (all)")
    "bl"  '(mode-line-other-buffer      :which-key "last buffer")
    "bi"  '(ibuffer                     :which-key "ibuffer")
    "bd"  '(kill-current-buffer         :which-key "kill this")
    "bk"  '(kill-current-buffer         :which-key "kill this")
    "bO"  '(my/kill-other-buffers       :which-key "kill others")
    "bs"  '(save-buffer                 :which-key "save")

    ;; Git
    "g"   '(:ignore t                   :which-key "git")
    "gg"  '(magit-status                :which-key "status")
    "gl"  '(magit-log-current           :which-key "log")
    "gd"  '(magit-diff-buffer-file      :which-key "diff file")

    ;; Help
    "h"   '(:ignore t             :which-key "help")
    "hm"  '(describe-mode         :which-key "mode")
    "hf"  '(describe-function     :which-key "function")
    "hv"  '(describe-variable     :which-key "variable")
    "hk"  '(describe-key          :which-key "key")

    ;; Project
    "p"   '(:ignore t                   :which-key "project")
    "pb"  '(consult-project-buffer      :which-key "buffers")
    "pp"  '(tabspaces-open-or-create-project-and-workspace :which-key "switch project")
    "pf"  '(my/dirvish-project          :which-key "files")
    "pg"  '(project-find-regexp         :which-key "grep")
    "pk"  '(project-kill-buffers        :which-key "kill buffers")
    "pD"  '(project-dired               :which-key "dired")

    ;; Search
    "s"   '(:ignore t             :which-key "search")
    "sf"  '(consult-find          :which-key "find file")
    "sg"  '(consult-grep          :which-key "grep")
    "sG"  '(consult-git-grep      :which-key "git grep")
    "sr"  '(consult-ripgrep       :which-key "ripgrep")
    "sh"  '(consult-info          :which-key "info")

    ;; Actions
    "x"   '(:ignore t             :which-key "actions")
    "xx"  '(consult-flymake       :which-key "errors")
    "xd"  '(dirvish               :which-key "dirvish")
    "xj"  '(dirvish-side          :which-key "side panel")
    "xf"  '(find-file             :which-key "find file")

    ;; Theme
    "t"   '(:ignore t               :which-key "theme")
    "tt"  '(modus-themes-toggle     :which-key "toggle light/dark")
    "ts"  '(consult-theme           :which-key "select theme")

    ;; Windows
    "w"   '(:ignore t                  :which-key "windows")
    "wd"  '(delete-window              :which-key "delete")
    "wo"  '(maximize-window             :which-key "maximize")
    "wO"  '(delete-other-windows       :which-key "delete others")
    "ws"  '(split-window-below         :which-key "split below")
    "wv"  '(split-window-right         :which-key "split right")
    "w="  '(balance-windows            :which-key "balance")
    "wr"  '(evil-window-rotate-downwards :which-key "rotate")
    "wh"  '(evil-window-left           :which-key "go left")
    "wj"  '(evil-window-down           :which-key "go down")
    "wk"  '(evil-window-up             :which-key "go up")
    "wl"  '(evil-window-right          :which-key "go right")
    "wH"  '(evil-window-move-far-left  :which-key "move left")
    "wJ"  '(evil-window-move-very-bottom :which-key "move down")
    "wK"  '(evil-window-move-very-top  :which-key "move up")
    "wL"  '(evil-window-move-far-right :which-key "move right")
    "wu"  '(winner-undo                :which-key "undo layout")
    "wU"  '(winner-redo                :which-key "redo layout")

    ;; Workspaces
    "TAB"   '(:ignore t                                          :which-key "workspaces")
    "TAB TAB" '(tabspaces-switch-or-create-workspace             :which-key "switch")
    "TAB l" '(tab-bar-switch-to-recent-tab                       :which-key "last")
    "TAB d" '(tabspaces-kill-buffers-close-workspace             :which-key "kill")
    "TAB k" '(tabspaces-kill-buffers-close-workspace             :which-key "kill")
    "TAB O" `(,(lambda () (interactive) (my/tabspaces-kill-other-workspaces)) :which-key "kill others")

    ;; Explorer
    "e"   '(:ignore t           :which-key "explorer")
    "ee"  '(neotree-toggle      :which-key "toggle")
    "ef"  '(neotree-find        :which-key "find file")

    ;; Open / tools
    "o"   '(:ignore t            :which-key "open")
    "oe"  '(my/eshell-toggle     :which-key "eshell")
    "oE"  '(eshell               :which-key "eshell (new)"))

  ;; Non-leader normal-state bindings
  (general-define-key
    :states 'normal
    "]b" 'switch-to-next-buffer
    "[b" 'switch-to-prev-buffer
    "]t" 'centaur-tabs-forward
    "[t" 'centaur-tabs-backward
    "]d" 'flymake-goto-next-error
    "[d" 'flymake-goto-prev-error
    "K"  'eldoc-box-help-at-point
    "C-h" 'evil-window-left
    "C-j" 'evil-window-down
    "C-k" 'evil-window-up
    "C-l" 'evil-window-right)

  ;; Comment operators
  (general-define-key
    :states 'normal
    "gcc" (lambda () (interactive)
            (comment-or-uncomment-region (line-beginning-position) (line-end-position))))
  (general-define-key
    :states 'visual
    "gc" (lambda () (interactive)
           (when (use-region-p)
             (comment-or-uncomment-region (region-beginning) (region-end)))))

  (add-hook 'git-commit-setup-hook 'evil-insert-state))

(use-package evil-collection
  :after evil
  :ensure t
  :custom
  ;; In REPL buffers (eshell etc.) submit the prompt with RET in *insert* state;
  ;; newline moves to normal state. Default is the reverse, which makes RET only
  ;; execute commands from normal mode. Must be set before evil-collection-init.
  (evil-collection-binding-overrides '((repl-submit  :state insert)
                                       (repl-newline :state normal)))
  :config
  (evil-collection-init))

(use-package vundo
  :ensure t
  :defer t)

;; Modeline
(use-package doom-modeline
  :ensure t
  :init (doom-modeline-mode 1)
  :custom
  (doom-modeline-height 24)
  (doom-modeline-bar-width 3)
  (doom-modeline-modal t)
  (doom-modeline-modal-icon t)
  (doom-modeline-major-mode-icon t)
  (doom-modeline-workspace-name nil)
  (doom-modeline-buffer-file-name-style 'file-name))

(use-package nyan-mode
  :ensure t
  :hook (after-init . nyan-mode)
  :custom
  (nyan-animate-nyancat nil)
  (nyan-wavy-trail nil))

(use-package hl-todo
  :ensure t
  :hook (after-init . global-hl-todo-mode)
  :custom
  (hl-todo-keyword-faces
   '(("TODO"       . "#ff9944")
     ("FIXME"      . "#ff4444")
     ("NOTE"       . "#44aaff")
     ("HACK"       . "#ff44ff")
     ("REVIEW"     . "#ffff44")
     ("DEPRECATED" . "#888888"))))

(use-package pulsar
  :ensure t
  :hook (after-init . pulsar-global-mode)
  :custom
  (pulsar-pulse t)
  (pulsar-delay 0.055)
  (pulsar-iterations 10)
  (pulsar-face 'pulsar-magenta)
  :config
  (dolist (fn '(evil-yank evil-yank-line))
    (add-to-list 'pulsar-pulse-functions fn)))

(use-package colorful-mode
  :ensure t
  :hook (after-init . global-colorful-mode)
  :custom
  (colorful-use-prefix t)
  (colorful-only-strings 'only-prog)
  (css-fontify-colors nil))

;; QoL features
(use-package which-key
  :ensure nil
  :hook
  (after-init . which-key-mode)
  (which-key-init-buffer . centaur-tabs-local-mode))

(use-package vertico
  :ensure t
  :hook
  (after-init . vertico-mode)
  :custom
  (vertico-count 10)
  (vertico-resize nil)
  (vertico-cycle nil)
  :config
  ;; Customize the display of the current candidate in the completion list.
  ;; This will prefix the current candidate with “» ” to make it stand out.
  (advice-add #'vertico--format-candidate :around
              (lambda (orig cand prefix suffix index _start)
                (setq cand (funcall orig cand prefix suffix index _start))
                (concat
                 (if (= vertico--index index)
                     (propertize "» " 'face '(:foreground "#80adf0" :weight bold))
                   "  ")
                 cand))))

(use-package savehist
  :init
  (savehist-mode))

(use-package marginalia
  :ensure t
  :hook
  (after-init . marginalia-mode))

(use-package orderless
  :ensure t
  :defer t
  :after vertico
  :init
  (setq completion-styles '(orderless basic)
        completion-category-defaults nil
        completion-category-overrides '((file (styles partial-completion)))))

(use-package consult
  :ensure t
  :defer t
  :bind (
         ;; Drop-in replacements
         ("C-x b" . consult-buffer)     ; orig. switch-to-buffer
         ("M-y"   . consult-yank-pop)   ; orig. yank-pop
         ;; Searching
         ("M-s r" . consult-ripgrep)
         ("M-s l" . consult-line)       ; Alternative: rebind C-s to use
         ("M-s s" . consult-line)       ; consult-line instead of isearch, bind
         ("M-s L" . consult-line-multi) ; isearch to M-s s
         ("M-s o" . consult-outline)
         ;; Isearch integration
         :map isearch-mode-map
         ("M-e" . consult-isearch-history)   ; orig. isearch-edit-string
         ("M-s e" . consult-isearch-history) ; orig. isearch-edit-string
         ("M-s l" . consult-line)            ; needed by consult-line to detect isearch
         ("M-s L" . consult-line-multi)      ; needed by consult-line to detect isearch
         )
  :config
  ;; Narrowing lets you restrict results to certain groups of candidates
  (setq consult-narrow-key "<"))

(use-package embark-consult
  :ensure t)

(use-package embark
  :ensure t
  :demand t
  :after (embark-consult)
  :bind (("C-c a" . embark-act))        ; bind this to an easy key to hit
  :init)

;; Modify search results en masse
(use-package wgrep
  :ensure t
  :config
  (setq wgrep-auto-save-buffer t))

(use-package project
  :ensure nil
  :custom
  (project-switch-commands 'project-find-file))

(use-package dirvish
  :ensure t
  :hook
  (after-init . dirvish-override-dired-mode)
  (dired-mode . centaur-tabs-local-mode)
  :custom
  (dirvish-default-layout '(0 0 0.7))
  ;; Rich per-file annotations: type icon, git state in the gutter, collapsed
  ;; single-child dirs, subtree arrows, last commit message, right-aligned
  ;; time/size, and a current-row highlight (global hl-line is disabled).
  (dirvish-attributes '(hl-line nerd-icons subtree-stage vc-state file-size))
  ;; Lighter set for the narrow side panel.
  (dirvish-side-attributes '(nerd-icons vc-state collapse))
  ;; Fancier mode line and header line.
  (dirvish-mode-line-format '(:left (sort symlink) :right (omit yank index)))
  (dirvish-header-line-format '(:left (path) :right (free-space)))
  (dirvish-preview-window-width 0.4)
  (delete-by-moving-to-trash t)
  (dired-listing-switches "-lAh --group-directories-first")
  (dired-dwim-target t)
  (dired-kill-when-opening-new-dired-buffer t)
  :config
  ;; This dirvish build (GNU/NonGNU ELPA, release-versioned) ships its
  ;; extensions under an `extensions/' subdir that package.el does NOT add to
  ;; `load-path'.  Without this, `dirvish-peek-mode'/`dirvish-side' and the
  ;; vc/icons/subtree/yank extensions are void; the void `(dirvish-peek-mode)'
  ;; below would then error and abort the rest of this :config block (which is
  ;; why the evil h/l/q bindings never took effect).
  (add-to-list 'load-path
               (expand-file-name "extensions"
                                 (file-name-directory (locate-library "dirvish"))))
  (require 'dirvish-peek)
  (require 'dirvish-side)
  (require 'dirvish-subtree)
  (dirvish-peek-mode)
  ;; Preview directories with `eza' (colored, icon-rich listing) instead of
  ;; dirvish's default plain dired text dump, which renders poorly.
  (when (executable-find "eza")
    (dirvish-define-preview eza (file)
      "Preview a directory with `eza'."
      (when (file-directory-p file)
        `(shell . ("eza" "-a" "--color=always" "--icons=always"
                   "--group-directories-first" ,file))))
    (add-to-list 'dirvish-preview-dispatchers 'eza))
  ;; Dirvish installs `dirvish-mode-map' as the buffer-local map (it merely
  ;; inherits `dired-mode-map' as a parent).  Both evil's overriding-map status
  ;; and its auxiliary keymaps key off the exact keymap object and do NOT follow
  ;; `set-keymap-parent' inheritance, so bindings placed on `dired-mode-map'
  ;; never apply in dirvish buffers — we must target `dirvish-mode-map' itself.
  ;; Register it as overriding so it beats evil-normal-state-map's h/l/q.
  (evil-make-overriding-map dirvish-mode-map 'normal)
  (evil-define-key* 'normal dirvish-mode-map
    (kbd "h")   #'dired-up-directory
    (kbd "l")   #'dired-find-file
    (kbd "q")   #'dirvish-quit
    (kbd "TAB") #'dirvish-subtree-toggle)
  ;; Dirvish calls `use-local-map' in `dirvish--setup-dired' AFTER evil has
  ;; already normalized this buffer's keymaps for `dired-mode-map', so evil
  ;; never promotes `dirvish-mode-map' into `evil-mode-map-alist' and
  ;; `evil-normal-state-map' keeps winning over h/l/q.  `dirvish-setup-hook'
  ;; is unreliable here because it runs from an async process sentinel
  ;; (`dirvish--dir-data-async'); instead re-normalize synchronously right
  ;; after dirvish installs its local map.
  (advice-add 'dirvish--setup-dired :after #'evil-normalize-keymaps)
  ;; Suppress centaur-tabs in dirvish preview windows.  Added globally,
  ;; `window-buffer-change-functions' calls its functions with the FRAME (not a
  ;; window), so we iterate the frame's windows: in any frame that contains a
  ;; dired/dirvish window, hide the tab bar in every non-dired window (i.e. the
  ;; preview pane, whatever buffer — eza listing, file content, image, …).
  (defun my/dirvish-hide-preview-tabs (frame-or-window)
    (let ((windows (cond ((framep frame-or-window) (window-list frame-or-window))
                         ((window-live-p frame-or-window) (list frame-or-window)))))
      (when (cl-some (lambda (w)
                       (with-current-buffer (window-buffer w)
                         (derived-mode-p 'dired-mode)))
                     windows)
        (dolist (w windows)
          (unless (window-minibuffer-p w)
            (with-current-buffer (window-buffer w)
              (when (and (not (derived-mode-p 'dired-mode))
                         (not (bound-and-true-p centaur-tabs-local-mode)))
                (centaur-tabs-local-mode 1))))))))
  (add-hook 'window-buffer-change-functions #'my/dirvish-hide-preview-tabs))

(defun my/dirvish-project ()
  "Open dirvish at the current buffer's directory."
  (interactive)
  (dirvish default-directory))

(defun my/tabspaces-kill-other-workspaces ()
  "Kill all workspaces and their buffers except the current one."
  (interactive)
  (let ((current (tab-bar--current-tab)))
    (dolist (tab (tab-bar-tabs))
      (unless (eq tab current)
        (let ((tab-name (alist-get 'name tab)))
          (tab-bar-select-tab-by-name tab-name)
          (tabspaces-kill-buffers-close-workspace))))))

(use-package tabspaces
  :ensure t
  :hook (after-init . tabspaces-mode)
  :custom
  (tabspaces-use-filtered-buffers-as-default t)
  (tabspaces-default-tab "Home")
  (tabspaces-remove-to-default t)
  (tabspaces-include-buffers '())
  (tabspaces-session nil)
  (tab-bar-new-tab-choice nil)
  (tab-bar-show nil)
  :config
  (with-eval-after-load 'consult
    (consult-customize consult--source-buffer :hidden t :default nil)
    (defvar consult--source-workspace
      (list :name "Workspace buffers"
            :narrow ?w
            :history 'buffer-name-history
            :category 'buffer
            :state #'consult--buffer-state
            :default t
            :items (lambda () (consult--buffer-query
                               :predicate #'tabspaces--local-buffer-p
                               :sort 'visibility
                               :as #'buffer-name)))
      "Workspace buffer source for consult.")
    (add-to-list 'consult-buffer-sources 'consult--source-workspace)))

(use-package centaur-tabs
  :ensure t
  :hook (after-init . centaur-tabs-mode)
  :custom
  (centaur-tabs-style "bar")
  (centaur-tabs-height 24)
  (centaur-tabs-set-icons t)
  (centaur-tabs-set-modified-marker t)
  (centaur-tabs-modified-marker "●")
  (centaur-tabs-close-button "×")
  (centaur-tabs-set-bar 'under)
  (x-underline-at-descent-line t)
  (centaur-tabs-show-new-tab-button nil)
  (centaur-tabs-excluded-prefixes '("*scratch" "*Messages" "*Warnings" "*Backtrace" "magit-" "COMMIT_EDITMSG" "*which-key*"))
  :config
  (defun my/centaur-tabs-buffer-groups ()
    (list (or (when-let* ((proj (project-current)))
                (file-name-nondirectory
                 (directory-file-name (project-root proj))))
              "Other")))
  (setq centaur-tabs-buffer-groups-function #'my/centaur-tabs-buffer-groups)
  (centaur-tabs-group-buffer-groups))

(use-package magit
  :ensure t
  :defer t
  :config
  ;; show fullscreen buffer
  (setq magit-display-buffer-function
        #'magit-display-buffer-same-window-except-diff-v1)
  ;; skip diff buffer before commit
  (setq magit-commit-show-diff nil)
  (setopt magit-format-file-function #'magit-format-file-nerd-icons)
  (add-to-list 'display-buffer-alist
    '("\\`magit-revision:"
      (display-buffer-in-direction)
      (direction . right)
      (window-width . 0.5))))

(use-package diff-hl
  :ensure t
  :hook
  (after-init          . global-diff-hl-mode)
  (magit-pre-refresh   . diff-hl-magit-pre-refresh)
  (magit-post-refresh  . diff-hl-magit-post-refresh)
  :config
  (diff-hl-flydiff-mode 1)
  (unless (display-graphic-p)
    (diff-hl-margin-mode 1)))

(use-package eldoc
  :ensure nil
  :config
  (setq eldoc-idle-delay 0)                  ;; Automatically fetch doc help
  (setq eldoc-echo-area-use-multiline-p nil) ;; We use the "K" floating help instead
  (setq eldoc-echo-area-display-truncation-message nil)
  :init
  (global-eldoc-mode))

(use-package eldoc-box
  :ensure t
  :defer t)

(use-package flymake
  :ensure nil
  :defer t
  :hook (prog-mode . flymake-mode)
  :custom
  (flymake-margin-indicators-string
   '((error "!»" compilation-error) (warning "»" compilation-warning)
     (note "»" compilation-info))))

(use-package org
  :ensure nil     ;; This is built-in, no need to fetch it.
  :defer t)

(use-package eglot
  :ensure nil
  :hook ((c-ts-mode c++-ts-mode go-ts-mode yaml-ts-mode bash-ts-mode python-ts-mode terraform-ts-mode) . eglot-ensure)
  :custom
  (eglot-events-buffer-size 0)
  (eglot-autoshutdown t)
  (eglot-report-progress nil)
  :config
  (setq-default eglot-workspace-configuration
    '(:yaml (:validate t
             :hover t
             :completion t
             :schemas (:additionalProperties t)))))

(add-hook 'go-ts-mode-hook
  (lambda ()
    (add-hook 'before-save-hook #'eglot-format-buffer nil t)))

(use-package ansible
  :ensure t
  :hook (yaml-ts-mode . ansible-auto-decrypt-encrypt))

(use-package flymake-ruff
  :ensure t
  :hook (python-ts-mode . flymake-ruff-load))

(setq treesit-language-source-alist
      '((bash "https://github.com/tree-sitter/tree-sitter-bash")
        (cmake "https://github.com/uyha/tree-sitter-cmake")
        (c "https://github.com/tree-sitter/tree-sitter-c")
        (cpp "https://github.com/tree-sitter/tree-sitter-cpp")
        (css "https://github.com/tree-sitter/tree-sitter-css")
        (elisp "https://github.com/Wilfred/tree-sitter-elisp")
        (gdscript "https://github.com/PrestonKnopp/tree-sitter-gdscript")
        (go "https://github.com/tree-sitter/tree-sitter-go")
        (gomod "https://github.com/camdencheek/tree-sitter-go-mod")
        (html "https://github.com/tree-sitter/tree-sitter-html")
        (hyprlang "https://github.com/tree-sitter-grammars/tree-sitter-hyprlang")
        (javascript "https://github.com/tree-sitter/tree-sitter-javascript" "master" "src")
        (json "https://github.com/tree-sitter/tree-sitter-json")
        (make "https://github.com/alemuller/tree-sitter-make")
        (markdown "https://github.com/ikatyang/tree-sitter-markdown")
        (python "https://github.com/tree-sitter/tree-sitter-python")
        (rust "https://github.com/tree-sitter/tree-sitter-rust")
        (toml "https://github.com/tree-sitter/tree-sitter-toml")
        (tsx "https://github.com/tree-sitter/tree-sitter-typescript" "master" "tsx/src")
        (typescript "https://github.com/tree-sitter/tree-sitter-typescript" "master" "typescript/src")
        (vue "https://github.com/ikatyang/tree-sitter-vue")
        (terraform "https://github.com/tree-sitter-grammars/tree-sitter-hcl.git")
        (dockerfile "https://github.com/camdencheek/tree-sitter-dockerfile")
        (yaml "https://github.com/ikatyang/tree-sitter-yaml")))

(setq major-mode-remap-alist
      '((yaml-mode . yaml-ts-mode)
        (go-mode . go-ts-mode)
        (sh-mode . bash-ts-mode)
        (c-mode . c-ts-mode)
        (c++-mode . c++-ts-mode)
        (css-mode . css-ts-mode)
        (python-mode . python-ts-mode)
        (mhtml-mode . html-ts-mode)
        (javascript-mode . js-ts-mode)
        (js-json-mode . json-ts-mode)
        (typescript-mode . typescript-ts-mode)
        (conf-toml-mode . toml-ts-mode)
        (gdscript-mode . gdscript-ts-mode)
        (terraform-mode . terraform-ts-mode)
        (dockerfile-mode . dockerfile-ts-mode)))


;; Or if there is no built in mode
(use-package cmake-ts-mode :ensure nil :mode ("CMakeLists\\.txt\\'" "\\.cmake\\'"))
(use-package dockerfile-mode :ensure t :defer t)
(use-package go-mod-ts-mode :ensure nil :mode "\\.mod\\'")
(use-package lua-ts-mode :ensure nil :mode "\\.lua\\'")
(use-package rust-ts-mode :ensure nil :mode "\\.rs\\'")
(use-package typescript-ts-mode :ensure nil :mode "\\.ts\\'")
(use-package tsx-ts-mode :ensure nil :mode "\\.tsx\\'")
(use-package yaml-ts-mode :ensure nil :mode ("\\.yaml\\'" "\\.yml\\'"))

(use-package corfu
  :ensure t
  :defer t
  :init
  (global-corfu-mode)
  (corfu-popupinfo-mode t)
  :custom
  (corfu-auto nil)                        ;; Only completes when hitting TAB
  ;; (corfu-auto-delay 0)                ;; Delay before popup (enable if corfu-auto is t)
  (corfu-auto-prefix 1)                  ;; Trigger completion after typing 1 character
  (corfu-quit-no-match t)                ;; Quit popup if no match
  (corfu-scroll-margin 5)                ;; Margin when scrolling completions
  (corfu-max-width 50)                   ;; Maximum width of completion popup
  (corfu-min-width 50)                   ;; Minimum width of completion popup
  (corfu-popupinfo-delay 0.5)            ;; Delay before showing documentation popup
  :config
  (add-to-list 'corfu-margin-formatters #'nerd-icons-corfu-formatter))

(use-package nerd-icons-corfu
  :ensure t
  :defer t
  :after (:all corfu))

(use-package nerd-icons
  :ensure t
  :defer t)

;; NOTE: `nerd-icons-dired' is intentionally NOT used.  With
;; `dirvish-override-dired-mode' every dired buffer is a dirvish buffer, and
;; dirvish's own `nerd-icons' attribute already draws the icons; enabling
;; `nerd-icons-dired-mode' on top of it renders a second, duplicated icon.

(use-package nerd-icons-completion
  :ensure t
  :after (:all nerd-icons marginalia)
  :config
  (nerd-icons-completion-mode)
  (add-hook 'marginalia-mode-hook #'nerd-icons-completion-marginalia-setup))

(use-package indent-guide
  :defer t
  :ensure t
  :hook
  (prog-mode . indent-guide-mode)  ;; Activate indent-guide in programming modes.
  :config
  (setq indent-guide-char ""))
  ;; (setq indent-guide-char "│"))

(use-package rainbow-delimiters
  :defer t
  :ensure t
  :hook
  (prog-mode . rainbow-delimiters-mode))

(use-package neotree
  :ensure t
  :defer t
  :custom
  (neo-window-width 30)
  (neo-smart-open t)
  (neo-theme (if (display-graphic-p) 'nerd-icons 'arrow))
  (neo-window-fixed-size nil)
  :config
  (evil-define-key 'normal neotree-mode-map
    (kbd "q")   #'neotree-hide
    (kbd "RET") #'neotree-enter
    (kbd "o")   #'neotree-enter
    (kbd "i")   #'neotree-enter-horizontal-split
    (kbd "s")   #'neotree-enter-vertical-split
    (kbd "r")   #'neotree-refresh
    (kbd "H")   #'neotree-hidden-file-toggle
    (kbd "n")   #'neotree-next-node
    (kbd "p")   #'neotree-previous-node))

(use-package terraform-mode
  :ensure t
  :custom
  (terraform-indent-level 4))

(use-package terraform-ts-mode
  :ensure nil
  :mode ("\\.tf\\'" "\\.tfvars\\'"))

(add-to-list 'auto-mode-alist '("\\.hcl\\'" . terraform-ts-mode))

(defun my/terragrunt-format-buffer ()
  "Format current .hcl buffer with `terragrunt hcl fmt'."
  (when (and buffer-file-name
             (string-match-p "\\.hcl\\'" buffer-file-name)
             (executable-find "terragrunt"))
    (shell-command (concat "terragrunt hcl fmt " (shell-quote-argument buffer-file-name)))
    (revert-buffer t t t)))

(add-hook 'terraform-ts-mode-hook
  (lambda ()
    (if (and buffer-file-name (string-match-p "\\.hcl\\'" buffer-file-name))
        (add-hook 'before-save-hook #'my/terragrunt-format-buffer nil t)
      (add-hook 'before-save-hook #'eglot-format-buffer nil t))))

(use-package markdown-mode
  :ensure t
  :defer t
  :mode ("\\.md\\'" "\\.markdown\\'")
  :custom
  (markdown-fontify-code-blocks-natively t)
  (markdown-command "pandoc")
  :hook
  (markdown-mode . visual-line-mode))

(use-package just-mode
  :ensure t
  :defer t)

(use-package make-mode
  :ensure nil
  :hook (makefile-mode . (lambda () (setq-local indent-tabs-mode t))))

(defun my/eshell-quit-or-delete-char (arg)
  "Delete a forward char, or at an empty prompt kill eshell and close its window.
This mirrors a terminal's C-d: end-of-file at an empty prompt closes the
session, otherwise it deletes the character under the cursor."
  (interactive "p")
  (if (string-empty-p (string-trim (or (eshell-get-old-input) "")))
      (let ((win (selected-window)))
        (kill-buffer)
        (when (window-live-p win) (ignore-errors (delete-window win))))
    (unless (eobp) (delete-char arg))))

(use-package eshell
  :ensure nil
  :custom
  (eshell-scroll-to-bottom-on-input t)
  (eshell-destroy-buffer-when-process-dies t)
  :hook
  (eshell-mode . evil-insert-state)
  :config
  ;; RET/<return> submission is handled by evil-collection (repl-submit, set to
  ;; insert state above). Here we only add C-d (evil's insert default is
  ;; evil-shift-left-line) and C-l, which evil-collection leaves untouched.
  (evil-define-key 'insert eshell-mode-map
    (kbd "C-d") #'my/eshell-quit-or-delete-char
    (kbd "C-l") #'eshell/clear-scrollback))
