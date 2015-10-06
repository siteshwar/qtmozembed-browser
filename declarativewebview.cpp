/****************************************************************************
**
** Copyright (C) 2015 Jolla Ltd.
** Contact: Raine Makelainen <raine.makelainen@jolla.com>
**
****************************************************************************/

/* This Source Code Form is subject to the terms of the Mozilla Public
 * License, v. 2.0. If a copy of the MPL was not distributed with this file,
 * You can obtain one at http://mozilla.org/MPL/2.0/. */

#include "declarativewebview.h"
#include "declarativewebpage.h"

#include <QGuiApplication>
#include <qpa/qplatformnativeinterface.h>
#include <QOpenGLFunctions_ES2>
#include <QScreen>
#include <QTimer>
#include <QTimerEvent>
#include <QThread>

#include <QQmlContext>
#include <QQmlEngine>
#include <QQmlComponent>
#include <qqmlinfo.h>

#include <silicatheme.h>

#define DEFAULT_COMPONENTS_PATH "/usr/lib/mozembedlite/"

DeclarativeWebView::DeclarativeWebView(QWindow *parent)
    : QWindow(parent)
    , m_currentItem(0)
    , m_chromeWindow(0)
    , m_delegate(0)
    , m_context(0)
    , m_completed(false)
{
    setenv("USE_ASYNC", "1", 1);
    setenv("USE_NEMO_GSTREAMER", "1", 1);
    setenv("NO_LIMIT_ONE_GST_DECODER", "1", 1);
    setenv("CUSTOM_UA", "Mozilla/5.0 (Sailfish; U; Jolla; Mobile; rv:31.0) Gecko/31.0 Firefox/31.0 SailfishBrowser/1.0", 1);

    // Workaround for https://bugzilla.mozilla.org/show_bug.cgi?id=929879
    setenv("LC_NUMERIC", "C", 1);
    setlocale(LC_NUMERIC, "C");

    QByteArray binaryPath = QCoreApplication::applicationDirPath().toLocal8Bit();
    setenv("GRE_HOME", binaryPath.constData(), 1);

    QString componentPath(DEFAULT_COMPONENTS_PATH);
    QMozContext::GetInstance()->addComponentManifest(componentPath + QString("/components/EmbedLiteBinComponents.manifest"));
    QMozContext::GetInstance()->addComponentManifest(componentPath + QString("/components/EmbedLiteJSComponents.manifest"));
    QMozContext::GetInstance()->addComponentManifest(componentPath + QString("/chrome/EmbedLiteJSScripts.manifest"));
    QMozContext::GetInstance()->addComponentManifest(componentPath + QString("/chrome/EmbedLiteOverrides.manifest"));

    QSize screenSize = QGuiApplication::primaryScreen()->size();
    QMozContext *context = QMozContext::GetInstance();
    if (screenSize.width() >= 720) {
        context->setPixelRatio(2.0);
    } else {
        context->setPixelRatio(1.5);
    }

    // Resize the window.
    resize(screenSize.width(), screenSize.height());
    setSurfaceType(QWindow::OpenGLSurface);

    QSurfaceFormat format(requestedFormat());
    format.setRedBufferSize(5);
    format.setGreenBufferSize(6);
    format.setBlueBufferSize(5);
    format.setAlphaBufferSize(0);
    setFormat(format);
    // Show first the content window to make it visible.
    showFullScreen();

    connect(context, SIGNAL(onInitialized()), this, SLOT(initialize()));
    QTimer::singleShot(0, QMozContext::GetInstance(), SLOT(runEmbedding()));
}

DeclarativeWebView::~DeclarativeWebView()
{
    // Disconnect all signal slot connections
    if (m_currentItem) {
        disconnect(m_currentItem, 0, 0, 0);
    }
}

QWindow *DeclarativeWebView::chromeWindow() const
{
    return m_chromeWindow;
}

