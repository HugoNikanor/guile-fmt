;;; A small library that adds a fmt function.
;;; Examples:
;;;
;;; (let ((name "Hugo"))
;;;   (fmt "Hello ${name}"))
;;; => "Hello Hugo"
;;;
;;; (let ((name "Stallman")
;;;       (ending "at last"))
;;;  (fmt "Hello ${name}, nice to meet you ${ending}"))
;;; => "Hello Stallman, nice to meet you at last"
;;;
;;; Currently only supports direct variable substitutions.
;;; Record fields is something for the future
;;;
;;; My definition of how a symbol looks is also rather limited.
;;; Currently I only allow "simple" ASCII characters.
;;; See (fmt patterns) exact implementation.
;;;
;;; TODO
;;; - (fmt "string without formatting rules") fails

(define-module (fmt)
  #:use-module (srfi srfi-1)
  #:use-module (srfi srfi-8)
  #:use-module (fmt patterns)
  #:export (fmt))

(define (infmt->format str)
  "Takes an fmt str and returns a list of a regular
format string and all embedded symbols as symbols after."
  (receive (str symbs)
      (car+cdr
       (let ((tree (parse-strings-in-tree (infmt->tree str))))
         (fold (lambda (pair done)
                 (receive (donestr symbs) (car+cdr done) 
                   (let ((type (car pair))
                         (body (cadr pair)))
                     (case type
                       ((text-part)
                        (cons (string-append donestr body)
                              symbs))
                       ((replace-pattern)
                        (cons (string-append donestr "~a")
                              (cons body
                                    symbs)))))))
               (cons "" '())
               tree)))
    (cons str (reverse symbs))))

(define-macro (fmt str)
  `(format #f . ,(infmt->format str)))
