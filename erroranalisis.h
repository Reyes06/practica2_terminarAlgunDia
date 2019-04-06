#ifndef ERRORANALISIS_H
#define ERRORANALISIS_H

#include <QString>
class ErrorAnalisis
{
public:
    QString tipoError;
    char* lexema;
    int linea;
    int columna;
     QString descripcion;

    ErrorAnalisis(QString tipoError,char* lexema,int linea,int columna, QString descripcion);
};

#endif // ERRORANALISIS_H
