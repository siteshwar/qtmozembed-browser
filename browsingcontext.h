#ifndef BROWSING_CONTEXT_H
#define BROWSING_CONTEXT_H

#include <QObject>

class BrowsingContext : public QObject {
    Q_OBJECT

public:
    BrowsingContext(QObject *parent = 0);

    Q_INVOKABLE void setPreference(const QString& name, const QVariant& value);
    Q_INVOKABLE void setPixelRatio(float pixelRatio);

signals:
    void completed();
};

#endif // BROWSING_CONTEXT_H
