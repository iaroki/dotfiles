# Plan: Bring vanilla Emacs config to Doom parity

## Context

`init.el` has the right foundation (evil, consult stack, project.el, eglot, tree-sitter, magit). Tasks below are ordered by priority and can be applied one at a time. Each task is self-contained.

## Guiding principles

- **Tree-sitter everywhere**: every language that has a tree-sitter grammar should use the `*-ts-mode` variant. Add grammars to `treesit-language-source-alist` and remaps to `major-mode-remap-alist`. Never add a legacy mode config when a ts-mode exists.
- **Eglot for LSP**: eglot is the only LSP client — no lsp-mode, no lsp-bridge. If a language has an LSP server available, wire it up via eglot. Prefer eglot's built-in server detection (it reads `eglot-server-programs`) over manual configuration where possible.
- **No external formatters unless eglot can't**: use `eglot-format-buffer` on save. Only fall back to a standalone formatter hook (e.g. gofmt, shfmt) if the LSP server does not provide formatting for that language.

---

## ~~Task 1 — GC & startup performance (`early-init.el` + `init.el`)~~ ✓

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

## ~~Task 2 — Scroll margin & trailing whitespace (`init.el`)~~ ✓

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

## ~~Task 3 — `electric-pair-mode` (`init.el`)~~ ✓

Inside `use-package emacs` `:init`:

```elisp
(electric-pair-mode 1)
```

---

## ~~Task 4 — Keybinding organization with `general.el` (`init.el`)~~ ✓

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

## ~~Task 5 — Window navigation `C-h/j/k/l` (`init.el`)~~ ✓

Add to the `general-define-key :states 'normal` block from Task 4:

```elisp
"C-h" 'evil-window-left
"C-j" 'evil-window-down
"C-k" 'evil-window-up
"C-l" 'evil-window-right
```

`C-h` shadows the built-in help prefix — accepted trade-off (same as Doom).

---

## ~~Task 6 — `vundo` visual undo tree (`init.el`)~~ ✓

New package block (place after `evil-collection`):

```elisp
(use-package vundo
  :ensure t
  :defer t)
```

The `"u" '(vundo :which-key "undo tree")` binding is already included in the `my/leader-def` block from Task 4.

---

## ~~Task 7 — Project = Workspace (`tabspaces`) (`init.el`)~~ ✓

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

## ~~Task 8 — VC gutter `diff-hl` (`init.el`)~~ ✓

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

## ~~Task 8b — Modeline tidy-up (`init.el`)~~ ✓

**Goal**: 24px height matching centaur-tabs, evil state first, `<parent>/project/.../file` with highlighted project+filename and truncated middle path, then nyan-mode bar, then existing doom-modeline segments.

**Step 1** — update `use-package doom-modeline` `:custom`:

```elisp
(doom-modeline-height 24)
(doom-modeline-bar-width 3)
(doom-modeline-modal t)
(doom-modeline-modal-icon nil)          ; show text (INSERT/NORMAL) not icon
(doom-modeline-project-detection 'project)
(doom-modeline-buffer-file-name-style 'truncate-with-project)
(doom-modeline-major-mode-icon t)
```

`truncate-with-project` produces `project/…/filename` — truncates the middle path, always shows project name and filename.

To get `<parent>/project` as the project label (showing one parent dir), add a custom project name function:

```elisp
:config
(defun my/doom-modeline-project-name ()
  "Show <parent>/project-name in modeline."
  (when-let* ((root (project-root (project-current)))
              (name (file-name-nondirectory (directory-file-name root)))
              (parent (file-name-nondirectory
                       (directory-file-name (file-name-directory
                                             (directory-file-name root))))))
    (concat parent "/" name)))
(setq doom-modeline-project-name-function #'my/doom-modeline-project-name)
```

**Step 2** — add `nyan-mode` and wire it into the modeline:

```elisp
(use-package nyan-mode
  :ensure t
  :after doom-modeline
  :custom
  (nyan-animate-nyancat t)
  (nyan-wavy-trail t)
  :config
  (nyan-mode 1))
```

Then define a custom modeline segment and redefine the main modeline to place nyan after the file info:

```elisp
(doom-modeline-def-segment my/nyan
  "Nyan cat position indicator."
  (when (bound-and-true-p nyan-mode)
    (list " " (nyan-create) " ")))

(doom-modeline-def-modeline 'my/main
  '(bar modal buffer-info remote-host buffer-position my/nyan selection-info)
  '(misc-info minor-modes input-method buffer-encoding major-mode process vcs checker))

(add-hook 'doom-modeline-mode-hook
  (lambda () (doom-modeline-set-modeline 'my/main t)))
```

