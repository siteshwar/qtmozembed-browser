#include <QGuiApplication>
#include <QQuickView>
#include <QtQml>

#include <qmozcontext.h>

#include "declarativewebpage.h"
#include "browsingcontext.h"

#define DEFAULT_COMPONENTS_PATH "/usr/lib/mozembedlite/"

static QObject *browsing_context_api_factory(QQmlEngine *, QJSEngine *)
{
    return new BrowsingContext;
}

int main(int argc, char* argv[]) {
    QGuiApplication *app = new QGuiApplication(argc, argv);

    QByteArray binaryPath = QCoreApplication::applicationDirPath().toLocal8Bit();
    setenv("GRE_HOME", binaryPath.constData(), 1);

    qmlRegisterType<DeclarativeWebPage>("QtMozEmbed.Browser", 1, 0, "WebPage");
    qmlRegisterSingletonType<BrowsingContext>("QtMozEmbed.Browser", 1, 0, "BrowsingContext", browsing_context_api_factory);

    QString componentPath(DEFAULT_COMPONENTS_PATH);
    QMozContext::GetInstance()->addComponentManifest(componentPath + QString("/components/EmbedLiteBinComponents.manifest"));
    QMozContext::GetInstance()->addComponentManifest(componentPath + QString("/components/EmbedLiteJSComponents.manifest"));
    QMozContext::GetInstance()->addComponentManifest(componentPath + QString("/chrome/EmbedLiteJSScripts.manifest"));
    QMozContext::GetInstance()->addComponentManifest(componentPath + QString("/chrome/EmbedLiteOverrides.manifest"));

    QQuickView *view = new QQuickView();
    view->setSource(app->applicationDirPath() + QDir::separator() + "browser.qml");
    view->showFullScreen();

    QTimer::singleShot(0, QMozContext::GetInstance(), SLOT(runEmbedding()));

    return app->exec();
}
