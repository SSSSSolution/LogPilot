#ifndef LOG_MSG_H
#define LOG_MSG_H

#include <QObject>
#include <QQmlEngine>
#include <WinExport.h>

class DATA_API LogMsg : public QObject {
    Q_OBJECT
    QML_ELEMENT
public:
    int line;
    QString msg;
};



#endif // LOG_MSG_H
