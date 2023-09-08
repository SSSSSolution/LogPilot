#ifndef FPS_ITEM_H
#define FPS_ITEM_H

#include <QQuickItem>

class FpsItem : public QQuickItem {
    Q_OBJECT
    QML_ELEMENT
    Q_PROPERTY(int fps READ fps NOTIFY fpsChanged)

public:
    FpsItem(QQuickItem *parent = nullptr);
    int fps() const;

signals:
    void fpsChanged();

private:
    int m_fps = 0;
    int m_frameCount = 0;
};

#endif
