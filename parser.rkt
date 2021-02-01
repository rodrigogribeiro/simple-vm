#lang brag


vm-program : (vm-instr /SEMI)*

vm-instr : PUSH INTEGER  ;; push an integer into the stack
         | ADD           ;; pops two integers and store their sum into the stack
         | EQ            ;; pops two integers and store 1 if they're equal, 0 otherwise.
         | JMPZ INTEGER  ;; jumps into a intruction if the stack top is zero.
