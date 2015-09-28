import QtQuick 2.1
import QtQuick.Window 2.1 as QtQuick
import QtMozEmbed.Browser 1.0
import Sailfish.Silica 1.0

Page {
    id: chrome

    readonly property rect inputMask: inputMaskForOrientation(orientation)
    property bool active: true
    property bool popupActive
    property alias toolbar: toolbar

    signal windowChanged(QtObject window)

    function inputMaskForOrientation(orientation) {
        // mask is in portrait window coordinates
        var mask = Qt.rect(0, 0, Screen.width, Screen.height)
        if (chrome.active && !chrome.popupActive) {
            var visibleHeight = chrome.height - toolbar.y

            switch (orientation) {
            case Orientation.None:
            case Orientation.Portrait:
                mask.y = toolbar.y
                // fallthrough
            case Orientation.PortraitInverted:
                mask.height = visibleHeight
                break

            case Orientation.LandscapeInverted:
                mask.x = toolbar.y
                // fallthrough
            case Orientation.Landscape:
                mask.width = visibleHeight
            }
        }
        return mask
    }

    Item {
        id: toolbar

        width: chrome.width
        height: searchField.height
        y: webView.currentItem && webView.currentItem.chrome ? chrome.height - height : chrome.height

        onWindowChanged: chrome.windowChanged(window)

        Behavior on y {
            enabled: webView.currentItem && webView.currentItem.chromeGestureEnabled
            NumberAnimation { duration: 200 }
        }

        Rectangle {
            color: "black"
            opacity: 0.8
            anchors.top: searchField.top
            width: parent.width
            height: width
        }

        TextField {
            id: searchField
            anchors.bottom: parent.bottom
            width: parent.width
            background: null
            labelVisible: false
            placeholderText: "Enter url"
            textTopMargin: Theme.paddingMedium
            inputMethodHints: Qt.ImhNoAutoUppercase

            EnterKey.onClicked: {
                if (webView.currentItem) {
                    webView.currentItem.load(text)
                    chrome.focus = true
                }
            }
        }
    }

    InputRegion {
        window: webView.chromeWindow
        x: inputMask.x
        y: inputMask.y
        width: inputMask.width
        height: inputMask.height
    }
}