void DeclarativeWebView::setChromeWindow(QWindow *chromeWindow)
{
    if (m_chromeWindow != chromeWindow) {
        m_chromeWindow = chromeWindow;
        if (m_chromeWindow) {
            m_chromeWindow->setTransientParent(this);
            m_chromeWindow->showFullScreen();
            updateContentOrientation(m_chromeWindow->contentOrientation());
            connect(m_chromeWindow, SIGNAL(contentOrientationChanged(Qt::ScreenOrientation)), this, SLOT(updateContentOrientation(Qt::ScreenOrientation)));
        }
        emit chromeWindowChanged();
    }
}

DeclarativeWebPage *DeclarativeWebView::currentItem() const
{
    return m_currentItem;
}

void DeclarativeWebView::setCurrentItem(DeclarativeWebPage *currentItem)
{
    if (m_currentItem != currentItem) {
        // Disconnect previous page.
        if (m_currentItem) {
            m_currentItem->disconnect(this);
        }

        m_currentItem = currentItem;
        if (m_currentItem && m_chromeWindow) {
            updateContentOrientation(m_chromeWindow->contentOrientation());
        }

        emit currentItemChanged();
        emit focusObjectChanged(m_currentItem);
    }
}

QQmlComponent *DeclarativeWebView::delegate() const
{
    return m_delegate;
}

void DeclarativeWebView::setDelegate(QQmlComponent *delegate)
{
    if (m_delegate != delegate) {
        m_delegate = delegate;
        emit delegateChanged();
    }
}

QObject *DeclarativeWebView::focusObject() const
{
    return m_currentItem ? m_currentItem : QWindow::focusObject();
}

void DeclarativeWebView::updateContentOrientation(Qt::ScreenOrientation orientation)
{
    if (m_currentItem) {
        m_currentItem->updateContentOrientation(orientation);
    }

    reportContentOrientationChange(orientation);
}

bool DeclarativeWebView::event(QEvent *event)
{
    QPlatformWindow *windowHandle;
    if (event->type() == QEvent::PlatformSurface
                && static_cast<QPlatformSurfaceEvent *>(event)->surfaceEventType() == QPlatformSurfaceEvent::SurfaceCreated
                && (windowHandle = handle())) {
        QPlatformNativeInterface *native = QGuiApplication::platformNativeInterface();
        native->setWindowProperty(windowHandle, QStringLiteral("BACKGROUND_VISIBLE"), false);
        native->setWindowProperty(windowHandle, QStringLiteral("HAS_CHILD_WINDOWS"), true);
    }
    return QWindow::event(event);
}

void DeclarativeWebView::touchEvent(QTouchEvent *event)
{
    if (m_currentItem) {
        m_currentItem->touchEvent(event);
    }
}

QVariant DeclarativeWebView::inputMethodQuery(Qt::InputMethodQuery property) const
{
    if (m_currentItem) {
        return m_currentItem->inputMethodQuery(property);
    }
    return QVariant();
}

void DeclarativeWebView::inputMethodEvent(QInputMethodEvent *event)
{
    if (m_currentItem) {
        m_currentItem->inputMethodEvent(event);
    }
}

void DeclarativeWebView::keyPressEvent(QKeyEvent *event)
{
    if (m_currentItem) {
        m_currentItem->keyPressEvent(event);
    }
}

void DeclarativeWebView::keyReleaseEvent(QKeyEvent *event)
{
    if (m_currentItem) {
        m_currentItem->keyReleaseEvent(event);
    }
}

void DeclarativeWebView::focusInEvent(QFocusEvent *event)
{
    if (m_currentItem) {
        m_currentItem->focusInEvent(event);
    }
}

void DeclarativeWebView::focusOutEvent(QFocusEvent *event)
{
    if (m_currentItem) {
        m_currentItem->focusOutEvent(event);
    }
}

void DeclarativeWebView::timerEvent(QTimerEvent *event)
{
    if (m_currentItem) {
        m_currentItem->timerEvent(event);
    }
}

