#include <quickmozview.h>

class DeclarativeWebPage : public QuickMozView {
    Q_OBJECT
    public:
        DeclarativeWebPage(QQuickItem *parent = 0);
    public slots:
        void onViewInitialized();
};
