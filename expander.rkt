#lang br/quicklang


;; definition of the VM state

(struct state
  (pc      ;; program counter
   stack   ;; stack
   code)   ;; instructions
  #:transparent)

(define (initial-state instrs)
  (state 0 '() instrs))

(define (pre-state st)
  (cons (state-pc st) (state-stack st)))

(define-macro (vm-module-begin PARSE-TREE)
  #'(#%module-begin
     PARSE-TREE))

(provide (rename-out (vm-module-begin #%module-begin)))


(define-macro (vm-program INSTR ...)
  #'(begin
      (define start-state (initial-state (list INSTR ...)))
      (displayln (format "Starting the vm execution at state~a" (pre-state start-state)))
      (displayln (format "Finishing the vm execution at state~a" (pre-state (exec start-state))))))

(provide vm-program)

(define (exec st)
  (define current-pc (state-pc st))
  (define code-size (length (state-code st)))
  (if (>= current-pc code-size)
      st
      (let* ([next-instr (list-ref (state-code st) current-pc)]
             [next-state (next-instr st)])
        (exec next-state))))


(define-macro-cases vm-instr
  ((vm-instr "PUSH" N) #'(lambda (st) (push N st)))
  ((vm-instr "ADD")    #'(lambda (st) (add st)))
  ((vm-instr "EQ")     #'(lambda (st) (eq st)))
  ((vm-instr "JMPZ" L) #'(lambda (st) (jmpz L st))))

(provide vm-instr)

;; interpreter logic

(define (push n st)
  (match st
    ((state pc stk instrs) (state (add1 pc)
                                  (cons n stk)
                                  instrs))))

(define (add st)
  (match st
    ((state pc (cons n (cons m stk)) instrs)
     (state (add1 pc) (cons (+ n m) stk) instrs))))

(define (eq st)
  (match st
    ((state pc (cons n (cons m stk)) instrs)
     (state (add1 pc)(if (= n m)
                         (cons 1 stk)
                         (cons 0 stk))
            instrs))))

;; jump instruction changes the pc
;; not the usual semantics, but fits
;; for our needs.

(define (jmpz l st)
  (match st
    ((state pc (cons n stk) instrs)
     (if (= n 0)
         (state l stk instrs)
         (state (add1 pc) stk instrs)))))
