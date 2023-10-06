#include "LogConfigModel.h"

#include <QCoreApplication>
#include <QFile>
#include <QDir>
#include <QJsonDocument>
#include <QJsonObject>

LogConfig::LogConfig(const QString &name): name(name) {

}

LogConfigModel::LogConfigModel(QObject *parent) : QAbstractListModel(parent) {
    loadBuildInConfig();
    loadUserConfigs();
}

void LogConfigModel::loadBuildInConfig() {
    QString buildInConfigUrl = ":/configs/LogPilotConfig.json";
    QFile configFile(buildInConfigUrl);

    if (!configFile.open(QIODevice::ReadOnly)) {
        qWarning() << "Couldn't open log config file: " << buildInConfigUrl;
        return;
    }

    QByteArray configData = configFile.readAll();
    QJsonParseError jsonError;
    QJsonDocument jsonDoc = QJsonDocument::fromJson(configData, &jsonError);

    if (jsonError.error != QJsonParseError::NoError) {
        qWarning() << "Failed to parse log config: " << jsonError.errorString();
        return;
    }

    auto logConfig = std::make_unique<LogConfig>("build-in");
    logConfig->config = jsonDoc.object().toVariantMap();
    m_logConfigs.push_back(std::move(logConfig));

    configFile.close();
}

void LogConfigModel::loadUserConfigs() {
    QString appDataDir = qApp->property("AppDataDir").toString();
    if (appDataDir.isEmpty()) {
        return;
    }

    QDir dir(appDataDir);
    QStringList filters;
    filters << "*.json";
    dir.setNameFilters(filters);

    QFileInfoList fileInfoList = dir.entryInfoList();
    foreach(const QFileInfo &fileInfo, fileInfoList) {
        QFile file(fileInfo.absoluteFilePath());
        if (!file.open(QIODevice::ReadOnly)) {
            qWarning() << "Couldn't open log config file:" << fileInfo.absoluteFilePath();
            continue;
        }

        QByteArray configData = file.readAll();
        QJsonParseError jsonError;
        QJsonDocument jsonDoc = QJsonDocument::fromJson(configData, &jsonError);

        auto logConfig = std::make_unique<LogConfig>(fileInfo.baseName());
        logConfig->config = jsonDoc.object().toVariantHash();
        logConfig->path = fileInfo.absoluteFilePath();
        m_logConfigs.push_back(std::move(logConfig));

        file.close();
    }
}

int LogConfigModel::rowCount(const QModelIndex &parent) const {
    return static_cast<int>(m_logConfigs.size());
}

QVariant LogConfigModel::data(const QModelIndex &index, int role) const {
    if (index.row() < 0 || index.row() >= rowCount()) {
        return QVariant();
    }

    LogConfig *cfg = m_logConfigs.at(index.row()).get();
    switch (role) {
    case NameRole:
        return cfg->name;
    default:
        return QVariant();
    }
}

QHash<int, QByteArray> LogConfigModel::roleNames() const {
    QHash<int, QByteArray> roles;
    roles[NameRole] = "name";
    return roles;
}

bool LogConfigModel::createLogConfig(const QString &name) {
    for (auto &cfg : m_logConfigs) {
        if (cfg->name == name) {
            return false;
        }
    }
    m_logConfigs.push_back(std::make_unique<LogConfig>(name));
    return true;
}

LogConfig *LogConfigModel::getLogConfig(const QString &name) {
    for (auto &cfg : m_logConfigs) {
        if (cfg->name == name) {
            return cfg.get();
        }
    }
    return nullptr;
}

bool LogConfigModel::save(const QString &name, QVariant *config) {
    return true;
}

bool LogConfigModel::setAsDefault(const QString &name) {
    return true;
}






















