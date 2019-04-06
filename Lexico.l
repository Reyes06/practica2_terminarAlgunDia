/*======================================OPCIONES=======================================*/
%option case-insensitive
%option yylineno
%option header-file="scanner.h"
%option outfile="scanner.cpp"
%option noyywrap
%option nounput
/*=================================CODIGO DE USUARIO.h=================================*/
%{
#include "parser.h"
#include "erroranalisis.h"
#include <QString>
#include <stdio.h>
#include <iostream>
#include "nodoArbol.h"
#include <qlist.h>

int yylex();
void yyerror(const char *s);

int linea = 1; 
int columna = 1;
int anterior = 0;
NodoArbol *raiz;
QList<ErrorAnalisis*> erroresLexicos;
%}
/*===============================EXPRESIONES REGULARES===================================*/
entero [0-9]+
booleano ("verdadero"|"falso"|"true"|"false")
decimal [0-9]+"."[0-9]+
cadena "\""[^"\""]*"\""
id [a-zñA-ZÑ]([a-zñA-ZÑ]|[0-9]|"_")*
caracter "\'"("\\")?[a-zñA-ZÑ0-9]"\'"
/*=======================================ESTADOS==========================================*/
%x COM COMM
%%
    /*====================================REGLAS_LEXICAS======================================*/
<INITIAL>"//"       {BEGIN COM; }
<INITIAL>"/*"       {BEGIN COMM; }

