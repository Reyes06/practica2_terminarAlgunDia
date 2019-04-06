/*================================OPCIONES=============================================*/
%defines "parser.h"
%output "parser.cpp"
%error-verbose
%locations
/*===========================CODIGO DE USUARIO.h=======================================*/
%{
#include "scanner.h"
#include "nodoArbol.h"
#include "qdebug.h"
#include "tipos.h"
#include <iostream>

extern int yylineno;
extern int columna;
extern char *yytext;
extern NodoArbol *raiz;

int yyerror(const char* mensaje) {
    std::cout << mensaje <<yytext<< std::endl;
    return 0;
}
%}
/*=============================TIPOS DE DATOS==========================================*/
%union{
    char TEXT [255];
    class NodoArbol *nodo;
}
//=================================DECLARACION DE TERMINALES===========================
%token<TEXT> entero;
%token<TEXT> decimal;
%token<TEXT> booleano;
%token<TEXT> caracter;
%token<TEXT> cadena;
%token<TEXT> id;
%token<TEXT> para;
%token<TEXT> parc;
%token<TEXT> lla;
%token<TEXT> llc;
%token<TEXT> cora;
%token<TEXT> corc;
%token<TEXT> pntcoma;
%token<TEXT> tipo;
%token<TEXT> arreglo;
%token<TEXT> igual;
%token<TEXT> coma;
%token<TEXT> mas;
%token<TEXT> menos;
%token<TEXT> por;
%token<TEXT> barra;
%token<TEXT> igualque;
%token<TEXT> diferenteque;
%token<TEXT> menorque;
%token<TEXT> mayorque;
%token<TEXT> menorigualque;
%token<TEXT> mayorigualque;
%token<TEXT> notnot;
%token<TEXT> pot;
%token<TEXT> andand;
%token<TEXT> oror;
%token<TEXT> decremento;
%token<TEXT> incremento;
%token<TEXT> imprimir;
%token<TEXT> show;
%token<TEXT> si;
%token<TEXT> sino;
%token<TEXT> ciclo_para;
%token<TEXT> ciclo_repetir;
//==================================DECLARACION DE NO TERMINALES===================================
%type<nodo> INICIO;
%type<nodo> BLOQUE;
%type<nodo> INSTRUCCION;
%type<nodo> DECLARACION;
%type<nodo> LISTA_ID;
%type<nodo> ASIGNACION;
%type<nodo> DIMENSIONES;
%type<nodo> ARREGLO_LISTA_EXPRESIONES; 
%type<nodo> LISTA_EXPRESIONES; 
%type<nodo> EXPRESION;
%type<nodo> PRINT;
%type<nodo> MESSAGE;
%type<nodo> IF;
%type<nodo> ELSEIF;
%type<nodo> ELSE;
%type<nodo> FOR;
%type<nodo> REPETIR;
//==========================================PRECEDENCIA==============================================
%left oror
%left andand
%left notnot 
%left menorque mayorque mayorigualque menorigualque igualque diferenteque
%left mas menos
%left por barra
%left NEG
%left pot
//=====================================PRODUCCION INICIAL============================================
%start INICIO
//=======================================PRODUCCIONES================================================
%%
INICIO:
    BLOQUE
    {
        raiz = new NodoArbol(INICIO);
        raiz->add($1);
    }
;

BLOQUE:
    BLOQUE INSTRUCCION
    {
        NodoArbol *padre = new NodoArbol(BLOQUE);
        padre->add($1);
        padre->add($2);
        $$ = padre;
    }
    |INSTRUCCION
    {
        NodoArbol *padre = new NodoArbol(BLOQUE);
        padre->add($1);
        $$ = padre;
    }
;

