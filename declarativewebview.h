/****************************************************************************
**
** Copyright (C) 2015 Jolla Ltd.
** Contact: Raine Makelainen <raine.makelainen@jolla.com>
**
****************************************************************************/

#ifndef DECLARATIVEWEBVIEW_H
#define DECLARATIVEWEBVIEW_H

#include <qmozcontext.h>

#include <QtGui/QWindow>
#include <QtGui/QOpenGLFunctions>
#include <QPointer>
#include <qqml.h>
#include <QQmlComponent>
#include <QMutex>

class DeclarativeWebPage;
class QInputMethodEvent;
class QTimerEvent;

class DeclarativeWebView : public QWindow, protected QOpenGLFunctions {
    Q_OBJECT
    Q_PROPERTY(QWindow *chromeWindow READ chromeWindow WRITE setChromeWindow NOTIFY chromeWindowChanged FINAL)
    Q_PROPERTY(DeclarativeWebPage *currentItem READ currentItem NOTIFY currentItemChanged FINAL)
    Q_PROPERTY(QQmlComponent* delegate READ delegate WRITE setDelegate NOTIFY delegateChanged FINAL)

public:
    DeclarativeWebView(QWindow *parent = 0);
    ~DeclarativeWebView();

    QWindow *chromeWindow() const;
    void setChromeWindow(QWindow *chromeWindow);

    DeclarativeWebPage *currentItem() const;

    QQmlComponent *delegate() const;
    void setDelegate(QQmlComponent *delegate);

    QObject *focusObject() const;

public slots:
    void updateContentOrientation(Qt::ScreenOrientation orientation);

signals:
    void chromeWindowChanged();
    void currentItemChanged();
    void delegateChanged();
    void completedChanged();

protected:
    bool event(QEvent *event);
    void touchEvent(QTouchEvent *event);
    QVariant inputMethodQuery(Qt::InputMethodQuery property) const;
    void inputMethodEvent(QInputMethodEvent *event);
    void keyPressEvent(QKeyEvent *event);
    void keyReleaseEvent(QKeyEvent *event);
    void focusInEvent(QFocusEvent *event);
    void focusOutEvent(QFocusEvent *event);
    void timerEvent(QTimerEvent *event);

private slots:
    void createGLContext();
    void initialize();

private:
    DeclarativeWebPage* createPage();
    void setCurrentItem(DeclarativeWebPage *currentItem);

    QPointer<DeclarativeWebPage> m_currentItem;
    QPointer<QWindow> m_chromeWindow;
    QPointer<QQmlComponent> m_delegate;
    QOpenGLContext *m_context;

    bool m_completed;
};

#endif // DECLARATIVEWEBVIEW_H
