;; build-cv.el

;; Set the package installation directory so that packages aren't stored in the
;; ~/.emacs.d/elpa path.
(require 'package)
(setq package-user-dir (expand-file-name "./.packages"))
(setq package-archives '(("melpa" . "https://melpa.org/packages/")
                         ("elpa" . "https://elpa.gnu.org/packages/")))

;; Initialize the package system
(package-initialize)
(unless package-archive-contents
  (package-refresh-contents))

;; Install Org if not already installed
(unless (package-installed-p 'org)
  (package-install 'org))

;; Load Org mode
(require 'org)

;; Export cv.org to HTML
(find-file "content/cv.org")
(org-html-export-to-html)

;; Move the generated HTML to the public folder
(copy-file "content/cv.html" "public/mbcv.html" t)

;; Exit Emacs
(kill-emacs 0)
