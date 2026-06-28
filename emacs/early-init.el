;; Max GC during startup; gcmh restores a sane threshold after init
(setq gc-cons-threshold most-positive-fixnum)

(defvar my/file-name-handler-alist file-name-handler-alist)
(setq file-name-handler-alist nil)
(add-hook 'emacs-startup-hook
  (lambda () (setq file-name-handler-alist my/file-name-handler-alist)))
(setq byte-compile-warnings '(not obsolete))
(setq warning-suppress-log-types '((comp) (bytecomp)))
(setq native-comp-async-report-warnings-errors 'silent)

;; Silence startup message
(setq inhibit-startup-echo-area-message (user-login-name))

;; Default frame configuration
(setq frame-resize-pixelwise t)
(tool-bar-mode -1)
(menu-bar-mode -1)
(scroll-bar-mode -1)
(setq default-frame-alist '(
			    (fullscreen . maximized)
			    (undecorated . t)))
