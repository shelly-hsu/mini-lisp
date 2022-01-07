# Mini-lisp
Mini-lisp is a simple LISP interpreter which is the final project of complier in NCU, Taiwan. You can find grammar rules and all the other infromation you need in the Readme.md file.
# Features
## Basic Features
- [x] Syntax Validation
- [x] Print
- [x] Numerical Operations
- [x] Logical Operations
- [x] if Expression
- [x] Variable Definition
- [x] Function
- [x] Named Function
# Usage
You can simply download all the file in the file. And you get the result by runing the code below:
```
./test.sh
```
If the code above ] does not work, then you can try:
```
flex lisp.l
yacc -d lisp.y
g++ lex.yy.c y.tab.c -o test
./test < input.data.lsp
```
# Operation Overview
![](https://i.imgur.com/iE3kiiC.png)
![](https://i.imgur.com/4eJouQ8.png)\
**Other Operators:** fun, def ,if
# Grammar Overview
``` ebnf
PROGRAM ::= STMT+
STMT ::= EXP | DEF-STMT | PRINT-STMT
PRINT-STMT ::= (print-num EXP) | (print-bool EXP)
EXP ::= bool-val | number | VARIABLE | NUM-OP | LOGICAL-OP | FUN-EXP | FUN-CALL | IF-EXP
NUM-OP ::= PLUS | MINUS | MULTIPLY | DIVIDE | MODULUS | GREATER | SMALLER | EQUAL
PLUS ::= (+ EXP EXP+)
MINUS ::= (- EXP EXP)
MULTIPLY ::= (* EXP EXP+)
DIVIDE ::= (/ EXP EXP)
MODULUS ::= (mod EXP EXP)
GREATER ::= (> EXP EXP)
SMALLER ::= (< EXP EXP)
EQUAL ::= (= EXP EXP+)
LOGICAL-OP ::= AND-OP | OR-OP | NOT-OP
AND-OP ::= (and EXP EXP+)
OR-OP ::= (or EXP EXP+)
NOT-OP ::= (not EXP)
DEF-STMT ::= (define VARIABLE EXP)
VARIABLE ::= id
FUN-EXP ::= (fun FUN_IDs FUN-BODY)
FUN-IDs ::= (id*)
FUN-BODY ::= EXP
FUN-CALL ::= (FUN-EXP PARAM*) | (FUN-NAME PARAM*)
PARAM ::= EXP
LAST-EXP ::= EXP
FUN-NAME ::= id
IF-EXP ::= (if TEST-EXP THAN-EXP ELSE-EXP)
TEST-EXP ::= EXP
THEN-EXP ::= EXP
ELSE-EXP ::= EX
```
# Grammar and Definition Behavior
## Program
``` ebnf
PROGRAM :: = STMT+
STMT ::= EXP | DEF-STMT | PRINT-STMT
```
## Print
``` ebnf
PRINT-STMT ::= (print-num EXP)
```
**Behavior: Print exp in decimal.**
``` ebnf
 | (print-bool EXP)
 ```
**Behavior: Print #t if EXP is true. Print #f, otherwise.**
## Expression (EXP)
``` ebnf
EXP ::= bool-val | number | VARIABLE | NUM-OP | LOGICAL-OP | FUN-EXP | FUN-CALL | IF-EXP
```
## Numerical Operations (NUM-OP)
``` ebnf
NUM-OP ::= PLUS | MINUS | MULTIPLY | DIVIDE | MODULUS | GREATER | SMALLER | EQUAL
```
``` ebnf
PLUS ::= (+ EXP EXP+)
```
**Behavior: return sum of all EXP inside.**\
Example: (+ 1 2 3 4) → 10
```ebnf
MINUS ::= (- EXP EXP)
```
**Behavior: return the result that the first EXP minus the second EXP.**\
Example: (- 2 1) → 1
```ebnf
MULTIPLY ::= (* EXP EXP+)
```
**Behavior: return the product of all EXP inside.**\
Example: (* 1 2 3 4) → 24
```ebnf
DIVIDE ::= (/ EXP EXP)
```
**Behavior: return the result that the first EXP divided by the second EXP.**\
Example:\
(/ 10 5) → 2\
(/ 3 2) → 1 (just like C++)
``` ebnf
MODULUS ::= (mod EXP EXP)
```
**Behavior: return the modulus that the first EXP divided by the second EXP.**\
Example: (mod 8 5) → 3
``` ebnf
GREATER ::= (> EXP EXP)
```
**Behavior: return #t if the first EXP greater than the second EXP. #f otherwise.**\
Example: (> 1 2) → #f
```ednf
SMALLER ::= (< EXP EXP)
```
**Behavior: return #t if the first EXP smaller than the second EXP. #f otherwise.**\
Example: (< 1 2) → #t
``` ebnf
EQUAL ::= (= EXP EXP+)
```
**Behavior: return #t if all EXPs are equal. #f otherwise.**\
Example: (= (+ 1 1) 2 (/6 3)) → #t
## Logical Operations (LOGICAL-OP)
```ebnf
LOGICAL-OP ::= AND-OP | OR-OP | NOT-OP
```
```ebnf
AND-OP ::= (and EXP EXP+)
```
**Behavior: return #t if all EXPs are true. #f otherwise.**\
Example: (and #t (> 2 1)) → #t
```ebnf
OR-OP ::= (or EXP EXP+)
```
**Behavior: return #t if at least one EXP is true. #f otherwise.**\
Example: (or (> 1 2) #f) → #f
```ebnf
NOT-OP ::= (not EXP)
```
**Behavior: return #t if EXP is false. #f otherwise.**\
Example: (not (> 1 2)) → #t
## define Statement (DEF-STMT)
```ebnf
DEF-STMT ::= (define id EXP)
VARIABLE ::= id
```
**Behavior: Define a variable named id whose value is EXP.**\
Example:\
(define x 5)\
(+ x 1) → 6\
**Note: Redefining is not allowed.**
## Function
```ebnf
FUN-EXP ::= (fun FUN-IDs FUN-BODY)
FUN-IDs ::= (id*)
FUN-BODY ::= EXP
FUN-CALL ::= (FUN-EXP PARAM*)
 | (FUN-NAME PARAM*)
PARAM ::= EXP
LAST-EXP ::= EXP
FUN-NAME ::= id
```
**Behavior: FUN-EXP defines a function. When a function is called, bind FUN-IDsto PARAMs, just like the define statement. If an id has been defined outside this function, prefer the definition inside the FUN-EXP. The variable definitions inside a function should not affect the outer scope. A FUN-CALL returns the evaluated result of FUN-BODY Note that variables used in FUN-BODY should be bound to PARAMs.**\
Examples:\
((fun (x) (+ x 1)) 2) → 3\
(define foo (fun () 0))\
(foo) → 0\
(define x 1)\
(define bar (fun (x y) (+ x y)))\
(bar 2 3) → 5\
x → 1
## if Expression
```ebnf
IF-EXP ::= (if TEST-EXP THEN-EXP ELSE-EXP)
TEST-EXP ::= EXP
THEN-EXP ::= EXP
ELSE-EXP ::= EXP
```
**Behavior: When TEST-EXP is true, returns THEN-EXP. Otherwise, returns ELSE-EXP.**\
Example:\
(if (= 1 0) 1 2) → 2\
(if #t 1 2) → 1
