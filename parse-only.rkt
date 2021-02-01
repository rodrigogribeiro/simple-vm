#lang br/quicklang

(require vm/parser vm/tokenizer)

(define (read-syntax path port)
  (define parse-tree (parse path (make-tokenizer port path)))
  (strip-bindings
   #`(module vm-parser-mod vm/parse-only
       #,parse-tree)))
(module+ reader (provide read-syntax))

(define-macro (parser-only-mb PARSE-TREE)
  #'(#%module-begin
     'PARSE-TREE))
(provide (rename-out [parser-only-mb #%module-begin]))
