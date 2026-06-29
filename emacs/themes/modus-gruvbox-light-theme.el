;;; modus-gruvbox-light-theme.el --- Gruvbox "soft" palette on the Modus engine -*- lexical-binding: t; no-byte-compile: t; -*-

;;; Commentary:
;; A derivative theme: the Gruvbox light "soft" palette (cream background,
;; matching the old `doom-gruvbox-soft') layered over `modus-operandi-palette'.
;; The stock `modus-operandi' is left untouched.  Built with `modus-themes-theme'
;; so all of modus's faces, `modus-themes-mixed-fonts', headings, etc. apply.

;;; Code:

;; NOTE: do not `(require 'modus-themes)' here.  The built-in modus-themes.el
;; lives in Emacs' etc/themes which is NOT on `load-path' (only reachable via
;; `load-theme'), so the require fails for a theme file outside that directory.
;; Loading the base theme with :no-enable pulls in both the engine (the
;; `modus-themes-theme' macro) and `modus-operandi-palette' below.
(unless (boundp 'modus-operandi-palette)
  (load-theme 'modus-operandi :no-confirm :no-enable))

(deftheme modus-gruvbox-light
  "Gruvbox \"soft\" (light) palette on the Modus themes engine.")

(defconst modus-gruvbox-light-palette
  (append
   '(;; backgrounds / foregrounds
     (bg-main      "#f9f5d7")
     (bg-dim       "#f2e5bc")
     (bg-inactive  "#ebdbb2")
     (bg-active    "#d5c4a1")
     (fg-main      "#282828")
     (fg-dim       "#7c6f64")
     (fg-alt       "#3c3836")
     (border       "#a89984")
     (cursor       "#282828")
     (bg-region    "#d5c4a1")
     (fg-region    "#282828")
     (bg-hl-line   "#f2e5bc")
     (bg-completion "#ebdbb2")
     (bg-hover     "#d5c4a1")
     ;; fringe, line-number column + mode line share the main background;
     ;; mode-line keeps a thin, barely-visible border (just off the bg).
     (fringe                    bg-main)
     (bg-line-number-active     bg-main)
     (bg-line-number-inactive   bg-main)
     (bg-mode-line-active       bg-main)
     (fg-mode-line-active       "#282828")
     (border-mode-line-active   "#ebdbb2")
     (bg-mode-line-inactive     bg-main)
     (fg-mode-line-inactive     "#7c6f64")
     (border-mode-line-inactive "#ebdbb2")
     ;; accent base colours (gruvbox light, faded/bright)
     (red          "#9d0006") (red-warmer    "#af3a03")
     (red-cooler   "#cc241d") (red-faint     "#9d0006")
     (red-intense  "#9d0006")
     (green        "#79740e") (green-warmer  "#98971a")
     (green-cooler "#427b58") (green-faint   "#79740e")
     (green-intense "#79740e")
     (yellow       "#b57614") (yellow-warmer "#af3a03")
     (yellow-cooler "#d79921") (yellow-faint "#b57614")
     (yellow-intense "#b57614")
     (blue         "#076678") (blue-warmer   "#458588")
     (blue-cooler  "#076678") (blue-faint    "#458588")
     (blue-intense "#076678")
     (magenta      "#b16286") (magenta-warmer "#8f3f71")
     (magenta-cooler "#8f3f71") (magenta-faint "#b16286")
     (magenta-intense "#b16286")
     (cyan         "#427b58") (cyan-warmer   "#689d6a")
     (cyan-cooler  "#36473a") (cyan-faint    "#689d6a")
     (cyan-intense "#427b58")
     ;; diff / magit (gruvbox-tinted add/remove/change backgrounds)
     (bg-added           "#d6e6b8") (bg-added-faint  "#e6eecb")
     (bg-added-refine    "#c4da98") (bg-added-fringe "#79740e")
     (fg-added           "#4a4500") (fg-added-intense "#79740e")
     (bg-removed         "#f5cabb") (bg-removed-faint  "#f5ddd5")
     (bg-removed-refine  "#f0b0a0") (bg-removed-fringe "#9d0006")
     (fg-removed         "#9d0006") (fg-removed-intense "#cc241d")
     (bg-changed         "#f2e3a0") (bg-changed-faint  "#f7eec5")
     (bg-changed-refine  "#ebd682") (bg-changed-fringe "#b57614")
     (fg-changed         "#7a5c00") (fg-changed-intense "#b57614")
     (bg-diff-context    "#f2eccf")
     ;; syntax mappings (match the old doom-gruvbox-soft roles)
     (comment      "#928374")
     (string       green)
     (keyword      red)
     (builtin      yellow-warmer)
     (fnname       yellow)
     (variable     blue)
     (type         magenta-cooler)
     (constant     magenta-cooler)
     (preprocessor red-warmer)
     (docstring    green)
     (rx-construct green)
     (rx-backslash red-warmer)
     ;; ui / accents
     (accent-0 blue) (accent-1 red-warmer) (accent-2 cyan) (accent-3 yellow)
     (fg-link cyan) (name green) (identifier yellow) (keybind blue)
     (err red) (warning yellow-warmer) (info cyan)
     ;; headings
     (fg-heading-0 blue) (fg-heading-1 red) (fg-heading-2 yellow-warmer)
     (fg-heading-3 yellow) (fg-heading-4 green) (fg-heading-5 cyan)
     (fg-heading-6 blue) (fg-heading-7 magenta) (fg-heading-8 fg-dim))
   modus-operandi-palette)
  "Gruvbox-soft colours layered over `modus-operandi-palette'.")

(modus-themes-theme modus-gruvbox-light modus-gruvbox-light-palette)

(provide-theme 'modus-gruvbox-light)
(provide 'modus-gruvbox-light-theme)
;;; modus-gruvbox-light-theme.el ends here
