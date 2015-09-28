import QtQuick 2.1
import QtQuick.Window 2.1 as QtQuick
import Sailfish.Silica 1.0
import QtMozEmbed.Browser 1.0
import "components"

BrowserApplication {
    id: browserApp

    property alias webView: webView

    backgroundWindow: webView

    WebView {
        id: webView

        property bool active: Qt.application.active
        readonly property bool fullscreenChrome: chrome.height == Screen.height

        width: Screen.width
        height: Screen.height

        delegate: Component {
            WebPage {
                width: Screen.width
                height: Screen.height

                active: enabled
                readyToPaint: enabled
                enabled: webView.visible

                chromeGestureThreshold: Theme.paddingLarge * 2
                chromeGestureEnabled: webView.fullscreenChrome

                onCompletedChanged: {
                    url = "about:blank"
                }
            }
        }
    }

    initialPage: Chrome {
        id: chrome
        anchors.fill: parent
        onWindowChanged: {
            webView.chromeWindow = window ? window : null
        }
    }
}
