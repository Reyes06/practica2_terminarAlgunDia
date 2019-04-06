bison -o parser.cpp --defines=parser.h Sintactico.y
flex -o scanner.cpp --header-file=scanner.h Lexico.l