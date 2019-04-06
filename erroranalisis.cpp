#include "erroranalisis.h"

ErrorAnalisis::ErrorAnalisis(QString tipoError,char* lexema,int linea,int columna, QString descripcion)
{
    this->tipoError = tipoError;
    this->lexema = lexema;
    this->linea = linea;
    this->columna = columna;
    this->descripcion = descripcion;
}
