#lang racket

(provide (struct-out target)
         (struct-out source)
         parse-line)

(struct target (untarget) #:transparent)
(struct source (unsource) #:transparent)

;; Determine if the path you are extracting from a line is a `source`
;; or a `target`.
(define (parse-line str)
  (match
      (regexp-match #px" +([^\\s#]+)|([^\\s#]+)" str)
    [(list _ s #f) (source s)]
    [(list _ #f t) (target t)]
    [_             #f]))