<INITIAL>"("        {std::cout<<yytext<<std::endl; columna+=yyleng; strcpy(yylval.TEXT,yytext); return para; }
<INITIAL>")"        {std::cout<<yytext<<std::endl; columna+=yyleng; strcpy(yylval.TEXT,yytext); return parc; }
<INITIAL>"{"        {std::cout<<yytext<<std::endl; columna+=yyleng; strcpy(yylval.TEXT,yytext); return lla; }
<INITIAL>"}"        {std::cout<<yytext<<std::endl; columna+=yyleng; strcpy(yylval.TEXT,yytext); return llc; }
<INITIAL>"["        {std::cout<<yytext<<std::endl; columna+=yyleng; strcpy(yylval.TEXT,yytext); return cora; }
<INITIAL>"]"        {std::cout<<yytext<<std::endl; columna+=yyleng; strcpy(yylval.TEXT,yytext); return corc; }
<INITIAL>"="        {std::cout<<yytext<<std::endl; columna+=yyleng; strcpy(yylval.TEXT,yytext); return igual; }
<INITIAL>";"        {std::cout<<yytext<<std::endl; columna+=yyleng; strcpy(yylval.TEXT,yytext); return pntcoma; }
<INITIAL>","        {std::cout<<yytext<<std::endl; columna+=yyleng; strcpy(yylval.TEXT,yytext); return coma; }
<INITIAL>"+"        {std::cout<<yytext<<std::endl; columna+=yyleng; strcpy(yylval.TEXT,yytext); return mas; }
<INITIAL>"-"        {std::cout<<yytext<<std::endl; columna+=yyleng; strcpy(yylval.TEXT,yytext); return menos; }
<INITIAL>"*"        {std::cout<<yytext<<std::endl; columna+=yyleng; strcpy(yylval.TEXT,yytext); return por; }
<INITIAL>"/"        {std::cout<<yytext<<std::endl; columna+=yyleng; strcpy(yylval.TEXT,yytext); return barra; }
<INITIAL>"=="       {std::cout<<yytext<<std::endl; columna+=yyleng; strcpy(yylval.TEXT,yytext); return igualque; }
<INITIAL>"!="       {std::cout<<yytext<<std::endl; columna+=yyleng; strcpy(yylval.TEXT,yytext); return diferenteque; }
<INITIAL>"<"        {std::cout<<yytext<<std::endl; columna+=yyleng; strcpy(yylval.TEXT,yytext); return menorque; }
<INITIAL>">"        {std::cout<<yytext<<std::endl; columna+=yyleng; strcpy(yylval.TEXT,yytext); return mayorque; }
<INITIAL>"<="       {std::cout<<yytext<<std::endl; columna+=yyleng; strcpy(yylval.TEXT,yytext); return menorigualque; }
<INITIAL>">="       {std::cout<<yytext<<std::endl; columna+=yyleng; strcpy(yylval.TEXT,yytext); return mayorigualque; }
<INITIAL>"!"        {std::cout<<yytext<<std::endl; columna+=yyleng; strcpy(yylval.TEXT,yytext); return notnot; }
<INITIAL>"^"        {std::cout<<yytext<<std::endl; columna+=yyleng; strcpy(yylval.TEXT,yytext); return pot; }
<INITIAL>"&&"       {std::cout<<yytext<<std::endl; columna+=yyleng; strcpy(yylval.TEXT,yytext); return andand; }
<INITIAL>"||"       {std::cout<<yytext<<std::endl; columna+=yyleng; strcpy(yylval.TEXT,yytext); return oror; }
<INITIAL>"--"       {std::cout<<yytext<<std::endl; columna+=yyleng; strcpy(yylval.TEXT,yytext); return decremento; }
<INITIAL>"++"       {std::cout<<yytext<<std::endl; columna+=yyleng; strcpy(yylval.TEXT,yytext); return incremento; }
<INITIAL>"int"      {std::cout<<yytext<<std::endl; columna+=yyleng; strcpy(yylval.TEXT,yytext); return tipo; }
<INITIAL>"double"   {std::cout<<yytext<<std::endl; columna+=yyleng; strcpy(yylval.TEXT,yytext); return tipo; }
<INITIAL>"char"     {std::cout<<yytext<<std::endl; columna+=yyleng; strcpy(yylval.TEXT,yytext); return tipo; }
<INITIAL>"bool"     {std::cout<<yytext<<std::endl; columna+=yyleng; strcpy(yylval.TEXT,yytext); return tipo; }
<INITIAL>"string"   {std::cout<<yytext<<std::endl; columna+=yyleng; strcpy(yylval.TEXT,yytext); return tipo; }
<INITIAL>"arreglo"  {std::cout<<yytext<<std::endl; columna+=yyleng; strcpy(yylval.TEXT,yytext); return arreglo; }
<INITIAL>"imprimir" {std::cout<<yytext<<std::endl; columna+=yyleng; strcpy(yylval.TEXT,yytext); return imprimir; }
<INITIAL>"show"     {std::cout<<yytext<<std::endl; columna+=yyleng; strcpy(yylval.TEXT,yytext); return show; }
<INITIAL>"si"       {std::cout<<yytext<<std::endl; columna+=yyleng; strcpy(yylval.TEXT,yytext); return si; }
<INITIAL>"sino"     {std::cout<<yytext<<std::endl; columna+=yyleng; strcpy(yylval.TEXT,yytext); return sino; }
<INITIAL>"para"     {std::cout<<yytext<<std::endl; columna+=yyleng; strcpy(yylval.TEXT,yytext); return ciclo_para; }
<INITIAL>"repetir"  {std::cout<<yytext<<std::endl; columna+=yyleng; strcpy(yylval.TEXT,yytext); return ciclo_repetir; }
<INITIAL>{entero}   {std::cout<<yytext<<std::endl; columna+=yyleng; strcpy(yylval.TEXT,yytext); return entero;}
<INITIAL>{decimal}  {std::cout<<yytext<<std::endl; columna+=yyleng; strcpy(yylval.TEXT,yytext); return decimal;}
<INITIAL>{caracter} {std::cout<<yytext<<std::endl; columna+=yyleng; strcpy(yylval.TEXT,yytext); return caracter;}
<INITIAL>{booleano} {std::cout<<yytext<<std::endl; columna+=yyleng; strcpy(yylval.TEXT,yytext); return booleano;}
<INITIAL>{cadena}   {std::cout<<yytext<<std::endl; columna+=yyleng; strcpy(yylval.TEXT,yytext); return cadena;}
<INITIAL>{id}       {std::cout<<yytext<<std::endl; columna+=yyleng; strcpy(yylval.TEXT,yytext); return id;}

<INITIAL>"\n"       {linea++; columna = 1; anterior = 0;}
<INITIAL>"\t"       {columna+=4;}
<INITIAL>" "        {columna+=1; }
    /*=====================ERROR_LEXICO=========================*/
<INITIAL>.  {
                columna+=yyleng; strcpy(yylval.TEXT, yytext);
                ErrorAnalisis *nuevo = new ErrorAnalisis("Lexico",yytext,linea,columna,"Simbolo no reconocido en el lenguaje");
                erroresLexicos.append(nuevo);
                std::cout <<yytext <<" Error Lexico en la linea "<< linea << " Columna:"<< columna<<  std::endl;
            }
    /*===============COMENTARIOS_MULTILINEA=====================*/
<COMM>"*/"          { BEGIN INITIAL; }
<COMM>"\n"          {linea++;}
<COMM>.             {}
    /*=================COMENTARIOS_SIMPLES======================*/
<COM>"\n"           { linea++; columna = 1; anterior = 0; BEGIN INITIAL; }
<COM>.              {}

%%