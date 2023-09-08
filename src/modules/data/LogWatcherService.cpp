#include "LogWatcherService.h"
#include <QElapsedTimer>
#include <QRegExp>
#include <iostream>

LogWatcherService::LogWatcherService() {
    m_logWatcher = std::make_unique<LogWatcher>();
    m_logData = std::make_unique<LogData>(m_logWatcher.get());
    m_filterProxyModel = new QSortFilterProxyModel();
    m_filterProxyModel->setSourceModel(m_logData.get());
    m_filterProxyModel->setFilterRole(LogData::SearchRole);
    m_filterProxyModel->setFilterCaseSensitivity(Qt::CaseInsensitive);
    m_filterProxyModel->setFilterKeyColumn(0);

    m_curModel = m_logData.get();

    connect(m_logWatcher.get(), &LogWatcher::newTailLogs, this, [=](QVector<std::shared_ptr<LogItem>> logs){
        m_logData->append(logs);
    });
}

void LogWatcherService::startWork(QString path, StartCallableObject *cbObj, const QString &filter) {
    qDebug() << "log watcher service: START at " << path;

    m_logData->clear();
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
    }, filter);
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

void LogWatcherService::setFilter(const QString &regex) {
    m_filterProxyModel->setFilterFixedString(regex);
    qDebug() << "set filter: " << regex;
    qDebug() << "filtered rows: " << m_filterProxyModel->rowCount();

    m_curModel = m_filterProxyModel;
    QElapsedTimer timer;
    timer.start();
    emit logDataChanged();
    std::cout << timer.elapsed() << "ms" << std::endl;
}

void LogWatcherService::unsetFilter() {
    m_curModel = m_logData.get();

    QElapsedTimer timer;
    timer.start();
    emit logDataChanged();
    emit logDataChanged();
    std::cout << timer.elapsed() << "ms" << std::endl;
}

QAbstractItemModel *LogWatcherService::logData() {
    qDebug() << "hahaha";
    return m_curModel;
}

void LogWatcherService::setLogLevelRegex(QVector<QString> regexs) {
    m_logData->setLogLevelRegex(regexs);
}

void LogWatcherService::onCurLineChanged(int curLine) {
    qDebug() << "not impl onCurLineChanged()";
}

void LogWatcherService::onPageItemCountChanged(int pageItemCount) {
    qDebug() << "not impl onPageItemCountChanged()";
}

