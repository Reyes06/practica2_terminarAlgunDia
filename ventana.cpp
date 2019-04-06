#include "ventana.h"
#include "ui_mainwindow.h"

#include <QFileDialog>
#include <fstream>
#include <stdlib.h>
#include <QTextStream>
#include <QMessageBox>
#include "parser.h"
#include "scanner.h"

extern int yyparse(); //
extern NodoArbol *raiz; // Raiz del arbol
extern int linea; // Linea del token
extern int columna; // Columna de los tokens
extern int yylineno;


MainWindow::MainWindow(QWidget *parent) :
    QMainWindow(parent),
    ui(new Ui::MainWindow)
{
    ui->setupUi(this);
}

MainWindow::~MainWindow()
{
    delete ui;
}

void MainWindow::on_pushButton_clicked()
{

    ui->areaEdicion->clear();

}

void MainWindow::on_pushButton_2_clicked()
{
    QString ruta = QFileDialog::getOpenFileName(this,"Abrir","/home/jotarh/Documentos","Text Files (*.txt);;All files(*.*)");
    if(!ruta.isEmpty()){
        this->archivo=ruta;
    }

    if(!archivo.isEmpty()){
        QFile file (archivo);

        if(file.open(QFile::ReadOnly)){
           ui->areaEdicion->setPlainText(file.readAll());
            QMessageBox::information(this,"Exito",tr("Archivo abierto exitosamente"));
        } else {
            QMessageBox::warning(this,"Error",tr("No se pudo arbrir el archivo.").arg(archivo).arg(file.errorString()));
        }
    }
}

void MainWindow::on_pushButton_3_clicked()
{
    if(archivo.isEmpty()){
        QString ruta = QFileDialog::getSaveFileName(this,"Guardar","/home/jotarh/Documentos","Text Files (*.txt);;All files(*.*)");
        if(!ruta.isEmpty()){
            this->archivo=ruta;
        }
    }

    if(!archivo.isEmpty()){
        QFile file (archivo);

        if(file.open(QFile::WriteOnly)){
            file.write(ui->areaEdicion->toPlainText().toUtf8());
            QMessageBox::information(this,"Exito",tr("Archivo guardado exitosamente"));
        } else {
            QMessageBox::warning(this,"Error",tr("No se pudo guardar el archivo.").arg(archivo).arg(file.errorString()));
        }
    }
}

void MainWindow::on_pushButton_4_clicked()
{
    QString ruta = QFileDialog::getSaveFileName(this,"Guardar","/home/jotarh/Documentos","Text Files (*.txt);;All files(*.*)");
    if(!ruta.isEmpty()){
        this->archivo=ruta;
    } else {
        archivo = nullptr;
    }


    if(!archivo.isEmpty()){
        QFile file (archivo);

        if(file.open(QFile::WriteOnly)){
            file.write(ui->areaEdicion->toPlainText().toUtf8());
            QMessageBox::information(this,"Exito",tr("Archivo guardado exitosamente"));
        } else {
            QMessageBox::warning(this,"Error",tr("No se puede arbrir el archivo.").arg(archivo).arg(file.errorString()));
        }
    }
}

void MainWindow::on_pushButton_5_clicked()
{
    QString programa = ui->areaEdicion->toPlainText();
    yy_scan_string(programa.toUtf8().constData());
    /*Limpiamos los contadores
    ya que son variables globales*/
    linea = 0;
    columna = 0;
    yylineno = 0;
    if(yyparse()==0) // Si nos da un número negativo, signifca error.
    {
        QMessageBox::information(this,"Exito",tr("Archivo analizado exitosamente"));
    } else {
        QMessageBox::information(this,"Error",tr("Archivo analizado con fracaso"));
    }
}
