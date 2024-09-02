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

;; Install dependencies
(package-install 'htmlize)
(package-install 'ox-pandoc) ;; Install ox-pandoc for Org to Pandoc conversion

;; Load the publishing system
(require 'ox-publish)
(require 'ox-pandoc)

;; Customize the HTML output
(setq org-html-validation-link nil            ;; Don't show validation link
      org-html-head-include-scripts nil       ;; Use our own scripts
      org-html-head-include-default-style nil) ;; Use our own styles

;; Define the publishing project
(setq org-publish-project-alist
      (list
       (list "org-site:main"
             :recursive t
             :base-directory "./content"
             :publishing-function 'org-html-publish-to-html
             :publishing-directory "./public"
             :with-author nil           ;; Don't include author name
             :with-creator nil          ;; Do not include Emacs and Org versions in footer
             :with-toc nil              ;; Don't include a table of contents
             :section-numbers nil       ;; Don't include section numbers
             :time-stamp-file nil)      ;; Don't include time stamp in file
       (list "org-site:static"
             :base-directory "./img"    ;; Path to static files
             :base-extension "jpg\\|jpeg\\|png\\|gif\\|pdf\\|mp3\\|ogg\\|swf"
             :publishing-directory "./public/img"
             :recursive t
             :publishing-function 'org-publish-attachment))) ;; Publish static files

;; Generate the site output
(org-publish-all t)

;; Use ox-pandoc to convert Org file to PDF
(let ((org-file "./content/index.org")  ;; Path to your Org file
      (pdf-file "./public/mbcv.pdf"))   ;; Output PDF file path
  (if (and (file-exists-p org-file)
           (executable-find "pandoc"))
      (progn
        ;; Export Org file to PDF using ox-pandoc
        (org-pandoc-export-to-pdf nil org-file)
        ;; Rename the output file to match desired filename
        (rename-file (concat (file-name-sans-extension org-file) ".pdf") pdf-file t))
    (message "Error: Either Org file does not exist or Pandoc is not installed.")))

(message "Build complete!")
