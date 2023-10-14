#include "FileIO.h"

#include <QFile>
#include <QTextStream>
#include <QDebug>

FileIO::FileIO(QObject *parent) : QObject(parent) {
}

QString FileIO::read(const QString &path) {
    QFile file(path);
    if (!file.open(QIODevice::ReadOnly | QIODevice::Text)) {
        return QString();
    }

    QTextStream in(&file);
    QString content = in.readAll();
    file.close();

    return content;
}

bool FileIO::write(const QString &path, const QString &content) {
    QFile file(path);
    if (!file.open(QIODevice::WriteOnly | QIODevice::Text)) {
        return false;
    }

    QTextStream out(&file);
    out << content;
    file.close();

    return true;
}
