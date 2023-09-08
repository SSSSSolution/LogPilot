#ifndef LOG_WATCHER_H
#define LOG_WATCHER_H

#include <QObject>
#include <QFileSystemWatcher>
#include <QFile>
#include <QVector>
#include <QThread>
#include <WinExport.h>

class RealWorker;

struct LOG_WATCHER_API LogItem {
    enum LogLevel {
        None = -1,
        Trace = 0,
        Debug,
        Info,
        Warn,
        Error,
        Fatal,
    };

    LogLevel level = None;
    int line;
    QString msg;
};

typedef std::function<void (QVector<std::shared_ptr<LogItem>> logItems, bool success, QString errStr)> LoadBlockCallback;


class LOG_WATCHER_API LogWatcher : public QObject {
    Q_OBJECT
public:
    explicit LogWatcher(QObject *parent = nullptr);
    ~LogWatcher();

    void startWatch(const QString &path, LoadBlockCallback callback, const QString &filter);

    void stopWatch();

    void loadFrontBlock(LoadBlockCallback callback);

signals:
    void newTailLogs(QVector<std::shared_ptr<LogItem>> logs);
    void triggerLoadFrontBlock(QObject *sender, LoadBlockCallback callback);

private:
    void onFileChanged(const QString &path);

private:
    QThread m_workerThread;
    QString m_filePath;

    std::unique_ptr<RealWorker> m_worker;
};

class RealWorker : public QObject {
    Q_OBJECT
public:
    explicit RealWorker(QObject *parent = nullptr);
    ~RealWorker();

    void setFilePath(const QString &path);

    void setFilter(const QString &filter);

    void setStartCallback(QObject *sender, LoadBlockCallback callback);

    void startWork();

    void stopWork();

    void loadFrontBlock(QObject *sender, LoadBlockCallback callback);
signals:
//    void newFrontLogs(QVector<LogItem> logs);
    void newTailLogs(QVector<std::shared_ptr<LogItem>> logs);


private:
    void onFileChanged(const QString &path);
    void recordLinePosMap();

private:
//    QFileSystemWatcher *m_watcher;
    QTimer *m_pollTimer;

    QString m_filePath;
    QFile   m_curFile;
    QString m_filter;

    qint64  m_frontPosition;
    int m_headLine;
    int m_tailLine;
    qint64  m_tailPosition;
    std::unordered_map<int, int> m_linePosMap;
//    std::unordered_map<int, QString> m_logMap;

    QObject *m_startLoadCallbackSender;
    LoadBlockCallback m_startLoadCallback;
};

#endif // LOG_WATCHER_H
