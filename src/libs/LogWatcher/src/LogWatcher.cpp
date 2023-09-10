#include "LogWatcher/LogWatcher.h"
#include <QFile>
#include <QTextStream>
#include <QThread>
#include <QTimer>
#include <QDebug>
#include <iostream>

static const int BlockSize = 1024;

LogWatcher::LogWatcher(QObject *parent)
    : QObject(parent)
{
    m_worker = std::make_unique<RealWorker>();
    m_worker->moveToThread(&m_workerThread);
    qDebug() << "main thread" << QThread::currentThread();


    connect(&m_workerThread, &QThread::started,
            m_worker.get(), &RealWorker::startWork);
    connect(&m_workerThread, &QThread::finished,
            m_worker.get(), &RealWorker::stopWork);
}

LogWatcher::~LogWatcher()
{
    stopWatch();
}

void LogWatcher::startWatch(const QString &path, LoadBlockCallback callback, const QString &filter,
                            LogItem::LogLevel level, const std::map<LogItem::LogLevel, QString> &logLevelRegexs) {
    m_filePath = path;
    connect(m_worker.get(), &RealWorker::newTailLogs,
            this, &LogWatcher::newTailLogs, Qt::QueuedConnection);
    connect(this, &LogWatcher::triggerLoadFrontBlock,
            m_worker.get(), &RealWorker::loadFrontBlock, Qt::QueuedConnection);

    m_worker->setFilePath(path);
    m_worker->setFilter(filter);
    m_worker->setLogLevel(level, logLevelRegexs);
    m_worker->setStartCallback(this, callback);
    m_workerThread.start();
}

void LogWatcher::stopWatch() {
    disconnect(m_worker.get(), &RealWorker::newTailLogs,
               this, &LogWatcher::newTailLogs);
    disconnect(this, &LogWatcher::triggerLoadFrontBlock,
               m_worker.get(), &RealWorker::loadFrontBlock);
    m_workerThread.quit();
    m_workerThread.wait();
}

void LogWatcher::loadFrontBlock(LoadBlockCallback callback) {
    emit triggerLoadFrontBlock(this, callback);
}

// RealWorker
RealWorker::RealWorker(QObject *parent)
    : QObject(parent)
{}

RealWorker::~RealWorker() {
}

void RealWorker::setFilePath(const QString &path) {
    m_filePath = path;
}

void RealWorker::setFilter(const QString &filter) {
    m_filter = filter;
}

void RealWorker::setLogLevel(LogItem::LogLevel level, const std::map<LogItem::LogLevel, QString> &logLevelRegexs) {
    m_level = level;
    m_logLevelRegexs.clear();
    for (auto it : logLevelRegexs) {
        QRegularExpression re(it.second, QRegularExpression::CaseInsensitiveOption);
        m_logLevelRegexs[it.first] = re;
    }
}

void RealWorker::setStartCallback(QObject *sender, LoadBlockCallback callback) {
    m_startLoadCallbackSender = sender;
    m_startLoadCallback = callback;
}

static void sendBackCallback(QObject *sender, LoadBlockCallback callback,
                             const QVector<std::shared_ptr<LogItem>> &logs, bool success, const QString &errStr = "") {
    assert(sender && callback);
    QTimer::singleShot(0, sender, [=](){
        if (callback) {
            callback(logs, success, errStr);
        }
    });
}

