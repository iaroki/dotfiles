;;; $DOOMDIR/config.el -*- lexical-binding: t; -*-

;; Place your private configuration here! Remember, you do not need to run 'doom
;; sync' after modifying this file!

;; Some functionality uses this to identify you, e.g. GPG configuration, email
;; clients, file templates and snippets. It is optional.
(setq user-full-name "Maxim Sytntyk"
      user-mail-address "iaroki@proton.me")

;; Doom exposes five (optional) variables for controlling fonts in Doom:
;;
;; - `doom-font' -- the primary font to use
;; - `doom-variable-pitch-font' -- a non-monospace font (where applicable)
;; - `doom-big-font' -- used for `doom-big-font-mode'; use this for
;;   presentations or streaming.
;; - `doom-symbol-font' -- for symbols
;; - `doom-serif-font' -- for the `fixed-pitch-serif' face
;;
;; See 'C-h v doom-font' for documentation and more examples of what they
;; accept. For example:
;;
(setq doom-font (font-spec :family "Aporetic Sans Mono" :size 18)
     doom-variable-pitch-font (font-spec :family "Aporetic Serif" :size 18)
     doom-serif-font (font-spec :family "Aporetic Serif" :size 18)
     doom-big-font (font-spec :family "Aporetic Sans Mono" :size 24)
     doom-symbol-font (font-spec :family "Iosevka Nerd Font" :size 18))
(after! doom-themes
  (setq doom-themes-enable-bold t
        doom-themes-enable-italic t))
