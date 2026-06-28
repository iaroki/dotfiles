# Plan: Bring vanilla Emacs config to Doom parity

## Context

`init.el` has the right foundation (evil, consult stack, project.el, eglot, tree-sitter, magit). Tasks below are ordered by priority and can be applied one at a time. Each task is self-contained.

---

## Task 1 — GC & startup performance (`early-init.el` + `init.el`)

**`early-init.el`** — raise GC to max during startup, suppress file-name-handler overhead:

```elisp
(setq gc-cons-threshold most-positive-fixnum)

(defvar my/file-name-handler-alist file-name-handler-alist)
(setq file-name-handler-alist nil)
(add-hook 'emacs-startup-hook
  (lambda () (setq file-name-handler-alist my/file-name-handler-alist)))
```

Remove the existing flat `(setq gc-cons-threshold 10000000)` line.

**`init.el`** — add to `use-package emacs` `:custom`:

```elisp
(read-process-output-max (* 1024 1024)) ; 1MB — speeds up eglot/LSP
(package-quickstart t)                  ; precompute autoloads at install time
```

Add new package block after `use-package emacs`:

```elisp
(use-package gcmh
  :ensure t
  :hook (after-init . gcmh-mode)
  :custom
  (gcmh-idle-delay 5)
  (gcmh-high-cons-threshold (* 64 1024 1024)))
```

---

## Task 2 — Scroll margin & trailing whitespace (`init.el`)

Inside `use-package emacs`:

Add to `:custom`:
```elisp
(scroll-margin 5)
```

Add to `:hook`:
```elisp
(before-save . delete-trailing-whitespace)
```

---

## Task 3 — `electric-pair-mode` (`init.el`)

Inside `use-package emacs` `:init`:

```elisp
(electric-pair-mode 1)
```

---

## Task 4 — Keybinding organization with `general.el` (`init.el`)

**Problem**: prefix submenus in which-key show `+prefix` instead of category names. Keybindings are scattered across `define-prefix-command`, `evil-define-key`, `define-key`, and `which-key-add-key-based-replacements` calls — hard to extend.

**Solution**: replace the entire approach with `general.el`. Each binding carries its own `:which-key` label inline. Group prefixes use `:ignore t` to get a category name with no bound command. Adding or changing a binding is one line in one place.

**Add package** (before `use-package evil`):

```elisp
(use-package general
  :ensure t
  :config
  (general-evil-setup t)
  (general-create-definer my/leader-def
    :states '(normal visual)
    :keymaps 'override
    :prefix "SPC"))
```

**Replace** the entire contents of `use-package evil` `:config` (all `define-prefix-command`, `evil-define-key`, `define-key` calls) with a single `my/leader-def` block plus non-leader bindings:

```elisp
;; Leader bindings
(my/leader-def
  ;; Top-level
  "SPC" '(consult-buffer              :which-key "switch buffer")
  "/"   '(consult-line                :which-key "search buffer")
  ":"   '(execute-extended-command    :which-key "M-x")
  "."   '(embark-act                  :which-key "embark act")
  "f"   '(find-file                   :which-key "find file")
  "P"   '(consult-yank-from-kill-ring :which-key "yank ring")
  "u"   '(vundo                       :which-key "undo tree")

  ;; Buffers
  "b"   '(:ignore t             :which-key "buffers")
  "bb"  '(consult-buffer        :which-key "switch")
  "bl"  '(consult-buffer        :which-key "list")
  "bi"  '(ibuffer               :which-key "ibuffer")
  "bd"  '(kill-current-buffer   :which-key "kill")
  "bk"  '(kill-current-buffer   :which-key "kill")
  "bs"  '(save-buffer           :which-key "save")

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
  "pp"  '(project-switch-project      :which-key "switch project")
  "pf"  '(project-find-file           :which-key "find file")
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
  "xd"  '(dired                 :which-key "dired")
  "xj"  '(dired-jump            :which-key "dired jump")
  "xf"  '(find-file             :which-key "find file")

  ;; Workspaces — populated in Task 7 when tabspaces is added
  "TAB"     '(:ignore t         :which-key "workspaces"))

;; Non-leader normal-state bindings
(general-define-key
  :states 'normal
  "]b" 'switch-to-next-buffer
  "[b" 'switch-to-prev-buffer
  "]t" 'tab-next
  "[t" 'tab-previous
  "]d" 'flymake-goto-next-error
  "[d" 'flymake-goto-prev-error
  "K"  'eldoc-box-help-at-point)

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

;; git-commit starts in insert state
(add-hook 'git-commit-setup-hook 'evil-insert-state)

(evil-mode 1)
```

**Simplify `use-package which-key`**: remove all `which-key-add-key-based-replacements` calls — labels are now inline in `my/leader-def`. Keep only:

```elisp
(use-package which-key
  :ensure nil
  :hook (after-init . which-key-mode))
```

**Pattern for adding new bindings going forward**:
- New top-level command: one line in `my/leader-def` with `:which-key`
- New group: one `:ignore t` line for the prefix + one line per command
- Non-leader binding: one line in the appropriate `general-define-key` block

---

## Task 5 — Window navigation `C-h/j/k/l` (`init.el`)

Add to the `general-define-key :states 'normal` block from Task 4:

