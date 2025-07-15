#lang racket

(provide charon)

(require "./parser.rkt")
(require "./system.rkt")

(define (charon fp)
  (call-with-input-file fp
    (λ (in) (charon-loop #f #f in))))

;; `t` is the current target, `skip` is either #t or #f and `in` is an
;; input port.
(define (charon-loop t skip in)
  (let ([ln (read-line in)])
    (unless (eof-object? ln)
      (match (parse-line ln)
        [(target new-t)
         (let ([new-skip (not (directory-exists? new-t))])
           (when new-skip
             (printf "INFO: ~a does not exist!\n" new-t))
           (charon-loop new-t new-skip in))]
        [(source s)
         (if skip
             (printf "INFO: not copying ~a into ~a...\n" s t)
             (begin
               (printf "INFO: ~a -> ~a...\n" s t)
               (recursive-copy s t)))
         (charon-loop t skip in)]
        [#f
         (charon-loop t skip in)]))))

