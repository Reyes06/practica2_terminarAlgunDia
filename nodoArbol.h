#ifndef NodoArbol_H
#define NodoArbol_H

#include <qstring.h>
#include "tipos.h"
#include <QList>

class NodoArbol{
public:
    //Atributos
    Tipo tipo;
    QString valor;
    int linea;
    int columna;
    QList<NodoArbol*> hijos;


    //Metodos
    NodoArbol(Tipo tipo);
    NodoArbol(Tipo tipo, int linea, int columna, QString valor);
    void add(NodoArbol *n);
    int getTipo();
};

#endif // NodoArbol_H
