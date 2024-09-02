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

;; Load the publishing system
(require 'ox-publish)

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

;; Add CSS for PDF adjustments
(with-temp-buffer
  (insert "
  <style>
    @page {
      margin: 0; /* Remove white border */
      size: A4; /* Set page size to A4 */
    }
    body {
      margin: 0;
      padding: 10mm; /* Adjust padding to control content fit */
    }
  </style>
  ")
  (write-region (point-min) (point-max) "./public/print.css" t))

;; Generate PDF from HTML using weasyprint with specific styles
(let ((html-file "./public/index.html")
      (pdf-file "./public/mbcv.pdf"))
  (if (and (file-exists-p html-file)
           (executable-find "weasyprint"))
      (shell-command (format "weasyprint %s %s -s ./public/print.css" html-file pdf-file))
    (message "Error: Either HTML file does not exist or weasyprint is not installed.")))

(message "Build complete!")
