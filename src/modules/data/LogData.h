#ifndef LOG_DATA_H
#define LOG_DATA_H

#include <QAbstractListModel>
#include <QQmlEngine>
#include <QQueue>
#include <QRegularExpression>
#include <WinExport.h>
#include <LogWatcher/LogWatcher.h>
#include "LogMsg.h"

class DATA_API LogData : public QAbstractListModel {
    Q_OBJECT
//    QML_ELEMENT
public:
    enum LogDataRoles {
        LineRole = Qt::UserRole + 1,
        LevelRole,
        MsgRole,
        SearchRole,
    };


    LogData(LogWatcher *logWatcher);
    ~LogData() = default;

    virtual int rowCount(const QModelIndex& parent = QModelIndex()) const override;

    virtual QVariant data(const QModelIndex& index, int role = Qt::DisplayRole) const override;

    virtual QHash<int, QByteArray> roleNames() const override;

    void append(QVector<std::shared_ptr<LogItem>> logs);

    void prepend(QVector<std::shared_ptr<LogItem>> logs);

    void clear();

private:
    QQueue<std::shared_ptr<LogItem>> m_logs;
    LogWatcher *m_logWatcher;
};

#endif // LOG_DATA_H