---

## ~~Task 9 — TODO highlighting `hl-todo` (`init.el`)~~ ✓

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

## ~~Task 10 — Nav-flash `pulsar` (`init.el`)~~ ✓

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

## ~~Task 11 — Color code highlighting `colorful-mode` (`init.el`)~~ ✓

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

## ~~Task 12 — Go (`init.el`)~~ ✓

**Bug fix**: eglot is currently hooked on `go-mode`, but `major-mode-remap-alist` remaps it to `go-ts-mode` — so the `go-mode-hook` never fires and eglot never starts. This affects all remapped modes. Fix the eglot `:hook` to use ts-mode variants:

```elisp
:hook ((c-ts-mode c++-ts-mode go-ts-mode yaml-ts-mode) . eglot-ensure)
```

Add gofmt on save:

```elisp
(add-hook 'go-ts-mode-hook
  (lambda ()
    (add-hook 'before-save-hook #'eglot-format-buffer nil t)))
```

LSP server: `go install golang.org/x/tools/gopls@latest`

---

## ~~Task 13 — YAML — ansible / kubernetes / helm (`init.el`)~~ ✓

YAML is already remapped to `yaml-ts-mode` and covered by the eglot hook fix in Task 12.

Add schema-aware configuration for `yaml-language-server`. Place in `use-package eglot` `:config`:

```elisp
(setq-default eglot-workspace-configuration
  '(:yaml (:validate t
           :hover t
           :completion t
           :schemas {"https://json.schemastore.org/ansible-playbook.json"
                     "/playbooks/*.yml"
                     "https://raw.githubusercontent.com/yannh/kubernetes-json-schema/master/v1.29.0-standalone-strict/all.json"
                     "/*.yaml"})))
```

LSP server: `npm install -g yaml-language-server`

For Ansible files specifically, add `ansible-mode` to detect playbook/role structure:

```elisp
(use-package ansible
  :ensure t
  :hook (yaml-ts-mode . ansible-auto-decrypt-encrypt))
```

---

## ~~Task 14 — Shell scripts (`init.el`)~~ ✓

Shell files are remapped to `bash-ts-mode` via `major-mode-remap-alist`. Add `bash-ts-mode` to eglot hooks (covered in Task 12 fix — extend the hook list):

```elisp
:hook ((c-ts-mode c++-ts-mode go-ts-mode yaml-ts-mode bash-ts-mode) . eglot-ensure)
```

LSP server: `npm install -g bash-language-server`

Add shfmt formatting on save:

```elisp
(add-hook 'bash-ts-mode-hook
  (lambda ()
    (add-hook 'before-save-hook #'eglot-format-buffer nil t)))
```

shfmt must be installed: `go install mvdan.cc/sh/v3/cmd/shfmt@latest`

---

## ~~Task 15 — Python (`init.el`)~~ ✓

Add `python-ts-mode` to the eglot hook list. No remap needed — Python ts-mode is already in `major-mode-remap-alist`.

```elisp
:hook ((... python-ts-mode) . eglot-ensure)
```

LSP server (pyright): `pip install pyright` or `npm install -g pyright`

Add ruff for fast linting via flymake (optional, alongside eglot):

```elisp
(use-package flymake-ruff
  :ensure t
  :hook (python-ts-mode . flymake-ruff-load))
```

ruff must be installed: `pip install ruff`

---

## ~~Task 16 — Terraform / Terragrunt (`.tf` / `.hcl`) (`init.el`)~~ ✓

The existing `terraform-mode` block covers `.tf` files but has no LSP and no tree-sitter remap. Fix:

Add to `major-mode-remap-alist`:
```elisp
(terraform-mode . terraform-ts-mode)
```

Add `.hcl` association for Terragrunt (uses the same grammar):
```elisp
(use-package terraform-ts-mode
  :ensure nil
  :mode ("\\.tf\\'" "\\.hcl\\'"))
```

Add `terraform-ts-mode` to eglot hooks:
```elisp
:hook ((... terraform-ts-mode) . eglot-ensure)
```

Update the existing `use-package terraform-mode` to remove the now-redundant `:mode` if `terraform-ts-mode` covers it. Keep `:custom (terraform-indent-level 4)` — terraform-ts-mode inherits it.

