#include "declarativewebpage.h"

DeclarativeWebPage::DeclarativeWebPage(QQuickItem *parent)
    : QuickMozView(parent)
{
    loadFrameScript("chrome://embedlite/content/SelectAsyncHelper.js");
    loadFrameScript("chrome://embedlite/content/embedhelper.js");
}
