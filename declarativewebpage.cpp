#include "declarativewebpage.h"

DeclarativeWebPage::DeclarativeWebPage(QQuickItem *parent)
    : QuickMozView(parent)
{
    connect(this, SIGNAL(viewInitialized()), this, SLOT(onViewInitialized()));
}

void DeclarativeWebPage::onViewInitialized()
{
    loadFrameScript("chrome://embedlite/content/SelectAsyncHelper.js");
    loadFrameScript("chrome://embedlite/content/embedhelper.js");
    setChrome(true);
    setUrl(QUrl("http://www.google.com/"));
}