(custom-set-faces!
  '(font-lock-comment-face :slant italic)
  '(font-lock-keyword-face :slant italic))


;;
;; If you or Emacs can't find your font, use 'M-x describe-font' to look them
;; up, `M-x eval-region' to execute elisp code, and 'M-x doom/reload-font' to
;; refresh your font settings. If Emacs still can't find your font, it likely
;; wasn't installed correctly. Font issues are rarely Doom issues!

;; There are two ways to load a theme. Both assume the theme is installed and
;; available. You can either set `doom-theme' or manually load a theme with the
;; `load-theme' function. This is the default:
;; (setq doom-theme 'doom-one)
;; (setq doom-theme 'doom-one-black)
(setq doom-theme 'doom-gruvbox-soft)
;; (setq doom-theme 'doom-gruvbox-black)

;; This determines the style of line numbers in effect. If set to `nil', line
;; numbers are disabled. For relative line numbers, set this to `relative'.
(setq display-line-numbers-type 'relative)
(setq scroll-margin 5)

;; If you use `org' and don't want your org files in the default location below,
;; change `org-directory'. It must be set before org loads!
(setq org-directory "~/org/")

;; Configure Org
(after! org
  (setq
    ;; Specify where to load org agenda
    org-agenda-files '("~/org/")

    ;; Default file for notes
    org-default-notes-file (expand-file-name "notes.org" org-directory)

    ;; Change how some symbols appear
    org-ellipsis " ▼ "
    org-superstar-headline-bullets-list '("◉" "●" "○" "◆" "●" "○" "◆")
    org-superstar-item-bullet-alist '((?- . ?➤) (?+ . ?✦)) ; changes +/- symbols in item lists
    org-hide-emphasis-markers 1

    ;; Add timestamp to org DONE entries
    org-log-done 'time

    ;; Upper bound to table conversions, useful for babel results
    org-table-convert-region-max-lines 20000

    ;; Set up to do keywords
    org-todo-keywords        ; This overwrites the default Doom org-todo-keywords
      '((sequence
         "TODO(t)"           ; A task that is ready to be tackled
         "PROJ(p)"           ; A project that contains other tasks
         "WAIT(w)"           ; Something is holding up this task
         "|"                 ; The pipe necessary to separate "active" states and "inactive" states
         "DONE(d)"           ; Task has been completed
         "CANCELLED(c)" ))   ; Task has been cancelled

    ;; Customize tags
    org-tag-alist
      '((:startgroup)
       ; Put mutually exclusive tags here
       (:endgroup)
       ("@errand" . ?E)
       ("@home" . ?H)
       ("@work" . ?W)
       ("agenda" . ?a)
       ("planning" . ?p)
       ("publish" . ?P)
       ("batch" . ?b)
       ("note" . ?n)
       ("music" .?m)
       ("game" .?g)
       ("chore" .?c)
       ("idea" . ?i))

    ;; Only one space after a tag
    org-tags-column 0

    ;; Some basic UI flags
    org-src-fontify-natively t
    org-src-tab-acts-natively t
    org-confirm-babel-evaluate nil
    org-edit-src-content-indentation 0)

  (custom-set-faces!
    `((org-document-title)
      :foreground ,(face-attribute 'org-document-title :foreground)
      :height 1.5 :weight bold)
    `((org-level-1)
      :foreground ,(face-attribute 'outline-1 :foreground)
      :height 1.4 :weight bold)
    `((org-level-2)
      :foreground ,(face-attribute 'outline-2 :foreground)
      :height 1.3 :weight bold)
    `((org-level-3)
      :foreground ,(face-attribute 'outline-3 :foreground)
      :height 1.2 :weight bold)
    `((org-level-4)
      :foreground ,(face-attribute 'outline-4 :foreground)
      :height 1.1 :weight bold)
    `((org-level-5)
      :foreground ,(face-attribute 'outline-5 :foreground)
      :weight bold)))

  ;; Org Modern
  (with-eval-after-load 'org (global-org-modern-mode))
  (setq org-modern-hide-stars nil)
  (setq org-modern-star 'replace)

;; Org Modern Indent
(add-hook! 'org-mode-hook :append #'org-modern-indent-mode)

(use-package! mixed-pitch
  :hook (org-mode . mixed-pitch-mode)
  :hook ((org-mode      . mixed-pitch-mode)
         (org-roam-mode . mixed-pitch-mode))
  :config
  ;; Ensure that Org elements that should remain in a fixed-width font do so.
  (set-face-attribute 'org-code nil :inherit 'fixed-pitch)
  (set-face-attribute 'org-block nil :inherit 'fixed-pitch)
  ;; (set-face-attribute 'org-block-begin-line nil :inherit 'fixed-pitch)
  ;; (set-face-attribute 'org-block-end-line nil :inherit 'fixed-pitch)
  (setq mixed-pitch-set-height t))

(custom-set-faces
 '(markdown-header-face ((t (org-levelunction-name-face :weight bold :family "variable-pitch"))))
 '(markdown-header-face-1 ((t (:inherit markdown-header-face :height 1.7))))
 '(markdown-header-face-2 ((t (:inherit markdown-header-face :height 1.6))))
 '(markdown-header-face-3 ((t (:inherit markdown-header-face :height 1.5))))
 '(markdown-header-face-4 ((t (:inherit markdown-header-face :height 1.4))))
 '(markdown-header-face-5 ((t (:inherit markdown-header-face :height 1.3))))
 '(markdown-header-face-6 ((t (:inherit markdown-header-face :height 1.2)))))

;; Whenever you reconfigure a package, make sure to wrap your config in an
;; `after!' block, otherwise Doom's defaults may override your settings. E.g.
;;
;;   (after! PACKAGE
;;     (setq x y))
;;
;; The exceptions to this rule:
;;
;;   - Setting file/directory variables (like `org-directory')
;;   - Setting variables which explicitly tell you to set them before their
;;     package is loaded (see 'C-h v VARIABLE' to look up their documentation).
;;   - Setting doom variables (which start with 'doom-' or '+').
;;
;; Here are some additional functions/macros that will help you configure Doom.
;;
;; - `load!' for loading external *.el files relative to this one
;; - `use-package!' for configuring packages
;; - `after!' for running code after a package has loaded
;; - `add-load-path!' for adding directories to the `load-path', relative to
;;   this file. Emacs searches the `load-path' when you load packages with
;;   `require' or `use-package'.
;; - `map!' for binding new keys
;;
;; To get information about any of these functions/macros, move the cursor over
;; the highlighted symbol at press 'K' (non-evil users must press 'C-c c k').
;; This will open documentation for it, including demos of how they are used.
;; Alternatively, use `C-h o' to look up a symbol (functions, variables, faces,
;; etc).
;;
;; You can also try 'gd' (or 'C-c c d') to jump to their definition and see how
;; they are implemented.

;; (setq select-enable-clipboard nil)
;; (setq x-select-enable-clipboard nil)
;; (setq x-select-enable-primary nil)

;; Toggle Maximized window on startup
(add-to-list 'default-frame-alist '(undecorated . t))
(add-hook 'window-setup-hook #'toggle-frame-maximized)
;; Transparency Wayland (PGTK)
;; (set-frame-parameter nil 'alpha-background 100)
;; (add-to-list 'default-frame-alist '(alpha-background . 100))
;; (set-frame-parameter nil 'alpha-background 75)
;; (add-to-list 'default-frame-alist '(alpha-background . 75))
;; (set-frame-parameter nil 'alpha-background 25)
;; (add-to-list 'default-frame-alist '(alpha-background . 25))
;; Transparency (GTK)
;; (set-frame-parameter (selected-frame) 'alpha '(90 100))
;; (add-to-list 'default-frame-alist '(alpha 90 100))

;; Keymaps
(define-key evil-normal-state-map (kbd "C-h") 'evil-window-left)
(define-key evil-normal-state-map (kbd "C-j") 'evil-window-down)
(define-key evil-normal-state-map (kbd "C-k") 'evil-window-up)
(define-key evil-normal-state-map (kbd "C-l") 'evil-window-right)
(map! :leader
      :desc "Switch to last workspace"
      "TAB l" #'+workspace/other)
(map! :leader
      :desc "Kill current window"
      "w k" #'evil-window-delete)

;; Indent lines
(setq
   indent-bars-mode t
   indent-bars-color '(highlight :face-bg t :blend 0.1)
   indent-bars-treesit-support t
   indent-bars-treesit-wrap '((yaml
                             block_mapping_pair comment))
   indent-bars-pattern " . . . . . . . ." ; play with the number of dots for your usual font size
   indent-bars-width-frac 0.01
   indent-bars-pad-frac 0.01)

(use-package! colorful-mode
  :custom
  (colorful-use-prefix t)
  (colorful-only-strings 'only-prog)
  (css-fontify-colors nil)
  :config
  (global-colorful-mode t)
  (add-to-list 'global-colorful-modes 'helpful-mode))

(nyan-mode 1)
;; (setq nyan-animate-nyancat t)
;; (setq nyan-wavy-trail t)

;; (setq-default show-trailing-whitespace t)
(add-hook 'before-save-hook
          'delete-trailing-whitespace)

;; GPTel
(use-package! gptel
  :config
  (setq
   gptel-default-mode 'org-mode
   gptel-display-buffer-action 'display-buffer
   gptel-model 'qwen2.5-coder:latest
   gptel-backend (gptel-make-ollama "ollama"
                  :host "10.0.0.24:11434"
                  :stream t
                  :models '(qwen2.5-coder:latest
                            deepseek-r1:14b
                            deepseek-coder-v2:latest
                            llama3.2:latest starcoder2:7b)))
  (add-hook 'gptel-post-stream-hook 'gptel-auto-scroll)
  (add-hook 'gptel-post-response-functions 'gptel-end-of-response))
