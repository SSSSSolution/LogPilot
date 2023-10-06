#ifndef LOG_CONFIG_MANAGER_H
#define LOG_CONFIG_MANAGER_H


#include <filesystem>
#include <map>
#include <memory>

#include <QObject>
#include <QQmlEngine>
#include <QAbstractListModel>

#include "WinExport.h"

struct DATA_API LogConfig: public QObject {
    Q_OBJECT
    QML_ELEMENT
public:
    LogConfig(const QString &name);
    ~LogConfig() = default;

    QString name;
    QString path;
    QVariant config;
};

class DATA_API LogConfigModel : public QAbstractListModel {
    Q_OBJECT
    QML_ELEMENT
public:
    enum LogConfigRoles {
        NameRole = Qt::UserRole + 1,
    };
    LogConfigModel(QObject *parent = nullptr);

    virtual int rowCount(const QModelIndex &parent = QModelIndex()) const override;

    virtual QVariant data(const QModelIndex &index, int role = Qt::DisplayRole) const override;

    virtual QHash<int, QByteArray> roleNames() const override;

    Q_INVOKABLE bool createLogConfig(const QString &name);

    Q_INVOKABLE LogConfig *getLogConfig(const QString &name);

    Q_INVOKABLE bool save(const QString &name, QVariant *config);

    Q_INVOKABLE bool setAsDefault(const QString &name);

private:
    void loadBuildInConfig();
    void loadUserConfigs();

private:
    std::vector<std::unique_ptr<LogConfig>> m_logConfigs;
};

#endif