INSTRUCCION:
    DECLARACION pntcoma
    {
        NodoArbol *padre = new NodoArbol(INSTRUCCION);
            NodoArbol *pntcoma = new NodoArbol(PNTCOMA,@2.first_line,@2.first_column,$2);
        padre->add($1);
        padre->add(pntcoma);
        $$ = padre;
    }
    |ASIGNACION pntcoma
    {
        NodoArbol *padre = new NodoArbol(INSTRUCCION);
            NodoArbol *pntcoma = new NodoArbol(PNTCOMA,@2.first_line,@2.first_column,$2);
        padre->add($1);
        padre->add(pntcoma);
        $$ = padre;
    }
    |PRINT pntcoma
    {
        NodoArbol *padre = new NodoArbol(INSTRUCCION);
            NodoArbol *pntcoma = new NodoArbol(PNTCOMA,@2.first_line,@2.first_column,$2);
        padre->add($1);
        padre->add(pntcoma);
        $$ = padre;
    }
    |MESSAGE pntcoma
    {
        NodoArbol *padre = new NodoArbol(INSTRUCCION);
            NodoArbol *pntcoma = new NodoArbol(PNTCOMA,@2.first_line,@2.first_column,$2);
        padre->add($1);
        padre->add(pntcoma);
        $$ = padre;
    }
    |IF
    {
        NodoArbol *padre = new NodoArbol(INSTRUCCION);
        padre->add($1);
        $$ = padre;
    }
    |FOR
    {
        NodoArbol *padre = new NodoArbol(INSTRUCCION);
        padre->add($1);
        $$ = padre;
    }
    |REPETIR
    {
        NodoArbol *padre = new NodoArbol(INSTRUCCION);
        padre->add($1);
        $$ = padre;
    }
;

DECLARACION:
    tipo LISTA_ID 
    {
        NodoArbol *padre = new NodoArbol(DECLARACION);
            NodoArbol *tipo = new NodoArbol(TIPO,@1.first_line,@1.first_column,$1);
        padre->add(tipo);
        padre->add($2);
        $$ = padre;
    }
    |tipo LISTA_ID igual EXPRESION 
    {
        NodoArbol *padre = new NodoArbol(DECLARACION);
            NodoArbol *tipo = new NodoArbol(TIPO,@1.first_line,@1.first_column,$1);
            NodoArbol *igual = new NodoArbol(IGUAL,@3.first_line,@3.first_column,$3);
        padre->add(tipo);
        padre->add($2);
        padre->add(igual);
        padre->add($4);
        $$ = padre;
    }
    |tipo arreglo LISTA_ID DIMENSIONES 
    {
        NodoArbol *padre = new NodoArbol(DECLARACION);
            NodoArbol *tipo = new NodoArbol(TIPO,@1.first_line,@1.first_column,$1);
            NodoArbol *arreglo = new NodoArbol(ARREGLO,@2.first_line,@2.first_column,$2);
        padre->add(tipo);
        padre->add(arreglo);
        padre->add($3);
        padre->add($4);
        $$ = padre;
    }
    |tipo arreglo LISTA_ID DIMENSIONES igual lla ARREGLO_LISTA_EXPRESIONES llc  
    {
        NodoArbol *padre = new NodoArbol(DECLARACION);
            NodoArbol *tipo = new NodoArbol(TIPO,@1.first_line,@1.first_column,$1);
            NodoArbol *arreglo = new NodoArbol(ARREGLO,@2.first_line,@2.first_column,$2);
            NodoArbol *igual = new NodoArbol(IGUAL,@5.first_line,@5.first_column,$5);
            NodoArbol *lla = new NodoArbol(LLA,@6.first_line,@6.first_column,$6);
            NodoArbol *llc = new NodoArbol(LLC,@8.first_line,@8.first_column,$8);
        padre->add(tipo);
        padre->add(arreglo);
        padre->add($3);
        padre->add($4);
        padre->add(igual);
        padre->add(lla);
        padre->add($7);
        padre->add(llc);
        $$ = padre;
    }
;

LISTA_ID:
    LISTA_ID coma id 
    {
        NodoArbol *padre = new NodoArbol(LISTA_ID);
            NodoArbol *coma = new NodoArbol(COMA,@2.first_line,@2.first_column,$2);
            NodoArbol *id = new NodoArbol(ID,@3.first_line,@3.first_column,$3);
        padre->add($1);
        padre->add(coma);
        padre->add(id);
        $$ = padre;
    }
    |id 
    {
        NodoArbol *padre = new NodoArbol(LISTA_ID);
            NodoArbol *id = new NodoArbol(ID,@1.first_line,@1.first_column,$1);
        padre->add(id);
        $$ = padre;
    }
;

