#lang br/quicklang

(require vm/parser vm/tokenizer)

(define (read-syntax path port)
  (define parse-tree (parse path (make-tokenizer port)))
  (define module-datum `(module vm-mod vm/expander
                          ,parse-tree))
  (datum->syntax #f module-datum))
(provide read-syntax)
