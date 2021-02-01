#lang br/quicklang
(require brag/support vm/tokenizer)

(define (read-syntax path port)
  (define tokens (apply-tokenizer make-tokenizer port))
  (strip-bindings
   #`(module vm-tokens-mod vm/tokenize-only
       #,@tokens)))
(module+ reader (provide read-syntax))

(define-macro (tokenize-only-mb TOKEN ...)
  #'(#%module-begin
     (list TOKEN ...)))
(provide (rename-out [tokenize-only-mb #%module-begin]))
