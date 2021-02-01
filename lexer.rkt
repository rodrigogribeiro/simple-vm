#lang racket

(require brag/support)

;; digits definition

(define-lex-abbrev digits (:+ (char-set "0123456789")))

;; reserved words

(define-lex-abbrev reserved-terms (:or "PUSH" "ADD" "EQ" "JMPZ"))

(define vm-lexer
  (lexer-srcloc
   ("\n"       (token lexeme #:skip? #t))
   (whitespace (token lexeme #:skip? #t))
   (";"        (token 'SEMI lexeme))
   (digits     (token 'INTEGER (string->number lexeme)))
   (reserved-terms (token lexeme lexeme))))

(provide vm-lexer)
