#include "LogWatcherService.h"
#include <QElapsedTimer>
#include <QRegExp>
#include <QVariantMap>
#include <iostream>

LogWatcherService::LogWatcherService() {
    m_logWatcher = std::make_unique<LogWatcher>();
    m_logData = std::make_unique<LogData>(m_logWatcher.get());

    m_curModel = m_logData.get();

    connect(m_logWatcher.get(), &LogWatcher::newTailLogs, this, [=](QVector<std::shared_ptr<LogItem>> logs){
        m_logData->append(logs);
    });
}

void LogWatcherService::startWork(QString path, StartCallableObject *cbObj, const QString &filter,
                                  LogItem::LogLevel logLevel, const QVariantMap &logLevelRegexs, int startLine) {
    qDebug() << "log watcher service: START at " << path;

    m_logData->clear();

    std::map<LogItem::LogLevel, QString> regexsMap;
    regexsMap[LogItem::LogLevel::Trace] =  logLevelRegexs["trace"].toString();
    regexsMap[LogItem::LogLevel::Debug] =  logLevelRegexs["debug"].toString();
    regexsMap[LogItem::LogLevel::Info] =  logLevelRegexs["info"].toString();
    regexsMap[LogItem::LogLevel::Warn] =  logLevelRegexs["warn"].toString();
    regexsMap[LogItem::LogLevel::Error] =  logLevelRegexs["error"].toString();
    regexsMap[LogItem::LogLevel::Fatal] =  logLevelRegexs["fatal"].toString();


    m_logWatcher->startWatch(path, [=](QVector<std::shared_ptr<LogItem>> logItems, bool success, QString errStr){
        if (success) {
            m_logData->append(logItems);
            if (cbObj) {
                emit cbObj->successed();
            }
        } else {
            qDebug() << "start Watch failed: " << errStr;
            stopWork();
            if (cbObj) {
                emit cbObj->failed(errStr);
            }
        }
    }, filter, logLevel, regexsMap, startLine);
}

void LogWatcherService::stopWork() {
    qDebug() << "Stop Watch";
    m_logWatcher->stopWatch();
    m_logData->clear();
}

void LogWatcherService::loadFrontBlock(LoadFrontBlockCallableObject *cbObj) {
    m_logWatcher->loadFrontBlock([=](QVector<std::shared_ptr<LogItem>> logItems, bool success, QString errStr){
        if (success) {
            m_logData->prepend(logItems);
            if (cbObj) {
                cbObj->setLoadedLogsCount(logItems.size());
                emit cbObj->successed();
            }
        } else {
            if (cbObj) {
                emit cbObj->failed(errStr);
            }
        }
    });
}

QAbstractItemModel *LogWatcherService::logData() {
    return m_curModel;
}

bool LogWatcherService::testRegexMatch(const QString &str, const QString &regex) {
    QRegularExpression re(regex, QRegularExpression::CaseInsensitiveOption);
    QRegularExpressionMatch match = re.match(str);
    return match.hasMatch();
}

void LogWatcherService::onCurLineChanged(int curLine) {
    qDebug() << "not impl onCurLineChanged()";
}

void LogWatcherService::onPageItemCountChanged(int pageItemCount) {
    qDebug() << "not impl onPageItemCountChanged()";
}

