#include "nodoArbol.h"

NodoArbol:: NodoArbol(Tipo tipo){
    this->linea = 0;
    this->columna = 0;
    this->tipo = tipo;
    this->valor = nullptr;
    hijos = QList<NodoArbol*>();
}

NodoArbol:: NodoArbol(Tipo tipo, int linea, int columna, QString valor){
    this->linea = linea;
    this->columna = columna;
    this->tipo = tipo;
    this->valor = valor;
    hijos = QList<NodoArbol*>();
}

void NodoArbol::add(NodoArbol *nd){
    this->hijos.append(nd);
}

int NodoArbol::getTipo(){
    return tipo;
}

