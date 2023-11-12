#ifndef LOG_WATCHER_SERVICE_H
#define LOG_WATCHER_SERVICE_H

#include <memory>
#include <QObject>
#include <QQmlEngine>
#include <LogWatcher/LogWatcher.h>
#include <LogData.h>
#include <WinExport.h>

enum class LogWatchStatus {
    Stopped,
    Running,
    Error,
};

class StartCallableObject : public QObject {
    Q_OBJECT
    QML_ELEMENT

signals:
    void successed();
    void failed(QString errStr);
};

class LoadFrontBlockCallableObject : public QObject {
    Q_OBJECT
    QML_ELEMENT
    Q_PROPERTY(int loadedLogsCount READ loadedLogsCount NOTIFY loadedLogsCountChanged FINAL)

public:
    ~LoadFrontBlockCallableObject() {
    }

    Q_INVOKABLE int loadedLogsCount() const {
        return m_loadedLogsCount;
    }

    void setLoadedLogsCount(int count) {
        m_loadedLogsCount = count;
    }

signals:
    void successed();
    void failed(QString errStr);
    void loadedLogsCountChanged();

private:
    int m_loadedLogsCount = 0;
};


class DATA_API LogWatcherService : public QObject {
    Q_OBJECT
    QML_ELEMENT
    Q_PROPERTY(QAbstractItemModel* logData READ logData NOTIFY logDataChanged)

public:
    LogWatcherService();
    ~LogWatcherService() = default;

    Q_INVOKABLE void startWork(QString path, StartCallableObject *cbObj, const QString &filter,
                               LogItem::LogLevel logLevel, const QVariantMap &logLevelRegexs, int startLine);

    Q_INVOKABLE void stopWork();

    Q_INVOKABLE void loadFrontBlock(LoadFrontBlockCallableObject *cbObj = nullptr);

    Q_INVOKABLE void onCurLineChanged(int curLine);

    Q_INVOKABLE void onPageItemCountChanged(int pageItemCount);

    Q_INVOKABLE QAbstractItemModel *logData();

    Q_INVOKABLE bool testRegexMatch(const QString &str, const QString &regex);

signals:
    void watchStarted();
    void watchFailed(const QString &errStr);
    void newLogItems(QVector<std::shared_ptr<LogItem>> logs);
    // For qml happy
    void logDataChanged();

private:
    LogWatchStatus m_status = LogWatchStatus::Stopped;
    QString m_serviceErrStr;

    std::unique_ptr<LogWatcher> m_logWatcher;
    std::unique_ptr<LogData> m_logData;
    QAbstractItemModel *m_curModel;

    int m_curLine;
};

#endif // LOG_WATCHER_SERVICE_H
