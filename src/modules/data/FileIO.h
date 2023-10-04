#ifndef FILE_IO_H
#define FILE_IO_H

#include <QObject>
#include <QFile>
#include <QTextStream>
#include <QQmlEngine>

class FileIO : public QObject {
    Q_OBJECT
    QML_ELEMENT

public:
    explicit FileIO(QObject *parent = nullptr);

    Q_INVOKABLE QString read(const QString &path);
    Q_INVOKABLE bool write(const QString &path, const QString &content);
};

#endif
