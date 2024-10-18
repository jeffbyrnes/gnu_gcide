;;;; Source this file from your ~/.emacs to load GCIDE-specific emacs
;;;; settings.

;; Disable special handling of file names ending with ".Z".
;; This makes sure CIDE.Z is not taken as a compressed file.
(let ((case-fold-search nil))
  (setq jka-compr-compression-info-list
	(seq-remove (lambda (x)
		      (string-match-p (jka-compr-info-regexp x) "CIDE.Z"))
		    jka-compr-compression-info-list)))

;;;; If, for some reason, you need to open traditional compressed files,
;;;; comment out the above, and uncomment the following instead:
;;
;; (let ((case-fold-search nil))
;;   (setq jka-compr-compression-info-list
;; 	(cons ["CIDE.Z\\'" nil "cat" nil nil "cat" nil nil nil nil]
;; 	      jka-compr-compression-info-list)))

;;;; Spell-checker settings:
(setq ispell-extra-args '("--per-conf=./aspell-gcide.conf"))
