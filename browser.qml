import QtQuick 2.1
import Sailfish.Silica 1.0
import QtMozEmbed.Browser 1.0
import "components"

BrowserWindow {
    id: window

    chrome: Chrome {
        webPage: WebPage {
            width: parent.width
            height: parent.height
            active: true
        }
    }
}