ASIGNACION:
    id igual EXPRESION
    {
        NodoArbol *padre = new NodoArbol(ASIGNACION);
            NodoArbol *id = new NodoArbol(ID,@1.first_line,@1.first_column,$1);
            NodoArbol *igual = new NodoArbol(IGUAL,@2.first_line,@2.first_column,$2);
        padre->add(id);
        padre->add(igual);
        padre->add($3);
        $$ = padre;
    }
;

DIMENSIONES:
    DIMENSIONES cora EXPRESION corc
    {
        NodoArbol *padre = new NodoArbol(DIMENSIONES);
            NodoArbol *cora = new NodoArbol(CORA,@2.first_line,@2.first_column,$2);
            NodoArbol *corc = new NodoArbol(CORC,@4.first_line,@4.first_column,$4);
        padre->add($1);
        padre->add(cora);
        padre->add($3);
        padre->add(corc);
        $$ = padre;
    }
    |cora EXPRESION corc
    {
        NodoArbol *padre = new NodoArbol(DIMENSIONES);
            NodoArbol *cora = new NodoArbol(CORA,@1.first_line,@1.first_column,$1);
            NodoArbol *corc = new NodoArbol(CORC,@3.first_line,@3.first_column,$3);
        padre->add(cora);
        padre->add($2);
        padre->add(corc);
        $$ = padre;
    }
;

ARREGLO_LISTA_EXPRESIONES:
    ARREGLO_LISTA_EXPRESIONES coma lla LISTA_EXPRESIONES llc
    {
        NodoArbol *padre = new NodoArbol(ARREGLO_LISTA_EXPRESIONES);
            NodoArbol *coma = new NodoArbol(COMA,@2.first_line,@2.first_column,$2);
            NodoArbol *lla = new NodoArbol(LLA,@3.first_line,@3.first_column,$3);
            NodoArbol *llc = new NodoArbol(LLC,@5.first_line,@5.first_column,$5);
        padre->add($1);
        padre->add(coma);
        padre->add(lla);
        padre->add($4);
        padre->add(llc);
        $$ = padre;
    }
    |lla LISTA_EXPRESIONES llc
    {
        NodoArbol *padre = new NodoArbol(ARREGLO_LISTA_EXPRESIONES);
            NodoArbol *lla = new NodoArbol(LLA,@1.first_line,@1.first_column,$1);
            NodoArbol *llc = new NodoArbol(LLC,@3.first_line,@3.first_column,$3);
        padre->add(lla);
        padre->add($2);
        padre->add(llc);
        $$ = padre;
    }
;

LISTA_EXPRESIONES:
    LISTA_EXPRESIONES coma EXPRESION
    {
        NodoArbol *padre = new NodoArbol(LISTA_EXPRESIONES);
            NodoArbol *coma = new NodoArbol(COMA,@2.first_line,@2.first_column,$2);
        padre->add($1);
        padre->add(coma);
        padre->add($3);
        $$ = padre;
    }
    |EXPRESION
    {
        NodoArbol *padre = new NodoArbol(LISTA_EXPRESIONES);
        padre->add($1);
        $$ = padre;
    }
;

