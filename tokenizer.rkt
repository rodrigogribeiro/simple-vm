#lang racket

(require vm/lexer brag/support)

(define (make-tokenizer ip [path #f])
  (port-count-lines! ip)
  (lexer-file-path path)
  (define (next-token) (vm-lexer ip))
  next-token)

(provide make-tokenizer)