void RealWorker::startWork() {
    qDebug() << "worker thread" << QThread::currentThread();
    qDebug() << "real worker start work!";
    QVector<std::shared_ptr<LogItem>> blockLogs;

    m_curFile.setFileName(m_filePath);
    if (!m_curFile.open(QIODevice::ReadOnly)) {
        QString errStr = "Failed to open file: " + m_filePath;
        sendBackCallback(m_startLoadCallbackSender, m_startLoadCallback, blockLogs, false, errStr);
        return;
    }

    recordLinePosMap();

    if (m_tailLine > 0) {
        int startLine = m_tailLine - BlockSize + 1;
        if (startLine < 1) {
            startLine = 1;
        }
        m_headLine = startLine;

        int startPos = m_linePosMap[startLine];
        m_curFile.seek(startPos);
        for (int i = startLine; i <= m_tailLine; i++) {
            auto log = std::make_shared<LogItem>();
            log->line = i;
            log->msg = m_curFile.readLine().trimmed();

            // process log level
            bool found = false;
            for (auto &it : m_logLevelRegexs) {
                QRegularExpressionMatch match = it.second.match(log->msg);
                if (match.hasMatch()) {
                    log->level = static_cast<LogItem::LogLevel>(it.first);
                    found = true;
                    break;
                }
            }
            if (!found) {
                log->level = LogItem::LogLevel::None;
            }
            if (log->level < m_level) {
                continue;
            }

            // process filter
            if (m_filter.isEmpty() || log->msg.contains(m_filter, Qt::CaseInsensitive)) {
                blockLogs.push_back(log);
            }
        }
    }

    sendBackCallback(m_startLoadCallbackSender, m_startLoadCallback, blockLogs, true);


    m_pollTimer = new QTimer(this);
    connect(m_pollTimer, &QTimer::timeout, this, [=]() {
        if (m_curFile.isOpen()) {
            QVector<std::shared_ptr<LogItem>> newLogs;
            int startPos = m_linePosMap[m_tailLine + 1];
            m_curFile.seek(startPos);

            if (m_curFile.atEnd())
                return;

            while (true) {
                QByteArray all = m_curFile.readAll();
                if (all.isEmpty() || !all.contains('\n'))
                    break;

                startPos = m_linePosMap[m_tailLine + 1];
                m_curFile.seek(startPos);
                QByteArray line = m_curFile.readLine();

                auto log = std::make_shared<LogItem>();
                log->msg = line.trimmed();
                log->line = m_tailLine + 1;

                // process log level
                bool found = false;
                for (auto &it : m_logLevelRegexs) {
                    QRegularExpressionMatch match = it.second.match(log->msg);
                    if (match.hasMatch()) {
                        log->level = static_cast<LogItem::LogLevel>(it.first);
                        found = true;
                        break;
                    }
                }
                if (!found) {
                    log->level = LogItem::LogLevel::None;
                }
                if (log->level < m_level) {
                    continue;
                }

                // process filter
                if (m_filter.isEmpty() || log->msg.contains(m_filter, Qt::CaseInsensitive)) {
                    newLogs.push_back(log);
                }
                m_tailLine++;
                m_linePosMap[m_tailLine + 1] = m_linePosMap[m_tailLine] + line.size();

            }
            if (newLogs.size() > 0) {
                emit newTailLogs(newLogs);
            }
        } else {
            // test when delete file
            qCritical() << "cur log file is closed!";
        }
    });
    m_pollTimer->start(10);


    m_startLoadCallbackSender = nullptr;
    m_startLoadCallback = nullptr;
}

void RealWorker::stopWork() {
    qDebug() << "real worker stop work!";
    if (m_pollTimer) {
        m_pollTimer->stop();
        m_pollTimer->deleteLater();
        m_curFile.close();
    }
    m_filePath = "";
    m_filter = "";
    m_linePosMap.clear();
}

void RealWorker::loadFrontBlock(QObject *sender, LoadBlockCallback callback) {
    QVector<std::shared_ptr<LogItem>> blockLogs;

    if (m_headLine <= 0) {
        sendBackCallback(sender, callback, blockLogs, false, "NO MORE LOGS");
        return;
    }

    int startLine = m_headLine - BlockSize + 1;
    if (startLine < 1) {
        startLine = 1;
    }

    int startPos = m_linePosMap[startLine];
    m_curFile.seek(startPos);
    for (int i = startLine; i <= m_headLine; i++) {
        auto log = std::make_shared<LogItem>();
        log->line = i;
        log->msg = m_curFile.readLine().trimmed();

        // process log level
        bool found = false;
        for (auto &it : m_logLevelRegexs) {
            QRegularExpressionMatch match = it.second.match(log->msg);
            if (match.hasMatch()) {
                log->level = static_cast<LogItem::LogLevel>(it.first);
                found = true;
                break;
            }
        }
        if (!found) {
            log->level = LogItem::LogLevel::None;
        }
        if (log->level < m_level) {
            continue;
        }

        // process filter
        if (m_filter.isEmpty() || log->msg.contains(m_filter, Qt::CaseInsensitive)) {
            blockLogs.push_back(log);
        }
    }

    m_headLine = m_headLine - BlockSize;
    sendBackCallback(sender, callback, blockLogs, true);
}

void RealWorker::recordLinePosMap() {
    int lineIdx = 1;
    int curPos = 0;

    m_curFile.seek(0);
    while (!m_curFile.atEnd()) {
        QByteArray line = m_curFile.readLine();
        m_linePosMap[lineIdx++] = curPos;
        curPos += line.size();
    }

    m_tailLine = lineIdx - 1;
    m_headLine = m_tailLine - 1;

    qDebug() << m_tailLine << ", " << m_headLine;

    // Record pos of last line's next line
    m_linePosMap[m_tailLine + 1] = curPos;
}















