#include <QGuiApplication>
#include <QQuickView>
#include <QQuickItem>
#include <QtQml>

#include "declarativewebpage.h"
#include "declarativewebview.h"
#include "browsingcontext.h"
#include "inputregion.h"

static QObject *browsing_context_api_factory(QQmlEngine *, QJSEngine *)
{
    return new BrowsingContext;
}

int main(int argc, char* argv[]) {
    QGuiApplication *app = new QGuiApplication(argc, argv);

    // Use QtQuick 2.1 for QtMozEmbed.Browser imports
    qmlRegisterRevision<QQuickItem, 1>("QtMozEmbed.Browser", 1, 0);
    qmlRegisterRevision<QWindow, 1>("QtMozEmbed.Browser", 1, 0);

    qmlRegisterType<DeclarativeWebPage>("QtMozEmbed.Browser", 1, 0, "WebPage");
    qmlRegisterType<DeclarativeWebView>("QtMozEmbed.Browser", 1, 0, "WebView");
    qmlRegisterType<InputRegion>("QtMozEmbed.Browser", 1, 0, "InputRegion");

    qmlRegisterSingletonType<BrowsingContext>("QtMozEmbed.Browser", 1, 0, "BrowsingContext", browsing_context_api_factory);

    QQuickView *view = new QQuickView();
    view->setSource(QUrl("qrc:///browser.qml"));
    return app->exec();
}
