;; build-cv.el

(require 'package)
(setq package-user-dir (expand-file-name "./.packages"))
(setq package-archives '(("melpa" . "https://melpa.org/packages/")
                         ("gnu" . "https://elpa.gnu.org/packages/")))

;; Initialize the package system
(package-initialize)

;; Attempt to refresh package archives up to 3 times in case of failure
(let ((attempt 0)
      (max-attempts 3)
      success)
  (while (and (not success) (< attempt max-attempts))
    (condition-case err
        (progn
          (setq attempt (1+ attempt))
          (unless package-archive-contents
            (package-refresh-contents))
          (setq success t))
      (error
       (message "Failed to refresh package contents: %s" (error-message-string err))
       (when (= attempt max-attempts)
         (error "Exceeded maximum attempts to refresh package archives"))))))

;; Install Org if not already installed
(unless (package-installed-p 'org)
  (package-install 'org))

;; Load Org mode
(require 'org)

;; Export cv.org to HTML
(find-file "content/cv.org") ;; Ensure this is the correct path
(org-html-export-to-html)

;; Ensure the 'public' directory exists
(unless (file-directory-p "public")
  (make-directory "public"))

;; Move the generated HTML to the public folder
;; Correct the source path to the generated HTML file
(rename-file "cv.html" "public/mbcv.html" t)

;; Exit Emacs
(kill-emacs 0)
