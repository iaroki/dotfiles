;;; modus-gruvbox-dark-theme.el --- Gruvbox "black" palette on the Modus engine -*- lexical-binding: t; no-byte-compile: t; -*-

;;; Commentary:
;; A derivative theme: the bright Gruvbox palette (pure-black "black" variant,
;; matching the old `doom-gruvbox-black') layered over `modus-vivendi-palette'.
;; The stock `modus-vivendi' is left untouched.  Built with `modus-themes-theme'
;; so all of modus's faces, `modus-themes-mixed-fonts', headings, etc. apply.

;;; Code:

;; NOTE: do not `(require 'modus-themes)' here.  The built-in modus-themes.el
;; lives in Emacs' etc/themes which is NOT on `load-path' (only reachable via
;; `load-theme'), so the require fails for a theme file outside that directory.
;; Loading the base theme with :no-enable pulls in both the engine (the
;; `modus-themes-theme' macro) and `modus-vivendi-palette' below.
(unless (boundp 'modus-vivendi-palette)
  (load-theme 'modus-vivendi :no-confirm :no-enable))

(deftheme modus-gruvbox-dark
  "Gruvbox \"black\" (dark) palette on the Modus themes engine.")

(defconst modus-gruvbox-dark-palette
  (append
   '(;; backgrounds / foregrounds
     (bg-main      "#000000")
     (bg-dim       "#1d2021")
     (bg-inactive  "#1d2021")
     (bg-active    "#3c3836")
     (fg-main      "#ebdbb2")
     (fg-dim       "#928374")
     (fg-alt       "#d5c4a1")
     (border       "#665c54")
     (cursor       "#fbf1c7")
     (bg-region    "#3c3836")
     (fg-region    "#ebdbb2")
     (bg-hl-line   "#1d2021")
     (bg-completion "#3c3836")
     (bg-hover     "#504945")
     ;; fringe, line-number column + mode line share the main background;
     ;; mode-line keeps a thin, barely-visible border (just off the bg).
     (fringe                    bg-main)
     (bg-line-number-active     bg-main)
     (bg-line-number-inactive   bg-main)
     (bg-mode-line-active       bg-main)
     (fg-mode-line-active       "#ebdbb2")
     (border-mode-line-active   "#1d2021")
     (bg-mode-line-inactive     bg-main)
     (fg-mode-line-inactive     "#928374")
     (border-mode-line-inactive "#1d2021")
     ;; accent base colours (bright gruvbox)
     (red          "#fb4934") (red-warmer    "#fe8019")
     (red-cooler   "#cc241d") (red-faint     "#cc241d")
     (red-intense  "#fb4934")
     (green        "#b8bb26") (green-warmer  "#98971a")
     (green-cooler "#8ec07c") (green-faint   "#98971a")
     (green-intense "#b8bb26")
     (yellow       "#fabd2f") (yellow-warmer "#fe8019")
     (yellow-cooler "#d79921") (yellow-faint "#d79921")
     (yellow-intense "#fabd2f")
     (blue         "#83a598") (blue-warmer   "#458588")
     (blue-cooler  "#458588") (blue-faint    "#83a598")
     (blue-intense "#83a598")
     (magenta      "#d3869b") (magenta-warmer "#b16286")
     (magenta-cooler "#d3869b") (magenta-faint "#b16286")
     (magenta-intense "#d3869b")
     (cyan         "#8ec07c") (cyan-warmer   "#689d6a")
     (cyan-cooler  "#689d6a") (cyan-faint    "#8ec07c")
     (cyan-intense "#8ec07c")
     ;; diff / magit (gruvbox-tinted add/remove/change backgrounds)
     (bg-added           "#0e2a12") (bg-added-faint  "#0a1f0c")
     (bg-added-refine    "#16401c") (bg-added-fringe "#98971a")
     (fg-added           "#b8bb26") (fg-added-intense "#b8bb26")
     (bg-removed         "#3a1012") (bg-removed-faint  "#2a0b0c")
     (bg-removed-refine  "#551a1c") (bg-removed-fringe "#cc241d")
     (fg-removed         "#fb4934") (fg-removed-intense "#fb4934")
     (bg-changed         "#2f2a0e") (bg-changed-faint  "#241f0a")
     (bg-changed-refine  "#4a3f16") (bg-changed-fringe "#d79921")
     (fg-changed         "#fabd2f") (fg-changed-intense "#fabd2f")
     (bg-diff-context    "#0d0d0d")
     ;; syntax mappings (match the old doom-gruvbox roles)
     (comment      "#928374")
     (string       green)
     (keyword      red)
     (builtin      yellow-warmer)
     (fnname       green)
     (variable     blue)
     (type         yellow)
     (constant     magenta)
     (preprocessor yellow-warmer)
     (docstring    "#a89984")
     (rx-construct green)
     (rx-backslash yellow-warmer)
     ;; ui / accents
     (accent-0 blue) (accent-1 yellow-warmer) (accent-2 green-cooler) (accent-3 yellow)
     (fg-link blue) (name green) (identifier yellow) (keybind blue)
     (err red) (warning yellow) (info green-cooler)
     ;; headings (rainbow, gruvbox tones)
     (fg-heading-0 yellow) (fg-heading-1 red) (fg-heading-2 yellow-warmer)
     (fg-heading-3 yellow) (fg-heading-4 green) (fg-heading-5 green-cooler)
     (fg-heading-6 blue) (fg-heading-7 magenta) (fg-heading-8 fg-dim))
   modus-vivendi-palette)
  "Gruvbox-black colours layered over `modus-vivendi-palette'.")

(modus-themes-theme modus-gruvbox-dark modus-gruvbox-dark-palette)

(provide-theme 'modus-gruvbox-dark)
(provide 'modus-gruvbox-dark-theme)
;;; modus-gruvbox-dark-theme.el ends here
