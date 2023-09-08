#ifndef LOG_MODEL_SORT_FILTER_PROXY_MODEL_H
#define LOG_MODEL_SORT_FILTER_PROXY_MODEL_H

#include <QSortFilterProxyModel>

class LogModelSortFilterProxyModel : public QSortFilterProxyModel {
public:
    virtual bool filterAcceptsRow(int sourceRow, const QModelIndex &sourceParent) const;
};





#endif
