flex mini_lisp.l
yacc -d mini_lisp.y
g++ lex.yy.c y.tab.c -o test

sleep 2

test_exe=./test
for file in ./test_data/[0-9]*.lsp ;
do
    echo $file
    $test_exe < $file 
done