```elisp
"C-h" 'evil-window-left
"C-j" 'evil-window-down
"C-k" 'evil-window-up
"C-l" 'evil-window-right
```

`C-h` shadows the built-in help prefix — accepted trade-off (same as Doom).

---

## Task 6 — `vundo` visual undo tree (`init.el`)

New package block (place after `evil-collection`):

```elisp
(use-package vundo
  :ensure t
  :defer t)
```

The `"u" '(vundo :which-key "undo tree")` binding is already included in the `my/leader-def` block from Task 4.

---

## Task 7 — Project = Workspace (`tabspaces`) (`init.el`)

New package block (place after `magit`):

```elisp
(use-package tabspaces
  :ensure t
  :hook (after-init . tabspaces-mode)
  :custom
  (tabspaces-use-filtered-buffers-as-default t)
  (tabspaces-default-tab "Home")
  (tabspaces-remove-to-default t)
  (tabspaces-include-buffers '("*scratch*"))
  (tab-bar-new-tab-choice "*scratch*")
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
```

Extend `my/leader-def` with workspace bindings (replace the stub from Task 4):

```elisp
"TAB"     '(:ignore t                                            :which-key "workspaces")
"TAB TAB" '(tabspaces-switch-or-create-workspace                 :which-key "switch")
"TAB l"   '(tabspaces-switch-to-last-workspace                   :which-key "last")
"TAB n"   '(tabspaces-create-workspace                           :which-key "new")
"TAB d"   '(tabspaces-close-workspace                            :which-key "delete")
"TAB r"   '(tabspaces-rename-workspace                           :which-key "rename")
"TAB p"   '(tabspaces-open-or-create-project-and-workspace       :which-key "open project")
```

Also update `"pp"` in the project group to `tabspaces-open-or-create-project-and-workspace`.

---

## Task 8 — VC gutter `diff-hl` (`init.el`)

New package block (place after `magit`):

```elisp
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
```

---

## Task 9 — TODO highlighting `hl-todo` (`init.el`)

New package block (place with UI packages after `doom-modeline`):

```elisp
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
```

---

## Task 10 — Nav-flash `pulsar` (`init.el`)

New package block (place with UI packages):

```elisp
(use-package pulsar
  :ensure t
  :hook (after-init . pulsar-global-mode)
  :custom
  (pulsar-pulse t)
  (pulsar-delay 0.055)
  (pulsar-iterations 10)
  (pulsar-face 'pulsar-magenta))
```

---

## Task 11 — Color code highlighting `colorful-mode` (`init.el`)

New package block (place with UI packages):

```elisp
(use-package colorful-mode
  :ensure t
  :hook (after-init . global-colorful-mode)
  :custom
  (colorful-use-prefix t)
  (colorful-only-strings 'only-prog)
  (css-fontify-colors nil))
```

---

## Task 12 — Split config into modules

Create `lisp/` subdirectory under the emacs config dir. Move `use-package` blocks into themed files, each ending with `(provide 'my-<name>)`. `init.el` becomes a loader only.

**Target layout:**

```
emacs/
  early-init.el
  init.el            ; sets load-path, requires all modules
  custom.el
  lisp/
    my-core.el       ; use-package emacs, gcmh, encoding
    my-ui.el         ; theme, doom-modeline, nerd-icons, pulsar, hl-todo,
                     ;   colorful-mode, indent-guide, rainbow-delimiters
    my-evil.el       ; general.el, evil, evil-collection, all keybindings
    my-completion.el ; vertico, orderless, marginalia, consult,
                     ;   embark, wgrep, corfu, nerd-icons-corfu
    my-git.el        ; magit, diff-hl
    my-lsp.el        ; eglot, tree-sitter grammars, major-mode-remap-alist,
                     ;   ts-mode packages, flymake, eldoc, eldoc-box
    my-projects.el   ; project.el keybinds, tabspaces, dired, neotree
    my-org.el        ; org (optional, require only if needed)
```

**`init.el` after split:**

```elisp
;;; init.el -*- lexical-binding: t; -*-

(package-initialize)

(add-to-list 'load-path (expand-file-name "lisp" user-emacs-directory))

(require 'my-core)
(require 'my-ui)
(require 'my-evil)
(require 'my-completion)
(require 'my-git)
(require 'my-lsp)
(require 'my-projects)
;; (require 'my-org)
```

To disable a feature entirely: comment out the `require` line.

---

## Verification

| Task | Check |
|------|-------|
| 1  | `M-x emacs-init-time` — faster; no GC pauses while typing |
| 2  | Save file with trailing spaces — stripped; cursor stays 5 lines from edge |
| 3  | Type `(` — closing `)` inserted |
| 4  | `SPC b` shows "buffers", `SPC g` shows "git", etc. — no `+prefix` anywhere |
| 5  | Two splits open; `C-h/j/k/l` navigates between them |
| 6  | `SPC u` opens vundo tree buffer |
| 7  | `SPC TAB p` picks project → new named tab; `SPC TAB l` returns to previous; `SPC SPC` lists only workspace buffers |
| 8  | Edit tracked file → coloured bars appear in fringe |
| 9  | `TODO` in comment → highlighted orange |
| 10 | `G` to bottom → current line briefly flashes |
| 11 | `#ff0000` in a prog buffer → prefixed with coloured swatch |
| 12 | `M-x load-file init.el` — all modules load cleanly |
