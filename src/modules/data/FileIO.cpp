#include "FileIO.h"

#include <QDebug>

FileIO::FileIO(QObject *parent) : QObject(parent) {

}

QString FileIO::read(const QString &path) {
    QFile file(path);
    if (file.open(QIODevice::ReadOnly | QIODevice::Text)) {
        QTextStream in(&file);
        return in.readAll();
    }
    qCritical() << "Failed to read file: " << path;
    return "";
}

bool FileIO::write(const QString &path, const QString &content) {
    QFile file(path);
    if (file.open(QIODevice::WriteOnly | QIODevice::Text)) {
        QTextStream out(&file);
        out << content;
        return true;
    }
    return false;
}