EXPRESION:
    EXPRESION mas EXPRESION 
    {
        NodoArbol *padre = new NodoArbol(EXPRESION);
            NodoArbol *mas = new NodoArbol(MAS,@2.first_line, @2.first_column,$2);
        padre->add($1);  
        padre->add(mas);
        padre->add($3); 
        $$ = padre;
    }
    |EXPRESION menos EXPRESION 
    {
        NodoArbol *padre = new NodoArbol(EXPRESION);
            NodoArbol *menos = new NodoArbol(MENOS,@2.first_line, @2.first_column,$2);  
        padre->add($1);  
        padre->add(menos);
        padre->add($3); 
        $$ = padre;
    }
    |EXPRESION por EXPRESION 
    {
        NodoArbol *padre = new NodoArbol(EXPRESION);
            NodoArbol *por = new NodoArbol(POR,@2.first_line, @2.first_column,$2);  
        padre->add($1);  
        padre->add(por);
        padre->add($3); 
        $$ = padre;
    }
    |EXPRESION barra EXPRESION 
    {
        NodoArbol *padre = new NodoArbol(EXPRESION);
            NodoArbol *barra = new NodoArbol(BARRA,@2.first_line, @2.first_column,$2);  
        padre->add($1);  
        padre->add(barra);
        padre->add($3); 
        $$ = padre;
    }
    |EXPRESION pot EXPRESION 
    {
        NodoArbol *padre = new NodoArbol(EXPRESION);
            NodoArbol *pot = new NodoArbol(POT,@2.first_line, @2.first_column,$2);  
        padre->add($1);  
        padre->add(pot);
        padre->add($3); 
        $$ = padre;
    }
    |EXPRESION igualque EXPRESION 
    {
        NodoArbol *padre = new NodoArbol(EXPRESION);
            NodoArbol *igualque = new NodoArbol(IGUALQUE,@2.first_line, @2.first_column,$2);  
        padre->add($1);  
        padre->add(igualque);
        padre->add($3); 
        $$ = padre;
    }
    |EXPRESION diferenteque EXPRESION 
    {
        NodoArbol *padre = new NodoArbol(EXPRESION);
            NodoArbol *diferenteque = new NodoArbol(DIFERENTEQUE,@2.first_line, @2.first_column,$2);  
        padre->add($1);  
        padre->add(diferenteque);
        padre->add($3); 
        $$ = padre;
    }
    |EXPRESION menorque EXPRESION 
    {
        NodoArbol *padre = new NodoArbol(EXPRESION);
            NodoArbol *menorque = new NodoArbol(MENORQUE,@2.first_line, @2.first_column,$2);  
        padre->add($1);  
        padre->add(menorque);
        padre->add($3); 
        $$ = padre;
    }
    |EXPRESION menorigualque EXPRESION 
    {
        NodoArbol *padre = new NodoArbol(EXPRESION);
            NodoArbol *menorigualque = new NodoArbol(MENORIGUALQUE,@2.first_line, @2.first_column,$2);  
        padre->add($1);  
        padre->add(menorigualque);
        padre->add($3); 
        $$ = padre;
    }
    |EXPRESION mayorque EXPRESION 
    {
        NodoArbol *padre = new NodoArbol(EXPRESION);
            NodoArbol *mayorque = new NodoArbol(MAYORQUE,@2.first_line, @2.first_column,$2);  
        padre->add($1);  
        padre->add(mayorque);
        padre->add($3); 
        $$ = padre;
    }
    |EXPRESION mayorigualque EXPRESION 
    {
        NodoArbol *padre = new NodoArbol(EXPRESION);
            NodoArbol *mayorigualque = new NodoArbol(MAYORIGUALQUE,@2.first_line, @2.first_column,$2);  
        padre->add($1);  
        padre->add(mayorigualque);
        padre->add($3); 
        $$ = padre;
    }
    |EXPRESION andand EXPRESION 
    {
        NodoArbol *padre = new NodoArbol(EXPRESION);
            NodoArbol *andand = new NodoArbol(AND,@2.first_line, @2.first_column,$2);  
        padre->add($1);  
        padre->add(andand);
        padre->add($3); 
        $$ = padre;
    }
    |EXPRESION oror EXPRESION 
    {
        NodoArbol *padre = new NodoArbol(EXPRESION);
            NodoArbol *oror = new NodoArbol(OR,@2.first_line, @2.first_column,$2);  
        padre->add($1);  
        padre->add(oror);
        padre->add($3); 
        $$ = padre;
    }
    |notnot EXPRESION 
    {
        NodoArbol *padre = new NodoArbol(EXPRESION);
            NodoArbol *notnot = new NodoArbol(NOT,@1.first_line, @1.first_column,$1);  
        padre->add(notnot);
        padre->add($2); 
        $$ = padre;
    }
    |menos EXPRESION %prec NEG
    {
        NodoArbol *padre = new NodoArbol(EXPRESION);
            NodoArbol *menos = new NodoArbol(MENOS,@1.first_line, @1.first_column,$1);  
        padre->add(menos);
        padre->add($2); 
        $$ = padre;
    }
    |entero 
    { 
        NodoArbol *padre = new NodoArbol(EXPRESION);
            NodoArbol *entero = new NodoArbol(ENTERO,@1.first_line, @1.first_column,$1); 
        padre->add(entero);
        $$ = padre;
    }
    |caracter 
    { 
        NodoArbol *padre = new NodoArbol(EXPRESION);
            NodoArbol *caracter = new NodoArbol(CARACTER,@1.first_line, @1.first_column,$1); 
        padre->add(caracter);
        $$ = padre;
    }
    |decimal 
    { 
        NodoArbol *padre = new NodoArbol(EXPRESION);
            NodoArbol *decimal = new NodoArbol(DECIMAL,@1.first_line, @1.first_column,$1); 
        padre->add(decimal);
        $$ = padre;
    }
    |booleano 
    { 
        NodoArbol *padre = new NodoArbol(EXPRESION);
            NodoArbol *booleano = new NodoArbol(BOOLEANO,@1.first_line, @1.first_column,$1); 
        padre->add(booleano);
        $$ = padre;
    }
    |cadena 
    { 
        NodoArbol *padre = new NodoArbol(EXPRESION);
            NodoArbol *cadena = new NodoArbol(CADENA,@1.first_line, @1.first_column,$1); 
        padre->add(cadena);
        $$ = padre;
    }
    |para EXPRESION parc
    {
        NodoArbol *padre = new NodoArbol(EXPRESION);
            NodoArbol *para = new NodoArbol(PARA,@1.first_line, @1.first_column,$1);
            NodoArbol *parc = new NodoArbol(PARC,@1.first_line, @1.first_column,$3); 
        padre->add(para);
        padre->add($2);
        padre->add(parc);
        $$ = padre;
    }