// This will be called from gecko compositor thread.
// Initialize QOpenGLContext for the web page.
void DeclarativeWebView::createGLContext()
{
    if (!m_context) {
        m_context = new QOpenGLContext();
        m_context->setFormat(requestedFormat());
        m_context->create();
        m_context->makeCurrent(this);
        initializeOpenGLFunctions();
    } else {
        m_context->makeCurrent(this);
    }
}

void DeclarativeWebView::initialize()
{
    QMozContext *context = QMozContext::GetInstance();

    Silica::Theme *theme = Silica::Theme::instance();

    qreal touchSideRadius = theme->paddingMedium() + theme->paddingLarge();
    qreal touchTopRadius = theme->paddingLarge() * 2;
    qreal touchBottomRadius = theme->paddingMedium() + theme->paddingSmall();

    context->setPref(QStringLiteral("apz.touch_start_tolerance"), QString("0.0555555f"));

    // these are magic numbers defining touch radius required to detect <image src=""> touch
    context->setPref(QStringLiteral("browser.ui.touch.left"), QVariant(touchSideRadius));
    context->setPref(QStringLiteral("browser.ui.touch.right"), QVariant(touchSideRadius));
    context->setPref(QStringLiteral("browser.ui.touch.top"), QVariant(touchTopRadius));
    context->setPref(QStringLiteral("browser.ui.touch.bottom"), QVariant(touchBottomRadius));

    // Don't force 16bit color depth
    context->setPref(QStringLiteral("gfx.qt.rgb16.force"), QVariant(false));

    // Use external Qt window for rendering content
    context->setPref(QStringLiteral("gfx.compositor.external-window"), QVariant(true));
    context->setPref(QStringLiteral("gfx.compositor.clear-context"), QVariant(false));
    context->setPref(QStringLiteral("embedlite.compositor.external_gl_context"), QVariant(true));
    context->setPref(QStringLiteral("embedlite.compositor.request_external_gl_context_early"), QVariant(true));

    // Enable progressive painting.
    context->setPref(QStringLiteral("layers.progressive-paint"), QVariant(true));
    context->setPref(QStringLiteral("layers.low-precision-buffer"), QVariant(true));

    if (context->pixelRatio() >= 2.0) {
        context->setPref(QStringLiteral("layers.tile-width"), QVariant(512));
        context->setPref(QStringLiteral("layers.tile-height"), QVariant(512));
        // Don't use too small low precision buffers for high dpi devices. This reduces
        // a bit the blurriness.
        context->setPref(QStringLiteral("layers.low-precision-resolution"), QString("0.5f"));
    }

    setCurrentItem(createPage());

    emit completedChanged();
    disconnect(m_chromeWindow, SIGNAL(contentOrientationChanged(Qt::ScreenOrientation)), this, SLOT(updateContentOrientation(Qt::ScreenOrientation)));
}

DeclarativeWebPage *DeclarativeWebView::createPage()
{
    if (!m_delegate) {
        qWarning() << "WebView not initialized!";
        return nullptr;
    }

    QQmlContext *creationContext = m_delegate->creationContext();
    QQmlContext *context = new QQmlContext(m_delegate ? creationContext : QQmlEngine::contextForObject(this));
    QObject *object = m_delegate->beginCreate(context);
    if (object) {
        context->setParent(object);
        object->setParent(this);
        DeclarativeWebPage* webPage = qobject_cast<DeclarativeWebPage *>(object);
        if (webPage) {
            connect(webPage, SIGNAL(requestGLContext()), this, SLOT(createGLContext()), Qt::DirectConnection);
            webPage->setWindow(this);
            webPage->initialize();
            m_delegate->completeCreate();
            QQmlEngine::setObjectOwnership(webPage, QQmlEngine::CppOwnership);
            return webPage;
        } else {
            qmlInfo(this) << "delegate component must be a WebPage component";
            m_delegate->completeCreate();
            delete object;
        }
    } else {
        qmlInfo(this) << "Creation of the web page failed. Error: " << m_delegate->errorString();
        delete context;
    }

    return nullptr;
}
