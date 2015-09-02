import QtQuick 2.1
import QtMozEmbed.Browser 1.0
import Sailfish.Silica 1.0

ApplicationWindow {
    id: window

    property Component chrome

    Connections {
        target: BrowsingContext
        ignoreUnknownSignals: true
        onCompleted: {
            var pixelRatio = Theme.pixelRatio * 1.5;
            var touchSideRadius = Theme.paddingMedium + Theme.paddingLarge;
            var touchTopRadius = Theme.paddingLarge * 2;
            var touchBottomRadius = Theme.paddingMedium + Theme.paddingSmall;

            BrowsingContext.setPreference("browser.ui.touch.left", touchSideRadius);
            BrowsingContext.setPreference("browser.ui.touch.right", touchSideRadius);
            BrowsingContext.setPreference("browser.ui.touch.top", touchTopRadius);
            BrowsingContext.setPreference("browser.ui.touch.bottom", touchBottomRadius);
            BrowsingContext.setPixelRatio(pixelRatio);
        }
    }

    Component.onCompleted: pageStack.push(window.chrome)
}
