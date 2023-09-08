#include "LogData.h"

LogData::LogData(LogWatcher *logWatcher) {
    m_logWatcher = logWatcher;

}

int LogData::rowCount(const QModelIndex& parent) const {
    return m_logs.size();
}

QVariant LogData::data(const QModelIndex& index, int role) const {
    if (index.row() < 0 || index.row() >= m_logs.size()) {
        return QVariant();
    }

    std::shared_ptr<LogItem> log = m_logs.at(index.row());
    switch (role) {
    case LevelRole:
        return log->level;
    case LineRole:
        return log->line;
    case MsgRole:
        return log->msg;
    case SearchRole:
        return QString::number(log->line) + " " +  log->msg;
    default:
        return QVariant();
    }
}

QHash<int, QByteArray> LogData::roleNames() const {
    QHash<int, QByteArray> roles;
    roles[LevelRole] = "level";
    roles[LineRole] = "line";
    roles[MsgRole] = "msg";
    roles[SearchRole] = "search";
    return roles;
}

void LogData::append(QVector<std::shared_ptr<LogItem>> logs) {
    int start = m_logs.size();
    int last = m_logs.size() + logs.size() - 1;
    if (last >= start) {
        beginInsertRows(QModelIndex(), start, last);
        for (auto log : logs) {
            for (auto &it : m_logLevelRegexMap) {
                QRegularExpressionMatch match = it.second.match(log->msg);
                if (match.hasMatch()) {
                    log->level = static_cast<LogItem::LogLevel>(it.first);
                    break;
                }
            }
            m_logs.enqueue(log);
        }
        endInsertRows();
    }
}

void LogData::prepend(QVector<std::shared_ptr<LogItem>> logs) {
    int start = 0;
    int last = logs.size() -1;
    if (last >= start) {
        beginInsertRows(QModelIndex(), 0, 0 + logs.size() - 1);
        for (int i = logs.size() - 1; i >= 0; i--) {
            for (auto &it : m_logLevelRegexMap) {
                QRegularExpressionMatch match = it.second.match(logs[i]->msg);
                if (match.hasMatch()) {
                    logs[i]->level = static_cast<LogItem::LogLevel>(it.first);
                    break;
                }
            }
            m_logs.prepend(logs[i]);
        }
        endInsertRows();
    }
}

void LogData::setLogLevelRegex(QVector<QString> regexs) {
    m_logLevelRegexMap.clear();
    for (int i = 0; i < regexs.size(); i++) {
        QRegularExpression re(regexs[i], QRegularExpression::CaseInsensitiveOption);
        m_logLevelRegexMap[i] = re;
    }
}

void LogData::clear() {
    int start = 0;
    int last = m_logs.size() -1;
    if (last >= start) {
        beginRemoveRows(QModelIndex(), 0, m_logs.size() - 1);
        m_logs.clear();
        endRemoveRows();
    }
}

//void LogData::onNewLogs(QVector<QByteArray> logs) {
//    QVector<std::shared_ptr<LogMsg>> msgs;
//    for (auto log : logs) {
//        auto msg = std::make_shared<LogMsg>();
//        msg->msg = QString::fromUtf8(log);
//        msgs.append(msg);
//        qDebug() << "recv msg: " << msg->msg;
//    }
//    append(msgs);
//}