;

PRINT:
    imprimir para EXPRESION parc
    {
        NodoArbol *padre = new NodoArbol(PRINT);
            NodoArbol *imprimir = new NodoArbol(IMPRIMIR,@1.first_line,@1.first_column,$1);
            NodoArbol *para = new NodoArbol(PARA,@2.first_line,@2.first_column,$2);
            NodoArbol *parc = new NodoArbol(PARC,@4.first_line,@4.first_column,$4);
        padre->add(imprimir);
        padre->add(para);
        padre->add($3);
        padre->add(parc);
        $$ = padre;
    }
;

MESSAGE:
    show para EXPRESION parc
    {
        NodoArbol *padre = new NodoArbol(MESSAGE);
            NodoArbol *show = new NodoArbol(SHOW,@1.first_line,@1.first_column,$1);
            NodoArbol *para = new NodoArbol(PARA,@2.first_line,@2.first_column,$2);
            NodoArbol *parc = new NodoArbol(PARC,@4.first_line,@4.first_column,$4);
        padre->add(show);
        padre->add(para);
        padre->add($3);
        padre->add(parc);
        $$ = padre;
    }
;

IF:
    si para EXPRESION parc lla BLOQUE llc
    {
        NodoArbol *padre = new NodoArbol(IF);
            NodoArbol *si = new NodoArbol(SI,@1.first_line,@1.first_column,$1);
            NodoArbol *para = new NodoArbol(PARA,@2.first_line,@2.first_column,$2);
            NodoArbol *parc = new NodoArbol(PARC,@4.first_line,@4.first_column,$4);
            NodoArbol *lla = new NodoArbol(LLA,@5.first_line,@5.first_column,$5);
            NodoArbol *llc = new NodoArbol(LLC,@7.first_line,@7.first_column,$7);
        padre->add(si);
        padre->add(para);
        padre->add($3);
        padre->add(parc);
        padre->add(lla);
        padre->add($6);
        padre->add(llc);
        $$ = padre;
    }
    |si para EXPRESION parc lla BLOQUE llc ELSE
    {
        NodoArbol *padre = new NodoArbol(IF);
            NodoArbol *si = new NodoArbol(SI,@1.first_line,@1.first_column,$1);
            NodoArbol *para = new NodoArbol(PARA,@2.first_line,@2.first_column,$2);
            NodoArbol *parc = new NodoArbol(PARC,@4.first_line,@4.first_column,$4);
            NodoArbol *lla = new NodoArbol(LLA,@5.first_line,@5.first_column,$5);
            NodoArbol *llc = new NodoArbol(LLC,@7.first_line,@7.first_column,$7);
        padre->add(si);
        padre->add(para);
        padre->add($3);
        padre->add(parc);
        padre->add(lla);
        padre->add($6);
        padre->add(llc);
        padre->add($8);
        $$ = padre;
    }
    |si para EXPRESION parc lla BLOQUE llc ELSEIF
    {
        NodoArbol *padre = new NodoArbol(IF);
            NodoArbol *si = new NodoArbol(SI,@1.first_line,@1.first_column,$1);
            NodoArbol *para = new NodoArbol(PARA,@2.first_line,@2.first_column,$2);
            NodoArbol *parc = new NodoArbol(PARC,@4.first_line,@4.first_column,$4);
            NodoArbol *lla = new NodoArbol(LLA,@5.first_line,@5.first_column,$5);
            NodoArbol *llc = new NodoArbol(LLC,@7.first_line,@7.first_column,$7);
        padre->add(si);
        padre->add(para);
        padre->add($3);
        padre->add(parc);
        padre->add(lla);
        padre->add($6);
        padre->add(llc);
        padre->add($8);
        $$ = padre;
    }
    |si para EXPRESION parc lla BLOQUE llc ELSEIF ELSE
    {
        NodoArbol *padre = new NodoArbol(IF);
            NodoArbol *si = new NodoArbol(SI,@1.first_line,@1.first_column,$1);
            NodoArbol *para = new NodoArbol(PARA,@2.first_line,@2.first_column,$2);
            NodoArbol *parc = new NodoArbol(PARC,@4.first_line,@4.first_column,$4);
            NodoArbol *lla = new NodoArbol(LLA,@5.first_line,@5.first_column,$5);
            NodoArbol *llc = new NodoArbol(LLC,@7.first_line,@7.first_column,$7);
        padre->add(si);
        padre->add(para);
        padre->add($3);
        padre->add(parc);
        padre->add(lla);
        padre->add($6);
        padre->add(llc);
        padre->add($8);
        padre->add($9);
        $$ = padre;
    }
