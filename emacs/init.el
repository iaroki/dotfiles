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
(load-theme 'modus-operandi-tinted)
;; (load-theme 'modus-vivendi)

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
  :config
  ;; Set the leader key to space for easier access to custom commands. (setq evil-want-leader t)
  (setq evil-leader/in-all-states t)  ;; Make the leader key available in all states.
  (setq evil-want-fine-undo t)        ;; Evil uses finer grain undoing steps
  ;; Define the leader key as Space
  (evil-set-leader 'normal (kbd "SPC"))
  (evil-set-leader 'visual (kbd "SPC"))
  ;; Leader prefix maps keep grouped commands structured and easier to label.
  (define-prefix-command 'my/leader-buffer-map)
  (define-prefix-command 'my/leader-git-map)
  (define-prefix-command 'my/leader-help-map)
  (define-prefix-command 'my/leader-project-map)
  (define-prefix-command 'my/leader-search-map)
  (define-prefix-command 'my/leader-actions-map)
  (evil-define-key 'normal 'global (kbd "<leader> b") my/leader-buffer-map)
  (evil-define-key 'normal 'global (kbd "<leader> g") my/leader-git-map)
  (evil-define-key 'normal 'global (kbd "<leader> h") my/leader-help-map)
  (evil-define-key 'normal 'global (kbd "<leader> p") my/leader-project-map)
  (evil-define-key 'normal 'global (kbd "<leader> s") my/leader-search-map)
  (evil-define-key 'normal 'global (kbd "<leader> x") my/leader-actions-map)
  ;; Keybindings for searching and finding files.
  (evil-define-key 'normal 'global (kbd "<leader> :") 'execute-extended-command)
  (define-key my/leader-search-map (kbd "f") #'consult-find)
  (define-key my/leader-search-map (kbd "g") #'consult-grep)
  (define-key my/leader-search-map (kbd "G") #'consult-git-grep)
  (define-key my/leader-search-map (kbd "r") #'consult-ripgrep)
  (define-key my/leader-search-map (kbd "h") #'consult-info)
  (evil-define-key 'normal 'global (kbd "<leader> /") 'consult-line)
  ;; Flymake navigation
  (define-key my/leader-actions-map (kbd "x") #'consult-flymake) ;; Gives you something like `trouble.nvim'
  (evil-define-key 'normal 'global (kbd "] d") 'flymake-goto-next-error) ;; Go to next Flymake error
  (evil-define-key 'normal 'global (kbd "[ d") 'flymake-goto-prev-error) ;; Go to previous Flymake error
  ;; Dired commands for file management
  (define-key my/leader-actions-map (kbd "d") #'dired)
  (define-key my/leader-actions-map (kbd "j") #'dired-jump)
  (define-key my/leader-actions-map (kbd "f") #'find-file)
  (evil-define-key 'normal 'global (kbd "<leader> f") 'find-file)
  ;; Magit keybindings for Git integration
  (define-key my/leader-git-map (kbd "g") #'magit-status)      ;; Open Magit status
  (define-key my/leader-git-map (kbd "l") #'magit-log-current) ;; Show current log
  (define-key my/leader-git-map (kbd "d") #'magit-diff-buffer-file) ;; Show diff for the current file
  ;; Buffer management keybindings
  (evil-define-key 'normal 'global (kbd "] b") 'switch-to-next-buffer) ;; Switch to next buffer
  (evil-define-key 'normal 'global (kbd "[ b") 'switch-to-prev-buffer) ;; Switch to previous buffer
  (define-key my/leader-buffer-map (kbd "b") #'consult-buffer) ;; Open consult buffer list
  (define-key my/leader-buffer-map (kbd "i") #'ibuffer) ;; Open Ibuffer
  (define-key my/leader-buffer-map (kbd "d") #'kill-current-buffer) ;; Kill current buffer
  (define-key my/leader-buffer-map (kbd "k") #'kill-current-buffer) ;; Kill current buffer
  (define-key my/leader-buffer-map (kbd "x") #'kill-current-buffer) ;; Kill current buffer
  (define-key my/leader-buffer-map (kbd "s") #'save-buffer) ;; Save buffer
  (define-key my/leader-buffer-map (kbd "l") #'consult-buffer) ;; Consult buffer
  (evil-define-key 'normal 'global (kbd "<leader>SPC") 'consult-buffer) ;; Consult buffer
  ;; Project management keybindings
  (define-key my/leader-project-map (kbd "b") #'consult-project-buffer) ;; Consult project buffer
  (define-key my/leader-project-map (kbd "p") #'project-switch-project) ;; Switch project
  (define-key my/leader-project-map (kbd "f") #'project-find-file) ;; Find file in project
  (define-key my/leader-project-map (kbd "g") #'project-find-regexp) ;; Find regexp in project
  (define-key my/leader-project-map (kbd "k") #'project-kill-buffers) ;; Kill project buffers
  (define-key my/leader-project-map (kbd "D") #'project-dired) ;; Dired for project
  ;; Yank from kill ring
  (evil-define-key 'normal 'global (kbd "<leader> P") 'consult-yank-from-kill-ring)
  ;; Embark actions for contextual commands
  (evil-define-key 'normal 'global (kbd "<leader> .") 'embark-act)
  ;; Help keybindings
  (define-key my/leader-help-map (kbd "m") #'describe-mode) ;; Describe current mode
  (define-key my/leader-help-map (kbd "f") #'describe-function) ;; Describe function
  (define-key my/leader-help-map (kbd "v") #'describe-variable) ;; Describe variable
  (define-key my/leader-help-map (kbd "k") #'describe-key) ;; Describe key
  ;; Tab navigation
  (evil-define-key 'normal 'global (kbd "] t") 'tab-next) ;; Go to next tab
  (evil-define-key 'normal 'global (kbd "[ t") 'tab-previous) ;; Go to previous tab
  ;; If you use Magit, start editing in insert state
  (add-hook 'git-commit-setup-hook 'evil-insert-state)
  ;; Remap K to docs
  (evil-define-key 'normal 'global (kbd "K") 'eldoc-box-help-at-point)
  ;; Commenting functionality for single and multiple lines
  (evil-define-key 'normal 'global (kbd "gcc")
                   (lambda ()
                     (interactive)
                     (if (not (use-region-p))
                         (comment-or-uncomment-region (line-beginning-position) (line-end-position)))))
  (evil-define-key 'visual 'global (kbd "gc")
                   (lambda ()
                     (interactive)
                     (if (use-region-p)
                         (comment-or-uncomment-region (region-beginning) (region-end)))))
  ;; Enable evil mode
  (evil-mode 1))

(use-package evil-collection
  :after evil
  :ensure t
  :config
  (evil-collection-init))

;; Modeline
(use-package doom-modeline
  :ensure t
  :init (doom-modeline-mode 1))

;; QoL features
(use-package which-key
  :ensure nil
  :defer t
  :hook
  (after-init . which-key-mode)
  :config
  (which-key-add-key-based-replacements
    "SPC b" '("buffers" . "buffer commands")
    "SPC g" '("git" . "git commands")
    "SPC h" '("help" . "help commands")
    "SPC p" '("project" . "project commands")
    "SPC s" '("search" . "search commands")
    "SPC x" '("actions" . "action commands")))

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

(use-package dired
  :ensure nil
  :custom
  (dired-listing-switches "-lah --group-directories-first")
  (dired-dwim-target t)
  (dired-kill-when-opening-new-dired-buffer t))

(use-package magit
  :ensure t
  :defer t
  :config
  ;; show fullscreen buffer
  (setq magit-display-buffer-function
        #'magit-display-buffer-same-window-except-diff-v1)
  ;; skip diff buffer before commit
  (setq magit-commit-show-diff nil)
  (setopt magit-format-file-function #'magit-format-file-nerd-icons))

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
  :hook ((c-mode c++-mode ;; Autostart lsp servers for a given mode
                 go-mode
                 yaml-mode)
         . eglot-ensure)
  :custom
  ;; Good default
  (eglot-events-buffer-size 0) ;; No event buffers (LSP server logs)
  (eglot-autoshutdown t);; Shutdown unused servers.
  (eglot-report-progress nil) ;; Disable LSP server logs (Don't show lsp messages at the bottom, java)
  )

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
        ))


;; Or if there is no built in mode
(use-package cmake-ts-mode :ensure nil :mode ("CMakeLists\\.txt\\'" "\\.cmake\\'"))
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

(use-package nerd-icons-dired
  :ensure t
  :defer t
  :hook
  (dired-mode . nerd-icons-dired-mode))

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
  :custom
  (neo-show-hidden-files t)
  (neo-theme 'nerd)
  (neo-vc-integration '(face char))
  :defer t
  :config
  (setq neo-theme 'nerd-icons))

(use-package terraform-mode
  :ensure t
  :custom
  (terraform-indent-level 4))
