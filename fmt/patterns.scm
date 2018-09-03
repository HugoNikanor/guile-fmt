(define-module (fmt patterns)
  #:use-module (ice-9 peg)
  #:export (infmt->tree))

;; A single upper or lower case letter
(define-peg-pattern letter body
  (or (range #\a #\z)
      (range #\A #\Z)))

;; A single number
(define-peg-pattern digit body
  (range #\0 #\9))

;; A single of the other valid symbol characters.
(define-peg-pattern symbol-extra-chars body
  (peg "[-!$%&*+./:<=>?@^_~]"))

;; A scheme symbol
(define-peg-pattern symbol body
  (and (or letter symbol-extra-chars)
       (* (or letter symbol-extra-chars digit))))

;; The pattern ${symbol}, used for finding symbols to replace.
(define-peg-pattern replace-pattern all
  (and (ignore "${") symbol (ignore "}")))

;; A contigious string of text ending at '${' or at the end of
;; the string
(define-peg-pattern text-part all
  (* (or (followed-by "${")
         peg-any)))

;; A full string on my format
(define-peg-pattern fmt-pattern body
  (* (or replace-pattern
         text-part)))

(define (infmt->tree str)
  "Takes a fmt string and returns a tree of the parts, where every top node is
a list with its first element being either text-part of replace-pattern, and
the second element being the string."
  (keyword-flatten
   '(text-part replace-pattern)
   (peg:tree
    (match-pattern fmt-pattern str))))