;

ELSEIF:
    ELSEIF sino si para EXPRESION parc lla BLOQUE llc 
    {
        NodoArbol *padre = new NodoArbol(ELSEIF);
            NodoArbol *sino = new NodoArbol(SINO,@2.first_line,@2.first_column,$2);
            NodoArbol *si = new NodoArbol(SI,@3.first_line,@3.first_column,$3);
            NodoArbol *para = new NodoArbol(PARA,@4.first_line,@4.first_column,$4);
            NodoArbol *parc = new NodoArbol(PARC,@6.first_line,@6.first_column,$6);
            NodoArbol *lla = new NodoArbol(LLA,@7.first_line,@7.first_column,$7);
            NodoArbol *llc = new NodoArbol(LLC,@9.first_line,@9.first_column,$9);
        padre->add($1);
        padre->add(sino);
        padre->add(si);
        padre->add(para);
        padre->add($5);
        padre->add(parc);
        padre->add(lla);
        padre->add($8);
        padre->add(llc);
        $$ = padre;
    }
    |sino si para EXPRESION parc lla BLOQUE llc
    {
       NodoArbol *padre = new NodoArbol(ELSEIF);
            NodoArbol *sino = new NodoArbol(SINO,@1.first_line,@1.first_column,$1);
            NodoArbol *si = new NodoArbol(SI,@2.first_line,@2.first_column,$2);
            NodoArbol *para = new NodoArbol(PARA,@3.first_line,@3.first_column,$3);
            NodoArbol *parc = new NodoArbol(PARC,@5.first_line,@5.first_column,$5);
            NodoArbol *lla = new NodoArbol(LLA,@6.first_line,@6.first_column,$6);
            NodoArbol *llc = new NodoArbol(LLC,@8.first_line,@8.first_column,$8);
        padre->add(sino);
        padre->add(si);
        padre->add(para);
        padre->add($4);
        padre->add(parc);
        padre->add(lla);
        padre->add($7);
        padre->add(llc);
        $$ = padre;
   }
;

