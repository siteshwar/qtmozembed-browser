#ifndef DECLARATIVEWEBPAGE_H
#define DECLARATIVEWEBPAGE_H

#include <qopenglwebpage.h>
#include <qqml.h>


class DeclarativeWebPage : public QOpenGLWebPage {
    Q_OBJECT

public:
    DeclarativeWebPage(QObject *parent = 0);
};

#endif // DECLARATIVEWEBPAGE_H