LSP server: install `terraform-ls` from [HashiCorp releases](https://github.com/hashicorp/terraform-ls/releases).

---

## ~~Task 17 — Dockerfile (`init.el`)~~ ✓

`dockerfile-ts-mode` is built into Emacs 29+. Add the grammar and remap:

Add to `treesit-language-source-alist`:
```elisp
(dockerfile "https://github.com/camdencheek/tree-sitter-dockerfile")
```

Add to `major-mode-remap-alist`:
```elisp
(dockerfile-mode . dockerfile-ts-mode)
```

Install `dockerfile-mode` to get the original mode that the remap triggers from:
```elisp
(use-package dockerfile-mode
  :ensure t
  :defer t)
```

No LSP needed. Hadolint linting via flymake (optional):
```elisp
(use-package flymake-hadolint
  :ensure t
  :hook (dockerfile-ts-mode . flymake-hadolint-setup))
```

hadolint must be installed separately (binary from GitHub releases).

---

## ~~Task 18 — Markdown (`init.el`)~~ ✓

`markdown-mode` is in `custom.el` package list but has no config. Add a proper block:

```elisp
(use-package markdown-mode
  :ensure t
  :defer t
  :mode ("\\.md\\'" "\\.markdown\\'")
  :custom
  (markdown-fontify-code-blocks-natively t)
  (markdown-command "pandoc")
  :hook
  (markdown-mode . visual-line-mode))
```

`pandoc` must be installed for `markdown-command` to work (`apt install pandoc` / `brew install pandoc`). Without it, set `markdown-command` to `"markdown"` or `"multimarkdown"`.

For live preview, add `grip-mode` (requires `pip install grip`):
```elisp
(use-package grip-mode
  :ensure t
  :defer t
  :bind (:map markdown-mode-command-map
              ("g" . grip-mode)))
```

---

## ~~Task 19 — Just / Make (`init.el`)~~ ✓

**Just** (Justfile):
```elisp
(use-package just-mode
  :ensure t
  :defer t)
```

**Make** (built-in `makefile-mode`): Makefiles require hard tabs — `indent-tabs-mode` must be `t`. The global `(indent-tabs-mode nil)` in `use-package emacs` overrides this. Override it back per-mode:

```elisp
(use-package makefile-mode
  :ensure nil
  :hook (makefile-mode . (lambda () (setq-local indent-tabs-mode t))))
```

---

## ~~Task 20 — Dirvish (dired replacement) (`init.el`)~~ ✓

`dirvish` is a modern dired UI built on top of dired — adds file preview, subtree expansion, better icons, and a more usable layout. Drop-in replacement; all dired bindings still work.

Remove or gut the existing `use-package dired` block and replace with:

```elisp
(use-package dirvish
  :ensure t
  :hook (after-init . dirvish-override-dired-mode)
  :custom
  (dirvish-quick-access-entries
   '(("h" "~/"        "Home")
     ("d" "~/Downloads" "Downloads")))
  (dirvish-attributes '(nerd-icons file-size collapse))
  (dirvish-preview-window-width 0.4)
  (delete-by-moving-to-trash t)
  (dired-listing-switches "-lah --group-directories-first")
  (dired-dwim-target t)
  (dired-kill-when-opening-new-dired-buffer t)
  :config
  (dirvish-peek-mode))
```

Add evil-friendly keybinds inside the dirvish block (uses `dirvish-define-key` or standard `evil-collection` which already covers dirvish via dired):

```elisp
:bind (:map dirvish-mode-map
       ("h" . dired-up-directory)
       ("l" . dired-find-file)
       ("q" . dirvish-quit))
```

Update the `SPC x j` binding to use `dirvish-side` for a side panel instead of `dired-jump`:

```elisp
"xj" '(dirvish-side :which-key "file tree")
```

---

## ~~Task 21 — Treemacs file tree sidebar (`init.el`)~~ ✓

`treemacs` provides a persistent project-aware file tree panel on the left side. Integrates with project.el and supports nerd-icons.

```elisp
(use-package treemacs
  :ensure t
  :defer t
  :custom
  (treemacs-width 30)
  (treemacs-display-in-side-window t)
  (treemacs-follow-after-init t)
  (treemacs-is-never-other-window t)
  :config
  (treemacs-follow-mode t)
  (treemacs-filewatch-mode t)
  (treemacs-fringe-indicator-mode 'always)
  (pcase (cons (not (null (executable-find "git")))
               (not (null (executable-find "python3"))))
    (`(t . t) (treemacs-git-mode 'deferred))
    (`(t . _) (treemacs-git-mode 'simple))))

(use-package treemacs-evil
  :ensure t
  :after (treemacs evil))

(use-package treemacs-nerd-icons
  :ensure t
  :after treemacs
  :config (treemacs-load-theme "nerd-icons"))

(use-package treemacs-projectile
  :ensure t
  :after (treemacs))
```

Add keybindings in `my/leader-def`:

```elisp
"e"   '(:ignore t           :which-key "explorer")
"ee"  '(treemacs            :which-key "toggle")
"ef"  '(treemacs-find-file  :which-key "find file")
```

Note: treemacs has its own project tracking independent of project.el. `treemacs-projectile` bridges this.

---

## ~~Task 22 — Eshell keybindings (`init.el`)~~ ✓

Wire eshell into the leader map under `SPC o` (open/tools) with a popup-style helper that toggles the eshell window:

```elisp
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
```

Add to `my/leader-def`:

```elisp
"o"   '(:ignore t            :which-key "open")
"oe"  '(my/eshell-toggle     :which-key "eshell")
"oE"  '(eshell               :which-key "eshell (new)")
```

### RET submits in insert state (evil-collection)

**Gotcha**: `evil-collection` owns eshell's RET bindings. Its
`evil-collection-repl-submit-state` defaults to `'normal`, so out of the box
`eshell-send-input` is bound to RET in **normal** state and `newline` to RET in
**insert** state — meaning Enter only executes commands from normal mode. Do
**not** try to fix this with a manual `evil-define-key`/`define-key` on
`eshell-mode-map`: evil-collection applies its bindings on
`eshell-first-time-mode-hook` (which runs *after* `use-package eshell :config`),
so it silently overwrites yours.

The supported fix is to flip the submit state to `insert` **before**
`evil-collection-init`. In the `use-package evil-collection` block:

```elisp
(use-package evil-collection
  :after evil
  :ensure t
  :custom
  (evil-collection-binding-overrides '((repl-submit  :state insert)
                                       (repl-newline :state normal)))
  :config
  (evil-collection-init))
```

Result: insert RET → `eshell-send-input`, normal RET → `newline`,
`S-<return>` → `newline` (force-newline) in either state.

### eshell settings + C-d / C-l

C-d should close the eshell session; at a non-empty prompt it deletes a char.
Note `eshell-delchar-or-maybe-eof` does **not** exist in Emacs 30 — define a
helper instead. C-d and C-l can be bound with `evil-define-key` because
evil-collection does not touch them.

```elisp
(defun my/eshell-quit-or-delete-char (arg)
  "Delete a forward char, or at an empty prompt kill eshell and close its window."
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
  ;; RET/<return> submission is handled by evil-collection (see above).
  ;; Only add C-d (evil's insert default is evil-shift-left-line) and C-l.
  (evil-define-key 'insert eshell-mode-map
    (kbd "C-d") #'my/eshell-quit-or-delete-char
    (kbd "C-l") #'eshell/clear-scrollback))
```

---

## Task 23 — Ghostty terminal integration (`init.el`)

`ghostty.el` integrates Emacs with the Ghostty terminal emulator — primarily used to open files in Emacs from Ghostty and to send commands from Emacs to a Ghostty pane.

Install from MELPA or source:

```elisp
(use-package ghostty
  :ensure t
  :defer t)
```

Add to the `o` (open) leader group:

```elisp
"ot"  '(ghostty               :which-key "ghostty")
"oT"  '(ghostty-send-region   :which-key "send region to ghostty")
```

If `ghostty.el` is not on MELPA yet, install via `use-package` with a `:vc` source (Emacs 30+) or clone manually into `lisp/`:

```elisp
(use-package ghostty
  :ensure nil
  :load-path "lisp/ghostty"
  :defer t)
```

---

## Task 24 — `pass` and `pass-otp` integration (`init.el`)

`password-store.el` provides a completing-read interface to `pass` (the standard Unix password manager). `password-store-otp` adds TOTP/OTP support.

```elisp
(use-package password-store
  :ensure t
  :defer t
  :custom
  (password-store-password-length 20))

(use-package password-store-otp
  :ensure t
  :defer t)

(use-package pass
  :ensure t
  :defer t)
```

Add to `my/leader-def` under a new `P` (private/passwords) group:

```elisp
"P"   '(:ignore t                          :which-key "pass")
"Pp"  '(password-store-copy               :which-key "copy password")
"Pi"  '(password-store-insert             :which-key "insert")
"Pg"  '(password-store-generate           :which-key "generate")
"Pe"  '(password-store-edit               :which-key "edit")
"Po"  '(password-store-otp-token-copy     :which-key "copy OTP")
"Pu"  '(password-store-url                :which-key "open URL")
```

Requires `pass` installed (`apt install pass` / `brew install pass`) and a GPG key set up. OTP requires `pass-otp` extension.

---

## Task 25 — Org-mode, org-roam, org-modern, presentation (`init.el`)

**Packages**: `org` (built-in), `org-modern`, `org-roam`, `org-present`, `olivetti`

### org base

```elisp
(use-package org
  :ensure nil
  :defer t
  :custom
  (org-directory "~/org")
  (org-default-notes-file (concat org-directory "/inbox.org"))
  (org-startup-indented t)
  (org-startup-folded 'content)
  (org-hide-emphasis-markers t)
  (org-pretty-entities t)
  (org-ellipsis " ▾")
  (org-src-fontify-natively t)
  (org-src-tab-acts-natively t)
  (org-return-follows-link t)
  (org-capture-templates
   '(("t" "Task" entry (file+headline "~/org/inbox.org" "Tasks")
      "* TODO %?\n  %U\n  %a")
     ("n" "Note" entry (file+headline "~/org/inbox.org" "Notes")
      "* %?\n  %U"))))
```

### org-modern (fancy bullets, tables, keywords)

```elisp
(use-package org-modern
  :ensure t
  :hook (org-mode . org-modern-mode)
  :custom
  (org-modern-star '("◉" "○" "✸" "✿"))
  (org-modern-table t)
  (org-modern-keyword t)
  (org-modern-block-name t))
```

### Variable pitch + centered layout for org buffers

```elisp
(use-package olivetti
  :ensure t
  :defer t
  :custom (olivetti-body-width 0.68))

(defun my/org-visual-setup ()
  (variable-pitch-mode 1)
  (olivetti-mode 1)
  (display-line-numbers-mode -1))

(add-hook 'org-mode-hook #'my/org-visual-setup)
```

### Presentation with org-present

```elisp
(use-package org-present
  :ensure t
  :defer t
  :hook
  (org-present-mode      . (lambda ()
                              (org-present-big)
                              (org-display-inline-images)
                              (org-present-hide-cursor)
                              (olivetti-mode 1)))
  (org-present-mode-quit . (lambda ()
                              (org-present-small)
                              (org-remove-inline-images)
                              (org-present-show-cursor)
                              (olivetti-mode -1))))
```

### org-roam

```elisp
(use-package org-roam
  :ensure t
  :defer t
  :custom
  (org-roam-directory "~/org/roam")
  (org-roam-completion-everywhere t)
  :config
  (org-roam-db-autosync-mode))
```

### Keybindings — `SPC n` (notes)

Add to `my/leader-def` in the evil `:config`:

```elisp
;; Notes / Org
"n"    '(:ignore t                  :which-key "notes")
"na"   '(org-agenda                 :which-key "agenda")
"nc"   '(org-capture                :which-key "capture")
"nl"   '(org-store-link             :which-key "store link")
"np"   '(org-present                :which-key "present")

;; Org-roam (nested under n r)
"nr"   '(:ignore t                  :which-key "roam")
"nrf"  '(org-roam-node-find         :which-key "find node")
"nri"  '(org-roam-node-insert       :which-key "insert link")
"nrc"  '(org-roam-capture           :which-key "capture")
"nrb"  '(org-roam-buffer-toggle     :which-key "backlinks")
"nrs"  '(org-roam-db-sync           :which-key "sync db")
"nrg"  '(org-roam-graph             :which-key "graph")
```

**Notes**:
- `org-roam-directory` defaults to `~/org/roam` — create it if it doesn't exist
- `org-roam-db-autosync-mode` keeps the roam SQLite DB in sync automatically
- Variable pitch in org buffers uses `Fira Sans` (already set in `use-package emacs`) for prose, while code blocks stay monospaced via `fixed-pitch` face
- `olivetti` centers the buffer with a comfortable reading width — disable per-buffer with `M-x olivetti-mode`

---

## Task 26 — Split config into modules

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
    my-langs.el      ; per-language mode config (Tasks 12–19)
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
(require 'my-langs)
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
| 12 | Open a `.go` file → eglot starts, gopls connects; save → gofmt applied |
| 13 | Open a `.yaml` file → eglot starts with yaml-language-server |
| 14 | Open a `.sh` file → eglot starts with bash-language-server |
| 15 | Open a `.py` file → eglot starts with pyright |
| 16 | Open a `.tf` or `.hcl` file → terraform-ts-mode, eglot starts with terraform-ls |
| 17 | Open a `Dockerfile` → dockerfile-ts-mode activates |
| 18 | Open a `.md` file → markdown-mode, code blocks syntax-highlighted |
| 19 | Open a `Justfile` → just-mode; open a `Makefile` → tabs used for indent |
| 20 | `M-x load-file init.el` — all modules load cleanly |