ELSE:
   sino lla BLOQUE llc
   {
        NodoArbol *padre = new NodoArbol(ELSE);
            NodoArbol *sino = new NodoArbol(SINO,@1.first_line,@1.first_column,$1);
            NodoArbol *lla = new NodoArbol(LLA,@2.first_line,@2.first_column,$2);
            NodoArbol *llc = new NodoArbol(LLC,@4.first_line,@4.first_column,$4);
        padre->add(sino);
        padre->add(lla);
        padre->add($3);
        padre->add(llc);
        $$ = padre;
   }
;

FOR:
    ciclo_para para ASIGNACION pntcoma EXPRESION pntcoma EXPRESION pntcoma parc lla BLOQUE llc
    {
        NodoArbol *padre = new NodoArbol(FOR);
            NodoArbol *ciclo_para = new NodoArbol(CICLO_PARA,@1.first_line,@1.first_column,$1);
            NodoArbol *para = new NodoArbol(PARA,@2.first_line,@2.first_column,$2);
            NodoArbol *pntcoma1 = new NodoArbol(PNTCOMA,@4.first_line,@4.first_column,$4);
            NodoArbol *pntcoma2 = new NodoArbol(PNTCOMA,@6.first_line,@6.first_column,$6);
            NodoArbol *pntcoma3 = new NodoArbol(PNTCOMA,@8.first_line,@8.first_column,$8);
            NodoArbol *parc = new NodoArbol(PARC,@9.first_line,@9.first_column,$9);
            NodoArbol *lla = new NodoArbol(LLA,@10.first_line,@10.first_column,$10);
            NodoArbol *llc = new NodoArbol(LLC,@12.first_line,@12.first_column,$12);
        padre->add(ciclo_para);
        padre->add(para);
        padre->add($3);
        padre->add(pntcoma1);
        padre->add($5);
        padre->add(pntcoma2);
        padre->add($7);
        padre->add(pntcoma3);
        padre->add(parc);
        padre->add(lla);
        padre->add($11);
        padre->add(llc);
        $$ = padre;
    }
    |ciclo_para para DECLARACION pntcoma EXPRESION pntcoma EXPRESION pntcoma parc lla BLOQUE llc
    {
        NodoArbol *padre = new NodoArbol(FOR);
            NodoArbol *ciclo_para = new NodoArbol(CICLO_PARA,@1.first_line,@1.first_column,$1);
            NodoArbol *para = new NodoArbol(PARA,@2.first_line,@2.first_column,$2);
            NodoArbol *pntcoma1 = new NodoArbol(PNTCOMA,@4.first_line,@4.first_column,$4);
            NodoArbol *pntcoma2 = new NodoArbol(PNTCOMA,@6.first_line,@6.first_column,$6);
            NodoArbol *pntcoma3 = new NodoArbol(PNTCOMA,@8.first_line,@8.first_column,$8);
            NodoArbol *parc = new NodoArbol(PARC,@9.first_line,@9.first_column,$9);
            NodoArbol *lla = new NodoArbol(LLA,@10.first_line,@10.first_column,$10);
            NodoArbol *llc = new NodoArbol(LLC,@12.first_line,@12.first_column,$12);
        padre->add(ciclo_para);
        padre->add(para);
        padre->add($3);
        padre->add(pntcoma1);
        padre->add($5);
        padre->add(pntcoma2);
        padre->add($7);
        padre->add(pntcoma3);
        padre->add(parc);
        padre->add(lla);
        padre->add($11);
        padre->add(llc);
        $$ = padre;
    }
;

REPETIR:
    ciclo_repetir para EXPRESION parc lla BLOQUE llc
    {
        NodoArbol *padre = new NodoArbol(REPETIR);
            NodoArbol *ciclo_repetir = new NodoArbol(CICLO_REPETIR,@1.first_line,@1.first_column,$1);
            NodoArbol *para = new NodoArbol(PARA,@2.first_line,@2.first_column,$2);
            NodoArbol *parc = new NodoArbol(PARC,@4.first_line,@4.first_column,$4);
            NodoArbol *lla = new NodoArbol(LLA,@5.first_line,@5.first_column,$5);
            NodoArbol *llc = new NodoArbol(LLC,@7.first_line,@7.first_column,$7);
        padre->add(ciclo_repetir);
        padre->add(para);
        padre->add($3);
        padre->add(parc);
        padre->add(lla);
        padre->add($6);
        padre->add(llc);
        $$ = padre;
    }
;