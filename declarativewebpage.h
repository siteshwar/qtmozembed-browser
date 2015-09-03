#ifndef DECLARATIVEWEBPAGE_H
#define DECLARATIVEWEBPAGE_H

#include <quickmozview.h>

class DeclarativeWebPage : public QuickMozView {
    Q_OBJECT
    public:
        DeclarativeWebPage(QQuickItem *parent = 0);
};

#endif // DECLARATIVEWEBPAGE_H
